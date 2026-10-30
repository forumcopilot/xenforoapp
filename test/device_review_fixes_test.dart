import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/utils/time_utils.dart';
import 'package:forumcopilot_flutter/views/members_page.dart';
import 'package:forumcopilot_flutter/views/search_page.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// What a review of every screen on a Pixel 4a found, as checks.

class _Search implements IFCSearchProxy {
  final calls = <String>[];

  @override
  Future<FCSearchTopicResult> searchTopicAsync(String q, int s, int l, String? id) async {
    calls.add('topics');
    return FCSearchTopicResult(result: true, totalTopicNum: 0, topics: const []);
  }

  @override
  Future<FCSearchPostResult> searchPostAsync(String q, int s, int l, String? id) async {
    calls.add('posts');
    return FCSearchPostResult(result: true, totalPostNum: 0, posts: const []);
  }

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Users implements IFCUserProxy {
  _Users(this.answer);
  final FCSearchUserResult Function(String keywords) answer;

  @override
  Future<FCSearchUserResult> searchUserAsync(String keywords, int page, int perpage) async => answer(keywords);

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Factory extends SiteProxyFactory {
  _Factory({this.search, this.users});
  final IFCSearchProxy? search;
  final IFCUserProxy? users;

  @override
  IFCSearchProxy createSearchProxy(SiteContext context) => search!;
  @override
  IFCUserProxy createUserProxy(SiteContext context) => users!;
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

SiteContext _site() => SiteContext(
      siteType: 'xenforo',
      site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'xenforo'),
      configDataOutput: FCConfigResult(),
    );

Widget _app(Widget home) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('a date in the past week is its weekday and time, not "4 days ago 11:17 PM"', (tester) async {
    late String text;
    final fourDaysAgo = DateTime.now().subtract(const Duration(days: 4));
    await tester.pumpWidget(_app(Builder(builder: (context) {
      text = formatSmartDateTime(fourDaysAgo.toUtc(), context);
      return const SizedBox();
    })));
    expect(text, isNot(contains('ago')));
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    expect(text, startsWith('${weekdays[fourDaysAgo.weekday - 1]}, '));
  });

  group('Search', () {
    testWidgets('opens ready to type, and runs only the search on show', (tester) async {
      final search = _Search();
      final site = _site();
      SiteProxyService.initialize(site);
      SiteProxyFactory.register('xenforo', _Factory(search: search));
      await tester.pumpWidget(_app(SearchPage(siteContext: site)));
      await tester.pumpAndSettle();
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.focusNode?.hasFocus, isTrue);

      await tester.enterText(find.byType(TextField), 'installation');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(search.calls, ['posts'], reason: 'one search, the one shown (Posts)');
      expect(find.text('Posts'), findsOneWidget);

      await tester.tap(find.text('Threads only'));
      await tester.pumpAndSettle();
      expect(search.calls, ['posts', 'topics']);
      // Back to Posts: already run for this query.
      await tester.tap(find.text('Posts'));
      await tester.pumpAndSettle();
      expect(search.calls, ['posts', 'topics']);
    });
  });

  group('Members', () {
    Future<void> open(WidgetTester tester, FCSearchUserResult Function(String) answer) async {
      final site = _site();
      SiteProxyService.initialize(site);
      SiteProxyFactory.register('xenforo', _Factory(users: _Users(answer)));
      await tester.pumpWidget(_app(MembersPage(siteContext: site)));
      await tester.pumpAndSettle();
    }

    testWidgets('a forum that keeps its member list hidden: a search prompt, not "No members found"', (tester) async {
      await open(tester, (_) => FCSearchUserResult(result: false, resultText: 'Member list is not available', total: 0, list: const []));
      expect(find.text('No members found'), findsNothing);
      expect(find.text('Search for members'), findsOneWidget);
    });

    testWidgets('a refused search says why', (tester) async {
      await open(
        tester,
        (q) => q.isEmpty
            ? FCSearchUserResult(result: false, resultText: 'Member list is not available', total: 0, list: const [])
            : FCSearchUserResult(result: false, resultText: 'Search keywords must be at least 2 characters', total: 0, list: const []),
      );
      await tester.enterText(find.byType(TextField), 'a');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text('Search keywords must be at least 2 characters'), findsOneWidget);
    });
  });
}
