import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/listitems/forum_list_item.dart';
import 'package:forumcopilot_flutter/views/widgets/subforum_masthead.dart';
import 'package:forumcopilot_flutter/views/widgets/unread_badge.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';

/// A forum's page header (where it sits, its name, description and size,
/// collapsing into the bar) and its sub-forums' rows.
void main() {
  final site = SiteContext(
    siteType: 'xenforo',
    site: Site(name: 'Test Forum', url: 'https://forum.test', description: '', siteType: 'xenforo'),
  );
  final parent = FCForum(id: '1', name: 'Community');

  Widget app(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: child),
      );

  Future<void> pumpMasthead(
    WidgetTester tester, {
    required FCForum forum,
    FCForum? parent,
    VoidCallback? onOpenParent,
    Locale locale = const Locale('en'),
  }) async {
    await tester.pumpWidget(app(
      CustomScrollView(
        slivers: [
          SubforumMasthead(siteContext: site, forum: forum, parent: parent, onOpenParent: onOpenParent),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => SizedBox(height: 80, child: Text('row $i')),
              childCount: 40,
            ),
          ),
        ],
      ),
      locale: locale,
    ));
    await tester.pump();
  }

  /// Text a reader can see: drawn, and not faded out.
  bool shown(WidgetTester tester, Finder finder) {
    final opacities = tester.widgetList<Opacity>(find.ancestor(of: finder, matching: find.byType(Opacity)));
    final animated = tester.widgetList<AnimatedOpacity>(find.ancestor(of: finder, matching: find.byType(AnimatedOpacity)));
    return opacities.every((o) => o.opacity > 0.5) && animated.every((o) => o.opacity > 0.5);
  }

  testWidgets('breadcrumb, name, description and compact stats', (tester) async {
    var opened = 0;
    await pumpMasthead(
      tester,
      forum: FCForum(id: '7', name: 'Dolores Speaks', description: 'Messages from Dolores', topicCount: 120, postCount: 4520),
      parent: parent,
      onOpenParent: () => opened++,
    );
    expect(find.text('Test Forum'), findsOneWidget);
    expect(find.text('Messages from Dolores'), findsOneWidget);
    expect(find.text('120 threads · 4.52K messages'), findsOneWidget);

    await tester.tap(find.text('Community'));
    expect(opened, 1);
  });

  testWidgets('the name shows once: in the open header, then in the bar', (tester) async {
    await pumpMasthead(tester, forum: FCForum(id: '7', name: 'Dolores Speaks'), parent: parent);
    final names = find.text('Dolores Speaks');
    expect(names, findsNWidgets(2), reason: 'one in the header, one in the bar');
    expect([for (var i = 0; i < 2; i++) shown(tester, names.at(i))].where((s) => s).length, 1);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();
    final scrolled = find.text('Dolores Speaks');
    expect([for (var i = 0; i < scrolled.evaluate().length; i++) shown(tester, scrolled.at(i))].where((s) => s).length, 1);
    expect(shown(tester, find.text('Test Forum')), isFalse, reason: 'the breadcrumb slid under the bar');
  });

  testWidgets('no stats line without counts, and a top-level forum names only the forum', (tester) async {
    await pumpMasthead(tester, forum: FCForum(id: '7', name: 'Lobby'));
    expect(find.textContaining('topic'), findsNothing);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });

  testWidgets('a description cut short opens in full', (tester) async {
    final long = List.filled(40, 'A forum about everything and then some more.').join(' ');
    await pumpMasthead(tester, forum: FCForum(id: '7', name: 'Lobby', description: long));
    await tester.tap(find.text(long));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
  });

  testWidgets('a short description is just text', (tester) async {
    await pumpMasthead(tester, forum: FCForum(id: '8', name: 'Lobby', description: 'Short'));
    await tester.tap(find.text('Short'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
  });

  testWidgets('at twice the text size, the header still lays out', (tester) async {
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(360, 780), textScaler: TextScaler.linear(2)),
      child: app(CustomScrollView(slivers: [
        SubforumMasthead(
          siteContext: site,
          forum: FCForum(
            id: '7',
            name: 'A forum with a rather long name indeed',
            description: List.filled(10, 'Long description.').join(' '),
            topicCount: 120,
            postCount: 4520,
          ),
          parent: parent,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 2000)),
      ])),
    ));
    await tester.pump();
    expect(tester.takeException(), isNull);
    // Measured to fit: the breadcrumb, at the top, is not cut off.
    final crumb = tester.getRect(find.text('Test Forum'));
    final bar = tester.getRect(find.byType(AppBar));
    expect(crumb.top, greaterThanOrEqualTo(bar.top + SubforumMasthead.toolbarHeight - 1));
  });

  testWidgets('stats are translated', (tester) async {
    await pumpMasthead(tester, forum: FCForum(id: '7', name: 'Lobby', topicCount: 2, postCount: 9), locale: const Locale('de'));
    expect(find.text('2 Themen · 9 Beiträge'), findsOneWidget);
  });

  group('ForumListItem', () {
    testWidgets('an unread sub-forum is marked, with its counts', (tester) async {
      await tester.pumpWidget(app(ForumListItem(
        siteContext: site,
        forum: FCForum(id: '9', name: 'Songs', hasNewPosts: true, topicCount: 1, postCount: 25),
        compact: true,
      )));
      expect(find.byType(UnreadBadge), findsOneWidget);
      expect(find.text('1 thread · 25 messages'), findsOneWidget);
    });

    testWidgets('a read one is not', (tester) async {
      await tester.pumpWidget(app(ForumListItem(siteContext: site, forum: FCForum(id: '9', name: 'Songs'))));
      expect(find.byType(UnreadBadge), findsNothing);
    });
  });
}
