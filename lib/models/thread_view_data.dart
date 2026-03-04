import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import 'package:forumcopilot_sdk/models/entities/fc_topic.dart';
import 'package:forumcopilot_sdk/models/results/fc_post_result.dart';

class ThreadViewData {
  final FCTopic topic; // Can be FCThreadResult, FCThreadByUnreadResult, FCThreadByPostResult, or FCAnnouncementResult
  final List<FCPost> posts;
  final int currentStartNum; // 0-based index of the first loaded post
  final int position; // 1-based anchor post (e.g. first unread, or last loaded post)

  ThreadViewData({
    required this.topic,
    required this.posts,
    required this.currentStartNum,
    required this.position,
  });

  /// Returns the total number of posts in the thread.
  /// 
  /// For result types (FCThreadResult, FCThreadByUnreadResult, FCThreadByPostResult, FCAnnouncementResult),
  /// uses totalPostNum which already includes the first post.
  /// For plain FCTopic (e.g., XenForo), replyCount commonly includes only
  /// replies, so we add 1 for the first post.
  int get totalPosts {
    // Try to get totalPostNum from result types that extend FCTopic
    if (topic is FCThreadResult) {
      return (topic as FCThreadResult).totalPostNum;
    } else if (topic is FCThreadByUnreadResult) {
      return (topic as FCThreadByUnreadResult).totalPostNum;
    } else if (topic is FCThreadByPostResult) {
      return (topic as FCThreadByPostResult).totalPostNum;
    } else if (topic is FCAnnouncementResult) {
      return (topic as FCAnnouncementResult).totalPostNum;
    }
    
    // Fallback: For plain FCTopic, replyCount may only include replies.
    // We add 1 to include the first post.
    // Since we can't reliably detect which platform, we add 1 as a safe fallback.
    // This may overcount for some forum implementations, but since post APIs
    // usually return the result types above,
    // this fallback should rarely be used.
    return topic.replyCount + 1;
  }
  int get loadedCount => posts.length;

  /// Returns the range of loaded posts (inclusive-exclusive)
  int get loadedStart => currentStartNum;
  int get loadedEnd => currentStartNum + loadedCount;

  /// Returns the range for loading earlier posts
  Map<String, int> earlierRange(int pageSize) => {
        'startNum': (currentStartNum - pageSize).clamp(0, totalPosts - 1),
        'lastNum': (currentStartNum - 1).clamp(0, totalPosts - 1),
      };

  /// Returns the range for loading later posts
  Map<String, int> laterRange(int pageSize) => {
        'startNum': loadedEnd,
        'lastNum': (loadedEnd + pageSize - 1).clamp(0, totalPosts - 1),
      };
}
