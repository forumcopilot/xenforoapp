import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'utils/time_utils.dart';
import 'services/notification_service.dart';
import 'controllers/push_notification_controller.dart';
import 'controllers/notification_settings_controller.dart';
import 'controllers/global_loader_controller.dart';
import 'core/errors/error_handling_init.dart';
import 'core/logging/app_logger.dart';
import 'core/memory/memory_manager.dart';
import 'services/user_state_service.dart';
import 'settings_context.dart';
import 'utils/locale_support_checker.dart';

import 'forumcopilot_app.dart';

// Store pending initial message for Android (opened from terminated state)
RemoteMessage? _pendingInitialMessage;

void main() async {
  AppLogger.info('Starting app initialization...');

  try {
    AppLogger.info('Ensuring Flutter binding...');
    WidgetsFlutterBinding.ensureInitialized();
    AppLogger.info('Flutter binding ensured');

    AppLogger.info('Initializing error handling system...');
    await ErrorHandlingInit.initialize(
      enableErrorDialogs: true,
      enableDebugLogs: true,
    );
    AppLogger.info('Error handling system initialized successfully');

    AppLogger.info('Initializing memory management...');
    MemoryManager().startMonitoring();
    AppLogger.info('Memory management initialized successfully');

    AppLogger.info('Initializing ForumcopilotSdk...');
    await ForumcopilotSdk.ensureInitialized(
      buildContext: globalNavigatorKey.currentContext,
      onCloudflareStart: () {
        // Reset any active global loader before showing the Cloudflare webview.
        if (Get.isRegistered<GlobalLoaderController>()) {
          GlobalLoaderController.to.forceHide();
        }
        AppLogger.debug('Cloudflare challenge detected - disabling global spinner');
      },
      onCloudflareEnd: () {
        // Ensure the Cloudflare flow cannot leave the global loader stuck on.
        if (Get.isRegistered<GlobalLoaderController>()) {
          GlobalLoaderController.to.forceHide();
        }
        AppLogger.debug('Cloudflare challenge finished - reset global spinner');
      },
    );
    AppLogger.info('ForumcopilotSdk initialized successfully');

    AppLogger.info('Initializing user state service...');
    Get.put(UserStateService());
    AppLogger.info('User state service initialized successfully');

    AppLogger.info('Loading app settings...');
    await SettingsContext.instance.loadFromDevice();
    AppLogger.info('App settings loaded successfully');

    // Check locale support for all supported locales (debug only)
    if (kDebugMode) {
      AppLogger.info('Checking locale support for all delegates...');
      final supportedLocales = const [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('it'), // Italian
        Locale('pt'), // Portuguese
        Locale('fr'), // French
        Locale('de'), // German
        Locale('ja'), // Japanese
        Locale('ko'), // Korean
        Locale('zh'), // Chinese
        Locale('ru'), // Russian
      ];
      LocaleSupportChecker.printSupportReport(supportedLocales);

      // Show detailed info for Portuguese (pt) since it's commonly missing support
      AppLogger.info('Checking detailed support for Portuguese (pt) locale...');
      LocaleSupportChecker.printLocaleDetails(const Locale('pt'));
    }

    initializeTimeAgo(); // Initialize timeago messages

    // ⚡ CRITICAL: Run app immediately after critical initialization
    // This allows UI to render while Firebase/notifications initialize in background
    AppLogger.info('Running app...');
    runApp(ForumCopilotApp());
    AppLogger.info('App started successfully - UI can now render');

    // Provide context to Cloudflare interceptor after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ForumcopilotSdk.updateContext(globalNavigatorKey.currentContext);
    });

    // Initialize Firebase and notifications in background (non-blocking)
    // This doesn't block UI rendering
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      _initializeFirebaseAndNotificationsInBackground();
    } else {
      AppLogger.info('Skipping Firebase initialization for ${Platform.operatingSystem}');
      AppLogger.info('Firebase features will not be available');
    }

    // Permissions are now requested on-demand:
    // - Photo/file reading permissions: Requested automatically by image_picker/file_picker when user selects files
    // - Photo saving permissions: Requested on-demand in full_screen_image_viewer when user taps download button

    AppLogger.info('App initialization completed successfully!');
  } catch (e, stackTrace) {
    AppLogger.fatal('Error during app initialization', error: e, stackTrace: stackTrace);
    rethrow;
  }
}

/// Initialize Firebase and notifications in background (non-blocking)
/// This allows UI to render immediately while services initialize
Future<void> _initializeFirebaseAndNotificationsInBackground() async {
  try {
    AppLogger.info('Initializing Firebase for ${Platform.operatingSystem} in background...');

    // Check if Firebase is already initialized
    try {
      Firebase.app(); // This will throw if not initialized
      AppLogger.info('Firebase already initialized');
    } catch (e) {
      AppLogger.info('Firebase not initialized, initializing now...');
      try {
        AppLogger.debug('Calling Firebase.initializeApp()...');
        await Firebase.initializeApp();
        AppLogger.info('✅ Firebase initialized successfully');

        // Verify Firebase is working
        try {
          final app = Firebase.app();
          AppLogger.info('✅ Firebase App Name: ${app.name}');
          AppLogger.info('✅ Firebase Project ID: ${app.options.projectId}');
        } catch (verifyError) {
          AppLogger.warning('Firebase initialized but verification failed', error: verifyError);
        }
      } catch (initError, stackTrace) {
        AppLogger.error('❌ Firebase initialization failed', error: initError, stackTrace: stackTrace);
        AppLogger.error('Error type: ${initError.runtimeType}');
        AppLogger.error('Error message: ${initError.toString()}');
        AppLogger.error('Check your google-services.json (Android) or GoogleService-Info.plist (iOS/macOS)');
        AppLogger.warning('Continuing without Firebase features...');
        return; // Exit early if Firebase fails
      }
    }

    try {
      AppLogger.info('Setting up Firebase messaging background handler...');
      FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
      AppLogger.info('Firebase messaging background handler set up');

      // ⚡ CRITICAL for Android: Check for initial message immediately after Firebase init
      // This must happen before notification service initialization to catch messages
      // that opened the app from terminated state
      if (Platform.isAndroid) {
        AppLogger.info('Checking for initial message on Android...');
        try {
          final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
          if (initialMessage != null) {
            AppLogger.info('Initial message found: ${initialMessage.messageId}');
            AppLogger.debug('Initial message data: ${initialMessage.data}');
            // Store the initial message to be handled after notification service is ready
            _pendingInitialMessage = initialMessage;
          } else {
            AppLogger.info('No initial message found');
          }
        } catch (e) {
          AppLogger.warning('Error checking for initial message', error: e);
        }
      }

      AppLogger.info('Initializing notification service...');
      try {
        final notificationService = NotificationService();
        await notificationService.initialize();
        AppLogger.info('Notification service initialized');

        // Handle pending initial message if it exists (Android)
        if (Platform.isAndroid && _pendingInitialMessage != null) {
          AppLogger.info('Handling pending initial message...');
          // Use a small delay to ensure app is ready for navigation
          Future.delayed(const Duration(milliseconds: 500), () {
            notificationService.handleMessageOpenedApp(_pendingInitialMessage!);
            _pendingInitialMessage = null;
          });
        }

        // Initialize push notification controller when FCM token is ready (event-driven)
        _initializePushNotificationControllerWhenReady(notificationService);
      } catch (e) {
        AppLogger.warning('Notification service initialization failed', error: e);
      }
    } catch (e) {
      AppLogger.warning('Firebase setup failed', error: e);
    }
  } catch (e, stackTrace) {
    AppLogger.error('Error initializing Firebase in background', error: e, stackTrace: stackTrace);
  }
}

/// Initialize push notification controller when FCM token is ready (event-driven)
/// This replaces the polling loop with an event-driven approach
void _initializePushNotificationControllerWhenReady(NotificationService notificationService) {
  AppLogger.info('Setting up event-driven push notification controller initialization...');

  // Check if token is already available
  if (notificationService.fcmToken != null) {
    AppLogger.info('FCM token already available, creating controller immediately');
    _createPushNotificationController();
    return;
  }

  // Listen for token refresh events (event-driven, no polling)
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    AppLogger.info('FCM token received via event listener');
    _createPushNotificationController();
  });

  // Also poll with reasonable intervals as fallback (but don't block)
  // This ensures we catch the token even if event listener doesn't fire
  Future.microtask(() async {
    const maxAttempts = 20; // 20 attempts × 500ms = 10 seconds max
    const pollInterval = Duration(milliseconds: 500);

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      await Future.delayed(pollInterval);

      final token = notificationService.fcmToken;
      if (token != null) {
        AppLogger.info('FCM token available after ${attempt} attempt(s)');
        _createPushNotificationController();
        return;
      }

      if (attempt % 5 == 0) {
        AppLogger.debug('Still waiting for FCM token (attempt $attempt/$maxAttempts)...');
      }
    }

    AppLogger.warning('FCM token not available after $maxAttempts attempts');
    AppLogger.warning('Push notification controller will not be initialized');
  });
}

/// Create and initialize push notification controller
/// The controller will get the FCM token from NotificationService when it initializes
void _createPushNotificationController() {
  try {
    // Check if controller already exists
    if (Get.isRegistered<PushNotificationController>()) {
      AppLogger.info('PushNotificationController already exists, skipping creation');
      return;
    }

    AppLogger.info('Creating PushNotificationController...');
    final pushController = PushNotificationController();
    Get.put(pushController);
    AppLogger.info('PushNotificationController created and added to GetX');

    // Controller will initialize itself in onInit() and get token from NotificationService
    // No need to poll - it will be ready when token is available

    // Initialize notification settings controller
    if (!Get.isRegistered<NotificationSettingsController>()) {
      Get.put(NotificationSettingsController());
      AppLogger.info('NotificationSettingsController initialized');
    }

    AppLogger.info('Push notification controllers initialized successfully');
  } catch (e) {
    AppLogger.warning('Error creating push notification controller', error: e);
  }
}

@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {
  AppLogger.info('Received background message: ${message.messageId}');
  AppLogger.debug('Message data: ${message.data}');
  if (message.notification != null) {
    AppLogger.info('Notification: ${message.notification?.title} - ${message.notification?.body}');
  }
}
