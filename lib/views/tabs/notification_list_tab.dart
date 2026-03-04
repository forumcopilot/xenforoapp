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
import '../../utils/url_utils.dart';
import 'package:forumcopilot_flutter/views/widgets/not_signed_in_view.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class NotificationListTab extends StatefulWidget {
  final SiteContext siteContext;
  final bool isActive;
  const NotificationListTab({super.key, required this.isActive, required this.siteContext});

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

  Future<void> _fetchTopics({bool reset = false}) async {
    final currentUsername = widget.siteContext.loginDataOutput?.user?.username;

    // Check authentication state first
    if (!widget.siteContext.isLoggedIn) {
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
      final alertData = await socialProxy.getAlertAsync(_page, _perPage, reset);
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
          _hasMore = topics.length >= _perPage;
          if (_hasMore) _page += 1;
        });
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

    // Handle navigation based on content type
    final contentType = alert.content_type?.toLowerCase() ?? '';

    if (contentType == 'post') {
      // For post type: use getThreadByPost with the post_id
      if (alert.postId == null || alert.postId!.isEmpty) {
        _showErrorDialog(context, 'Post ID is missing. Cannot navigate to the post.');
        return;
      }

      // topicId is now always provided by the API for post alerts
      if (alert.topicId == null || alert.topicId!.isEmpty) {
        _showErrorDialog(context, 'Topic ID is missing. Cannot navigate to the post.');
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostPage(
            siteContext: widget.siteContext,
            topicId: alert.topicId!,
            title: _extractTopicTitleFromMessage(alert.message),
            mode: PostsListMode.thread_by_post,
            anchorPostId: alert.postId,
            forumId: '', // Forum ID may not be available
          ),
        ),
      );
    } else if (contentType == 'thread') {
      // For thread type: open the topic
      final topicId = alert.topic_id ?? alert.content_id;
      if (topicId == null || topicId.isEmpty) {
        _showErrorDialog(context, 'Topic ID is missing. Cannot open the topic.');
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostPage(
            siteContext: widget.siteContext,
            topicId: topicId,
            title: _extractTopicTitleFromMessage(alert.message),
            mode: PostsListMode.first_unread,
            forumId: '', // Forum ID may not be available
          ),
        ),
      );
    } else if (contentType == 'conversation_message') {
      // For conversation_message type: open the conversation
      final conversationId = alert.conversationId ?? alert.content_id;
      if (conversationId == null || conversationId.isEmpty) {
        _showErrorDialog(context, 'Conversation ID is missing. Cannot open the conversation.');
        return;
      }

      // For conversation_message type, contentId is the message ID
      // Use it to navigate to the specific message in the conversation
      final messageId = alert.content_id?.isNotEmpty == true ? alert.content_id : null;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationPage(
            siteContext: widget.siteContext,
            conversationId: conversationId,
            subject: _extractSubjectFromMessage(alert.message),
            anchorMessageId: messageId,
          ),
        ),
      );
    } else if (contentType == 'user') {
      // For user type: open user profile page
      final username = alert.fromUsername ?? alert.username;
      if (username.isEmpty) {
        _showErrorDialog(context, 'Username is missing. Cannot open user profile.');
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfilePage(
            siteContext: widget.siteContext,
            userName: username,
            profilePictureUrl: alert.icon_url,
          ),
        ),
      );
    } else {
      // For all other types: use actionUrl to open in external browser
      final actionUrl = alert.actionUrl;
      if (actionUrl == null || actionUrl.isEmpty) {
        AppLogger.debug('Content type "${alert.content_type}" has no actionUrl. Cannot navigate.');
        _showErrorDialog(context, 'No action URL available for this notification type.');
        return;
      }

      // Open URL in external browser
      await UrlUtils.openUrl(actionUrl);
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
            AppLocalizations.of(context)?.errorTitle ?? 'Error',
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
                'OK',
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
        title: 'Sign in to view notifications',
        message: 'You need to be signed in to view your notifications.',
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
                          'Error loading notifications',
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
                          'Pull down to refresh',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
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
                          "All caught up!",
                          style: textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: DesignTokens.fontWeightBold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: DesignTokens.spacingS),
                        Text(
                          'You have no new notifications. Check back later for updates on topics you\'re following.',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: DesignTokens.spacingL),
                        Text(
                          'Pull down to refresh',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
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
