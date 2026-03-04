import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/widgets/error_or_child.dart';
import 'package:forumcopilot_sdk/network/fc_api_exception.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_flutter/controllers/topic_controller.dart';
import 'package:forumcopilot_flutter/views/post_page.dart';
import 'package:forumcopilot_flutter/views/listitems/topic_list_item.dart';
import 'package:forumcopilot_flutter/views/lists/posts_list.dart';
import 'package:forumcopilot_flutter/settings_context.dart';
import 'package:forumcopilot_flutter/views/widgets/resettable_widget.dart';
import 'package:forumcopilot_flutter/views/widgets/not_signed_in_view.dart';
import 'package:forumcopilot_flutter/views/tabs/topic_list_tab.dart';
import 'package:forumcopilot_sdk/models/results/fc_subscription_result.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import '../../theme/design_tokens.dart';

class SubscribedTopicsList extends StatefulWidget {
  final SiteContext siteContext;
  final bool isActive;
  const SubscribedTopicsList({super.key, required this.siteContext, required this.isActive});

  @override
  SubscribedTopicsListState createState() => SubscribedTopicsListState();
}

class SubscribedTopicsListState extends FCStatefulWidget<SubscribedTopicsList> with FCListStatefulWidget<SubscribedTopicsList>, AutomaticKeepAliveClientMixin {
  bool _hasLoaded = false;
  bool _isInitialLoading = false;
  SubscribedTopicController? _subscribedTopicController;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  final int _pageSize = 20;
  int _currentPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(covariant SubscribedTopicsList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Initialize controller when tab becomes active
    final tabJustBecameActive = !oldWidget.isActive && widget.isActive;
    if (tabJustBecameActive && widget.siteContext.isLoggedIn) {
      _isInitialLoading = true;
      if (mounted) {
        setState(() {});
      }
      if (!Get.isRegistered<SubscribedTopicController>()) {
        _initializeController();
      } else {
        _subscribedTopicController = Get.find<SubscribedTopicController>();
        if (!_hasLoaded) {
          _initializeData();
        }
      }
    }

    // Load data if tab is active, user is logged in, and we haven't loaded yet
    // Parent (TopicListTab) handles credential changes and calls resetList()
    if (widget.isActive && !_hasLoaded && widget.siteContext.isLoggedIn) {
      if (_subscribedTopicController != null) {
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
    if (Get.isRegistered<SubscribedTopicController>()) {
      Get.delete<SubscribedTopicController>();
    }

    _subscribedTopicController = Get.put(SubscribedTopicController());
    // Don't call _initializeData() here - let didUpdateWidget() or initState() handle it
    if (widget.isActive && widget.siteContext.isLoggedIn && !_hasLoaded) {
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
    if (_subscribedTopicController != null) {
      _subscribedTopicController!.subscribedTopicsDataOutput.value = FCSubscribedTopicResult(
        result: false,
        resultText: '',
        totalTopicNum: 0,
        topics: [],
      );
      _subscribedTopicController!.fcTopics.clear();
    }
    if (Get.isRegistered<SubscribedTopicController>()) {
      Get.delete<SubscribedTopicController>();
    }
    _subscribedTopicController = null;
  }

  @override
  Future<void> refreshList() async {
    await resetList();
    return Future.value();
  }

  Future<void> _initializeData() async {
    if (widget.isActive && !_hasLoaded && widget.siteContext.isLoggedIn && _subscribedTopicController != null) {
      _isInitialLoading = true;
      if (mounted) {
        setState(() {});
      }
      try {
        _currentPage = 0;
        int startNum = 0;
        int lastNum = _pageSize - 1;
        await _subscribedTopicController!.getSubscribedTopicAsync(startNum, lastNum);

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
        if (e is FCApiException) {
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
    if (_subscribedTopicController == null || !_subscribedTopicController!.isInitialized.value) return;
    var currentData = _subscribedTopicController!.subscribedTopicsDataOutput.value;
    int currentCount = currentData.topics.length;
    if (currentCount >= (currentData.total_topic_num ?? 0)) {
      return;
    }

    // Set the flag immediately to prevent re-entry
    _isLoadingMore = true;
    setState(() {});
    try {
      _currentPage += 1;
      int startNum = _currentPage * _pageSize;
      int lastNum = startNum + _pageSize - 1;
      await _subscribedTopicController!.getSubscribedTopicAsync(startNum, lastNum);
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
    if (_subscribedTopicController == null || !_subscribedTopicController!.isInitialized.value) return false;
    var currentData = _subscribedTopicController!.subscribedTopicsDataOutput.value;
    int currentCount = currentData.topics.length;
    return currentCount < (currentData.total_topic_num ?? 0);
  }

  // Get topic items as List<Widget> for use in parent ListView
  List<Widget> buildTopicItems() {
    if (!_hasLoaded || _isInitialLoading) {
      return [const Center(child: CircularProgressIndicator())];
    }
    if (_subscribedTopicController == null || !_subscribedTopicController!.isInitialized.value) {
      return [const Center(child: CircularProgressIndicator())];
    }

    var topicsList = _subscribedTopicController!.fcTopics;
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
            final int pageSize = SettingsContext.instance.pagePerSize.value;
            final int totalPostNum = topic.replyCount + 1;
            final int gotoPage = (totalPostNum - 1) ~/ pageSize + 1;
            Get.to(() => PostPage(
                  siteContext: widget.siteContext,
                  topicId: topic.id,
                  title: topic.title,
                  mode: PostsListMode.first_unread,
                  gotoPage: gotoPage,
                  forumId: topic.forumId,
                ));
          },
        ),
      );
    }

    // Add loading indicator if there are more items
    if (_isLoadingMore || (topicsList.length < (_subscribedTopicController!.subscribedTopicsDataOutput.value.total_topic_num ?? 0) && topicsList.isNotEmpty)) {
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
    if (_subscribedTopicController == null || !_subscribedTopicController!.isInitialized.value) return null;
    var topicsList = _subscribedTopicController!.fcTopics;
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
              Icons.watch_rounded,
              size: DesignTokens.avatarSizeXL, // 64px - matches NotSignedInView
              color: colorScheme.primary,
            ),
            SizedBox(height: DesignTokens.spacingXL - DesignTokens.spacingXS), // 20px - matches NotSignedInView
            Text(
              AppLocalizations.of(context)!.noSubscribedTopics,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: DesignTokens.fontWeightBold,
                fontSize: DesignTokens.fontSizeL, // Match NotSignedInView title size
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacingS), // Match NotSignedInView
            Text(
              AppLocalizations.of(context)!.noSubscribedTopicsMessage,
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
        title: AppLocalizations.of(context)!.signInToViewSubscribedTopics,
        message: AppLocalizations.of(context)!.youNeedToBeSignedInToViewSubscribedTopics,
        icon: Icons.bookmark_outline_rounded,
      );
    }
    if (super.isError.value) {
      final errorMessage = super.errorMessage;
      if (errorMessage.contains('not logged in') || errorMessage.contains('do not have permission') || errorMessage.contains('permission to do this action')) {
        return NotSignedInView(
          siteContext: widget.siteContext,
          title: AppLocalizations.of(context)?.signInToViewSubscribedTopics ?? 'Sign in to view subscribed topics',
          message: AppLocalizations.of(context)?.youNeedToBeSignedInToViewSubscribedTopics ?? 'You need to be signed in to view your subscribed topics.',
          icon: Icons.bookmark_outline_rounded,
        );
      }
    }
    return null;
  }

  // Get loading widget
  Widget? buildLoadingWidget() {
    if (_subscribedTopicController == null || !_subscribedTopicController!.isInitialized.value) {
      return const Center(child: CircularProgressIndicator());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    // Show login prompt immediately if user is not logged in
    if (!widget.siteContext.isLoggedIn) {
      return NotSignedInView(
        siteContext: widget.siteContext,
        title: AppLocalizations.of(context)!.signInToViewSubscribedTopics,
        message: AppLocalizations.of(context)!.youNeedToBeSignedInToViewSubscribedTopics,
        icon: Icons.bookmark_outline_rounded,
      );
    }

    return ErrorOrChild(
        isError: super.isError,
        errorMessage: super.errorMessage,
        onRetry: () {
          resetList(); // o la función que quieras para reintentar
        },
        errorBuilder: (context, errorMessage, onRetry) {
          // Show login prompt for login/permission errors
          if (errorMessage.contains('not logged in') || errorMessage.contains('do not have permission') || errorMessage.contains('permission to do this action')) {
            return NotSignedInView(
              siteContext: widget.siteContext,
              title: AppLocalizations.of(context)?.signInToViewSubscribedTopics ?? 'Sign in to view subscribed topics',
              message: AppLocalizations.of(context)?.youNeedToBeSignedInToViewSubscribedTopics ?? 'You need to be signed in to view your subscribed topics.',
              icon: Icons.bookmark_outline_rounded,
            );
          }
          // Return null to use default error handling for other errors
          return null;
        },
        builder: (context) {
          // Show spinner while controller is not initialized
          if (_subscribedTopicController == null) {
            // If controller doesn't exist and tab is active but not loaded yet, show spinner
            // This is the default state - spinner while loading
            if ((!_hasLoaded || _isInitialLoading) && widget.isActive) {
              return const Center(child: CircularProgressIndicator());
            }
            // Default: show spinner (controller not initialized yet)
            return const Center(child: CircularProgressIndicator());
          }
          if (_isInitialLoading && widget.isActive) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!_subscribedTopicController!.isInitialized.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_subscribedTopicController != null && _subscribedTopicController!.isInitialized.value) {
            var topicsList = _subscribedTopicController!.fcTopics;
            if (topicsList.isEmpty) {
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
                        Icons.watch_rounded,
                        size: 80,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context)!.noSubscribedTopics,
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.noSubscribedTopicsMessage,
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

            return RefreshIndicator(
              onRefresh: refreshList,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: topicsList.length + 1,
                itemBuilder: (context, index) {
                  if (index < topicsList.length) {
                    final topic = topicsList[index];
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
                        final int pageSize = SettingsContext.instance.pagePerSize.value;
                        final int totalPostNum = topic.replyCount + 1;
                        final int gotoPage = (totalPostNum - 1) ~/ pageSize + 1;
                        Get.to(() => PostPage(
                              siteContext: widget.siteContext,
                              topicId: topic.id,
                              title: topic.title,
                              mode: PostsListMode.first_unread,
                              gotoPage: gotoPage,
                              forumId: topic.forumId,
                            ));
                      },
                    );
                  } else {
                    // Show spinner when loading more items or when there are more items to load
                    if (_isLoadingMore || (_subscribedTopicController != null && topicsList.length < (_subscribedTopicController!.subscribedTopicsDataOutput.value.total_topic_num ?? 0))) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  void dispose() {
    clearList();
    _scrollController.dispose();
    super.dispose();
  }
}
