import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/widgets/thread_options_section.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';

/// A new thread's type, poll, custom fields and tags, as the website's
/// "Post thread" form has them (add-on 1.11.0+).

const _options = FCThreadPostingOptions(
  canTag: true,
  minTags: 2,
  canCreatePoll: true,
  threadTypes: [FCThreadTypeOption(type: 'discussion', title: 'Discussion'), FCThreadTypeOption(type: 'poll', title: 'Poll')],
  defaultThreadType: 'discussion',
  threadFields: [
    FCThreadField(id: 'os', title: 'OS', type: 'select', required: true, choices: [
      FCFieldChoice(value: 'ios', title: 'iOS'),
      FCFieldChoice(value: 'android', title: 'Android'),
    ]),
    FCThreadField(id: 'areas', title: 'Areas', type: 'checkbox', choices: [
      FCFieldChoice(value: 'ui', title: 'UI'),
      FCFieldChoice(value: 'sync', title: 'Sync'),
    ]),
    FCThreadField(id: 'steps', title: 'Steps', type: 'textarea', description: 'How to see it'),
  ],
);

Future<(ThreadOptionsController, AppLocalizations)> _pump(WidgetTester tester, FCThreadPostingOptions options) async {
  final controller = ThreadOptionsController(options);
  late AppLocalizations l10n;
  await tester.pumpWidget(MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Builder(builder: (context) {
        l10n = AppLocalizations.of(context);
        return SingleChildScrollView(child: ThreadOptionsSection(controller: controller));
      }),
    ),
  ));
  return (controller, l10n);
}

void main() {
  testWidgets("required fields and the forum's minimum of tags are asked for, then sent", (tester) async {
    final (c, l10n) = await _pump(tester, _options);
    expect(find.text('Thread type'), findsOneWidget);
    expect(find.text('OS *'), findsOneWidget);
    expect(find.text('How to see it'), findsOneWidget);
    expect(find.text('Add at least 2 tags'), findsOneWidget);

    expect(c.validate(l10n), 'Please fill in OS.');
    await tester.tap(find.text('OS *'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Android').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('UI'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Steps'), 'Open it');

    expect(c.validate(l10n), 'Add at least 2 tags');
    await tester.enterText(find.widgetWithText(TextField, 'Tags *'), 'crash, android,');
    await tester.pumpAndSettle();
    expect(find.widgetWithText(InputChip, 'crash'), findsOneWidget);
    expect(find.widgetWithText(InputChip, 'android'), findsOneWidget);

    expect(c.validate(l10n), isNull);
    expect(c.customFields, {'os': 'android', 'areas': ['ui'], 'steps': 'Open it'});
    expect(c.tags, ['crash', 'android']);
    expect((c.threadTypeToSend, c.poll), ('discussion', null));
  });

  testWidgets('a poll: question and two responses needed, and its options sent', (tester) async {
    final (c, l10n) = await _pump(tester, const FCThreadPostingOptions(
      canCreatePoll: true,
      threadTypes: [FCThreadTypeOption(type: 'discussion', title: 'Discussion'), FCThreadTypeOption(type: 'poll', title: 'Poll')],
    ));
    expect(find.text('Poll question'), findsNothing);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Poll'));
    await tester.pumpAndSettle();
    expect(find.text('Poll question'), findsOneWidget);
    expect(c.validate(l10n), 'Enter a poll question and at least two responses.');

    await tester.enterText(find.widgetWithText(TextField, 'Poll question'), 'Seen it?');
    await tester.enterText(find.widgetWithText(TextField, 'Response 1'), 'Yes');
    await tester.enterText(find.widgetWithText(TextField, 'Response 2'), 'No');
    await tester.tap(find.text('Add response'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Response 3'), 'Not sure');
    await tester.tap(find.text('Voters may choose more than one response'));
    await tester.pumpAndSettle();

    expect(c.validate(l10n), isNull);
    final poll = c.poll!;
    expect((c.threadTypeToSend, poll.question, poll.maxVotes, poll.viewResultsUnvoted, poll.closeDays), ('poll', 'Seen it?', 0, true, 0));
    expect(poll.responses, ['Yes', 'No', 'Not sure']);
  });

  testWidgets('a forum that takes nothing extra shows nothing and sends no type', (tester) async {
    final (c, l10n) = await _pump(tester, const FCThreadPostingOptions());
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(ChoiceChip), findsNothing);
    expect(c.validate(l10n), isNull);
    expect(c.threadTypeToSend, isNull);
    expect(c.customFields, isEmpty);
    expect(c.tags, isEmpty);
  });
}
