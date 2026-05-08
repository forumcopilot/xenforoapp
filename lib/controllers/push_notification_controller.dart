import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_forum_config.dart';
import '../models/site_notification_state.dart';
import '../models/notification_preferences.dart';
import '../services/device_service.dart';
import '../services/push_notification_service.dart';
import '../services/notification_preferences_service.dart';
import '../services/notification_service.dart';
import '../services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/core/errors/error_handling_mixins.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'site_controller.dart';

/// Main controller for managing push notifications across multiple sites
class PushNotificationController extends GetxController with ErrorHandlingMixin {
  static PushNotificationController get to => Get.find();

  // Services
  final DeviceService _deviceService = DeviceService();
  final PushNotificationService _pushService = PushNotificationService();
  final NotificationPreferencesService _preferencesService = NotificationPreferencesService();
  final NotificationService _notificationService = NotificationService();

  // Storage key
  static const String _storageKey = 'push_notification_site_states';

  // State management
  final Map<String, SiteNotificationState> _siteStates = {};
  String? _deviceId;
  String? _fcmToken;
  bool _isInitialized = false;
  String? _lastError;
  bool _hasNetworkError = false;


  // Reactive getters
  Map<String, SiteNotificationState> get siteStates => Map.from(_siteStates);
  List<SiteNotificationState> get registeredSites => _siteStates.values.where((state) => state.isRegistered).toList();
  List<SiteNotificationState> get unregisteredSites => _siteStates.values.where((state) => !state.isRegistered).toList();

  bool get isInitialized => _isInitialized;
  String? get deviceId => _deviceId;
  String? get fcmToken => _fcmToken;
  String? get lastError => _lastError;
  bool get hasNetworkError => _hasNetworkError;

  int get totalRegisteredSites => registeredSites.length;
  int get totalUnregisteredSites => unregisteredSites.length;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  /// Initialize the push notification system
  Future<void> _initialize() async {
    try {
      AppLogger.debug('Initializing PushNotificationController...');
      _lastError = null;
      _hasNetworkError = false;

      // Get device ID
      _deviceId = await _deviceService.getDeviceId();

      // Get FCM token
      _fcmToken = _notificationService.fcmToken;

      if (_fcmToken == null) {
        throw Exception('FCM token not available');
      }

      // Register token refresh callback with NotificationService (consolidated listener)
      _notificationService.setTokenRefreshCallback(_handleTokenRefresh);

      // Load existing site states from storage
      await _loadExistingStates();

      // Re-register sites that were previously registered
      await _reRegisterPersistedSites();

      // BYO/direct push: register device with the forum's own server.
      await _tryRegisterDirect();

      // Re-fire when the user logs in later (registration requires an authenticated session).
      _watchLoginForDirectRegistration();

      _isInitialized = true;
      AppLogger.debug('PushNotificationController initialized successfully');
      AppLogger.debug('Loaded ${_siteStates.length} site states, ${registeredSites.length} registered');
      update();
    } catch (e) {
      _lastError = e.toString();
      _hasNetworkError = _isNetworkError(e);
      AppLogger.debug('Error initializing PushNotificationController: $e');
      update();
    }
  }

  // ----- BYO/direct mode device registration ---------------------------

  bool _hasDirectRegistered = false;
  Worker? _loginWatcher;

  /// Attempts to register this device with the forum's own server for the
  /// BYO Firebase ("direct") push mode. No-op when this build isn't a direct
  /// build, or when prerequisites (token, login) aren't satisfied yet.
  Future<void> _tryRegisterDirect({String? overrideToken}) async {
    if (AppForumConfig.pushSource != 'direct') return;
    if (_deviceId == null) return;
    final token = overrideToken ?? _fcmToken;
    if (token == null || token.isEmpty) return;

    final ctx = Get.isRegistered<SiteController>()
        ? Get.find<SiteController>().currentSiteContext.value
        : null;
    if (ctx == null || !ctx.isLoggedIn) {
      AppLogger.debug('[DirectPush] Skipping register — not logged in yet');
      return;
    }

    try {
      final deviceInfo = await _deviceService.getDeviceInfo();
      final proxy = SiteProxyService.getDeviceProxy();
      final r = await proxy.registerDeviceAsync(
        deviceId: _deviceId!,
        fcmToken: token,
        platform: deviceInfo.platform,
        source: 'direct',
        appVersion: deviceInfo.appVersion,
      );
      if (r.result) {
        _hasDirectRegistered = true;
        AppLogger.debug('[DirectPush] Registered device ${_deviceId!.substring(0, 8)}... '
            'platform=${deviceInfo.platform} on forum ${ctx.site.url}');
      } else {
        AppLogger.debug('[DirectPush] Register failed: ${r.resultText}');
      }
    } catch (e) {
      AppLogger.debug('[DirectPush] Register error: $e');
    }
  }

  /// Unregister this device from direct-mode push (BYO Firebase). Call on
  /// logout so the server stops dispatching to this token after the user
  /// signs out.
  Future<bool> unregisterDirect() async {
    if (AppForumConfig.pushSource != 'direct') return true;
    if (_deviceId == null) return true;
    if (!_hasDirectRegistered) return true;

    try {
      final proxy = SiteProxyService.getDeviceProxy();
      final r = await proxy.unregisterDeviceAsync(_deviceId!);
      if (r.result) {
        _hasDirectRegistered = false;
        AppLogger.debug('[DirectPush] Unregistered device ${_deviceId!.substring(0, 8)}...');
        return true;
      }
      AppLogger.debug('[DirectPush] Unregister failed: ${r.resultText}');
      return false;
    } catch (e) {
      AppLogger.debug('[DirectPush] Unregister error: $e');
      return false;
    }
  }

  /// Listens for the user to become logged in and (re-)attempts direct
  /// registration. Called once during init.
  void _watchLoginForDirectRegistration() {
    if (AppForumConfig.pushSource != 'direct') return;
    if (_loginWatcher != null) return;
    if (!Get.isRegistered<SiteController>()) return;

    final siteCtrl = Get.find<SiteController>();
    _loginWatcher = ever<dynamic>(siteCtrl.currentSiteContext, (_) async {
      final ctx = siteCtrl.currentSiteContext.value;
      if (ctx != null && ctx.isLoggedIn && !_hasDirectRegistered) {
        await _tryRegisterDirect();
      }
    });
  }

  /// Handle token refresh from NotificationService (consolidated listener)
  Future<void> _handleTokenRefresh(String newToken) async {
    AppLogger.debug('FCM token refreshed, updating all registrations...');
    _fcmToken = newToken;

    // BYO/direct: re-register with the new token.
    if (AppForumConfig.pushSource == 'direct' && _hasDirectRegistered) {
      _hasDirectRegistered = false; // force re-register with new token
    }
    await _tryRegisterDirect(overrideToken: newToken);

    // Show toast notification
    _showToast('Updating push notification token...', isError: false);

    // Update token for all registered sites in parallel
    final sitesToUpdate = registeredSites.map((state) => state.siteId).toList();
    if (sitesToUpdate.isNotEmpty) {
      final results = await Future.wait(
        sitesToUpdate.map((siteId) => _updateTokenForSite(siteId)),
      );

      final successCount = results.where((success) => success).length;
      final failureCount = results.length - successCount;

      if (failureCount == 0) {
        _showToast('Push notification token updated successfully', isError: false);
      } else {
        _showToast('Token updated for $successCount site(s), $failureCount failed', isError: true);
      }
    }

    update();
  }

  /// Load existing site states from storage
  Future<void> _loadExistingStates() async {
    try {
      AppLogger.debug('Loading site states from storage...');
      final prefs = await SharedPreferences.getInstance();
      final statesJson = prefs.getString(_storageKey);

      if (statesJson == null || statesJson.isEmpty) {
        AppLogger.debug('No saved site states found');
        return;
      }

      final statesList = jsonDecode(statesJson) as List<dynamic>;
      _siteStates.clear();

      for (final stateJson in statesList) {
        try {
          final state = SiteNotificationState.fromJson(stateJson as Map<String, dynamic>);
          if (state.isValid) {
            _siteStates[state.siteId] = state;
            AppLogger.debug('Loaded state for site: ${state.siteName} (${state.siteId}) - Registered: ${state.isRegistered}');
          } else {
            AppLogger.debug('Skipping invalid state: ${state.siteId}');
          }
        } catch (e) {
          AppLogger.debug('Error parsing site state: $e');
        }
      }

      AppLogger.debug('Loaded ${_siteStates.length} site states from storage');
    } catch (e) {
      AppLogger.debug('Error loading existing states: $e');
      // Continue with empty state if loading fails
      _siteStates.clear();
    }
  }

  /// Save site states to storage
  Future<void> _saveSiteStates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statesList = _siteStates.values.map((state) => state.toJson()).toList();
      final statesJson = jsonEncode(statesList);
      await prefs.setString(_storageKey, statesJson);
      AppLogger.debug('Saved ${_siteStates.length} site states to storage');
    } catch (e) {
      AppLogger.debug('Error saving site states: $e');
    }
  }

  /// Re-register sites that were previously registered (after app restart)
  Future<void> _reRegisterPersistedSites() async {
    if (_deviceId == null || _fcmToken == null) {
      AppLogger.debug('Cannot re-register sites: device ID or FCM token not available');
      return;
    }

    final sitesToReRegister = _siteStates.values.where((state) => state.isRegistered).toList();
    
    if (sitesToReRegister.isEmpty) {
      AppLogger.debug('No sites to re-register');
      return;
    }

    AppLogger.debug('Re-registering ${sitesToReRegister.length} previously registered sites...');

    // Re-register sites in parallel for better performance
    final deviceInfo = await _deviceService.getDeviceInfo();
    final results = await Future.wait(
      sitesToReRegister.map((state) async {
        try {
          final success = await _pushService.registerDeviceForSite(
            deviceId: _deviceId!,
            firebaseToken: _fcmToken!,
            platform: deviceInfo.platform,
            appVersion: deviceInfo.appVersion,
            siteId: state.siteId,
            siteUserId: state.userId,
            siteUsername: state.username,
            preferences: state.preferences,
          );

          if (success) {
            _siteStates[state.siteId] = state.markAsRegistered();
            AppLogger.debug('Successfully re-registered site: ${state.siteName}');
            return true;
          } else {
            _siteStates[state.siteId] = state.markRegistrationError('Re-registration failed');
            AppLogger.debug('Failed to re-register site: ${state.siteName}');
            return false;
          }
        } catch (e) {
          AppLogger.debug('Error re-registering site ${state.siteName}: $e');
          _siteStates[state.siteId] = state.markRegistrationError(e.toString());
          return false;
        }
      }),
    );

    final successCount = results.where((success) => success).length;
    if (successCount > 0) {
      AppLogger.debug('Re-registered $successCount out of ${sitesToReRegister.length} sites');
    }

    // Save updated states
    await _saveSiteStates();
    update();
  }

  /// Register device for a specific site with retry logic
  Future<bool> registerSite({
    required String siteId,
    required String siteUrl,
    required String siteName,
    required String userId,
    required String username,
    NotificationPreferences? preferences,
    int maxRetries = 2,
    bool suppressToasts = false, // Suppress toast messages (e.g., during login)
    Duration? toastDelay, // Delay before showing toasts (useful for non-blocking operations)
  }) async {
    try {
      if (!_isInitialized || _deviceId == null || _fcmToken == null) {
        final errorMsg = 'Push notification system not ready for registration';
        AppLogger.debug(errorMsg);
        _lastError = errorMsg;
        _showToast('Push notifications not ready', isError: true);
        update();
        return false;
      }

      AppLogger.debug('Registering device for site: $siteName ($siteId)');
      _lastError = null;
      _hasNetworkError = false;

      // Show toast for registration attempt (unless suppressed)
      if (!suppressToasts) {
        if (toastDelay != null) {
          Future.delayed(toastDelay, () {
            _showToast('Registering for push notifications...', isError: false);
          });
        } else {
          _showToast('Registering for push notifications...', isError: false);
        }
      }

      // Get or create preferences
      final sitePreferences = preferences ?? await _preferencesService.getPreferences(siteId);

      // Get device info for registration
      final deviceInfo = await _deviceService.getDeviceInfo();

      // Retry logic with exponential backoff
      int attempts = 0;
      bool success = false;
      Exception? lastException;

      while (attempts <= maxRetries && !success) {
        try {
          if (attempts > 0) {
            // Exponential backoff: 1s, 2s, 4s
            final delay = Duration(seconds: 1 << (attempts - 1));
            AppLogger.debug('Retrying registration (attempt ${attempts + 1}/${maxRetries + 1}) after ${delay.inSeconds}s...');
            await Future.delayed(delay);
            if (!suppressToasts) {
              if (toastDelay != null) {
                Future.delayed(toastDelay, () {
                  _showToast('Retrying registration...', isError: false);
                });
              } else {
                _showToast('Retrying registration...', isError: false);
              }
            }
          }

          // Register with backend
          success = await _pushService.registerDeviceForSite(
            deviceId: _deviceId!,
            firebaseToken: _fcmToken!,
            platform: deviceInfo.platform,
            appVersion: deviceInfo.appVersion,
            siteId: siteId,
            siteUserId: userId,
            siteUsername: username,
            preferences: sitePreferences,
          );

          if (success) {
            break;
          }
        } catch (e) {
          lastException = e is Exception ? e : Exception(e.toString());
          AppLogger.debug('Registration attempt ${attempts + 1} failed: $e');
        }

        attempts++;
      }

      if (success) {
        // Update local state
        _siteStates[siteId] = SiteNotificationState(
          siteId: siteId,
          siteUrl: siteUrl,
          siteName: siteName,
          userId: userId,
          username: username,
          isRegistered: true,
          preferences: sitePreferences,
          lastRegistration: DateTime.now(),
          registrationAttempts: attempts,
        );

        // Save to storage
        await _saveSiteStates();

        AppLogger.debug('Successfully registered for site: $siteName (after $attempts attempt(s))');
        if (!suppressToasts) {
          if (toastDelay != null) {
            Future.delayed(toastDelay, () {
              _showToast('Push notifications enabled for $siteName', isError: false);
            });
          } else {
            _showToast('Push notifications enabled for $siteName', isError: false);
          }
        }
        update();
        return true;
      } else {
        // Mark as failed registration
        final errorMsg = lastException?.toString() ?? 'Registration failed - server returned error';
        _siteStates[siteId] = SiteNotificationState(
          siteId: siteId,
          siteUrl: siteUrl,
          siteName: siteName,
          userId: userId,
          username: username,
          isRegistered: false,
          preferences: sitePreferences,
          lastRegistration: DateTime.now(),
          lastError: DateTime.now(),
          errorMessage: errorMsg,
          registrationAttempts: attempts,
        );

        // Save to storage even if failed (so we can retry later)
        await _saveSiteStates();

        _lastError = errorMsg;
        final isNetworkErr = lastException != null && _isNetworkError(lastException);
        _hasNetworkError = isNetworkErr;
        AppLogger.debug('Failed to register for site: $siteName after $attempts attempt(s)');
        if (!suppressToasts) {
          if (toastDelay != null) {
            Future.delayed(toastDelay, () {
              _showToast('Failed to enable push notifications', isError: true);
            });
          } else {
            _showToast('Failed to enable push notifications', isError: true);
          }
        }
        update();
        return false;
      }
    } catch (e) {
      AppLogger.debug('Error registering site $siteId: $e');

      final isNetworkErr = _isNetworkError(e);
      _lastError = e.toString();
      _hasNetworkError = isNetworkErr;

      // Get or create preferences
      final sitePreferences = preferences ?? await _preferencesService.getPreferences(siteId);

      // Mark as error
      _siteStates[siteId] = SiteNotificationState(
        siteId: siteId,
        siteUrl: siteUrl,
        siteName: siteName,
        userId: userId,
        username: username,
        isRegistered: false,
        preferences: sitePreferences,
        lastRegistration: DateTime.now(),
        lastError: DateTime.now(),
        errorMessage: e.toString(),
        registrationAttempts: 1,
      );

      // Save to storage even if failed
      await _saveSiteStates();

      if (!suppressToasts) {
        if (toastDelay != null) {
          Future.delayed(toastDelay, () {
            _showToast('Failed to register for push notifications', isError: true);
          });
        } else {
          _showToast('Failed to register for push notifications', isError: true);
        }
      }
      update();
      return false;
    }
  }

  /// Unregister device from a specific site
  Future<bool> unregisterSite(String siteId) async {
    try {
      final state = _siteStates[siteId];
      if (state == null) {
        AppLogger.debug('Site $siteId not found in states');
        return false;
      }

      AppLogger.debug('Unregistering device from site: ${state.siteName} ($siteId)');
      
      // Show toast for unregistration attempt
      _showToast('Unregistering from push notifications...', isError: false);

      final success = await _pushService.unregisterDeviceFromSite(
        deviceId: _deviceId!,
        siteId: siteId,
        siteUserId: state.userId,
      );

      if (success) {
        // Remove from local state
        _siteStates.remove(siteId);
        
        // Save to storage
        await _saveSiteStates();

        AppLogger.debug('Successfully unregistered from site: ${state.siteName}');
        _showToast('Push notifications disabled for ${state.siteName}', isError: false);
        update();
        return true;
      } else {
        AppLogger.debug('Failed to unregister from site: ${state.siteName}');
        _showToast('Failed to disable push notifications', isError: true);
        return false;
      }
    } catch (e) {
      AppLogger.debug('Error unregistering site $siteId: $e');
      _showToast('Error disabling push notifications', isError: true);
      return false;
    }
  }

  /// Update preferences for a site
  Future<void> updatePreferences(String siteId, NotificationPreferences preferences) async {
    try {
      // Save preferences
      await _preferencesService.savePreferences(siteId, preferences);

      // Update local state
      if (_siteStates.containsKey(siteId)) {
        _siteStates[siteId] = _siteStates[siteId]!.updatePreferences(preferences);
        
        // Save to storage
        await _saveSiteStates();
        
        // If site is registered, update backend
        if (_siteStates[siteId]!.isRegistered && _deviceId != null && _fcmToken != null) {
          try {
            _showToast('Updating notification preferences...', isError: false);
            final deviceInfo = await _deviceService.getDeviceInfo();
            final success = await _pushService.registerDeviceForSite(
              deviceId: _deviceId!,
              firebaseToken: _fcmToken!,
              platform: deviceInfo.platform,
              appVersion: deviceInfo.appVersion,
              siteId: siteId,
              siteUserId: _siteStates[siteId]!.userId,
              siteUsername: _siteStates[siteId]!.username,
              preferences: preferences,
            );
            if (success) {
              AppLogger.debug('Updated preferences on backend for site $siteId');
              _showToast('Notification preferences updated', isError: false);
            } else {
              _showToast('Failed to update preferences on server', isError: true);
            }
          } catch (e) {
            AppLogger.debug('Error updating preferences on backend: $e');
            _showToast('Error updating preferences', isError: true);
            // Don't fail - preferences are saved locally
          }
        }
        
        update();
      }

      AppLogger.debug('Updated preferences for site $siteId');
    } catch (e) {
      AppLogger.debug('Error updating preferences for site $siteId: $e');
      _showToast('Error updating preferences', isError: true);
    }
  }

  /// Update Firebase token for a specific site
  Future<bool> _updateTokenForSite(String siteId) async {
    try {
      if (_fcmToken == null) return false;

      final success = await _pushService.updateDeviceToken(
        deviceId: _deviceId!,
        newFirebaseToken: _fcmToken!,
      );

      if (success) {
        AppLogger.debug('Updated token for site $siteId');
        return true;
      } else {
        AppLogger.debug('Failed to update token for site $siteId');
        return false;
      }
    } catch (e) {
      AppLogger.debug('Error updating token for site $siteId: $e');
      return false;
    }
  }

  /// Get badge count for device
  Future<int> getBadgeCount() async {
    try {
      if (_deviceId == null) return 0;
      return await _pushService.getBadgeCount(_deviceId!);
    } catch (e) {
      AppLogger.debug('Error getting badge count: $e');
      return 0;
    }
  }

  /// Reset badge count
  Future<bool> resetBadgeCount({String? siteId}) async {
    try {
      if (_deviceId == null) return false;
      return await _pushService.resetBadgeCount(
        deviceId: _deviceId!,
        siteId: siteId,
      );
    } catch (e) {
      AppLogger.debug('Error resetting badge count: $e');
      return false;
    }
  }

  /// Check service health
  Future<bool> checkServiceHealth() async {
    try {
      return await _pushService.checkHealth();
    } catch (e) {
      AppLogger.debug('Error checking service health: $e');
      return false;
    }
  }

  /// Get site state by ID
  SiteNotificationState? getSiteState(String siteId) {
    return _siteStates[siteId];
  }

  /// Check if site is registered
  bool isSiteRegistered(String siteId) {
    return _siteStates[siteId]?.isRegistered ?? false;
  }

  /// Get all site IDs
  List<String> getAllSiteIds() {
    return _siteStates.keys.toList();
  }

  /// Retry failed registrations
  Future<void> retryFailedRegistrations() async {
    try {
      final failedSites = _siteStates.values.where((state) => !state.isRegistered && state.shouldRetryRegistration).toList();

      AppLogger.debug('Retrying ${failedSites.length} failed registrations...');

      for (final state in failedSites) {
        AppLogger.debug('Retrying registration for site: ${state.siteName}');
        await registerSite(
          siteId: state.siteId,
          siteUrl: state.siteUrl,
          siteName: state.siteName,
          userId: state.userId,
          username: state.username,
          preferences: state.preferences,
        );
      }
    } catch (e) {
      AppLogger.debug('Error retrying failed registrations: $e');
    }
  }

  /// Clear all registrations (for logout or reset)
  Future<void> clearAllRegistrations() async {
    try {
      final siteIds = List<String>.from(_siteStates.keys);

      for (final siteId in siteIds) {
        await unregisterSite(siteId);
      }

      _siteStates.clear();
      
      // Clear storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      
      update();
      AppLogger.debug('Cleared all site registrations');
    } catch (e) {
      AppLogger.debug('Error clearing all registrations: $e');
    }
  }

  /// Check if error is network-related
  bool _isNetworkError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('network') || 
           errorString.contains('connection') || 
           errorString.contains('timeout') || 
           errorString.contains('socket') || 
           errorString.contains('unreachable');
  }

  /// Clear last error
  void clearError() {
    _lastError = null;
    _hasNetworkError = false;
    update();
  }

  /// Get summary for logging
  String getSummary() {
    return 'PushNotificationController(initialized: $_isInitialized, deviceId: ${_deviceId?.substring(0, 8)}..., sites: ${_siteStates.length}, registered: $totalRegisteredSites)';
  }

  /// Show toast notification (disabled - toasts were too noisy during login/logout)
  void _showToast(String message, {bool isError = false}) {
    // Toasts disabled - push notification status is logged instead
    AppLogger.debug('Push notification: $message${isError ? ' (error)' : ''}');
  }

  @override
  void onClose() {
    // Save states before closing
    _saveSiteStates();

    // Stop watching login state
    _loginWatcher?.dispose();
    _loginWatcher = null;

    // Clear token refresh callback from NotificationService
    _notificationService.clearTokenRefreshCallback();

    // Clear state
    _siteStates.clear();
    _deviceId = null;
    _fcmToken = null;
    _isInitialized = false;
    _lastError = null;
    _hasNetworkError = false;

    super.onClose();
  }
}
