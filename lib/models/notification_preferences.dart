/// Notification preferences model for forum-specific settings
class NotificationPreferences {
  final bool isEnabled;
  final bool newPosts;
  final bool replies;
  final bool mentions;
  final bool quotes;
  final bool likes;
  final bool subscriptions;
  final bool privateMessages;
  final bool systemNotifications;
  final DateTime? lastUpdated;

  const NotificationPreferences({
    required this.isEnabled,
    required this.newPosts,
    required this.replies,
    required this.mentions,
    required this.quotes,
    required this.likes,
    required this.subscriptions,
    required this.privateMessages,
    required this.systemNotifications,
    this.lastUpdated,
  });

  /// Default preferences for new forums
  static const NotificationPreferences defaultPreferences = NotificationPreferences(
    isEnabled: true,
    newPosts: true,
    replies: true,
    mentions: true,
    quotes: true,
    likes: false,
    subscriptions: true,
    privateMessages: true,
    systemNotifications: true,
  );

  /// Disabled preferences (all notifications off)
  static const NotificationPreferences disabled = NotificationPreferences(
    isEnabled: false,
    newPosts: false,
    replies: false,
    mentions: false,
    quotes: false,
    likes: false,
    subscriptions: false,
    privateMessages: false,
    systemNotifications: false,
  );

  /// Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'is_enabled': isEnabled,
      'new_posts': newPosts,
      'replies': replies,
      'mentions': mentions,
      'quotes': quotes,
      'likes': likes,
      'subscriptions': subscriptions,
      'private_messages': privateMessages,
      'system_notifications': systemNotifications,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      isEnabled: json['is_enabled'] as bool? ?? true,
      newPosts: json['new_posts'] as bool? ?? true,
      replies: json['replies'] as bool? ?? true,
      mentions: json['mentions'] as bool? ?? true,
      quotes: json['quotes'] as bool? ?? true,
      likes: json['likes'] as bool? ?? false,
      subscriptions: json['subscriptions'] as bool? ?? true,
      privateMessages: json['private_messages'] as bool? ?? true,
      systemNotifications: json['system_notifications'] as bool? ?? true,
      lastUpdated: json['last_updated'] != null ? DateTime.parse(json['last_updated'] as String) : null,
    );
  }

  /// Create a copy with updated fields
  NotificationPreferences copyWith({
    bool? isEnabled,
    bool? newPosts,
    bool? replies,
    bool? mentions,
    bool? quotes,
    bool? likes,
    bool? subscriptions,
    bool? privateMessages,
    bool? systemNotifications,
    DateTime? lastUpdated,
  }) {
    return NotificationPreferences(
      isEnabled: isEnabled ?? this.isEnabled,
      newPosts: newPosts ?? this.newPosts,
      replies: replies ?? this.replies,
      mentions: mentions ?? this.mentions,
      quotes: quotes ?? this.quotes,
      likes: likes ?? this.likes,
      subscriptions: subscriptions ?? this.subscriptions,
      privateMessages: privateMessages ?? this.privateMessages,
      systemNotifications: systemNotifications ?? this.systemNotifications,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Update with current timestamp
  NotificationPreferences updateTimestamp() {
    return copyWith(lastUpdated: DateTime.now());
  }

  /// Enable all notifications
  NotificationPreferences enableAll() {
    return copyWith(
      isEnabled: true,
      newPosts: true,
      replies: true,
      mentions: true,
      quotes: true,
      likes: true,
      subscriptions: true,
      privateMessages: true,
      systemNotifications: true,
      lastUpdated: DateTime.now(),
    );
  }

  /// Disable all notifications
  NotificationPreferences disableAll() {
    return copyWith(
      isEnabled: false,
      newPosts: false,
      replies: false,
      mentions: false,
      quotes: false,
      likes: false,
      subscriptions: false,
      privateMessages: false,
      systemNotifications: false,
      lastUpdated: DateTime.now(),
    );
  }

  /// Toggle global enable/disable
  NotificationPreferences toggleGlobal() {
    return copyWith(
      isEnabled: !isEnabled,
      lastUpdated: DateTime.now(),
    );
  }

  /// Get list of enabled notification types
  List<String> get enabledTypes {
    if (!isEnabled) return [];

    final types = <String>[];
    if (newPosts) types.add('new_posts');
    if (replies) types.add('replies');
    if (mentions) types.add('mentions');
    if (quotes) types.add('quotes');
    if (likes) types.add('likes');
    if (subscriptions) types.add('subscriptions');
    if (privateMessages) types.add('private_messages');
    if (systemNotifications) types.add('system_notifications');

    return types;
  }

  /// Check if any notifications are enabled
  bool get hasAnyEnabled {
    return isEnabled && (newPosts || replies || mentions || quotes || likes || subscriptions || privateMessages || systemNotifications);
  }

  /// Get count of enabled notification types
  int get enabledCount {
    if (!isEnabled) return 0;

    int count = 0;
    if (newPosts) count++;
    if (replies) count++;
    if (mentions) count++;
    if (quotes) count++;
    if (likes) count++;
    if (subscriptions) count++;
    if (privateMessages) count++;
    if (systemNotifications) count++;

    return count;
  }

  @override
  String toString() {
    return 'NotificationPreferences(isEnabled: $isEnabled, newPosts: $newPosts, replies: $replies, mentions: $mentions, quotes: $quotes, likes: $likes, subscriptions: $subscriptions, privateMessages: $privateMessages, systemNotifications: $systemNotifications, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationPreferences &&
        other.isEnabled == isEnabled &&
        other.newPosts == newPosts &&
        other.replies == replies &&
        other.mentions == mentions &&
        other.quotes == quotes &&
        other.likes == likes &&
        other.subscriptions == subscriptions &&
        other.privateMessages == privateMessages &&
        other.systemNotifications == systemNotifications &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return isEnabled.hashCode ^
        newPosts.hashCode ^
        replies.hashCode ^
        mentions.hashCode ^
        quotes.hashCode ^
        likes.hashCode ^
        subscriptions.hashCode ^
        privateMessages.hashCode ^
        systemNotifications.hashCode ^
        lastUpdated.hashCode;
  }
}
