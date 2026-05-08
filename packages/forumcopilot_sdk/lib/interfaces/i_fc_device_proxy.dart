import '../models/results/fc_device_result.dart';

/// Forum Copilot Device Proxy Interface
///
/// Manages the mobile app's push-notification device registration on the
/// XenForo server (writes to `xf_fc_device_token` via `forumcopilot.php`).
/// This is distinct from `PushNotificationService` (which talks to the hosted
/// push backend at push.forumcopilot.com) — this proxy talks to the customer's
/// own forum, used for the BYO Firebase ("direct") push mode.
abstract class IFCDeviceProxy {
  /// Register or upsert a device for the current visitor.
  ///
  /// [source] is the routing key consumed by the server-side `DispatchRouter`:
  ///   - 'direct'       — white-label app, will dispatch via the customer's Firebase
  ///   - 'forumcopilot' — official Forum Copilot app, will dispatch via the hosted backend
  Future<FCDeviceResult> registerDeviceAsync({
    required String deviceId,
    required String fcmToken,
    required String platform,
    required String source,
    String? appVersion,
  });

  /// Update the FCM token for an existing device row (e.g. after Firebase rotates the token).
  Future<FCDeviceResult> updateDeviceTokenAsync({
    required String deviceId,
    required String fcmToken,
  });

  /// Remove a device registration (e.g. on logout).
  Future<FCDeviceResult> unregisterDeviceAsync(String deviceId);
}
