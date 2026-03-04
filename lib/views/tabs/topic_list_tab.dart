import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/widgets/resettable_widget.dart';
import 'package:forumcopilot_flutter/views/lists/latest_topics_list.dart';
import 'package:forumcopilot_flutter/views/lists/unread_topics_list.dart';
import 'package:forumcopilot_flutter/views/lists/participated_topics_list.dart';
import 'package:forumcopilot_flutter/views/lists/subscribed_topics_list.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_header_widget.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart' as forumcopilot_sdk;
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

/// Reactive widget that observes controller changes and rebuilds topic items
class _ReactiveTopicItems extends StatefulWidget {
  final int filterIndex;
  final List<Widget> Function() buildItems;
  final Widget? Function() buildEmptyState;

  const _ReactiveTopicItems({
    required this.filterIndex,
    required this.buildItems,
    required this.buildEmptyState,
  });

  @override
  State<_ReactiveTopicItems> createState() => _ReactiveTopicItemsState();
}

class _ReactiveTopicItemsState extends State<_ReactiveTopicItems> {
  @override
  Widget build(BuildContext context) {
    // Simple: just build content, no Obx complexity
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    final topicItems = widget.buildItems();
    final emptyState = widget.buildEmptyState();

    // If we have items, check if the only item is a spinner
    if (topicItems.isNotEmpty) {
      // Check if the first (and possibly only) item is a CircularProgressIndicator wrapped in Center
      final firstItem = topicItems.first;
      if (topicItems.length == 1 && firstItem is Center) {
        final centerChild = firstItem.child;
        if (centerChild is CircularProgressIndicator) {
          // Show spinner instead of empty state when loading
          return firstItem;
        }
      }
      // If we have multiple items or the item is not a spinner, show the items
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: topicItems,
      );
    }

    // If no items and we have empty state, show it
    if (emptyState != null) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 300,
        child: emptyState,
      );
    }

    // Fallback: show spinner if nothing else
    return const Center(child: CircularProgressIndicator());
  }
}

class TopicListTab extends StatefulWidget {
  final SiteContext siteContext;
  final bool isActive;
  final forumcopilot_sdk.FCBoardStatResult? boardStats;
  const TopicListTab({Key? key, required this.siteContext, required this.isActive, this.boardStats}) : super(key: key);

  @override
  TopicListTabState createState() => TopicListTabState();
}

class TopicListTabState extends FCStatefulWidget<TopicListTab> with FCTabStatefulWidget<TopicListTab> {
  int _selectedFilterIndex = 0;
  bool _isLoadingMore = false;

  // Add keys for each list
  final GlobalKey<LatestTopicsListState> _latestTopicsKey = GlobalKey();
  final GlobalKey<UnreadTopicsListState> _unreadTopicsKey = GlobalKey();
  final GlobalKey<SubscribedTopicsListState> _subscribedTopicsKey = GlobalKey();
  final GlobalKey<ParticipatedTopicsListState> _participatedTopicsKey = GlobalKey();

  // Scroll controller for the main ListView
  final ScrollController _scrollController = ScrollController();

  // Track previous login state to detect changes
  bool _wasLoggedIn = false;
  String? _lastLoadedUsername;
  late final VoidCallback _authStateListener;

  List<String> _getFilterLabels(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.latest,
      l10n.unread,
      l10n.subscribed,
      l10n.participated,
    ];
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize tracking variables
    _wasLoggedIn = widget.siteContext.isLoggedIn;
    _lastLoadedUsername = widget.siteContext.loginDataOutput?.user?.username;

    // Listen to credential changes and reset all lists
    _authStateListener = () {
      final isLoggedInStatus = widget.siteContext.isLoggedIn;
      final currentUsername = widget.siteContext.loginDataOutput?.user?.username;

      final authStateChanged = _wasLoggedIn != isLoggedInStatus;
      final userChanged = isLoggedInStatus && _lastLoadedUsername != currentUsername;

      if (authStateChanged || userChanged) {
        AppLogger.debug('📋 [TOPIC_LIST_TAB] Credential change detected - resetting all topic lists');
        _wasLoggedIn = isLoggedInStatus;
        _lastLoadedUsername = currentUsername;

        // Reset all child lists when credentials change
        _latestTopicsKey.currentState?.resetList();
        _unreadTopicsKey.currentState?.resetList();
        _subscribedTopicsKey.currentState?.resetList();
        _participatedTopicsKey.currentState?.resetList();
      }
    };

    widget.siteContext.isLoggedInNotifier.addListener(_authStateListener);
  }

  @override
  void didUpdateWidget(covariant TopicListTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If tab just became active, ensure the active list refreshes
    final tabJustBecameActive = !oldWidget.isActive && widget.isActive;
    if (tabJustBecameActive) {
      AppLogger.debug('📋 [TOPIC_LIST_TAB] Tab just became active - refreshing active list');
      // Trigger refresh on the active topic list
      switch (_selectedFilterIndex) {
        case 0:
          _latestTopicsKey.currentState?.refreshList();
          break;
        case 1:
          _unreadTopicsKey.currentState?.refreshList();
          break;
        case 2:
          _subscribedTopicsKey.currentState?.refreshList();
          break;
        case 3:
          _participatedTopicsKey.currentState?.refreshList();
          break;
      }
      // Force rebuild to show updated content
      if (mounted) {
        setState(() {});
      }
    }
  }

  // Method to notify parent that data has been loaded - child can call this
  void notifyDataLoaded() {
    AppLogger.debug('📢 [TOPIC_LIST_TAB] notifyDataLoaded called - forcing rebuild');
    if (mounted) {
      setState(() {});
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 && !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    _isLoadingMore = true;
    setState(() {});

    try {
      // Call loadMore on the active topic list
      switch (_selectedFilterIndex) {
        case 0:
          final state = _latestTopicsKey.currentState;
          if (state != null && state.hasMoreItems) {
            await state.loadMore();
          }
          break;
        case 1:
          final state = _unreadTopicsKey.currentState;
          if (state != null && state.hasMoreItems) {
            await state.loadMore();
          }
          break;
        case 2:
          final state = _subscribedTopicsKey.currentState;
          if (state != null && state.hasMoreItems) {
            await state.loadMore();
          }
          break;
        case 3:
          final state = _participatedTopicsKey.currentState;
          if (state != null && state.hasMoreItems) {
            await state.loadMore();
          }
          break;
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  void resetTab() {
    // Reset all child lists
    _latestTopicsKey.currentState?.resetList();
    _unreadTopicsKey.currentState?.resetList();
    _subscribedTopicsKey.currentState?.resetList();
    _participatedTopicsKey.currentState?.resetList();

    // Reset to first filter if needed
    setState(() {
      _selectedFilterIndex = 0;
    });

    // Scroll back to top
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    widget.siteContext.isLoggedInNotifier.removeListener(_authStateListener);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildFilterChips() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingM),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _getFilterLabels(context).length,
          separatorBuilder: (context, index) => SizedBox(width: DesignTokens.spacingS),
          itemBuilder: (context, index) {
            final isSelected = _selectedFilterIndex == index;
            return FilterChip(
              selected: isSelected,
              label: Text(_getFilterLabels(context)[index]),
              onSelected: (selected) {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
              selectedColor: colorScheme.primaryContainer,
              checkmarkColor: colorScheme.onPrimaryContainer,
              labelStyle: textTheme.labelLarge?.copyWith(
                color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? DesignTokens.fontWeightSemiBold : DesignTokens.fontWeightNormal,
              ),
              backgroundColor: colorScheme.surfaceVariant,
              padding: EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingM,
                vertical: DesignTokens.spacingS,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
              ),
            );
          },
        ),
      ),
    );
  }

  // Build topic list items from the active list
  List<Widget> _buildTopicItems() {
    switch (_selectedFilterIndex) {
      case 0:
        final state = _latestTopicsKey.currentState;
        return state?.buildTopicItems() ?? [];
      case 1:
        final state = _unreadTopicsKey.currentState;
        return state?.buildTopicItems() ?? [];
      case 2:
        final state = _subscribedTopicsKey.currentState;
        return state?.buildTopicItems() ?? [];
      case 3:
        final state = _participatedTopicsKey.currentState;
        return state?.buildTopicItems() ?? [];
      default:
        final state = _latestTopicsKey.currentState;
        return state?.buildTopicItems() ?? [];
    }
  }

  // Build error/not signed in widget
  Widget? _buildErrorOrNotSignedInWidget() {
    switch (_selectedFilterIndex) {
      case 0:
        return _latestTopicsKey.currentState?.buildErrorOrNotSignedInWidget();
      case 1:
        return _unreadTopicsKey.currentState?.buildErrorOrNotSignedInWidget();
      case 2:
        return _subscribedTopicsKey.currentState?.buildErrorOrNotSignedInWidget();
      case 3:
        return _participatedTopicsKey.currentState?.buildErrorOrNotSignedInWidget();
      default:
        return _latestTopicsKey.currentState?.buildErrorOrNotSignedInWidget();
    }
  }

  // Build empty state widget
  Widget? _buildEmptyState() {
    switch (_selectedFilterIndex) {
      case 0:
        return _latestTopicsKey.currentState?.buildEmptyState();
      case 1:
        return _unreadTopicsKey.currentState?.buildEmptyState();
      case 2:
        return _subscribedTopicsKey.currentState?.buildEmptyState();
      case 3:
        return _participatedTopicsKey.currentState?.buildEmptyState();
      default:
        return _latestTopicsKey.currentState?.buildEmptyState();
    }
  }

  // Ensure topic list widgets are initialized (but not visible)
  // We use IndexedStack to keep all widgets mounted for state management
  // Position them off-screen with constrained size to avoid layout errors
  Widget _buildTopicListWidgets() {
    return Positioned(
      left: -10000, // Position completely off-screen
      top: -10000,
      child: IgnorePointer(
        ignoring: true,
        child: Opacity(
          opacity: 0.0,
          child: SizedBox(
            width: 100, // Small but bounded size
            height: 100,
            child: ClipRect(
              child: IndexedStack(
                index: _selectedFilterIndex,
                children: [
                  LatestTopicsList(
                    key: _latestTopicsKey,
                    isActive: widget.isActive && _selectedFilterIndex == 0,
                    siteContext: widget.siteContext,
                  ),
                  UnreadTopicsList(
                    key: _unreadTopicsKey,
                    isActive: widget.isActive && _selectedFilterIndex == 1,
                    siteContext: widget.siteContext,
                  ),
                  SubscribedTopicsList(
                    key: _subscribedTopicsKey,
                    isActive: widget.isActive && _selectedFilterIndex == 2,
                    siteContext: widget.siteContext,
                  ),
                  ParticipatedTopicsList(
                    key: _participatedTopicsKey,
                    isActive: widget.isActive && _selectedFilterIndex == 3,
                    siteContext: widget.siteContext,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Trigger refresh on the active topic list
    switch (_selectedFilterIndex) {
      case 0:
        await _latestTopicsKey.currentState?.refreshList();
        break;
      case 1:
        await _unreadTopicsKey.currentState?.refreshList();
        break;
      case 2:
        await _subscribedTopicsKey.currentState?.refreshList();
        break;
      case 3:
        await _participatedTopicsKey.currentState?.refreshList();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always build the hidden widgets first to ensure they're initialized
    final hiddenWidgets = _buildTopicListWidgets();

    // Check for error/not signed in state
    final errorWidget = _buildErrorOrNotSignedInWidget();
    if (errorWidget != null) {
      return Stack(
        children: [
          Column(
            children: [
              ForumHeaderWidget(
                boardStats: widget.boardStats,
                extendUnderAppBar: true,
              ),
              _buildFilterChips(),
              Expanded(child: errorWidget),
            ],
          ),
          hiddenWidgets,
        ],
      );
    }

    // Always show the ListView - buildTopicItems() handles loading states
    // The _ReactiveTopicItems widget uses Obx internally to observe controller changes
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView(
            controller: _scrollController,
            children: [
              // Forum Header
              ForumHeaderWidget(
                boardStats: widget.boardStats,
                extendUnderAppBar: true,
              ),
              // Filter Chips
              _buildFilterChips(),
              // Empty state or topic items - wrapped in reactive widget
              _ReactiveTopicItems(
                filterIndex: _selectedFilterIndex,
                buildItems: _buildTopicItems,
                buildEmptyState: _buildEmptyState,
              ),
            ],
          ),
        ),
        hiddenWidgets,
      ],
    );
  }
}

/// Widget que muestra una lista de foros con datos mockup
class TopicList extends StatelessWidget {
  const TopicList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 0,
      itemBuilder: (context, index) => const SizedBox.shrink(),
    );
  }
}
