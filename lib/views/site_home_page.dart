import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/controllers/site_controller.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_sdk/models/results/fc_forum_result.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_conversation_result.dart';
import 'package:get/get.dart';
import 'package:xenforo_core/xenforo_core.dart';
import '../theme/design_tokens.dart';
import '../theme/style_builders.dart';
import 'appbars/forum_app_bar.dart';
import 'appbars/topics_tab_app_bar.dart';
import 'appbars/forums_tab_app_bar.dart';
import 'appbars/messages_tab_app_bar.dart';
import 'appbars/notifications_tab_app_bar.dart';
import 'appbars/profile_tab_app_bar.dart';
import 'tabs/forum_list_tab.dart';
import 'tabs/topic_list_tab.dart';
import 'tabs/notification_list_tab.dart';
import 'tabs/privatemessage_list_tab.dart';
import 'tabs/profile_tab.dart';
import 'private_messaging/traditional/pages/new_traditional_pm_page.dart';
import 'private_messaging/conversation/pages/new_conversation_page.dart';
import 'widgets/resettable_widget.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'package:forumcopilot_flutter/core/async/async_utils.dart';
import 'dart:async';

class SiteHomePage extends StatefulWidget {
  final Site? siteToInitialize;
  final bool showGlobalLoader;

  const SiteHomePage({
    super.key,
    this.siteToInitialize,
    this.showGlobalLoader = true,
  });

  // Static flag to trigger autoShowLogin in ProfileTab after registration
  static bool triggerProfileAutoLogin = false;

  @override
  State<SiteHomePage> createState() => _SiteHomePageState();
}

class _SiteHomePageState extends State<SiteHomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _previousTabIndex = 0;

  // Add keys for each tab
  final GlobalKey<TopicListTabState> _topicListKey = GlobalKey();
  final GlobalKey<ForumListTabState> _forumListKey = GlobalKey();
  final GlobalKey<PrivateMessageListTabState> _pmListKey = GlobalKey();
  final GlobalKey<NotificationListTabState> _notificationTabKey = GlobalKey();
  final GlobalKey<ProfileTabState> _profileTabKey = GlobalKey();

  // Add workers to listen for auth or forum changes
  Worker? _siteWorker;
  SiteContext? _siteContext;

  // Store listener callbacks so we can remove them in dispose
  VoidCallback? _loginStateListener;

  // Track if we need to wait for initialization
  bool _waitingForInitialization = false;

  // Track unread conversations count for badge
  int _unreadConversationsCount = 0;

  // Track unread alerts count for badge
  int _unreadAlertsCount = 0;

  // Shared board stats for both Topics and Forums tabs
  FCBoardStatResult? _boardStats;

  // Track last logged values to reduce debug noise
  int? _lastLoggedTabCount;
  int? _lastLoggedTabIndex;
  bool? _lastLoggedShouldShowFAB;

  // Track last stable login state to prevent rebuilds from temporary API fluctuations
  bool? _lastStableLoginState;
  Timer? _loginStateDebounceTimer;

  // Helper method to get tab count
  int get _tabCount {
    return _enabledTabs.length;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    _previousTabIndex = _tabController.index; // Initialize to match initial index
    _tabController.addListener(_onTabChanged);

    // If siteToInitialize is null, site was already initialized in bootstrap flow.
    // Do not set context, listener, or load here when site is initialized: the block
    // below runs getConfig first, then sets context, listener, and loads. That way we
    // always validate session with getConfig before any other API calls.
    if (widget.siteToInitialize == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (Get.isRegistered<SiteController>()) {
          final siteController = Get.find<SiteController>();
          final alreadyInitialized = siteController.isInitialized.value &&
              siteController.currentSiteContext.value != null;
          if (alreadyInitialized) {
            // Let the verification block below handle everything (getConfig then load).
            return;
          }
        }
      });
    } else {
      // Initialize site if provided (legacy path - should not be used anymore)
      setState(() {
        _waitingForInitialization = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _siteContext = await _initializeSite(widget.siteToInitialize!);
        if (_siteContext != null) {
          _setupLoginStateListener();

          // Load board stats and fetch inbox stat if user is logged in
          _loadBoardStats();
          if (_siteContext!.isLoggedIn) {
            Future.delayed(const Duration(milliseconds: 500), () {
              final context = _siteContext;
              if (mounted && context != null && context.isLoggedIn) {
                AppLogger.debug('📬 [SITE_HOME] Fetching inbox stat after initialization (auto login case)...');
                _fetchInboxStat();
              }
            });
          }
        }
      });
    }

    // Set up listeners for auth and site changes

    if (Get.isRegistered<SiteController>()) {
      final siteController = Get.find<SiteController>();

      // Check if site is already initialized when page loads (re-entering forum)
      // This handles the case when user navigates back to an already initialized forum
      // CRITICAL: Even if site appears initialized, we must verify it's still accessible
      if (siteController.isInitialized.value && widget.siteToInitialize == null) {
        AppLogger.debug('🏁 [SITE_HOME] Site appears initialized - verifying site is still accessible...');
        // Get the current site context if available
        final currentContext = siteController.currentSiteContext.value;
        final currentSite = siteController.currentSite.value;

        if (currentContext != null && currentSite != null) {
          // Show loading state while verifying
          setState(() {
            _waitingForInitialization = true;
          });

          // Verify site is still accessible by calling getConfig
          // This prevents using stale cached data when site is down
          // Use post-frame callback to make this async operation safe
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            try {
              AppLogger.debug('🏁 [SITE_HOME] Verifying site accessibility with getConfig...');
              SiteProxyService.initialize(currentContext);
              var configProxy = SiteProxyService.getConfigProxy();

              await AsyncUtils.withTimeout(
                () => configProxy.getConfig(currentSite.pluginUrl, forceRefresh: true),
                timeout: const Duration(seconds: 10),
                operationName: 'getConfig verification',
              );

              AppLogger.debug('🏁 [SITE_HOME] ✅ Site verification successful - using cached context');
              if (mounted) {
                setState(() {
                  _waitingForInitialization = false;
                });
                _siteContext = currentContext;
                _setupLoginStateListener();

                // Load board stats and fetch inbox stat if user is logged in
                _loadBoardStats();
                if (currentContext.isLoggedIn) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      AppLogger.debug('📬 [SITE_HOME] Fetching inbox stat for already initialized site...');
                      _fetchInboxStat();
                    }
                  });
                }
              }
            } on TimeoutException {
              AppLogger.error('🏁 [SITE_HOME] ❌ Site verification timed out - site may be down');
              // Site is down - show error and navigate back
              if (mounted) {
                setState(() {
                  _waitingForInitialization = false;
                });
                _showErrorAndGoBack(currentSite, 'Connection timed out. The site may be down or unreachable.');
              }
            } catch (e) {
              AppLogger.error('🏁 [SITE_HOME] ❌ Site verification failed: $e - site may be down');
              // Site is down - show error and navigate back
              if (mounted) {
                setState(() {
                  _waitingForInitialization = false;
                });
                _showErrorAndGoBack(currentSite, AppLocalizations.of(context)!.failedToConnectToSite);
              }
            }
          });
        } else {
          AppLogger.warning('🏁 [SITE_HOME] Site marked as initialized but context or site is null - forcing re-initialization');
          // Force re-initialization if context is missing
          setState(() {
            _waitingForInitialization = true;
          });
          if (currentSite != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              _siteContext = await _initializeSite(currentSite);
              if (_siteContext != null) {
                _setupLoginStateListener();
                _loadBoardStats();
                if (_siteContext!.isLoggedIn) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    final context = _siteContext;
                    if (mounted && context != null && context.isLoggedIn) {
                      AppLogger.debug('📬 [SITE_HOME] Fetching inbox stat after re-initialization...');
                      _fetchInboxStat();
                    }
                  });
                }
              }
            });
          }
        }
      }

      _siteWorker = ever(siteController.isInitialized, (isInitialized) {
        if (isInitialized) {
          AppLogger.debug('🏁 [SITE_HOME] Site initialization completed - refreshing all tabs');
          _recreateTabController();
          _resetAllTabs();
          // Load board stats once for sharing between tabs
          _loadBoardStats();
          // Fetch inbox stat when entering forum
          // Use a small delay to ensure auto login has completed if it's happening
          Future.delayed(const Duration(milliseconds: 500), () {
            final context = _siteContext;
            if (mounted && context != null && context.isLoggedIn) {
              AppLogger.debug('📬 [SITE_HOME] Fetching inbox stat after site initialization (auto login case)...');
              _fetchInboxStat();
            }
          });
          // Force rebuild to update UI with new tab structure
          if (mounted) {
            setState(() {});
          }
        }
      });
    }
  }

  /// Set up login state listener for site context
  void _setupLoginStateListener() {
    if (_siteContext == null) return;

    // Initialize stable login state
    _lastStableLoginState = _siteContext!.isLoggedIn;

    _loginStateListener = () {
      if (!mounted) return;

      final currentLoginState = _siteContext!.isLoggedIn;

      // Cancel any pending debounce timer
      _loginStateDebounceTimer?.cancel();

      // Check if this is a "real" login/logout (loginDataOutput changed) vs temporary API fluctuation
      final hasLoginData = _siteContext!.loginDataOutput != null;
      final isRealLoginChange = (currentLoginState && hasLoginData) || (!currentLoginState && !hasLoginData);

      // If it's a real login/logout, react immediately
      // Otherwise, debounce to avoid reacting to temporary API fluctuations
      if (isRealLoginChange && currentLoginState != _lastStableLoginState) {
        _handleLoginStateChange(currentLoginState);
        _lastStableLoginState = currentLoginState;
      } else {
        // Debounce temporary fluctuations - only react if state is stable for 500ms
        _loginStateDebounceTimer = Timer(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          final stableState = _siteContext!.isLoggedIn;
          if (stableState != _lastStableLoginState) {
            _handleLoginStateChange(stableState);
            _lastStableLoginState = stableState;
          }
        });
      }
    };
    _siteContext!.isLoggedInNotifier.addListener(_loginStateListener!);
  }

  /// Handle login state change - only called for stable, meaningful changes
  void _handleLoginStateChange(bool isLoggedIn) {
    if (!mounted) return;
    _recreateTabController();
    _resetAllTabs();
    // Fetch inbox stat after login to update badge
    if (isLoggedIn) {
      _fetchInboxStat();
    } else {
      // Clear badges when logged out
      if (mounted) {
        setState(() {
          _unreadConversationsCount = 0;
          _unreadAlertsCount = 0;
        });
      }
    }
    // Force rebuild to update UI with new tab structure
    if (mounted) {
      setState(() {});
    }
  }

  Future<SiteContext?> _initializeSite(Site site) async {
    if (!mounted) return null;
    SiteContext? siteContext;
    try {
      AppLogger.debug('🏁 [SITE_HOME] Starting site initialization for ${site.name}');
      final siteController = Get.find<SiteController>();

      // Create SiteContext
      final context = SiteContext(siteType: site.siteType, site: site);

      SiteProxyService.initialize(context);
      // Initialize the site (GlobalLoaderController will handle the loading UI)
      // getConfig and all initialization must complete successfully before proceeding
      // Auto-login failures will show the Login screen before continuing as guest
      siteContext = await siteController.initializeSite(
        site,
        showGlobalLoader: widget.showGlobalLoader,
      );
      // IMPORTANT: Re-initialize proxy service with the actual SiteContext returned by initialization.
      // The controller may load a persisted SiteContext, so we must ensure proxies target that context.
      if (siteContext != null) {
        SiteProxyService.initialize(siteContext);
      }

      // Mark initialization as complete so UI can be built
      if (mounted) {
        // Verify initialization was successful - siteContext should not be null
        if (!siteController.isInitialized.value || siteContext == null) {
          AppLogger.debug('🏁 [SITE_HOME] Site initialization failed - siteContext is null or not initialized');
          setState(() {
            _waitingForInitialization = false;
          });
          // Error dialog should have been shown by SiteController, just navigate back
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(this.context).pop();
            }
          });
          return null;
        }

        setState(() {
          _waitingForInitialization = false;
        });
        AppLogger.debug('🏁 [SITE_HOME] Site initialization completed successfully');

        // Load board stats and fetch inbox stat if site is already initialized and user is logged in
        // This handles the case when re-entering the forum
        // Use a small delay to ensure any auto login has completed
        if (siteContext.isLoggedIn) {
          _loadBoardStats();
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && (siteContext?.isLoggedIn ?? false)) {
              AppLogger.debug('📬 [SITE_HOME] Site already initialized, fetching inbox stat...');
              _fetchInboxStat();
            }
          });
        }
      }
      // The page will automatically update when the forum is initialized
      // due to the _siteWorker listener
    } catch (e) {
      if (mounted) {
        setState(() {
          _waitingForInitialization = false;
        });
        AppLogger.debug('🏁 [SITE_HOME] Site initialization failed with exception: $e');
        // Show error dialog and go back (in case SiteController didn't show one)
        _showErrorAndGoBack(site, e.toString());
      }
    }
    return siteContext;
  }

  void _showErrorAndGoBack(Site site, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(
            AppLocalizations.of(context)!.connectionFailed,
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.error,
              fontWeight: DesignTokens.fontWeightSemiBold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.failedToConnectToSiteName(site.name),
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: DesignTokens.spacingS),
              Text(
                error,
                style: StyleBuilders.smallTextStyle(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ).copyWith(
                  fontSize: DesignTokens.fontSizeXS,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous page
              },
              child: Text(
                AppLocalizations.of(context)!.okButton,
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Method to recreate tab controller when notification permission changes
  void _recreateTabController() {
    final newTabCount = _tabCount;
    final currentTabCount = _tabController.length;

    AppLogger.debug('🔄 [SITE_HOME] _recreateTabController called - Current: $currentTabCount, New: $newTabCount');

    if (currentTabCount != newTabCount) {
      final currentIndex = _tabController.index;
      AppLogger.debug('🔄 [SITE_HOME] Recreating TabController - Current index: $currentIndex');

      _tabController.dispose();
      _previousTabIndex = 0; // Reset previous index when recreating controller
      _tabController = TabController(length: newTabCount, vsync: this);
      _tabController.addListener(_onTabChanged);

      // Try to maintain the same tab index if possible
      final newEnabledTabs = _enabledTabs;
      int newIndex = 0;

      if (currentIndex < newEnabledTabs.length) {
        // If the current index is still valid, use it
        newIndex = currentIndex;
      } else {
        // If current index is out of bounds, go to Profile tab
        newIndex = _getTabIndex(_profileTab);
      }

      // Ensure the index is within bounds
      if (newIndex >= 0 && newIndex < newTabCount) {
        _tabController.index = newIndex;
        _previousTabIndex = newIndex;
        AppLogger.debug('🔄 [SITE_HOME] Set TabController index to: $newIndex');
      } else {
        // Fallback to first tab if index is still invalid
        _tabController.index = 0;
        _previousTabIndex = 0;
        AppLogger.debug('🔄 [SITE_HOME] Fallback to index 0');
      }
    }
  }

  // Method to reset all tabs
  void _resetAllTabs() {
    final enabledTabs = _enabledTabs;

    // Reset all tab controllers using the ResettableTabState mixin
    final tabStates = enabledTabs.map((tabType) {
      switch (tabType) {
        case _topicsTab:
          return _topicListKey.currentState;
        case _forumsTab:
          return _forumListKey.currentState;
        case _messagesTab:
          return _pmListKey.currentState;
        case _notificationsTab:
          return _notificationTabKey.currentState;
        case _profileTab:
          return _profileTabKey.currentState;
        default:
          return null;
      }
    }).where((state) => state != null);

    for (final state in tabStates) {
      if (state is FCTabStatefulWidget) {
        state.resetTab();
      }
    }

    // Refresh badge when Messages tab is reset (e.g., after returning from viewing messages)
    if (_siteContext?.isLoggedIn ?? false) {
      _fetchInboxStat();
    }

    // Force rebuild if needed
    if (mounted) {
      setState(() {});
    }
  }

  // Tab change listener that checks mounted before setState
  void _onTabChanged() {
    if (!mounted) return;
    if (_tabController.index != _previousTabIndex) {
      _previousTabIndex = _tabController.index;
      setState(() {});
    }
  }

  void _onNewMessagePressed() async {
    if (_siteContext == null) return;

    if (_siteContext!.configDataOutput?.conversation ?? false) {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => NewConversationPage(siteContext: _siteContext!)),
      );
      if (result == true) {
        _pmListKey.currentState?.resetTab();
      }
    } else {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => NewTraditionalPMPage(siteContext: _siteContext!)),
      );
      if (result == true) {
        _pmListKey.currentState?.resetTab();
      }
    }
  }

  // Define tab types for better organization
  static const String _topicsTab = 'topics';
  static const String _forumsTab = 'forums';
  static const String _messagesTab = 'messages';
  static const String _notificationsTab = 'notifications';
  static const String _profileTab = 'profile';

  // Get the list of enabled tabs based on user permissions
  List<String> get _enabledTabs {
    final tabs = [_topicsTab, _forumsTab];
    tabs.add(_messagesTab); // Always show Messages tab
    if (_siteContext?.configDataOutput?.alert ?? false) tabs.add(_notificationsTab);
    tabs.add(_profileTab);
    return tabs;
  }

  // Helper methods to get tab indices
  int _getTabIndex(String tabType) => _enabledTabs.indexOf(tabType);
  bool _isCurrentTab(String tabType) => _tabController.index == _getTabIndex(tabType);

  // Build the appropriate app bar for the current tab
  PreferredSizeWidget _buildAppBarForCurrentTab(bool isLoggedIn, bool canSendPM) {
    if (_siteContext == null) {
      return ForumAppBar(
        siteContext: SiteContext(siteType: 'none', site: Site(name: 'Loading...', url: '', description: '', siteType: 'none')),
        isLoggedIn: false,
      );
    }

    final currentTabType = _enabledTabs[_tabController.index];

    switch (currentTabType) {
      case _topicsTab:
        return TopicsTabAppBar(
          siteContext: _siteContext!,
          isLoggedIn: isLoggedIn,
        );
      case _forumsTab:
        return ForumsTabAppBar(
          siteContext: _siteContext!,
          isLoggedIn: isLoggedIn,
        );
      case _messagesTab:
        return MessagesTabAppBar(
          siteContext: _siteContext!,
          isLoggedIn: isLoggedIn,
        );
      case _notificationsTab:
        return NotificationsTabAppBar(
          siteContext: _siteContext!,
          isLoggedIn: isLoggedIn,
        );
      case _profileTab:
        return ProfileTabAppBar(
          siteContext: _siteContext!,
          isLoggedIn: isLoggedIn,
        );
      default:
        return ForumAppBar(
          siteContext: _siteContext!,
          isLoggedIn: isLoggedIn,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Don't build the main UI until initialization is complete
    if (_waitingForInitialization) {
      // Show a minimal scaffold with just the app bar while waiting
      // The GlobalLoaderController will show the loading overlay
      return Scaffold(
        appBar: TopicsTabAppBar(
          siteContext: _siteContext ?? SiteContext(siteType: 'none', site: Site(name: 'Loading...', url: '', description: '', siteType: 'none')),
          isLoggedIn: false, // Not logged in during initialization
        ),
        body: const SizedBox.shrink(), // Empty body, loading overlay will show
      );
    }

    // If siteContext is null after initialization, show error and prevent UI entry
    // This can happen if initialization failed
    if (_siteContext == null && !_waitingForInitialization) {
      // If we have a site to initialize but failed, show error dialog and go back
      if (widget.siteToInitialize != null) {
        // Error dialog should have already been shown by _initializeSite or SiteController
        // But ensure we navigate back after a delay to allow dialog to be shown
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _siteContext == null) {
            Navigator.of(context).pop();
          }
        });
      }

      // Return minimal error state while navigating back
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.errorTitle ?? 'Error'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Debug logging for tab counts (only log when values actually change to reduce noise)
    final enabledTabs = _enabledTabs;
    final destinations = _buildNavigationDestinations();
    // Only log if tab count or index changed (not on every rebuild)
    if (_lastLoggedTabCount != enabledTabs.length || _lastLoggedTabIndex != _tabController.index) {
      AppLogger.debug('🔍 [SITE_HOME] Build - Enabled tabs: ${enabledTabs.length}, TabController: ${_tabController.length}, Destinations: ${destinations.length}');
      AppLogger.debug('🔍 [SITE_HOME] Enabled tabs: $enabledTabs');
      AppLogger.debug('🔍 [SITE_HOME] Current TabController index: ${_tabController.index}');
      _lastLoggedTabCount = enabledTabs.length;
      _lastLoggedTabIndex = _tabController.index;
    }

    // Check if TabController needs to be recreated due to tab count change
    if (_tabController.length != enabledTabs.length) {
      AppLogger.debug('🔄 [SITE_HOME] Tab count mismatch detected in build - recreating TabController');
      _recreateTabController();
    }

    final isLoggedIn = _siteContext!.isLoggedIn;
    final canSendPM = isLoggedIn && (_siteContext?.loginDataOutput?.user?.canSendPM ?? false);
    final isOnMessagesTab = _isCurrentTab(_messagesTab);
    final shouldShowFAB = isLoggedIn && isOnMessagesTab && canSendPM;

    // Only log FAB visibility when it changes to reduce noise
    if (_lastLoggedShouldShowFAB != shouldShowFAB) {
      AppLogger.debug('🔍 [SITE_HOME] FAB visibility changed:');
      AppLogger.debug('   - isLoggedIn: $isLoggedIn');
      AppLogger.debug('   - isOnMessagesTab: $isOnMessagesTab (currentIndex: ${_tabController.index}, messagesTabIndex: ${_getTabIndex(_messagesTab)})');
      AppLogger.debug('   - canSendPM: $canSendPM');
      AppLogger.debug('   - FAB should show: $shouldShowFAB');
      _lastLoggedShouldShowFAB = shouldShowFAB;
    }

    return Scaffold(
      appBar: _buildAppBarForCurrentTab(isLoggedIn, canSendPM),
      body: IndexedStack(
        index: _tabController.index,
        children: _buildTabWidgets(),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          AppLogger.debug('🎯 [SITE_HOME] NavigationBar onDestinationSelected: index=$index, TabController.length=${_tabController.length}');
          setState(() {
            _tabController.index = index;
            _previousTabIndex = index;
          });
          // Refresh badge when Messages tab becomes active
          if (_enabledTabs[index] == _messagesTab && (_siteContext?.isLoggedIn ?? false)) {
            _fetchInboxStat();
          }
        },
        selectedIndex: _tabController.index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: _buildNavigationDestinations(),
      ),
      floatingActionButton: shouldShowFAB
          ? FloatingActionButton.extended(
              onPressed: _onNewMessagePressed,
              icon: const Icon(Icons.post_add_rounded),
              label: Text(_siteContext?.configDataOutput?.conversation ?? false ? AppLocalizations.of(context)!.newConversation : AppLocalizations.of(context)!.newMessage),
            )
          : null,
    );
  }

  // Build tab widgets based on enabled tabs
  List<Widget> _buildTabWidgets() {
    return _enabledTabs.map((tabType) {
      switch (tabType) {
        case _topicsTab:
          return TopicListTab(
              key: _topicListKey,
              isActive: _isCurrentTab(_topicsTab),
              siteContext: _siteContext ?? SiteContext(siteType: 'none', site: Site(name: 'Loading...', url: '', description: '', siteType: 'none')),
              boardStats: _boardStats);
        case _forumsTab:
          return ForumListTab(
              key: _forumListKey,
              isActive: _isCurrentTab(_forumsTab),
              siteContext: _siteContext ?? SiteContext(siteType: 'none', site: Site(name: 'Loading...', url: '', description: '', siteType: 'none')),
              boardStats: _boardStats);
        case _messagesTab:
          return PrivateMessageListTab(
              key: _pmListKey,
              isActive: _isCurrentTab(_messagesTab),
              siteContext: _siteContext ?? SiteContext(siteType: 'none', site: Site(name: 'Loading...', url: '', description: '', siteType: 'none')));
        case _notificationsTab:
          return NotificationListTab(
              key: _notificationTabKey,
              isActive: _isCurrentTab(_notificationsTab),
              siteContext: _siteContext ?? SiteContext(siteType: 'none', site: Site(name: 'Loading...', url: '', description: '', siteType: 'none')));
        case _profileTab:
          return ProfileTab(
            key: _profileTabKey,
            isActive: _isCurrentTab(_profileTab),
            autoShowLogin: SiteHomePage.triggerProfileAutoLogin,
            siteContext: _siteContext ?? SiteContext(siteType: 'none', site: Site(name: 'Loading...', url: '', description: '', siteType: 'none')),
          );
        default:
          throw ArgumentError('Unknown tab type: $tabType');
      }
    }).toList();
  }

  // Build navigation destinations based on enabled tabs
  List<NavigationDestination> _buildNavigationDestinations() {
    return _enabledTabs.map((tabType) {
      switch (tabType) {
        case _topicsTab:
          return const NavigationDestination(
            selectedIcon: Icon(Icons.chat_bubble),
            icon: Icon(Icons.chat_bubble_outline),
            label: '',
          );
        case _forumsTab:
          return const NavigationDestination(
            selectedIcon: Icon(Icons.forum),
            icon: Icon(Icons.forum_outlined),
            label: '',
          );
        case _messagesTab:
          return NavigationDestination(
            selectedIcon: const Icon(Icons.mail),
            icon: Badge(
              label: Text('$_unreadConversationsCount'),
              isLabelVisible: _unreadConversationsCount > 0,
              child: const Icon(Icons.mail_outline),
            ),
            label: '',
          );
        case _notificationsTab:
          return NavigationDestination(
            selectedIcon: const Icon(Icons.notifications),
            icon: Badge(
              label: Text('$_unreadAlertsCount'),
              isLabelVisible: _unreadAlertsCount > 0,
              child: const Icon(Icons.notifications_outlined),
            ),
            label: '',
          );
        case _profileTab:
          return const NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outlined),
            label: '',
          );
        default:
          throw ArgumentError('Unknown tab type: $tabType');
      }
    }).toList();
  }

  /// Load board statistics once for sharing between tabs
  Future<void> _loadBoardStats() async {
    if (_siteContext == null) {
      return;
    }

    try {
      AppLogger.debug('📊 [SITE_HOME] Loading board stats...');
      final forumProxy = SiteProxyFactory.getForumProxy();
      final stats = await forumProxy.getBoardStatAsync();
      if (mounted) {
        setState(() {
          _boardStats = stats;
        });
        AppLogger.debug('📊 [SITE_HOME] Board stats loaded successfully');
      }
    } catch (e) {
      AppLogger.debug('📊 [SITE_HOME] Error loading board stats: $e');
      // Silently fail - board stats are not critical
    }
  }

  /// Fetch inbox statistics to update the badge count
  Future<void> _fetchInboxStat() async {
    if (_siteContext == null || !_siteContext!.isLoggedIn) {
      return;
    }

    try {
      AppLogger.debug('📬 [SITE_HOME] Fetching inbox stat...');
      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();

      // Check if this is a XenForo proxy that supports getInboxStatWithAlertsAsync
      if (conversationProxy is XenForoPrivateConversationProxy) {
        final result = await conversationProxy.getInboxStatWithAlertsAsync();
        final inboxStat = result['inboxStat'] as FCInboxStatResult;
        final unreadAlerts = result['unreadAlerts'] as int;

        if (inboxStat.result) {
          AppLogger.debug('📬 [SITE_HOME] Inbox stat fetched: ${inboxStat.unreadConversations} unread conversations, $unreadAlerts unread alerts');
          if (mounted) {
            setState(() {
              _unreadConversationsCount = inboxStat.unreadConversations;
              _unreadAlertsCount = unreadAlerts;
            });
          }
        } else {
          AppLogger.debug('📬 [SITE_HOME] Failed to fetch inbox stat: ${inboxStat.resultText}');
        }
      } else {
        // Fallback for proxies that don't support unread alert counts
        final inboxStat = await conversationProxy.getInboxStatAsync();
        if (inboxStat.result) {
          AppLogger.debug('📬 [SITE_HOME] Inbox stat fetched: ${inboxStat.unreadConversations} unread conversations');
          if (mounted) {
            setState(() {
              _unreadConversationsCount = inboxStat.unreadConversations;
              // unreadAlerts not available for this proxy type
              _unreadAlertsCount = 0;
            });
          }
        } else {
          AppLogger.debug('📬 [SITE_HOME] Failed to fetch inbox stat: ${inboxStat.resultText}');
        }
      }
    } catch (e) {
      AppLogger.debug('📬 [SITE_HOME] Error fetching inbox stat: $e');
      // Silently fail since this is not urgent
    }
  }

  @override
  void dispose() {
    // Cancel login state debounce timer
    _loginStateDebounceTimer?.cancel();
    _loginStateDebounceTimer = null;

    // Remove tab controller listener
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();

    // Remove login state listener if it exists
    if (_loginStateListener != null && _siteContext != null) {
      _siteContext!.isLoggedInNotifier.removeListener(_loginStateListener!);
      _loginStateListener = null;
    }

    // Dispose worker
    _siteWorker?.dispose();
    _siteWorker = null;

    super.dispose();
  }
}
