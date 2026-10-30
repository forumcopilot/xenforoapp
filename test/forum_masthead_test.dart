import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_icon_tile.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_masthead.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_sdk/models/results/fc_forum_result.dart';

/// The forum's header on Home: whose forum it is, how big, and search, and
/// it collapses into the app bar.
void main() {
  final site = SiteContext(
    siteType: 'xenforo',
    site: Site(name: 'Test Forum', url: 'https://forum.test', description: 'All about tests', siteType: 'xenforo'),
  );
  final stats = FCBoardStatResult(
    result: true,
    resultText: '',
    totalMembers: 56800,
    totalThreads: 1,
    totalPosts: 1234567,
  );

  Future<void> pump(WidgetTester tester, {VoidCallback? onSearch, Locale locale = const Locale('en')}) async {
    await tester.pumpWidget(MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            ForumMasthead(siteContext: site, boardStats: stats, onSearch: onSearch),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => SizedBox(height: 80, child: Text('row $i')),
                childCount: 40,
              ),
            ),
          ],
        ),
      ),
    ));
    await tester.pump();
  }

  testWidgets('name, description, compact stats and the search field', (tester) async {
    var searches = 0;
    await pump(tester, onSearch: () => searches++);
    expect(find.text('Test Forum'), findsOneWidget);
    expect(find.text('All about tests'), findsOneWidget);
    expect(find.text('56.8K members · 1 thread · 1.23M messages'), findsOneWidget);
    expect(find.byType(ForumIconTile), findsOneWidget);
    expect(find.text('T'), findsOneWidget); // the initial, without a logo

    await tester.tap(find.text('Search Test Forum'));
    expect(searches, 1);
  });

  testWidgets('no search where the visitor cannot search', (tester) async {
    await pump(tester);
    expect(find.textContaining('Search'), findsNothing);
    expect(find.byIcon(Icons.search), findsNothing);
  });

  testWidgets('scrolled, it is the bar: name stays, search becomes a button', (tester) async {
    var searches = 0;
    await pump(tester, onSearch: () => searches++);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('Test Forum'), findsOneWidget);
    final searchButton = find.widgetWithIcon(IconButton, Icons.search);
    expect(searchButton, findsOneWidget);
    await tester.tap(searchButton);
    expect(searches, 1);
  });

  testWidgets('stats are translated', (tester) async {
    await pump(tester, locale: const Locale('de'));
    expect(find.textContaining('Mitglieder'), findsOneWidget);
    expect(find.textContaining('Beiträge'), findsOneWidget);
  });

  test('initials take whole characters', () {
    expect(initialOf('🎓 Docs'), '🎓');
    expect(initialOf('  forum'), 'F');
    expect(initialOf('', fallback: 'F'), 'F');
  });
}
