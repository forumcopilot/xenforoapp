import 'package:dart_mappable/dart_mappable.dart';

part 'fc_directory_item.mapper.dart';

/// One row from the user directory (Discourse: `/directory_items.json`).
/// Carries the user identity plus the activity stats the directory
/// sorts by — likes given/received, post/topic counts, days visited.
///
/// Phase 5.38 — promoted out of `discourse_core` (was
/// `DiscourseDirectoryItem`) so the directory concept is expressed
/// directly on the SDK surface, per CLAUDE.md's "extend the SDK
/// interface to express the Discourse concept directly" rule.
@MappableClass()
class FCDirectoryItem with FCDirectoryItemMappable {
  int id;
  String username;
  String? name;

  /// Pre-resolved absolute avatar URL (proxies expand any
  /// templates against the forum base URL before constructing).
  String avatarUrl;

  /// Discourse trust level: 0 (New) → 4 (Leader). Null when the
  /// backend didn't include it.
  int? trustLevel;

  int likesReceived;
  int likesGiven;
  int topicsEntered;
  int postsRead;
  int daysVisited;
  int topicCount;
  int postCount;

  FCDirectoryItem({
    required this.id,
    required this.username,
    required this.avatarUrl,
    this.name,
    this.trustLevel,
    this.likesReceived = 0,
    this.likesGiven = 0,
    this.topicsEntered = 0,
    this.postsRead = 0,
    this.daysVisited = 0,
    this.topicCount = 0,
    this.postCount = 0,
  });

  /// Pull the integer stat matching a directory `order` key so the
  /// list view can show the right metric alongside each row.
  int statFor(String order) {
    switch (order) {
      case 'likes_received':
        return likesReceived;
      case 'likes_given':
        return likesGiven;
      case 'topics_entered':
        return topicsEntered;
      case 'posts_read':
        return postsRead;
      case 'days_visited':
        return daysVisited;
      case 'topic_count':
        return topicCount;
      case 'post_count':
        return postCount;
      default:
        return 0;
    }
  }
}
