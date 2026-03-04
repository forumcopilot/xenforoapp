import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import 'package:forumcopilot_sdk/models/entities/fc_like.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import '../../utils/time_utils.dart';
import '../../utils/accessibility_helpers.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:forumcopilot_flutter/views/user_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/design_tokens.dart';

class PostListItemSocial extends StatelessWidget {
  final FCPost post;
  final bool isLiked;
  final bool isThanked;
  final int likeCount;
  final bool isLoggedIn;
  final VoidCallback? onLike;
  final VoidCallback? onThank;
  final VoidCallback? onShowLikes;
  final VoidCallback? onShowThanks;
  final Widget? trailing;

  const PostListItemSocial({
    super.key,
    required this.post,
    required this.isLiked,
    required this.isThanked,
    required this.likeCount,
    this.isLoggedIn = false,
    this.onLike,
    this.onThank,
    this.onShowLikes,
    this.onShowThanks,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (post.likesInfo.isNotEmpty) ...[
        //   const SizedBox(height: 12),
        //   Row(
        //     children: [
        //       Icon(Icons.favorite_border, size: 18, color: colorScheme.primary),
        //       const SizedBox(width: 6),
        //       Text('Likes: ', style: textTheme.bodySmall),
        //       ...post.likesInfo.take(4).map((l) => Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 2.0),
        //             child: Chip(
        //               label: Text(l.username, style: textTheme.bodySmall),
        //               visualDensity: VisualDensity.compact,
        //             ),
        //           )),
        //       if (post.likesInfo.length > 4)
        //         Text(
        //           ' + {post.likesInfo.length - 4} more people',
        //           style: textTheme.bodySmall,
        //         ),
        //     ],
        //   ),
        // ],
        // if (post.thanksInfo.isNotEmpty) ...[
        //   const SizedBox(height: 12),
        //   Row(
        //     children: [
        //       Icon(Icons.thumb_up_alt_outlined, size: 18, color: colorScheme.primary),
        //       const SizedBox(width: 6),
        //       Text('Thanks: ', style: textTheme.bodySmall),
        //       ...post.thanksInfo.take(4).map((t) => Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 2.0),
        //             child: Chip(
        //               label: Text(t.username, style: textTheme.bodySmall),
        //               visualDensity: VisualDensity.compact,
        //             ),
        //           )),
        //       if (post.thanksInfo.length > 4)
        //         Text(
        //           ' + {post.thanksInfo.length - 4} more people',
        //           style: textTheme.bodySmall,
        //         ),
        //     ],
        //   ),
        // ],
        // Like avatars row (if there are likes)
        if (likeCount > 0) ...[
          SizedBox(height: DesignTokens.spacingXL),
          LayoutBuilder(
            builder: (context, constraints) {
              final likeText = likeCount == 1 ? '1 Like' : '$likeCount Likes';
              
              return Semantics(
                label: likeText,
                hint: 'Show likes',
                button: true,
                enabled: onShowLikes != null,
                child: GestureDetector(
                  onTap: onShowLikes,
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
                              post.likesInfo,
                              likeCount,
                              onShowLikes,
                              colorScheme,
                              avatarConstraints.maxWidth,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              );
            },
          ),
        ],
        // Like/Thank button row
        SizedBox(height: DesignTokens.spacingM),
        Row(
          children: [
            // Reply button (trailing widget)
            if (trailing != null) trailing!,
            // Show like button only if logged in and can like
            if (isLoggedIn && post.canLike) ...[
              if (trailing != null) SizedBox(width: DesignTokens.spacingXL),
              Builder(
                builder: (context) {
                  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
                  final iconColor = isLiked 
                      ? colorScheme.error 
                      : colorScheme.onSurfaceVariant.withOpacity(isDarkMode ? 0.4 : 0.5);
                  return AccessibilityHelpers.accessibleIconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: iconColor,
                      size: DesignTokens.iconSizeMedium,
                    ),
                    onTap: onLike,
                    label: AccessibilityHelpers.getLikeButtonLabel(context, isLiked, likeCount),
                    isSelected: isLiked,
                    context: context,
                  );
                },
              ),
            ],
            // Show thank button only if logged in and (can thank or has thanks)
            if (isLoggedIn && (post.canThank || post.thanksInfo.isNotEmpty)) ...[
              if (trailing != null || (isLoggedIn && (post.canLike || post.likesInfo.isNotEmpty))) SizedBox(width: DesignTokens.spacingXL),
              Builder(
                builder: (context) {
                  return AccessibilityHelpers.accessibleIconButton(
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isThanked ? Icons.emoji_emotions : Icons.emoji_emotions_outlined,
                          color: post.canThank ? (isThanked ? Colors.orange : colorScheme.onSurfaceVariant) : colorScheme.onSurfaceVariant.withOpacity(DesignTokens.opacityMediumLow),
                          size: DesignTokens.iconSizeMedium,
                        ),
                        if (post.thanksInfo.isNotEmpty) ...[
                          SizedBox(width: DesignTokens.spacingXS),
                          Text(
                            '${post.thanksInfo.length}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    onTap: onThank,
                    label: AccessibilityHelpers.getThankButtonLabel(context, isThanked),
                    hint: post.thanksInfo.isNotEmpty 
                        ? 'Show ${post.thanksInfo.length} thanks'
                        : null,
                    isSelected: isThanked,
                    context: context,
                  );
                },
              ),
              // Separate button for showing thanks count if available
              if (post.thanksInfo.isNotEmpty) ...[
                SizedBox(width: DesignTokens.spacingXS),
                Builder(
                  builder: (context) {
                    return Semantics(
                      label: '${post.thanksInfo.length} thanks',
                      hint: 'Show thanks',
                      button: true,
                      enabled: onShowThanks != null,
                      child: GestureDetector(
                        onTap: onShowThanks,
                        child: Text(
                          '${post.thanksInfo.length}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildLikesAvatars(
    BuildContext context,
    List<FCLike> likesInfo,
    int likeCount,
    VoidCallback? onShowLikes,
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

  static Widget _buildReactionIcon(BuildContext context, FCLike like) {
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

  static void showLikesBottomSheet(BuildContext context, FCPost post, SiteContext siteContext) {
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
                      Semantics(
                        label: 'Close',
                        button: true,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: DesignTokens.spacingL),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: post.likesInfo.length,
                      itemBuilder: (context, index) {
                        final like = post.likesInfo[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingS),
                          child: Semantics(
                            label: 'View profile of ${like.username}',
                            button: true,
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

  static void showThanksBottomSheet(BuildContext context, FCPost post, SiteContext siteContext) {
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Thanked By',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Semantics(
                        label: 'Close',
                        button: true,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: DesignTokens.spacingL),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: post.thanksInfo.length,
                      itemBuilder: (context, index) {
                        final thank = post.thanksInfo[index];
                        return ListTile(
                          leading: UserAvatar(
                            username: thank.username,
                            iconUrl: thank.avatarUrl,
                            radius: DesignTokens.avatarRadiusM,
                          ),
                          title: Text(thank.username),
                          subtitle: Text(formatTimeAgo(thank.timestamp ?? DateTime.now(), context)),
                          onTap: () {
                            Navigator.pop(context); // Close bottom sheet
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfilePage(
                                  siteContext: siteContext,
                                  userId: thank.userId,
                                  userName: thank.username,
                                ),
                              ),
                            );
                          },
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
