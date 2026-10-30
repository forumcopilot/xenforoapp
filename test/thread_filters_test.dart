import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/views/lists/forum_topic_list.dart';
import 'package:forumcopilot_flutter/views/widgets/thread_filters_sheet.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Sorting and filtering a forum's threads as the website's filter menu
/// does (add-on 1.11.0+); older add-ons get no Filters button.

class _Topics implements IFCTopicProxy {
  _Topics({this.canFilter = true, this.empty = false});
  final bool canFilter;
  final bool empty;
  final requests = <FCTopicFilters?>[];
  var stickyLoads = 0;

  FCTopic _topic(String id, String title) =>
      FCTopic(id: id, title: title, forumId: '9', forumName: 'Bugs', authorId: '1', authorName: 'Ann', timestamp: DateTime.utc(2026, 10, 1), shortContent: '');

  @override
  Future<FCTopicDataResult> getTopicAsync(String forumId, int startNum, int lastNum, {FCTopicFilters? filters}) async {
    requests.add(filters);
    return FCTopicDataResult(
      result: true,
      resultText: '',
      totalTopicNum: 1,
      topics: empty && (filters?.filters ?? false) ? [] : [_topic('1', 'Crash on start')],
      prefixes: [FCPrefix(prefixId: '2', prefixDisplayName: 'Closed', group: 'Status')],
      sortOptions: canFilter
          ? const [FCSortOption(key: 'last_post_date', title: 'Last message'), FCSortOption(key: 'title', title: 'Title')]
          : null,
      defaultOrder: canFilter ? 'last_post_date' : null,
      defaultDirection: canFilter ? 'desc' : null,
      dateLimitOptions: canFilter ? const [-1, 7, 30, 60, 365] : null,
      dateLimitDays: canFilter ? 0 : null,
      appliedFilters: canFilter
          ? {
              ...(filters?.toParams() ?? {})..remove('starterName'),
              if (filters?.starterName != null && filters!.starterName != 'ghost') 'starterName': filters.starterName,
              'order': filters?.order ?? 'last_post_date',
              'direction': filters?.direction ?? 'desc',
            }
          : null,
    );
  }

  @override
  Future<FCTopicDataResult> getTopTopicAsync(String forumId, int startNum, int lastNum) async {
    stickyLoads++;
    return FCTopicDataResult(result: true, resultText: '', totalTopicNum: 0);
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

Future<void> _pump(WidgetTester tester, _Topics topics) async {
  final site = SiteContext(
    siteType: 'xenforo',
    site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'xenforo'),
    configDataOutput: FCConfigResult(),
  );
  SiteProxyService.initialize(site);
  SiteProxyFactory.register('xenforo', _Factory(topics));
  await tester.pumpWidget(GetMaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: ForumTopicList(siteContext: site, forum: FCForum(id: '9', name: 'Bugs'))),
  ));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(Get.reset);

  testWidgets("filters as the website's menu: the choices are sent, shown as chips, and each can be removed", (tester) async {
    final topics = _Topics();
    await _pump(tester, topics);
    expect(topics.requests.single, isNull, reason: 'the first page as before');
    expect(topics.stickyLoads, 1);

    await tester.tap(find.text('Filters'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('(Any)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Status · Closed').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Last message'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Title').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ascending'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Filter'));
    await tester.pumpAndSettle();

    final sent = topics.requests.last!;
    expect((sent.prefixId, sent.order, sent.direction, sent.starterName, sent.lastDays), (2, 'title', 'asc', null, null));
    expect(topics.stickyLoads, 1, reason: 'sticky threads come unfiltered: left out while filtering');
    expect(find.text('Prefix: Closed'), findsOneWidget);
    expect(find.text('Sort by: Title ↑'), findsOneWidget);

    await tester.tap(find.descendant(of: find.widgetWithText(InputChip, 'Prefix: Closed'), matching: find.byTooltip('Clear filters')));
    await tester.pumpAndSettle();
    final after = topics.requests.last!;
    expect((after.prefixId, after.order), (null, 'title'));
    expect(find.text('Prefix: Closed'), findsNothing);
    expect(topics.stickyLoads, 2, reason: 'only sorted: sticky threads are back');
  });

  testWidgets('nothing matches: says so, and Clear filters brings the list back', (tester) async {
    final topics = _Topics(empty: true);
    await _pump(tester, topics);
    await tester.tap(find.text('Filters'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Started by'), 'nobody');
    await tester.tap(find.widgetWithText(FilledButton, 'Filter'));
    await tester.pumpAndSettle();

    expect(topics.requests.last!.starterName, 'nobody');
    expect(find.text('No threads match these filters.'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Clear filters'));
    await tester.pumpAndSettle();
    expect(topics.requests.last, isNull);
    expect(find.text('Crash on start'), findsOneWidget);
  });

  testWidgets("a filter the forum ignored (an unknown member) isn't shown as set", (tester) async {
    final topics = _Topics();
    await _pump(tester, topics);
    await tester.tap(find.text('Filters'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Started by'), 'ghost');
    await tester.tap(find.widgetWithText(FilledButton, 'Filter'));
    await tester.pumpAndSettle();
    expect(topics.requests.last!.starterName, 'ghost');
    expect(find.text('Started by: ghost'), findsNothing);
    expect(find.text('Crash on start'), findsOneWidget);
  });

  testWidgets('older add-ons: no Filters button', (tester) async {
    await _pump(tester, _Topics(canFilter: false));
    expect(find.text('Crash on start'), findsOneWidget);
    expect(find.text('Filters'), findsNothing);
  });

  testWidgets("periods are named as XenForo's Last updated menu names them", (tester) async {
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: (context) {
        final l10n = AppLocalizations.of(context);
        return Text([-1, 7, 30, 60, 90, 182, 365].map((d) => threadPeriodLabel(l10n, d)).join(', '));
      }),
    ));
    expect(find.text('Any time, 7 days, 30 days, 2 months, 3 months, 6 months, 1 year'), findsOneWidget);
  });
}
