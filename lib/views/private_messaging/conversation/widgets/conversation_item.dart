import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_reaction.dart';
import 'package:forumcopilot_flutter/views/widgets/reaction_picker.dart' show ReactionGlyph;
import 'package:forumcopilot_sdk/models/results/fc_private_conversation_result.dart';
import 'package:forumcopilot_sdk/models/entities/fc_like.dart';
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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import 'package:forumcopilot_flutter/views/post_page.dart';
import 'package:forumcopilot_flutter/views/lists/posts_list.dart';

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
  final VoidCallback? onShowLikes;
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
    this.onShowLikes,
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

    final processedText = BBCodeProcessor.processText(message.textBody ?? '', siteContext: siteContext).trimRight();

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
        // Check if URL might be a mention link (contains @username pattern)
        final mentionMatch = RegExp(r'@(\w+)').firstMatch(url);
        if (mentionMatch != null) {
          final username = mentionMatch.group(1);
          AppLogger.debug('ConversationHeaderItem: URL contains mention pattern, username: $username');
          if (username != null && username.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfilePage(
                  siteContext: siteContext,
                  userName: username,
                ),
              ),
            );
            return;
          }
        }
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
      inlineAttachments: message.attachments,
      attachments: message.attachments,
    );
    final stylesheet = CustomBBStylesheet(
      siteContext: siteContext,
      callbacks: callbacks,
      context: context,
    );

    return Material(
      color: isHighlighted ? colorScheme.primaryContainer.withOpacity(0.3) : (message.isUnread == true ? colorScheme.primaryContainer.withOpacity(0.1) : colorScheme.surface),
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
                  // Avatar with Online Status Dot
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserProfilePage(
                                siteContext: siteContext,
                                userId: message.userId ?? '',
                                userName: message.username ?? 'Unknown',
                                profilePictureUrl: message.iconUrl,
                              ),
                            ),
                          );
                        },
                        child: UserAvatar(
                          username: message.username ?? 'Unknown',
                          iconUrl: message.iconUrl,
                          radius: DesignTokens.avatarRadiusM,
                          cacheKey: message.iconUrl != null && message.iconUrl!.isNotEmpty
                              ? AvatarCacheUtils.generateAvatarCacheKey(
                                  userId: message.userId ?? '',
                                  username: message.username ?? 'Unknown',
                                  avatarUrl: message.iconUrl!,
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: DesignTokens.statusDotSize,
                          height: DesignTokens.statusDotSize,
                          decoration: BoxDecoration(
                            color: message.isFromCurrentUser == true ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.surface,
                              width: DesignTokens.borderWidthThinMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                                  userId: message.userId ?? '',
                                  userName: message.username ?? 'Unknown',
                                  profilePictureUrl: message.iconUrl,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            message.username ?? 'Unknown',
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
                          case 'report':
                            // TODO: Implement report functionality if needed
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
                  title: 'Attachments',
                ),
              ),
            ],
            // Like avatars card (if there are likes)
            if (message.likeCount > 0) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, DesignTokens.spacingXL, DesignTokens.spacingL, 0.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final likeText = message.likeCount == 1 ? '1 Like' : '${message.likeCount} Likes';
                    final textTheme = Theme.of(context).textTheme;

                    return GestureDetector(
                      onTap: () => onShowLikes?.call(),
                      child: Container(
                        margin: EdgeInsets.only(top: DesignTokens.spacingS),
                        padding: DesignTokens.paddingS,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityLow),
                            width: DesignTokens.borderWidthThin,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              likeText,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: DesignTokens.lineHeightTight,
                              ),
                            ),
                            SizedBox(width: DesignTokens.spacingS),
                            Flexible(
                              child: LayoutBuilder(
                                builder: (context, avatarConstraints) {
                                  return _buildLikesAvatars(
                                    context,
                                    message.likesInfo,
                                    message.likeCount,
                                    () => onShowLikes?.call(),
                                    colorScheme,
                                    avatarConstraints.maxWidth,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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

  List<PopupMenuEntry<String>> _buildPopupMenuItemsHeader(BuildContext context) {
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
              Text(AppLocalizations.of(context)?.edit ?? 'Edit'),
            ],
          ),
        ),
      );
    }
    
    // Report button (if canReport is true)
    if (message.canReport == true) {
      items.add(
        PopupMenuItem<String>(
          value: 'report',
          child: Row(
            children: [
              Icon(
                Icons.flag_outlined,
                size: DesignTokens.iconSizeM,
                color: colorScheme.secondary,
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Text(AppLocalizations.of(context)?.report ?? 'Report'),
            ],
          ),
        ),
      );
    }
    
    return items;
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
              Text(AppLocalizations.of(context)?.edit ?? 'Edit'),
            ],
          ),
        ),
      );
    }
    
    // Report button (if canReport is true)
    if (message.canReport == true) {
      items.add(
        PopupMenuItem<String>(
          value: 'report',
          child: Row(
            children: [
              Icon(
                Icons.flag_outlined,
                size: DesignTokens.iconSizeM,
                color: colorScheme.secondary,
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Text(AppLocalizations.of(context)?.report ?? 'Report'),
            ],
          ),
        ),
      );
    }
    
    return items;
  }

  Widget _buildSocialActions(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    // Get like data from message model
    final bool canLike = message.canLike;
    final bool isLiked = message.isLiked;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = colorScheme.onSurfaceVariant.withOpacity(isDarkMode ? 0.4 : 0.5);
    final likeCount = message.likesInfo.length;

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
          if (canLike) ...[
            if (!isClosed) SizedBox(width: DesignTokens.spacingXL),
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

  Widget _buildLikesAvatars(
    BuildContext context,
    List<FCLike> likesInfo,
    int likeCount,
    VoidCallback onShowLikes,
    ColorScheme colorScheme,
    double availableWidth,
  ) {
    if (likesInfo.isEmpty || likeCount == 0) {
      return const SizedBox.shrink();
    }

    final avatarRadius = 12.0; // Smaller avatars for overlapping display
    final avatarSize = avatarRadius * 2;
    final overlapOffset = avatarSize * 0.5; // 50% overlap - each avatar overlaps half of the previous one

    // Calculate how many avatars can fit
    // Each avatar after the first takes overlapOffset (12px) additional width
    // Formula: width = avatarSize + (n - 1) * overlapOffset
    // So: n = ((width - avatarSize) / overlapOffset) + 1
    // Ensure we have at least enough space for one avatar
    final int maxAvatarsToShow;
    if (availableWidth < avatarSize) {
      maxAvatarsToShow = 1; // Show at least one avatar even if space is tight
    } else {
      maxAvatarsToShow = math.max(1, ((availableWidth - avatarSize) / overlapOffset).floor() + 1);
    }

    // Show as many avatars as can fit, but limit to available likesInfo
    final int avatarsToShow = math.min(maxAvatarsToShow, likesInfo.length);

    return SizedBox(
      width: avatarSize + (avatarsToShow - 1) * overlapOffset,
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Show avatars
          ...List.generate(avatarsToShow, (index) {
            final like = likesInfo[index];
            return Positioned(
              left: index * overlapOffset,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: UserAvatar(
                  username: like.username,
                  iconUrl: like.avatarUrl.isNotEmpty ? like.avatarUrl : null,
                  radius: avatarRadius,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReactionIcon(BuildContext context, FCLike like) {
    final avatarSize = DesignTokens.avatarRadiusM * 2; // Same size as avatar
    final colorScheme = Theme.of(context).colorScheme;
    
    Widget? content;
    
    // If emoji is available, display it
    if (like.reactionEmoji != null && like.reactionEmoji!.isNotEmpty) {
      content = Text(
        like.reactionEmoji!,
        style: TextStyle(fontSize: avatarSize * 0.6), // Emoji size relative to circle
      );
    }
    // If icon URL is available, display it
    else if (like.reactionIconUrl != null && like.reactionIconUrl!.isNotEmpty) {
      content = ClipOval(
        child: CachedNetworkImage(
          imageUrl: like.reactionIconUrl!,
          width: avatarSize * 0.7,
          height: avatarSize * 0.7,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => SizedBox(width: avatarSize * 0.7, height: avatarSize * 0.7),
        ),
      );
    }
    // Backward compatibility: if no reaction info, return empty widget
    if (content == null) {
      return const SizedBox.shrink();
    }
    
    // Wrap content in grey circle
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.surfaceVariant,
      ),
      alignment: Alignment.center,
      child: content,
    );
  }

  void _showLikesBottomSheet(BuildContext context) {
    if (message.likesInfo.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(DesignTokens.radiusL)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingL, horizontal: DesignTokens.spacingL),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite, color: Theme.of(context).colorScheme.error),
                      SizedBox(width: DesignTokens.spacingS),
                      Expanded(
                        child: Text(AppLocalizations.of(context)?.reactedBy ?? 'Reacted by', style: Theme.of(context).textTheme.titleMedium),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        alignment: Alignment.centerRight,
                      ),
                    ],
                  ),
                  SizedBox(height: DesignTokens.spacingL),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: message.likesInfo.length,
                      itemBuilder: (context, index) {
                        final like = message.likesInfo[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingS),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // Close bottom sheet
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfilePage(
                                    siteContext: siteContext,
                                    userId: like.userId,
                                    userName: like.username,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                UserAvatar(
                                  username: like.username,
                                  iconUrl: like.avatarUrl,
                                  radius: DesignTokens.avatarRadiusM,
                                ),
                                SizedBox(width: DesignTokens.spacingM),
                                Expanded(
                                  child: Text(like.username, style: Theme.of(context).textTheme.bodyLarge),
                                ),
                                SizedBox(width: DesignTokens.spacingS),
                                _buildReactionIcon(context, like),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
    final List<String> allHeroTags = [];
    int tappedIndex = 0;
    int currentIndex = 0;

    for (var att in message.attachments) {
      final isImage = att.isImage || (att.contentType?.startsWith('image/') ?? false);
      final hasUrl = att.url.isNotEmpty || (att.thumbnailUrl?.isNotEmpty ?? false);
      if (isImage && hasUrl) {
        // Use full URL if available, otherwise use thumbnail
        final urlToUse = att.url.isNotEmpty ? att.url : (att.thumbnailUrl ?? '');
        allImageUrls.add(urlToUse);
        allHeroTags.add('${message.messageId}_attachment_$currentIndex');
        if (urlToUse == imageUrl || att.url == imageUrl || att.thumbnailUrl == imageUrl) {
          tappedIndex = currentIndex;
        }
        currentIndex++;
      }
    }

    if (allImageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No images found to display.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(8),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          imageUrls: allImageUrls,
          initialIndex: tappedIndex,
          heroTag: allHeroTags[tappedIndex],
        ),
      ),
    );
  }

  void onLoginRequired(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Please login to view this attachment',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
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

    final processedText = BBCodeProcessor.processText(message.textBody ?? '', siteContext: siteContext).trimRight();

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
        // Check if URL might be a mention link (contains @username pattern)
        final mentionMatch = RegExp(r'@(\w+)').firstMatch(url);
        if (mentionMatch != null) {
          final username = mentionMatch.group(1);
          AppLogger.debug('ConversationItem: URL contains mention pattern, username: $username');
          if (username != null && username.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfilePage(
                  siteContext: siteContext,
                  userName: username,
                ),
              ),
            );
            return;
          }
        }
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
      inlineAttachments: message.attachments,
      attachments: message.attachments,
    );

    final stylesheet = CustomBBStylesheet(
      siteContext: siteContext,
      callbacks: callbacks,
      context: context,
    );

    return Material(
      color: isHighlighted ? colorScheme.primaryContainer.withOpacity(0.3) : (message.isUnread == true ? colorScheme.primaryContainer.withOpacity(0.1) : colorScheme.surface),
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
                  // Avatar with Online Status Dot
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserProfilePage(
                                siteContext: siteContext,
                                userId: message.userId ?? '',
                                userName: message.username ?? 'Unknown',
                                profilePictureUrl: message.iconUrl,
                              ),
                            ),
                          );
                        },
                        child: UserAvatar(
                          username: message.username ?? 'Unknown',
                          iconUrl: message.iconUrl,
                          radius: DesignTokens.avatarRadiusM,
                          cacheKey: message.iconUrl != null && message.iconUrl!.isNotEmpty
                              ? AvatarCacheUtils.generateAvatarCacheKey(
                                  userId: message.userId ?? '',
                                  username: message.username ?? 'Unknown',
                                  avatarUrl: message.iconUrl!,
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: DesignTokens.statusDotSize,
                          height: DesignTokens.statusDotSize,
                          decoration: BoxDecoration(
                            color: message.isFromCurrentUser == true ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.surface,
                              width: DesignTokens.borderWidthThinMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                                  userId: message.userId ?? '',
                                  userName: message.username ?? 'Unknown',
                                  profilePictureUrl: message.iconUrl,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            message.username ?? 'Unknown',
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
                          case 'report':
                            // TODO: Implement report functionality if needed
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
                  title: 'Attachments',
                ),
              ),
            ],
            // Like avatars card (if there are likes)
            if (message.likeCount > 0) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, DesignTokens.spacingXL, DesignTokens.spacingL, 0.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final likeText = message.likeCount == 1 ? '1 Like' : '${message.likeCount} Likes';

                    return GestureDetector(
                      onTap: () => _showLikesBottomSheet(context),
                      child: Container(
                        margin: EdgeInsets.only(top: DesignTokens.spacingS),
                        padding: DesignTokens.paddingS,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityLow),
                            width: DesignTokens.borderWidthThin,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              likeText,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: DesignTokens.lineHeightTight,
                              ),
                            ),
                            SizedBox(width: DesignTokens.spacingS),
                            Flexible(
                              child: LayoutBuilder(
                                builder: (context, avatarConstraints) {
                                  return _buildLikesAvatars(
                                    context,
                                    message.likesInfo,
                                    message.likeCount,
                                    () => _showLikesBottomSheet(context),
                                    colorScheme,
                                    avatarConstraints.maxWidth,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
              Text(AppLocalizations.of(context)?.edit ?? 'Edit'),
            ],
          ),
        ),
      );
    }
    
    // Report button (if canReport is true)
    if (message.canReport == true) {
      items.add(
        PopupMenuItem<String>(
          value: 'report',
          child: Row(
            children: [
              Icon(
                Icons.flag_outlined,
                size: DesignTokens.iconSizeM,
                color: colorScheme.secondary,
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Text(AppLocalizations.of(context)?.report ?? 'Report'),
            ],
          ),
        ),
      );
    }
    
    return items;
  }

  Widget _buildSocialActions(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    // Get like data from message model
    final bool canLike = message.canLike;
    final bool isLiked = message.isLiked;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = colorScheme.onSurfaceVariant.withOpacity(isDarkMode ? 0.4 : 0.5);
    final likeCount = message.likesInfo.length;

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
          if (canLike) ...[
            if (!isClosed) SizedBox(width: DesignTokens.spacingXL),
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

  Widget _buildLikesAvatars(
    BuildContext context,
    List<FCLike> likesInfo,
    int likeCount,
    VoidCallback onShowLikes,
    ColorScheme colorScheme,
    double availableWidth,
  ) {
    if (likesInfo.isEmpty || likeCount == 0) {
      return const SizedBox.shrink();
    }

    final avatarRadius = 12.0; // Smaller avatars for overlapping display
    final avatarSize = avatarRadius * 2;
    final overlapOffset = avatarSize * 0.5; // 50% overlap - each avatar overlaps half of the previous one

    // Calculate how many avatars can fit
    // Each avatar after the first takes overlapOffset (12px) additional width
    // Formula: width = avatarSize + (n - 1) * overlapOffset
    // So: n = ((width - avatarSize) / overlapOffset) + 1
    // Ensure we have at least enough space for one avatar
    final int maxAvatarsToShow;
    if (availableWidth < avatarSize) {
      maxAvatarsToShow = 1; // Show at least one avatar even if space is tight
    } else {
      maxAvatarsToShow = math.max(1, ((availableWidth - avatarSize) / overlapOffset).floor() + 1);
    }

    // Show as many avatars as can fit, but limit to available likesInfo
    final int avatarsToShow = math.min(maxAvatarsToShow, likesInfo.length);

    return SizedBox(
      width: avatarSize + (avatarsToShow - 1) * overlapOffset,
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Show avatars
          ...List.generate(avatarsToShow, (index) {
            final like = likesInfo[index];
            return Positioned(
              left: index * overlapOffset,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: UserAvatar(
                  username: like.username,
                  iconUrl: like.avatarUrl.isNotEmpty ? like.avatarUrl : null,
                  radius: avatarRadius,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReactionIcon(BuildContext context, FCLike like) {
    final avatarSize = DesignTokens.avatarRadiusM * 2; // Same size as avatar
    final colorScheme = Theme.of(context).colorScheme;
    
    Widget? content;
    
    // If emoji is available, display it
    if (like.reactionEmoji != null && like.reactionEmoji!.isNotEmpty) {
      content = Text(
        like.reactionEmoji!,
        style: TextStyle(fontSize: avatarSize * 0.6), // Emoji size relative to circle
      );
    }
    // If icon URL is available, display it
    else if (like.reactionIconUrl != null && like.reactionIconUrl!.isNotEmpty) {
      content = ClipOval(
        child: CachedNetworkImage(
          imageUrl: like.reactionIconUrl!,
          width: avatarSize * 0.7,
          height: avatarSize * 0.7,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => SizedBox(width: avatarSize * 0.7, height: avatarSize * 0.7),
        ),
      );
    }
    // Backward compatibility: if no reaction info, return empty widget
    if (content == null) {
      return const SizedBox.shrink();
    }
    
    // Wrap content in grey circle
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.surfaceVariant,
      ),
      alignment: Alignment.center,
      child: content,
    );
  }

  void _showLikesBottomSheet(BuildContext context) {
    if (message.likesInfo.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(DesignTokens.radiusL)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingL, horizontal: DesignTokens.spacingL),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite, color: Theme.of(context).colorScheme.error),
                      SizedBox(width: DesignTokens.spacingS),
                      Expanded(
                        child: Text(AppLocalizations.of(context)?.reactedBy ?? 'Reacted by', style: Theme.of(context).textTheme.titleMedium),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        alignment: Alignment.centerRight,
                      ),
                    ],
                  ),
                  SizedBox(height: DesignTokens.spacingL),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: message.likesInfo.length,
                      itemBuilder: (context, index) {
                        final like = message.likesInfo[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingS),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // Close bottom sheet
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfilePage(
                                    siteContext: siteContext,
                                    userId: like.userId,
                                    userName: like.username,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                UserAvatar(
                                  username: like.username,
                                  iconUrl: like.avatarUrl,
                                  radius: DesignTokens.avatarRadiusM,
                                ),
                                SizedBox(width: DesignTokens.spacingM),
                                Expanded(
                                  child: Text(like.username, style: Theme.of(context).textTheme.bodyLarge),
                                ),
                                SizedBox(width: DesignTokens.spacingS),
                                _buildReactionIcon(context, like),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
