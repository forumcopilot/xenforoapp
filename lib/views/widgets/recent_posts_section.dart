import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/results/fc_user_result.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/views/post_page.dart';
import 'package:forumcopilot_flutter/views/lists/posts_list.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import 'package:forumcopilot_flutter/utils/time_utils.dart';
import 'package:forumcopilot_flutter/utils/number_utils.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class RecentPostsSection extends StatelessWidget {
  final SiteContext siteContext;
  final List<FCUserReply>? recentPosts;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMorePosts;
  final int remainingCount;
  final String? error;
  final VoidCallback? onLoadMore;

  const RecentPostsSection({
    Key? key,
    required this.siteContext,
    required this.recentPosts,
    required this.isLoading,
    this.isLoadingMore = false,
    this.hasMorePosts = false,
    this.remainingCount = 0,
    this.error,
    this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hide the entire section if there's an error or no posts (and not loading)
    if (error != null || (!isLoading && (recentPosts == null || recentPosts!.isEmpty))) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: DesignTokens.paddingL,
          child: Text(
            'Recent Posts',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildContent(context, colorScheme, textTheme),
      ],
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    if (isLoading) {
      return const Padding(
        padding: DesignTokens.paddingXXL,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      children: [
        ...recentPosts!.map((post) => _buildPostItem(context, post, colorScheme, textTheme)).toList(),
        if (hasMorePosts && onLoadMore != null)
          Padding(
            padding: DesignTokens.paddingL,
            child: isLoadingMore ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink(),
          ),
      ],
    );
  }

  Widget _buildPostItem(BuildContext context, FCUserReply post, ColorScheme colorScheme, TextTheme textTheme) {
    return Material(
      color: colorScheme.surface,
      child: InkWell(
        onTap: () async {
          await _navigateToPost(context, post);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with avatar, username, and timestamp
            Padding(
              padding: EdgeInsets.all(DesignTokens.spacingL),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  UserAvatar(
                    username: post.authorName.isNotEmpty ? post.authorName : 'User',
                    iconUrl: post.authorIconUrl?.isNotEmpty == true ? post.authorIconUrl : null,
                    radius: 20,
                  ),
                  SizedBox(width: DesignTokens.spacingL),
                  // Author info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.authorName.isNotEmpty ? post.authorName : 'Unknown',
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: DesignTokens.fontWeightSemiBold,
                            letterSpacing: DesignTokens.letterSpacingMedium,
                          ),
                        ),
                        if (post.postTime != DateTime.fromMillisecondsSinceEpoch(0)) ...[
                          SizedBox(height: DesignTokens.spacingXS),
                          Text(
                            formatSmartDateTime(post.postTime, context),
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              letterSpacing: DesignTokens.letterSpacingWide,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Title row (matching topic list item structure)
            Padding(
              padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, 0.0, DesignTokens.spacingL, DesignTokens.spacingS),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      post.topicTitle.isNotEmpty ? post.topicTitle : 'Unknown Topic',
                      style: StyleBuilders.titleTextStyle(
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                        fontSize: DesignTokens.fontSizeTopicTitle,
                        fontWeight: DesignTokens.fontWeightMedium,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Short content if available
            if (post.shortContent?.isNotEmpty == true) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, 0.0, DesignTokens.spacingL, DesignTokens.spacingS),
                child: Text(
                  post.shortContent!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            // Metadata row
            Padding(
              padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, 0.0, DesignTokens.spacingL, DesignTokens.spacingL),
              child: Wrap(
                spacing: DesignTokens.spacingL,
                runSpacing: DesignTokens.spacingXS,
                children: [
                  if (post.forumName.isNotEmpty) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.forum_outlined,
                          size: textTheme.bodySmall?.fontSize ?? 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: DesignTokens.spacingXS),
                        Text(
                          post.forumName,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: DesignTokens.letterSpacingWide,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (post.replyNumber > 0) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: textTheme.bodySmall?.fontSize ?? 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: DesignTokens.spacingXS),
                        Text(
                          formatNumber(context, post.replyNumber),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: DesignTokens.letterSpacingWide,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Bottom divider
            _buildBottomDivider(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomDivider(ColorScheme colorScheme) {
    return Divider(
      height: 1,
      thickness: 1,
      color: colorScheme.outlineVariant.withOpacity(0.3),
    );
  }

  Future<void> _navigateToPost(BuildContext context, FCUserReply post) async {
    try {
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
          AppLogger.debug('RecentPostsSection: proceeding to thread as guest after login screen');
        }
      }
      // Validate required parameters
      if (post.topicId.isEmpty || post.topicTitle.isEmpty) {
        AppLogger.debug('Invalid post information: topicId or topicTitle is empty');
        return;
      }

      // Navigate to the specific post if postId is available, otherwise use first_unread mode
      if (post.postId.isNotEmpty) {
        AppLogger.debug('Navigating to specific post: ${post.postId} in topic: ${post.topicId}');
        Get.to(() => PostPage(
              siteContext: siteContext,
              topicId: post.topicId,
              title: post.topicTitle,
              mode: PostsListMode.thread_by_post,
              anchorPostId: post.postId,
              forumId: post.forumId.isNotEmpty ? post.forumId : null,
            ));
      } else {
        AppLogger.debug('No postId available, navigating to latest posts in topic: ${post.topicId}');
        Get.to(() => PostPage(
              siteContext: siteContext,
              topicId: post.topicId,
              title: post.topicTitle,
              mode: PostsListMode.first_unread,
              forumId: post.forumId.isNotEmpty ? post.forumId : null,
            ));
      }
    } catch (e) {
      AppLogger.debug('Error navigating to post: $e');
    }
  }
}
