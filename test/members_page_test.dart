import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/views/members_page.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A user proxy that answers the members screen like add-on 1.11.0+: the
/// online list, or the forum's refusal without "View member lists".
class _Users implements IFCUserProxy {
  _Users({this.online = const [], this.allowed = true});
  final List<FCOnlineUser> online;
  final bool allowed;
  final calls = <String>[];

  @override
  Future<FCOnlineUserResult> getOnlineUsersAsync(int page, int perpage, String? id, String? area) async {
    calls.add('getOnlineUsers');
    return allowed
        ? FCOnlineUserResult(result: true, total: online.length, list: List.of(online))
        : FCOnlineUserResult(result: false, resultText: 'Cannot view member list');
  }

  @override
  Future<FCSearchUserResult> searchUserAsync(String keywords, int page, int perpage) async {
    calls.add('searchUser');
    return FCSearchUserResult(result: true, total: 0, list: []);
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
      configDataOutput: FCConfigResult(guestWhosOnline: true),
    );

Future<_Users> _open(WidgetTester tester, _Users users) async {
  final site = _site();
  SiteProxyService.initialize(site);
  SiteProxyFactory.register('xenforo', _Factory(users));
  await tester.pumpWidget(MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MembersPage(siteContext: site),
  ));
  await tester.pumpAndSettle();
  return users;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('the screen opens on who is online, with the count and what each is doing', (tester) async {
    final users = await _open(
      tester,
      _Users(online: [
        FCOnlineUser(id: '2', username: 'EmilyMoore599', isOnline: true, currentActivity: 'Viewing thread Hello'),
        FCOnlineUser(id: '3', username: 'DavidThomas100', isOnline: true),
      ]),
    );

    expect(users.calls, ['getOnlineUsers'], reason: 'Online first; all members only when chosen');
    expect(find.text('2 members online'), findsOneWidget);
    expect(find.text('EmilyMoore599'), findsOneWidget);
    expect(find.text('Viewing thread Hello'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
  });

  testWidgets('a guest the forum keeps its lists from is told so and can log in', (tester) async {
    await _open(tester, _Users(allowed: false));

    expect(find.text("This forum's member lists aren't open to you"), findsOneWidget);
    expect(find.text("Log in to see who's online, if the forum shows it to members."), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Log in'), findsOneWidget);
    expect(find.text('No users online'), findsNothing, reason: 'a refusal used to read as an empty list');
  });
}
