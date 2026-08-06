import 'package:dart_mappable/dart_mappable.dart';

part 'fc_notification_prefs.mapper.dart';

/// User-level notification preferences (Discourse: `user.user_option.*`
/// on `/u/{username}.json`, writable via `PUT /u/{username}.json`).
///
/// Phase 5.37 — promoted out of `discourse_core` (was
/// `DiscourseUserNotificationPrefs`) so the notification-prefs concept
/// is expressed directly on the SDK surface, per CLAUDE.md's "extend
/// the SDK interface to express the Discourse concept directly" rule.
///
/// Discourse doesn't model notifications as per-type opt-outs — it
/// decides what counts as a notification, and the user controls how
/// and when it's *delivered* (email frequency, like aggregation,
/// digest cadence). This entity surfaces the controls that genuinely
/// round-trip to the server.
@MappableClass()
class FCNotificationPrefs with FCNotificationPrefsMappable {
  /// Email frequency for activity (replies, mentions, quotes, etc.).
  /// 0 = always · 1 = only when away · 2 = never.
  int emailLevel;

  /// Email frequency for private messages. Same enum as
  /// [emailLevel]; tracked separately on Discourse because PMs are
  /// often higher-priority than general topic activity.
  int emailMessagesLevel;

  /// When true, Discourse periodically sends a digest of activity
  /// the user missed. Mutually exclusive with [mailingListMode]
  /// (server auto-disables digests when MLM is on).
  bool emailDigests;

  /// Window between digest emails, in minutes. Discourse-canonical
  /// values: 1440 (daily) · 10080 (weekly, default) · 43200 (monthly).
  int digestAfterMinutes;

  /// When true, every public post is emailed to the user like a
  /// mailing list. Not recommended on high-volume forums.
  bool mailingListMode;

  /// How often to notify the user when their posts get liked.
  /// 0 = always · 1 = first time + daily digest · 2 = first time
  /// only · 3 = never.
  int likeNotificationFrequency;

  /// Notification level the backend auto-applies to a topic when the
  /// user replies to it. Matches the topic-watch enum (Discourse):
  /// 1 = Normal · 2 = Tracking · 3 = Watching.
  int notificationLevelWhenReplying;

  FCNotificationPrefs({
    this.emailLevel = 1,
    this.emailMessagesLevel = 1,
    this.emailDigests = true,
    this.digestAfterMinutes = 10080,
    this.mailingListMode = false,
    this.likeNotificationFrequency = 0,
    this.notificationLevelWhenReplying = 2,
  });
}
