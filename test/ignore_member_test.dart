import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/views/ignored_members_page.dart';
import 'package:forumcopilot_flutter/views/widgets/ignored_content_gate.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A user proxy that answers the ignore calls (XenForo add-on 1.11.0+).
class _Users implements IFCUserProxy {
  _Users(this.ignored);
  final List<FCIgnoredUser> ignored;
  final List<String> calls = [];

  @override
  Future<FCIgnoredUserResult> getIgnoredUsersAsync(int page, int perpage) async =>
      FCIgnoredUserResult(result: true, total: ignored.length, list: List.of(ignored));

  @override
  Future<FCIgnoreUserResult> ignoreUserAsync(String userId, int mode) async {
    calls.add('${mode == 0 ? 'unignore' : 'ignore'}:$userId');
    if (mode == 0) ignored.removeWhere((m) => m.id == userId);
    return FCIgnoreUserResult(result: true);
  }

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Factory extends SiteProxyFactory {
  _Factory(this.users);
  final IFCUserProxy users;

  @override
  IFCUserProxy createUserProxy(SiteContext context) => users;
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

SiteContext _site() => SiteContext(
      siteType: 'xenforo',
      site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'xenforo'),
      configDataOutput: FCConfigResult(ignoreUser: true),
    );

Widget _app(Widget home) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('IgnoredContentGate', () {
    testWidgets('content by an ignored member is one line until Show', (tester) async {
      await tester.pumpWidget(_app(const Scaffold(
        body: IgnoredContentGate(isIgnored: true, authorName: 'Jessica', child: Text('the message')),
      )));
      expect(find.text('the message'), findsNothing);
      expect(find.text('You are ignoring Jessica.'), findsOneWidget);

      await tester.tap(find.text('Show'));
      await tester.pump();
      expect(find.text('the message'), findsOneWidget);
      expect(find.text('You are ignoring Jessica.'), findsNothing);
    });

    testWidgets('content by anyone else shows as it is', (tester) async {
      await tester.pumpWidget(_app(const Scaffold(
        body: IgnoredContentGate(isIgnored: false, authorName: 'Jessica', child: Text('the message')),
      )));
      expect(find.text('the message'), findsOneWidget);
      expect(find.text('Show'), findsNothing);
    });
  });

  group('Ignored members page', () {
    testWidgets('lists the ignored members and stops ignoring one', (tester) async {
      final users = _Users([
        FCIgnoredUser(id: '3', username: 'JessicaTaylor110', isIgnored: true),
        FCIgnoredUser(id: '4', username: 'ThomasLee426', isIgnored: true),
      ]);
      final site = _site();
      SiteProxyService.initialize(site);
      SiteProxyFactory.register('xenforo', _Factory(users));
      await tester.pumpWidget(_app(IgnoredMembersPage(siteContext: site)));
      await tester.pumpAndSettle();

      expect(find.text('Ignored members'), findsOneWidget);
      expect(find.text('JessicaTaylor110'), findsOneWidget);
      expect(find.text('ThomasLee426'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'Stop ignoring').first);
      await tester.pumpAndSettle();
      expect(users.calls, ['unignore:3']);
      expect(find.text('JessicaTaylor110'), findsNothing, reason: 'removed from the list');
      expect(find.text('ThomasLee426'), findsOneWidget);
      expect(find.text('You are no longer ignoring JessicaTaylor110.'), findsOneWidget);
    });

    testWidgets('says so when nobody is ignored', (tester) async {
      final site = _site();
      SiteProxyService.initialize(site);
      SiteProxyFactory.register('xenforo', _Factory(_Users([])));
      await tester.pumpWidget(_app(IgnoredMembersPage(siteContext: site)));
      await tester.pumpAndSettle();
      expect(find.text("You aren't ignoring anyone."), findsOneWidget);
    });
  });
}
