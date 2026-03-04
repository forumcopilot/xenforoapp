import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:forumcopilot_flutter/config/app_forum_config.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:permission_handler/permission_handler.dart';
import 'device_service.dart';
import 'push_notification_service.dart';
import 'package:get/get.dart';
import '../views/single_forum_bootstrap_page.dart';
import '../views/site_home_page.dart';
import '../controllers/site_controller.dart';
import '../controllers/login_controller.dart';
import '../views/login_page.dart';
import '../views/post_page.dart';
import '../views/lists/posts_list.dart';
import '../views/private_messaging/conversation/pages/conversation_page.dart';
import '../views/user_profile_page.dart';
import '../core/errors/error_handling_mixins.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class NotificationService with ServiceErrorHandlingMixin {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final DeviceService _deviceService = DeviceService();
  final PushNotificationService _pushService = PushNotificationService();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Callback for token refresh notifications
  Function(String)? _onTokenRefreshCallback;

  /// Register a callback to be notified when FCM token refreshes
  void setTokenRefreshCallback(Function(String) callback) {
    _onTokenRefreshCallback = callback;
  }

  /// Remove the token refresh callback
  void clearTokenRefreshCallback() {
    _onTokenRefreshCallback = null;
  }

  // Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.debug('🔧 [NotificationService] Starting initialization...');

      // Request permissions with better error handling
      try {
        await _requestPermissions();
        AppLogger.debug('✅ [NotificationService] Permissions requested successfully');
      } catch (e) {
        AppLogger.debug('⚠️ [NotificationService] Permission request failed: $e');
        // Continue without permissions - user can grant them later
      }

      // Initialize local notifications with better error handling
      try {
        await _initializeLocalNotifications();
        AppLogger.debug('✅ [NotificationService] Local notifications initialized');
      } catch (e) {
        AppLogger.debug('⚠️ [NotificationService] Local notifications initialization failed: $e');
        // Continue without local notifications
      }

      await _createAndroidNotificationChannel();

      // Get FCM token with better error handling
      try {
        await _getFCMToken();
        AppLogger.debug('✅ [NotificationService] FCM token retrieved');
      } catch (e) {
        AppLogger.debug('⚠️ [NotificationService] FCM token retrieval failed: $e');
        // Continue without FCM token - it might be available later
      }

      // Setup message handlers
      try {
        _setupMessageHandlers();
        AppLogger.debug('✅ [NotificationService] Message handlers set up');
      } catch (e) {
        AppLogger.debug('⚠️ [NotificationService] Message handlers setup failed: $e');
      }

      // Setup token refresh listener
      try {
        _setupTokenRefreshListener();
        AppLogger.debug('✅ [NotificationService] Token refresh listener set up');
      } catch (e) {
        AppLogger.debug('⚠️ [NotificationService] Token refresh listener setup failed: $e');
      }

      // Test connection to push service (non-critical)
      try {
        await _testPushServiceConnection();
        AppLogger.debug('✅ [NotificationService] Push service connection tested');
      } catch (e) {
        AppLogger.debug('⚠️ [NotificationService] Push service connection test failed: $e');
        // This is not critical for basic functionality
      }

      _isInitialized = true;
      AppLogger.debug('✅ [NotificationService] Initialization completed successfully');
    } catch (e) {
      AppLogger.debug('❌ [NotificationService] Critical initialization error: $e');
      // Don't rethrow - let the app continue without notifications
      _isInitialized = false;
    }
  }

  /// Wait for APNs token using event-driven approach (no fixed delays)
  /// Checks immediately, then polls with short intervals if needed
  Future<String?> _waitForAPNsToken() async {
    try {
      // Try immediately first - token might already be available
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        AppLogger.debug('✅ [NotificationService] APNs token available immediately');
        return apnsToken;
      }

      // If not ready, poll with short intervals (event-driven, not fixed delay)
      AppLogger.debug('⚠️ [NotificationService] APNs token not ready, polling with short intervals...');
      const maxAttempts = 20; // 20 attempts × 300ms = 6 seconds max
      const pollInterval = Duration(milliseconds: 300);

      for (int attempt = 1; attempt <= maxAttempts; attempt++) {
        await Future.delayed(pollInterval);
        apnsToken = await _firebaseMessaging.getAPNSToken();

        if (apnsToken != null) {
          AppLogger.debug('✅ [NotificationService] APNs token available after ${attempt} attempt(s)');
          return apnsToken;
        }

        if (attempt % 5 == 0) {
          AppLogger.debug('🔍 [NotificationService] Still waiting for APNs token (attempt $attempt/$maxAttempts)...');
        }
      }

      AppLogger.debug('⚠️ [NotificationService] APNs token not available after $maxAttempts attempts');
      return null;
    } catch (e) {
      AppLogger.debug('❌ [NotificationService] Error waiting for APNs token: $e');
      return null;
    }
  }

  // Request notification permissions
  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      // Request notification permission for Android 13+
      final status = await Permission.notification.request();
      if (status.isDenied) {
        AppLogger.debug('Notification permission denied');
      }
    }

    // Request Firebase messaging permissions
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    AppLogger.debug('Firebase messaging permission status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      AppLogger.debug('✅ [NotificationService] Permissions granted');

      // Check APNs token on iOS and macOS (both use APNs)
      if (Platform.isIOS || Platform.isMacOS) {
        AppLogger.debug('✅ [NotificationService] Checking for APNs token...');
        // Use event-driven approach: check immediately and poll with short intervals if needed
        await _waitForAPNsToken();
      }
    } else {
      AppLogger.debug('❌ [NotificationService] Permissions not granted: ${settings.authorizationStatus}');
    }
  }

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings, // macOS requires separate settings
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  Future<void> _createAndroidNotificationChannel() async {
    if (!Platform.isAndroid) return;

    const channel = AndroidNotificationChannel(
      'forum_copilot_channel',
      'Forum Copilot Notifications',
      description: 'Notifications for Forum Copilot app',
      importance: Importance.high,
    );

    final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) {
      AppLogger.debug('⚠️ [NotificationService] Android notifications plugin not available');
      return;
    }

    await androidPlugin.createNotificationChannel(channel);
    AppLogger.debug('✅ [NotificationService] Android notification channel created');
  }

  // Get FCM token
  Future<void> _getFCMToken() async {
    try {
      AppLogger.debug('🔍 [NotificationService] Getting FCM token...');

      // Check if Firebase app is initialized
      try {
        final app = Firebase.app();
        AppLogger.debug('🔍 [NotificationService] Firebase app initialized: ${app.name}');
      } catch (e) {
        AppLogger.debug('❌ [NotificationService] Firebase app not initialized: $e');
        return;
      }

      // Check FirebaseMessaging instance
      final messaging = FirebaseMessaging.instance;
      AppLogger.debug('🔍 [NotificationService] FirebaseMessaging instance created');

      // First, ensure APNs token is available (iOS and macOS both use APNs)
      if (Platform.isIOS || Platform.isMacOS) {
        AppLogger.debug('🔍 [NotificationService] Checking for APNs token...');
        String? apnsToken = await _waitForAPNsToken();

        if (apnsToken == null) {
          if (Platform.isMacOS) {
            // For macOS, try to get FCM token anyway - it might work without APNs token
            // or APNs token might come later via event listener
            AppLogger.debug('⚠️ [NotificationService] APNs token not available on macOS, but will try FCM token anyway');
            AppLogger.debug('⚠️ [NotificationService] APNs token may arrive later via system callback');
          } else {
            // For iOS, APNs token is required
            AppLogger.debug('❌ [NotificationService] APNs token not available after retries');
            AppLogger.debug('❌ [NotificationService] This usually means notification permissions are not granted');
            return;
          }
        } else {
          AppLogger.debug('✅ [NotificationService] APNs token available: ${apnsToken.substring(0, 8)}...');
        }
      } else {
        AppLogger.debug('🔍 [NotificationService] Skipping APNs token check (not iOS/macOS)');
      }

      // Now get the FCM token
      // On macOS, this might succeed even if APNs token isn't available yet
      try {
        _fcmToken = await messaging.getToken();
        AppLogger.debug('📱 [NotificationService] FCM Token: ${_fcmToken?.substring(0, 8)}...');

        if (_fcmToken == null) {
          AppLogger.debug('❌ [NotificationService] FCM token is null');
          if (Platform.isMacOS) {
            AppLogger.debug('⚠️ [NotificationService] On macOS, FCM token may require APNs token to be available first');
            AppLogger.debug('⚠️ [NotificationService] Token may become available later when APNs token is received');
          }
        }
      } catch (e) {
        AppLogger.debug('❌ [NotificationService] Error getting FCM token: $e');
        if (Platform.isMacOS) {
          AppLogger.debug('⚠️ [NotificationService] On macOS, this might be due to missing APNs token');
          AppLogger.debug('⚠️ [NotificationService] Token will be retried when APNs token becomes available');
        }
      }
    } catch (e) {
      AppLogger.debug('❌ [NotificationService] Failed to get FCM token: $e');
      AppLogger.debug('❌ [NotificationService] Error type: ${e.runtimeType}');
      if (e is PlatformException) {
        AppLogger.debug('❌ [NotificationService] Platform error code: ${e.code}');
        AppLogger.debug('❌ [NotificationService] Platform error message: ${e.message}');
      }
    }
  }

  // Setup message handlers
  void _setupMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle messages when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Handle messages when app is opened from terminated state
    // Note: On Android, this is checked early in main.dart to avoid timing issues.
    // On iOS, we still check here as a fallback.
    if (Platform.isIOS || Platform.isMacOS) {
      _firebaseMessaging.getInitialMessage().then((message) {
        if (message != null) {
          AppLogger.debug('Initial message found in setupMessageHandlers: ${message.messageId}');
          _handleMessageOpenedApp(message);
        }
      });
    } else {
      // On Android, check getInitialMessage as a fallback (in case it wasn't caught early)
      // This is safe because getInitialMessage() returns null if already consumed
      _firebaseMessaging.getInitialMessage().then((message) {
        if (message != null) {
          AppLogger.debug('Initial message found in setupMessageHandlers (Android fallback): ${message.messageId}');
          // Use a small delay to ensure app is ready for navigation
          Future.delayed(const Duration(milliseconds: 500), () {
            _handleMessageOpenedApp(message);
          });
        }
      });
    }
  }

  // Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    AppLogger.debug('Received foreground message: ${message.messageId}');
    AppLogger.debug('Title: ${message.notification?.title}');
    AppLogger.debug('Body: ${message.notification?.body}');
    AppLogger.debug('Data: ${message.data}');

    // Show local notification when app is in foreground
    await _showLocalNotification(message);
  }

  // Handle message opened app
  void _handleMessageOpenedApp(RemoteMessage message) {
    AppLogger.debug('Message opened app: ${message.messageId}');
    AppLogger.debug('Title: ${message.notification?.title}');
    AppLogger.debug('Body: ${message.notification?.body}');
    AppLogger.debug('Data: ${message.data}');

    // Navigate to specific screen based on message data
    _navigateFromNotification(message.data);
  }

  // Public method to handle message opened app (used for initial messages on Android)
  void handleMessageOpenedApp(RemoteMessage message) {
    _handleMessageOpenedApp(message);
  }

  // Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'forum_copilot_channel',
      'Forum Copilot Notifications',
      channelDescription: 'Notifications for Forum Copilot app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails, // macOS requires separate notification details
    );

    // Encode notification data as JSON for payload
    final payload = jsonEncode(message.data);

    await _localNotifications.show(
      id: message.hashCode,
      title: message.notification?.title ?? 'Forum Copilot',
      body: message.notification?.body ?? 'New notification',
      notificationDetails: details,
      payload: payload,
    );
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    AppLogger.debug('Notification tapped: ${response.payload}');

    if (response.payload == null || response.payload!.isEmpty) {
      AppLogger.debug('⚠️ [NotificationService] Notification tapped but payload is empty');
      return;
    }

    try {
      // Parse the JSON payload
      final Map<String, dynamic> data = jsonDecode(response.payload!);
      AppLogger.debug('🔔 [NotificationService] Parsed notification payload: $data');

      // Navigate using the same logic as remote messages
      _navigateFromNotification(data);
    } catch (e) {
      AppLogger.debug('❌ [NotificationService] Error parsing notification payload: $e');
      AppLogger.debug('⚠️ [NotificationService] Payload was: ${response.payload}');
    }
  }

  // Navigate based on notification data
  Future<void> _navigateFromNotification(Map<String, dynamic> data) async {
    try {
      AppLogger.debug('🔔 [NotificationService] Navigate from notification with data: $data');

      // Extract content type and required fields
      final String contentType = (data['content_type'] ?? '').toString().toLowerCase();
      final dynamic rawSiteId = data['site_id'];

      AppLogger.debug('🔔 [NotificationService] Content type: $contentType');
      AppLogger.debug('🔔 [NotificationService] Site ID: $rawSiteId');

      // Validate required fields
      if (rawSiteId == null) {
        AppLogger.debug('⚠️ [NotificationService] Missing site_id in payload - opening app without navigation');
        _showNotificationError('Unable to open notification', 'Missing site information (site_id).');
        _openAppWithoutNavigation();
        return;
      }

      // Normalize site_id possibly like "580.0" → "580"
      String siteIdStr = rawSiteId.toString();
      if (siteIdStr.contains('.')) {
        siteIdStr = siteIdStr.split('.').first;
      }
      final int? siteId = int.tryParse(siteIdStr);
      if (siteId == null) {
        AppLogger.debug('⚠️ [NotificationService] Unable to parse site_id: $rawSiteId - opening app without navigation');
        _showNotificationError('Unable to open notification', 'Invalid site information (site_id).');
        _openAppWithoutNavigation();
        return;
      }

      final siteController = Get.isRegistered<SiteController>() ? Get.find<SiteController>() : null;
      final currentSite = siteController?.currentSite.value;
      final isSameSite = currentSite?.id != null && currentSite!.id == siteId;
      final isAlreadyInitialized = siteController?.isInitialized.value == true && siteController?.currentSiteContext.value != null;
      if (!(isSameSite && isAlreadyInitialized)) {
        await _resetToHomeIfNeeded();
      }

      // Handle different content types based on new payload format
      if (contentType == 'post') {
        // New unified format: all post-related notifications (mention, like, reply, newtopic)
        // content_id is the post ID
        if (!data.containsKey('content_id')) {
          AppLogger.debug('⚠️ [NotificationService] Missing content_id for post notification - opening app without navigation');
          _showNotificationError('Unable to open notification', 'Missing post information (content_id).');
          _openAppWithoutNavigation();
          return;
        }
        await _handlePostNotification(data, siteId, siteIdStr);
      } else if (contentType == 'conversation_message') {
        // New format: conversation messages use conversation_id
        if (!data.containsKey('conversation_id')) {
          AppLogger.debug('⚠️ [NotificationService] Missing conversation_id for conversation_message notification - opening app without navigation');
          _showNotificationError('Unable to open notification', 'Missing conversation information (conversation_id).');
          _openAppWithoutNavigation();
          return;
        }
        await _handleConversationNotification(data, siteId, siteIdStr);
      } else if (contentType == 'user') {
        // User-related notifications (e.g., following)
        // sender_id contains the user ID to open
        if (!data.containsKey('sender_id')) {
          AppLogger.debug('⚠️ [NotificationService] Missing sender_id for user notification - opening app without navigation');
          _showNotificationError('Unable to open notification', 'Missing user information (sender_id).');
          _openAppWithoutNavigation();
          return;
        }
        await _handleUserNotification(data, siteId, siteIdStr);
      } else {
        AppLogger.debug('🔔 [NotificationService] Unknown content type: $contentType - opening app without navigation');
        _showNotificationError('Unable to open notification', 'Unsupported notification type.');
        _openAppWithoutNavigation();
      }
    } catch (e) {
      AppLogger.debug('❌ [NotificationService] Error navigating from notification: $e - opening app without navigation');
      _showNotificationError('Unable to open notification', e.toString());
      _openAppWithoutNavigation();
    }
  }

  // Resolve forum for notifications in single-forum mode.
  Future<Site?> _findForumBySiteId(int siteId) async {
    try {
      final configuredSite = AppForumConfig.buildSite();

      if (configuredSite.id != null && configuredSite.id != siteId) {
        AppLogger.debug(
          '⚠️ [NotificationService] Incoming site_id $siteId does not match configured site ID ${configuredSite.id}; using configured site',
        );
      }

      return configuredSite;
    } catch (e) {
      AppLogger.debug('❌ [NotificationService] Error finding forum by site_id $siteId: $e');
      return null;
    }
  }

  /// Initialize site and wait for it to be ready
  /// Returns the initialized SiteController, or null if initialization failed
  Future<SiteController?> _initializeSiteAndWait(Site targetForum) async {
    try {
      // Ensure ForumSiteController is available
      final siteController = Get.isRegistered<SiteController>() ? Get.find<SiteController>() : Get.put(SiteController());

      final currentSite = siteController.currentSite.value;
      // Ensure we only short-circuit when the initialized context matches the target forum.
      // This prevents returning stale contexts when switching forums via push notifications.
      final currentContext = siteController.currentSiteContext.value;
      final isSameSite = currentSite?.id != null && currentSite!.id == targetForum.id;
      final isContextMatching = currentContext?.site.id != null && currentContext!.site.id == targetForum.id;
      final isAlreadyInitialized = siteController.isInitialized.value && currentContext != null && isContextMatching;
      if (isSameSite && isAlreadyInitialized) {
        AppLogger.debug('🔔 [NotificationService] Using already initialized forum ${targetForum.name} (${targetForum.id})');
        return siteController;
      }

      // Navigate to forum home which will initialize the forum and attempt auto-login
      AppLogger.debug('🚀 [NotificationService] Opening ForumSiteHomePage for forum ${targetForum.name} (${targetForum.id})');
      Get.to(() => SiteHomePage(
            siteToInitialize: targetForum,
            showGlobalLoader: false,
          ));

      // Wait for initialization to complete with timeout
      const Duration timeout = Duration(seconds: 30);
      final DateTime start = DateTime.now();

      // Wait for both initialization and site context to be ready
      while (DateTime.now().difference(start) < timeout) {
        final siteContext = siteController.currentSiteContext.value;
        final isContextReady = siteController.isInitialized.value && siteContext != null && siteContext.site.id == targetForum.id;
        if (isContextReady) {
          // Initialization complete, but wait a bit more to ensure login and cookies are set
          // This gives time for auto-login to complete and cookies to be restored
          await Future.delayed(const Duration(milliseconds: 500));

          AppLogger.debug('✅ [NotificationService] Forum initialized successfully');
          AppLogger.debug('🔐 [NotificationService] Login state: isLoggedIn=${siteContext!.isLoggedIn}, hasLoginData=${siteContext.loginDataOutput != null}');
          return siteController;
        }
        await Future.delayed(const Duration(milliseconds: 200));
      }

      if (!siteController.isInitialized.value || siteController.currentSiteContext.value == null) {
        AppLogger.debug('⚠️ [NotificationService] Forum initialization timed out for forum ${targetForum.id}');
        return null;
      }

      AppLogger.debug('✅ [NotificationService] Forum initialized successfully');
      return siteController;
    } catch (e) {
      AppLogger.debug('❌ [NotificationService] Error initializing site: $e');
      return null;
    }
  }

  Future<void> _resetToHomeIfNeeded() async {
    if (!Get.isRegistered<SiteController>()) {
      return;
    }

    final siteController = Get.find<SiteController>();
    final hasActiveSite = siteController.isInitialized.value && siteController.currentSiteContext.value != null;
    if (!hasActiveSite) {
      return;
    }

    AppLogger.debug('🧭 [NotificationService] Returning to single-forum bootstrap before notification navigation');
    Get.offAll(() => const SingleForumBootstrapPage());

    // Give the navigator a moment to settle before pushing SiteHomePage.
    await Future.delayed(const Duration(milliseconds: 200));
  }

  // Handle post notification (new unified format: content_type: "post")
  Future<void> _handlePostNotification(
    Map<String, dynamic> data,
    int siteId,
    String siteIdStr,
  ) async {
    try {
      // Extract post ID from content_id
      final dynamic rawPostId = data['content_id'];
      // Normalize post ID (handle cases like "4135.0" → "4135")
      String postId = rawPostId.toString();
      if (postId.contains('.')) {
        postId = postId.split('.').first;
      }
      AppLogger.debug('🔔 [NotificationService] Post notification - Post ID: $postId (normalized from: $rawPostId)');

      // Extract action type for logging (mention, like, reply, etc.)
      final String? action = data.containsKey('action') ? data['action'].toString() : null;
      if (action != null) {
        AppLogger.debug('🔔 [NotificationService] Action: $action');
      }

      // Look up forum by site_id
      AppLogger.debug('🔎 [NotificationService] Looking up forum by site_id: $siteId');
      final Site? targetForum = await _findForumBySiteId(siteId);

      if (targetForum == null) {
        AppLogger.debug('❌ [NotificationService] Forum not found for site_id: $siteId');
        _showNotificationError('Unable to open notification', 'Forum not found for this site.');
        _openAppWithoutNavigation();
        return;
      }

      AppLogger.debug('✅ [NotificationService] Found forum: ${targetForum.name} (${targetForum.id})');

      // Initialize site
      final siteController = await _initializeSiteAndWait(targetForum);
      if (siteController == null || siteController.currentSiteContext.value == null) {
        AppLogger.debug('⚠️ [NotificationService] Failed to initialize site');
        _showNotificationError('Unable to open notification', 'Failed to initialize the forum.');
        _openAppWithoutNavigation();
        return;
      }

      final siteContext = siteController.currentSiteContext.value!;
      if (!siteContext.isLoggedIn) {
        if (!Get.isRegistered<LoginController>()) {
          Get.put(LoginController());
        }
        final loginController = Get.find<LoginController>();
        final loginResult = await loginController.attemptAutomaticLogin(siteContext);
        if (!loginResult.success && loginResult.hadCredentials && Get.currentRoute != '/LoginPage') {
          await Get.to(() => LoginPage(siteContext: siteContext));
        }
        if (!siteContext.isLoggedIn) {
          AppLogger.debug('⚠️ [NotificationService] Proceeding to thread as guest after login screen');
        }
      }

      AppLogger.debug('✅ [NotificationService] Navigating to post $postId');

      // Extract optional forum_id if available
      final String? forumId = data.containsKey('forum_id') ? data['forum_id'].toString() : siteIdStr;

      // Extract topicId (thread_id) from push notification payload
      // topicId is required for:
      // 1. Passing to PostPage constructor
      // 2. Subsequent thread actions (reply, quote, edit, etc.) that need topicId before thread data loads
      // 3. Proper thread context for all operations
      // content_id is the post ID used for getThreadByPost API call
      if (!data.containsKey('topic_id')) {
        AppLogger.debug('⚠️ [NotificationService] Topic ID missing from push notification payload - required for thread actions');
        _showNotificationError('Unable to open notification', 'Missing thread information (topic_id).');
        _openAppWithoutNavigation();
        return;
      }

      final dynamic rawTopicId = data['topic_id'];
      String topicId = rawTopicId.toString();
      if (topicId.contains('.')) {
        topicId = topicId.split('.').first;
      }
      AppLogger.debug('🔔 [NotificationService] Topic ID from payload: $topicId');
      AppLogger.debug('🔔 [NotificationService] Post ID (content_id) for getThreadByPost: $postId');

      // Navigate to the specific post using thread_by_post mode
      // content_id (postId) is used by getThreadByPost API
      // topic_id is passed to PostPage for subsequent thread actions
      final postPageBuilder = () => PostPage(
            siteContext: siteContext,
            topicId: topicId, // Required for thread actions (reply, quote, edit, etc.)
            title: '', // Topic title will be loaded by PostPage
            mode: PostsListMode.thread_by_post,
            anchorPostId: postId, // Used by getThreadByPost API
            forumId: forumId,
          );
      if (Get.currentRoute == '/PostPage') {
        Get.off(postPageBuilder);
      } else {
        Get.to(postPageBuilder);
      }
    } catch (e) {
      AppLogger.debug('❌ [NotificationService] Error handling post notification: $e');
      _showNotificationError('Unable to open notification', e.toString());
      _openAppWithoutNavigation();
    }
  }

  // Handle conversation notification
  Future<void> _handleConversationNotification(
    Map<String, dynamic> data,
    int siteId,
    String siteIdStr,
  ) async {
    try {
      // Extract conversation ID
      final dynamic rawConversationId = data['conversation_id'];
      // Normalize conversation ID (handle cases like "518.0" → "518")
      String conversationId = rawConversationId.toString();
      if (conversationId.contains('.')) {
        conversationId = conversationId.split('.').first;
      }
      AppLogger.debug('🔔 [NotificationService] Conversation ID: $conversationId (normalized from: $rawConversationId)');

      // Extract optional message ID for navigating to a specific message
      // content_id contains the message ID
      String? messageId;
      if (data.containsKey('content_id') && data['content_id'] != null) {
        // Normalize message ID (handle cases like "4135.0" → "4135")
        String rawMessageId = data['content_id'].toString();
        if (rawMessageId.contains('.')) {
          rawMessageId = rawMessageId.split('.').first;
        }
        messageId = rawMessageId;
        if (messageId.isNotEmpty) {
          AppLogger.debug('🔔 [NotificationService] Message ID: $messageId (normalized from: ${data['content_id']})');
        }
      }

      // Extract optional subject, default to "Conversation" if not provided
      final String subject = data.containsKey('subject') ? data['subject'].toString() : 'Conversation';

      // Look up forum by site_id
      AppLogger.debug('🔎 [NotificationService] Looking up forum by site_id: $siteId');
      final Site? targetForum = await _findForumBySiteId(siteId);

      if (targetForum == null) {
        AppLogger.debug('❌ [NotificationService] Forum not found for site_id: $siteId');
        _showNotificationError('Unable to open notification', 'Forum not found for this site.');
        _openAppWithoutNavigation();
        return;
      }

      AppLogger.debug('✅ [NotificationService] Found forum: ${targetForum.name} (${targetForum.id})');

      // Initialize site
      final siteController = await _initializeSiteAndWait(targetForum);
      if (siteController == null || siteController.currentSiteContext.value == null) {
        AppLogger.debug('⚠️ [NotificationService] Failed to initialize site');
        _showNotificationError('Unable to open notification', 'Failed to initialize the forum.');
        _openAppWithoutNavigation();
        return;
      }

      AppLogger.debug('✅ [NotificationService] Navigating to conversation $conversationId${messageId != null ? ' (message: $messageId)' : ''}');

      // Navigate to the conversation, with optional message ID for highlighting
      final conversationPageBuilder = () => ConversationPage(
            siteContext: siteController.currentSiteContext.value!,
            conversationId: conversationId,
            subject: subject,
            anchorMessageId: messageId,
          );
      if (Get.currentRoute == '/ConversationPage') {
        Get.off(conversationPageBuilder);
      } else {
        Get.to(conversationPageBuilder);
      }
    } catch (e) {
      AppLogger.debug('❌ [NotificationService] Error handling conversation notification: $e');
      _showNotificationError('Unable to open notification', e.toString());
      _openAppWithoutNavigation();
    }
  }

  // Handle user notification (new format: content_type: "user")
  Future<void> _handleUserNotification(
    Map<String, dynamic> data,
    int siteId,
    String siteIdStr,
  ) async {
    try {
      // Extract user ID from sender_id
      final dynamic rawUserId = data['sender_id'];
      final String userId = rawUserId.toString();
      AppLogger.debug('🔔 [NotificationService] User notification - User ID: $userId');

      // Extract action type for logging (following, etc.)
      final String? action = data.containsKey('action') ? data['action'].toString() : null;
      if (action != null) {
        AppLogger.debug('🔔 [NotificationService] Action: $action');
      }

      // Look up forum by site_id
      AppLogger.debug('🔎 [NotificationService] Looking up forum by site_id: $siteId');
      final Site? targetForum = await _findForumBySiteId(siteId);

      if (targetForum == null) {
        AppLogger.debug('❌ [NotificationService] Forum not found for site_id: $siteId');
        _showNotificationError('Unable to open notification', 'Forum not found for this site.');
        _openAppWithoutNavigation();
        return;
      }

      AppLogger.debug('✅ [NotificationService] Found forum: ${targetForum.name} (${targetForum.id})');

      // Initialize site
      final siteController = await _initializeSiteAndWait(targetForum);
      if (siteController == null || siteController.currentSiteContext.value == null) {
        AppLogger.debug('⚠️ [NotificationService] Failed to initialize site');
        _showNotificationError('Unable to open notification', 'Failed to initialize the forum.');
        _openAppWithoutNavigation();
        return;
      }

      AppLogger.debug('✅ [NotificationService] Navigating to user profile: $userId');

      // Navigate to the user profile
      Get.to(() => UserProfilePage(
            siteContext: siteController.currentSiteContext.value!,
            userId: userId,
          ));
    } catch (e) {
      AppLogger.debug('❌ [NotificationService] Error handling user notification: $e');
      _showNotificationError('Unable to open notification', e.toString());
      _openAppWithoutNavigation();
    }
  }

  void _showNotificationError(String title, String message) {
    final context = Get.context;
    if (context == null) {
      AppLogger.debug('⚠️ [NotificationService] No context available for error dialog');
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) {
          final colorScheme = Theme.of(dialogContext).colorScheme;
          final textTheme = Theme.of(dialogContext).textTheme;
          return AlertDialog(
            backgroundColor: colorScheme.surface,
            title: Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            content: Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'OK',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  // Open app without specific navigation (fallback)
  void _openAppWithoutNavigation() {
    AppLogger.debug('🔔 [NotificationService] Opening app without specific navigation');
    // The app is already open, so no additional action needed
    // This prevents crashes when payload is incomplete
  }

  // Refresh FCM token
  Future<void> refreshToken() async {
    await _getFCMToken();
  }

  // Setup token refresh listener
  void _setupTokenRefreshListener() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      AppLogger.debug('FCM token refreshed: ${newToken.substring(0, 8)}...');
      _fcmToken = newToken;

      // Notify registered callback (e.g., PushNotificationController)
      if (_onTokenRefreshCallback != null) {
        _onTokenRefreshCallback!(newToken);
      }
    });

    // For macOS/iOS: Periodically check for APNs token and retry FCM token if needed
    if (Platform.isIOS || Platform.isMacOS) {
      _startAPNsTokenPolling();
    }
  }

  // Periodically check for APNs token and retry FCM token retrieval
  void _startAPNsTokenPolling() {
    // Only poll if we don't have an FCM token yet
    if (_fcmToken != null) {
      AppLogger.debug('✅ [NotificationService] FCM token already available, skipping APNs polling');
      return;
    }

    AppLogger.debug('🔄 [NotificationService] Starting APNs token polling for FCM token retrieval...');

    // Poll every 2 seconds for up to 60 seconds (30 attempts)
    int attempts = 0;
    const maxAttempts = 30;
    const pollInterval = Duration(seconds: 2);

    Timer.periodic(pollInterval, (timer) async {
      attempts++;

      try {
        // Check if APNs token is now available
        String? apnsToken = await _firebaseMessaging.getAPNSToken();

        if (apnsToken != null) {
          AppLogger.debug('✅ [NotificationService] APNs token now available! Retrying FCM token retrieval...');
          timer.cancel();

          // Now try to get FCM token
          try {
            _fcmToken = await _firebaseMessaging.getToken();
            if (_fcmToken != null) {
              AppLogger.debug('✅ [NotificationService] FCM token successfully retrieved after APNs token became available');
              AppLogger.debug('📱 [NotificationService] FCM Token: ${_fcmToken!.substring(0, 8)}...');
            } else {
              AppLogger.debug('❌ [NotificationService] FCM token is still null even with APNs token');
            }
          } catch (e) {
            AppLogger.debug('❌ [NotificationService] Error getting FCM token after APNs token: $e');
          }
        } else if (attempts >= maxAttempts) {
          AppLogger.debug('⏱️ [NotificationService] APNs token polling timeout after ${maxAttempts * 2} seconds');
          AppLogger.debug('⚠️ [NotificationService] This usually means Push Notifications is not enabled in Apple Developer Portal');
          AppLogger.debug('⚠️ [NotificationService] Or APNs Auth Key is not configured in Firebase Console');
          timer.cancel();
        } else if (attempts % 5 == 0) {
          // Log every 5 attempts (every 10 seconds)
          AppLogger.debug('🔄 [NotificationService] Still polling for APNs token (${attempts * 2}s elapsed)...');
        }
      } catch (e) {
        AppLogger.debug('❌ [NotificationService] Error during APNs token polling: $e');
        timer.cancel();
      }
    });
  }

  // Test connection to push service
  Future<void> _testPushServiceConnection() async {
    try {
      final isConnected = await _pushService.testConnection();
      if (isConnected) {
        AppLogger.debug('Push service connection test: SUCCESS');
      } else {
        AppLogger.debug('Push service connection test: FAILED');
      }
    } catch (e) {
      AppLogger.debug('Push service connection test error: $e');
    }
  }

  // Get device info for registration
  Future<Map<String, dynamic>?> getDeviceInfoForRegistration() async {
    try {
      if (_fcmToken == null) {
        AppLogger.debug('FCM token not available for registration');
        return null;
      }

      final deviceInfo = await _deviceService.getDeviceInfo();
      return {
        'device_id': deviceInfo.deviceId,
        'firebase_token': _fcmToken!,
        'platform': deviceInfo.platform,
        'app_version': deviceInfo.appVersion,
        'device_model': deviceInfo.deviceModel,
        'os_version': deviceInfo.osVersion,
      };
    } catch (e) {
      AppLogger.debug('Error getting device info for registration: $e');
      return null;
    }
  }

  // Check if service is ready for registration
  bool get isReadyForRegistration {
    return _isInitialized && _fcmToken != null;
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      AppLogger.debug('Subscribed to topic: $topic');
    } catch (e) {
      AppLogger.debug('Error subscribing to topic $topic: $e');
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      AppLogger.debug('Unsubscribed from topic: $topic');
    } catch (e) {
      AppLogger.debug('Error unsubscribing from topic $topic: $e');
    }
  }
}
