import '../models/results/fc_bookmark_result.dart';

/// Bookmark operations exposed to the app.
///
/// Phase 5.33 — promoted out of `DiscoursePostProxy` (the previous
/// `bookmarkPostAsync` / `unbookmarkPostAsync` / `getBookmarksAsync`
/// sidecars) so bookmarks are a first-class SDK concept, per
/// CLAUDE.md's "extend the SDK interface to express the Discourse
/// concept directly" rule.
///
/// Discourse endpoints used by the reference implementation:
///   * `POST   /bookmarks.json`         — create
///   * `DELETE /bookmarks/{id}.json`    — remove (by bookmark id)
///   * `GET    /u/{username}/bookmarks.json` — list current user's
abstract class IFCBookmarkProxy {
  /// Add a bookmark on the given [postId]. On success the result
  /// carries the new bookmark id so callers can remove it without an
  /// extra lookup.
  Future<FCAddBookmarkResult> addPostBookmarkAsync(String postId);

  /// Remove the bookmark from the given [postId]. Implementations
  /// that need the bookmark id (e.g. Discourse) look it up via the
  /// list endpoint internally; callers should only need the post id.
  Future<FCRemoveBookmarkResult> removePostBookmarkAsync(String postId);

  /// Remove a bookmark by its own id. Use this when the caller
  /// already has the bookmark id from a list query — it skips the
  /// extra lookup round-trip [removePostBookmarkAsync] does.
  Future<FCRemoveBookmarkResult> removeBookmarkByIdAsync(int bookmarkId);

  /// Fetch the current user's bookmark list. [page] is 0-indexed;
  /// implementations decide page size. Returns `result:false` if the
  /// user is not signed in.
  Future<FCBookmarkListResult> getBookmarksAsync({int page = 0});
}
