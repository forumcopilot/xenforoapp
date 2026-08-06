import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/entities/fc_bookmark.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_bookmark_result.mapper.dart';

/// Result of adding a bookmark on a post or topic (Discourse:
/// `POST /bookmarks.json`).
///
/// [isBookmarked] is true on success — UI uses this to drive its
/// optimistic toggle instead of inferring from [result]. [bookmarkId]
/// is the newly-created bookmark id so the UI can DELETE it without a
/// round-trip lookup.
@MappableClass()
class FCAddBookmarkResult extends FCBaseResult with FCAddBookmarkResultMappable {
  bool isBookmarked;
  int? bookmarkId;

  FCAddBookmarkResult({
    required bool result,
    String? resultText,
    this.isBookmarked = false,
    this.bookmarkId,
  }) : super(result: result, resultText: resultText);
}

/// Result of removing a bookmark (Discourse:
/// `DELETE /bookmarks/{id}.json`). [isBookmarked] reflects post-state
/// — false on success — so the UI doesn't need to invert [result].
@MappableClass()
class FCRemoveBookmarkResult extends FCBaseResult
    with FCRemoveBookmarkResultMappable {
  bool isBookmarked;

  FCRemoveBookmarkResult({
    required bool result,
    String? resultText,
    this.isBookmarked = true,
  }) : super(result: result, resultText: resultText);
}

/// Result of fetching the current user's bookmark list (Discourse:
/// `GET /u/{username}/bookmarks.json`).
@MappableClass()
class FCBookmarkListResult extends FCBaseResult
    with FCBookmarkListResultMappable {
  /// Total bookmarks across all pages, when the backend supplies it.
  /// Discourse does not always return a total; falls back to `items.length`
  /// for the current page.
  int total;

  List<FCBookmark> items;

  FCBookmarkListResult({
    required bool result,
    String? resultText,
    required this.total,
    required this.items,
  }) : super(result: result, resultText: resultText);
}
