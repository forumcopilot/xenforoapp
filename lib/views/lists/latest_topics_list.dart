import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_flutter/controllers/topic_controller.dart';
import 'package:forumcopilot_flutter/views/post_page.dart';
import 'package:forumcopilot_flutter/views/listitems/topic_list_item.dart';
import 'package:forumcopilot_flutter/views/lists/posts_list.dart';
import 'package:forumcopilot_flutter/views/widgets/resettable_widget.dart';
import 'package:forumcopilot_flutter/views/widgets/not_signed_in_view.dart';
import 'package:forumcopilot_flutter/views/tabs/topic_list_tab.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart' as forumcopilot_sdk;
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import '../../theme/design_tokens.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class LatestTopicsList extends StatefulWidget {
  final SiteContext siteContext;
  final bool isActive;
  const LatestTopicsList({super.key, required this.siteContext, required this.isActive});

  @override
  LatestTopicsListState createState() => LatestTopicsListState();
}

class LatestTopicsListState extends FCStatefulWidget<LatestTopicsList> with FCListStatefulWidget<LatestTopicsList>, AutomaticKeepAliveClientMixin {
  bool _hasLoaded = false;
  bool _isInitialLoading = false;

  LatestTopicController? _latestTopicController;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  final int _pageSize = 20;
  int _currentPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(covariant LatestTopicsList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Initialize controller when tab becomes active
    final tabJustBecameActive = !oldWidget.isActive && widget.isActive;
    if (tabJustBecameActive) {
      _isInitialLoading = true;
      if (mounted) {
        setState(() {});
      }
      if (!Get.isRegistered<LatestTopicController>()) {
        _initializeController();
      } else {
        _latestTopicController = Get.find<LatestTopicController>();
        if (!_hasLoaded) {
          _initializeData();
        }
      }
    }

    // Load data if tab is active and we haven't loaded yet
    // Parent (TopicListTab) handles credential changes and calls resetList()
    if (widget.isActive && !_hasLoaded) {
      if (_latestTopicController != null) {
        _initializeData();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Only initialize controller if tab is already active when created
    if (widget.isActive) {
      _isInitialLoading = true;
      _initializeController();
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 && !_isLoadingMore) {
        _loadMore();
      }
    });
  }

  Future<void> _initializeController() async {
    if (Get.isRegistered<LatestTopicController>()) {
      Get.delete<LatestTopicController>();
    }
    _latestTopicController = Get.put(LatestTopicController());
    // Don't call _initializeData() here - let didUpdateWidget() or initState() handle it
    if (widget.isActive && !_hasLoaded) {
      await _initializeData();
    }
  }

  @override
  Future<void> resetList() async {
    clearList();
    // Scroll back to top if needed
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    await _initializeController();
  }

  void clearList() {
    _hasLoaded = false;
    _isInitialLoading = false;
    _currentPage = 0;
    _isLoadingMore = false;
    clearError();
    if (_latestTopicController != null) {
      _latestTopicController!.latestTopicsDataOutput.value = forumcopilot_sdk.FCLatestTopicResult(
        result: false,
        resultText: '',
        totalLatestNum: 0,
        topics: [],
      );
      _latestTopicController!.fcTopics.clear();
    }
    if (Get.isRegistered<LatestTopicController>()) {
      Get.delete<LatestTopicController>();
    }
    _latestTopicController = null;
  }

  @override
  Future<void> refreshList() async {
    await resetList();
    return Future.value();
  }

  Future<void> _initializeData() async {
    // Latest topics are public and should load even when not logged in
    if (widget.isActive && !_hasLoaded && _latestTopicController != null) {
      _isInitialLoading = true;
      if (mounted) {
        setState(() {});
      }
      try {
        _currentPage = 0;
        int startNum = 0;
        int lastNum = _pageSize - 1;
        await _latestTopicController!.getLatestTopicAsync(startNum, lastNum);

        // Mark as loaded even if result is false - this prevents endless loading
        // The UI will handle displaying the error/NotSignedInView based on result.result
        _hasLoaded = true;

        // Notify parent to rebuild - simple and direct
        if (mounted) {
          setState(() {});

          // Notify parent to rebuild - find parent TopicListTabState and call notifyDataLoaded
          final parentState = context.findAncestorStateOfType<TopicListTabState>();
          if (parentState != null) {
            parentState.notifyDataLoaded();
          }
        }
      } catch (e) {
        if (e is forumcopilot_sdk.FCApiException) {
          setError(e.message);
          if (mounted) setState(() {}); // Trigger rebuild to show error
        } else {
          rethrow;
        }
      } finally {
        _isInitialLoading = false;
      }
    }
  }

  Future<void> _loadMore() async {
    if (_latestTopicController == null || !_latestTopicController!.isInitialized.value) return;
    var currentData = _latestTopicController!.latestTopicsDataOutput.value;
    int currentCount = currentData.topics.length;
    if (currentCount >= currentData.total_topic_num) {
      return;
    }

    // Set the flag immediately to prevent re-entry
    _isLoadingMore = true;
    setState(() {});
    try {
      _currentPage += 1;
      int startNum = _currentPage * _pageSize;
      int lastNum = startNum + _pageSize - 1;
      await _latestTopicController!.getLatestTopicAsync(startNum, lastNum);
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  // Public method to load more - can be called from parent
  Future<void> loadMore() async {
    await _loadMore();
  }

  // Check if there are more items to load
  bool get hasMoreItems {
    if (_latestTopicController == null || !_latestTopicController!.isInitialized.value) return false;
    var currentData = _latestTopicController!.latestTopicsDataOutput.value;
    int currentCount = currentData.topics.length;
    return currentCount < currentData.total_topic_num;
  }

  // Get topic items as List<Widget> for use in parent ListView
  List<Widget> buildTopicItems() {
    if (!_hasLoaded || _isInitialLoading) {
      return [const Center(child: CircularProgressIndicator())];
    }
    if (_latestTopicController == null || !_latestTopicController!.isInitialized.value) {
      return [const Center(child: CircularProgressIndicator())];
    }

    var topicsList = _latestTopicController!.fcTopics;
    List<Widget> items = [];

    for (var topic in topicsList) {
      items.add(
        TopicListItem(
          siteContext: widget.siteContext,
          topic: topic,
          onTap: () async {
            if (!widget.siteContext.isLoggedIn) {
              if (!Get.isRegistered<LoginController>()) {
                Get.put(LoginController());
              }
              final loginController = Get.find<LoginController>();
              final loginResult = await loginController.attemptAutomaticLogin(widget.siteContext);
              if (!loginResult.success && loginResult.hadCredentials && Get.currentRoute != '/LoginPage') {
                await Get.to(() => LoginPage(siteContext: widget.siteContext));
              }
            }
            // Only use first_unread mode if user is logged in (it requires authentication)
            // Otherwise, use normal mode which doesn't require authentication
            final mode = widget.siteContext.isLoggedIn ? PostsListMode.first_unread : PostsListMode.normal;
            AppLogger.debug('🔍 [LatestTopicsList] Topic tapped: topicId=${topic.id}, isLoggedIn=${widget.siteContext.isLoggedIn}, mode=$mode');
            Get.to(() => PostPage(siteContext: widget.siteContext, topicId: topic.id, title: topic.title, mode: mode, forumId: topic.forumId));
          },
          onMarkAsRead: (topicId) {
            _latestTopicController!.markTopicAsRead(topicId);
          },
        ),
      );
    }

    // Add loading indicator if there are more items
    if (_isLoadingMore || (topicsList.length < _latestTopicController!.latestTopicsDataOutput.value.total_topic_num && topicsList.isNotEmpty)) {
      items.add(
        const Padding(
          padding: DesignTokens.paddingS,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return items;
  }

  // Get empty state widget
  Widget? buildEmptyState() {
    if (!_hasLoaded || _isInitialLoading) return null;
    if (_latestTopicController == null || !_latestTopicController!.isInitialized.value) return null;
    var topicsList = _latestTopicController!.fcTopics;
    if (topicsList.isNotEmpty) return null;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: DesignTokens.paddingXXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.forum_outlined,
              size: DesignTokens.avatarSizeXL, // 64px - matches NotSignedInView
              color: colorScheme.primary,
            ),
            SizedBox(height: DesignTokens.spacingXL - DesignTokens.spacingXS), // 20px - matches NotSignedInView
            Text(
              AppLocalizations.of(context)!.noLatestTopics,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: DesignTokens.fontWeightBold,
                fontSize: DesignTokens.fontSizeL, // Match NotSignedInView title size
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacingS), // Match NotSignedInView
            Text(
              AppLocalizations.of(context)!.noRecentTopicsToDisplay,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: DesignTokens.fontSizeS, // Match NotSignedInView message size
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Get error/not signed in widget
  Widget? buildErrorOrNotSignedInWidget() {
    if (_latestTopicController == null) return null;
    // Check if API returned result: false with permission/login message
    final result = _latestTopicController!.latestTopicsDataOutput.value;
    final resultText = result.resultText;
    if (!result.result && resultText != null && resultText.isNotEmpty) {
      final lowerResultText = resultText.toLowerCase();
      // Check if the error message indicates login/permission required
      if (lowerResultText.contains('not logged in') ||
          lowerResultText.contains('do not have permission') ||
          lowerResultText.contains('permission to') ||
          lowerResultText.contains('please log in') ||
          lowerResultText.contains('log in to access')) {
        // Show login prompt if user is not logged in
        if (!widget.siteContext.isLoggedIn) {
          return NotSignedInView(
            siteContext: widget.siteContext,
            title: AppLocalizations.of(context)!.signInToViewLatestTopics,
            message: AppLocalizations.of(context)?.youNeedToBeSignedInToViewLatestTopics ?? resultText,
            icon: Icons.lock_outline_rounded,
          );
        }
      }
    }
    return null;
  }

  // Get loading widget
  Widget? buildLoadingWidget() {
    if (_latestTopicController == null || !_latestTopicController!.isInitialized.value) {
      return const Center(child: CircularProgressIndicator());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    // This list's own frame is never on screen. TopicListTab keeps it
    // mounted (Offstage) for its data and draws the rows itself through
    // buildTopicItems() / buildErrorOrNotSignedInWidget().
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    clearList();
    _scrollController.dispose();
    super.dispose();
  }
}
