import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/device_info.dart';
import 'package:forumcopilot_flutter/core/errors/error_handling_mixins.dart';
import 'package:forumcopilot_flutter/core/errors/app_exceptions.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'package:forumcopilot_flutter/core/memory/memory_manager.dart';

/// Service for managing device identification and information
class DeviceService with ServiceErrorHandlingMixin {
  static const String _deviceIdKey = 'forumcopilot_device_id';
  static const String _deviceInfoKey = 'forumcopilot_device_info';

  static final DeviceService _instance = DeviceService._internal();
  factory DeviceService() => _instance;
  DeviceService._internal() {
    // Register cleanup with memory manager
    MemoryManager().registerCleanup('DeviceService', () {
      _cachedDeviceId = null;
      _cachedDeviceInfo = null;
    });
  }

  final Uuid _uuid = const Uuid();
  String? _cachedDeviceId;
  DeviceInfo? _cachedDeviceInfo;

  /// Get or create unique device ID
  Future<String> getDeviceId() async {
    if (_cachedDeviceId != null) {
      return _cachedDeviceId!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      String? deviceId = prefs.getString(_deviceIdKey);

      if (deviceId == null || deviceId.isEmpty) {
        // Generate new device ID
        deviceId = _generateDeviceId();
        await prefs.setString(_deviceIdKey, deviceId);
        AppLogger.debug('Generated new device ID: ${deviceId.substring(0, 8)}...');
      } else {
        AppLogger.debug('Retrieved existing device ID: ${deviceId.substring(0, 8)}...');
      }

      _cachedDeviceId = deviceId;
      return deviceId;
    } catch (e) {
      AppLogger.debug('Error getting device ID: $e');
      // Fallback to generated ID
      final fallbackId = _generateDeviceId();
      _cachedDeviceId = fallbackId;
      return fallbackId;
    }
  }

  /// Get complete device information
  Future<DeviceInfo> getDeviceInfo() async {
    if (_cachedDeviceInfo != null) {
      return _cachedDeviceInfo!;
    }

    try {
      final deviceId = await getDeviceId();
      final deviceInfo = await DeviceInfo.create();

      // Set the device ID
      final completeDeviceInfo = deviceInfo.copyWith(deviceId: deviceId);

      // Cache the device info
      _cachedDeviceInfo = completeDeviceInfo;

      // Save to preferences
      await _saveDeviceInfo(completeDeviceInfo);

      return completeDeviceInfo;
    } catch (e) {
      AppLogger.debug('Error getting device info: $e');
      // Return fallback device info
      final deviceId = await getDeviceId();
      return DeviceInfo(
        deviceId: deviceId,
        platform: Platform.isAndroid
            ? 'android'
            : Platform.isIOS
                ? 'ios'
                : Platform.isMacOS
                    ? 'macos'
                    : 'unknown',
        appVersion: '0.1.1', // Fallback version
        createdAt: DateTime.now(),
      );
    }
  }

  /// Load device info from storage
  Future<DeviceInfo?> loadDeviceInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceInfoJson = prefs.getString(_deviceInfoKey);

      if (deviceInfoJson != null) {
        final deviceInfoMap = jsonDecode(deviceInfoJson) as Map<String, dynamic>;
        final deviceInfo = DeviceInfo.fromJson(deviceInfoMap);

        // Verify device ID matches
        final currentDeviceId = await getDeviceId();
        if (deviceInfo.deviceId == currentDeviceId) {
          _cachedDeviceInfo = deviceInfo;
          return deviceInfo;
        } else {
          AppLogger.debug('Device ID mismatch, will regenerate device info');
          return null;
        }
      }

      return null;
    } catch (e) {
      AppLogger.debug('Error loading device info: $e');
      return null;
    }
  }

  /// Save device info to storage
  Future<void> _saveDeviceInfo(DeviceInfo deviceInfo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceInfoJson = jsonEncode(deviceInfo.toJson());
      await prefs.setString(_deviceInfoKey, deviceInfoJson);
    } catch (e) {
      AppLogger.debug('Error saving device info: $e');
    }
  }

  /// Update device info
  Future<void> updateDeviceInfo(DeviceInfo deviceInfo) async {
    try {
      final updatedInfo = deviceInfo.updateTimestamp();
      _cachedDeviceInfo = updatedInfo;
      await _saveDeviceInfo(updatedInfo);
    } catch (e) {
      AppLogger.debug('Error updating device info: $e');
    }
  }

  /// Generate unique device ID
  String _generateDeviceId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _uuid.v4();
    return 'fc_${timestamp}_$random';
  }

  /// Reset device ID (for testing or user request)
  Future<String> resetDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Remove old device ID and info
      await prefs.remove(_deviceIdKey);
      await prefs.remove(_deviceInfoKey);

      // Clear cache
      _cachedDeviceId = null;
      _cachedDeviceInfo = null;

      // Generate new device ID
      final newDeviceId = await getDeviceId();
      AppLogger.debug('Reset device ID: ${newDeviceId.substring(0, 8)}...');

      return newDeviceId;
    } catch (e) {
      AppLogger.debug('Error resetting device ID: $e');
      // Fallback to new ID
      final fallbackId = _generateDeviceId();
      _cachedDeviceId = fallbackId;
      return fallbackId;
    }
  }

  /// Clear all device data
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_deviceIdKey);
      await prefs.remove(_deviceInfoKey);

      _cachedDeviceId = null;
      _cachedDeviceInfo = null;

      AppLogger.debug('Cleared all device data');
    } catch (e) {
      AppLogger.debug('Error clearing device data: $e');
    }
  }

  /// Check if device ID exists
  Future<bool> hasDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceId = prefs.getString(_deviceIdKey);
      return deviceId != null && deviceId.isNotEmpty;
    } catch (e) {
      AppLogger.debug('Error checking device ID: $e');
      return false;
    }
  }

  /// Get device ID without creating one
  Future<String?> getExistingDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_deviceIdKey);
    } catch (e) {
      AppLogger.debug('Error getting existing device ID: $e');
      return null;
    }
  }

  /// Validate device ID format
  bool isValidDeviceId(String deviceId) {
    if (deviceId.isEmpty) return false;
    if (!deviceId.startsWith('fc_')) return false;
    if (deviceId.length < 20) return false;
    return true;
  }

  /// Get device summary for logging
  Future<String> getDeviceSummary() async {
    try {
      final deviceInfo = await getDeviceInfo();
      return 'Device(${deviceInfo.platform}, ${deviceInfo.appVersion}, ${deviceInfo.deviceId.substring(0, 8)}...)';
    } catch (e) {
      return 'Device(unknown, error: $e)';
    }
  }

  /// Dispose resources and cleanup
  void dispose() {
    _cachedDeviceId = null;
    _cachedDeviceInfo = null;
    MemoryManager().unregisterCleanup('DeviceService');
  }
}
