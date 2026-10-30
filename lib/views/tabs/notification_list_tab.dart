import 'dart:async';

import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/entities/fc_topic.dart';
import 'package:forumcopilot_sdk/models/results/fc_social_result.dart';
import '../../theme/design_tokens.dart';
import '../widgets/resettable_widget.dart';
import '../listitems/notification_list_item.dart';
import '../post_page.dart';
import '../lists/posts_list.dart';
import '../private_messaging/conversation/pages/conversation_page.dart';
import '../user_profile_page.dart';
import 'package:forumcopilot_flutter/views/widgets/not_signed_in_view.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import '../../services/notification_router.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/app_navigation.dart';
import '../../utils/forum_links.dart';

class NotificationListTab extends StatefulWidget {
  final SiteContext siteContext;
  final bool isActive;

  /// Set while a loaded alert is unread and can be marked read (XenForo
  /// add-on 1.11.0+): the Alerts bar shows "Mark all read" then.
  final ValueNotifier<bool>? hasUnreadAlerts;

  const NotificationListTab({super.key, required this.isActive, required this.siteContext, this.hasUnreadAlerts});

  @override
  NotificationListTabState createState() => NotificationListTabState();
}

class NotificationListTabState extends FCStatefulWidget<NotificationListTab> with FCTabStatefulWidget<NotificationListTab> {
  List<FCTopic> _topics = [];
  List<FCAlert> _alerts = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  int _page = 1;
  final int _perPage = 20;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  // Add authentication state tracking
  bool _hasLoaded = false;
  bool _wasLoggedIn = false;
  String? _lastLoadedUsername;
  late final VoidCallback _authStateListener;

  @override
  void initState() {
    super.initState();
    // Initialize authentication state
    _wasLoggedIn = widget.siteContext.isLoggedIn;
    _lastLoadedUsername = widget.siteContext.loginDataOutput?.user?.username;

    // Only load if user is logged in and tab is active
    if (widget.siteContext.isLoggedIn && widget.isActive) {
      _fetchTopics(reset: true);
    }
    _scrollController.addListener(_onScroll);

    // Listen to login state changes
    _authStateListener = () {
      final isLoggedInStatus = widget.siteContext.isLoggedIn;
      final currentUsername = widget.siteContext.loginDataOutput?.user?.username;

      // If user logged in and tab is active, reset and reload
      if (isLoggedInStatus && widget.isActive) {
        // Check if this is a new login or different user
        if (!_wasLoggedIn || _lastLoadedUsername != currentUsername) {
          AppLogger.debug('📋 [NOTIFICATIONS] Auth state changed - resetting and reloading');
          _hasLoaded = false;
          _wasLoggedIn = isLoggedInStatus;
          _lastLoadedUsername = currentUsername;
          _fetchTopics(reset: true);
        }
      } else if (!isLoggedInStatus && _wasLoggedIn) {
        // User logged out - clear data
        AppLogger.debug('📋 [NOTIFICATIONS] User logged out - clearing data');
        _hasLoaded = false;
        _wasLoggedIn = false;
        _lastLoadedUsername = null;
        widget.hasUnreadAlerts?.value = false;
        if (mounted) {
          setState(() {
            _topics = [];
            _alerts = [];
            _isLoading = false;
            _isLoadingMore = false;
            _error = null;
          });
        }
      }
    };

    widget.siteContext.isLoggedInNotifier.addListener(_authStateListener);
  }

  @override
  void didUpdateWidget(NotificationListTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if we should load data when widget becomes active
    if (widget.isActive && !oldWidget.isActive && _shouldLoadData()) {
      _fetchTopics(reset: true);
    }
  }

  bool _shouldLoadData() {
    final currentUsername = widget.siteContext.loginDataOutput?.user?.username;

    // Always load if we haven't loaded yet and user is logged in
    if (!_hasLoaded && widget.siteContext.isLoggedIn) {
      return true;
    }

    // Load if authentication state changed (login/logout)
    if (_wasLoggedIn != widget.siteContext.isLoggedIn) {
      return true;
    }

    // Load if user changed (different user logged in)
    if (widget.siteContext.isLoggedIn && _lastLoadedUsername != currentUsername) {
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    widget.siteContext.isLoggedInNotifier.removeListener(_authStateListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoadingMore && _hasMore && !_isLoading) {
      _fetchTopics();
    }
  }

  /// Marks every alert read, then lists them again (add-on 1.11.0+).
  Future<void> markAllRead() => _fetchTopics(reset: true, markAllRead: true);

  /// Whether the Alerts bar offers "Mark all read".
  void _publishUnread() {
    widget.hasUnreadAlerts?.value = _alerts.any((a) => a.isUnread == true && a.alertId != null);
  }

  /// Opening an alert reads it, as on the website (add-on 1.11.0+; older
  /// add-ons send no read state, and the row stays as it was).
  void _markRead(FCAlert alert) {
    final id = alert.alertId;
    if (alert.isUnread != true || id == null) return;
    setState(() => alert.isUnread = false);
    _publishUnread();
    unawaited(SiteProxyFactory.getSocialProxy().getAlertAsync(1, 1, false, markReadIds: [id], skipMarkRead: true));
  }

  Future<void> _fetchTopics({bool reset = false, bool markAllRead = false}) async {
    final currentUsername = widget.siteContext.loginDataOutput?.user?.username;

    // Check authentication state first
    if (!widget.siteContext.isLoggedIn) {
      widget.hasUnreadAlerts?.value = false;
      setState(() {
        _topics = [];
        _alerts = [];
        _isLoading = false;
        _isLoadingMore = false;
        _error = null;
        _hasLoaded = false;
      });
      _wasLoggedIn = false;
      _lastLoadedUsername = null;
      return;
    }

    // Update tracking variables
    _wasLoggedIn = widget.siteContext.isLoggedIn;
    _lastLoadedUsername = currentUsername;

    if (!reset && (_isLoadingMore || _isLoading)) return;
    if (reset) {
      setState(() {
        _isLoading = true;
        _error = null;
        _page = 1;
        _hasMore = true;
      });
    } else {
      setState(() {
        _isLoadingMore = true;
      });
    }
    try {
      final socialProxy = SiteProxyFactory.getSocialProxy();
      final alertData = await socialProxy.getAlertAsync(_page, _perPage, reset, markAllRead: markAllRead);
      final alerts = alertData.items.where((alert) => alert.message.trim().isNotEmpty).toList();
      final topics = alerts
          .map((alert) => FCTopic(
                id: alert.contentId,
                title: alert.message.trim(),
                forumId: '',
                forumName: '',
                prefix: '',
                authorId: alert.userId,
                authorName: alert.username,
                authorUserType: '',
                authorIconUrl: alert.iconUrl.isNotEmpty ? alert.iconUrl : '',
                timestamp: DateTime.fromMillisecondsSinceEpoch(int.parse(alert.timestamp), isUtc: true),
                replyCount: 0,
                viewCount: 0,
                hasNewPosts: false,
                isClosed: false,
                isSubscribed: false,
                canSubscribe: false,
                url: null,
                shortContent: '',
                participatedUserIds: const [],
                isPinned: false,
                isAnnouncement: false,
                canRename: false,
                canDelete: false,
                canClose: false,
                canApprove: false,
                canStick: false,
                canMove: false,
                canBan: false,
                isBanned: false,
                isApproved: true,
                isDeleted: false,
                isMoved: false,
                isMerged: false,
                realTopicId: null,
                canLike: false,
                isLiked: false,
                likeCount: 0,
                canThank: false,
              ))
          .toList();
      if (mounted) {
        setState(() {
          if (reset) {
            _topics = topics;
            _alerts = alerts.cast<FCAlert>();
          } else {
            _topics.addAll(topics);
            _alerts.addAll(alerts.cast<FCAlert>());
          }
          _isLoading = false;
          _isLoadingMore = false;
          _error = null;
          // Rows without text are dropped above, so count what the server sent.
          _hasMore = alertData.hasMore ?? alertData.items.length >= _perPage;
          if (_hasMore) _page += 1;
        });
        _publishUnread();
        _hasLoaded = true; // Mark as loaded after successful load
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (reset) {
            _isLoading = false;
          } else {
            _isLoadingMore = false;
          }
          _error = e.toString();
        });
      }
    }
  }

  @override
  void resetTab() {
    _hasLoaded = false; // Reset loaded state to force reload
    _fetchTopics(reset: true);
  }

  Future<void> _onRefresh() async {
    await _fetchTopics(reset: true);
  }

  Future<void> _onAlertTap(FCTopic topic, FCAlert alert) async {
    AppLogger.debug('=== Alert Tapped ===');
    AppLogger.debug('Topic ID: ${topic.id}');
    AppLogger.debug('Topic Title: ${topic.title}');
    AppLogger.debug('Author: ${topic.authorName} (ID: ${topic.authorId})');
    AppLogger.debug('Timestamp: ${topic.timestamp}');
    AppLogger.debug('--- Alert Details ---');
    AppLogger.debug('Content ID: ${alert.content_id}');
    AppLogger.debug('Content Type: ${alert.content_type}');
    AppLogger.debug('User ID: ${alert.user_id}');
    AppLogger.debug('Username: ${alert.username}');
    AppLogger.debug('Message: ${alert.message}');
    AppLogger.debug('Icon URL: ${alert.icon_url}');
    AppLogger.debug('Timestamp: ${alert.timestamp}');
    AppLogger.debug('==================');

    _markRead(alert);

    // The same mapping pushes use (NotificationRouter).
    final destination = NotificationRouter.destinationFor(
      contentType: alert.contentType,
      contentId: alert.contentId,
      postId: alert.postId,
      topicId: alert.topicId,
      conversationId: alert.conversationId,
      username: alert.fromUsername ?? alert.username,
      url: alert.actionUrl,
    );
    switch (destination) {
      case PostDestination(:final postId, :final topicId):
        if (topicId == null) {
          _showErrorDialog(
            context,
            AppLocalizations.of(context).topicIdIsMissingCannotNavigateToThePost,
          );
          return;
        }
        AppNavigation.push(context, PostPage(
              siteContext: widget.siteContext,
              topicId: topicId,
              title: _extractTopicTitleFromMessage(alert.message),
              mode: PostsListMode.thread_by_post,
              anchorPostId: postId,
              forumId: '', // Forum ID may not be available
            ));
      case TopicDestination(:final topicId):
        AppNavigation.push(context, PostPage(
              siteContext: widget.siteContext,
              topicId: topicId,
              title: _extractTopicTitleFromMessage(alert.message),
              mode: PostsListMode.first_unread,
              forumId: '', // Forum ID may not be available
            ));
      case ConversationDestination(:final conversationId, :final messageId):
        AppNavigation.push(context, ConversationPage(
              siteContext: widget.siteContext,
              conversationId: conversationId,
              subject: _extractSubjectFromMessage(alert.message),
              anchorMessageId: messageId,
            ));
      case ProfileDestination(:final userId, :final username):
        AppNavigation.push(context, UserProfilePage(
              siteContext: widget.siteContext,
              userId: userId,
              userName: username,
              profilePictureUrl: alert.icon_url,
            ));
      case LinkDestination(:final url):
        await ForumLinks.open(context, url, widget.siteContext);
      case AlertsDestination():
        SnackbarHelper.showInfo(
          context,
          AppLocalizations.of(context).noActionUrlAvailableForThisNotificationType,
        );
    }
  }

  String _extractSubjectFromMessage(String message) {
    // Extract subject from message like 'sent you a message "Re: I've just gifted you a Silver Award"'
    final match = RegExp(r'"([^"]*)"').firstMatch(message);
    return match?.group(1) ?? 'Private Message';
  }

  String _extractTopicTitleFromMessage(String message) {
    // Extract topic title from message like 'replied to "First sugar mummy provider in Singapore. "'
    final match = RegExp(r'"([^"]*)"').firstMatch(message);
    return match?.group(1) ?? 'Topic';
  }

  void _showErrorDialog(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(
            AppLocalizations.of(context).errorTitle,
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: DesignTokens.fontWeightSemiBold,
            ),
          ),
          content: Text(
            message,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context).okButton,
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show not signed in view if user is not logged in
    if (!widget.siteContext.isLoggedIn) {
      return NotSignedInView(
        siteContext: widget.siteContext,
        title: AppLocalizations.of(context).signInToViewNotifications,
        message: AppLocalizations.of(context).youNeedToBeSignedInToViewYourNotifications,
        icon: Icons.notifications_outlined,
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      final colorScheme = Theme.of(context).colorScheme;
      final textTheme = Theme.of(context).textTheme;
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: DesignTokens.paddingScreen,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 80,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: DesignTokens.spacingXL),
                        Text(
                          AppLocalizations.of(context).errorLoadingNotifications,
                          style: textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: DesignTokens.fontWeightBold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: DesignTokens.spacingS),
                        Text(
                          '$_error',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: DesignTokens.spacingL),
                        Text(
                          AppLocalizations.of(context).pullDownToRefresh,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    if (_topics.isEmpty) {
      final colorScheme = Theme.of(context).colorScheme;
      final textTheme = Theme.of(context).textTheme;
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: DesignTokens.paddingScreen,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          size: 80,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: DesignTokens.spacingXL),
                        Text(
                          AppLocalizations.of(context).youAreAllCaughtUp,
                          style: textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: DesignTokens.fontWeightBold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: DesignTokens.spacingS),
                        Text(
                          AppLocalizations.of(context).youHaveNoNewNotificationsCheckBackLater,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: DesignTokens.spacingL),
                        Text(
                          AppLocalizations.of(context).pullDownToRefresh,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _topics.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _topics.length) {
            final topic = _topics[index];
            final originalAlert = _alerts[index];
            return NotificationListItem(
              topic: topic,
              onTap: () => _onAlertTap(topic, originalAlert),
              contentType: originalAlert.content_type,
              // XenForo's read state from add-on 1.11.0; before, "not seen"
              isUnread: originalAlert.isUnread ?? !originalAlert.isRead,
            );
          } else {
            // Loading indicator for load more
            return const Padding(
              padding: DesignTokens.paddingL,
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
