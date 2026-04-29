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
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import '../user_profile_page.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../login_page.dart';
import '../post_page.dart';
import '../lists/posts_list.dart';

class _PostContentData {
  final String processedText;
  final List<String> limitedUrls;
  final List<String> limitedYoutubeUrls;
  final List<String> limitedTwitterUrls;
  final List<FCAttachment> attachments;
  final List<FCAttachment> filteredInlineAttachments;
  _PostContentData({
    required this.processedText,
    required this.limitedUrls,
    required this.limitedYoutubeUrls,
    required this.limitedTwitterUrls,
    required this.attachments,
    required this.filteredInlineAttachments,
  });
}

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
  // Local state for like and thanks
  late bool _isLiked;
  bool _isThanked = false;
  late final PostController _postsController;
  late int _likeCount; // Add local state for like count
  late final PostActionsHandler _postActionsHandler;

  @override
  void initState() {
    super.initState();
    _postsController = widget.postController;
    _postActionsHandler =
        PostActionsHandler(_postsController, widget.siteContext);
    // Set the default refresh callback for attachment login prompts
    _postActionsHandler.setDefaultRefreshCallback(widget.actions?.onRefresh);
    _isLiked = widget.post.isLiked;
    _likeCount = widget.post.likesInfo.length;
  }

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
        AppLogger.debug(
            'PostListItem: Skipping mention URL from preview: url=$url, linkText=$linkText');
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
    // Limit
    final limitedUrls = urls.take(10).toList();
    final limitedYoutubeUrls = youtubeUrls.take(10).toList();
    final limitedTwitterUrls = twitterUrls.take(10).toList();
    // Filter out attachments that are already displayed inline
    // The isInline flag is set by the backend to indicate the attachment is embedded inline in the post content
    final nonInlineAttachments = widget.post.attachments.where((att) {
      // Check if attachment has isInline property - now directly accessible from the model
      final isInline = att.isInline ?? false;
      // Return true if NOT inline (i.e., should be shown in attachment list)
      return !isInline;
    }).toList();

    return _PostContentData(
      processedText: processedText,
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

  Widget _buildPostContent(BuildContext context, _PostContentData data,
      ColorScheme colorScheme, TextTheme textTheme) {
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
    final stylesheet = CustomBBStylesheet(
      siteContext: widget.siteContext,
      callbacks: callbacks,
      context: context,
    );
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
          Builder(
            builder: (context) {
              final processor = BBCodeProcessor();
              String textToRender =
                  processor.getValidBBCodeText(data.processedText);
              if (textToRender == data.processedText &&
                  !processor.isBBCodeStructurallyValid(textToRender)) {
                return Text(
                  data.processedText,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    height: DesignTokens.lineHeightTight,
                  ),
                );
              }
              try {
                return BBCodeText(
                  data: textToRender,
                  stylesheet: stylesheet,
                );
              } catch (error, stackTrace) {
                debugPrint(
                    'BBCode parsing error in post: \n$error\nStackTrace: $stackTrace');
                debugPrint('Post content that caused error:\n$textToRender');
                // If BBCode parsing fails, display as plain text instead of rich text
                return Text(
                  data.processedText,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    height: DesignTokens.lineHeightTight,
                  ),
                );
              }
            },
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
            isThanked: _isThanked,
            likeCount: _likeCount,
            isLoggedIn: widget.siteContext.isLoggedIn,
            onLike: _handleLikeAction,
            onThank: _handleThankAction,
            onShowLikes: _showLikesBottomSheet,
            onShowThanks: _showThanksBottomSheet,
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
    final data = _extractPostContentData();

    // Determine background color based on highlight state
    // Use a more visible highlight color
    final backgroundColor = widget.isHighlighted
        ? colorScheme.primaryContainer.withOpacity(0.4)
        : colorScheme.surface;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      color: backgroundColor,
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(context),
            _buildPostContent(context, data, colorScheme, textTheme),
            _buildBottomDivider(colorScheme),
          ],
        ),
      ),
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

  void _showThanksBottomSheet() {
    PostListItemSocial.showThanksBottomSheet(
        context, widget.post, widget.siteContext);
  }

  void _handleLikeAction() async {
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

  void _handleThankAction() async {
    await _postActionsHandler.handleThank(
      context: context,
      siteContext: widget.siteContext,
      post: widget.post,
      onRefresh: widget.actions?.onRefresh ?? () {},
      setIsThanked: (val) => setState(() => _isThanked = val),
      isThanked: _isThanked,
    );
  }
}
