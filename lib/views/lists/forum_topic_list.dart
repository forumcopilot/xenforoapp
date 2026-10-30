import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';
import 'package:forumcopilot_sdk/models/entities/fc_topic_filters.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/entities/fc_topic.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/utils/forum_navigation.dart';
import 'package:forumcopilot_flutter/views/post_page.dart';
import 'package:forumcopilot_flutter/views/lists/posts_list.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import '../listitems/topic_list_item.dart';
import '../listitems/forum_list_item.dart';
import '../widgets/subforum_masthead.dart';
import '../../theme/design_tokens.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import '../../utils/snackbar_helper.dart';
import '../widgets/forum_watch_sheet.dart';
import '../widgets/thread_filters_sheet.dart';
import '../../utils/app_navigation.dart';

class ForumTopicList extends StatefulWidget {
  final SiteContext siteContext;
  final FCForum forum;
  /// The page's header, a sliver above the list (the forum's masthead);
  /// it stays through loading and errors, so the page keeps its bar.
  final Widget? header;
  final void Function(VoidCallback)? onRefreshAvailable;

  /// Room below the last topic for the page's floating New Topic button,
  /// so it never covers that topic.
  final bool clearFloatingButton;

  const ForumTopicList({
    super.key,
    required this.siteContext,
    required this.forum,
    this.header,
    this.onRefreshAvailable,
    this.clearFloatingButton = false,
  });

  @override
  State<ForumTopicList> createState() => _ForumTopicListState();
}

class _ForumTopicListState extends State<ForumTopicList> {
  List<FCTopic> _allItems = [];
  List<FCForum> _childForums = [];
  int _currentTopicCount = 0;
  String? _error;
  bool _isLoading = true;
  final int _pageSize = 20;
  bool _hasMoreTopics = true;
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  /// Sorting and filters chosen for the threads, and what the forum offers
  /// (add-on 1.11.0+; null before, and no Filters button).
  FCTopicFilters _filters = const FCTopicFilters();
  ThreadListOptions? _listOptions;

  @override
  void initState() {
    super.initState();
    AppLogger.debug('\n[ForumTopicList] Initializing for forum: ${widget.forum.name} (ID: ${widget.forum.id})');
    _scrollController.addListener(_onScroll);
    _loadTopics();
    widget.onRefreshAvailable?.call(_loadTopics);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8 && !_isLoadingMore && _hasMoreTopics) {
      _loadMoreTopics();
    }
  }

  Future<void> _loadTopics() async {
    AppLogger.debug('\n[ForumTopicList] Starting to load topics for forum: ${widget.forum.name}');
    AppLogger.debug('[ForumTopicList] Current state - Loading: $_isLoading, Error: $_error');

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      AppLogger.debug('[ForumTopicList] State updated - Loading started, Error cleared');

      final topicProxy = SiteProxyFactory.getTopicProxy();
      AppLogger.debug('[ForumTopicList] TopicProxy initialized');

      try {
        AppLogger.debug('[ForumTopicList] Calling getTopicAsync with params:');
        AppLogger.debug('  - forumId: ${widget.forum.id}');
        AppLogger.debug('  - startNum: 0');
        AppLogger.debug('  - lastNum: $_pageSize');
        AppLogger.debug('  - mode: TOPIC');

        List<FCTopic> allItems = []; // Clear the list before adding new items
        List<FCForum> childForums = []; // Separate list for child forums

        // Add child forums if they exist
        if (widget.forum.childForums.isNotEmpty) {
          AppLogger.debug('[ForumTopicList] Adding ${widget.forum.childForums.length} child forums');
          childForums.addAll(widget.forum.childForums);
        }
        bool hasMoreTopics = false;
        ThreadListOptions? listOptions;
        FCTopicFilters? appliedFilters;

        // Check if user can view content in this forum
        final canViewContent = widget.forum.canViewContent;
        AppLogger.debug('[ForumTopicList] canViewContent: $canViewContent');

        if (!widget.forum.isSubForumContainer && canViewContent) {
          // TEMPORARILY DISABLED: Load announcement topics
          // final annTopicData = await topicProxy.getAnnTopicAsync(widget.forum.id, 0, 19);
          // if (annTopicData.topics.isNotEmpty) {
          //   AppLogger.debug('[ForumTopicList] Adding ${annTopicData.topics.length} announcement topics');
          //   // Mark as announcement and convert to FCTopic
          //   for (final t in annTopicData.topics) {
          //     t.isAnnouncement = true;
          //   }
          //   var annTopicsList = annTopicData.topics;
          //   // Mark FCTopics as announcements
          //   for (final topic in annTopicsList) {
          //     topic.isAnnouncement = true;
          //   }
          //   allItems.addAll(annTopicsList);
          // }

          // Load sticky topics
          // Sticky threads come unfiltered: left out while a filter is set,
          // as the website's filters leave out those that don't match
          final topTopicData = _filters.filters
              ? null
              : await topicProxy.getTopTopicAsync(widget.forum.id, 0, 19);
          if (topTopicData != null && topTopicData.topics.isNotEmpty) {
            AppLogger.debug(
                '[ForumTopicList] Adding ${topTopicData.topics.length} sticky topics');
            // Mark as sticky and convert to FCTopic
            for (final t in topTopicData.topics) {
              t.isStickySource = true;
            }
            var topTopicsList = topTopicData.topics;
            // Mark FCTopics as pinned
            for (final topic in topTopicsList) {
              topic.isPinned = true;
            }
            allItems.addAll(topTopicsList);
          }

          // Load regular topics
          final forumTopicData = await topicProxy.getTopicAsync(widget.forum.id, 0, _pageSize,
              filters: _filters.isEmpty ? null : _filters);
          listOptions = ThreadListOptions.from(forumTopicData);
          // Show only the filters the forum applied (it ignores, say, an
          // unknown member's name, as the website does)
          final applied = forumTopicData.appliedFilters;
          if (!_filters.isEmpty && applied != null) {
            appliedFilters = FCTopicFilters.fromApplied(applied,
                defaultOrder: forumTopicData.defaultOrder,
                defaultDirection: forumTopicData.defaultDirection,
                dateLimitDays: forumTopicData.dateLimitDays ?? 0);
          }
          if (forumTopicData.topics.isNotEmpty) {
            AppLogger.debug('[ForumTopicList] Adding ${forumTopicData.topics.length} regular topics');
            var topicsList = forumTopicData.topics;
            allItems.addAll(topicsList);
            _currentTopicCount = forumTopicData.topics.length;
          }
          // Also when a reload (new filters) finds none
          _currentTopicCount = forumTopicData.topics.length;
          hasMoreTopics = forumTopicData.topics.length >= _pageSize;
        }
        AppLogger.debug('\n[ForumTopicList] Items loaded successfully:');
        AppLogger.debug('  - Total items: ${allItems.length}');

        if (mounted) {
          setState(() {
            _allItems = allItems;
            _childForums = childForums;
            _isLoading = false;
            _hasMoreTopics = hasMoreTopics;
            _listOptions = listOptions ?? _listOptions;
            if (appliedFilters != null) _filters = appliedFilters;
          });
          AppLogger.debug('[ForumTopicList] State updated - Loading completed');
          AppLogger.debug('  - Total items: ${_allItems.length}');
          AppLogger.debug('  - Has more topics: $_hasMoreTopics');
          AppLogger.debug('  - Loading state: $_isLoading');
        } else {
          AppLogger.debug('[ForumTopicList] Widget no longer mounted, state update skipped');
        }
      } catch (e, stackTrace) {
        AppLogger.debug('\n[ForumTopicList] Error during getTopicAsync:');
        AppLogger.debug('  - Error: $e');
        AppLogger.debug('  - Stack trace: $stackTrace');
        rethrow;
      }
    } catch (e) {
      AppLogger.debug('\n[ForumTopicList] Error handling:');
      AppLogger.debug('  - Error: $e');

      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
        AppLogger.debug('[ForumTopicList] State updated with error');
        AppLogger.debug('  - Error message: $_error');
        AppLogger.debug('  - Loading state: $_isLoading');
      } else {
        AppLogger.debug('[ForumTopicList] Widget no longer mounted, error state update skipped');
      }
    }
  }

  void _applyFilters(FCTopicFilters filters) {
    setState(() => _filters = filters);
    _loadTopics();
  }

  Future<void> _openFilters(ThreadListOptions options) async {
    final chosen = await showModalBottomSheet<FCTopicFilters>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ThreadFiltersSheet(options: options, filters: _filters),
    );
    if (chosen != null && mounted) _applyFilters(chosen);
  }

  /// The Filters button, and the filters in effect, each with a ✕.
  Widget _buildFilterBar(ThreadListOptions options) {
    final l10n = AppLocalizations.of(context);
    final f = _filters;
    Widget chip(String label, FCTopicFilters without) => InputChip(
          label: Text(label),
          visualDensity: VisualDensity.compact,
          onDeleted: () => _applyFilters(without),
          deleteButtonTooltipMessage: l10n.clearFilters,
        );
    final chips = <Widget>[
      if (f.prefixId != null)
        chip('${l10n.prefix}: ${options.prefixTitle(f.prefixId!) ?? f.prefixId}',
            FCTopicFilters(order: f.order, direction: f.direction, starterName: f.starterName, lastDays: f.lastDays)),
      if (f.starterName != null)
        chip('${l10n.startedBy}: ${f.starterName}',
            FCTopicFilters(order: f.order, direction: f.direction, prefixId: f.prefixId, lastDays: f.lastDays)),
      if (f.lastDays != null)
        chip('${l10n.lastUpdated}: ${threadPeriodLabel(l10n, f.lastDays!)}',
            FCTopicFilters(order: f.order, direction: f.direction, prefixId: f.prefixId, starterName: f.starterName)),
      if (f.order != null)
        chip('${l10n.sortBy}: ${options.sortTitle(f.order!)} ${f.direction == 'asc' ? '↑' : '↓'}',
            FCTopicFilters(prefixId: f.prefixId, starterName: f.starterName, lastDays: f.lastDays)),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(DesignTokens.spacingL, DesignTokens.spacingS, DesignTokens.spacingS, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Wrap(spacing: DesignTokens.spacingS, runSpacing: DesignTokens.spacingXS, children: chips),
          ),
          TextButton.icon(
            onPressed: () => _openFilters(options),
            icon: const Icon(Icons.tune_rounded),
            label: Text(l10n.threadFilters),
          ),
        ],
      ),
    );
  }

  Future<void> _loadMoreTopics() async {
    if (_isLoadingMore || !_hasMoreTopics) return;

    // Don't load more topics if user cannot view content
    if (!widget.forum.canViewContent) return;

    AppLogger.debug('\n[ForumTopicList] Loading more topics');
    AppLogger.debug('  - Current topic count: ${_allItems.length}');

    setState(() => _isLoadingMore = true);

    try {
      final topicProxy = SiteProxyFactory.getTopicProxy();

      AppLogger.debug('[ForumTopicList] Calling getTopicAsync for more topics:');
      AppLogger.debug('  - Start num: $_currentTopicCount');
      AppLogger.debug('  - Last num: ${_currentTopicCount + _pageSize}');

      final moreTopics = await topicProxy.getTopicAsync(
          widget.forum.id, _currentTopicCount, _currentTopicCount + _pageSize,
          filters: _filters.isEmpty ? null : _filters);

      if (mounted) {
        setState(() {
          // Add new topics to the _allItems list
          if (moreTopics.topics.isNotEmpty) {
            var topicsList = moreTopics.topics;
            _allItems.addAll(topicsList);
            _currentTopicCount += moreTopics.topics.length;
          }

          _hasMoreTopics = moreTopics.topics.length >= _pageSize;
          _isLoadingMore = false;
        });

        AppLogger.debug('\n[ForumTopicList] More topics loaded:');
        AppLogger.debug('  - New topics count: ${moreTopics.topics.length}');
        AppLogger.debug('  - Total items now: ${_allItems.length}');
        AppLogger.debug('  - Has more topics: $_hasMoreTopics');
      }
    } catch (e) {
      AppLogger.debug('\n[ForumTopicList] Error loading more topics:');
      AppLogger.debug('  - Error: $e');

      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  Future<void> _handleSubscription(String forumId, bool subscribe) async {
    // Check if user is logged in before proceeding with subscription
    if (!widget.siteContext.isLoggedIn) {
      SnackbarHelper.showInfo(context, subscribe ? AppLocalizations.of(context).pleaseLoginToSubscribeForums : AppLocalizations.of(context).pleaseLoginToUnsubscribeForums);
      return;
    }

    try {
      final target = _allItems.whereType<FCForum>().where((f) => f.id == forumId).firstOrNull;
      if (target != null && ForumWatch.hasOptions(target)) {
        // Add-on 1.11.0: the website's watch options
        final watched = await ForumWatch.change(context, target);
        if (watched == null || !mounted) return;
        subscribe = watched;
      } else {
        final subscriptionProxy = SiteProxyFactory.getSubscriptionProxy();

        if (subscribe) {
          await subscriptionProxy.subscribeForumAsync(
              forumId, 1); // mode 1 for subscribe
        } else {
          await subscriptionProxy.unsubscribeForumAsync(forumId);
        }
      }

      // Update the forum's subscription status in the list
      setState(() {
        for (var forum in _allItems) {
          if (forum is FCForum && forum.id == forumId) {
            forum.isSubscribed = subscribe;
          }
        }
      });
    } catch (e) {
      AppLogger.debug('[ForumTopicList] Error handling subscription: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_isLoading) {
      return _withHeader(const Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return _withHeader(Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).errorLoadingContent('$_error'),
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.error),
            ),
            SizedBox(height: DesignTokens.spacingL),
            FilledButton(
              onPressed: _loadTopics,
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingXL,
                  vertical: DesignTokens.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                ),
                elevation: DesignTokens.elevationMedium,
              ),
              child: Text(AppLocalizations.of(context).retry),
            ),
          ],
        ),
      ));
    }

    // Use separate lists for forums and topics
    final forums = _childForums;
    final topics = _allItems;
    final canViewContent = widget.forum.canViewContent;

    // Separate topics into different categories
    final announcements = topics.where((topic) => topic.isAnnouncement == true).toList();
    final stickyTopics = topics.where((topic) => topic.isPinned == true && topic.isAnnouncement != true).toList();
    final regularTopics = topics.where((topic) => topic.isAnnouncement != true && topic.isPinned != true).toList();

    final header = widget.header;
    return RefreshIndicator(
      onRefresh: _loadTopics,
      // Below the collapsed header, not behind it.
      edgeOffset: header == null ? 0 : MediaQuery.paddingOf(context).top + SubforumMasthead.collapsedHeight,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (header != null) header,
          SliverPadding(
            // An extended FAB (56) and its margins (16 each side).
            padding: widget.clearFloatingButton
                ? const EdgeInsets.only(bottom: 56 + 2 * kFloatingActionButtonMargin)
                : EdgeInsets.zero,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
          // Show permission message if user cannot view content. Not on a
          // category's page: XenForo categories hold forums, never topics,
          // and say so as "cannot view content".
          if (!canViewContent && !widget.forum.isSubForumContainer)
            Padding(
              padding: DesignTokens.paddingL,
              child: Container(
                padding: DesignTokens.paddingM,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: DesignTokens.spacingM),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).noPermissionToViewSubforumTopics,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // If there are no forums and no topics, show empty state
          if (forums.isEmpty && topics.isEmpty && canViewContent && !_filters.filters)
            Padding(
              padding: DesignTokens.paddingXXL,
              child: Center(
                child: Text(
                  AppLocalizations.of(context).noDiscussionsYet,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (forums.isNotEmpty) ...[
            // Named where the forum has topics of its own below them; a
            // category's page is only its forums.
            if (!widget.forum.isSubForumContainer)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  DesignTokens.spacingL,
                  DesignTokens.spacingM,
                  DesignTokens.spacingL,
                  DesignTokens.spacingXS,
                ),
                child: Semantics(
                  header: true,
                  child: Text(
                    AppLocalizations.of(context).subForums,
                    style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            ...forums.map((forum) => ForumListItem(
                  siteContext: widget.siteContext,
                  forum: forum,
                  compact: !widget.forum.isSubForumContainer,
                  onSubscriptionChanged: (subscribe) => _handleSubscription(
                      forum.id.isEmpty ? "0" : forum.id, subscribe),
                  onTap: () {
                    pushForumOrLinkForum(context, forum, widget.siteContext,
                        parent: widget.forum, openedFromParent: true);
                  },
                )),
            // Separator between Forums and Topics
            if (announcements.isNotEmpty || stickyTopics.isNotEmpty || regularTopics.isNotEmpty)
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
          ],
          // Filters for the threads, as on the website (add-on 1.11.0+)
          if (_listOptions != null && canViewContent && !widget.forum.isSubForumContainer)
            _buildFilterBar(_listOptions!),
          if (topics.isEmpty && _filters.filters)
            Padding(
              padding: DesignTokens.paddingXXL,
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context).noThreadsMatchFilters,
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () => _applyFilters(const FCTopicFilters()),
                    child: Text(AppLocalizations.of(context).clearFilters),
                  ),
                ],
              ),
            ),
          if (announcements.isNotEmpty) ...[
            ...announcements.map((topic) => TopicListItem(
                  siteContext: widget.siteContext,
                  topic: topic,
                  topicIcon: Icons.campaign_outlined,
                  onTap: () async {
                    if (!widget.siteContext.isLoggedIn) {
                      if (!Get.isRegistered<LoginController>()) {
                        Get.put(LoginController());
                      }
                      final loginController = Get.find<LoginController>();
                      final loginResult = await loginController.attemptAutomaticLogin(widget.siteContext);
                      if (!loginResult.success && loginResult.hadCredentials && Get.currentRoute != '/LoginPage') {
                        await AppNavigation.pushGlobal(LoginPage(siteContext: widget.siteContext), name: '/LoginPage');
                      }
                    }
                    AppNavigation.pushGlobal(PostPage(
                          siteContext: widget.siteContext,
                          topicId: topic.id,
                          title: topic.title,
                          isAnnouncement: true,
                        ), name: '/PostPage');
                  },
                )),
          ],
          if (stickyTopics.isNotEmpty) ...[
            ...stickyTopics.map((topic) => TopicListItem(
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
                        await AppNavigation.pushGlobal(LoginPage(siteContext: widget.siteContext), name: '/LoginPage');
                      }
                    }
                    // At the first unread post, as the Latest list opens topics (signed in only).
                    AppNavigation.pushGlobal(PostPage(siteContext: widget.siteContext, topicId: topic.id, title: topic.title, mode: widget.siteContext.isLoggedIn ? PostsListMode.first_unread : PostsListMode.normal), name: '/PostPage');
                  },
                )),
          ],
          if (regularTopics.isNotEmpty) ...[
            ...regularTopics.map((topic) => TopicListItem(
                  siteContext: widget.siteContext,
                  topic: topic,
                  topicIcon: null,
                  onTap: () async {
                    if (!widget.siteContext.isLoggedIn) {
                      if (!Get.isRegistered<LoginController>()) {
                        Get.put(LoginController());
                      }
                      final loginController = Get.find<LoginController>();
                      final loginResult = await loginController.attemptAutomaticLogin(widget.siteContext);
                      if (!loginResult.success && loginResult.hadCredentials && Get.currentRoute != '/LoginPage') {
                        await AppNavigation.pushGlobal(LoginPage(siteContext: widget.siteContext), name: '/LoginPage');
                      }
                    }
                    // At the first unread post, as the Latest list opens topics (signed in only).
                    AppNavigation.pushGlobal(PostPage(siteContext: widget.siteContext, topicId: topic.id, title: topic.title, mode: widget.siteContext.isLoggedIn ? PostsListMode.first_unread : PostsListMode.normal), name: '/PostPage');
                  },
                )),
          ],
          if (_hasMoreTopics)
            const Padding(
              padding: DesignTokens.paddingS,
              child: Center(child: CircularProgressIndicator()),
            ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  /// [body] under the page's header, filling the rest of the screen.
  Widget _withHeader(Widget body) {
    final header = widget.header;
    if (header == null) return body;
    return CustomScrollView(
      slivers: [
        header,
        SliverFillRemaining(hasScrollBody: false, child: body),
      ],
    );
  }

  @override
  void dispose() {
    AppLogger.debug('\n[ForumTopicList] Disposing widget for forum: ${widget.forum.name}');
    _scrollController.dispose();
    super.dispose();
  }
}
