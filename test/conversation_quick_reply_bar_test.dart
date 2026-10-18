import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/private_messaging/conversation/widgets/conversation_quick_reply_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The composer at the bottom of a conversation: sends in place, keeps the
/// text when sending fails, and shares the reply draft with the full Reply
/// page.
void main() {
  const key = 'dm_reply_draft:test:42';

  Future<void> pumpBar(
    WidgetTester tester, {
    required Future<bool> Function(String text) onSend,
    Future<bool> Function(TextEditingController controller)? onOpenFullEditor,
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
          child: ConversationQuickReplyBar(
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
}
