import 'notification_preferences.dart';

/// State model for site notification registration and status
class SiteNotificationState {
  final String siteId;
  final String siteUrl;
  final String siteName;
  final String userId;
  final String username;
  final bool isRegistered;
  final NotificationPreferences preferences;
  final DateTime lastRegistration;
  final DateTime? lastNotification;
  final DateTime? lastError;
  final String? errorMessage;
  final int registrationAttempts;
  final bool isOnline;

  const SiteNotificationState({
    required this.siteId,
    required this.siteUrl,
    required this.siteName,
    required this.userId,
    required this.username,
    required this.isRegistered,
    required this.preferences,
    required this.lastRegistration,
    this.lastNotification,
    this.lastError,
    this.errorMessage,
    this.registrationAttempts = 0,
    this.isOnline = true,
  });

  /// Create initial state for a new site
  factory SiteNotificationState.initial({
    required String siteId,
    required String siteUrl,
    required String siteName,
    required String userId,
    required String username,
    NotificationPreferences? preferences,
  }) {
    return SiteNotificationState(
      siteId: siteId,
      siteUrl: siteUrl,
      siteName: siteName,
      userId: userId,
      username: username,
      isRegistered: false,
      preferences: preferences ?? NotificationPreferences.defaultPreferences,
      lastRegistration: DateTime.now(),
      registrationAttempts: 0,
      isOnline: true,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'site_id': siteId,
      'site_url': siteUrl,
      'site_name': siteName,
      'user_id': userId,
      'username': username,
      'is_registered': isRegistered,
      'preferences': preferences.toJson(),
      'last_registration': lastRegistration.toIso8601String(),
      'last_notification': lastNotification?.toIso8601String(),
      'last_error': lastError?.toIso8601String(),
      'error_message': errorMessage,
      'registration_attempts': registrationAttempts,
      'is_online': isOnline,
    };
  }

  /// Create from JSON
  factory SiteNotificationState.fromJson(Map<String, dynamic> json) {
    return SiteNotificationState(
      siteId: json['site_id'] as String,
      siteUrl: json['site_url'] as String,
      siteName: json['site_name'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String,
      isRegistered: json['is_registered'] as bool,
      preferences: NotificationPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      lastRegistration: DateTime.parse(json['last_registration'] as String),
      lastNotification: json['last_notification'] != null ? DateTime.parse(json['last_notification'] as String) : null,
      lastError: json['last_error'] != null ? DateTime.parse(json['last_error'] as String) : null,
      errorMessage: json['error_message'] as String?,
      registrationAttempts: json['registration_attempts'] as int? ?? 0,
      isOnline: json['is_online'] as bool? ?? true,
    );
  }

  /// Create a copy with updated fields
  SiteNotificationState copyWith({
    String? siteId,
    String? siteUrl,
    String? siteName,
    String? userId,
    String? username,
    bool? isRegistered,
    NotificationPreferences? preferences,
    DateTime? lastRegistration,
    DateTime? lastNotification,
    DateTime? lastError,
    String? errorMessage,
    int? registrationAttempts,
    bool? isOnline,
  }) {
    return SiteNotificationState(
      siteId: siteId ?? this.siteId,
      siteUrl: siteUrl ?? this.siteUrl,
      siteName: siteName ?? this.siteName,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      isRegistered: isRegistered ?? this.isRegistered,
      preferences: preferences ?? this.preferences,
      lastRegistration: lastRegistration ?? this.lastRegistration,
      lastNotification: lastNotification ?? this.lastNotification,
      lastError: lastError ?? this.lastError,
      errorMessage: errorMessage ?? this.errorMessage,
      registrationAttempts: registrationAttempts ?? this.registrationAttempts,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  /// Mark as successfully registered
  SiteNotificationState markAsRegistered() {
    return copyWith(
      isRegistered: true,
      lastRegistration: DateTime.now(),
      registrationAttempts: 0,
      errorMessage: null,
      lastError: null,
    );
  }

  /// Mark as unregistered
  SiteNotificationState markAsUnregistered() {
    return copyWith(
      isRegistered: false,
      lastRegistration: DateTime.now(),
    );
  }

  /// Mark registration error
  SiteNotificationState markRegistrationError(String error) {
    return copyWith(
      isRegistered: false,
      lastError: DateTime.now(),
      errorMessage: error,
      registrationAttempts: registrationAttempts + 1,
    );
  }

  /// Update preferences
  SiteNotificationState updatePreferences(NotificationPreferences newPreferences) {
    return copyWith(
      preferences: newPreferences.updateTimestamp(),
    );
  }

  /// Mark notification received
  SiteNotificationState markNotificationReceived() {
    return copyWith(
      lastNotification: DateTime.now(),
    );
  }

  /// Update user info
  SiteNotificationState updateUserInfo(String newUserId, String newUsername) {
    return copyWith(
      userId: newUserId,
      username: newUsername,
      lastRegistration: DateTime.now(),
    );
  }

  /// Set online/offline status
  SiteNotificationState setOnlineStatus(bool online) {
    return copyWith(
      isOnline: online,
    );
  }

  /// Check if registration should be retried
  bool get shouldRetryRegistration {
    if (isRegistered) return false;
    if (registrationAttempts >= 3) return false;

    // Retry if last error was more than 5 minutes ago
    if (lastError != null) {
      final timeSinceError = DateTime.now().difference(lastError!);
      return timeSinceError.inMinutes >= 5;
    }

    return true;
  }

  /// Get time since last notification
  Duration? get timeSinceLastNotification {
    if (lastNotification == null) return null;
    return DateTime.now().difference(lastNotification!);
  }

  /// Get time since last registration
  Duration get timeSinceLastRegistration {
    return DateTime.now().difference(lastRegistration);
  }

  /// Check if state is valid
  bool get isValid {
    return siteId.isNotEmpty && siteUrl.isNotEmpty && siteName.isNotEmpty && userId.isNotEmpty && username.isNotEmpty;
  }

  /// Get display name for the site
  String get displayName {
    return siteName.isNotEmpty ? siteName : siteUrl;
  }

  /// Get status description
  String get statusDescription {
    if (!isOnline) return 'Offline';
    if (isRegistered) return 'Registered';
    if (errorMessage != null) return 'Error: $errorMessage';
    return 'Not registered';
  }

  @override
  String toString() {
    return 'SiteNotificationState(siteId: $siteId, siteName: $siteName, username: $username, isRegistered: $isRegistered, registrationAttempts: $registrationAttempts, isOnline: $isOnline)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SiteNotificationState &&
        other.siteId == siteId &&
        other.siteUrl == siteUrl &&
        other.siteName == siteName &&
        other.userId == userId &&
        other.username == username &&
        other.isRegistered == isRegistered &&
        other.preferences == preferences &&
        other.lastRegistration == lastRegistration &&
        other.lastNotification == lastNotification &&
        other.lastError == lastError &&
        other.errorMessage == errorMessage &&
        other.registrationAttempts == registrationAttempts &&
        other.isOnline == isOnline;
  }

  @override
  int get hashCode {
    return siteId.hashCode ^
        siteUrl.hashCode ^
        siteName.hashCode ^
        userId.hashCode ^
        username.hashCode ^
        isRegistered.hashCode ^
        preferences.hashCode ^
        lastRegistration.hashCode ^
        lastNotification.hashCode ^
        lastError.hashCode ^
        errorMessage.hashCode ^
        registrationAttempts.hashCode ^
        isOnline.hashCode;
  }
}
