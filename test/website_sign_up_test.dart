import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/controllers/global_loader_controller.dart';
import 'package:forumcopilot_flutter/controllers/site_controller.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/services/browser_login.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/services/website_sign_up.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Register opens the forum's own register page in the browser sheet; the
/// app has no sign-up form of its own.

/// Says whether the forum's registration is open, as the add-on does.
class _Account implements IFCAccountProxy {
  bool registrationOpen = true;

  @override
  Future<FCPrefetchAccountResult?> prefetchAccount() async =>
      FCPrefetchAccountResult(result: true, registrationOpen: registrationOpen);

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _User implements IFCUserProxy, IFCBrowserLogin {
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Factory extends SiteProxyFactory {
  _Factory(this.account);
  final _Account account;

  @override
  IFCAccountProxy createAccountProxy(SiteContext context) => account;
  @override
  IFCUserProxy createUserProxy(SiteContext context) => _User();
  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

const _site = Site(
    id: 1,
    name: 'T',
    url: 'https://example.com',
    description: '',
    endpoint: 'forumcopilot.php',
    baseUrl: 'https://example.com',
    siteType: 'xenforo');

/// A forum whose add-on offers website sign-in to this app, or ([website]
/// false) one that doesn't list the app's scheme.
SiteContext _forum({bool website = true}) => SiteContext(
      siteType: 'xenforo',
      site: _site,
      configDataOutput: FCConfigResult(browserLoginSchemes: website ? const [BrowserLogin.scheme] : null),
    );

void main() {
  late _Account account;
  late List<String> opened;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    BrowserLogin.debugHasSystemSheet = true;
    account = _Account();
    opened = <String>[];
    // The member closes every page the sheet opens.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_web_auth_2'), (call) async {
      if (call.method != 'authenticate') return null;
      opened.add((call.arguments as Map)['url'] as String);
      throw PlatformException(code: 'CANCELED');
    });
  });

  tearDown(() {
    BrowserLogin.debugHasSystemSheet = null;
    Get.reset();
  });

  /// The app with one Register button for [forum].
  Future<void> pumpApp(WidgetTester tester, SiteContext forum) async {
    SiteProxyService.initialize(forum);
    SiteProxyFactory.register('xenforo', _Factory(account));
    Get.put(GlobalLoaderController());
    Get.put(SiteController()).currentSite.value = _site;
    await tester.pumpWidget(GetMaterialApp(
      navigatorKey: globalNavigatorKey,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(onPressed: () => WebsiteSignUp.start(context, forum), child: const Text('Register')),
        ),
      ),
    ));
  }

  testWidgets('registration closed: the forum says so, and nothing opens', (tester) async {
    account.registrationOpen = false;
    await pumpApp(tester, _forum());

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Registration Not Available'), findsOneWidget);
    expect(opened, isEmpty);
  });

  testWidgets("website forum: the register page, then Continue opens the forum's sign-in page", (tester) async {
    await pumpApp(tester, _forum());

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    final register = Uri.parse(opened.single);
    expect(register.query, startsWith('register/&'));
    final then = Uri.splitQueryString(register.query.substring('register/&'.length))['_xfRedirect'];
    expect(then, startsWith('https://example.com/index.php?forumcopilot-app-login/&'));

    // Closed after signing up on the website.
    expect(find.text('Created your account?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pumpAndSettle();

    expect(opened, hasLength(2));
    expect(opened.last, startsWith('https://example.com/index.php?forumcopilot-app-login/&'));
    expect(find.byType(LoginPage), findsNothing);
  });

  testWidgets("website forum: Not now closes it, with no sign-in", (tester) async {
    await pumpApp(tester, _forum());

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Not now'));
    await tester.pumpAndSettle();

    expect(opened, hasLength(1));
    expect(find.text('Created your account?'), findsNothing);
  });

  testWidgets("a forum that doesn't list the app: the register page alone, then the app's own form",
      (tester) async {
    await pumpApp(tester, _forum(website: false));

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(opened, ['https://example.com/index.php?register/']);
    expect(find.text('Log in with the user name and password you just chose.'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Log in'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(opened, hasLength(1));
  });
}
