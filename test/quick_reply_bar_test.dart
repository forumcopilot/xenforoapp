import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/reply_page.dart';
import 'package:forumcopilot_flutter/views/widgets/quick_reply_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The composer at the bottom of a conversation or a thread: sends in
/// place, keeps the text when sending fails, and shares the reply draft with
/// the full Reply page.
void main() {
  const key = 'dm_reply_draft:test:42';

  Future<void> pumpBar(
    WidgetTester tester, {
    required Future<bool> Function(String text) onSend,
    Future<bool> Function(TextEditingController controller)? onOpenFullEditor,
    GlobalKey<QuickReplyBarState>? barKey,
  }) async {
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
        body: Align(
          alignment: Alignment.bottomCenter,
          child: QuickReplyBar(
            key: barKey,
            draftKey: key,
            onSend: onSend,
            onOpenFullEditor: onOpenFullEditor,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  String fieldText(WidgetTester tester) => tester.widget<TextField>(find.byType(TextField)).controller!.text;

  Future<void> tapSend(WidgetTester tester) async {
    await tester.pump(); // the button reflects the text just entered
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();
  }

  testWidgets('a sent reply clears the field and the draft', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final sent = <String>[];
    await pumpBar(tester, onSend: (text) async {
      sent.add(text);
      return true;
    });
    await tester.enterText(find.byType(TextField), '  hello there  ');
    await tester.pump(const Duration(seconds: 3)); // the 2 s draft debounce
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(key), '  hello there  ');

    await tapSend(tester);
    await tester.pumpAndSettle();
    expect(sent, ['hello there']);
    expect(fieldText(tester), isEmpty);
    expect(prefs.getString(key), isNull);
  });

  testWidgets('a reply that was not posted stays in the field', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await pumpBar(tester, onSend: (_) async => false);
    await tester.enterText(find.byType(TextField), 'keep me');
    await tapSend(tester);
    await tester.pumpAndSettle();
    expect(fieldText(tester), 'keep me');
  });

  testWidgets('a send that throws keeps the text and the bar usable', (tester) async {
    SharedPreferences.setMockInitialValues({});
    var calls = 0;
    await pumpBar(tester, onSend: (_) async {
      calls++;
      if (calls == 1) throw Exception('offline');
      return true;
    });
    await tester.enterText(find.byType(TextField), 'try again');
    await tapSend(tester);
    await tester.pumpAndSettle();
    expect(fieldText(tester), 'try again');

    await tapSend(tester);
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(fieldText(tester), isEmpty);
  });

  testWidgets('send is disabled while empty and while sending', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final reply = Completer<bool>();
    var calls = 0;
    await pumpBar(tester, onSend: (_) {
      calls++;
      return reply.future;
    });
    await tapSend(tester);
    expect(calls, 0);

    await tester.enterText(find.byType(TextField), 'once');
    await tapSend(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(CircularProgressIndicator));
    await tester.pump();
    expect(calls, 1);

    reply.complete(true);
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('the saved draft comes back', (tester) async {
    SharedPreferences.setMockInitialValues({key: 'half a reply'});
    await pumpBar(tester, onSend: (_) async => true);
    expect(fieldText(tester), 'half a reply');
  });

  testWidgets('leaving the conversation keeps what was typed', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await pumpBar(tester, onSend: (_) async => true);
    await tester.enterText(find.byType(TextField), 'later');
    await tester.pumpWidget(const SizedBox()); // left before the debounce
    await tester.pump();
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(key), 'later');
  });

  testWidgets('the full editor works on the same text', (tester) async {
    SharedPreferences.setMockInitialValues({});
    TextEditingController? given;
    var posted = false;
    await pumpBar(
      tester,
      onSend: (_) async => true,
      onOpenFullEditor: (controller) async {
        given = controller;
        controller.text = '${controller.text}, then more';
        return posted;
      },
    );
    await tester.enterText(find.byType(TextField), 'start');

    // Closed without posting: the longer text is back in the bar.
    await tester.tap(find.byIcon(Icons.open_in_full));
    await tester.pumpAndSettle();
    expect(given, isNotNull);
    expect(fieldText(tester), 'start, then more');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(key), 'start, then more');

    // Posted there: nothing left to send.
    posted = true;
    await tester.tap(find.byIcon(Icons.open_in_full));
    await tester.pumpAndSettle();
    expect(fieldText(tester), isEmpty);
    expect(prefs.getString(key), isNull);
  });

  testWidgets('another editor (a quote) takes the text, and the bar empties once it posts', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final barKey = GlobalKey<QuickReplyBarState>();
    await pumpBar(tester, onSend: (_) async => true, barKey: barKey);
    await tester.enterText(find.byType(TextField), 'I agree');

    // Closed without posting: the quote and the text stay, as the draft.
    await barKey.currentState!.openEditor((controller) async {
      controller.text = ReplyPage.withQuote(controller.text, '[QUOTE="Ann"]Hi[/QUOTE]\n');
      return false;
    });
    await tester.pumpAndSettle();
    expect(fieldText(tester), 'I agree\n\n[QUOTE="Ann"]Hi[/QUOTE]\n');

    await barKey.currentState!.openEditor((controller) async => true);
    await tester.pumpAndSettle();
    expect(fieldText(tester), isEmpty);
  });

  test('a quote goes after what was typed, or on its own', () {
    expect(ReplyPage.withQuote('', '[QUOTE]x[/QUOTE]\n'), '[QUOTE]x[/QUOTE]\n');
    expect(ReplyPage.withQuote('  ', '[QUOTE]x[/QUOTE]\n'), '[QUOTE]x[/QUOTE]\n');
    expect(ReplyPage.withQuote('Typed\n', '[QUOTE]x[/QUOTE]\n'), 'Typed\n\n[QUOTE]x[/QUOTE]\n');
    // XenForo's quote ends at [/QUOTE]: a new line to write on.
    expect(ReplyPage.withQuote('', '[QUOTE]x[/QUOTE]'), '[QUOTE]x[/QUOTE]\n');
  });

  group('dragging the list above puts the keyboard away', () {
    Future<void> pumpPage(WidgetTester tester, {required ScrollPhysics physics, required int rows}) async {
      SharedPreferences.setMockInitialValues({});
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
          body: Column(children: [
            Expanded(
              child: DismissKeyboardOnDrag(
                child: ListView.builder(
                  physics: physics,
                  itemCount: rows,
                  itemBuilder: (context, i) => SizedBox(height: 80, child: Text('message $i')),
                ),
              ),
            ),
            QuickReplyBar(draftKey: key, onSend: (_) async => true),
          ]),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.showKeyboard(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'Half a reply');
      await tester.pump();
    }

    bool typing(WidgetTester tester) => tester.widget<TextField>(find.byType(TextField)).focusNode!.hasFocus;

    testWidgets('in the middle of the list, keeping the text', (tester) async {
      await pumpPage(tester, physics: const AlwaysScrollableScrollPhysics(), rows: 40);
      expect(typing(tester), isTrue);
      await tester.drag(find.text('message 2'), const Offset(0, -200));
      await tester.pumpAndSettle();
      expect(typing(tester), isFalse);
      expect(fieldText(tester), 'Half a reply');
    });

    testWidgets('past its end, as at a conversation\'s newest message (Android)', (tester) async {
      await pumpPage(tester, physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()), rows: 2);
      await tester.drag(find.text('message 0'), const Offset(0, 200));
      await tester.pumpAndSettle();
      expect(typing(tester), isFalse);
    });

    testWidgets('past its end on iOS, where the list bounces', (tester) async {
      await pumpPage(tester, physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()), rows: 2);
      await tester.drag(find.text('message 0'), const Offset(0, 200));
      await tester.pumpAndSettle();
      expect(typing(tester), isFalse);
    });

    testWidgets('typing alone does not', (tester) async {
      await pumpPage(tester, physics: const AlwaysScrollableScrollPhysics(), rows: 40);
      await tester.enterText(find.byType(TextField), 'Half a reply, and more');
      await tester.pumpAndSettle();
      expect(typing(tester), isTrue);
    });
  });
}
