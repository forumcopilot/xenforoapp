import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/views/tabs/topic_list_tab.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Home's topic chips (Latest, Unread, …). Going back to a chip already
/// shown left it a spinner for good, on an iPhone 17 with 1.0.0 (56).
class _Topics implements IFCTopicProxy {
  final calls = <String>[];

  FCTopic _topic(String title) => FCTopic(
        id: title,
        title: title,
        forumId: '1',
        forumName: 'Lobby',
        authorId: '1',
        authorName: 'Ann',
        timestamp: DateTime.utc(2026, 10, 19),
        shortContent: 'The first post.',
      );

  @override
  Future<FCLatestTopicResult> getLatestTopicAsync(int s, int l, {String? searchId, List<String>? filters}) async {
    calls.add('latest');
    return FCLatestTopicResult(result: true, totalLatestNum: 1, topics: [_topic('A latest topic')]);
  }

  @override
  Future<FCUnreadTopicResult> getUnreadTopicAsync(int s, int l, {String? searchId, List<String>? filters}) async {
    calls.add('unread');
    return FCUnreadTopicResult(result: true, totalUnreadNum: 1, topics: [_topic('An unread topic')]);
  }

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Factory extends SiteProxyFactory {
  _Factory(this.topics);
  final IFCTopicProxy topics;

  @override
  IFCTopicProxy createTopicProxy(SiteContext context) => topics;
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(Get.reset);

  Future<_Topics> openHome(WidgetTester tester) async {
    final topics = _Topics();
    final site = SiteContext(
      siteType: 'xenforo',
      site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'xenforo'),
      configDataOutput: FCConfigResult(),
    )..updateLoginStateFromHeader(true);
    SiteProxyService.initialize(site);
    SiteProxyFactory.register('xenforo', _Factory(topics));
    await tester.pumpWidget(GetMaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: TopicListTab(siteContext: site, isActive: true)),
    ));
    await tester.pumpAndSettle();
    return topics;
  }

  Future<void> chip(WidgetTester tester, String label) async {
    await tester.tap(find.widgetWithText(FilterChip, label));
    await tester.pumpAndSettle();
  }

  testWidgets('back on Latest, its topics load again instead of a spinner', (tester) async {
    final topics = await openHome(tester);
    expect(find.text('A latest topic'), findsOneWidget);

    await chip(tester, 'Unread');
    expect(find.text('An unread topic'), findsOneWidget);

    await chip(tester, 'Latest');
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('A latest topic'), findsOneWidget);
    expect(topics.calls, ['latest', 'unread', 'latest'], reason: 'the list is loaded afresh');
  });

  testWidgets('back on Unread too', (tester) async {
    final topics = await openHome(tester);
    await chip(tester, 'Unread');
    await chip(tester, 'Latest');
    await chip(tester, 'Unread');
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('An unread topic'), findsOneWidget);
    expect(topics.calls, ['latest', 'unread', 'latest', 'unread']);
  });
}
