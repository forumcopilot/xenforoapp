import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_device_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_device_result.dart';
import '../base_xenforo_proxy.dart';

/// XenForo implementation of [IFCDeviceProxy].
/// Hits ForumCopilot's standard `forumcopilot.php` endpoint with the
/// `registerDevice` / `unregisterDevice` / `updateDeviceToken` methods.
class XenForoDeviceProxy extends BaseXenForoProxy implements IFCDeviceProxy {
  XenForoDeviceProxy(SiteContext context) : super(context);

  @override
  Future<FCDeviceResult> registerDeviceAsync({
    required String deviceId,
    required String fcmToken,
    required String platform,
    required String source,
    String? appVersion,
  }) async {
    try {
      final r = await callPluginApi('registerDevice', {
        'deviceId': deviceId,
        'fcmToken': fcmToken,
        'platform': platform,
        'source': source,
        if (appVersion != null && appVersion.isNotEmpty) 'appVersion': appVersion,
      });
      final device = r['device'];
      return FCDeviceResult(
        result: r['result'] == true,
        resultText: r['resultText']?.toString(),
        deviceId: device is Map<String, dynamic> ? device['deviceId']?.toString() : null,
      );
    } catch (e) {
      return FCDeviceResult(result: false, resultText: 'registerDevice error: $e');
    }
  }

  @override
  Future<FCDeviceResult> updateDeviceTokenAsync({
    required String deviceId,
    required String fcmToken,
  }) async {
    try {
      final r = await callPluginApi('updateDeviceToken', {
        'deviceId': deviceId,
        'fcmToken': fcmToken,
      });
      return FCDeviceResult(
        result: r['result'] == true,
        resultText: r['resultText']?.toString(),
        deviceId: deviceId,
      );
    } catch (e) {
      return FCDeviceResult(result: false, resultText: 'updateDeviceToken error: $e');
    }
  }

  @override
  Future<FCDeviceResult> unregisterDeviceAsync(String deviceId) async {
    try {
      final r = await callPluginApi('unregisterDevice', {'deviceId': deviceId});
      return FCDeviceResult(
        result: r['result'] == true,
        resultText: r['resultText']?.toString(),
      );
    } catch (e) {
      return FCDeviceResult(result: false, resultText: 'unregisterDevice error: $e');
    }
  }
}
