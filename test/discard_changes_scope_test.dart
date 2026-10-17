import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/widgets/discard_changes_scope.dart';

/// The composers ask before throwing away what was typed, whichever way they
/// are closed; an untouched form closes at once.
void main() {
  Future<TextEditingController> openForm(WidgetTester tester, {bool isEdit = false, bool busy = false}) async {
    final controller = TextEditingController();
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => DiscardChangesScope(
              listenable: controller,
              hasChanges: () => controller.text.trim().isNotEmpty,
              isEdit: isEdit,
              busy: busy,
              child: Scaffold(body: TextField(controller: controller)),
            ),
          )),
          child: const Text('open'),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return controller;
  }

  Future<void> pressBack(WidgetTester tester) async {
    await tester.binding.handlePopRoute(); // system Back
    await tester.pumpAndSettle();
  }

  testWidgets('an untouched form closes at once', (tester) async {
    await openForm(tester);
    await pressBack(tester);
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('typed text: Back asks, Cancel keeps the form, Discard closes it', (tester) async {
    final controller = await openForm(tester);
    controller.text = 'half a reply';
    await tester.pump();

    await pressBack(tester);
    expect(find.text('Do you want to discard your post?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(controller.text, 'half a reply');

    await pressBack(tester);
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('an edit asks about changes', (tester) async {
    final controller = await openForm(tester, isEdit: true);
    controller.text = 'edited';
    await tester.pump();
    await pressBack(tester);
    expect(find.text('Do you want to discard your changes?'), findsOneWidget);
    expect(find.text('Discard changes'), findsOneWidget);
  });

  testWidgets('nothing closes while sending', (tester) async {
    final controller = await openForm(tester, busy: true);
    controller.text = 'sending';
    await tester.pump();
    await pressBack(tester);
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(TextField), findsOneWidget);
  });
}
