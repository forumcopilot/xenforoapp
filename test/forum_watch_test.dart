import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_watch_sheet.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Watching a forum: with add-on 1.11.0 the website's "Watch forum" choices,
/// before it the plain toggle the app had.

class _Subscriptions implements IFCSubscriptionProxy {
  _Subscriptions({this.refuse = false});
  final bool refuse;
  final calls = <String>[];

  @override
  Future<FCSubscribeForumResult> subscribeForumAsync(String forumId, int subscribeMode,
      {String? notifyOn, bool? sendAlert, bool? sendEmail}) async {
    calls.add('watch $forumId mode=$subscribeMode notifyOn=$notifyOn alert=$sendAlert email=$sendEmail');
    return refuse
        ? FCSubscribeForumResult(result: false, resultText: 'You may not watch this forum.')
        : FCSubscribeForumResult(result: true);
  }

  @override
  Future<FCUnsubscribeForumResult> unsubscribeForumAsync(String forumId) async {
    calls.add('unwatch $forumId');
    return FCUnsubscribeForumResult(result: true);
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

/// A button that runs ForumWatch.change and keeps its answer.
Future<List<bool?>> _pump(WidgetTester tester, FCForum forum, _Subscriptions subscriptions) async {
  final site = SiteContext(
    siteType: 'xenforo',
    site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'xenforo'),
    configDataOutput: FCConfigResult(),
  );
  SiteProxyService.initialize(site);
  SiteProxyFactory.register('xenforo', _Factory(subscriptions));
  final answers = <bool?>[];
  await tester.pumpWidget(MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () async => answers.add(await ForumWatch.change(context, forum)),
          child: const Text('go'),
        ),
      ),
    ),
  ));
  await tester.tap(find.text('go'));
  await tester.pumpAndSettle();
  return answers;
}

FCForum _forum({String? allowed = 'all', bool watched = false, String? notifyOn, bool? sendAlert, bool? sendEmail}) => FCForum(
      id: '4',
      name: 'Announcements',
      isSubscribed: watched,
      allowedWatchNotifications: allowed,
      notifyOn: notifyOn,
      sendAlert: sendAlert,
      sendEmail: sendEmail,
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets("watching asks as the website does, and saves the member's choices", (tester) async {
    final forum = _forum();
    final subscriptions = _Subscriptions();
    final answers = await _pump(tester, forum, subscriptions);

    expect(find.text('Announcements'), findsOneWidget);
    expect(find.text('Unwatch'), findsNothing, reason: 'not watched yet');
    await tester.tap(find.text('New messages'));
    await tester.tap(find.text('Emails'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Watch'));
    await tester.pumpAndSettle();

    expect(subscriptions.calls, ['watch 4 mode=1 notifyOn=message alert=true email=true']);
    expect(answers, [true]);
    expect((forum.isSubscribed, forum.notifyOn, forum.sendAlert, forum.sendEmail), (true, 'message', true, true));
  });

  testWidgets('a watched forum shows its options and can be unwatched', (tester) async {
    final forum = _forum(watched: true, notifyOn: 'message', sendAlert: false, sendEmail: true);
    final subscriptions = _Subscriptions();
    final answers = await _pump(tester, forum, subscriptions);

    final emails = tester.widget<SwitchListTile>(find.widgetWithText(SwitchListTile, 'Emails'));
    final alerts = tester.widget<SwitchListTile>(find.widgetWithText(SwitchListTile, 'Alerts'));
    expect((alerts.value, emails.value), (false, true));
    expect(find.widgetWithText(FilledButton, 'Save'), findsOneWidget);

    await tester.tap(find.text('Unwatch'));
    await tester.pumpAndSettle();
    expect(subscriptions.calls, ['unwatch 4']);
    expect(answers, [false]);
    expect((forum.isSubscribed, forum.notifyOn), (false, null));
  });

  testWidgets('a forum that only notifies of new threads offers only that', (tester) async {
    await _pump(tester, _forum(allowed: 'thread'), _Subscriptions());
    expect(find.text('New threads'), findsOneWidget);
    expect(find.text('New messages'), findsNothing);
  });

  testWidgets("a refusal shows the forum's reason and changes nothing", (tester) async {
    final forum = _forum();
    final answers = await _pump(tester, forum, _Subscriptions(refuse: true));
    await tester.tap(find.widgetWithText(FilledButton, 'Watch'));
    await tester.pumpAndSettle();
    expect(answers, [null]);
    expect(forum.isSubscribed, isFalse);
    expect(find.text('You may not watch this forum.'), findsOneWidget);
  });

  testWidgets('older add-ons keep the plain toggle', (tester) async {
    final forum = _forum(allowed: null);
    final subscriptions = _Subscriptions();
    final answers = await _pump(tester, forum, subscriptions);
    expect(find.byType(ForumWatchSheet), findsNothing);
    expect(subscriptions.calls, ['watch 4 mode=1 notifyOn=null alert=null email=null']);
    expect(answers, [true]);
    expect(forum.isSubscribed, isTrue);
  });
}
