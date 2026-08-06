import 'package:dart_mappable/dart_mappable.dart';

part 'fc_draft.mapper.dart';

/// A single server-side draft entry (Discourse: one row from
/// `GET /drafts.json` or one decoded `draft` blob from
/// `GET /drafts/{key}.json`).
///
/// Phase 5.34 — promoted out of `discourse_core` (was `DiscourseDraft`)
/// so drafts are a first-class SDK concept, per CLAUDE.md's "extend
/// the SDK interface to express the Discourse concept directly" rule.
///
/// The `data` map intentionally stays untyped — Discourse drafts hold
/// different fields depending on the composer (`reply` body markdown,
/// optional `title` for new topics, `action`, `categoryId`, `tags`).
/// Use the convenience getters for the common reads.
@MappableClass()
class FCDraft with FCDraftMappable {
  /// `topic_<id>` for reply drafts, `new_topic` for new topics,
  /// `new_private_message` for PM drafts.
  String draftKey;

  /// Optimistic-concurrency token; bumped on every save. Pass back to
  /// `IFCDraftProxy.saveDraftAsync` and `deleteDraftAsync`.
  int sequence;

  /// Parsed inner blob — typically `{reply, title?, categoryId?, tags?, action?}`.
  Map<String, dynamic> data;

  /// Topic id for reply drafts; null for `new_topic` / PM drafts.
  int? topicId;

  /// Topic title for reply drafts, when the backend includes it.
  String? title;

  /// Category id for new-topic drafts (typically read out of `data['categoryId']`).
  int? categoryId;

  /// Server-recorded last-modified time. Used to sort drafts newest-first.
  DateTime? updatedAt;

  FCDraft({
    required this.draftKey,
    required this.sequence,
    required this.data,
    this.topicId,
    this.title,
    this.categoryId,
    this.updatedAt,
  });

  /// Reply body text (raw markdown) the user was typing.
  String get reply => (data['reply'] ?? '').toString();

  /// Title pulled from `data['title']` (new-topic / PM drafts), or null
  /// when it's empty/absent.
  String? get topicTitle =>
      data['title']?.toString().isNotEmpty == true
          ? data['title'] as String
          : null;

  /// True when this draft is for a new topic (vs a reply to an existing
  /// topic). Includes new private messages.
  bool get isNewTopic =>
      draftKey == 'new_topic' || draftKey == 'new_private_message';
}
