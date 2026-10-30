import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/views/appbars/notifications_tab_app_bar.dart';
import 'package:forumcopilot_flutter/views/tabs/notification_list_tab.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Alerts read state (XenForo add-on 1.11.0+): opening an alert reads it,
/// and the Alerts bar offers "Mark all read" while one is unread.

/// Answers getAlert with [alerts] and records each call's options.
class _Social implements IFCSocialProxy {
  _Social(this.alerts);
  final List<FCAlert> Function() alerts;
  final calls = <({List<int>? markReadIds, bool markAllRead, bool skipMarkRead})>[];

  @override
  Future<FCAlertResult> getAlertAsync(int page, int perpage, bool forceRefresh,
      {List<int>? markReadIds, bool markAllRead = false, bool skipMarkRead = false}) async {
    calls.add((markReadIds: markReadIds, markAllRead: markAllRead, skipMarkRead: skipMarkRead));
    final items = alerts();
    if (markAllRead) {
      for (final a in items) {
        if (a.isUnread != null) a.isUnread = false;
      }
    }
    return FCAlertResult(result: true, total: items.length, items: items, hasMore: false);
  }

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Factory extends SiteProxyFactory {
  _Factory(this.social);
  final IFCSocialProxy social;

  @override
  IFCSocialProxy createSocialProxy(SiteContext context) => social;
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

SiteContext _signedIn() => SiteContext(
      siteType: 'xenforo',
      site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'xenforo'),
      configDataOutput: FCConfigResult(),
      loginDataOutput: FCLoginResult(result: true, resultText: '', user: FCUser(id: '2', username: 'alice')),
    )..initializeAuth();

/// An alert the app has no page for: a tap only shows a note.
FCAlert _alert(int id, String message, {bool? isUnread, bool isRead = true}) => FCAlert(
      userId: '3',
      username: 'bob',
      iconUrl: '',
      message: message,
      timestamp: '1760000000000',
      contentType: 'trophy',
      contentId: '$id',
      isRead: isRead,
      isUnread: isUnread,
      alertId: id,
    );

Future<ValueNotifier<bool>> _pump(WidgetTester tester, _Social social) async {
  final site = _signedIn();
  SiteProxyService.initialize(site);
  SiteProxyFactory.register('xenforo', _Factory(social));
  final unread = ValueNotifier(false);
  final tab = GlobalKey<NotificationListTabState>();
  await tester.pumpWidget(MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      appBar: NotificationsTabAppBar(
        siteContext: site,
        isLoggedIn: true,
        hasUnreadAlerts: unread,
        onMarkAllRead: () => tab.currentState?.markAllRead(),
      ),
      body: NotificationListTab(key: tab, isActive: true, siteContext: site, hasUnreadAlerts: unread),
    ),
  ));
  await tester.pumpAndSettle();
  return unread;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('opening an unread alert reads it on the forum', (tester) async {
    final alerts = [_alert(9, 'You got a trophy', isUnread: true), _alert(8, 'An older one', isUnread: false)];
    final social = _Social(() => alerts);
    final unread = await _pump(tester, social);

    expect(unread.value, isTrue);
    expect(find.byTooltip('Mark all read'), findsOneWidget);

    await tester.tap(find.text('You got a trophy'));
    await tester.pumpAndSettle();

    expect(social.calls.last.markReadIds, [9]);
    expect((social.calls.last.markAllRead, social.calls.last.skipMarkRead), (false, true));
    expect(alerts.first.isUnread, isFalse);
    expect(unread.value, isFalse, reason: 'nothing unread is left');
    expect(find.byTooltip('Mark all read'), findsNothing);

    // An alert that is already read sends nothing more.
    final before = social.calls.length;
    await tester.tap(find.text('An older one'));
    await tester.pumpAndSettle();
    expect(social.calls.length, before);
  });

  testWidgets('Mark all read marks them on the forum and lists them again', (tester) async {
    final alerts = [_alert(9, 'One', isUnread: true), _alert(8, 'Two', isUnread: true)];
    final social = _Social(() => alerts);
    final unread = await _pump(tester, social);

    await tester.tap(find.byTooltip('Mark all read'));
    await tester.pumpAndSettle();

    expect(social.calls.last.markAllRead, isTrue);
    expect(unread.value, isFalse);
    expect(find.byTooltip('Mark all read'), findsNothing);
  });

  testWidgets('older add-ons send no read state: no button, and a tap marks nothing', (tester) async {
    final social = _Social(() => [_alert(9, 'Not seen yet', isRead: false)]);
    final unread = await _pump(tester, social);

    expect(unread.value, isFalse);
    expect(find.byTooltip('Mark all read'), findsNothing);
    await tester.tap(find.text('Not seen yet'));
    await tester.pumpAndSettle();
    expect(social.calls.length, 1, reason: 'only the list was loaded');
  });
}
