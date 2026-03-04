import 'dart:io';
import 'device_info.dart';
import 'notification_preferences.dart';

/// Data model for push notification registration API calls
class PushRegistrationData {
  final String deviceId;
  final String firebaseToken;
  final String platform;
  final String appVersion;
  final String siteId;
  final String siteUserId;
  final String siteUsername;
  final NotificationPreferences notificationPreferences;
  final DateTime createdAt;

  const PushRegistrationData({
    required this.deviceId,
    required this.firebaseToken,
    required this.platform,
    required this.appVersion,
    required this.siteId,
    required this.siteUserId,
    required this.siteUsername,
    required this.notificationPreferences,
    required this.createdAt,
  });

  /// Create from device info and forum data
  factory PushRegistrationData.create({
    required DeviceInfo deviceInfo,
    required String firebaseToken,
    required String siteId,
    required String siteUserId,
    required String siteUsername,
    required NotificationPreferences preferences,
  }) {
    return PushRegistrationData(
      deviceId: deviceInfo.deviceId,
      firebaseToken: firebaseToken,
      platform: deviceInfo.platform,
      appVersion: deviceInfo.appVersion,
      siteId: siteId,
      siteUserId: siteUserId,
      siteUsername: siteUsername,
      notificationPreferences: preferences,
      createdAt: DateTime.now(),
    );
  }

  /// Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'firebase_token': firebaseToken,
      'platform': platform,
      'app_version': appVersion,
      'site_id': siteId,
      'site_user_id': siteUserId,
      'site_username': siteUsername,
      'notification_preferences': notificationPreferences.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory PushRegistrationData.fromJson(Map<String, dynamic> json) {
    return PushRegistrationData(
      deviceId: json['device_id'] as String,
      firebaseToken: json['firebase_token'] as String,
      platform: json['platform'] as String,
      appVersion: json['app_version'] as String,
      siteId: json['site_id'] as String,
      siteUserId: json['site_user_id'] as String,
      siteUsername: json['site_username'] as String,
      notificationPreferences: NotificationPreferences.fromJson(json['notification_preferences'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Create a copy with updated fields
  PushRegistrationData copyWith({
    String? deviceId,
    String? firebaseToken,
    String? platform,
    String? appVersion,
    String? siteId,
    String? siteUserId,
    String? siteUsername,
    NotificationPreferences? notificationPreferences,
    DateTime? createdAt,
  }) {
    return PushRegistrationData(
      deviceId: deviceId ?? this.deviceId,
      firebaseToken: firebaseToken ?? this.firebaseToken,
      platform: platform ?? this.platform,
      appVersion: appVersion ?? this.appVersion,
      siteId: siteId ?? this.siteId,
      siteUserId: siteUserId ?? this.siteUserId,
      siteUsername: siteUsername ?? this.siteUsername,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Update Firebase token
  PushRegistrationData updateFirebaseToken(String newToken) {
    return copyWith(
      firebaseToken: newToken,
      createdAt: DateTime.now(),
    );
  }

  /// Update preferences
  PushRegistrationData updatePreferences(NotificationPreferences newPreferences) {
    return copyWith(
      notificationPreferences: newPreferences,
      createdAt: DateTime.now(),
    );
  }

  /// Update user info
  PushRegistrationData updateUserInfo(String newUserId, String newUsername) {
    return copyWith(
      siteUserId: newUserId,
      siteUsername: newUsername,
      createdAt: DateTime.now(),
    );
  }

  /// Validate registration data
  bool get isValid {
    return deviceId.isNotEmpty && firebaseToken.isNotEmpty && platform.isNotEmpty && appVersion.isNotEmpty && siteId.isNotEmpty && siteUserId.isNotEmpty && siteUsername.isNotEmpty;
  }

  /// Get platform display name
  String get platformDisplayName {
    switch (platform.toLowerCase()) {
      case 'android':
        return 'Android';
      case 'ios':
        return 'iOS';
      case 'macos':
        return 'macOS';
      default:
        return platform;
    }
  }

  /// Check if data is for current platform
  bool get isCurrentPlatform {
    if (Platform.isAndroid) return platform.toLowerCase() == 'android';
    if (Platform.isIOS) return platform.toLowerCase() == 'ios';
    if (Platform.isMacOS) return platform.toLowerCase() == 'macos';
    return false;
  }

  /// Get age of registration data
  Duration get age {
    return DateTime.now().difference(createdAt);
  }

  /// Check if data is fresh (less than 1 hour old)
  bool get isFresh {
    return age.inHours < 1;
  }

  /// Get summary for logging
  String get summary {
    return 'PushRegistrationData(site: $siteId, user: $siteUsername, platform: $platform, device: ${deviceId.substring(0, 8)}...)';
  }

  @override
  String toString() {
    return 'PushRegistrationData(deviceId: ${deviceId.substring(0, 8)}..., firebaseToken: ${firebaseToken.substring(0, 8)}..., platform: $platform, appVersion: $appVersion, siteId: $siteId, siteUserId: $siteUserId, siteUsername: $siteUsername, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PushRegistrationData &&
        other.deviceId == deviceId &&
        other.firebaseToken == firebaseToken &&
        other.platform == platform &&
        other.appVersion == appVersion &&
        other.siteId == siteId &&
        other.siteUserId == siteUserId &&
        other.siteUsername == siteUsername &&
        other.notificationPreferences == notificationPreferences &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return deviceId.hashCode ^
        firebaseToken.hashCode ^
        platform.hashCode ^
        appVersion.hashCode ^
        siteId.hashCode ^
        siteUserId.hashCode ^
        siteUsername.hashCode ^
        notificationPreferences.hashCode ^
        createdAt.hashCode;
  }
}
