import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_flutter/controllers/topic_controller.dart';
import 'package:forumcopilot_flutter/views/post_page.dart';
import 'package:forumcopilot_flutter/views/listitems/topic_list_item.dart';
import 'package:forumcopilot_flutter/views/widgets/resettable_widget.dart';
import 'package:forumcopilot_flutter/views/widgets/not_signed_in_view.dart';
import 'package:forumcopilot_flutter/views/tabs/topic_list_tab.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import '../../theme/design_tokens.dart';
import '../../core/logging/app_logger.dart';

class UnreadTopicsList extends StatefulWidget {
  final SiteContext siteContext;
  final bool isActive;
  const UnreadTopicsList({Key? key, required this.siteContext, required this.isActive}) : super(key: key);

  @override
  UnreadTopicsListState createState() => UnreadTopicsListState();
}

class UnreadTopicsListState extends FCStatefulWidget<UnreadTopicsList> with FCListStatefulWidget<UnreadTopicsList>, AutomaticKeepAliveClientMixin {
  bool _hasLoaded = false;
  bool _isInitialLoading = false;
  UnreadTopicController? _unreadTopicController;

  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  final int _pageSize = 20;
  int _currentPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(covariant UnreadTopicsList oldWidget) {
    super.didUpdateWidget(oldWidget);

    AppLogger.debug('🔄 [UNREAD_TOPICS] didUpdateWidget called');
    AppLogger.debug('  - oldWidget.isActive: ${oldWidget.isActive}');
    AppLogger.debug('  - widget.isActive: ${widget.isActive}');
    AppLogger.debug('  - _hasLoaded: $_hasLoaded');
    AppLogger.debug('  - _unreadTopicController: ${_unreadTopicController != null ? "exists" : "null"}');
    AppLogger.debug('  - Get.isRegistered: ${Get.isRegistered<UnreadTopicController>()}');

    // Initialize controller when tab becomes active
    final tabJustBecameActive = !oldWidget.isActive && widget.isActive;
    AppLogger.debug('  - tabJustBecameActive: $tabJustBecameActive');

    if (tabJustBecameActive && widget.siteContext.isLoggedIn) {
      _isInitialLoading = true;
      if (mounted) {
        setState(() {});
      }
      AppLogger.debug('✅ [UNREAD_TOPICS] Tab just became active!');
      if (!Get.isRegistered<UnreadTopicController>()) {
        AppLogger.debug('  → Controller not registered, initializing...');
        _initializeController();
      } else {
        AppLogger.debug('  → Controller already registered, getting it...');
        _unreadTopicController = Get.find<UnreadTopicController>();
        AppLogger.debug('  → Controller state:');
        AppLogger.debug('    - isInitialized: ${_unreadTopicController?.isInitialized.value}');
        AppLogger.debug('    - fcTopics.length: ${_unreadTopicController?.fcTopics.length}');
        // Always force UI update when tab becomes active
        if (mounted) {
          AppLogger.debug('  → Calling setState() to force UI update');
          setState(() {});
        }
        if (!_hasLoaded) {
          AppLogger.debug('  → Data not loaded yet, initializing data...');
          _initializeData();
        } else {
          AppLogger.debug('  → Data already loaded, skipping _initializeData()');
        }
      }
    }

    // Load data if tab is active, user is logged in, and we haven't loaded yet
    if (widget.isActive && !_hasLoaded && widget.siteContext.isLoggedIn) {
      if (_unreadTopicController != null) {
        AppLogger.debug('  → Tab is active but data not loaded, initializing data...');
        _initializeData();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Only initialize controller if tab is already active when created
    if (widget.isActive && widget.siteContext.isLoggedIn) {
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
    AppLogger.debug('🔧 [UNREAD_TOPICS] _initializeController called');
    if (Get.isRegistered<UnreadTopicController>()) {
      AppLogger.debug('  → Deleting existing controller');
      Get.delete<UnreadTopicController>();
    }

    _unreadTopicController = Get.put(UnreadTopicController());
    AppLogger.debug('  → Controller created and registered in GetX');
    AppLogger.debug('    - isInitialized: ${_unreadTopicController?.isInitialized.value}');
    AppLogger.debug('    - Get.isRegistered: ${Get.isRegistered<UnreadTopicController>()}');

    // Force a rebuild to ensure parent's Obx can observe the controller
    if (mounted) {
      AppLogger.debug('  → Forcing rebuild after controller creation');
      setState(() {});
    }

    // Don't call _initializeData() here - let didUpdateWidget() or initState() handle it
    if (widget.isActive && widget.siteContext.isLoggedIn && !_hasLoaded) {
      AppLogger.debug('  → Widget is active, calling _initializeData()');
      await _initializeData();
    } else {
      AppLogger.debug('  → Skipping _initializeData() (isActive: ${widget.isActive}, isLoggedIn: ${widget.siteContext.isLoggedIn}, _hasLoaded: $_hasLoaded)');
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
    if (_unreadTopicController != null) {
      _unreadTopicController!.unreadTopicsDataOutput.value = FCUnreadTopicResult(
        result: false,
        resultText: '',
        totalUnreadNum: 0,
        topics: [],
      );
      _unreadTopicController!.fcTopics.clear();
    }
    if (Get.isRegistered<UnreadTopicController>()) {
      Get.delete<UnreadTopicController>();
    }
    _unreadTopicController = null;
  }

  @override
  Future<void> refreshList() async {
    await resetList();
    return Future.value();
  }

  Future<void> _initializeData() async {
    AppLogger.debug('📥 [UNREAD_TOPICS] _initializeData called');
    AppLogger.debug('  - widget.isActive: ${widget.isActive}');
    AppLogger.debug('  - _hasLoaded: $_hasLoaded');
    AppLogger.debug('  - isLoggedIn: ${widget.siteContext.isLoggedIn}');
    AppLogger.debug('  - _unreadTopicController: ${_unreadTopicController != null ? "exists" : "null"}');

    if (widget.isActive && !_hasLoaded && widget.siteContext.isLoggedIn && _unreadTopicController != null) {
      _isInitialLoading = true;
      if (mounted) {
        setState(() {});
      }
      try {
        AppLogger.debug('  → Starting API call...');
        _currentPage = 0;
        int startNum = 0;
        int lastNum = _pageSize - 1;
        await _unreadTopicController!.getUnreadTopicAsync(startNum, lastNum);

        AppLogger.debug('  ✅ API call completed');
        AppLogger.debug('    - controller.isInitialized: ${_unreadTopicController!.isInitialized.value}');
        AppLogger.debug('    - controller.fcTopics.length: ${_unreadTopicController!.fcTopics.length}');
        AppLogger.debug('    - controller.unreadTopicsDataOutput.total_topic_num: ${_unreadTopicController!.unreadTopicsDataOutput.value.total_topic_num}');

        _hasLoaded = true;
        AppLogger.debug('  → _hasLoaded set to true');

        // Notify parent to rebuild - simple and direct
        if (mounted) {
          AppLogger.debug('  → Widget is mounted, calling setState() and notifying parent');
          setState(() {});

          // Notify parent to rebuild - find parent TopicListTabState and call notifyDataLoaded
          final parentState = context.findAncestorStateOfType<TopicListTabState>();
          if (parentState != null) {
            AppLogger.debug('  → Found parent TopicListTabState, calling notifyDataLoaded()');
            parentState.notifyDataLoaded();
          } else {
            AppLogger.debug('  → Parent TopicListTabState not found');
          }
        } else {
          AppLogger.debug('  → Widget not mounted, skipping setState()');
        }
      } catch (e) {
        AppLogger.debug('  ❌ Error in _initializeData: $e');
        if (e is FCApiException) {
          setError(e.message);
          if (mounted) {
            setState(() {});
          }
        } else {
          rethrow;
        }
      } finally {
        _isInitialLoading = false;
      }
    } else {
      AppLogger.debug('  → Skipping _initializeData() - conditions not met');
    }
  }

  Future<void> _loadMore() async {
    if (_unreadTopicController == null || !_unreadTopicController!.isInitialized.value) return;
    var currentData = _unreadTopicController!.unreadTopicsDataOutput.value;
    int currentCount = currentData.topics.length;
    if (currentCount >= currentData.total_topic_num) {
      return;
    }

    _isLoadingMore = true;
    if (mounted) setState(() {});
    try {
      _currentPage += 1;
      int startNum = _currentPage * _pageSize;
      int lastNum = startNum + _pageSize - 1;
      await _unreadTopicController!.getUnreadTopicAsync(startNum, lastNum);
      if (mounted) setState(() {});
    } catch (e) {
      rethrow;
    } finally {
      _isLoadingMore = false;
      if (mounted) setState(() {});
    }
  }

  // Public method to load more - can be called from parent
  Future<void> loadMore() async {
    await _loadMore();
  }

  // Check if there are more items to load
  bool get hasMoreItems {
    if (_unreadTopicController == null || !_unreadTopicController!.isInitialized.value) return false;
    var currentData = _unreadTopicController!.unreadTopicsDataOutput.value;
    int currentCount = currentData.topics.length;
    return currentCount < currentData.total_topic_num;
  }

  // Get topic items as List<Widget> for use in parent ListView
  List<Widget> buildTopicItems() {
    if (!_hasLoaded || _isInitialLoading) {
      return [const Center(child: CircularProgressIndicator())];
    }
    // Try to get controller from local reference first, then from GetX
    UnreadTopicController? controller = _unreadTopicController;
    if (controller == null && Get.isRegistered<UnreadTopicController>()) {
      controller = Get.find<UnreadTopicController>();
      _unreadTopicController = controller; // Update local reference
    }

    if (controller == null || !controller.isInitialized.value) {
      return [const Center(child: CircularProgressIndicator())];
    }

    var topicsList = controller.fcTopics;
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
            Get.to(() => PostPage(siteContext: widget.siteContext, topicId: topic.id, title: topic.title, forumId: topic.forumId));
          },
          onMarkAsRead: (topicId) {
            controller!.markTopicAsRead(topicId);
          },
        ),
      );
    }

    // No loading indicator - removed spinner

    return items;
  }

  // Get empty state widget
  Widget? buildEmptyState() {
    if (!_hasLoaded || _isInitialLoading) return null;
    // Try to get controller from local reference first, then from GetX
    UnreadTopicController? controller = _unreadTopicController;
    if (controller == null && Get.isRegistered<UnreadTopicController>()) {
      controller = Get.find<UnreadTopicController>();
      _unreadTopicController = controller; // Update local reference
    }

    if (controller == null || !controller.isInitialized.value) return null;
    var topicsList = controller.fcTopics;
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
              Icons.inbox_rounded,
              size: DesignTokens.avatarSizeXL, // 64px - matches NotSignedInView
              color: colorScheme.primary,
            ),
            SizedBox(height: DesignTokens.spacingXL - DesignTokens.spacingXS), // 20px - matches NotSignedInView
            Text(
              AppLocalizations.of(context)!.youAreAllCaughtUp,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: DesignTokens.fontWeightBold,
                fontSize: DesignTokens.fontSizeL, // Match NotSignedInView title size
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacingS), // Match NotSignedInView
            Text(
              AppLocalizations.of(context)!.thereAreNoUnreadTopics,
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
    if (!widget.siteContext.isLoggedIn) {
      return NotSignedInView(
        siteContext: widget.siteContext,
        title: AppLocalizations.of(context)!.signInToViewUnreadTopics,
        message: AppLocalizations.of(context)!.youNeedToBeSignedInToViewUnreadTopics,
        icon: Icons.lock_outline_rounded,
      );
    }
    if (super.isError.value) {
      final errorMessage = super.errorMessage;
      if (errorMessage.contains('not logged in') || errorMessage.contains('do not have permission') || errorMessage.contains('permission to do this action')) {
        return NotSignedInView(
          siteContext: widget.siteContext,
          title: AppLocalizations.of(context)?.signInToViewUnreadTopics ?? 'Sign in to view unread topics',
          message: 'You need to be signed in to view topics your unread topics.',
          icon: Icons.lock_outline_rounded,
        );
      }
    }
    return null;
  }

  // Build empty state widget
  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: DesignTokens.paddingXXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 80,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.youAreAllCaughtUp,
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.thereAreNoUnreadTopics,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    AppLogger.debug('🎨 [UNREAD_TOPICS] build() called');
    AppLogger.debug('  - widget.isActive: ${widget.isActive}');
    AppLogger.debug('  - isLoggedIn: ${widget.siteContext.isLoggedIn}');
    AppLogger.debug('  - _hasLoaded: $_hasLoaded');
    AppLogger.debug('  - _unreadTopicController: ${_unreadTopicController != null ? "exists" : "null"}');
    AppLogger.debug('  - Get.isRegistered: ${Get.isRegistered<UnreadTopicController>()}');

    // Not logged in
    if (!widget.siteContext.isLoggedIn) {
      AppLogger.debug('  → Returning NotSignedInView (not logged in)');
      return NotSignedInView(
        siteContext: widget.siteContext,
        title: 'Sign in to view unread topics',
        message: 'You need to be signed in to view your unread topics.',
        icon: Icons.lock_outline_rounded,
      );
    }

    // Error state
    if (super.isError.value) {
      AppLogger.debug('  → Error state detected: ${super.errorMessage}');
      final errorMessage = super.errorMessage;
      if (errorMessage.contains('not logged in') || errorMessage.contains('do not have permission') || errorMessage.contains('permission to do this action')) {
        return NotSignedInView(
          siteContext: widget.siteContext,
          title: AppLocalizations.of(context)?.signInToViewUnreadTopics ?? 'Sign in to view unread topics',
          message: 'You need to be signed in to view your unread topics.',
          icon: Icons.lock_outline_rounded,
        );
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${AppLocalizations.of(context)!.errorTitle}: $errorMessage'),
            ElevatedButton(
              onPressed: () => resetList(),
              child: Text(AppLocalizations.of(context)!.retryButton),
            ),
          ],
        ),
      );
    }

    // Check controller - prioritize local reference over Get.isRegistered check
    // The local reference is more reliable since GetX might have unregistered it
    if (_unreadTopicController == null) {
      if (Get.isRegistered<UnreadTopicController>()) {
        AppLogger.debug('  → Controller registered in GetX but local reference is null, getting it...');
        _unreadTopicController = Get.find<UnreadTopicController>();
      } else {
        // If controller doesn't exist and we haven't loaded yet, show spinner
        // Only show empty state if we've already tried to load and there's nothing
        if ((!_hasLoaded || _isInitialLoading) && widget.isActive) {
          AppLogger.debug('  → Controller not registered, tab is active but not loaded yet, showing spinner');
          return const Center(child: CircularProgressIndicator());
        }
        AppLogger.debug('  → Controller not registered and local reference is null, returning empty state');
        return _buildEmptyState();
      }
    }

    final controller = _unreadTopicController!;
    if (_isInitialLoading && widget.isActive) {
      return const Center(child: CircularProgressIndicator());
    }
    AppLogger.debug('  → Using controller from local reference');
    AppLogger.debug('  → Controller exists');
    AppLogger.debug('    - isInitialized: ${controller.isInitialized.value}');
    AppLogger.debug('    - fcTopics.length: ${controller.fcTopics.length}');
    AppLogger.debug('    - total_topic_num: ${controller.unreadTopicsDataOutput.value.total_topic_num}');

    // If not initialized yet, show spinner while loading
    if (!controller.isInitialized.value) {
      AppLogger.debug('  → Controller not initialized, showing spinner');
      return const Center(child: CircularProgressIndicator());
    }

    // Get topics
    final topics = controller.fcTopics;
    final totalTopics = controller.unreadTopicsDataOutput.value.total_topic_num;
    AppLogger.debug('  → Topics: ${topics.length}, Total: $totalTopics');

    // Empty state
    if (topics.isEmpty) {
      AppLogger.debug('  → Topics list is empty, returning empty state');
      return _buildEmptyState();
    }

    // List of topics
    AppLogger.debug('  → Returning ListView with ${topics.length} topics');
    return RefreshIndicator(
      onRefresh: refreshList,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: topics.length + (topics.length < totalTopics ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < topics.length) {
            final topic = topics[index];
            return TopicListItem(
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
                Get.to(() => PostPage(
                      siteContext: widget.siteContext,
                      topicId: topic.id,
                      title: topic.title,
                      forumId: topic.forumId,
                    ));
              },
              onMarkAsRead: (topicId) {
                controller.markTopicAsRead(topicId);
                setState(() {}); // Refresh UI after marking as read
              },
            );
          } else {
            // Show spinner when loading more items
            if (_isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    clearList();
    _scrollController.dispose();
    super.dispose();
  }
}
