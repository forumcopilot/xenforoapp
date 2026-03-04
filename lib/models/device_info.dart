import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

/// Device information model for push notifications
class DeviceInfo {
  final String deviceId;
  final String platform;
  final String appVersion;
  final String? deviceModel;
  final String? osVersion;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  const DeviceInfo({
    required this.deviceId,
    required this.platform,
    required this.appVersion,
    this.deviceModel,
    this.osVersion,
    required this.createdAt,
    this.lastUpdated,
  });

  /// Create DeviceInfo from current device
  static Future<DeviceInfo> create() async {
    final deviceInfo = DeviceInfoPlugin();

    String platform;
    String? deviceModel;
    String? osVersion;

    if (Platform.isAndroid) {
      platform = 'android';
      final androidInfo = await deviceInfo.androidInfo;
      deviceModel = '${androidInfo.brand} ${androidInfo.model}';
      osVersion = 'Android ${androidInfo.version.release}';
    } else if (Platform.isIOS) {
      platform = 'ios';
      final iosInfo = await deviceInfo.iosInfo;
      deviceModel = iosInfo.model;
      osVersion = 'iOS ${iosInfo.systemVersion}';
    } else if (Platform.isMacOS) {
      platform = 'macos';
      try {
        final macInfo = await deviceInfo.macOsInfo;
        deviceModel = macInfo.model;
        osVersion = 'macOS ${macInfo.osRelease}';
      } catch (e) {
        // Fallback if device_info_plus doesn't support macOS or fails
        deviceModel = 'Mac';
        osVersion = 'macOS';
      }
    } else {
      platform = 'unknown';
    }

    return DeviceInfo(
      deviceId: '', // Will be set by DeviceService
      platform: platform,
      appVersion: '0.1.1', // Fallback version
      deviceModel: deviceModel,
      osVersion: osVersion,
      createdAt: DateTime.now(),
    );
  }

  /// Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'platform': platform,
      'app_version': appVersion,
      'device_model': deviceModel,
      'os_version': osVersion,
      'created_at': createdAt.toIso8601String(),
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      deviceId: json['device_id'] as String,
      platform: json['platform'] as String,
      appVersion: json['app_version'] as String,
      deviceModel: json['device_model'] as String?,
      osVersion: json['os_version'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastUpdated: json['last_updated'] != null ? DateTime.parse(json['last_updated'] as String) : null,
    );
  }

  /// Create a copy with updated fields
  DeviceInfo copyWith({
    String? deviceId,
    String? platform,
    String? appVersion,
    String? deviceModel,
    String? osVersion,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return DeviceInfo(
      deviceId: deviceId ?? this.deviceId,
      platform: platform ?? this.platform,
      appVersion: appVersion ?? this.appVersion,
      deviceModel: deviceModel ?? this.deviceModel,
      osVersion: osVersion ?? this.osVersion,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Update last updated timestamp
  DeviceInfo updateTimestamp() {
    return copyWith(lastUpdated: DateTime.now());
  }

  /// Validate device info
  bool get isValid {
    return deviceId.isNotEmpty && platform.isNotEmpty && appVersion.isNotEmpty;
  }

  @override
  String toString() {
    return 'DeviceInfo(deviceId: $deviceId, platform: $platform, appVersion: $appVersion, deviceModel: $deviceModel, osVersion: $osVersion, createdAt: $createdAt, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeviceInfo &&
        other.deviceId == deviceId &&
        other.platform == platform &&
        other.appVersion == appVersion &&
        other.deviceModel == deviceModel &&
        other.osVersion == osVersion &&
        other.createdAt == createdAt &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return deviceId.hashCode ^ platform.hashCode ^ appVersion.hashCode ^ deviceModel.hashCode ^ osVersion.hashCode ^ createdAt.hashCode ^ lastUpdated.hashCode;
  }
}
