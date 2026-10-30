import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/controllers/post_controller.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/listitems/post_list_item.dart';
import 'package:forumcopilot_flutter/views/listitems/topic_list_item.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// XenForo question and suggestion threads (add-on 1.11.0+): the topic row
/// says whether a question is solved and shows a suggestion's score, and the
/// accepted answer is marked in the thread.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(Get.reset);

  final site = SiteContext(
    siteType: 'xenforo',
    site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'xenforo'),
    configDataOutput: FCConfigResult(),
  );

  FCTopic topic({String? threadType, bool isSolved = false, int? voteScore}) => FCTopic(
        id: '1',
        title: 'A topic',
        forumId: '1',
        forumName: 'Lobby',
        authorId: '1',
        authorName: 'Ann',
        timestamp: DateTime.utc(2026, 10, 19),
        shortContent: 'Text',
        threadType: threadType,
        isSolved: isSolved,
        voteScore: voteScore,
      );

  Future<void> pumpRow(WidgetTester tester, FCTopic topic) => tester.pumpWidget(GetMaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: TopicListItem(siteContext: site, topic: topic, onTap: () {})),
      ));

  testWidgets('a solved question says so', (tester) async {
    await pumpRow(tester, topic(threadType: 'question', isSolved: true));
    expect(find.text('Solved'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
  });

  testWidgets('an open question is marked as a question', (tester) async {
    await pumpRow(tester, topic(threadType: 'question'));
    expect(find.text('Question'), findsOneWidget, reason: 'its only marker, so it is labelled');
    expect(find.text('Solved'), findsNothing);
  });

  testWidgets("a suggestion shows its score", (tester) async {
    await pumpRow(tester, topic(threadType: 'suggestion', voteScore: -2));
    expect(find.text('-2'), findsOneWidget);
    expect(find.byIcon(Icons.thumbs_up_down_outlined), findsOneWidget);
  });

  testWidgets('a discussion, or a thread from an older add-on, has none of these', (tester) async {
    await pumpRow(tester, topic());
    expect(find.text('Question'), findsNothing);
    expect(find.text('Solved'), findsNothing);
    expect(find.byIcon(Icons.thumbs_up_down_outlined), findsNothing);
  });

  Future<void> pumpPost(WidgetTester tester, {required bool isSolution}) => tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: PostListItem(
              siteContext: site,
              post: FCPost(
                id: '42',
                title: '',
                content: 'Restart the router.',
                topicId: '7',
                authorId: '1',
                authorName: 'author',
                postNumber: 3,
                isSolution: isSolution,
              ),
              threadId: '7',
              topicTitle: 'Thread',
              postController: PostController(),
            ),
          ),
        ),
      ));

  testWidgets('the accepted answer is marked in the thread', (tester) async {
    await pumpPost(tester, isSolution: true);
    expect(find.text('SOLUTION'), findsOneWidget);
    await pumpPost(tester, isSolution: false);
    expect(find.text('SOLUTION'), findsNothing);
  });
}
