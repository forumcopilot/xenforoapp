import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../l10n/generated/app_localizations.dart';

/// The kinds of notification, each its own Android channel, so members can
/// silence one kind (likes, say) in the phone's settings and keep the rest.
/// The add-on names the kind in a push's `channel` (and, on its direct FCM
/// path, the Android channel itself); for an older add-on the app works it
/// out from `content_type` and `action`, with the add-on's rules.
enum NotificationKind { messages, replies, reactions, other }

class NotificationChannels {
  NotificationChannels._();

  /// The Android channel id. "other" keeps the one channel earlier builds
  /// had, so its settings carry over.
  static String idOf(NotificationKind kind) => switch (kind) {
        NotificationKind.messages => 'fc_messages',
        NotificationKind.replies => 'fc_replies',
        NotificationKind.reactions => 'fc_reactions',
        NotificationKind.other => 'forum_copilot_channel',
      };

  /// The kind of a push from its data.
  static NotificationKind kindOf(Map<String, dynamic> data) {
    switch (data['channel']?.toString()) {
      case 'messages':
        return NotificationKind.messages;
      case 'replies':
        return NotificationKind.replies;
      case 'reactions':
        return NotificationKind.reactions;
      case 'other':
        return NotificationKind.other;
    }
    final type = data['content_type']?.toString() ?? '';
    final action = data['action']?.toString() ?? '';
    if (type == 'conversation_message' || type == 'conversation') return NotificationKind.messages;
    if (action == 'reaction' || action == 'like') return NotificationKind.reactions;
    if (action == 'quote' || action == 'mention') return NotificationKind.replies;
    if (const {'post', 'thread', 'profile_post', 'profile_post_comment'}.contains(type) &&
        const {'insert', 'reply', 'thread_reply', 'tag'}.contains(action)) {
      return NotificationKind.replies;
    }
    return NotificationKind.other;
  }

  static String nameOf(NotificationKind kind, AppLocalizations l10n) => switch (kind) {
        NotificationKind.messages => l10n.notificationChannelMessages,
        NotificationKind.replies => l10n.notificationChannelReplies,
        NotificationKind.reactions => l10n.notificationChannelReactions,
        NotificationKind.other => l10n.notificationChannelOther,
      };

  static String descriptionOf(NotificationKind kind, AppLocalizations l10n) => switch (kind) {
        NotificationKind.messages => l10n.notificationChannelMessagesDescription,
        NotificationKind.replies => l10n.notificationChannelRepliesDescription,
        NotificationKind.reactions => l10n.notificationChannelReactionsDescription,
        NotificationKind.other => l10n.notificationChannelOtherDescription,
      };

  /// All four channels, in the order the phone's settings list them.
  static List<AndroidNotificationChannel> all(AppLocalizations l10n) => [
        for (final kind in NotificationKind.values)
          AndroidNotificationChannel(
            idOf(kind),
            nameOf(kind, l10n),
            description: descriptionOf(kind, l10n),
            // Likes are the quiet kind; the rest heads up.
            importance: kind == NotificationKind.reactions ? Importance.defaultImportance : Importance.high,
          ),
      ];

  /// Notifications of one forum stack together (the forum is the push's
  /// site_id; a single-forum app has one group).
  static String groupOf(Map<String, dynamic> data) {
    final site = data['site_id']?.toString();
    return 'forum_${site == null || site.isEmpty ? 'app' : site}';
  }
}
