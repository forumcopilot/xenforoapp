// Smoke test: the app builds and shows its root MaterialApp.
//
// Pumping ForumCopilotApp also starts the forum bootstrap (SiteController and
// SingleForumBootstrapPage each kick off a getConfig call with a 10-second
// timeout in a post-frame callback). Under flutter_test the HTTP client
// answers every request with 400, so those calls fail fast and land in their
// error handlers, but the timeout timers they armed still exist when the test
// body returns. Advancing fake time past every timeout lets them fire and be
// cleaned up, so the test ends with no pending timers and no network access.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:forumcopilot_flutter/forumcopilot_app.dart';

void main() {
  testWidgets('ForumCopilotApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ForumCopilotApp());

    expect(find.byType(MaterialApp), findsOneWidget);

    // Let the bootstrap's timeouts (10 s) and any HTTP connect timeout elapse.
    await tester.pump(const Duration(seconds: 31));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });
}
