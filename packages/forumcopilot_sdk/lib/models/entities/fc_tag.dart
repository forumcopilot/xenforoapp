import 'package:dart_mappable/dart_mappable.dart';

part 'fc_tag.mapper.dart';

/// A single tag as exposed to the app.
///
/// Phase 5.35 — promoted out of `discourse_core` (was `DiscourseTag`)
/// so tags are a first-class SDK concept, per CLAUDE.md's "extend
/// the SDK interface to express the Discourse concept directly" rule.
@MappableClass()
class FCTag with FCTagMappable {
  /// Database id when the backend exposes one (Discourse: integer).
  int? id;

  /// Tag handle as used in URLs. Lowercase + slug-safe; this is the
  /// value the SDK passes to `IFCTagProxy.getTopicsByTagAsync`.
  String name;

  /// Human-display label. Usually identical to [name].
  String text;

  /// Number of topics using this tag (excluding deleted/whispered).
  /// Used to sort the global tag list by popularity.
  int count;

  /// Optional admin-set description shown under the name on a tag
  /// browser.
  String? description;

  /// True when the tag is only valid on private messages (per-tag PM
  /// allowlist). Public tag browsers should hide these by default.
  bool pmOnly;

  FCTag({
    required this.name,
    required this.text,
    this.id,
    this.count = 0,
    this.description,
    this.pmOnly = false,
  });
}
