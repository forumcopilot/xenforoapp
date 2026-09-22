import 'package:flutter/material.dart';
import 'package:flutter_bbcode/flutter_bbcode.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_attachment.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import '../widgets/custom_bb_stylesheet.dart';
import '../widgets/link_preview_card.dart';
import '../widgets/video_card.dart';
import '../widgets/full_screen_video_viewer.dart';
import '../widgets/twitter_card.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/post_actions.dart';
import '../widgets/thread_poll_card.dart';
import '../../controllers/post_controller.dart';
import 'package:forumcopilot_sdk/models/entities/fc_poll.dart';
import '../../utils/bbcode_processor.dart';
import '../../utils/url_utils.dart';
import '../../utils/file_utils.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';
import 'post_list_item_header.dart';
import 'post_list_item_attachment.dart';
import 'post_list_item_social.dart';
import 'package:forumcopilot_sdk/models/entities/fc_reaction.dart';
import 'package:forumcopilot_flutter/views/widgets/reaction_picker.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import '../user_profile_page.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../login_page.dart';
import '../post_page.dart';
import '../lists/posts_list.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/gestures.dart' show GestureRecognizer;
import 'package:forumcopilot_flutter/core/cache/lru_cache.dart';
import 'package:forumcopilot_flutter/utils/preview_selection.dart';

/// Everything a post's body needs that is derived from its text and its
/// attachment lists. Immutable, and shared through [_postContentCache].
///
/// Producing one of these is the single most expensive thing a post does:
/// `BBCodeProcessor.processText` (four tag-strip passes with fresh RegExps,
/// normalisation, emoji, a [url] rewrite, plain-URL detection), three more
/// regex sweeps for previews, the inline-attachment substitution, and then
/// two full structural scans to decide whether the result is safe to hand to
/// the BBCode renderer. It used to be recomputed on every build of every
/// visible post — and the thread rebuilt every visible post on every scroll
/// frame until F2. Now it is computed once per input and remembered.
class _PostContentData {
  /// Post text after processing and inline-attachment substitution.
  final String processedText;

  /// [processedText] after `getValidBBCodeText` — what actually gets parsed.
  final String textToRender;

  /// True when the text could not be repaired into structurally valid
  /// BBCode; the body is then shown as plain text instead of being parsed.
  final bool renderAsPlainText;

  final List<String> limitedUrls;
  final List<String> limitedYoutubeUrls;
  final List<String> limitedTwitterUrls;
  final List<FCAttachment> attachments;
  final List<FCAttachment> filteredInlineAttachments;
  _PostContentData({
    required this.processedText,
    required this.textToRender,
    required this.renderAsPlainText,
    required this.limitedUrls,
    required this.limitedYoutubeUrls,
    required this.limitedTwitterUrls,
    required this.attachments,
    required this.filteredInlineAttachments,
  });
}

/// Identifies one [_PostContentData] exactly.
///
/// Equality compares the full original text, so a hit can never serve
/// content for a different edit of the post; the attachment fingerprint
/// covers the two lists the derivation also reads (url / view permission /
/// inline flag per attachment). The hash is cheap: Dart caches a String's
/// hashCode after first use, so repeat lookups do not rescan the text.
class _PostContentKey {
  final String postId;
  final String siteType;
  final String attachmentFingerprint;
  final String text;

  const _PostContentKey(
      this.postId, this.siteType, this.attachmentFingerprint, this.text);

  static String fingerprint(FCPost post) {
    final b = StringBuffer();
    for (final a in post.inlineAttachments) {
      b..write(a.id)..write('|')..write(a.url)..write('|')..write(a.canViewUrl)..write(';');
    }
    b.write('#');
    for (final a in post.attachments) {
      b..write(a.id)..write('|')..write(a.isInline)..write(';');
    }
    return b.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is _PostContentKey &&
      other.postId == postId &&
      other.siteType == siteType &&
      other.attachmentFingerprint == attachmentFingerprint &&
      other.text == text;

  @override
  int get hashCode =>
      Object.hash(postId, siteType, attachmentFingerprint, text.length, text.hashCode);
}

/// Process-wide memo of derived post content, keyed exactly by its inputs.
///
/// Sized for a thread's worth of scroll-back: a page is 20 posts, so 256
/// entries is a dozen pages. Memory is dominated by the processed text,
/// roughly the size of the post itself. A post scrolled off screen and back
/// on (its element disposed and recreated) costs a map lookup, not a
/// reprocess.
final LRUCache<_PostContentKey, _PostContentData> _postContentCache =
    LRUCache<_PostContentKey, _PostContentData>(maxSize: 256);

/// Callback class for post-related actions
class PostActions {
  /// Called when replying to a post
  final Future<void> Function(String postId)? onReply;

  /// Called when quoting a post
  final Future<void> Function(
      String postId, String authorName, String postText)? onQuote;

  /// Called when editing a post
  final Future<void> Function(String postId, String currentText)? onEdit;

  /// Called when deleting a post
  final Future<void> Function(String postId)? onDelete;

  /// Called when reporting a post
  final Future<void> Function(String postId)? onReport;

  /// Called when viewing an image in the post
  final Function(String imageUrl, BuildContext context, String heroTag)?
      onShowImage;

  /// Called when the post needs to be refreshed
  final VoidCallback? onRefresh;

  /// Called when login is required for restricted attachments
  final Function(BuildContext context)? onLoginRequired;

  const PostActions({
    this.onReply,
    this.onQuote,
    this.onEdit,
    this.onDelete,
    this.onReport,
    this.onShowImage,
    this.onRefresh,
    this.onLoginRequired,
  });
}

/// Widget para representar un ítem de la lista de foros
class PostListItem extends StatefulWidget {
  final SiteContext siteContext;
  final FCPost post;
  final String threadId;
  final String? forumId;
  final String topicTitle;
  final String? topicPrefix;
  final PostActions? actions;
  final void Function(String userId, String userName)? onAvatarTap;
  final PostController postController;
  final bool isHighlighted;

  /// Poll for the thread. When non-null and this is the first post, the poll card is shown above the body.
  final FCPoll? poll;

  /// Called after a successful vote to update the thread's poll in state.
  final void Function(FCPoll updatedPoll)? onVoteSuccess;

  /// Optional translated content to display instead of original post content.
  /// When provided, the post will show translated text with a visual indicator.
  final String? translatedContent;

  /// Whether translation is currently in progress for this thread.
  final bool isTranslating;
  // Note: postDateString is not currently used, but if needed, use formatTimeAgo with context
  // String postDateString(BuildContext context) => post.timestamp != null ? formatTimeAgo(post.timestamp!, context) : "";

  const PostListItem({
    super.key,
    required this.siteContext,
    required this.post,
    required this.threadId,
    required this.topicTitle,
    required this.postController,
    this.forumId,
    this.topicPrefix,
    this.actions,
    this.onAvatarTap,
    this.isHighlighted = false,
    this.poll,
    this.onVoteSuccess,
    this.translatedContent,
    this.isTranslating = false,
  });

  @override
  _PostListItemState createState() => _PostListItemState();
}

class _PostListItemState extends State<PostListItem> {
  // Local state for likes
  late bool _isLiked;
  late final PostController _postsController;
  late int _likeCount; // Add local state for like count
  late final PostActionsHandler _postActionsHandler;
  int? _visitorReactionId; // which reaction the viewer currently has (multi-reaction)

  /// Derived content for the current inputs. Resolved in [initState] and
  /// again in [didUpdateWidget] only when an input changes; never in build.
  late _PostContentData _contentData;

  /// The body parsed to spans, once per (content, theme, text scale).
  ///
  /// `BBCodeText` re-parses its data inside its own build(), so every rebuild
  /// of a post already on screen -- each page load, like, poll vote,
  /// translation -- paid the full parse again: measured as the dominant term
  /// of the rebuild frame (thread_rebuild in docs/perf-benchmarking.md). The
  /// spans are kept on the State, not in a process-wide cache, because the
  /// tag callbacks close over this State's context and handlers. Reusing the
  /// same span objects also hands the element tree identical WidgetSpan
  /// children, so embedded images and cards are not rebuilt either.
  List<InlineSpan>? _spans;
  BBStylesheet? _stylesheet;
  bool _spansFailed = false;
  ThemeData? _spansTheme;
  TextScaler? _spansTextScaler;

  /// True from the moment a highlight is cleared until its fade-out ends, so
  /// the AnimatedContainer that animates it stays in the tree that long and
  /// no longer. Every other post renders a plain ColoredBox.
  bool _highlightFading = false;

  @override
  void initState() {
    super.initState();
    _contentData = _resolveContentData();
    _postsController = widget.postController;
    _postActionsHandler =
        PostActionsHandler(_postsController, widget.siteContext);
    // Set the default refresh callback for attachment login prompts
    _postActionsHandler.setDefaultRefreshCallback(widget.actions?.onRefresh);
    _isLiked = widget.post.isLiked;
    _likeCount = widget.post.likesInfo.length;
    _visitorReactionId = _initialVisitorReactionId();
  }

  @override
  void didUpdateWidget(covariant PostListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_contentInputsChanged(oldWidget)) {
      _contentData = _resolveContentData();
      _prepareSpans();
    }
    if (oldWidget.isHighlighted && !widget.isHighlighted) {
      _highlightFading = true;
    }
  }

  /// Runs before the first build and whenever an inherited dependency
  /// changes. Only a theme or text-scale change invalidates the spans -- the
  /// stylesheet bakes in the theme's text style -- so anything else that
  /// trips this (a keyboard inset, say) leaves them alone.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    if (_spans == null ||
        !identical(theme, _spansTheme) ||
        scaler != _spansTextScaler) {
      _prepareSpans();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers(_spans);
    super.dispose();
  }

  /// Builds the stylesheet for this State and parses the body once.
  void _prepareSpans() {
    _disposeRecognizers(_spans);
    _spansTheme = Theme.of(context);
    _spansTextScaler = MediaQuery.textScalerOf(context);
    _stylesheet = _buildStylesheet(context);
    _spansFailed = false;
    if (_contentData.renderAsPlainText) {
      _spans = const <InlineSpan>[];
      return;
    }
    try {
      _spans = parseBBCode(
        _contentData.textToRender,
        stylesheet: _stylesheet,
        onError: (error, stackTrace) {
          debugPrint(
              'BBCode parsing error in post: \n$error\nStackTrace: $stackTrace');
          debugPrint('Post content that caused error:\n${_contentData.textToRender}');
          _spansFailed = true;
        },
      );
    } catch (error, stackTrace) {
      debugPrint('BBCode parsing error in post: \n$error\nStackTrace: $stackTrace');
      _spans = const <InlineSpan>[];
      _spansFailed = true;
    }
  }

  /// flutter_bbcode allocates a TapGestureRecognizer per tappable text span
  /// on every parse and never disposes them. Before this cache they leaked
  /// once per rebuild; now they live as long as the spans and go with them.
  static void _disposeRecognizers(List<InlineSpan>? spans) {
    if (spans == null) return;
    for (final span in spans) {
      span.visitChildren((child) {
        if (child is TextSpan) {
          final GestureRecognizer? r = child.recognizer;
          r?.dispose();
        }
        return true;
      });
    }
  }

  /// True when anything [_extractPostContentData] reads has changed. Deliberately
  /// not `widget.post != oldWidget.post`: FCPost has value equality over every
  /// field, so a like or a reaction would count as a change.
  bool _contentInputsChanged(PostListItem old) {
    if (widget.translatedContent != old.translatedContent) {
      return true;
    }
    if (!identical(widget.siteContext, old.siteContext) &&
        widget.siteContext.siteType != old.siteContext.siteType) {
      return true;
    }
    final p = widget.post, q = old.post;
    if (identical(p, q)) {
      return false;
    }
    return p.id != q.id ||
        p.content != q.content ||
        !listEquals(p.inlineAttachments, q.inlineAttachments) ||
        !listEquals(p.attachments, q.attachments);
  }

  /// Serves [_PostContentData] from [_postContentCache], deriving and storing
  /// it on a miss.
  _PostContentData _resolveContentData() {
    final key = _PostContentKey(
      widget.post.id,
      widget.siteContext.siteType,
      _PostContentKey.fingerprint(widget.post),
      widget.translatedContent ?? widget.post.content,
    );
    final cached = _postContentCache.get(key);
    if (cached != null) return cached;
    final data = _extractPostContentData();
    _postContentCache.put(key, data);
    return data;
  }

  /// Determine the viewer's existing reaction on this post. Prefers the
  /// reactionId on the viewer's own like entry (when the server sent it),
  /// falling back to the default Like when the post is liked but no id is known.
  int? _initialVisitorReactionId() {
    final me = widget.siteContext.currentUsername;
    for (final like in widget.post.likesInfo) {
      if (like.username == me) {
        return like.reactionId ??
            (widget.post.isLiked
                ? (ReactionRegistry.instance.defaultReaction?.id ?? 1)
                : null);
      }
    }
    return widget.post.isLiked
        ? (ReactionRegistry.instance.defaultReaction?.id ?? 1)
        : null;
  }

  /// The viewer's current reaction (for rendering on the react button), or
  /// null to show the default outline heart.
  FCReaction? get _currentReaction =>
      ReactionRegistry.instance.byId(_visitorReactionId);

  /// Checks if a URL is a mention link (link text starts with @ and has no spaces)
  bool _isMentionUrl(String? linkText) {
    if (linkText == null || linkText.isEmpty) return false;
    final trimmed = linkText.trim();
    // Check if it starts with @ and has no spaces
    return trimmed.startsWith('@') && !trimmed.contains(' ');
  }

  _PostContentData _extractPostContentData() {
    // Use translated content if available, otherwise use original
    final originalText = widget.translatedContent ?? widget.post.content;
    String processedText = BBCodeProcessor.processText(originalText,
            siteContext: widget.siteContext)
        .trimRight();
    final urls = <String>{};
    final youtubeUrls = <String>{};
    final twitterUrls = <String>{};
    final inlineTwitterUrls = <String>{};
    final inlineYoutubeUrls = <String>{};

    // First, extract URLs from the original text before processing
    final originalPlainUrls = BBCodeProcessor.findPlainUrls(originalText);
    for (final match in originalPlainUrls) {
      final url = originalText.substring(match.start, match.end);
      if (url.toLowerCase().startsWith('mailto:')) continue;
      if (BBCodeProcessor.isYoutubeUrl(url)) {
        youtubeUrls.add(url);
      } else if (BBCodeProcessor.isTwitterUrl(url)) {
        twitterUrls.add(url);
      } else {
        urls.add(url);
      }
    }

    // Then extract from BBCode tags in processed text
    // Inline YouTube
    final youtubeTagRegex =
        RegExp(r'\[youtube\](.*?)\[/youtube\]', caseSensitive: false);
    for (final match in youtubeTagRegex.allMatches(processedText)) {
      final url = match.group(1)!;
      inlineYoutubeUrls.add(url);
      // Remove from youtubeUrls if it's there (to avoid duplicates)
      youtubeUrls.remove(url);
    }
    // Inline Twitter
    final twitterTagRegex =
        RegExp(r'\[twitter\](.*?)\[/twitter\]', caseSensitive: false);
    for (final match in twitterTagRegex.allMatches(processedText)) {
      final url = match.group(1)!;
      inlineTwitterUrls.add(url);
      // Remove from twitterUrls if it's there (to avoid duplicates)
      twitterUrls.remove(url);
    }
    // [url] tags
    final bbCodeRegex =
        RegExp(r'\[url(?:=([^\]]+))?\](.*?)\[/url\]', caseSensitive: false);
    for (final match in bbCodeRegex.allMatches(processedText)) {
      final url = match.group(1) ?? match.group(2)!;
      final linkText = match.group(2); // The visible text inside [url]...[/url]

      // Skip mention URLs (link text starts with @ and has no spaces)
      if (_isMentionUrl(linkText)) {
        continue;
      }

      if (url.toLowerCase().startsWith('mailto:')) continue;
      if (match.group(1) != null && match.group(1) != match.group(2)) continue;
      if (inlineYoutubeUrls.contains(url) || inlineTwitterUrls.contains(url))
        continue;
      if (BBCodeProcessor.isYoutubeUrl(url)) {
        youtubeUrls.add(url);
      } else if (BBCodeProcessor.isTwitterUrl(url)) {
        twitterUrls.add(url);
      } else {
        urls.add(url);
      }
    }

    // Inline attachments
    final inlineAttachmentResult =
        BBCodeProcessor.replaceInlineAttachmentUrlsAndFilter(
      processedText,
      widget.post.inlineAttachments,
    );
    processedText = inlineAttachmentResult.text;
    final filteredInlineAttachments =
        inlineAttachmentResult.remainingInlineAttachments;
    // One preview per post: a video if there is one, else a tweet, else the
    // first external link. Up to thirty cards used to be built here, each
    // fetching on appearance.
    final preview = PreviewSelection.choose(
        videos: youtubeUrls, tweets: twitterUrls, links: urls);
    final limitedUrls = [if (preview.linkUrl != null) preview.linkUrl!];
    final limitedYoutubeUrls = [if (preview.videoUrl != null) preview.videoUrl!];
    final limitedTwitterUrls = [if (preview.tweetUrl != null) preview.tweetUrl!];
    // Filter out attachments that are already displayed inline
    // The isInline flag is set by the backend to indicate the attachment is embedded inline in the post content
    final nonInlineAttachments = widget.post.attachments.where((att) {
      // Check if attachment has isInline property - now directly accessible from the model
      final isInline = att.isInline ?? false;
      // Return true if NOT inline (i.e., should be shown in attachment list)
      return !isInline;
    }).toList();

    // Decide once whether the result is safe to parse. This used to run inside
    // build() as two further full scans of the text on every frame.
    final processor = BBCodeProcessor();
    final textToRender = processor.getValidBBCodeText(processedText);
    final renderAsPlainText = textToRender == processedText &&
        !processor.isBBCodeStructurallyValid(textToRender);

    return _PostContentData(
      processedText: processedText,
      textToRender: textToRender,
      renderAsPlainText: renderAsPlainText,
      limitedUrls: limitedUrls,
      limitedYoutubeUrls: limitedYoutubeUrls,
      limitedTwitterUrls: limitedTwitterUrls,
      attachments: nonInlineAttachments,
      filteredInlineAttachments: filteredInlineAttachments,
    );
  }

  Widget _buildPostHeader(BuildContext context) {
    return PostListItemHeader(
      siteContext: widget.siteContext,
      post: widget.post,
      onAvatarTap: widget.onAvatarTap,
      onMenuSelected: _onMenuSelected,
      buildPopupMenuItems: _buildPopupMenuItems,
      context: context,
      postActionsHandler: _postActionsHandler,
      onRefresh: widget.actions?.onRefresh,
    );
  }

  /// The stylesheet's tag callbacks close over this State's [context] and
  /// handlers, all of which live as long as the State, so one stylesheet per
  /// State (rebuilt with the spans) is enough.
  BBStylesheet _buildStylesheet(BuildContext context) {
    final callbacks = BBCodeCallbacks(
      onUrlTap: (url) {
        AppLogger.debug('BBCode URL tapped: $url');
        // Check if URL might be a mention link (contains user profile path)
        // This is a fallback in case CustomUrlTag didn't catch it
        final mentionMatch = RegExp(r'@(\w+)').firstMatch(url);
        if (mentionMatch != null) {
          final username = mentionMatch.group(1);
          AppLogger.debug(
              'BBCode URL contains mention pattern, username: $username');
          if (username != null && username.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfilePage(
                  siteContext: widget.siteContext,
                  userName: username,
                ),
              ),
            );
            return;
          }
        }
        final cleanUrl = url.trim().replaceAll('"', '');
        final site = widget.siteContext.site;
        final forumUrl = site.pluginUrl;
        final forumType = widget.siteContext.ConfigData.forumType;
        UrlUtils.handleUrlTapWithForumDetection(
          widget.siteContext,
          cleanUrl,
          context,
          forumUrl: forumUrl,
          forumType: forumType,
          onForumNavigation: (topicId, postId, forumId) {
            Future.microtask(() async {
              if (!mounted) return;
              if (!widget.siteContext.isLoggedIn) {
                if (!Get.isRegistered<LoginController>()) {
                  Get.put(LoginController());
                }
                final loginController = Get.find<LoginController>();
                final loginResult = await loginController
                    .attemptAutomaticLogin(widget.siteContext);
                if (!loginResult.success &&
                    loginResult.hadCredentials &&
                    Get.currentRoute != '/LoginPage') {
                  await Get.to(
                      () => LoginPage(siteContext: widget.siteContext));
                }
                if (!widget.siteContext.isLoggedIn) {
                  AppLogger.debug(
                      'PostListItem: proceeding to thread as guest after login screen');
                }
              }
              if (postId != null) {
                final String effectiveTopicId =
                    topicId.isNotEmpty ? topicId : postId;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostPage(
                      siteContext: widget.siteContext,
                      topicId: effectiveTopicId,
                      title: '',
                      mode: PostsListMode.thread_by_post,
                      anchorPostId: postId,
                      forumId: forumId,
                    ),
                  ),
                );
              } else if (topicId.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostPage(
                      siteContext: widget.siteContext,
                      topicId: topicId,
                      title: '',
                      mode: PostsListMode.normal,
                      forumId: forumId,
                    ),
                  ),
                );
              }
            });
          },
        );
      },
      // Viewable image attachments arrive here with the Hero tag they were
      // rendered with, so the viewer can fly from them like [img] images.
      onAttachmentImageTap: (String url, BuildContext context, String heroTag) {
        widget.actions?.onShowImage?.call(url, context, heroTag);
      },
      onImageTap: (String imageUrl, BuildContext context, String heroTag) {
        if (widget.actions?.onShowImage != null) {
          widget.actions!.onShowImage!(imageUrl, context, heroTag);
        } else {
          AppLogger.debug('No onShowImage action defined');
        }
      },
      onVideoTap: (videoUrl) {
        AppLogger.debug('BBCode Video tapped: $videoUrl');
        UrlUtils.handleUrlTap(videoUrl, context);
      },
      onMentionTap: (username) {
        AppLogger.debug('BBCode Mention tapped: $username');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(
              siteContext: widget.siteContext,
              userName: username,
            ),
          ),
        );
      },
      onUserTap: (username, userId) {
        AppLogger.debug('BBCode User tapped: $username (userId: $userId)');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(
              siteContext: widget.siteContext,
              userId: userId,
              userName: username,
            ),
          ),
        );
      },
      onAttachmentTap: (String url, bool isImage, bool canView) {
        if (canView) {
          if (isImage) {
            if (widget.actions?.onShowImage != null) {
              widget.actions!.onShowImage!(
                  url, context, url.hashCode.toString());
            } else {
              AppLogger.debug('No onShowImage action defined');
            }
          } else if (isVideoFile(url)) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenVideoViewer(videoUrl: url),
              ),
            );
          } else {
            UrlUtils.handleUrlTap(url, context);
          }
        } else {
          AppLogger.debug('BBCode Attachment tapped - login required');
          _postActionsHandler.showPostLoginPrompt(context);
        }
      },
      inlineAttachments: widget.post.inlineAttachments,
      attachments: widget.post.attachments,
    );
    return CustomBBStylesheet(
      siteContext: widget.siteContext,
      callbacks: callbacks,
      context: context,
      contentId: widget.post.id,
    );
  }

  Widget _buildPostContent(BuildContext context, _PostContentData data,
      ColorScheme colorScheme, TextTheme textTheme) {
    // Check if attachments/images are the last items - if so, reduce bottom padding
    // to avoid excessive white space between images and social buttons
    // Attachments and filteredInlineAttachments always come last (after text, videos, links)
    final bool hasAttachments = data.attachments.isNotEmpty ||
        data.filteredInlineAttachments.isNotEmpty;
    // Check if attachments are all images (using same logic as PostListItemAttachment)
    final bool allAttachmentsAreImages = hasAttachments &&
        (data.attachments.isEmpty ||
            data.attachments.every((att) => isImageFile(att.filename))) &&
        (data.filteredInlineAttachments.isEmpty ||
            data.filteredInlineAttachments
                .every((att) => isImageFile(att.filename)));
    // Reduce bottom padding when images are the last items since PostListItemSocial
    // already adds spacingM (12px) before the social buttons
    final double bottomPadding = allAttachmentsAreImages
        ? DesignTokens.spacingM
        : DesignTokens.spacingXL;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          DesignTokens.spacingL, 0.0, DesignTokens.spacingL, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show topic title for the first post (topic starter)
          if (widget.post.postNumber == 1 && widget.topicTitle.isNotEmpty) ...[
            Text(
              widget.topicTitle,
              style: StyleBuilders.titleTextStyle(
                colorScheme: colorScheme,
                textTheme: textTheme,
                fontSize: DesignTokens.fontSizeTopicTitle,
                fontWeight: DesignTokens.fontWeightBold,
              ),
            ),
            // Show prefix badge below the topic title if available
            if (widget.topicPrefix != null &&
                widget.topicPrefix!.isNotEmpty) ...[
              const SizedBox(height: DesignTokens.spacingS),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingS,
                  vertical: DesignTokens.spacingXS / 2,
                ),
                decoration: StyleBuilders.badgeDecoration(
                  colorScheme: colorScheme,
                  backgroundColor: colorScheme.primaryContainer,
                  borderRadius: DesignTokens.radiusXS,
                ),
                child: Text(
                  widget.topicPrefix!,
                  style: StyleBuilders.smallTextStyle(
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: DesignTokens.fontWeightMedium,
                  ),
                ),
              ),
            ],
            const SizedBox(height: DesignTokens.spacingM),
          ],
          // Poll card (first post only): below title/prefix, above body. onVoteSuccess updates
          // the thread's poll in PostController so the UI reflects the new vote without reloading.
          if (widget.post.postNumber == 1 &&
              widget.poll != null &&
              widget.onVoteSuccess != null) ...[
            ThreadPollCard(
              poll: widget.poll!,
              topicId: widget.threadId,
              siteContext: widget.siteContext,
              onVoteSuccess: widget.onVoteSuccess!,
            ),
            const SizedBox(height: DesignTokens.spacingM),
          ],
          // Translation indicator badge - show "Translating..." or "Translated"
          if (widget.isTranslating || widget.translatedContent != null) ...[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingS,
                vertical: DesignTokens.spacingXS / 2,
              ),
              margin: EdgeInsets.only(bottom: DesignTokens.spacingS),
              decoration: BoxDecoration(
                color: widget.isTranslating && widget.translatedContent == null
                    ? colorScheme.secondaryContainer.withOpacity(0.5)
                    : colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isTranslating &&
                      widget.translatedContent == null) ...[
                    SizedBox(
                      width: DesignTokens.iconSizeXS,
                      height: DesignTokens.iconSizeXS,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ] else ...[
                    Icon(
                      Icons.translate_rounded,
                      size: DesignTokens.iconSizeXS,
                      color: colorScheme.primary,
                    ),
                  ],
                  const SizedBox(width: DesignTokens.spacingXS),
                  Text(
                    widget.isTranslating && widget.translatedContent == null
                        ? (AppLocalizations.of(context)?.translating ??
                            'Translating...')
                        : (AppLocalizations.of(context)?.translated ??
                            'Translated'),
                    style: textTheme.labelSmall?.copyWith(
                      color: widget.isTranslating &&
                              widget.translatedContent == null
                          ? colorScheme.secondary
                          : colorScheme.primary,
                      fontWeight: DesignTokens.fontWeightMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
          // The body: spans parsed once in _prepareSpans, rendered the way
          // BBCodeText.build renders them, minus the parse.
          if (data.renderAsPlainText || _spansFailed || _spans == null)
            Text(
              data.processedText,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                height: DesignTokens.lineHeightTight,
              ),
            )
          else
            RichText(
              text: TextSpan(
                children: _spans,
                style: _stylesheet?.defaultTextStyle,
              ),
              textScaler: MediaQuery.textScalerOf(context),
            ),
          if (data.limitedYoutubeUrls.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spacingM),
            StyleBuilders.divider(colorScheme: colorScheme),
            const SizedBox(height: DesignTokens.spacingS),
            ...data.limitedYoutubeUrls.map((url) => VideoCard(url: url)),
          ],
          if (data.limitedTwitterUrls.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spacingM),
            StyleBuilders.divider(colorScheme: colorScheme),
            const SizedBox(height: DesignTokens.spacingS),
            ...data.limitedTwitterUrls.map((url) => TwitterCard(url: url)),
          ],
          if (data.limitedUrls.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spacingM),
            StyleBuilders.divider(colorScheme: colorScheme),
            const SizedBox(height: DesignTokens.spacingS),
            ...data.limitedUrls
                .where((url) =>
                    !BBCodeProcessor.isEmail(url) &&
                    !BBCodeProcessor.isYoutubeUrl(url) &&
                    !BBCodeProcessor.isTwitterUrl(url) &&
                    !UrlUtils.isSameDomain(widget.siteContext, url))
                .map((url) =>
                    LinkPreviewCard(url: url, siteContext: widget.siteContext)),
          ],
          if (data.attachments.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spacingS),
            PostListItemAttachment(
              attachments: data.attachments,
              actions: widget.actions,
              context: context,
              isInline: false,
              title: AppLocalizations.of(context)?.attachments ?? 'Attachments',
            ),
          ],
          if (data.filteredInlineAttachments.isNotEmpty) ...[
            const SizedBox(height: DesignTokens.spacingS),
            PostListItemAttachment(
              attachments: data.filteredInlineAttachments,
              actions: widget.actions,
              context: context,
            ),
          ],
          PostListItemSocial(
            post: widget.post,
            isLiked: _isLiked,
            likeCount: _likeCount,
            currentReaction: _currentReaction,
            isLoggedIn: widget.siteContext.isLoggedIn,
            onLike: _handleLikeAction,
            onShowLikes: _showLikesBottomSheet,
            trailing: (widget.siteContext.isLoggedIn &&
                    (_postsController.threadDataOutput.value?.topic.canReply ??
                        false))
                ? _buildReplyButtonWithMenu(context, colorScheme, textTheme)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomDivider(ColorScheme colorScheme) {
    return StyleBuilders.divider(
      colorScheme: colorScheme,
      opacity: DesignTokens.opacityLow,
      thickness: 2.0,
      height: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final data = _contentData;

    // Determine background color based on highlight state
    // Use a more visible highlight color
    final backgroundColor = widget.isHighlighted
        ? colorScheme.primaryContainer.withOpacity(0.4)
        : colorScheme.surface;

    final body = Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(context),
          _buildPostContent(context, data, colorScheme, textTheme),
          _buildBottomDivider(colorScheme),
        ],
      ),
    );
    // The highlight is a flash one post shows for a few seconds. Only that
    // post -- while lit, and until its fade-out ends -- pays for an
    // AnimatedContainer; the rest of the thread is a ColoredBox.
    if (!widget.isHighlighted && !_highlightFading) {
      return ColoredBox(color: backgroundColor, child: body);
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      color: backgroundColor,
      onEnd: () {
        if (mounted && !widget.isHighlighted && _highlightFading) {
          setState(() => _highlightFading = false);
        }
      },
      child: body,
    );
  }

  Widget _buildReplyButtonWithMenu(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor =
        colorScheme.onSurfaceVariant.withOpacity(isDarkMode ? 0.4 : 0.5);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
              ),
              title: Text(
                AppLocalizations.of(context)?.replyOptions ?? 'Reply Options',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading:
                        Icon(Icons.reply_rounded, color: colorScheme.primary),
                    title: Text(
                      AppLocalizations.of(context)?.reply ?? 'Reply',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _handleReply();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.format_quote_rounded,
                        color: colorScheme.primary),
                    title: Text(
                      AppLocalizations.of(context)?.replyWithQuote ??
                          'Reply with Quote',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _handleQuote();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Icon(
        Icons.reply_rounded,
        color: iconColor,
        size: DesignTokens.iconSizeMedium,
      ),
    );
  }

  // Handles menu item selection for the post header
  void _onMenuSelected(String value) {
    switch (value) {
      case 'edit':
        _handleEdit();
        break;
      case 'delete':
        _handleDelete();
        break;
      case 'report':
        _handleReport();
        break;
      default:
        break;
    }
  }

  // Builds the popup menu items for the post header
  List<PopupMenuEntry<String>> _buildPopupMenuItems(BuildContext context) {
    final items = <PopupMenuEntry<String>>[];
    if (widget.siteContext.isLoggedIn && widget.post.canEdit) {
      items.add(
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit,
                  size: DesignTokens.iconSizeM,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: DesignTokens.spacingM),
              Text(AppLocalizations.of(context)?.edit ?? 'Edit'),
            ],
          ),
        ),
      );
    }
    if (widget.siteContext.isLoggedIn && widget.post.canDelete) {
      items.add(
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete,
                  size: DesignTokens.iconSizeM,
                  color: Theme.of(context).colorScheme.error),
              const SizedBox(width: DesignTokens.spacingM),
              Text(AppLocalizations.of(context)?.delete ?? 'Delete'),
            ],
          ),
        ),
      );
    }
    if (widget.post.canReport) {
      items.add(
        PopupMenuItem<String>(
          value: 'report',
          child: Row(
            children: [
              Icon(Icons.flag,
                  size: DesignTokens.iconSizeM,
                  color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: DesignTokens.spacingM),
              Text(AppLocalizations.of(context)?.report ?? 'Report'),
            ],
          ),
        ),
      );
    }
    return items;
  }

  void _handleQuote() async {
    if (widget.actions?.onQuote != null) {
      AppLogger.debug('Post Quote action: ${widget.post.id}');
      await widget.actions!.onQuote!(
          widget.post.id, widget.post.authorName, widget.post.content);
    }
  }

  void _handleReply() async {
    AppLogger.debug('Post Reply action: ${widget.post.id}');
    if (widget.actions?.onReply != null) {
      await widget.actions!.onReply!(widget.post.id);
    }
  }

  void _handleEdit() async {
    AppLogger.debug('Post Edit action: ${widget.post.id}');
    if (widget.actions?.onEdit != null) {
      await widget.actions!.onEdit!(widget.post.id, widget.post.content);
    }
  }

  void _handleDelete() async {
    AppLogger.debug('Post Delete action: ${widget.post.id}');
    if (widget.actions?.onDelete != null) {
      await widget.actions!.onDelete!(widget.post.id);
    }
  }

  void _handleReport() async {
    AppLogger.debug('Post Report action: ${widget.post.id}');
    if (widget.actions?.onReport != null) {
      await widget.actions!.onReport!(widget.post.id);
    }
  }

  void _showLikesBottomSheet() {
    PostListItemSocial.showLikesBottomSheet(
        context, widget.post, widget.siteContext);
  }

  void _handleLikeAction() async {
    // Multi-reaction path: if the forum exposes a reaction set (newer plugin),
    // tapping opens the chooser. Picking the current reaction toggles it off.
    if (ReactionRegistry.instance.isAvailable) {
      if (!widget.siteContext.isLoggedIn) {
        _postActionsHandler.handleLike(
          context: context,
          siteContext: widget.siteContext,
          post: widget.post,
          onRefresh: widget.actions?.onRefresh ?? () {},
          setIsLiked: (val) => setState(() => _isLiked = val),
          setLikeCount: (val) => setState(() => _likeCount = val),
          isLiked: _isLiked,
        );
        return;
      }
      final selected = await showReactionPicker(
        context,
        currentReactionId: _visitorReactionId,
      );
      if (selected == null) return; // dismissed
      await _postActionsHandler.handleReaction(
        context: context,
        siteContext: widget.siteContext,
        post: widget.post,
        reactionId: selected.id,
        currentReactionId: _visitorReactionId,
        setIsLiked: (val) => setState(() => _isLiked = val),
        setLikeCount: (val) => setState(() => _likeCount = val),
        setVisitorReaction: (val) => setState(() => _visitorReactionId = val),
      );
      return;
    }

    // Legacy single-Like path (older plugin without a reaction set).
    await _postActionsHandler.handleLike(
      context: context,
      siteContext: widget.siteContext,
      post: widget.post,
      onRefresh: widget.actions?.onRefresh ?? () {},
      setIsLiked: (val) => setState(() => _isLiked = val),
      setLikeCount: (val) => setState(() => _likeCount = val),
      isLiked: _isLiked,
    );
  }
}
