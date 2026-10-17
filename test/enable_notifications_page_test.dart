import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/notification_permission.dart';
import 'package:forumcopilot_flutter/views/enable_notifications_page.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notification permission is asked after sign-in, once, with a page that
/// shows what arrives; a refusal shows the way to the system settings.
void main() {
  final site = Site(name: 'Test Forum', url: 'https://forum.test', description: '', siteType: 'xenforo');

  Widget app(Widget home) => MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: home,
      );

  tearDown(() => NotificationPermission.debugStatus = null);

  testWidgets('not asked yet: shows samples and Turn on notifications', (tester) async {
    NotificationPermission.debugStatus = NotificationPermissionState.notDetermined;
    await tester.pumpWidget(app(EnableNotificationsPage(siteContext: SiteContext(siteType: 'xenforo', site: site))));
    await tester.pumpAndSettle();
    expect(find.text('Never miss a reply on Test Forum'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Turn on notifications'), findsOneWidget);
    expect(find.text('Notifications are turned off for this app'), findsNothing);
  });

  testWidgets('refused: says notifications are off and offers Settings', (tester) async {
    NotificationPermission.debugStatus = NotificationPermissionState.denied;
    await tester.pumpWidget(app(EnableNotificationsPage(siteContext: SiteContext(siteType: 'xenforo', site: site))));
    await tester.pumpAndSettle();
    expect(find.text('Notifications are turned off for this app'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Turn on notifications'), findsNothing);
    expect(find.text('Not now'), findsOneWidget);
  });

  testWidgets('a guest, or permission already decided, is never asked', (tester) async {
    SharedPreferences.setMockInitialValues({});
    NotificationPermission.debugStatus = NotificationPermissionState.granted;
    late BuildContext context;
    await tester.pumpWidget(app(Builder(builder: (c) {
      context = c;
      return const Scaffold(body: Text('Home'));
    })));
    final guest = SiteContext(siteType: 'xenforo', site: site);
    await EnableNotificationsPage.maybeShow(context, guest);
    await tester.pumpAndSettle();
    expect(find.byType(EnableNotificationsPage), findsNothing);
  });
}
