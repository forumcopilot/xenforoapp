import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

/// Whether the OS lets this app show notifications.
enum NotificationPermissionState {
  /// Alerts will display.
  granted,

  /// The user has not been asked yet (or, on Android, refused once without
  /// choosing "don't ask again"); [NotificationPermission.request] shows the
  /// system prompt.
  notDetermined,

  /// Refused. The system will not prompt again; only the app's page in the
  /// system settings can flip it.
  denied,
}

/// The OS notification permission, on the app's terms rather than each
/// platform's: Android 13+ has a runtime permission (permission_handler);
/// Apple platforms answer through UNUserNotificationCenter, reached via
/// firebase_messaging, whose request also registers for remote notifications
/// on the way. Anything else has no gate we can manage and reports granted.
///
/// Kept out of NotificationService on purpose: this asks nothing at launch.
/// The prompt belongs where the user has just read what the alerts are for —
/// the grant page — so [status] and [request] are separate and the caller
/// picks the moment.
class NotificationPermission {
  NotificationPermission._();

  /// Tests pin the answer here: otherwise it depends on the machine the
  /// test runs on (a Mac asks Firebase, which is not set up, and reports
  /// [NotificationPermissionState.notDetermined]; Linux has no gate and
  /// reports [NotificationPermissionState.granted]).
  @visibleForTesting
  static NotificationPermissionState? debugStatus;

  static Future<NotificationPermissionState> status() async {
    final override = debugStatus;
    if (override != null) return override;
    try {
      if (Platform.isAndroid) {
        return _fromAndroid(await Permission.notification.status);
      }
      if (Platform.isIOS || Platform.isMacOS) {
        final settings =
            await FirebaseMessaging.instance.getNotificationSettings();
        return _fromApple(settings.authorizationStatus);
      }
    } catch (e) {
      // Firebase not initialized, plugin missing: nothing to gate on, and a
      // false "blocked" banner would be worse than none.
      AppLogger.debug('NotificationPermission: could not read status: $e');
      return NotificationPermissionState.notDetermined;
    }
    return NotificationPermissionState.granted;
  }

  /// Shows the system prompt. A no-op that reports the current state once the
  /// user has decided — neither platform prompts twice.
  static Future<NotificationPermissionState> request() async {
    try {
      if (Platform.isAndroid) {
        return _fromAndroid(await Permission.notification.request());
      }
      if (Platform.isIOS || Platform.isMacOS) {
        final settings = await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        return _fromApple(settings.authorizationStatus);
      }
    } catch (e) {
      AppLogger.debug('NotificationPermission: request failed: $e');
      return NotificationPermissionState.notDetermined;
    }
    return NotificationPermissionState.granted;
  }

  /// True when the platform has an app settings page the user can be sent
  /// to after refusing.
  static bool get canOpenSettings => Platform.isAndroid || Platform.isIOS;

  /// Opens the app's page in the system settings, where a refused permission
  /// can be turned back on. False when there is no such page.
  static Future<bool> openSettings() async {
    if (!canOpenSettings) return false;
    try {
      return await openAppSettings();
    } catch (e) {
      AppLogger.debug('NotificationPermission: could not open settings: $e');
      return false;
    }
  }

  static NotificationPermissionState _fromAndroid(PermissionStatus status) {
    if (status.isGranted || status.isLimited) {
      return NotificationPermissionState.granted;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      return NotificationPermissionState.denied;
    }
    // `denied` before the first prompt, and after a single refusal: both
    // can still be asked.
    return NotificationPermissionState.notDetermined;
  }

  static NotificationPermissionState _fromApple(AuthorizationStatus status) {
    if (status == AuthorizationStatus.authorized ||
        status == AuthorizationStatus.provisional) {
      return NotificationPermissionState.granted;
    }
    if (status == AuthorizationStatus.denied) {
      return NotificationPermissionState.denied;
    }
    return NotificationPermissionState.notDetermined;
  }
}
