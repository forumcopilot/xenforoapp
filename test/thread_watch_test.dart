import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/views/widgets/thread_watch_sheet.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Watching a thread: with add-on 1.11.0 the website's "Watch thread"
/// choices (emails or not, unwatch); before it the plain toggle.

class _Subscriptions implements IFCSubscriptionProxy {
  _Subscriptions({this.currentEmails = false, this.refuse = false});
  final bool currentEmails;
  final bool refuse;
  final calls = <String>[];

  @override
  Future<FCSubscribeTopicResult> subscribeTopicAsync(String topicId, int subscribeMode, {bool? emailSubscribe}) async {
    calls.add('watch $topicId mode=$subscribeMode email=$emailSubscribe');
    if (refuse) return FCSubscribeTopicResult(result: false, resultText: 'You may not watch this thread.');
    return FCSubscribeTopicResult(result: true, isSubscribed: true, emailSubscribe: emailSubscribe ?? currentEmails);
  }

  @override
  Future<FCUnsubscribeTopicResult> unsubscribeTopicAsync(String topicId) async {
    calls.add('unwatch $topicId');
    return FCUnsubscribeTopicResult(result: true);
  }

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Factory extends SiteProxyFactory {
  _Factory(this.subscriptions);
  final IFCSubscriptionProxy subscriptions;

  @override
  IFCSubscriptionProxy createSubscriptionProxy(SiteContext context) => subscriptions;
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

Future<List<ThreadWatchState?>> _pump(
  WidgetTester tester,
  _Subscriptions subscriptions, {
  required bool isWatched,
  bool hasOptions = true,
  bool? emailSubscribe,
}) async {
  final site = SiteContext(
    siteType: 'xenforo',
    site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'xenforo'),
    configDataOutput: FCConfigResult(),
  );
  SiteProxyService.initialize(site);
  SiteProxyFactory.register('xenforo', _Factory(subscriptions));
  final answers = <ThreadWatchState?>[];
  await tester.pumpWidget(MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () async => answers.add(await ThreadWatch.change(
            context,
            topicId: '7',
            title: 'Router keeps dropping',
            isWatched: isWatched,
            hasOptions: hasOptions,
            emailSubscribe: emailSubscribe,
          )),
          child: const Text('go'),
        ),
      ),
    ),
  ));
  await tester.tap(find.text('go'));
  await tester.pumpAndSettle();
  return answers;
}

bool _emailsSwitch(WidgetTester tester) => tester.widget<SwitchListTile>(find.widgetWithText(SwitchListTile, 'Emails')).value;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('watching asks as the website does: alerts, and emails only when chosen', (tester) async {
    final subscriptions = _Subscriptions();
    final answers = await _pump(tester, subscriptions, isWatched: false);

    expect(find.text('Router keeps dropping'), findsOneWidget);
    expect(find.text("You'll get an alert when someone replies."), findsOneWidget);
    expect(_emailsSwitch(tester), isFalse, reason: 'no emails unless chosen, as on the website');
    expect(find.text('Unwatch'), findsNothing);
    await tester.tap(find.text('Emails'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Watch'));
    await tester.pumpAndSettle();

    expect(subscriptions.calls, ['watch 7 mode=1 email=true']);
    expect(answers.single, (watched: true, emailSubscribe: true));
  });

  testWidgets('a watched thread shows how it is watched, asking the forum when unknown, and can be unwatched', (tester) async {
    final subscriptions = _Subscriptions(currentEmails: true);
    final answers = await _pump(tester, subscriptions, isWatched: true);

    expect(subscriptions.calls, ['watch 7 mode=0 email=null'], reason: 'reads the watch without changing it');
    expect(_emailsSwitch(tester), isTrue);
    await tester.tap(find.text('Unwatch'));
    await tester.pumpAndSettle();
    expect(subscriptions.calls.last, 'unwatch 7');
    expect(answers.single, (watched: false, emailSubscribe: null));
  });

  testWidgets('a known watch is shown as it is and saved with the change', (tester) async {
    final subscriptions = _Subscriptions();
    final answers = await _pump(tester, subscriptions, isWatched: true, emailSubscribe: false);

    expect(subscriptions.calls, isEmpty);
    expect(find.widgetWithText(FilledButton, 'Save'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    expect(subscriptions.calls, ['watch 7 mode=0 email=false']);
    expect(answers.single, (watched: true, emailSubscribe: false));
  });

  testWidgets("a refusal shows the forum's reason and changes nothing", (tester) async {
    final answers = await _pump(tester, _Subscriptions(refuse: true), isWatched: false);
    await tester.tap(find.widgetWithText(FilledButton, 'Watch'));
    await tester.pumpAndSettle();
    expect(answers.single, isNull);
    expect(find.text('You may not watch this thread.'), findsOneWidget);
  });

  testWidgets('older add-ons keep the plain toggle', (tester) async {
    final subscriptions = _Subscriptions();
    final answers = await _pump(tester, subscriptions, isWatched: false, hasOptions: false);
    expect(find.byType(ThreadWatchSheet), findsNothing);
    expect(subscriptions.calls, ['watch 7 mode=1 email=null']);
    expect(answers.single, (watched: true, emailSubscribe: null));
  });
}
