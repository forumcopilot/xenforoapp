import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/services/notification_router.dart';

/// Pushes and the Alerts tab open notifications through one mapping.
void main() {
  test('a post opens the post in its thread', () {
    final d = NotificationRouter.forPush({'content_type': 'post', 'content_id': '4135.0', 'topic_id': 42, 'site_id': 1});
    expect(d, isA<PostDestination>());
    expect((d as PostDestination).postId, '4135');
    expect(d.topicId, '42');
  });

  test('a thread alert opens the thread (it used to be "Unsupported")', () {
    final d = NotificationRouter.forPush({'content_type': 'thread', 'content_id': '7', 'topic_id': '7'});
    expect(d, isA<TopicDestination>());
    expect((d as TopicDestination).topicId, '7');
  });

  test('a direct message opens its conversation at the message', () {
    final d = NotificationRouter.forPush({'content_type': 'conversation_message', 'content_id': '99', 'conversation_id': '12'});
    expect(d, isA<ConversationDestination>());
    expect((d as ConversationDestination).conversationId, '12');
    expect(d.messageId, '99');
  });

  test('a follow opens the follower\'s profile', () {
    final d = NotificationRouter.forPush({'content_type': 'user', 'sender_id': '63'});
    expect(d, isA<ProfileDestination>());
    expect((d as ProfileDestination).userId, '63');
  });

  test('other types open their link, or the Alerts tab without one', () {
    expect(NotificationRouter.forPush({'content_type': 'profile_post', 'url': 'https://forum.test/profile-posts/3/'}), isA<LinkDestination>());
    expect(NotificationRouter.forPush({'content_type': 'report'}), isA<AlertsDestination>());
    expect(NotificationRouter.forPush({}), isA<AlertsDestination>());
  });

  test('missing ids fall back instead of failing', () {
    expect(NotificationRouter.forPush({'content_type': 'post'}), isA<AlertsDestination>());
    expect(NotificationRouter.forPush({'content_type': 'conversation_message', 'content_id': '9', 'url': 'https://x.test/c'}), isA<LinkDestination>());
  });

  test('the Alerts tab maps the same way', () {
    final d = NotificationRouter.destinationFor(contentType: 'user', username: 'JessicaTaylor110');
    expect(d, isA<ProfileDestination>());
    expect((d as ProfileDestination).username, 'JessicaTaylor110');
  });
}
