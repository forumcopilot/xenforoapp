import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_reaction.dart';
import 'package:forumcopilot_flutter/views/widgets/reaction_picker.dart' show ReactionGlyph;
import 'package:forumcopilot_flutter/views/widgets/reaction_summary.dart';
import 'package:forumcopilot_flutter/views/widgets/reaction_users_sheet.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_conversation_result.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:flutter_bbcode/flutter_bbcode.dart';
import '../../../../utils/bbcode_processor.dart';
import '../../../widgets/custom_bb_stylesheet.dart';
import 'package:forumcopilot_flutter/views/user_profile_page.dart';
import '../../../../utils/time_utils.dart';
import '../../../../utils/url_utils.dart';
import '../../../../utils/accessibility_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../theme/design_tokens.dart';
import '../../../../theme/style_builders.dart';
import '../../../../utils/avatar_cache_utils.dart';
import '../../../listitems/post_list_item_attachment.dart';
import '../../../widgets/full_screen_image_viewer.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import 'package:forumcopilot_flutter/views/post_page.dart';
import 'package:forumcopilot_flutter/views/lists/posts_list.dart';
import '../../../../utils/snackbar_helper.dart';

/// Icon for a conversation message's react button: the viewer's chosen
/// reaction glyph (emoji or custom image) when they've reacted, else the heart.
/// Shared by both message layouts (header + regular item).
Widget buildMessageReactButtonIcon({
  required SiteContext siteContext,
  required FCConversationMessage message,
  required bool isLiked,
  required Color iconColor,
  required ColorScheme colorScheme,
}) {
  FCReaction? viewer;
  if (isLiked) {
    final me = siteContext.currentUsername;
    for (final like in message.likesInfo) {
      if (like.username == me && like.reactionId != null) {
        viewer = ReactionRegistry.instance.byId(like.reactionId);
        break;
      }
    }
  }
  if (viewer != null) {
    return ReactionGlyph(reaction: viewer, size: DesignTokens.iconSizeMedium);
  }
  return Icon(
    Icons.favorite,
    color: isLiked ? colorScheme.error : iconColor,
    size: DesignTokens.iconSizeMedium,
  );
}

class ConversationHeaderItem extends StatelessWidget {
  final SiteContext siteContext;
  final FCConversationMessage message;
  final String subject;
  final List<FCParticipant> participants;
  final VoidCallback? onQuote;
  final VoidCallback? onLike;
  final VoidCallback? onEdit;
  final bool isHighlighted;
  final bool isClosed;

  const ConversationHeaderItem({
    Key? key,
    required this.siteContext,
    required this.message,
    required this.subject,
    required this.participants,
    this.onQuote,
    this.onLike,
    this.onEdit,
    this.isHighlighted = false,
    this.isClosed = false,
  }) : super(key: key);

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

    final processedText = BBCodeProcessor.processText(message.textBody, siteContext: siteContext).trimRight();

    // Filter out attachments that are already displayed inline
    final nonInlineAttachments = message.attachments.where((att) {
      // Check if attachment has isInline property - filter out inline attachments
      final isInline = att.isInline ?? false;
      // Return true if NOT inline (i.e., should be shown in attachment list)
      return !isInline;
    }).toList();

    final callbacks = BBCodeCallbacks(
      onUrlTap: (url) async {
        AppLogger.debug('ConversationHeaderItem: BBCode URL tapped: $url');
        // Links go where they point. An "@word" anywhere in a URL (an email
        // address, a social media handle) used to open a forum profile instead;
        // real mentions arrive as [USER] tags or as links reading "@name".
        final cleanUrl = url.trim().replaceAll('"', '');
        final site = siteContext.site;
        final forumUrl = site.pluginUrl;
        final forumType = siteContext.ConfigData.forumType;
        await UrlUtils.handleUrlTapWithForumDetection(
          siteContext,
          cleanUrl,
          context,
          forumUrl: forumUrl,
          forumType: forumType,
          onForumNavigation: (topicId, postId, forumId) {
            Future.microtask(() async {
              if (!context.mounted) return;
              if (!siteContext.isLoggedIn) {
                if (!Get.isRegistered<LoginController>()) {
                  Get.put(LoginController());
                }
                final loginController = Get.find<LoginController>();
                final loginResult = await loginController.attemptAutomaticLogin(siteContext);
                if (!loginResult.success && loginResult.hadCredentials && Get.currentRoute != '/LoginPage') {
                  await Get.to(() => LoginPage(siteContext: siteContext));
                }
                if (!siteContext.isLoggedIn) {
                  AppLogger.debug('ConversationHeaderItem: proceeding to thread as guest after login screen');
                }
              }
              if (postId != null) {
                final String effectiveTopicId = topicId.isNotEmpty ? topicId : postId;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostPage(
                      siteContext: siteContext,
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
                      siteContext: siteContext,
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
      onMentionTap: (username) {
        AppLogger.debug('ConversationHeaderItem: BBCode Mention tapped: $username');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(
              siteContext: siteContext,
              userName: username,
            ),
          ),
        );
      },
      onUserTap: (username, userId) {
        AppLogger.debug('ConversationHeaderItem: BBCode User tapped: $username (userId: $userId)');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(
              siteContext: siteContext,
              userId: userId,
              userName: username,
            ),
          ),
        );
      },
      // An inline [IMG] picture (tapping it used to do nothing).
      onImageTap: (url, _, heroTag) => _buildAttachmentActions(context).onShowImage(url, context, heroTag),
      inlineAttachments: message.attachments,
      attachments: message.attachments,
    );
    final stylesheet = CustomBBStylesheet(
      siteContext: siteContext,
      callbacks: callbacks,
      context: context,
      contentId: message.messageId,
    );

    return Material(
      color: isHighlighted ? colorScheme.primaryContainer.withValues(alpha: 0.3) : (message.isUnread == true ? colorScheme.primaryContainer.withValues(alpha: 0.1) : colorScheme.surface),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with avatar, username, and timestamp
            Padding(
              padding: EdgeInsets.all(DesignTokens.spacingL),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar. No online dot: the dot was green for your own messages and
                  // grey for everyone else's, whoever was online.
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfilePage(
                            siteContext: siteContext,
                            userId: message.userId,
                            userName: message.username,
                            profilePictureUrl: message.iconUrl,
                          ),
                        ),
                      );
                    },
                    child: UserAvatar(
                      username: message.username,
                      iconUrl: message.iconUrl,
                      radius: DesignTokens.avatarRadiusM,
                      cacheKey: message.iconUrl != null && message.iconUrl!.isNotEmpty
                          ? AvatarCacheUtils.generateAvatarCacheKey(
                              userId: message.userId,
                              username: message.username,
                              avatarUrl: message.iconUrl!,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: DesignTokens.spacingL),
                  // Author Info and Post Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfilePage(
                                  siteContext: siteContext,
                                  userId: message.userId,
                                  userName: message.username,
                                  profilePictureUrl: message.iconUrl,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            message.username,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: DesignTokens.fontWeightMedium,
                              letterSpacing: DesignTokens.letterSpacingMedium,
                            ),
                          ),
                        ),
                        SizedBox(height: DesignTokens.spacingXS),
                        Row(
                          children: [
                            if (message.messageNumber != null) ...[
                              Text(
                                '#${message.messageNumber}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  letterSpacing: DesignTokens.letterSpacingWide,
                                ),
                              ),
                              SizedBox(width: DesignTokens.spacingS),
                            ],
                            Text(
                              formatSmartDateTime(parseTimestampString(message.messageTime) ?? DateTime.now(), context),
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                letterSpacing: DesignTokens.letterSpacingWide,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Menu Button
                  if (_buildPopupMenuItems(context).isNotEmpty)
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            if (onEdit != null) onEdit!();
                            break;
                        }
                      },
                      itemBuilder: (context) => _buildPopupMenuItems(context),
                    ),
                ],
              ),
            ),
            // Message content
            Padding(
              padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, 0.0, DesignTokens.spacingL, DesignTokens.spacingXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      final processor = BBCodeProcessor();
                      String textToRender = processor.getValidBBCodeText(processedText);
                      if (textToRender == processedText && !processor.isBBCodeStructurallyValid(textToRender)) {
                        return Text(
                          processedText,
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
                        debugPrint('BBCode parsing error in conversation: \n$error\nStackTrace: $stackTrace');
                        debugPrint('Conversation content that caused error:\n$textToRender');
                        return Text(
                          processedText,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            height: DesignTokens.lineHeightTight,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            // Attachments - filter out attachments that are already displayed inline
            if (nonInlineAttachments.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, 0.0, DesignTokens.spacingL, DesignTokens.spacingM),
                child: PostListItemAttachment(
                  attachments: nonInlineAttachments,
                  actions: _buildAttachmentActions(context),
                  context: context,
                  isInline: false,
                  title: AppLocalizations.of(context).attachments,
                ),
              ),
            ],
            // Social actions (like and quote buttons)
            SizedBox(height: DesignTokens.spacingM),
            _buildSocialActions(context, colorScheme, textTheme),
            // Bottom divider
            _buildBottomDivider(colorScheme),
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildPopupMenuItems(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = <PopupMenuEntry<String>>[];
    
    // Edit button (only for XenForo and if canEdit is true)
    if ((message.canEdit ?? false) && siteContext.siteType == 'xenforo' && onEdit != null) {
      items.add(
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: DesignTokens.iconSizeM,
                color: colorScheme.primary,
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Text(AppLocalizations.of(context).edit),
            ],
          ),
        ),
      );
    }
    
    // No Report: reporting a conversation message isn't implemented (the
    // menu item did nothing).
    
    return items;
  }

  /// Who reacted, in the sheet ported from the Discourse app.
  void _showReactors(BuildContext context) {
    ReactionUsersSheet.show(
      context: context,
      siteContext: siteContext,
      likes: message.likesInfo,
      count: message.likeCount,
      onReact: (message.canLike && ReactionRegistry.instance.isAvailable)
          ? onLike
          : null,
    );
  }

  Widget _buildSocialActions(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    // Get like data from message model
    final bool canLike = message.canLike;
    final bool isLiked = message.isLiked;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = colorScheme.onSurfaceVariant.withValues(alpha: isDarkMode ? 0.4 : 0.5);
    final likeCount = message.likesInfo.length;
    final showSummary = reactionTotal(message.likesInfo, message.likeCount) > 0;

    return Padding(
      padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, 0.0, DesignTokens.spacingL, DesignTokens.spacingL),
      child: Row(
        children: [
          // Quote button - only show if conversation is not closed
          if (!isClosed)
            AccessibilityHelpers.accessibleIconButton(
              icon: Icon(
                Icons.format_quote_rounded,
                color: iconColor,
                size: DesignTokens.iconSizeMedium,
              ),
              onTap: onQuote,
              label: AccessibilityHelpers.getQuoteButtonLabel(context),
              context: context,
            ),
          // Reactions, as in the Discourse app: the summary (the emoji
          // people used and how many; a tap lists who) packed against the
          // react button it counts for.
          if (showSummary) ...[
            if (!isClosed) SizedBox(width: DesignTokens.spacingXL),
            ReactionSummary(
              likes: message.likesInfo,
              count: message.likeCount,
              besideReactButton: canLike,
              onTap: message.likesInfo.isNotEmpty
                  ? () => _showReactors(context)
                  : null,
            ),
          ],
          if (canLike) ...[
            if (!isClosed && !showSummary) SizedBox(width: DesignTokens.spacingXL),
            AccessibilityHelpers.accessibleIconButton(
              icon: buildMessageReactButtonIcon(
                siteContext: siteContext,
                message: message,
                isLiked: isLiked,
                iconColor: iconColor,
                colorScheme: colorScheme,
              ),
              onTap: onLike,
              label: AccessibilityHelpers.getLikeButtonLabel(context, isLiked, likeCount > 0 ? likeCount : null),
              isSelected: isLiked,
              context: context,
            ),
          ],
        ],
      ),
    );
  }

  /// Build attachment actions for conversation messages
  dynamic _buildAttachmentActions(BuildContext context) {
    return _ConversationAttachmentActions(
      message: message,
      context: context,
      siteContext: siteContext,
    );
  }
}

/// Attachment actions for conversation messages
class _ConversationAttachmentActions {
  final FCConversationMessage message;
  final BuildContext context;
  final SiteContext siteContext;

  _ConversationAttachmentActions({
    required this.message,
    required this.context,
    required this.siteContext,
  });

  void onShowImage(String imageUrl, BuildContext context, String heroTag) {
    // Collect all image attachments from this message
    final List<String> allImageUrls = [];
    int tappedIndex = 0;
    int currentIndex = 0;
    bool found = false;

    for (var att in message.attachments) {
      final isImage = att.isImage || (att.contentType?.startsWith('image/') ?? false);
      final hasUrl = att.url.isNotEmpty || (att.thumbnailUrl?.isNotEmpty ?? false);
      if (isImage && hasUrl) {
        // Use full URL if available, otherwise use thumbnail
        final urlToUse = att.url.isNotEmpty ? att.url : (att.thumbnailUrl ?? '');
        allImageUrls.add(urlToUse);
        if (urlToUse == imageUrl || att.url == imageUrl || att.thumbnailUrl == imageUrl) {
          tappedIndex = currentIndex;
          found = true;
        }
        currentIndex++;
      }
    }

    // A picture that isn't one of the attachments (an inline [IMG]) is shown
    // on its own, not the first attachment in its place.
    if (!found && imageUrl.isNotEmpty) {
      allImageUrls
        ..clear()
        ..add(imageUrl);
      tappedIndex = 0;
    }

    if (allImageUrls.isEmpty) {
      SnackbarHelper.showInfo(context, AppLocalizations.of(context).noImagesToDisplay);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          imageUrls: allImageUrls,
          initialIndex: tappedIndex,
          // The tapped widget's own Hero tag; see image_actions.dart.
          heroTag: heroTag,
        ),
      ),
    );
  }

  void onLoginRequired(BuildContext context) {
    SnackbarHelper.showError(context, AppLocalizations.of(context).pleaseLoginToViewAttachment);
  }
}

class ConversationItem extends StatelessWidget {
  final SiteContext siteContext;
  final FCConversationMessage message;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onQuote;
  final VoidCallback? onLike;
  final VoidCallback? onEdit;
  final bool isHighlighted;
  final bool isClosed;

  const ConversationItem({
    Key? key,
    required this.siteContext,
    required this.message,
    this.isFirst = false,
    this.isLast = false,
    this.onQuote,
    this.onLike,
    this.onEdit,
    this.isHighlighted = false,
    this.isClosed = false,
  }) : super(key: key);

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

    final processedText = BBCodeProcessor.processText(message.textBody, siteContext: siteContext).trimRight();

    // Filter out attachments that are already displayed inline
    final nonInlineAttachments = message.attachments.where((att) {
      // Check if attachment has isInline property - filter out inline attachments
      final isInline = att.isInline ?? false;
      // Return true if NOT inline (i.e., should be shown in attachment list)
      return !isInline;
    }).toList();

    final callbacks = BBCodeCallbacks(
      onUrlTap: (url) async {
        AppLogger.debug('ConversationItem: BBCode URL tapped: $url');
        // Links go where they point. An "@word" anywhere in a URL (an email
        // address, a social media handle) used to open a forum profile instead;
        // real mentions arrive as [USER] tags or as links reading "@name".
        final cleanUrl = url.trim().replaceAll('"', '');
        final site = siteContext.site;
        final forumUrl = site.pluginUrl;
        final forumType = siteContext.ConfigData.forumType;
        await UrlUtils.handleUrlTapWithForumDetection(
          siteContext,
          cleanUrl,
          context,
          forumUrl: forumUrl,
          forumType: forumType,
          onForumNavigation: (topicId, postId, forumId) {
            Future.microtask(() async {
              if (!context.mounted) return;
              if (!siteContext.isLoggedIn) {
                if (!Get.isRegistered<LoginController>()) {
                  Get.put(LoginController());
                }
                final loginController = Get.find<LoginController>();
                final loginResult = await loginController.attemptAutomaticLogin(siteContext);
                if (!loginResult.success && loginResult.hadCredentials && Get.currentRoute != '/LoginPage') {
                  await Get.to(() => LoginPage(siteContext: siteContext));
                }
                if (!siteContext.isLoggedIn) {
                  AppLogger.debug('ConversationItem: proceeding to thread as guest after login screen');
                }
              }
              if (postId != null) {
                final String effectiveTopicId = topicId.isNotEmpty ? topicId : postId;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostPage(
                      siteContext: siteContext,
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
                      siteContext: siteContext,
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
      onMentionTap: (username) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(
              siteContext: siteContext,
              userName: username,
            ),
          ),
        );
      },
      onUserTap: (username, userId) {
        AppLogger.debug('ConversationItem: BBCode User tapped: $username (userId: $userId)');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfilePage(
              siteContext: siteContext,
              userId: userId,
              userName: username,
            ),
          ),
        );
      },
      // An inline [IMG] picture (tapping it used to do nothing).
      onImageTap: (url, _, heroTag) => _buildAttachmentActions(context).onShowImage(url, context, heroTag),
      inlineAttachments: message.attachments,
      attachments: message.attachments,
    );

    final stylesheet = CustomBBStylesheet(
      siteContext: siteContext,
      callbacks: callbacks,
      context: context,
      contentId: message.messageId,
    );

    return Material(
      color: isHighlighted ? colorScheme.primaryContainer.withValues(alpha: 0.3) : (message.isUnread == true ? colorScheme.primaryContainer.withValues(alpha: 0.1) : colorScheme.surface),
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with avatar, username, and timestamp
            Padding(
              padding: EdgeInsets.all(DesignTokens.spacingL),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar. No online dot: the dot was green for your own messages and
                  // grey for everyone else's, whoever was online.
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfilePage(
                            siteContext: siteContext,
                            userId: message.userId,
                            userName: message.username,
                            profilePictureUrl: message.iconUrl,
                          ),
                        ),
                      );
                    },
                    child: UserAvatar(
                      username: message.username,
                      iconUrl: message.iconUrl,
                      radius: DesignTokens.avatarRadiusM,
                      cacheKey: message.iconUrl != null && message.iconUrl!.isNotEmpty
                          ? AvatarCacheUtils.generateAvatarCacheKey(
                              userId: message.userId,
                              username: message.username,
                              avatarUrl: message.iconUrl!,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: DesignTokens.spacingL),
                  // Author Info and Post Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfilePage(
                                  siteContext: siteContext,
                                  userId: message.userId,
                                  userName: message.username,
                                  profilePictureUrl: message.iconUrl,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            message.username,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: DesignTokens.fontWeightMedium,
                              letterSpacing: DesignTokens.letterSpacingMedium,
                            ),
                          ),
                        ),
                        SizedBox(height: DesignTokens.spacingXS),
                        Row(
                          children: [
                            if (message.messageNumber != null) ...[
                              Text(
                                '#${message.messageNumber}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  letterSpacing: DesignTokens.letterSpacingWide,
                                ),
                              ),
                              SizedBox(width: DesignTokens.spacingS),
                            ],
                            Text(
                              formatSmartDateTime(parseTimestampString(message.messageTime) ?? DateTime.now(), context),
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                letterSpacing: DesignTokens.letterSpacingWide,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Menu Button
                  if (_buildPopupMenuItems(context).isNotEmpty)
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            if (onEdit != null) onEdit!();
                            break;
                        }
                      },
                      itemBuilder: (context) => _buildPopupMenuItems(context),
                    ),
                ],
              ),
            ),
            // Message content
            Padding(
              padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, 0.0, DesignTokens.spacingL, DesignTokens.spacingXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      final processor = BBCodeProcessor();
                      String textToRender = processor.getValidBBCodeText(processedText);
                      if (textToRender == processedText && !processor.isBBCodeStructurallyValid(textToRender)) {
                        return Text(
                          processedText,
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
                        debugPrint('BBCode parsing error in conversation: \n$error\nStackTrace: $stackTrace');
                        debugPrint('Conversation content that caused error:\n$textToRender');
                        return Text(
                          processedText,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            height: DesignTokens.lineHeightTight,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            // Attachments - filter out attachments that are already displayed inline
            if (nonInlineAttachments.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, 0.0, DesignTokens.spacingL, DesignTokens.spacingM),
                child: PostListItemAttachment(
                  attachments: nonInlineAttachments,
                  actions: _buildAttachmentActions(context),
                  context: context,
                  isInline: false,
                  title: AppLocalizations.of(context).attachments,
                ),
              ),
            ],
            // Social actions (like and quote buttons)
            SizedBox(height: DesignTokens.spacingM),
            _buildSocialActions(context, colorScheme, textTheme),
            // Bottom divider
            _buildBottomDivider(colorScheme),
          ],
        ),
      ),
    );
  }

  /// Build attachment actions for conversation messages
  dynamic _buildAttachmentActions(BuildContext context) {
    return _ConversationAttachmentActions(
      message: message,
      context: context,
      siteContext: siteContext,
    );
  }

  List<PopupMenuEntry<String>> _buildPopupMenuItems(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = <PopupMenuEntry<String>>[];
    
    // Edit button (only for XenForo and if canEdit is true)
    if ((message.canEdit ?? false) && siteContext.siteType == 'xenforo' && onEdit != null) {
      items.add(
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: DesignTokens.iconSizeM,
                color: colorScheme.primary,
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Text(AppLocalizations.of(context).edit),
            ],
          ),
        ),
      );
    }
    
    // No Report: reporting a conversation message isn't implemented (the
    // menu item did nothing).
    
    return items;
  }

  /// Who reacted, in the sheet ported from the Discourse app.
  void _showReactors(BuildContext context) {
    ReactionUsersSheet.show(
      context: context,
      siteContext: siteContext,
      likes: message.likesInfo,
      count: message.likeCount,
      onReact: (message.canLike && ReactionRegistry.instance.isAvailable)
          ? onLike
          : null,
    );
  }

  Widget _buildSocialActions(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    // Get like data from message model
    final bool canLike = message.canLike;
    final bool isLiked = message.isLiked;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = colorScheme.onSurfaceVariant.withValues(alpha: isDarkMode ? 0.4 : 0.5);
    final likeCount = message.likesInfo.length;
    final showSummary = reactionTotal(message.likesInfo, message.likeCount) > 0;

    return Padding(
      padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, 0.0, DesignTokens.spacingL, DesignTokens.spacingL),
      child: Row(
        children: [
          // Quote button - only show if conversation is not closed
          if (!isClosed)
            AccessibilityHelpers.accessibleIconButton(
              icon: Icon(
                Icons.format_quote_rounded,
                color: iconColor,
                size: DesignTokens.iconSizeMedium,
              ),
              onTap: onQuote,
              label: AccessibilityHelpers.getQuoteButtonLabel(context),
              context: context,
            ),
          // Reactions, as in the Discourse app: the summary (the emoji
          // people used and how many; a tap lists who) packed against the
          // react button it counts for.
          if (showSummary) ...[
            if (!isClosed) SizedBox(width: DesignTokens.spacingXL),
            ReactionSummary(
              likes: message.likesInfo,
              count: message.likeCount,
              besideReactButton: canLike,
              onTap: message.likesInfo.isNotEmpty
                  ? () => _showReactors(context)
                  : null,
            ),
          ],
          if (canLike) ...[
            if (!isClosed && !showSummary) SizedBox(width: DesignTokens.spacingXL),
            AccessibilityHelpers.accessibleIconButton(
              icon: buildMessageReactButtonIcon(
                siteContext: siteContext,
                message: message,
                isLiked: isLiked,
                iconColor: iconColor,
                colorScheme: colorScheme,
              ),
              onTap: onLike,
              label: AccessibilityHelpers.getLikeButtonLabel(context, isLiked, likeCount > 0 ? likeCount : null),
              isSelected: isLiked,
              context: context,
            ),
          ],
        ],
      ),
    );
  }
}
