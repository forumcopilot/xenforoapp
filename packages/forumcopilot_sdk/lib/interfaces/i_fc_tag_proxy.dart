import '../models/results/fc_tag_result.dart';
import '../models/results/fc_topic_result.dart';

/// Tag operations exposed to the app.
///
/// Phase 5.35 — promoted out of `DiscourseTopicProxy` (the previous
/// `getAllTagsAsync` / `searchTagsAsync` / `getTopicsByTagAsync`
/// sidecars) so tags are a first-class SDK concept, per CLAUDE.md's
/// "extend the SDK interface to express the Discourse concept directly"
/// rule. XF-shaped backends without a tag concept can implement this
/// proxy as `result:false` stubs.
///
/// Discourse endpoints used by the reference implementation:
///   * `GET /tags.json`                                  — list all tags
///   * `GET /tags/filter/search.json?q=&limit=`          — autocomplete
///   * `GET /tag/{name}.json[?page=P]`                   — topics tagged
abstract class IFCTagProxy {
  /// List all tags visible to the current user, sorted by topic count
  /// (descending) then alphabetically.
  ///
  /// [includePmOnly] defaults to false — PM-only tags are admin-set
  /// allowlists for private messages and don't belong on a public
  /// tags browser.
  Future<FCTagListResult> getAllTagsAsync({bool includePmOnly = false});

  /// Autocomplete tag names matching the [query] prefix. Returns the
  /// matching tag names (strings) for composer suggestions; pass to
  /// [getAllTagsAsync] / [getTopicsByTagAsync] for richer data.
  Future<FCTagSearchResult> searchTagsAsync(String query, {int limit = 10});

  /// List topics tagged with [tagName] (paginated). The returned
  /// [FCTopicDataResult] re-uses the topic-list result type so the UI
  /// can render tag-filtered lists with the same widgets as a category
  /// listing.
  Future<FCTopicDataResult> getTopicsByTagAsync(
    String tagName, {
    int page = 0,
  });
}
