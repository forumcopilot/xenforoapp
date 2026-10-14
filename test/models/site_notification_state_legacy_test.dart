// Builds that had the device-side notification settings stored a
// `preferences` map in every site's push state
// (`push_notification_site_states`). PushNotificationController drops a site
// whose state fails to parse, and a dropped site is not re-registered with
// push-backend on app start (only on the next login), so that key must keep
// parsing.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:forumcopilot_flutter/models/site_notification_state.dart';

void main() {
  test('state saved with legacy preferences still loads and drops them', () {
    // Exactly what an older build's toJson() wrote, round-tripped through
    // jsonEncode/jsonDecode as SharedPreferences storage does.
    final stored = jsonDecode(jsonEncode({
      'site_id': 'forum.example.com',
      'site_url': 'https://forum.example.com',
      'site_name': 'Test Forum',
      'user_id': '42',
      'username': 'alice',
      'is_registered': true,
      'preferences': {
        'is_enabled': true,
        'new_posts': true,
        'replies': true,
        'mentions': true,
        'quotes': true,
        'likes': false,
        'subscriptions': true,
        'private_messages': true,
        'system_notifications': true,
        'last_updated': '2026-01-01T00:00:00.000',
      },
      'last_registration': '2026-01-02T00:00:00.000',
      'last_notification': null,
      'last_error': null,
      'error_message': null,
      'registration_attempts': 0,
      'is_online': true,
    })) as Map<String, dynamic>;

    final state = SiteNotificationState.fromJson(stored);

    expect(state.isValid, isTrue);
    expect(state.isRegistered, isTrue);
    expect(state.username, 'alice');
    expect(state.toJson().containsKey('preferences'), isFalse);
  });
}
