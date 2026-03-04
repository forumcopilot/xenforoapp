import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/views/post_page.dart';
import 'package:forumcopilot_flutter/views/lists/posts_list.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';
import 'package:forumcopilot_flutter/utils/time_utils.dart';
import 'package:forumcopilot_flutter/utils/number_utils.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class UserRepliedPosts extends StatefulWidget {
  final SiteContext siteContext;
  final String? userId;
  final String? userName;

  const UserRepliedPosts({
    super.key,
    required this.siteContext,
    this.userId,
    this.userName,
  });

  @override
  State<UserRepliedPosts> createState() => _UserRepliedPostsState();
}

class _UserRepliedPostsState extends State<UserRepliedPosts> {
  List<FCUserReply>? _recentPosts;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _total = 0;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _fetchRecentPosts();
  }

  @override
  void didUpdateWidget(UserRepliedPosts oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId || oldWidget.userName != widget.userName) {
      _fetchRecentPosts();
    }
  }

  // Public method to check if should load more based on scroll position
  // This is called from parent scroll controllers
  void checkAndLoadMore(double scrollPosition, double maxScrollExtent) {
    if (!mounted) return;
    if (scrollPosition >= maxScrollExtent - 300 && !_isLoadingMore && _hasMorePosts && _recentPosts != null) {
      _fetchRecentPosts(loadMore: true);
    }
  }

  Future<void> _fetchRecentPosts({bool loadMore = false}) async {
    if (widget.userName == null && widget.userId == null) {
      setState(() {
        _error = 'No user specified';
        _isLoading = false;
      });
      return;
    }

    if (loadMore) {
      if (_isLoadingMore || _recentPosts == null) return;
      setState(() {
        _isLoadingMore = true;
        _error = null;
      });
    } else {
      setState(() {
        _isLoading = true;
        _error = null;
        _recentPosts = null;
        _total = 0;
      });
    }

    try {
      final currentCount = _recentPosts?.length ?? 0;
      final startNum = loadMore ? currentCount : 0;
      final lastNum = startNum + _pageSize - 1;

      AppLogger.debug('Fetching recent posts for user: ${widget.userName ?? widget.userId}, startNum: $startNum, lastNum: $lastNum');
      final proxy = SiteProxyFactory.getUserProxy();
      final result = await proxy.getUserReplyPostAsync(startNum, lastNum, null, widget.userName, widget.userId);
      AppLogger.debug('Result from getUserReplyPostAsync: total: ${result.total}, posts count: ${result.posts.length}');

      if (mounted) {
        setState(() {
          if (loadMore) {
            _recentPosts = [...(_recentPosts ?? []), ...result.posts];
          } else {
            _recentPosts = result.posts;
            _total = result.total;
          }
          _isLoading = false;
          _isLoadingMore = false;
          // Update total if we got a new value
          if (result.total > _total) {
            _total = result.total;
          }
        });
      }
    } catch (e, stack) {
      AppLogger.debug('Error in _fetchRecentPosts: ${e.toString()}');
      AppLogger.debug('Stack trace: $stack');
      if (mounted) {
        setState(() {
          _error = 'Failed to load recent posts';
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  bool get _hasMorePosts {
    if (_recentPosts == null) return false;
    return _recentPosts!.length < _total;
  }

  @override
  Widget build(BuildContext context) {
    // Hide the entire section if there's an error or no posts (and not loading)
    if (_error != null || (!_isLoading && (_recentPosts == null || _recentPosts!.isEmpty))) {
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
              fontWeight: DesignTokens.fontWeightBold,
            ),
          ),
        ),
        _buildContent(context, colorScheme, textTheme),
      ],
    );
  }

  Future<void> _navigateToPost(FCUserReply post) async {
    try {
      if (!widget.siteContext.isLoggedIn) {
        if (!Get.isRegistered<LoginController>()) {
          Get.put(LoginController());
        }
        final loginController = Get.find<LoginController>();
        final loginResult = await loginController.attemptAutomaticLogin(widget.siteContext);
        if (!loginResult.success && loginResult.hadCredentials && Get.currentRoute != '/LoginPage') {
          await Get.to(() => LoginPage(siteContext: widget.siteContext));
        }
        if (!widget.siteContext.isLoggedIn) {
          AppLogger.debug('UserRepliedPosts: proceeding to thread as guest after login screen');
        }
      }
      // Validate required parameters
      if (post.topicId.isEmpty || post.topicTitle.isEmpty) {
        AppLogger.debug('Invalid post information: topic_id or topic_title is empty');
        return;
      }

      // Navigate to the specific post if post_id is available, otherwise use first_unread mode
      if (post.postId.isNotEmpty) {
        AppLogger.debug('Navigating to specific post: ${post.postId} in topic: ${post.topicId}');
        Get.to(() => PostPage(
              siteContext: widget.siteContext,
              topicId: post.topicId,
              title: post.topicTitle,
              mode: PostsListMode.thread_by_post,
              anchorPostId: post.postId,
              forumId: post.forumId.isNotEmpty ? post.forumId : null,
            ));
      } else {
        AppLogger.debug('No post_id available, navigating to latest posts in topic: ${post.topicId}');
        Get.to(() => PostPage(
              siteContext: widget.siteContext,
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

  Widget _buildContent(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    if (_isLoading) {
      return const Padding(
        padding: DesignTokens.paddingXXL,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      children: [
        ..._recentPosts!.map((post) => _buildPostItem(context, post, colorScheme, textTheme)).toList(),
        if (_hasMorePosts)
          Padding(
            padding: DesignTokens.paddingL,
            child: _isLoadingMore ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink(),
          ),
      ],
    );
  }

  Widget _buildPostItem(BuildContext context, FCUserReply post, ColorScheme colorScheme, TextTheme textTheme) {
    return Material(
      color: colorScheme.surface,
      child: InkWell(
        onTap: () async {
          await _navigateToPost(post);
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
                    username: (post.authorName.isNotEmpty) ? post.authorName : (widget.userName ?? 'User'),
                    iconUrl: (post.authorIconUrl?.isNotEmpty == true) ? post.authorIconUrl : null,
                    radius: 20,
                  ),
                  SizedBox(width: DesignTokens.spacingL),
                  // Author info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (post.authorName.isNotEmpty) ? post.authorName : (widget.userName ?? 'Unknown'),
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: DesignTokens.fontWeightMedium,
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
                          size: textTheme.bodySmall?.fontSize ?? DesignTokens.fontSizeXS,
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
                          size: textTheme.bodySmall?.fontSize ?? DesignTokens.fontSizeXS,
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
}
