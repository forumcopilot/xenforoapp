import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/controllers/post_controller.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/utils/forum_links.dart';
import 'package:forumcopilot_flutter/views/listitems/post_list_item.dart';
import 'package:forumcopilot_flutter/views/widgets/post_time_gap.dart';
import 'package:forumcopilot_flutter/views/widgets/topic_stats_bar.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The thread page's head, as the Discourse app draws it: the title with a
/// lock or pin, the forum under it, the summary under the first post, and
/// "N days later" between posts far apart in time.
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

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('a gap shows after more than a week, in days, months or years', () {
    final start = DateTime(2026, 1, 1);
    expect(PostTimeGap.between(start, start.add(const Duration(days: 7))), isNull, reason: 'at the threshold it stays hidden');
    expect(PostTimeGap.between(start, start.add(const Duration(days: 8))), 8);
    expect(PostTimeGap.between(null, start), isNull);
    expect(ForumLinks.forumUrl(_site.site, '24'), 'https://staging.forumcopilot.com/xenforo/index.php?forums/24/');
  });

  testWidgets('the gap says how long', (tester) async {
    for (final (days, text) in [(12, '12 days later'), (75, '3 months later'), (800, '2 years later')]) {
      await tester.pumpWidget(_app(PostTimeGap(daysSince: days)));
      expect(find.text(text), findsOneWidget);
    }
  });

  testWidgets('the summary: views and replies, and faces once two members take part', (tester) async {
    await tester.pumpWidget(_app(const TopicStatsBar(
      viewCount: 1200,
      replyCount: 1,
      participants: [('Admin', null), ('JessicaTaylor110', null), ('ThomasLee426', null)],
    )));
    expect(find.text('views'), findsOneWidget);
    expect(find.text('reply'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.byType(UserAvatar), findsNWidgets(3));

    await tester.pumpWidget(_app(const TopicStatsBar(viewCount: 3, replyCount: 0, participants: [('Admin', null)])));
    expect(find.text('replies'), findsNothing, reason: 'no replies: no number');
    expect(find.byType(UserAvatar), findsNothing, reason: 'one face is no conversation yet');

    await tester.pumpWidget(_app(const TopicStatsBar(viewCount: 0, replyCount: 0)));
    expect(find.byType(DecoratedBox), findsNothing, reason: 'nothing to report leaves no rule behind');
  });

  testWidgets('the first post: a lock and a pin before the title, the forum under it', (tester) async {
    Future<void> pump({required bool closed, required bool pinned, bool divider = true, int postNumber = 1}) =>
        tester.pumpWidget(_app(PostListItem(
          siteContext: _site,
          post: FCPost(id: '42', title: '', content: 'Body', topicId: '7', authorId: '1', authorName: 'Admin', postNumber: postNumber),
          threadId: '7',
          forumId: '24',
          topicTitle: 'App lab: a locked thread',
          topicClosed: closed,
          topicPinned: pinned,
          topicForumName: 'Layout lab',
          showBottomDivider: divider,
          postController: PostController(),
        )));

    await pump(closed: true, pinned: true);
    expect(find.byIcon(Icons.lock), findsOneWidget);
    expect(find.byIcon(Icons.push_pin), findsOneWidget);
    expect(find.byTooltip('Locked'), findsOneWidget, reason: "XenForo's word, also read out");
    expect(find.text('Layout lab'), findsOneWidget);

    await pump(closed: false, pinned: false);
    expect(find.byIcon(Icons.lock), findsNothing);
    expect(find.byIcon(Icons.push_pin), findsNothing);

    await pump(closed: true, pinned: false, postNumber: 2);
    expect(find.text('Layout lab'), findsNothing, reason: 'only the first post carries the title');

    await pump(closed: false, pinned: false, postNumber: 2);
    final withRule = tester.widgetList<Divider>(find.byType(Divider)).length;
    await pump(closed: false, pinned: false, postNumber: 2, divider: false);
    expect(tester.widgetList<Divider>(find.byType(Divider)).length, withRule - 1);
  });
}
