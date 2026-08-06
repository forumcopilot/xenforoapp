/// Subscription / notification level for topics, categories and tags.
///
/// Maps directly to Discourse's `notification_level` integers:
///   0 → muted
///   1 → normal (regular)
///   2 → tracking
///   3 → watching
///   4 → watching first post (categories/tags only)
///
/// Phase 5.37 — promoted out of `DiscourseSubscriptionProxy`'s raw
/// `int level` arguments so the SDK contract reads in human terms.
enum FCNotificationLevel {
  muted(0),
  normal(1),
  tracking(2),
  watching(3),
  watchingFirstPost(4);

  final int level;
  const FCNotificationLevel(this.level);

  /// Build from Discourse's raw integer. Falls back to [normal] for
  /// unknown values so callers don't have to handle null.
  static FCNotificationLevel fromInt(int? value) {
    switch (value) {
      case 0:
        return FCNotificationLevel.muted;
      case 2:
        return FCNotificationLevel.tracking;
      case 3:
        return FCNotificationLevel.watching;
      case 4:
        return FCNotificationLevel.watchingFirstPost;
      default:
        return FCNotificationLevel.normal;
    }
  }
}
