import 'package:dart_mappable/dart_mappable.dart';

part 'fc_bookmark.mapper.dart';

/// A single bookmark entry returned by the backend's bookmarks endpoint.
///
/// Phase 5.33 — promoted out of `discourse_core` (was
/// `DiscourseBookmark`) so the bookmark concept is expressed directly
/// on the SDK surface rather than leaking the Discourse type through
/// `IFCBookmarkProxy`. The shape is intentionally Discourse-aligned
/// because Discourse is the only backend in v1, but the field names
/// are forum-agnostic so a future XF mapping can populate the same
/// type by translation.
@MappableClass()
class FCBookmark with FCBookmarkMappable {
  /// Bookmark id. Required by `DELETE /bookmarks/{id}.json` on
  /// Discourse — without this we can't remove a bookmark from a list.
  int id;

  /// What this bookmark points to. Discourse's values are `Post` or
  /// `Topic`; unknown values are passed through verbatim.
  String? bookmarkableType;

  /// Numeric id of the bookmarked post or topic.
  int? bookmarkableId;

  /// Topic id used for navigation. May differ from [bookmarkableId]
  /// when the bookmark is on an individual post.
  int? topicId;

  /// 1-based post number within the topic. Lets the UI deep-link into
  /// the thread at the bookmarked post.
  int? postNumber;

  /// Topic title at the time the bookmark was loaded.
  String? title;

  /// Snippet/excerpt from the bookmarked post (HTML-stripped server-side).
  String? excerpt;

  /// Optional user-supplied note attached to the bookmark.
  String? name;

  /// Author of the bookmarked post.
  String? username;

  /// Avatar URL or template for the bookmark's author. Implementations
  /// that produce a template (e.g. Discourse's `avatar_template`) must
  /// pre-resolve the absolute URL — the SDK does not interpret
  /// templates.
  String? avatarUrl;

  /// When the bookmark was created on the server.
  DateTime? createdAt;

  /// When the user asked to be reminded about this bookmark
  /// (Discourse: `reminder_at`). Null when no reminder is set or the
  /// backend has no reminder concept.
  DateTime? reminderAt;

  /// Whether the user pinned this bookmark so it sorts to the top of
  /// their bookmark list (Discourse: `pinned`). Backends without
  /// pinnable bookmarks leave false.
  bool pinned;

  FCBookmark({
    required this.id,
    this.bookmarkableType,
    this.bookmarkableId,
    this.topicId,
    this.postNumber,
    this.title,
    this.excerpt,
    this.name,
    this.username,
    this.avatarUrl,
    this.createdAt,
    this.reminderAt,
    this.pinned = false,
  });
}
