import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations_en.dart';
import 'package:forumcopilot_flutter/services/notification_channels.dart';

/// Pushes are filed under their kind's channel: the add-on's `channel`, or,
/// from an older add-on, the same rules applied to content_type and action.
void main() {
  NotificationKind kind(Map<String, dynamic> data) => NotificationChannels.kindOf(data);

  test("the add-on's channel wins", () {
    expect(kind({'channel': 'reactions', 'content_type': 'conversation_message'}), NotificationKind.reactions);
    expect(kind({'channel': 'messages'}), NotificationKind.messages);
  });

  test('older add-ons: worked out from the alert', () {
    expect(kind({'content_type': 'conversation_message', 'action': 'insert'}), NotificationKind.messages);
    expect(kind({'content_type': 'conversation_message', 'action': 'invite'}), NotificationKind.messages);
    expect(kind({'content_type': 'post', 'action': 'insert'}), NotificationKind.replies);
    expect(kind({'content_type': 'post', 'action': 'quote'}), NotificationKind.replies);
    expect(kind({'content_type': 'profile_post', 'action': 'mention'}), NotificationKind.replies);
    expect(kind({'content_type': 'post', 'action': 'reaction'}), NotificationKind.reactions);
    expect(kind({'content_type': 'user', 'action': 'following'}), NotificationKind.other);
    expect(kind({}), NotificationKind.other);
  });

  test('channel ids: "other" keeps the old channel', () {
    expect(NotificationChannels.idOf(NotificationKind.other), 'forum_copilot_channel');
    expect(NotificationKind.values.map(NotificationChannels.idOf).toSet().length, 4);
  });

  test('four named channels; likes do not head up', () {
    final channels = NotificationChannels.all(AppLocalizationsEn());
    expect(channels.map((c) => c.name), ['Messages', 'Replies and mentions', 'Likes and reactions', 'Other notifications']);
  });

  test('grouped per forum', () {
    expect(NotificationChannels.groupOf({'site_id': '12'}), 'forum_12');
    expect(NotificationChannels.groupOf({}), 'forum_app');
  });
}
