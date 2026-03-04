import 'dart:async';
import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/models/thread_view_data.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_flutter/controllers/post_controller.dart';
import 'package:forumcopilot_flutter/views/listitems/post_list_item.dart';
import 'package:forumcopilot_flutter/views/widgets/post_actions.dart';
import 'package:forumcopilot_flutter/views/widgets/image_actions.dart';
import 'package:forumcopilot_flutter/views/widgets/avatar_actions.dart';
import 'package:forumcopilot_flutter/views/widgets/thread_poll_mini_card.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:shimmer/shimmer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';
import '../../utils/error_dialog.dart';

class PostsList extends StatefulWidget {
  const PostsList({
    super.key,
    required this.siteContext,
    required this.topicId,
    required this.topicTitle,
    this.onForumIdAvailable,
    this.onRefreshAvailable,
    this.onSubscriptionStatusChanged,
    this.onClosedStatusChanged,
    this.onStickyStatusChanged,
    this.onDeletedStatusChanged,
    this.mode = PostsListMode.normal,
    this.anchorPostId,
    this.gotoPage,
    this.isAnnouncement = false,
    this.onCanSubscribeChanged,
    this.onCanCloseChanged,
    this.onCanStickyChanged,
    this.onCanDeleteChanged,
    this.onTopicTitleLoaded,
    this.onThreadUrlAvailable,
    this.forumId,
  })  : assert(mode != PostsListMode.thread_by_post || anchorPostId != null, 'anchorPostId must be provided for thread_by_post mode'),
        assert(mode != PostsListMode.goto_page || gotoPage != null, 'gotoPage must be provided for goto_page mode');

  final SiteContext siteContext;
  final String topicId;
  final String topicTitle;
  final void Function(String)? onForumIdAvailable;
  /// Called with a refresh callback. The callback may be invoked with no args to refresh
  /// the current page, or with [scrollToPostId] to refresh by loading the thread at that post
  /// and scrolling to it (used after replying so the new post is visible without replacing the route).
  final void Function(void Function([String? scrollToPostId]) refresh)? onRefreshAvailable;
  final void Function(bool)? onSubscriptionStatusChanged;
  final void Function(bool isClosed)? onClosedStatusChanged;
  final void Function(bool isSticky)? onStickyStatusChanged;
  final void Function(bool isDeleted)? onDeletedStatusChanged;
  final PostsListMode mode;
  final String? anchorPostId;
  final int? gotoPage;
  final bool isAnnouncement;
  final String? forumId;

  /// Called with the thread's can_subscribe permission after loading thread data.
  final void Function(bool canSubscribe)? onCanSubscribeChanged;

  /// Called with the thread's can_close permission after loading thread data.
  final void Function(bool canClose)? onCanCloseChanged;

  /// Called with the thread's can_stick permission after loading thread data.
  final void Function(bool canSticky)? onCanStickyChanged;

  /// Called with the thread's can_delete permission after loading thread data.
  final void Function(bool canDelete)? onCanDeleteChanged;

  /// Called with the actual topic title when it's loaded from the server.
  final void Function(String topicTitle)? onTopicTitleLoaded;

  /// Called with the thread URL when it's loaded from the server.
  final void Function(String? threadUrl)? onThreadUrlAvailable;

  @override
  State<PostsList> createState() => _PostsState(topicId, anchorPostId, gotoPage);
}

enum PostsListMode { normal, first_unread, thread_by_post, goto_page }

const bool _retriveHtml = false;

enum _PagingDirection { none, earlier, later }

class _PostsState extends State<PostsList> {
  late final PostController _postsController;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  bool _isLoadingMore = false;
  bool _hasMorePosts = true;
  final int _pageSize = 20;
  String? _anchorPostId;
  int? _gotoPage;
  int _currentVisiblePostIndex = 0;
  int? _pendingInitialScrollIndex;
  bool _hasJumpedToInitialPost = false;
  String? _highlightedPostId; // Track which post should be highlighted
  Timer? _highlightTimer; // Timer to clear highlight after a few seconds
  String? _actualTopicId; // Store the actual topicId resolved from thread_by_post mode

  // Add scroll loading control flag
  bool _isScrollLoadingEnabled = false;

  // Track paging direction to render shimmer in correct place
  _PagingDirection _pagingDirection = _PagingDirection.none;

  /// True when the first post (post #1) is currently visible on screen.
  /// Used to hide the mini poll bar when the full poll is visible inside the first post.
  bool _isFirstPostVisible = true;

  // Track when we last loaded earlier posts to prevent endless loading
  DateTime? _lastEarlierLoadTime;

  _PostsState(topicId, [anchorPostId, gotoPage]) {
    _anchorPostId = anchorPostId;
    _gotoPage = gotoPage;
    // Create a unique controller instance for this PostsList
    _postsController = PostController();
  }

  @override
  void initState() {
    super.initState();

    // Schedule callback for the next frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onRefreshAvailable?.call(_refreshWithOptionalScrollToPost);
        widget.onTopicTitleLoaded?.call(widget.topicTitle);
      }
    });
    // For initial load, startNum and lastNum should be 1-based for the API
    // But _loadInitialPosts passes these to getThreadAsync, which now expects 1-based
    // So we keep them as 0-based here and let _loadInitialPosts convert
    int startNum = 0;
    int lastNum = _pageSize - 1;
    // Calculate gotoPost based on mode
    int gotoPost = 0;
    if (widget.mode == PostsListMode.goto_page && widget.gotoPage != null) {
      // For goto_page mode, we want to land on the first post of that page
      gotoPost = (widget.gotoPage! - 1) * _pageSize + 1;
    } else if (widget.mode == PostsListMode.thread_by_post && _anchorPostId != null) {
      // For thread_by_post mode, pass the anchor post ID
      gotoPost = int.tryParse(_anchorPostId!) ?? 0;
    }
    _loadInitialPosts(startNum, lastNum, widget.mode, gotoPost: gotoPost);
    _setupScrollListener();
  }

  @override
  void didUpdateWidget(PostsList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if topicId changed OR if anchorPostId changed (for same topic navigation)
    final topicIdChanged = oldWidget.topicId != widget.topicId;
    final anchorPostIdChanged = oldWidget.anchorPostId != widget.anchorPostId;
    final modeChanged = oldWidget.mode != widget.mode;

    if (topicIdChanged || anchorPostIdChanged || modeChanged) {
      if (!mounted) return;

      // Update internal state for anchorPostId
      if (anchorPostIdChanged) {
        _anchorPostId = widget.anchorPostId;
      }

      // Disable scroll loading when switching threads or posts
      _isScrollLoadingEnabled = false;

      // Clear the controller's data first to prevent showing old posts during loading
      _postsController.threadDataOutput.value = null;

      // Reset state when switching threads or posts
      setState(() {
        _currentVisiblePostIndex = 0;
        _isLoadingMore = false;
        _hasMorePosts = true;
        _hasJumpedToInitialPost = false; // Reset to allow jumping to new post
        _pendingInitialScrollIndex = null; // Clear pending scroll
        _actualTopicId = null; // Reset actual topicId when switching threads
      });

      // Reset scroll position using item controller
      try {
        _itemScrollController.jumpTo(index: 0);
      } catch (e) {
        AppLogger.debug('PostsList: Failed to reset scroll position: $e');
      }

      int startNum = 0;
      int lastNum = _pageSize - 1;
      // Calculate gotoPost based on mode
      int gotoPost = 0;
      if (widget.mode == PostsListMode.goto_page && widget.gotoPage != null) {
        // For goto_page mode, we want to land on the first post of that page
        gotoPost = (widget.gotoPage! - 1) * _pageSize + 1;
      } else if (widget.mode == PostsListMode.thread_by_post && widget.anchorPostId != null) {
        // For thread_by_post mode, pass the anchor post ID
        gotoPost = int.tryParse(widget.anchorPostId!) ?? 0;
      }
      _loadInitialPosts(startNum, lastNum, widget.mode, gotoPost: gotoPost);
    }
  }

  /// Loads the initial set of posts for the thread.
  ///
  /// - If mode is [PostsListMode.first_unread], uses getThreadByUnreadAsync to jump to the first unread post.
  /// - If mode is [PostsListMode.thread_by_post], uses getThreadByPostAsync to jump to a specific anchor post.
  /// - If mode is [PostsListMode.goto_page], uses getThreadByPageAsync to jump to a specific page.
  /// - Otherwise, uses getThreadAsync for normal loading.
  ///
  /// Note: Only the initial load uses these special APIs. All subsequent paging (earlier/later) uses normal loading.
  Future<void> _loadInitialPosts(int startNum, int lastNum, PostsListMode mode, {int gotoPost = 0}) async {
    if (!mounted) return;

    // Clear the controller's data first to prevent showing old posts during loading
    _postsController.threadDataOutput.value = null;

    // Disable scroll loading during initial load
    _isScrollLoadingEnabled = false;

    AppLogger.debug('PostsList: _loadInitialPosts called: mode=$mode, topicId=${widget.topicId}');

    try {
      // --- Check for announcement first, regardless of mode ---
      if (mode == PostsListMode.first_unread) {
        // Jump to the first unread post using the special API
        // If this fails due to authentication, fall back to normal mode
        try {
          await _postsController.getThreadByUnreadAsync(widget.topicId, _pageSize, _retriveHtml);
        } catch (e, stackTrace) {
          AppLogger.debug('🔍 [PostsList] getThreadByUnreadAsync failed: $e');
          AppLogger.debug('🔍 [PostsList] Stack trace: $stackTrace');
          // Check if error is due to authentication
          final errorString = e.toString().toLowerCase();
          if (errorString.contains('authentication') || errorString.contains('log in') || errorString.contains('401')) {
            // Fall back to normal mode if authentication is required
            // startNum and lastNum are 0-based, but getThreadAsync expects 1-based for the API
            final startNum1Based = startNum + 1; // Convert to 1-based
            final lastNum1Based = lastNum + 1; // Convert to 1-based
            AppLogger.debug('⚠️ [POSTS_LIST] getThreadByUnread requires authentication, falling back to normal mode');
            await _postsController.getThreadAsync(widget.topicId, startNum1Based, lastNum1Based, _retriveHtml, mode: LoadMode.initial);
          } else {
            // Re-throw other errors
            rethrow;
          }
        }
      } else if (mode == PostsListMode.thread_by_post) {
        // Jump to a specific anchor post using the special API
        if (_anchorPostId == null) throw Exception('anchorPostId is required for thread_by_post mode');
        await _postsController.getThreadByPostAsync(_anchorPostId!, _pageSize, _retriveHtml);
      } else if (mode == PostsListMode.goto_page) {
        // Jump to a specific page using the special API
        if (_gotoPage == null) throw Exception('gotoPage is required for goto_page mode');
        await _postsController.getThreadByPageAsync(widget.topicId, _gotoPage!, _pageSize, false);
      } else {
        // Normal initial load
        // startNum and lastNum are 0-based, but getThreadAsync expects 1-based for the API
        final startNum1Based = startNum + 1; // Convert to 1-based
        final lastNum1Based = lastNum + 1; // Convert to 1-based
        AppLogger.debug('🔍 [PostsList] Mode is normal, calling getThreadAsync (mode=$mode)');
        await _postsController.getThreadAsync(widget.topicId, startNum1Based, lastNum1Based, _retriveHtml, mode: LoadMode.initial);
      }
      // --- End special initial load ---

      if (!mounted) return;
      final data = _postsController.threadDataOutput.value;

      // Store the actual topicId from the loaded data (important for thread_by_post mode)
      if (data != null && data.topic.id.isNotEmpty) {
        _actualTopicId = data.topic.id;
      }

      // Schedule callbacks for the next frame to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final forumId = data?.topic.forumId;
        if (forumId != null && forumId.isNotEmpty) {
          widget.onForumIdAvailable?.call(forumId);
        }
        widget.onSubscriptionStatusChanged?.call(data?.topic.isSubscribed ?? false);
        // Notify closed and sticky status separately
        widget.onClosedStatusChanged?.call(data?.topic.isClosed ?? false);
        widget.onStickyStatusChanged?.call(data?.topic.isPinned ?? false);
        widget.onDeletedStatusChanged?.call(data?.topic.isDeleted ?? false);
        // Notify permission flags
        widget.onCanSubscribeChanged?.call(data?.topic.canSubscribe ?? true);
        widget.onCanCloseChanged?.call(data?.topic.canClose ?? true);
        widget.onCanStickyChanged?.call(data?.topic.canStick ?? true);
        widget.onCanDeleteChanged?.call(data?.topic.canDelete ?? true);
        widget.onTopicTitleLoaded?.call(data?.topic.title ?? '');
        widget.onThreadUrlAvailable?.call(data?.topic.url);
      });
      _updateHasMorePosts();

      // Determine the target post position to scroll to
      int targetPosition = 0;

      // For goto_page mode, data.position is incorrect (it's set to startNum + posts.length, not the target post).
      // So we should NOT use data.position for goto_page mode. Always use gotoPost parameter instead.
      // For first_unread mode, the API returns position field indicating the first unread post number.
      // For thread_by_post mode, we search by post ID, not position.
      // IMPORTANT: Use the 'mode' parameter passed to this method, not widget.mode, since this method
      // can be called with a different mode than the widget's initial mode (e.g., from jump-to-post dialog).
      if (mode == PostsListMode.goto_page && gotoPost > 0) {
        // For goto_page mode, always use gotoPost parameter
        targetPosition = gotoPost;
      } else if (data != null && data.position > 0 && mode == PostsListMode.first_unread) {
        // For first_unread mode, use API position field
        targetPosition = data.position;
      } else if (gotoPost > 0) {
        // Fallback: Use gotoPost parameter
        targetPosition = gotoPost;
      }

      // Calculate scroll index based on mode
      // For thread_by_post mode, we need to handle it separately since targetPosition may be 0
      if (data != null && data.posts.isNotEmpty) {
        final postsList = data.posts;
        int index = -1;

        // For thread_by_post mode, find by post ID or use position from API
        // IMPORTANT: Use the 'mode' parameter passed to this method, not widget.mode
        if (mode == PostsListMode.thread_by_post && _anchorPostId != null) {
          // First, try to use the position from API response if available
          // position is 1-based index in the entire thread
          // currentStartNum is 0-based starting index of the loaded page
          // So index in the loaded list = position - 1 - currentStartNum
          if (data.position > 0) {
            final calculatedIndex = (data.position - 1) - data.currentStartNum;
            if (calculatedIndex >= 0 && calculatedIndex < postsList.length) {
              // Verify the post at this index matches the anchor post ID
              final postAtIndex = postsList[calculatedIndex];
              final normalizedAnchorId = _anchorPostId!.toString().trim();
              final normalizedPostId = postAtIndex.id.toString().trim();
              if (normalizedPostId == normalizedAnchorId) {
                index = calculatedIndex;
                AppLogger.debug('🔍 [PostsList] Found anchor post at calculated index $index using position ${data.position}');
              } else {
                AppLogger.debug('⚠️ [PostsList] Post at calculated index $calculatedIndex (ID: $normalizedPostId) does not match anchor ID: $normalizedAnchorId, falling back to search');
                // Fall back to searching by ID
                index = postsList.indexWhere((p) {
                  return p.id.toString().trim() == normalizedAnchorId;
                });
              }
            } else {
              AppLogger.debug('⚠️ [PostsList] Calculated index $calculatedIndex is out of range (0-${postsList.length - 1}), falling back to search');
              // Fall back to searching by ID
              index = postsList.indexWhere((p) {
                return p.id.toString().trim() == _anchorPostId!.toString().trim();
              });
            }
          } else {
            // Fall back to searching by ID if position is not available
            AppLogger.debug('🔍 [PostsList] Searching for post with ID: $_anchorPostId (position not available)');
            AppLogger.debug('🔍 [PostsList] Available post IDs: ${postsList.map((p) => p.id).toList()}');

            // Normalize both IDs to strings for comparison (handle type mismatches)
            final normalizedAnchorId = _anchorPostId!.toString().trim();
            index = postsList.indexWhere((p) {
              final normalizedPostId = p.id.toString().trim();
              final matches = normalizedPostId == normalizedAnchorId;
              if (matches) {
                AppLogger.debug('🔍 [PostsList] Found matching post at index: ${postsList.indexOf(p)}');
              }
              return matches;
            });
          }

          if (index < 0) {
            AppLogger.debug('⚠️ [PostsList] Post with ID $_anchorPostId not found in loaded posts');
          }
        } else if (targetPosition > 0) {
          // For other modes, find by post number/position
          index = postsList.indexWhere((p) => (p.postNumber ?? 0) == targetPosition);
        }

        if (index >= 0) {
          // Found the target post in the loaded page
          _pendingInitialScrollIndex = index;
          _hasJumpedToInitialPost = false; // Reset to allow jumping
        } else if (index < 0) {
          // Target post not found by postNumber in current page
          // For thread_by_post mode, we can't calculate relative position since we don't know the post number
          // For other modes, we can try to calculate relative position
          // IMPORTANT: Use the 'mode' parameter passed to this method, not widget.mode
          if (mode == PostsListMode.thread_by_post) {
            // For thread_by_post mode, if anchor post not found, scroll to top
            AppLogger.debug('⚠️ [PostsList] Anchor post not found in thread_by_post mode, scrolling to top');
            if (postsList.isNotEmpty) {
              _pendingInitialScrollIndex = 0;
              _hasJumpedToInitialPost = false; // Reset to allow jumping
            } else {
              _pendingInitialScrollIndex = null;
              _hasJumpedToInitialPost = true;
            }
          } else if (targetPosition > 0) {
            // targetPosition is 1-based, currentStartNum is 0-based
            // Convert targetPosition to 0-based index: targetPosition - 1
            // Then calculate relative position in the loaded list
            int targetIndex0Based = targetPosition - 1;
            int relativePosition = targetIndex0Based - data.currentStartNum;
            if (relativePosition >= 0 && relativePosition < postsList.length) {
              _pendingInitialScrollIndex = relativePosition;
              _hasJumpedToInitialPost = false; // Reset to allow jumping
            } else {
              // Relative position is out of range - this shouldn't happen if page was loaded correctly
              // Fallback: scroll to top of the page
              if (postsList.isNotEmpty) {
                _pendingInitialScrollIndex = 0;
                _hasJumpedToInitialPost = false; // Reset to allow jumping
              } else {
                _pendingInitialScrollIndex = null;
                _hasJumpedToInitialPost = true;
              }
            }
          } else {
            // No target position available, scroll to top
            if (postsList.isNotEmpty) {
              _pendingInitialScrollIndex = 0;
              _hasJumpedToInitialPost = false;
            } else {
              _pendingInitialScrollIndex = null;
              _hasJumpedToInitialPost = true;
            }
          }
        }
      } else {
        // No need to scroll, so mark as "jumped" to avoid unnecessary attempts
        _pendingInitialScrollIndex = null;
        _hasJumpedToInitialPost = true;
        AppLogger.debug('PostsList: No target position, skipping scroll');
      }

      // Enable scroll loading after initial load is complete and UI will be ready
      // Use a small delay to ensure the UI has had time to render
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _isScrollLoadingEnabled = true;
              AppLogger.debug('PostsList: Scroll loading enabled after initial load');
            }
          });
        });
      }
    } catch (e) {
      // Re-enable scroll loading even on error
      if (mounted) {
        _isScrollLoadingEnabled = true;
      }

      // Show user-friendly error message
      if (mounted) {
        final errorMessage = extractErrorMessage(e);
        // Capture ScaffoldMessengerState and theme to avoid using context after unmount
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final theme = Theme.of(context);
        final errorContainerColor = theme.colorScheme.errorContainer;
        final onErrorContainerColor = theme.colorScheme.onErrorContainer;

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: onErrorContainerColor,
                ),
                const SizedBox(width: DesignTokens.spacingM),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: onErrorContainerColor,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: errorContainerColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            ),
            margin: DesignTokens.paddingS,
            padding: EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingL - DesignTokens.spacingXS,
            ),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: AppLocalizations.of(context)?.dismiss ?? 'Dismiss',
              textColor: onErrorContainerColor,
              onPressed: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
            ),
          ),
        );
      }

      // Still rethrow to allow upper layers to handle if needed
      rethrow;
    }
  }

  void _onScroll() {
    // Don't process scroll events if scroll loading is disabled
    if (!_isScrollLoadingEnabled || _isLoadingMore || !_postsController.isInitialized.value) return;

    final itemPositions = _itemPositionsListener.itemPositions.value;
    if (itemPositions.isNotEmpty) {
      // Get the first visible item
      final firstVisibleItem = itemPositions.reduce((a, b) => a.index < b.index ? a : b);
      // Get the last visible item
      final lastVisibleItem = itemPositions.reduce((a, b) => a.index > b.index ? a : b);

      // Load earlier posts if we're near the top
      // Only trigger if:
      // 1. The first visible item is at index 0 (at the very top of the list)
      // 2. AND it's within 200px threshold (for smoother triggering)
      // 3. AND we haven't loaded earlier posts in the last 500ms (cooldown to prevent endless loading)
      if (firstVisibleItem.index == 0 && _hasMoreEarlier()) {
        final firstItemTop = firstVisibleItem.itemLeadingEdge;
        final now = DateTime.now();
        final canLoad = _lastEarlierLoadTime == null || now.difference(_lastEarlierLoadTime!) > const Duration(milliseconds: 500);

        // Only trigger if within threshold AND cooldown period has passed
        // This prevents re-triggering immediately after scroll restoration
        if (firstItemTop > 0 && firstItemTop <= 200 && canLoad) {
          _loadMoreEarlier();
        }
      }

      // Load later posts if we're near the bottom
      final data = _postsController.threadDataOutput.value;
      if (data != null) {
        final totalItems = data.loadedCount;
        if (lastVisibleItem.index >= totalItems - 3 && _hasMorePosts) {
          _loadMoreLater();
        }

        // Update mini poll bar visibility: hide when first post is on screen
        final bool newFirstPostVisible;
        if (data.currentStartNum > 0) {
          newFirstPostVisible = false; // First post not in list
        } else {
          final firstPostListIndex = (_isLoadingMore && _pagingDirection == _PagingDirection.earlier) ? 1 : 0;
          newFirstPostVisible = itemPositions.any((p) => p.index == firstPostListIndex);
        }
        if (newFirstPostVisible != _isFirstPostVisible && mounted) {
          setState(() {
            _isFirstPostVisible = newFirstPostVisible;
          });
        }
      }
    }
  }

  bool _hasMoreEarlier() {
    final data = _postsController.threadDataOutput.value;
    if (data == null) return false;
    return data.currentStartNum > 0;
  }

  void _updateHasMorePosts() {
    var data = _postsController.threadDataOutput.value;
    if (data == null) {
      _hasMorePosts = false;
      return;
    }
    int currentCount = data.loadedCount;
    _hasMorePosts = data.currentStartNum + currentCount < data.totalPosts;
  }

  /// Loads earlier posts (when user scrolls up near the top).
  ///
  /// Regardless of the initial mode, always uses getThreadAsync for paging.
  /// This ensures consistent merging and avoids jumping anchors.
  Future<void> _loadMoreEarlier() async {
    if (!mounted) return;
    if (!_postsController.isInitialized.value || _isLoadingMore || !_hasMoreEarlier()) return;

    // Temporarily disable scroll loading to prevent recursive calls
    _isScrollLoadingEnabled = false;
    _pagingDirection = _PagingDirection.earlier;

    // Track the post ID that's currently visible so we can restore to it after prepending
    String? currentVisiblePostId;
    try {
      final itemPositions = _itemPositionsListener.itemPositions.value;
      final data = _postsController.threadDataOutput.value;
      if (itemPositions.isNotEmpty && data != null && data.posts.isNotEmpty) {
        // Get the first visible item as reference point
        final firstVisibleItem = itemPositions.reduce((a, b) => a.index < b.index ? a : b);
        final firstVisibleIndex = firstVisibleItem.index;
        // Adjust for loading indicator if present
        final postIndex = firstVisibleIndex - (_isLoadingMore && _pagingDirection == _PagingDirection.earlier ? 1 : 0);
        if (postIndex >= 0 && postIndex < data.posts.length) {
          currentVisiblePostId = data.posts[postIndex].id;
        }
      }
    } catch (e) {
      AppLogger.debug('PostsList: Failed to get current scroll position: $e');
    }

    // Record the load time to prevent endless loading
    _lastEarlierLoadTime = DateTime.now();

    setState(() {
      _isLoadingMore = true;
    });
    try {
      final data = _postsController.threadDataOutput.value;
      if (data == null) return;
      final range = data.earlierRange(_pageSize);
      // earlierRange returns 0-based values, but getThreadAsync expects 1-based for the API
      final startNum1Based = range['startNum']! + 1; // Convert 0-based to 1-based
      final lastNum1Based = range['lastNum']! + 1; // Convert 0-based to 1-based

      // --- Always use normal loading for paging (earlier) ---
      // Even if initial load was unread or anchor, paging uses getThreadAsync for correct merging.
      // Always use the actual topicId from the loaded data (important for thread_by_post mode where widget.topicId is a placeholder)
      final topicIdToUse = data.topic.id.isNotEmpty ? data.topic.id : (_actualTopicId ?? widget.topicId);
      await _postsController.getThreadAsync(topicIdToUse, startNum1Based, lastNum1Based, _retriveHtml, mode: LoadMode.earlier);
      // --- End normal paging ---
      _updateHasMorePosts();

      // Restore scroll position to the post that was visible before loading
      // Find the post by ID in the new list and scroll to it
      if (currentVisiblePostId != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            final scrollData = _postsController.threadDataOutput.value;
            if (scrollData != null) {
              // Find the post by ID in the updated list
              final postIndex = scrollData.posts.indexWhere((p) => p.id == currentVisiblePostId);
              if (postIndex >= 0) {
                // When loading earlier posts, list has a loading card at index 0, so offset by 1.
                final scrollIndex = postIndex + (_isLoadingMore && _pagingDirection == _PagingDirection.earlier ? 1 : 0);
                // Scroll to the post without forcing alignment - this should maintain visual position better
                // Using a very short duration for smooth transition
                _itemScrollController.scrollTo(
                  index: scrollIndex,
                  duration: const Duration(milliseconds: 50),
                  curve: Curves.easeOut,
                );
                AppLogger.debug('PostsList: Restored scroll to post $currentVisiblePostId at index $scrollIndex');
              } else {
                AppLogger.debug('PostsList: Could not find post $currentVisiblePostId after loading earlier posts');
              }
            }
          } catch (e) {
            AppLogger.debug('PostsList: Failed to restore scroll position after loading earlier posts: $e');
          }
        });
      }
    } catch (e) {
      rethrow;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
        // Re-enable scroll loading after a brief delay to allow UI to stabilize
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _isScrollLoadingEnabled = true;
            AppLogger.debug('PostsList: Scroll loading re-enabled after loading earlier posts');
          }
        });
        _pagingDirection = _PagingDirection.none;
      }
    }
  }

  /// Loads later posts (when user scrolls down near the bottom).
  ///
  /// Regardless of the initial mode, always uses getThreadAsync for paging.
  /// This ensures consistent merging and avoids jumping anchors.
  Future<void> _loadMoreLater() async {
    if (!mounted) return;
    if (!_postsController.isInitialized.value || _isLoadingMore || !_hasMorePosts) return;

    // Temporarily disable scroll loading to prevent recursive calls
    _isScrollLoadingEnabled = false;
    _pagingDirection = _PagingDirection.later;

    setState(() {
      _isLoadingMore = true;
    });
    try {
      final data = _postsController.threadDataOutput.value;
      if (data == null) return;
      final range = data.laterRange(_pageSize);
      // laterRange returns 0-based values, but getThreadAsync expects 1-based for the API
      final startNum1Based = range['startNum']! + 1; // Convert 0-based to 1-based
      final lastNum1Based = range['lastNum']! + 1; // Convert 0-based to 1-based

      // --- Always use normal loading for paging (later) ---
      // Even if initial load was unread or anchor, paging uses getThreadAsync for correct merging.
      // Always use the actual topicId from the loaded data (important for thread_by_post mode where widget.topicId is a placeholder)
      final topicIdToUse = data.topic.id.isNotEmpty ? data.topic.id : (_actualTopicId ?? widget.topicId);
      await _postsController.getThreadAsync(topicIdToUse, startNum1Based, lastNum1Based, _retriveHtml, mode: LoadMode.later);
      // --- End normal paging ---
      _updateHasMorePosts();
    } catch (e) {
      rethrow;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
        // Re-enable scroll loading after a brief delay to allow UI to stabilize
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _isScrollLoadingEnabled = true;
            AppLogger.debug('PostsList: Scroll loading re-enabled after loading later posts');
          }
        });
        _pagingDirection = _PagingDirection.none;
      }
    }
  }

  /// Refreshes the current page of posts, similar to _loadMoreEarlier/_loadMoreLater but reloads the current page.
  /// This is intended for use as a refresh callback (e.g., pull-to-refresh).
  Future<void> _refreshCurrentPage() async {
    if (!mounted) return;
    if (!_postsController.isInitialized.value || _isLoadingMore) return;

    // Temporarily disable scroll loading during refresh
    _isScrollLoadingEnabled = false;

    setState(() {
      _isLoadingMore = true;
    });
    try {
      final data = _postsController.threadDataOutput.value;
      if (data == null) return;

      // Always use the actual topicId from the loaded data (important for thread_by_post mode where widget.topicId is a placeholder)
      // data.topic.id is guaranteed to be the correct topic ID since we already have the data loaded
      final topicIdToUse = data.topic.id.isNotEmpty ? data.topic.id : (_actualTopicId ?? widget.topicId);

      // currentStartNum is 0-based, but getThreadAsync expects 1-based for the API
      final startNum0Based = data.currentStartNum;
      final lastNum0Based = startNum0Based + _pageSize - 1;
      final startNum1Based = startNum0Based + 1; // Convert to 1-based
      final lastNum1Based = lastNum0Based + 1; // Convert to 1-based
      await _postsController.getThreadAsync(topicIdToUse, startNum1Based, lastNum1Based, _retriveHtml, mode: LoadMode.initial);
      _updateHasMorePosts();
    } catch (e) {
      rethrow;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
        // Re-enable scroll loading after a brief delay to allow UI to stabilize
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _isScrollLoadingEnabled = true;
            AppLogger.debug('PostsList: Scroll loading re-enabled after refresh');
          }
        });
      }
    }
  }

  /// Refresh callback that optionally scrolls to a post after load.
  /// When [scrollToPostId] is provided (e.g. after reply), loads thread at that post and scrolls to it in place.
  void _refreshWithOptionalScrollToPost([String? scrollToPostId]) {
    if (scrollToPostId != null && scrollToPostId.isNotEmpty) {
      _refreshAndScrollToPost(scrollToPostId);
    } else {
      _refreshCurrentPage();
    }
  }

  /// Loads the thread centered on [postId] and scrolls to that post, then highlights it.
  /// Used after replying so the user stays on the same screen (consistent with conversation reply).
  /// Clears [threadDataOutput] before loading so the list shows loading state and we replace
  /// with a single page centered on the new post instead of merging with previous data.
  Future<void> _refreshAndScrollToPost(String postId) async {
    if (!mounted) return;
    if (_isLoadingMore) return;

    _isScrollLoadingEnabled = false;
    _pagingDirection = _PagingDirection.none;
    _postsController.threadDataOutput.value = null;
    setState(() {
      _isLoadingMore = true;
    });
    try {
      await _postsController.getThreadByPostAsync(postId, _pageSize, _retriveHtml);
      if (!mounted) return;
      final data = _postsController.threadDataOutput.value;
      if (data != null && data.topic.id.isNotEmpty) {
        _actualTopicId = data.topic.id;
      }
      _updateHasMorePosts();
      // After reply refresh we loaded a page centered on the new post; that page often
      // extends to the end of the thread. If we already have the last post, do not
      // allow "load more later" or the scroll-to-bottom will trigger a merge that
      // duplicates posts (existing 8-18 + "later" 12-18 = duplicates).
      if (data != null && data.posts.isNotEmpty && data.totalPosts > 0) {
        final lastPostNumber = data.posts.last.postNumber ?? 0;
        if (lastPostNumber >= data.totalPosts) {
          _hasMorePosts = false;
        }
      }
      if (data != null && data.posts.isNotEmpty) {
        final index = data.posts.indexWhere((p) => p.id == postId);
        if (index >= 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            try {
              _itemScrollController.jumpTo(index: index);
              _highlightPost(postId);
            } catch (_) {}
          });
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _isScrollLoadingEnabled = true;
          }
        });
      }
    }
  }

  Widget _buildLoadingCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade500 : Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: avatar + name/time bars
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 160,
                        height: 14,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade800 : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade800 : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Body lines
            Container(
              width: double.infinity,
              height: 12,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 12,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 12,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            // Action row placeholders
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialShimmerList(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) => _buildLoadingCard(context),
    );
  }

  /// Calculates the height of the bottom toolbar to ensure proper padding
  double _getBottomToolbarHeight(BuildContext context) {
    // IconButton height: 48px
    // Vertical padding: DesignTokens.spacingS * 2 = 16px
    // SafeArea bottom padding: varies by device
    const double iconButtonHeight = 48.0;
    const double verticalPadding = DesignTokens.spacingS * 2;
    final double safeAreaBottom = MediaQuery.of(context).padding.bottom;
    return iconButtonHeight + verticalPadding + safeAreaBottom;
  }

  Widget _buildPostItem(BuildContext context, FCPost post, int postIndex, int postsListLength, ThreadViewData data, {bool isHighlighted = false}) {
    final avatarActions = AvatarActions();
    final imageActions = ImageActions(_postsController, siteContext: widget.siteContext);
    final postActionsHandler = PostActionsHandler(_postsController, widget.siteContext, fallbackForumId: widget.forumId);

    Widget postWidget = VisibilityDetector(
      key: Key('post_${post.id}'),
      onVisibilityChanged: (info) {
        if (!mounted) return;
        if (info.visibleFraction > 0.5) {
          final newIndex = (post.postNumber ?? 1) - 1;
          // Only update state if the visible post index actually changed
          if (_currentVisiblePostIndex != newIndex) {
            setState(() {
              _currentVisiblePostIndex = newIndex;
            });
          }
        }
      },
      child: PostListItem(
        siteContext: widget.siteContext,
        onAvatarTap: (userId, userName) => avatarActions.handleAvatarTap(context, widget.siteContext, userId, userName, postActionsHandler: postActionsHandler, onRefresh: _refreshCurrentPage),
        post: post,
        threadId: widget.topicId,
        topicTitle: widget.topicTitle,
        topicPrefix: data.topic.prefix,
        postController: _postsController,
        forumId: data.topic.forumId,
        isHighlighted: isHighlighted,
        poll: post.postNumber == 1 ? data.topic.poll : null,
        onVoteSuccess: (p) => _postsController.updateThreadPoll(p),
        actions: PostActions(
          onReply: (postId) => postActionsHandler.handleReply(context, postId, widget.topicId, widget.topicTitle, _refreshWithOptionalScrollToPost),
          onQuote: (postId, authorName, postText) => postActionsHandler.handleQuote(context, postId, authorName, postText, widget.topicId, widget.topicTitle, _refreshWithOptionalScrollToPost),
          onEdit:
              post.canEdit ? (postId, currentText) => postActionsHandler.handleEdit(context, postId, currentText, widget.topicTitle, widget.topicId, data.topic.forumId, _refreshCurrentPage) : null,
          onDelete: post.canDelete ? (postId) => postActionsHandler.handleDelete(context, postId) : null,
          onReport: post.canReport ? (postId) => postActionsHandler.handleReport(context, postId) : null,
          onShowImage: (imageUrl, context, heroTag) => imageActions.handleShowImage(imageUrl, context, heroTag, post.id),
          onRefresh: _refreshCurrentPage,
          onLoginRequired: (context) => postActionsHandler.showPostLoginPrompt(context, onRefresh: _refreshCurrentPage),
        ),
      ),
    );
    if (postIndex == postsListLength - 1) {
      // Add padding equal to the toolbar height so the last post can scroll above it
      final double toolbarHeight = _getBottomToolbarHeight(context);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          postWidget,
          SizedBox(height: toolbarHeight),
        ],
      );
    } else {
      return postWidget;
    }
  }

  void _showJumpToPostDialog(BuildContext context, ThreadViewData data) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Jump to Post',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_currentVisiblePostIndex + 1}',
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Slider(
                    value: (_currentVisiblePostIndex + 1).toDouble(),
                    min: 1,
                    max: data.totalPosts.toDouble(),
                    divisions: data.totalPosts - 1,
                    label: '${_currentVisiblePostIndex + 1}',
                    onChanged: (double value) {
                      setState(() {
                        _currentVisiblePostIndex = value.toInt() - 1;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (!mounted) return;
                Navigator.of(context).pop();
                int selectedPostIndex = _currentVisiblePostIndex + 1;
                int gotoPage = ((selectedPostIndex - 1) ~/ _pageSize) + 1;
                final data = _postsController.threadDataOutput.value;

                // Check if target post is already loaded and visible
                if (data != null && data.posts.isNotEmpty) {
                  // Calculate if the target post is in the currently loaded range
                  int targetIndex0Based = selectedPostIndex - 1; // Convert to 0-based
                  bool isInLoadedRange = targetIndex0Based >= data.currentStartNum && targetIndex0Based < data.currentStartNum + data.posts.length;

                  if (isInLoadedRange) {
                    // Try to find the post in the loaded list
                    int listIndex = data.posts.indexWhere((p) => (p.postNumber ?? 0) == selectedPostIndex);

                    if (listIndex >= 0) {
                      // Post is already loaded, just scroll to it and highlight
                      try {
                        final targetPost = data.posts[listIndex];
                        _itemScrollController.jumpTo(index: listIndex);

                        // Update visible index to reflect the jump
                        setState(() {
                          _currentVisiblePostIndex = selectedPostIndex - 1;
                        });

                        // Highlight the post after a short delay to ensure it's rendered
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Future.delayed(const Duration(milliseconds: 100), () {
                            if (mounted) {
                              _highlightPost(targetPost.id);
                            }
                          });
                        });

                        return;
                      } catch (e) {
                        AppLogger.debug('PostsList: Failed to scroll directly to post: $e');
                        // Fall through to reload
                      }
                    }
                  }
                }

                // Need to load a different page
                if (!mounted) return;

                // Disable scroll loading during jump operation
                _isScrollLoadingEnabled = false;

                setState(() {
                  _isLoadingMore = false;
                  _hasMorePosts = true;
                  _anchorPostId = null;
                  _gotoPage = gotoPage;
                  _postsController.threadDataOutput.value = null;
                });
                // Reset scroll position before loading new page
                final currentData = _postsController.threadDataOutput.value;
                if (currentData != null && currentData.posts.isNotEmpty) {
                  try {
                    _itemScrollController.jumpTo(index: 0);
                  } catch (e) {
                    AppLogger.debug('PostsList: Failed to reset scroll position in dialog: $e');
                  }
                }
                // startNum and lastNum are ignored for goto_page mode, but we pass them anyway
                // They should be 0-based, but _loadInitialPosts will convert when needed
                int startNum = 0;
                int lastNum = _pageSize - 1;
                await _loadInitialPosts(startNum, lastNum, PostsListMode.goto_page, gotoPost: selectedPostIndex);
              },
              child: Text(
                'Jump',
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, ThreadViewData data) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingS,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  onPressed: _jumpToFirstPost,
                  tooltip: AppLocalizations.of(context)?.goToTop ?? 'Go to top',
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  onPressed: _jumpToLastPost,
                  tooltip: AppLocalizations.of(context)?.goToBottom ?? 'Go to bottom',
                ),
                SizedBox(width: DesignTokens.spacingS),
                GestureDetector(
                  onTap: () {
                    _showJumpToPostDialog(context, data);
                  },
                  child: Text(
                    '${_currentVisiblePostIndex + 1} / ${data.totalPosts}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const Spacer(),
                if (widget.siteContext.isLoggedIn && data.topic.canReply)
                  FilledButton.icon(
                    onPressed: () {
                      final postActionsHandler = PostActionsHandler(_postsController, widget.siteContext, fallbackForumId: widget.forumId);
                      postActionsHandler.handleReply(context, "", widget.topicId, widget.topicTitle, _refreshWithOptionalScrollToPost);
                    },
                    icon: const Icon(Icons.reply),
                    label: Text(AppLocalizations.of(context)?.reply ?? 'Reply'),
                    style: StyleBuilders.extendedFilledButtonStyle(
                      colorScheme: Theme.of(context).colorScheme,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = _postsController.threadDataOutput.value;
      if (_postsController.isInitialized.value && data != null) {
        var postsList = data.posts;
        if (postsList.isEmpty && data.totalPosts > 0) {
          return _buildInitialShimmerList(context);
        }
        // Show mini poll bar only when thread has a poll and the full poll is not visible:
        // either we're not on the first page, or the first post has scrolled off screen.
        final showMiniPollBar = data.topic.hasPoll &&
            data.topic.poll != null &&
            (data.currentStartNum > 0 || !_isFirstPostVisible);
        final stack = Stack(
          children: [
            RefreshIndicator(
              onRefresh: _refreshCurrentPage,
              child: ScrollablePositionedList.builder(
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: postsList.length + 1 + (_isLoadingMore && _hasMoreEarlier() ? 1 : 0),
                itemBuilder: (context, index) {
                  int offset = 0;
                  if (_isLoadingMore && _pagingDirection == _PagingDirection.earlier && index == offset) {
                    return _buildLoadingCard(context);
                  }
                  int postIndex = index - (_isLoadingMore && _pagingDirection == _PagingDirection.earlier ? 1 : 0);
                  if (postIndex == postsList.length) {
                    if (_isLoadingMore && _pagingDirection == _PagingDirection.later) {
                      return _buildLoadingCard(context);
                    } else if (_hasMorePosts) {
                      return const SizedBox.shrink();
                    } else {
                      // End of discussion indicator
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text(
                            'End of the discussion',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ),
                      );
                    }
                  }
                  if (postIndex < postsList.length) {
                    final post = postsList[postIndex];
                    final isHighlighted = _highlightedPostId == post.id;
                    return _buildPostItem(context, post, postIndex, postsList.length, data, isHighlighted: isHighlighted);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            if (showMiniPollBar && data.topic.poll != null)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: ThreadPollMiniCard(
                  poll: data.topic.poll!,
                  onTap: _jumpToFirstPost,
                ),
              ),
            _buildBottomBar(context, data),
          ],
        );

        // Trigger scroll after ScrollablePositionedList is built
        if (_pendingInitialScrollIndex != null && !_hasJumpedToInitialPost) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _attemptInitialScroll();
          });
        }

        return stack;
      } else {
        return _buildInitialShimmerList(context);
      }
    });
  }

  /// Setup scroll listener for item positions
  void _setupScrollListener() {
    _itemPositionsListener.itemPositions.addListener(_onScroll);
  }

  /// Attempts to jump to the initial target post instantly without animation
  void _attemptInitialScroll() {
    AppLogger.debug('🔍 [PostsList] _attemptInitialScroll called: _hasJumpedToInitialPost=$_hasJumpedToInitialPost, _pendingInitialScrollIndex=$_pendingInitialScrollIndex');

    if (!mounted || _hasJumpedToInitialPost || _pendingInitialScrollIndex == null) {
      return;
    }

    final data = _postsController.threadDataOutput.value;
    if (data == null || data.posts.isEmpty) {
      return;
    }

    final targetListIndex = _pendingInitialScrollIndex!;
    final maxListIndexForPost = data.posts.length - 1;
    // Bounds check: avoid jumping to an out-of-range index (e.g. after reply refresh with different page).
    if (targetListIndex < 0 || targetListIndex > maxListIndexForPost) {
      return;
    }

    try {
      // Use jumpTo for instant positioning without animation (targetListIndex is the list index)
      _itemScrollController.jumpTo(index: targetListIndex);

      _hasJumpedToInitialPost = true; // Mark as jumped
      final postIndex = targetListIndex.clamp(0, data.posts.length - 1);
      final targetPost = data.posts[postIndex];

        // Get the target post and highlight it after a short delay to ensure it's visible
        // Wait a frame to ensure the scroll has completed and post is rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _highlightPost(targetPost.id);
          }
        });
      });
    } catch (_) {}
  }

  /// Highlights a post by ID and clears it after a few seconds
  void _highlightPost(String postId) {
    if (!mounted) return;

    // Cancel any existing timer
    _highlightTimer?.cancel();

    // Set the highlighted post
    setState(() {
      _highlightedPostId = postId;
    });

    // Clear highlight after 3 seconds
    _highlightTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _highlightedPostId = null;
        });
      }
    });

    AppLogger.debug('PostsList: Highlighting post $postId');
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onScroll);
    _highlightTimer?.cancel(); // Cancel timer on dispose
    // Dispose the controller to prevent memory leaks
    _postsController.dispose();
    super.dispose();
  }

  // Add these methods to encapsulate jump logic
  Future<void> _jumpToFirstPost() async {
    final data = _postsController.threadDataOutput.value;
    if (data == null || data.posts.isEmpty) return;

    // Only "just scroll" when we actually have the first post of the thread.
    // After getThreadByPostAsync (e.g. reply refresh) we can have currentStartNum=0
    // with a window of later posts (e.g. positions 8-18), so we must load the first page.
    final firstPostNumber = data.posts.first.postNumber ?? 0;
    final alreadyAtFirstPage = data.currentStartNum == 0 && firstPostNumber <= 1;
    if (alreadyAtFirstPage) {
      if (data.posts.isNotEmpty) {
        try {
          _itemScrollController.jumpTo(index: 0);
        } catch (e) {
          AppLogger.debug('PostsList: Failed to jump to first post: $e');
        }
      }
      return;
    }

    // Disable scroll loading during jump operation
    _isScrollLoadingEnabled = false;

    setState(() {
      _isLoadingMore = false;
      _hasMorePosts = true;
      _anchorPostId = null;
      _gotoPage = 1;
      _postsController.threadDataOutput.value = null;
    });
    int startNum = 0;
    int lastNum = _pageSize - 1;
    await _loadInitialPosts(startNum, lastNum, PostsListMode.goto_page, gotoPost: 1);
  }

  Future<void> _jumpToLastPost() async {
    final data = _postsController.threadDataOutput.value;
    if (data == null || data.posts.isEmpty) return;
    int totalPosts = data.totalPosts;
    int lastPage = ((totalPosts - 1) ~/ _pageSize) + 1;
    int lastPageStartNum = (lastPage - 1) * _pageSize;

    // Check if already at the last page
    if (data.currentStartNum == lastPageStartNum) {
      if (data.posts.isNotEmpty) {
        try {
          final lastIndex = data.loadedCount - 1;
          if (lastIndex >= 0 && lastIndex < data.posts.length) {
            _itemScrollController.jumpTo(index: lastIndex);
          }
        } catch (e) {
          AppLogger.debug('PostsList: Failed to jump to last post: $e');
        }
      }
      return;
    }

    // Disable scroll loading during jump operation
    _isScrollLoadingEnabled = false;

    setState(() {
      _isLoadingMore = false;
      _hasMorePosts = true;
      _anchorPostId = null;
      _gotoPage = lastPage;
      _postsController.threadDataOutput.value = null;
    });
    // lastPageStartNum is 0-based, but _loadInitialPosts will handle conversion for goto_page mode
    int startNum = lastPageStartNum;
    int lastNum = startNum + _pageSize - 1;
    await _loadInitialPosts(startNum, lastNum, PostsListMode.goto_page, gotoPost: totalPosts);
  }
}
