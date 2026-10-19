import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/widgets/position_navigator.dart';

/// The pill over a conversation or a thread: first, last, and where the
/// reader is, a tap away from Jump.
void main() {
  Future<List<String>> pump(WidgetTester tester, {required int position, required int total}) async {
    final calls = <String>[];
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: Stack(children: [
          const SizedBox.expand(),
          PositionNavigator.place(
            navigator: HiddenWhileTyping(
              child: PositionNavigator(
              position: position,
              total: total,
              positionLabel: 'Post $position of $total',
              jumpHint: 'jump',
              firstHint: 'first',
              lastHint: 'last',
              onFirst: () => calls.add('first'),
              onLast: () => calls.add('last'),
              onJump: () => calls.add('jump'),
              ),
            ),
          ),
        ]),
      ),
    ));
    return calls;
  }

  testWidgets('where the reader is, and the three ways to move', (tester) async {
    final calls = await pump(tester, position: 3, total: 12);
    expect(find.text('3 / 12'), findsOneWidget);
    expect(find.bySemanticsLabel('Post 3 of 12'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.tap(find.text('3 / 12'));
    await tester.tap(find.byIcon(Icons.arrow_downward));
    expect(calls, ['first', 'jump', 'last']);
  });

  testWidgets('nothing with a single post or message', (tester) async {
    await pump(tester, position: 1, total: 1);
    expect(find.text('1 / 1'), findsNothing);
    expect(find.byIcon(Icons.arrow_upward), findsNothing);
  });

  testWidgets('out of the way while the keyboard is up, even under a Scaffold', (tester) async {
    await pump(tester, position: 3, total: 12);
    expect(find.text('3 / 12'), findsOneWidget);
    // The keyboard: the Scaffold's body sees no insets, the window does.
    tester.view.viewInsets = const FakeViewPadding(bottom: 800);
    addTearDown(tester.view.resetViewInsets);
    await tester.pump();
    expect(find.text('3 / 12'), findsNothing);
    tester.view.resetViewInsets();
    await tester.pump();
    expect(find.text('3 / 12'), findsOneWidget);
  });

  testWidgets('at the bottom left, clear of the footers\' actions on the right', (tester) async {
    await pump(tester, position: 3, total: 12);
    final pill = tester.getRect(find.byType(PositionNavigator));
    expect(pill.left, lessThan(tester.view.physicalSize.width / tester.view.devicePixelRatio / 2));
  });
}
