import '../models/results/fc_draft_result.dart';

/// Draft operations exposed to the app.
///
/// Phase 5.34 — promoted out of `DiscoursePostProxy` (the previous
/// `saveDraftAsync` / `loadDraftAsync` / `deleteDraftAsync` /
/// `getMyDraftsAsync` sidecars) so server-side drafts are a
/// first-class SDK concept, per CLAUDE.md's "extend the SDK
/// interface to express the Discourse concept directly" rule.
///
/// Discourse endpoints used by the reference implementation:
///   * `POST   /drafts.json`             — save / upsert (body carries
///                                          `draft_key`, `sequence`,
///                                          `data` as a JSON-encoded
///                                          string)
///   * `GET    /drafts/{key}.json`       — fetch one draft
///   * `DELETE /drafts/{key}.json?sequence=N` — discard
///   * `GET    /drafts.json[?page=P]`    — list current user's drafts
abstract class IFCDraftProxy {
  /// Save or update the draft under [draftKey]. [data] is a typed
  /// blob the composer wants to persist (typically `{reply, title?,
  /// categoryId?, tags?, action?}`). [sequence] is Discourse's
  /// optimistic-concurrency token — pass back whatever the last
  /// load/save returned, or 0 on first save.
  Future<FCSaveDraftResult> saveDraftAsync({
    required String draftKey,
    required Map<String, dynamic> data,
    int sequence = 0,
  });

  /// Load the draft at [draftKey], if any. On success the result's
  /// `draft` may still be null when no server-side draft exists for
  /// that key — that's the expected fresh-composer case.
  Future<FCLoadDraftResult> loadDraftAsync(String draftKey);

  /// Delete the draft at [draftKey]. [sequence] is the last-known
  /// sequence the server returned; mismatch yields a conflict error.
  Future<FCDeleteDraftResult> deleteDraftAsync(
    String draftKey, {
    int sequence = 0,
  });

  /// Fetch the current user's full draft list. [page] is 0-indexed;
  /// implementations decide the page size. Returns `result:false` if
  /// the user is not signed in.
  Future<FCDraftListResult> getMyDraftsAsync({int page = 0});
}
