import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:forumcopilot_flutter/config/app_forum_config.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import '../models/notification_preferences.dart';
import 'package:forumcopilot_flutter/core/errors/error_handling_mixins.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

/// Service for communicating with ForumCopilot push notification backend
class PushNotificationService with ServiceErrorHandlingMixin {
  static const int timeoutSeconds = 30;
  static const int maxRetries = 3;

  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  String get _baseUrl {
    if (!AppForumConfig.isPushBackendEnabled) {
      throw UnsupportedError(
        'Push backend is disabled. Set AppForumConfig.pushApiBaseUrl to enable it.',
      );
    }
    return AppForumConfig.pushApiBaseUrl.trim();
  }

  /// Get headers for API requests
  Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
      'User-Agent': 'ForumCopilot-Flutter/1.0',
    };
  }

  Map<String, dynamic> _decodeResponseData(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is String) {
      try {
        return jsonDecode(data) as Map<String, dynamic>;
      } catch (_) {
        return {};
      }
    }
    return {};
  }

  /// Register device for a specific site
  Future<bool> registerDeviceForSite({
    required String deviceId,
    required String firebaseToken,
    required String platform,
    required String appVersion,
    required String siteId,
    required String siteUserId,
    required String siteUsername,
    required NotificationPreferences preferences,
  }) async {
    // Skip the hosted-backend registration entirely when no backend URL is set.
    // BYO/direct builds set pushApiBaseUrl='' — there's nothing to register against.
    // The direct-mode registration happens separately via PushNotificationController._tryRegisterDirect.
    if (!AppForumConfig.isPushBackendEnabled) {
      AppLogger.debug('[PushNotificationService] Hosted backend disabled — skipping registerDeviceForSite');
      return true; // Treat as success so the controller's retry chain doesn't fire.
    }
    try {
      AppLogger.debug('Registering device for site: $siteId, user: $siteUsername');

      final response = await _makeRequest(
        'POST',
        '/devices/register',
        {
          'device_id': deviceId,
          'firebase_token': firebaseToken,
          'platform': platform,
          'app_version': appVersion,
          'site_id': siteId,
          'site_user_id': siteUserId,
          'site_username': siteUsername,
          'notification_preferences': preferences.toJson(),
        },
      );

      if ((response.statusCode ?? 0) == 200) {
        final responseData = _decodeResponseData(response);
        final statusCode = responseData['statusCode'] ?? 0;
        final data = responseData['data'] as Map<String, dynamic>?;
        final message = data?['message'] ?? 'Unknown response';

        if (statusCode == 200) {
          AppLogger.debug('Device registration successful: $message');

          // Log device info if available
          if (data != null && data.containsKey('device')) {
            final device = data['device'] as Map<String, dynamic>;
            AppLogger.debug('Device ID: ${device['device_id']}');
            AppLogger.debug('Platform: ${device['platform']}');
            AppLogger.debug('Active: ${device['is_active']}');
          }

          return true;
        } else {
          AppLogger.debug('Device registration failed: $message');
          return false;
        }
      } else {
        AppLogger.debug('Device registration failed with HTTP status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      AppLogger.debug('Error registering device for site: $e');
      return false;
    }
  }

  /// Update Firebase token for a device
  Future<bool> updateDeviceToken({
    required String deviceId,
    required String newFirebaseToken,
  }) async {
    if (!AppForumConfig.isPushBackendEnabled) return true; // hosted backend disabled
    try {
      AppLogger.debug('Updating device token for device: ${deviceId.substring(0, 8)}...');

      final response = await _makeRequest(
        'POST',
        '/devices/update-token',
        {
          'device_id': deviceId,
          'firebase_token': newFirebaseToken,
        },
      );

      if ((response.statusCode ?? 0) == 200) {
        final responseData = _decodeResponseData(response);
        final statusCode = responseData['statusCode'] ?? 0;
        final data = responseData['data'] as Map<String, dynamic>?;
        final message = data?['message'] ?? 'Unknown response';

        if (statusCode == 200) {
          AppLogger.debug('Token update successful: $message');
          return true;
        } else {
          AppLogger.debug('Token update failed: $message');
          return false;
        }
      } else {
        AppLogger.debug('Token update failed with HTTP status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      AppLogger.debug('Error updating device token: $e');
      return false;
    }
  }

  /// Unregister device from a specific site
  Future<bool> unregisterDeviceFromSite({
    required String deviceId,
    required String siteId,
    required String siteUserId,
  }) async {
    try {
      AppLogger.debug('Unregistering device from site: $siteId, user: $siteUserId');

      final response = await _makeRequest(
        'POST',
        '/devices/unregister',
        {
          'device_id': deviceId,
          'site_id': siteId,
          'site_user_id': siteUserId,
        },
      );

      if ((response.statusCode ?? 0) == 200) {
        final responseData = _decodeResponseData(response);
        final statusCode = responseData['statusCode'] ?? 0;
        final data = responseData['data'] as Map<String, dynamic>?;
        final message = data?['message'] ?? 'Unknown response';

        if (statusCode == 200) {
          AppLogger.debug('Device unregistration successful: $message');
          return true;
        } else {
          AppLogger.debug('Device unregistration failed: $message');
          return false;
        }
      } else {
        AppLogger.debug('Device unregistration failed with HTTP status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      AppLogger.debug('Error unregistering device from site: $e');
      return false;
    }
  }

  /// Get badge count for a device
  Future<int> getBadgeCount(String deviceId) async {
    try {
      AppLogger.debug('Getting badge count for device: ${deviceId.substring(0, 8)}...');

      final response = await _makeRequest(
        'GET',
        '/devices/$deviceId/badge',
        null,
      );

      if ((response.statusCode ?? 0) == 200) {
        final responseData = _decodeResponseData(response);
        final statusCode = responseData['statusCode'] ?? 0;
        final data = responseData['data'] as Map<String, dynamic>?;

        if (statusCode == 200 && data != null) {
          final badgeCount = data['badge_count'] ?? 0;
          AppLogger.debug('Badge count: $badgeCount');
          return badgeCount;
        } else {
          AppLogger.debug('Failed to get badge count: ${data?['message'] ?? 'Unknown error'}');
          return 0;
        }
      } else {
        AppLogger.debug('Failed to get badge count with HTTP status: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      AppLogger.debug('Error getting badge count: $e');
      return 0;
    }
  }

  /// Reset badge count for a device
  Future<bool> resetBadgeCount({
    required String deviceId,
    String? siteId,
  }) async {
    try {
      AppLogger.debug('Resetting badge count for device: ${deviceId.substring(0, 8)}...');

      final body = siteId != null ? <String, dynamic>{'site_id': siteId} : <String, dynamic>{};

      final response = await _makeRequest(
        'POST',
        '/devices/$deviceId/badge/reset',
        body,
      );

      if ((response.statusCode ?? 0) == 200) {
        final responseData = _decodeResponseData(response);
        final statusCode = responseData['statusCode'] ?? 0;
        final data = responseData['data'] as Map<String, dynamic>?;
        final message = data?['message'] ?? 'Unknown response';

        if (statusCode == 200) {
          AppLogger.debug('Badge reset successful: $message');
          return true;
        } else {
          AppLogger.debug('Badge reset failed: $message');
          return false;
        }
      } else {
        AppLogger.debug('Badge reset failed with HTTP status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      AppLogger.debug('Error resetting badge count: $e');
      return false;
    }
  }

  /// Check service health
  Future<bool> checkHealth() async {
    try {
      AppLogger.debug('Checking push service health...');

      final response = await _makeRequest(
        'GET',
        '/health',
        null,
      );

      if ((response.statusCode ?? 0) == 200) {
        final responseData = _decodeResponseData(response);
        final statusCode = responseData['statusCode'] ?? 0;
        final data = responseData['data'] as Map<String, dynamic>?;

        if (statusCode == 200 && data != null) {
          final isHealthy = data['status'] == 'healthy';
          AppLogger.debug('Service health: ${isHealthy ? 'healthy' : 'unhealthy'}');
          return isHealthy;
        } else {
          AppLogger.debug('Health check failed: ${data?['message'] ?? 'Unknown error'}');
          return false;
        }
      } else {
        AppLogger.debug('Health check failed with HTTP status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      AppLogger.debug('Error checking service health: $e');
      return false;
    }
  }

  /// Make HTTP request with retry logic using FCHttpClient
  Future<Response> _makeRequest(
    String method,
    String endpoint,
    Map<String, dynamic>? body,
  ) async {
    final uri = Uri.parse('${_baseUrl}$endpoint');
    final headers = await _getHeaders();

    int attempts = 0;
    Exception? lastException;

    while (attempts < maxRetries) {
      try {
        Response response;

        switch (method.toUpperCase()) {
          case 'GET':
            response = await FCHttpClient.get(
              uri,
              headers: headers,
              responseType: ResponseType.plain,
            );
            break;
          case 'POST':
            response = await FCHttpClient.post(
              uri,
              headers: headers,
              body: body != null ? jsonEncode(body) : null,
              responseType: ResponseType.plain,
            );
            break;
          default:
            throw Exception('Unsupported HTTP method: $method');
        }

        // If successful, return response
        if ((response.statusCode ?? 0) < 500) {
          return response;
        }

        // If server error, retry
        attempts++;
        if (attempts < maxRetries) {
          final delay = Duration(seconds: attempts * 2);
          AppLogger.debug('Server error ${response.statusCode}, retrying in ${delay.inSeconds}s...');
          await Future.delayed(delay);
        }
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        attempts++;

        if (attempts < maxRetries) {
          final delay = Duration(seconds: attempts * 2);
          AppLogger.debug('Request failed, retrying in ${delay.inSeconds}s... Error: $e');
          await Future.delayed(delay);
        }
      }
    }

    // All retries failed
    throw lastException ?? Exception('Request failed after $maxRetries attempts');
  }

  /// Test connection to push service
  Future<bool> testConnection() async {
    // Skip the probe entirely when no hosted backend is configured (BYO/direct
    // builds set pushApiBaseUrl='' — the probe would always fail and spam logs).
    if (!AppForumConfig.isPushBackendEnabled) {
      return true; // Treat as a no-op success.
    }
    try {
      final isHealthy = await checkHealth();
      if (isHealthy) {
        AppLogger.debug('Push service connection test: SUCCESS');
        return true;
      } else {
        AppLogger.debug('Push service connection test: FAILED - Service unhealthy');
        return false;
      }
    } catch (e) {
      AppLogger.debug('Push service connection test: FAILED - $e');
      return false;
    }
  }

  /// Get service status information
  Future<Map<String, dynamic>?> getServiceStatus() async {
    try {
      final response = await _makeRequest('GET', '/health', null);

      if ((response.statusCode ?? 0) == 200) {
        return _decodeResponseData(response);
      }

      return null;
    } catch (e) {
      AppLogger.debug('Error getting service status: $e');
      return null;
    }
  }

  /// Dispose resources (no-op for FCHttpClient)
  void dispose() {
    // FCHttpClient is static and doesn't need to be closed
  }
}
