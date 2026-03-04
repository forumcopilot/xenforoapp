import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/widgets/resettable_widget.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';
import '../../utils/error_dialog.dart';
import '../../utils/forum_navigation.dart';
import '../listitems/forum_list_item.dart';

import '../widgets/forum_header_widget.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class ForumListTab extends StatefulWidget {
  final SiteContext siteContext;
  final bool isActive;
  final FCBoardStatResult? boardStats;
  const ForumListTab({super.key, required this.isActive, required this.siteContext, this.boardStats});
  @override
  ForumListTabState createState() => ForumListTabState();
}

class ForumListTabState extends FCStatefulWidget<ForumListTab> with FCTabStatefulWidget<ForumListTab> {
  List<FCForum>? _allForums;
  List<FCForum>? _subscribedForums;
  String? _error;
  bool _isLoading = true;

  // Add authentication state tracking
  bool _wasLoggedIn = false;
  String? _lastLoadedUsername;
  late final VoidCallback _authStateListener;

  // Track last logged forum count to reduce debug noise
  int? _lastLoggedForumCount;

  @override
  void initState() {
    super.initState();
    // Initialize authentication state
    _wasLoggedIn = widget.siteContext.isLoggedIn;
    _lastLoadedUsername = widget.siteContext.loginDataOutput?.user?.username;

    // Clear any cached data - always fetch fresh from server
    _allForums = null;
    _subscribedForums = null;
    _loadForums();

    // Only load subscribed forums if tab is active
    if (widget.isActive && widget.siteContext.isLoggedIn) {
      _loadSubscribedForums();
    }

    // Listen to login state changes
    _authStateListener = () {
      final isLoggedInStatus = widget.siteContext.isLoggedIn;
      final currentUsername = widget.siteContext.loginDataOutput?.user?.username;

      // If user logged in and tab is active, reload to get subscribed forums
      if (isLoggedInStatus && widget.isActive) {
        // Check if this is a new login or different user
        if (!_wasLoggedIn || _lastLoadedUsername != currentUsername) {
          AppLogger.debug('📋 [FORUMS] Auth state changed - reloading forums and subscribed forums');
          _wasLoggedIn = isLoggedInStatus;
          _lastLoadedUsername = currentUsername;
          // Reload forums to get subscribed forums for logged-in user
          _loadForums();
          _loadSubscribedForums();
        }
      } else if (!isLoggedInStatus && _wasLoggedIn) {
        // User logged out - clear subscribed forums and reload
        AppLogger.debug('📋 [FORUMS] User logged out - clearing subscribed forums');
        _wasLoggedIn = false;
        _lastLoadedUsername = null;
        if (mounted) {
          setState(() {
            _subscribedForums = null;
          });
          // Reload forums to refresh the list without subscribed forums
          _loadForums();
        }
      }
    };

    widget.siteContext.isLoggedInNotifier.addListener(_authStateListener);
  }

  @override
  void resetTab() {
    // Update tracking variables
    _wasLoggedIn = widget.siteContext.isLoggedIn;
    _lastLoadedUsername = widget.siteContext.loginDataOutput?.user?.username;
    _loadForums();
    // Only load subscribed forums if tab is active
    if (widget.isActive && widget.siteContext.isLoggedIn) {
      _loadSubscribedForums();
    }
  }

  @override
  void didUpdateWidget(ForumListTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Load subscribed forums when tab becomes active and user is logged in
    if (widget.isActive && !oldWidget.isActive && widget.siteContext.isLoggedIn) {
      _loadSubscribedForums();
    }
  }

  @override
  void dispose() {
    widget.siteContext.isLoggedInNotifier.removeListener(_authStateListener);
    super.dispose();
  }

  Future<void> _loadSubscribedForums() async {
    // Only load subscribed forums if user is logged in and tab is active
    if (!widget.siteContext.isLoggedIn || !widget.isActive) {
      return;
    }

    AppLogger.debug('[ForumList] Initializing SubscriptionProxy');
    final subscriptionProxy = SiteProxyFactory.getSubscriptionProxy();
    AppLogger.debug('[ForumList] Fetching subscribed forums');
    try {
      final subscribedForums = await subscriptionProxy.getSubscribedForumAsync();
      AppLogger.debug('[ForumList] Subscribed forums loaded: ${subscribedForums.forums.length} forums');

      if (mounted) {
        setState(() {
          _subscribedForums = subscribedForums.forums
              .map((subscribedForum) => FCForum(
                    id: subscribedForum.forum_id ?? '',
                    name: subscribedForum.forum_name ?? '',
                    logoUrl: subscribedForum.icon_url,
                    isProtected: subscribedForum.is_protected ?? false,
                    hasNewPosts: subscribedForum.new_post ?? false,
                    canPost: subscribedForum.can_post ?? false,
                    isSubscribed: true,
                    canSubscribe: true,
                    isSubForumContainer: false,
                  ))
              .toList();
        });
      }
    } catch (e) {
      AppLogger.debug('[ForumList] Error loading subscribed forums: $e');
      // Show error to user if it's a critical error (like account locked)
      if (e is FCApiException && e.message.toLowerCase().contains('security locked')) {
        final errorMessage = extractErrorMessage(e);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
              ),
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              behavior: SnackBarBehavior.floating,
              margin: DesignTokens.paddingS,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
      // Don't show error for subscribed forums otherwise, just keep the previous value
    }
  }

  Future<void> _loadForums() async {
    AppLogger.debug('\n[ForumList] Loading forums');
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load all forums first - always fetch fresh from server (no caching)
      AppLogger.debug('[ForumList] Fetching all forums');
      final forumProxy = SiteProxyFactory.getForumProxy();
      final getForumsResult = await forumProxy.getForumAsync(true, '', true); // forceRefresh = true to bypass cache

      AppLogger.debug('[ForumList] getForumAsync completed:');
      AppLogger.debug('   - result: ${getForumsResult.result}');
      AppLogger.debug('   - resultText: ${getForumsResult.resultText}');
      AppLogger.debug('   - forums count: ${getForumsResult.forums?.length ?? 'null'}');

      if (!getForumsResult.result && (getForumsResult.resultText?.isNotEmpty ?? false)) {
        AppLogger.debug('[ForumList] ⚠️ API call returned result=false: ${getForumsResult.resultText}');
      }

      final allForums = getForumsResult.forums;
      AppLogger.debug('[ForumList] All forums loaded: ${allForums?.length ?? 0} forums');

      // Debug print for sub_only status
      if (allForums != null) {
        for (var forum in allForums) {
          AppLogger.debug('[ForumList] Forum "${forum.name}" (ID: ${forum.id}) sub_only: ${forum.isSubForumContainer} childForums: ${forum.childForums?.length ?? 'null'}');
        }
      }

      // Clear subscribed forums if user is not logged in
      if (!widget.siteContext.isLoggedIn) {
        if (mounted) {
          setState(() {
            _subscribedForums = null;
          });
        }
      }

      if (mounted) {
        setState(() {
          _allForums = allForums;
          _isLoading = false;
        });
      }
    } catch (e) {
      AppLogger.debug('[ForumList] Error loading forums: $e');
      final errorMessage = extractErrorMessage(e);
      if (mounted) {
        setState(() {
          _error = errorMessage;
          _isLoading = false;
        });
        // Show error to user via SnackBar for important errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            behavior: SnackBarBehavior.floating,
            margin: DesignTokens.paddingS,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _handleSubscription(String forumId, bool subscribe) async {
    // Check if user is logged in before proceeding with subscription
    if (!widget.siteContext.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please login to ${subscribe ? 'subscribe to' : 'unsubscribe from'} forums',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          margin: DesignTokens.paddingS,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      final subscriptionProxy = SiteProxyFactory.getSubscriptionProxy();

      if (subscribe) {
        await subscriptionProxy.subscribeForumAsync(forumId, 1); // mode 1 for subscribe
      } else {
        await subscriptionProxy.unsubscribeForumAsync(forumId);
      }

      // Update the forum's subscription status in both lists
      setState(() {
        if (_allForums != null) {
          for (var forum in _allForums!) {
            if (forum.id == forumId) {
              forum.isSubscribed = subscribe;
            }
          }
        }

        if (subscribe) {
          // Add to subscribed forums if subscribing
          final forum = _allForums?.firstWhere((f) => f.id == forumId);
          if (forum != null) {
            _subscribedForums ??= [];
            if (!_subscribedForums!.any((f) => f.id == forumId)) {
              _subscribedForums!.add(forum);
            }
          }
        } else {
          // Remove from subscribed forums if unsubscribing
          _subscribedForums?.removeWhere((forum) => forum.id == forumId);
        }
      });
    } catch (e) {
      AppLogger.debug('[ForumList] Error handling subscription: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: DesignTokens.spacingL),
            Text(
              'Unable to Load Forums',
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.error,
                fontWeight: DesignTokens.fontWeightBold,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingS),
            Padding(
              padding: DesignTokens.paddingL,
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: DesignTokens.spacingXL),
            FilledButton.icon(
              onPressed: _loadForums,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
            ),
          ],
        ),
      );
    }

    if (_allForums == null || _allForums!.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await _loadForums();
        },
        child: ListView(
          children: [
            // Forum Header - Always show even when no forums
            ForumHeaderWidget(
              boardStats: widget.boardStats,
            ),
            // Empty state message
            Center(
              child: Padding(
                padding: DesignTokens.paddingXXL,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.forum_outlined,
                      size: DesignTokens.iconSizeXXL * 1.67, // 80px
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: DesignTokens.spacingXL),
                    Text(
                      "No Forums Available",
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: DesignTokens.fontWeightBold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DesignTokens.spacingS),
                    Text(
                      'There are no forums to display. This might be due to permissions or the forum structure.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _loadForums();
      },
      child: ListView(
        children: [
          // Forum Header
          ForumHeaderWidget(
            boardStats: widget.boardStats,
            extendUnderAppBar: true,
          ),
          if (widget.siteContext.isLoggedIn && _subscribedForums != null && _subscribedForums!.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(
                DesignTokens.spacingL,
                DesignTokens.spacingS,
                DesignTokens.spacingL,
                DesignTokens.spacingS,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.watch_rounded,
                    size: DesignTokens.iconSizeM,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: DesignTokens.spacingS),
                  Text(
                    'Subscribed Forums',
                    style: StyleBuilders.titleTextStyle(
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      fontWeight: DesignTokens.fontWeightMedium,
                    ),
                  ),
                ],
              ),
            ),
            ..._subscribedForums!.map((forum) => ForumListItem(
                  siteContext: widget.siteContext,
                  forum: forum,
                  onSubscriptionChanged: (subscribe) => _handleSubscription(forum.id.isEmpty ? "0" : forum.id, subscribe),
                  onTap: () {
                    pushForumOrLinkForum(context, forum, widget.siteContext);
                  },
                )),
            if (_allForums != null && _allForums!.isNotEmpty) ...[
              const SizedBox(height: DesignTokens.spacingS),
              StyleBuilders.divider(
                colorScheme: colorScheme,
                indent: DesignTokens.spacingL,
                endIndent: DesignTokens.spacingL,
              ),
              const SizedBox(height: DesignTokens.spacingS),
            ],
          ],

          ..._buildForumList(_allForums!),
        ],
      ),
    );
  }

  List<Widget> _buildForumList(List<FCForum> forums) {
    final List<Widget> widgets = [];
    final colorScheme = Theme.of(context).colorScheme;
    // Only log when forum count changes to reduce noise
    if (_lastLoggedForumCount != forums.length) {
      AppLogger.debug('[ForumList] _buildForumList called with \\${forums.length} forums');
      _lastLoggedForumCount = forums.length;
    }
    for (int i = 0; i < forums.length; i++) {
      final forum = forums[i];
      // Removed per-forum debug logging to reduce noise
      if (forum.isSubForumContainer) {
        // If forum is sub_only, show it as a section title
        widgets.add(
          Padding(
            padding: EdgeInsets.fromLTRB(
              DesignTokens.spacingL,
              DesignTokens.spacingM,
              DesignTokens.spacingL,
              DesignTokens.spacingM,
            ),
            child: Text(
              forum.name,
              style: StyleBuilders.titleTextStyle(
                colorScheme: Theme.of(context).colorScheme,
                textTheme: Theme.of(context).textTheme,
                fontSize: DesignTokens.fontSizeM,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
            ),
          ),
        );

        // Add child forums as cards
        if (forum.childForums != null && forum.childForums!.isNotEmpty) {
          // Removed per-child-forum debug logging to reduce noise
          widgets.addAll(
            forum.childForums!.map((childForum) {
              return ForumListItem(
                siteContext: widget.siteContext,
                forum: childForum,
                onSubscriptionChanged: (subscribe) => _handleSubscription(childForum.id.isEmpty ? "0" : childForum.id, subscribe),
                onTap: () {
                  pushForumOrLinkForum(context, childForum, widget.siteContext);
                },
              );
            }),
          );
        }

        // Add separator after category group if the next item is also a category group
        if (i < forums.length - 1 && forums[i + 1].isSubForumContainer) {
          widgets.add(
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant.withOpacity(0.3),
              ),
            ),
          );
        }
      } else {
        // If forum is not sub_only, show it as a regular card
        widgets.add(
          ForumListItem(
            siteContext: widget.siteContext,
            forum: forum,
            onSubscriptionChanged: (subscribe) => _handleSubscription(forum.id.isEmpty ? "0" : forum.id, subscribe),
            onTap: () {
              pushForumOrLinkForum(context, forum, widget.siteContext);
            },
          ),
        );
      }
    }
    return widgets;
  }
}
