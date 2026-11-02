import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/controllers/global_loader_controller.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/browser_login.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/views/forgot_password_page.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An account proxy that answers forgotPassword like add-on 1.11.0+: a
/// forum that shows guests a captcha on its lost-password page sends that
/// page instead of an email.
class _Account implements IFCAccountProxy {
  _Account(this.reply);
  final FCForgetPasswordResult reply;

  @override
  Future<FCForgetPasswordResult> forgetPassword(String username, String token, String code) async => reply;

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Factory extends SiteProxyFactory {
  _Factory(this.account);
  final IFCAccountProxy account;

  @override
  IFCAccountProxy createAccountProxy(SiteContext context) => account;
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

SiteContext _site() => SiteContext(
      siteType: 'xenforo',
      site: Site(id: 1, name: 'T', url: 'https://example.com', description: '', endpoint: 'forumcopilot.php', baseUrl: 'https://example.com', siteType: 'xenforo'),
      configDataOutput: FCConfigResult(),
    );

Widget _app(Widget home) => GetMaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );

Future<void> _send(WidgetTester tester, FCForgetPasswordResult reply) async {
  final site = _site();
  SiteProxyService.initialize(site);
  Get.put(GlobalLoaderController()); // the page's forum header starts SiteController
  SiteProxyFactory.register('xenforo', _Factory(_Account(reply)));
  await tester.pumpWidget(_app(ForgotPasswordPage(siteContext: site)));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextFormField), 'dan');
  await tester.tap(find.widgetWithText(FilledButton, 'Send Reset Link'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(Get.reset);

  testWidgets("a forum that resets on its website offers that page, not a failure", (tester) async {
    await _send(
      tester,
      FCForgetPasswordResult(
        result: false,
        resultText: "Please reset your password on the forum's website.",
        resetViaWebUrl: 'https://example.com/lost-password/',
      ),
    );

    expect(find.text("Please reset your password on the forum's website."), findsOneWidget);
    expect(find.text('Reset Failed'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Open Website'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets("Open Website opens the forum's page in the browser sheet, like its other pages", (tester) async {
    final opened = <String>[];
    BrowserLogin.debugHasSystemSheet = true;
    addTearDown(() => BrowserLogin.debugHasSystemSheet = null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_web_auth_2'), (call) async {
      opened.add((call.arguments as Map)['url'] as String);
      throw PlatformException(code: 'CANCELED'); // the member closes it
    });

    await _send(
      tester,
      FCForgetPasswordResult(
        result: false,
        resultText: "Please reset your password on the forum's website.",
        resetViaWebUrl: 'https://example.com/lost-password/',
      ),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Open Website'));
    await tester.pumpAndSettle();

    expect(opened, ['https://example.com/lost-password/']);
  });

  testWidgets('any other refusal still reads as a failure with OK', (tester) async {
    await _send(tester, FCForgetPasswordResult(result: false, resultText: 'The requested member could not be found.'));

    expect(find.text('Reset Failed'), findsOneWidget);
    expect(find.text('The requested member could not be found.'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'OK'), findsOneWidget);
    expect(find.text('Open Website'), findsNothing);
  });
}
