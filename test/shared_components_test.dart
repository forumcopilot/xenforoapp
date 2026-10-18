import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/utils/snackbar_helper.dart';
import 'package:forumcopilot_flutter/views/widgets/empty_state_view.dart';
import 'package:forumcopilot_flutter/views/widgets/filter_chip_bar.dart';
import 'package:forumcopilot_flutter/views/widgets/unread_badge.dart';

/// The shared components phase 2 brings over from the Discourse app.
void main() {
  Widget app(Widget child) => MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: child),
      );

  group('SnackbarHelper', () {
    test('reading time grows with the text, 4 to 10 seconds', () {
      expect(SnackbarHelper.readingTime('Saved'), const Duration(seconds: 4));
      expect(SnackbarHelper.readingTime('x' * 300), const Duration(seconds: 10));
      final medium = SnackbarHelper.readingTime('x' * 100);
      expect(medium, greaterThan(const Duration(seconds: 4)));
      expect(medium, lessThan(const Duration(seconds: 10)));
    });

    testWidgets('an error has a close icon, no action, and replaces what is showing', (tester) async {
      late BuildContext context;
      await tester.pumpWidget(app(Builder(builder: (c) {
        context = c;
        return const SizedBox();
      })));
      SnackbarHelper.showInfo(context, 'First');
      await tester.pump();
      SnackbarHelper.showError(context, 'Could not post');
      await tester.pumpAndSettle();
      expect(find.text('First'), findsNothing);
      expect(find.text('Could not post'), findsOneWidget);
      final bar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(bar.action, isNull);
      expect(bar.showCloseIcon, isTrue);
      // It times out (no action keeps it up).
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text('Could not post'), findsNothing);
    });
  });

  group('EmptyStateView', () {
    testWidgets('an error offers Try again', (tester) async {
      var retried = 0;
      await tester.pumpWidget(app(EmptyStateView.error(message: 'Could not load', onRetry: () => retried++)));
      expect(find.text('Could not load'), findsOneWidget);
      await tester.tap(find.text('Try Again'));
      expect(retried, 1);
    });

    testWidgets('an empty state shows its hint and no retry', (tester) async {
      await tester.pumpWidget(app(const EmptyStateView(icon: Icons.inbox_outlined, message: 'No messages', hint: 'Start one')));
      expect(find.text('No messages'), findsOneWidget);
      expect(find.text('Start one'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNothing);
    });
  });

  testWidgets('FilterChipBar selects another chip, ignores the selected one', (tester) async {
    final selected = <int>[];
    await tester.pumpWidget(app(FilterChipBar(
      options: const [FilterChipOption(label: 'Latest'), FilterChipOption(label: 'Unread')],
      selectedIndex: 0,
      onSelected: selected.add,
    )));
    await tester.tap(find.text('Latest'));
    await tester.tap(find.text('Unread'));
    expect(selected, [1]);
  });

  testWidgets('UnreadBadge caps at 99+ and is a dot without a count', (tester) async {
    await tester.pumpWidget(app(const Row(children: [UnreadBadge(count: 150), UnreadBadge()])));
    expect(find.text('99+'), findsOneWidget);
    expect(find.byType(Badge), findsNWidgets(2));
  });
}
