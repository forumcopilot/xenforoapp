/// Where a notification opens. One mapping for pushes and the Alerts tab, as
/// in the Discourse app: the push router knew three content types and showed
/// an English "Unsupported notification type" for the rest (thread alerts
/// included), and the Alerts tab had its own, different router.
sealed class NotificationDestination {
  const NotificationDestination();
}

/// A post in its thread.
class PostDestination extends NotificationDestination {
  const PostDestination({required this.postId, this.topicId});
  final String postId;
  final String? topicId;
}

/// A thread, at its first unread post.
class TopicDestination extends NotificationDestination {
  const TopicDestination({required this.topicId});
  final String topicId;
}

/// A conversation, at [messageId] when known.
class ConversationDestination extends NotificationDestination {
  const ConversationDestination({required this.conversationId, this.messageId});
  final String conversationId;
  final String? messageId;
}

/// A member's profile.
class ProfileDestination extends NotificationDestination {
  const ProfileDestination({this.userId, this.username});
  final String? userId;
  final String? username;
}

/// Anything else the forum gave a link for (profile posts, reports, ...).
class LinkDestination extends NotificationDestination {
  const LinkDestination({required this.url});
  final String url;
}

/// Nothing better: the forum's Alerts tab.
class AlertsDestination extends NotificationDestination {
  const AlertsDestination();
}

class NotificationRouter {
  NotificationRouter._();

  /// The destination for a notification about [contentType] / [contentId]
  /// (XenForo's alert content), with the ids the add-on adds where it has
  /// them. Pure: no navigation, no context.
  static NotificationDestination destinationFor({
    required String? contentType,
    String? contentId,
    String? postId,
    String? topicId,
    String? conversationId,
    String? userId,
    String? username,
    String? url,
  }) {
    String? id(String? value) {
      final v = value?.trim();
      if (v == null || v.isEmpty) return null;
      // Push payloads can carry numbers as "4135.0".
      return v.endsWith('.0') ? v.substring(0, v.length - 2) : v;
    }

    final type = contentType?.trim().toLowerCase() ?? '';
    final link = url?.trim();
    NotificationDestination fallback() =>
        (link != null && link.isNotEmpty) ? LinkDestination(url: link) : const AlertsDestination();

    switch (type) {
      case 'post':
        final post = id(postId) ?? id(contentId);
        return post == null ? fallback() : PostDestination(postId: post, topicId: id(topicId));
      case 'thread':
        final topic = id(topicId) ?? id(contentId);
        return topic == null ? fallback() : TopicDestination(topicId: topic);
      case 'conversation_message':
        final conversation = id(conversationId);
        return conversation == null
            ? fallback()
            : ConversationDestination(conversationId: conversation, messageId: id(contentId));
      case 'conversation':
        final conversation = id(conversationId) ?? id(contentId);
        return conversation == null ? fallback() : ConversationDestination(conversationId: conversation);
      case 'user':
        final user = id(userId);
        final name = username?.trim();
        return (user == null && (name == null || name.isEmpty))
            ? fallback()
            : ProfileDestination(userId: user, username: (name == null || name.isEmpty) ? null : name);
      default:
        return fallback();
    }
  }

  /// [destinationFor] for a push payload (the add-on's field names).
  static NotificationDestination forPush(Map<String, dynamic> data) {
    String? s(String key) => data[key]?.toString();
    return destinationFor(
      contentType: s('content_type'),
      contentId: s('content_id'),
      topicId: s('topic_id'),
      conversationId: s('conversation_id'),
      userId: s('sender_id'),
      url: s('url'),
    );
  }
}
