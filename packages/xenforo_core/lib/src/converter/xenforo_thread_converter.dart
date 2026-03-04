import 'package:forumcopilot_sdk/models/entities/fc_topic.dart';
import '../data/thread/thread.dart';

/// Converter for XenForo thread data to FCTopic
class XenForoThreadConverter {
  /// Convert XenForo thread to FCTopic
  static FCTopic toFCTopic(XenForoThread xenForoThread) {
    return FCTopic(
      id: xenForoThread.id,
      title: xenForoThread.title ?? '',
      forumId: xenForoThread.forumId,
      forumName: xenForoThread.forumName,
      prefix: xenForoThread.prefixString,
      authorId: xenForoThread.authorId,
      authorName: xenForoThread.authorName,
      authorUserType: xenForoThread.authorUserType,
      authorIconUrl: xenForoThread.authorAvatarUrl,
      timestamp: xenForoThread.creationDate,
      replyCount: xenForoThread.replyCount ?? 0,
      viewCount: xenForoThread.viewCount ?? 0,
      hasNewPosts: !xenForoThread.isRead,
      isClosed: xenForoThread.isLocked,
      isSubscribed: xenForoThread.isSubscribed,
      canSubscribe: false, // Not available in API
      url: xenForoThread.url,
      shortContent: '', // Not available in API
      participatedUserIds: const [], // Not available in API
      isPinned: xenForoThread.isSticky,
      isAnnouncement: false, // Not available in API
      isStickySource: xenForoThread.isSticky,
      canRename: false, // Not available in API
      canDelete: xenForoThread.canDelete,
      canClose: false, // Not available in API
      canApprove: false, // Not available in API
      canStick: false, // Not available in API
      canMove: false, // Not available in API
      canMerge: false, // Not available in API
      canBan: false, // Not available in API
      canReply: xenForoThread.canReply ?? false,
      canReport: false, // Not available in API
      canUpload: false, // Not available in API
      isBanned: false, // Not available in API
      isApproved: true, // Assume approved if accessible
      isDeleted: false, // Not available in API
      isMoved: false, // Not available in API
      isMerged: false, // Not available in API
      realTopicId: xenForoThread.id,
      canLike: false, // Not available in API
      isLiked: false, // Not available in API
      likeCount: 0, // Not available in API
      canThank: false, // Not available in API
    );
  }

  /// Convert list of XenForo threads to list of FCTopics
  static List<FCTopic> toFCTopicList(List<XenForoThread> xenForoThreads) {
    return xenForoThreads.map((thread) => toFCTopic(thread)).toList();
  }

  /// Convert Map data to FCTopic (for plugin API responses)
  static FCTopic toFCTopicFromMap(Map<String, dynamic> topicData) {
    return FCTopic(
      id: topicData['id']?.toString() ?? topicData['topic_id']?.toString() ?? '',
      title: topicData['title']?.toString() ?? topicData['topic_title']?.toString() ?? '',
      forumId: topicData['forumId']?.toString() ?? topicData['forum_id']?.toString() ?? '',
      forumName: topicData['forumName']?.toString() ?? topicData['forum_name']?.toString() ?? '',
      prefix: topicData['prefix']?.toString() ?? topicData['prefix_string']?.toString() ?? '',
      authorId: topicData['authorId']?.toString() ?? topicData['author_id']?.toString() ?? '',
      authorName: topicData['authorName']?.toString() ?? topicData['author_name']?.toString() ?? '',
      authorUserType: topicData['authorUserType']?.toString() ?? topicData['author_user_type']?.toString() ?? '',
      authorIconUrl: topicData['authorIconUrl']?.toString() ?? topicData['author_icon_url']?.toString() ?? '',
      timestamp: _parseTimestamp(topicData['timestamp'] ?? topicData['creation_date'] ?? topicData['post_date']),
      replyCount: _parseInt(topicData['replyCount'] ?? topicData['reply_count'] ?? topicData['replies']),
      viewCount: _parseInt(topicData['viewCount'] ?? topicData['view_count'] ?? topicData['views']),
      hasNewPosts: topicData['hasNewPosts'] ?? topicData['has_new_posts'] ?? topicData['is_unread'] ?? false,
      isClosed: topicData['isClosed'] ?? topicData['is_closed'] ?? topicData['is_locked'] ?? false,
      isSubscribed: topicData['isSubscribed'] ?? topicData['is_subscribed'] ?? false,
      canSubscribe: topicData['canSubscribe'] ?? topicData['can_subscribe'] ?? false,
      url: topicData['url']?.toString() ?? topicData['topic_url']?.toString() ?? '',
      shortContent: topicData['shortContent']?.toString() ?? topicData['short_content']?.toString() ?? '',
      participatedUserIds: const [], // Not available in plugin API
      isPinned: topicData['isPinned'] ?? topicData['is_pinned'] ?? topicData['is_sticky'] ?? false,
      isAnnouncement: topicData['isAnnouncement'] ?? topicData['is_announcement'] ?? false,
      isStickySource: topicData['isStickySource'] ?? topicData['is_sticky_source'] ?? topicData['is_sticky'] ?? false,
      likeCount: _parseInt(topicData['likeCount'] ?? topicData['like_count']),
      canThank: topicData['canThank'] ?? topicData['can_thank'] ?? false,
    );
  }

  /// Parse timestamp from various formats
  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    }
    if (timestamp is String) {
      return DateTime.tryParse(timestamp) ?? DateTime.now();
    }
    return DateTime.now();
  }

  /// Parse integer from various formats
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
