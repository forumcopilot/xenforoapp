import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/listitems/topic_list_item.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A topic row with and without a preview of its first post. Without one
/// the row threw (`shortContent!`); XenForo always sends one, other forums
/// and older add-ons need not.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(Get.reset);

  final site = SiteContext(
    siteType: 'xenforo',
    site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'xenforo'),
    configDataOutput: FCConfigResult(),
  );

  FCTopic topic({String? preview}) => FCTopic(
        id: '1',
        title: 'A topic',
        forumId: '1',
        forumName: 'Lobby',
        authorId: '1',
        authorName: 'Ann',
        timestamp: DateTime.utc(2026, 10, 19),
        shortContent: preview,
      );

  Future<void> pumpRow(WidgetTester tester, FCTopic topic) => tester.pumpWidget(GetMaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: TopicListItem(siteContext: site, topic: topic, onTap: () {})),
      ));

  testWidgets('without a preview, the row shows its title', (tester) async {
    await pumpRow(tester, topic());
    expect(tester.takeException(), isNull);
    expect(find.text('A topic'), findsOneWidget);
  });

  testWidgets('with one, the preview shows under the title', (tester) async {
    await pumpRow(tester, topic(preview: 'The first post.'));
    expect(find.text('The first post.'), findsOneWidget);
  });
}
