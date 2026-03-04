import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/utils/time_utils.dart';
import '../user_profile_page.dart';
// import '../widgets/cached_redirect_image.dart';
import '../widgets/user_avatar.dart';
import '../widgets/post_actions.dart';
import '../login_page.dart';
import '../../utils/avatar_cache_utils.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';
// import '../../utils/avatar_color_utils.dart';

class PostListItemHeader extends StatelessWidget {
  final SiteContext siteContext;
  final FCPost post;
  final void Function(String userId, String userName)? onAvatarTap;
  final void Function(String value) onMenuSelected;
  final List<PopupMenuEntry<String>> Function(BuildContext) buildPopupMenuItems;
  final BuildContext context;
  final PostActionsHandler? postActionsHandler;
  final VoidCallback? onRefresh;

  const PostListItemHeader({
    super.key,
    required this.siteContext,
    required this.post,
    required this.onAvatarTap,
    required this.onMenuSelected,
    required this.buildPopupMenuItems,
    required this.context,
    this.postActionsHandler,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(this.context).colorScheme;
    final textTheme = Theme.of(this.context).textTheme;
    // final isLightTheme = Theme.of(this.context).brightness == Brightness.light;

    // Avatar colors handled within UserAvatar

    return Padding(
      padding: EdgeInsets.all(DesignTokens.spacingL),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Author Avatar with Online Status Dot
          Stack(
            children: [
              GestureDetector(
                onTap: () => onAvatarTap?.call(post.authorId, post.authorName),
                child: UserAvatar(
                  username: post.authorName,
                  iconUrl: post.authorIconUrl,
                  radius: DesignTokens.avatarRadiusM,
                  cacheKey: post.authorIconUrl != null && post.authorIconUrl!.isNotEmpty
                      ? AvatarCacheUtils.generateAvatarCacheKey(
                          userId: post.authorId,
                          username: post.authorName,
                          avatarUrl: post.authorIconUrl!,
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
                    color: post.isAuthorOnline == true ? Colors.green : Colors.grey,
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
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Check if user is logged in
                        if (!siteContext.isLoggedIn) {
                          // Show login popup if not logged in
                          if (postActionsHandler != null) {
                            postActionsHandler!.showPostLoginPrompt(this.context, onRefresh: onRefresh);
                          } else {
                            // Fallback to simple login prompt
                            _showSimpleLoginPrompt(this.context);
                          }
                          return;
                        }

                        // Navigate to user profile if logged in
                        Navigator.push(
                          this.context,
                          MaterialPageRoute(
                            builder: (context) => UserProfilePage(
                              siteContext: siteContext,
                              userName: post.authorName,
                              userId: post.authorId,
                              profilePictureUrl: post.authorIconUrl,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        post.authorName,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: DesignTokens.fontWeightMedium,
                          letterSpacing: DesignTokens.letterSpacingMedium,
                        ),
                      ),
                    ),
                    // Status badges for banned and deleted posts
                    if (post.isBanned) ...[
                      SizedBox(width: DesignTokens.spacingS),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingM - DesignTokens.spacingXS,
                          vertical: DesignTokens.spacingXS / 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer.withOpacity(DesignTokens.opacityHigh),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.block,
                              size: DesignTokens.iconSizeXS,
                              color: colorScheme.onErrorContainer,
                            ),
                            SizedBox(width: DesignTokens.spacingXS),
                            Text(
                              'BANNED',
                              style: StyleBuilders.badgeTextStyle(
                                colorScheme: colorScheme,
                                textTheme: textTheme,
                                color: colorScheme.onErrorContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (post.isDeleted) ...[
                      SizedBox(width: DesignTokens.spacingS),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingM - DesignTokens.spacingXS,
                          vertical: DesignTokens.spacingXS / 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.outline.withOpacity(DesignTokens.opacityLow),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: DesignTokens.iconSizeXS,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: DesignTokens.spacingXS),
                            Text(
                              'DELETED',
                              style: StyleBuilders.badgeTextStyle(
                                colorScheme: colorScheme,
                                textTheme: textTheme,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: DesignTokens.spacingXS),
                Row(
                  children: [
                    if (post.postNumber != null) ...[
                      Text(
                        '#${post.postNumber}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: DesignTokens.letterSpacingWide,
                        ),
                      ),
                      SizedBox(width: DesignTokens.spacingS),
                    ],
                    Text(
                      post.timestamp != null ? formatSmartDateTime(post.timestamp!, context) : 'Unknown date',
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
          if (buildPopupMenuItems(this.context).isNotEmpty)
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              onSelected: onMenuSelected,
              itemBuilder: buildPopupMenuItems,
            ),
        ],
      ),
    );
  }

  void _showSimpleLoginPrompt(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Login Required',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Please login to view user profiles.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.to(() => LoginPage(siteContext: siteContext));
            },
            child: Text(
              'Login',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
