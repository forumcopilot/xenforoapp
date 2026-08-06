import 'package:dart_mappable/dart_mappable.dart';

part 'fc_badge.mapper.dart';

/// Badge tier (Bronze / Silver / Gold).
enum FCBadgeTier { bronze, silver, gold }

/// A single badge (Discourse: from `/badges.json` or
/// `/user-badges/{username}.json`). The proxy flattens Discourse's
/// `badges[]` definitions + `user_badges[]` grants into one model so
/// the UI can render badge chips without juggling two arrays.
///
/// Phase 5.38 — promoted out of `discourse_core` (was
/// `DiscourseBadge`).
@MappableClass()
class FCBadge with FCBadgeMappable {
  int id;
  String name;
  String? description;

  /// Font Awesome short name (e.g. `fa-heart`). Null when the badge
  /// uses an uploaded image.
  String? icon;

  /// Uploaded image URL — overrides [icon] when present.
  String? imageUrl;

  /// Bronze=1, Silver=2, Gold=3 per Discourse convention.
  int badgeTypeId;

  /// When this user was granted the badge. Null for catalog rows
  /// (badges the user hasn't earned).
  DateTime? grantedAt;

  /// How many times the user has been granted this badge (some
  /// badges can stack, e.g. "Nice Reply"). Defaults to 1.
  int grantCount;

  /// True when the badge appears on the user's profile (rather than
  /// being a catalog row).
  bool granted;

  FCBadge({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.imageUrl,
    this.badgeTypeId = 1,
    this.grantedAt,
    this.grantCount = 1,
    this.granted = true,
  });

  FCBadgeTier get tier {
    switch (badgeTypeId) {
      case 3:
        return FCBadgeTier.gold;
      case 2:
        return FCBadgeTier.silver;
      default:
        return FCBadgeTier.bronze;
    }
  }
}
