import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/controllers/post_controller.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/listitems/post_list_item.dart';
import 'package:forumcopilot_flutter/views/private_messaging/conversation/widgets/conversation_item.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// What the next add-on sends after 1.11.0: the title under a member's name
/// (posts and direct messages), the "Last edited" line, and a thread's tags.
final _site = SiteContext(
  siteType: 'xenforo',
  site: Site(id: 1, name: 'T', url: 'https://staging.forumcopilot.com/xenforo', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://staging.forumcopilot.com/xenforo', siteType: 'xenforo'),
  configDataOutput: FCConfigResult(),
);

Widget _app(Widget child) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

Widget _post(FCPost post, {List<String> tags = const []}) => PostListItem(
      siteContext: _site,
      post: post,
      threadId: '7',
      forumId: '24',
      topicTitle: 'App lab',
      topicForumName: 'Layout lab',
      topicTags: tags,
      postController: PostController(),
    );

FCPost _fcPost({int postNumber = 2, String? title, DateTime? edited, bool byModerator = false}) => FCPost(
      id: '42',
      title: '',
      content: 'Body',
      topicId: '7',
      authorId: '1',
      authorName: 'Admin',
      postNumber: postNumber,
      authorTitle: title,
      lastEditDate: edited,
      lastEditByModerator: byModerator,
    );

Finder _tooltipStarting(String text) => find.byWidgetPredicate((w) => w is Tooltip && (w.message ?? '').startsWith(text));

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets("a post shows the author's title beside the name", (tester) async {
    await tester.pumpWidget(_app(_post(_fcPost(title: 'Well-known member'))));
    expect(find.text('Well-known member'), findsOneWidget);

    await tester.pumpWidget(_app(_post(_fcPost(title: ''))));
    expect(find.text('Well-known member'), findsNothing);
  });

  testWidgets('an edited post carries XenForo\'s "Last edited" line on its pencil', (tester) async {
    final edited = DateTime(2026, 10, 29, 18, 0);
    await tester.pumpWidget(_app(_post(_fcPost(edited: edited))));
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(_tooltipStarting('Last edited: '), findsOneWidget);

    await tester.pumpWidget(_app(_post(_fcPost(edited: edited, byModerator: true))));
    expect(_tooltipStarting('Last edited by a moderator: '), findsOneWidget, reason: 'XenForo never names the editor');

    await tester.pumpWidget(_app(_post(_fcPost())));
    expect(find.byIcon(Icons.edit_outlined), findsNothing, reason: 'no edit line: never edited, or an add-on that does not say');
  });

  testWidgets("the first post lists the thread's tags beside its forum", (tester) async {
    await tester.pumpWidget(_app(_post(_fcPost(postNumber: 1), tags: ['flutter', 'app lab'])));
    expect(find.text('Layout lab'), findsOneWidget);
    expect(find.text('flutter'), findsOneWidget);
    expect(find.text('app lab'), findsOneWidget);
  });

  testWidgets("a direct message shows the author's title beside the name", (tester) async {
    await tester.pumpWidget(_app(ConversationItem(
      siteContext: _site,
      message: FCConversationMessage(
        messageId: '9',
        userId: '2',
        username: 'alice',
        textBody: 'Hi',
        messageTime: '1760000000000',
        authorTitle: 'Moderator',
      ),
    )));
    expect(find.text('alice'), findsOneWidget);
    expect(find.text('Moderator'), findsOneWidget);
  });
}
