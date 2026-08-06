import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/entities/fc_notification_level.dart';
import 'package:forumcopilot_sdk/models/entities/fc_notification_prefs.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_notification_result.mapper.dart';

/// Result of getting or setting a topic/category/tag notification
/// level (Discourse: `POST /t/{id}/notifications.json`,
/// `POST /category/{id}/notifications.json`, etc.). On success the
/// result carries the post-set level so callers can reconcile UI
/// state without a refetch.
@MappableClass()
class FCNotificationLevelResult extends FCBaseResult
    with FCNotificationLevelResultMappable {
  FCNotificationLevel? level;

  FCNotificationLevelResult({
    required bool result,
    String? resultText,
    this.level,
  }) : super(result: result, resultText: resultText);
}

/// Result of fetching or updating the current user's notification
/// preferences (Discourse: `GET /u/{username}.json` →
/// `PUT /u/{username}.json`).
@MappableClass()
class FCNotificationPrefsResult extends FCBaseResult
    with FCNotificationPrefsResultMappable {
  FCNotificationPrefs? prefs;

  FCNotificationPrefsResult({
    required bool result,
    String? resultText,
    this.prefs,
  }) : super(result: result, resultText: resultText);
}
