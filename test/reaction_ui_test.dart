import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/widgets/reaction_summary.dart';
import 'package:forumcopilot_flutter/views/widgets/reaction_users_sheet.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';

/// The reaction summary beside the react button and the who-reacted sheet,
/// both ported from the Discourse app.

FCLike _like(String username, int? reactionId, {String? emoji}) => FCLike(
      userId: username.hashCode.toString(),
      username: username,
      avatarUrl: '',
      reactionId: reactionId,
      reactionEmoji: emoji,
    );

void _loadReactionSet() {
  ReactionRegistry.instance.setFromJsonList([
    {'id': 1, 'title': 'Like', 'emoji': '👍', 'imageUrl': '', 'displayOrder': 100},
    {'id': 2, 'title': 'Love', 'emoji': '😍', 'imageUrl': '', 'displayOrder': 200},
    {'id': 4, 'title': 'Wow', 'emoji': '😮', 'imageUrl': '', 'displayOrder': 400},
  ]);
}

SiteContext _siteContext({String? viewer}) => SiteContext(
      siteType: 'xenforo',
      site: Site(
        id: 1,
        name: 'Test',
        url: 'https://example.com',
        description: '',
        endpoint: 'forumcopilot.php',
        baseUrl: 'https://example.com',
        siteType: 'xenforo',
      ),
      loginDataOutput: viewer == null
          ? null
          : FCLoginResult(result: true, resultText: '', user: FCUser(id: '9', username: viewer)),
    );

Widget _app(Widget child) => MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  tearDown(ReactionRegistry.instance.clear);

  group('groupReactions / reactionTotal', () {
    test('most used first, ties in the forum display order', () {
      _loadReactionSet();
      final groups = groupReactions([
        _like('a', 4),
        _like('b', 2),
        _like('c', 1),
        _like('d', 1),
      ]);
      expect(groups.map((g) => g.id), [1, 2, 4]);
      expect(groups.map((g) => g.count), [2, 1, 1]);
      expect(groups.first.glyph.emoji, '👍');
    });

    test('entries without a reaction id (add-on 1.3.x) are one Like group', () {
      final groups = groupReactions([_like('a', null), _like('b', null)]);
      expect(groups, hasLength(1));
      expect(groups.single.isDefaultLike, isTrue);
      expect(groups.single.glyph.hasEmoji, isFalse);
    });

    test('an unknown reaction uses the emoji the entry carries', () {
      final groups = groupReactions([_like('a', 9, emoji: '🤯')]);
      expect(groups.single.glyph.emoji, '🤯');
    });

    test('the total is the higher of the server count and the list', () {
      // Add-ons before 1.8.11 send reaction_score: 0 for a lone Wow.
      expect(reactionTotal([_like('a', 4)], 0), 1);
      expect(reactionTotal([_like('a', 1)], 7), 7);
      expect(reactionTotal(const [], 0), 0);
    });
  });

  group('ReactionSummary', () {
    testWidgets('shows the emoji used, most used first, and the count', (tester) async {
      _loadReactionSet();
      await tester.pumpWidget(_app(ReactionSummary(
        likes: [_like('a', 4), _like('b', 1), _like('c', 1)],
        count: 2, // reaction_score from an older add-on
        besideReactButton: true,
        onTap: () {},
      )));
      expect(find.text('👍'), findsOneWidget);
      expect(find.text('😮'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('👍')).dx < tester.getTopLeft(find.text('😮')).dx,
        isTrue,
      );
      expect(find.bySemanticsLabel('3 reactions'), findsOneWidget);
    });

    testWidgets('at most three emoji', (tester) async {
      _loadReactionSet();
      await tester.pumpWidget(_app(ReactionSummary(
        likes: [_like('a', 1), _like('b', 2), _like('c', 4), _like('d', 9, emoji: '🤯')],
        count: 4,
      )));
      expect(find.text('🤯'), findsNothing);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('only Likes beside the react button: the bare count', (tester) async {
      _loadReactionSet();
      await tester.pumpWidget(_app(ReactionSummary(
        likes: [_like('a', 1), _like('b', 1)],
        count: 2,
        besideReactButton: true,
      )));
      expect(find.text('👍'), findsNothing);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('only Likes without the react button: the Like shows', (tester) async {
      _loadReactionSet();
      await tester.pumpWidget(_app(ReactionSummary(
        likes: [_like('a', 1), _like('b', 1)],
        count: 2,
      )));
      expect(find.text('👍'), findsOneWidget);
    });

    testWidgets('a count with nobody listed shows a heart and is not tappable', (tester) async {
      await tester.pumpWidget(_app(const ReactionSummary(likes: [], count: 2)));
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('nothing at all without reactions', (tester) async {
      await tester.pumpWidget(_app(const ReactionSummary(likes: [], count: 0)));
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('a tap opens the list', (tester) async {
      _loadReactionSet();
      var taps = 0;
      await tester.pumpWidget(_app(ReactionSummary(
        likes: [_like('a', 4)],
        count: 1,
        onTap: () => taps++,
      )));
      await tester.tap(find.text('1'));
      expect(taps, 1);
    });
  });

  group('ReactionUsersSheet', () {
    Future<void> open(
      WidgetTester tester, {
      required List<FCLike> likes,
      String? viewer,
      VoidCallback? onReact,
    }) async {
      // A Pixel 4a's screen: the sheet opens at half height, which on the
      // default 800x600 test surface fits only three rows.
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(Builder(
        builder: (context) => TextButton(
          onPressed: () => ReactionUsersSheet.show(
            context: context,
            siteContext: _siteContext(viewer: viewer),
            likes: likes,
            count: likes.length,
            onReact: onReact,
          ),
          child: const Text('open'),
        ),
      )));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    final mixed = [
      _like('Alice', 1),
      _like('Bob', 1),
      _like('Carol', 4),
      _like('Me', 1),
    ];

    testWidgets('title with the count, a chip per reaction, you first', (tester) async {
      _loadReactionSet();
      await open(tester, likes: mixed, viewer: 'Me', onReact: () {});

      expect(find.text('4 reactions'), findsOneWidget);
      expect(find.text('All 4'), findsOneWidget);
      expect(find.bySemanticsLabel('Like, 3 people'), findsOneWidget);
      expect(find.bySemanticsLabel('Wow, 1 person'), findsOneWidget);

      expect(find.text('You'), findsOneWidget);
      final names = ['Me', 'Alice', 'Bob', 'Carol'];
      final ys = [for (final n in names) tester.getTopLeft(find.text(n)).dy];
      expect(ys, orderedEquals([...ys]..sort()), reason: 'the reader leads, then server order');
      expect(find.text('Change your reaction'), findsOneWidget);
    });

    testWidgets('a chip filters the list', (tester) async {
      _loadReactionSet();
      await open(tester, likes: mixed, viewer: 'Me');

      await tester.tap(find.bySemanticsLabel('Wow, 1 person'));
      await tester.pumpAndSettle();
      expect(find.text('Carol'), findsOneWidget);
      expect(find.text('Alice'), findsNothing);
      expect(find.text('Me'), findsNothing);

      await tester.tap(find.text('All 4'));
      await tester.pumpAndSettle();
      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('one kind of reaction: no chips', (tester) async {
      _loadReactionSet();
      await open(tester, likes: [_like('Alice', 1), _like('Bob', 1)]);
      expect(find.byType(ChoiceChip), findsNothing);
      expect(find.text('2 reactions'), findsOneWidget);
    });

    testWidgets('React closes the sheet and opens the picker', (tester) async {
      _loadReactionSet();
      var reacted = 0;
      await open(tester, likes: [_like('Alice', 1)], viewer: 'Me', onReact: () => reacted++);
      expect(find.text('React'), findsOneWidget);
      await tester.tap(find.text('React'));
      await tester.pumpAndSettle();
      expect(reacted, 1);
      expect(find.text('Alice'), findsNothing);
    });

    testWidgets('no button when the reader may not react; Like wording without a reaction set',
        (tester) async {
      await open(tester, likes: [_like('Alice', null)]);
      expect(find.byType(OutlinedButton), findsNothing);
      expect(find.text('1 like'), findsOneWidget);
    });
  });
}
