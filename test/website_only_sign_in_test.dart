import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/controllers/global_loader_controller.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/controllers/site_controller.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/models/site_visit_history.dart';
import 'package:forumcopilot_flutter/services/browser_login.dart';
import 'package:forumcopilot_flutter/services/sign_in.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/views/dialogs/tfa_input_dialog.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_browser_login.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// On a forum that offers website sign-in, every way in goes to the forum's
/// website, in the browser sheet: no sign-in page of the app's, no password
/// form, no two-step screen. Older add-ons keep the app's own form.

/// A user proxy that redeems the website's code and answers password
/// sign-ins with [passwordReply].
class _User implements IFCUserProxy, IFCBrowserLogin {
  FCLoginResult? passwordReply;
  final passwordSignIns = <String>[];

  @override
  Future<FCLoginResult> completeBrowserLoginAsync({required String code, required String verifier}) async =>
      FCLoginResult(result: true, resultText: '', user: FCUser(id: '7', username: 'dan'));

  @override
  Future<FCLoginResult> loginAsync(String loginname, String password, bool anonymous, String? trustCode,
      {bool remember = true,
      String? tfaCode,
      String? tfaProvider,
      String? webauthnChallenge,
      Map<String, String>? webauthnPayload,
      bool trustDevice = false}) async {
    passwordSignIns.add(loginname);
    return passwordReply!;
  }

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError('${i.memberName}');
}

class _Factory extends SiteProxyFactory {
  _Factory(this.user);
  final _User user;

  @override
  IFCUserProxy createUserProxy(SiteContext context) => user;
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

/// A forum whose add-on offers website sign-in to this app (its admin listed
/// AppForumConfig.browserLoginScheme), or ([website] false) one from before
/// add-on 1.9.0 or that doesn't list the scheme.
SiteContext _forum({bool website = true}) => SiteContext(
      siteType: 'xenforo',
      site: _site,
      configDataOutput: FCConfigResult(browserLoginSchemes: website ? const [BrowserLogin.scheme] : null),
    );

/// The browser sheet (flutter_web_auth_2): what was opened, and its answer.
class _Sheet {
  final opened = <String>[];

  /// The sheet's answer to [url]: the page's hand-back, or a
  /// PlatformException (CANCELED: closed by the member).
  FutureOr<String> Function(String url) answer = (_) => throw PlatformException(code: 'CANCELED');

  void install() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_web_auth_2'), (call) async {
      if (call.method != 'authenticate') return null;
      final url = (call.arguments as Map)['url'] as String;
      opened.add(url);
      return answer(url);
    });
  }

  /// The forum's sign-in page hands a code back for the request in [url].
  static String handBack(String url) {
    final query = Uri.parse(url).query;
    final state = Uri.splitQueryString(query.substring(query.indexOf('&') + 1))['state'];
    return '${BrowserLogin.scheme}://app-login?code=one-time&state=$state';
  }
}

void main() {
  late _User user;
  late _Sheet sheet;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    BrowserLogin.debugHasSystemSheet = true;
    user = _User();
    sheet = _Sheet()..install();
  });

  tearDown(() async {
    BrowserLogin.debugHasSystemSheet = null;
    await SiteVisitTracker.instance.removeCredentials(_site);
    Get.reset();
  });

  /// The app with one button that signs in to [forum]; its result lands in
  /// [results].
  Future<void> pumpApp(WidgetTester tester, SiteContext forum, List<bool> results) async {
    SiteProxyService.initialize(forum);
    SiteProxyFactory.register('xenforo', _Factory(user));
    Get.put(GlobalLoaderController());
    Get.put(SiteController()).currentSite.value = _site;
    await tester.pumpWidget(GetMaterialApp(
      navigatorKey: globalNavigatorKey,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(onPressed: () async => results.add(await SignIn.start(forum)), child: const Text('Sign in')),
        ),
      ),
    ));
  }

  group('a forum that offers website sign-in', () {
    testWidgets('Sign in opens the forum\'s sign-in page in the sheet, with no page of the app\'s', (tester) async {
      final results = <bool>[];
      await pumpApp(tester, _forum(), results);

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(sheet.opened, hasLength(1));
      expect(sheet.opened.single, startsWith('https://example.com/index.php?forumcopilot-app-login/&'));
      // Closed without signing in: back where they were.
      expect(results, [false]);
      expect(find.byType(LoginPage), findsNothing);
      expect(find.byType(TextFormField), findsNothing);
    });

    testWidgets('signed in on the website: no page, and a password saved in the app is forgotten', (tester) async {
      await SiteVisitTracker.instance.recordVisit(_site, username: 'dan', password: 'old-password');
      final forum = _forum()
        ..username = 'dan'
        ..password = 'old-password'
        ..lastSuccessfulLoginMethod = SiteContext.loginMethodPassword;
      sheet.answer = _Sheet.handBack;
      final results = <bool>[];
      await pumpApp(tester, forum, results);

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(results, [true]);
      expect(find.byType(LoginPage), findsNothing);
      expect(forum.lastSuccessfulLoginMethod, SiteContext.loginMethodBrowser);
      expect(forum.password, isNull);
      expect(await SiteVisitTracker.instance.getCredentials(_site), isNull);
    });

    testWidgets('a second tap while the sheet is open opens no second sheet', (tester) async {
      final reply = Completer<String>();
      sheet.answer = (_) => reply.future;
      final results = <bool>[];
      await pumpApp(tester, _forum(), results);

      await tester.tap(find.text('Sign in'));
      await tester.pump();
      await tester.tap(find.text('Sign in'));
      await tester.pump();
      expect(sheet.opened, hasLength(1));

      reply.completeError(PlatformException(code: 'CANCELED'));
      await tester.pumpAndSettle();
      expect(results, [false, false]);
    });

    testWidgets("where the sheet won't open, the app's own form, without passkeys", (tester) async {
      sheet.answer = (_) => throw PlatformException(code: 'EUNKNOWN', message: 'no browser');
      await pumpApp(tester, _forum(), <bool>[]);

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Username'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
      expect(find.byIcon(Icons.key_rounded), findsNothing);
      expect(find.byIcon(Icons.open_in_browser_rounded), findsNothing);
      // No "something went wrong" over it.
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  testWidgets("a forum on an older add-on gets the app's own form, and no sheet", (tester) async {
    await pumpApp(tester, _forum(website: false), <bool>[]);

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(sheet.opened, isEmpty);
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.byIcon(Icons.open_in_browser_rounded), findsNothing);
  });

  group('a password saved by an earlier sign-in in the app', () {
    Future<AutoLoginResult> renew(WidgetTester tester, SiteContext forum, FCLoginResult reply) async {
      await SiteVisitTracker.instance.recordVisit(_site, username: 'dan', password: 'old-password');
      forum
        ..username = 'dan'
        ..password = 'old-password'
        ..lastSuccessfulLoginMethod = SiteContext.loginMethodPassword;
      user.passwordReply = reply;
      await pumpApp(tester, forum, <bool>[]);
      // Real I/O (the cookie jar) runs outside the test's clock. A two-step
      // screen or a sign-in page would hold it up: it must finish alone.
      final result = await tester.runAsync(
          () => LoginController().attemptAutomaticLogin(forum).timeout(const Duration(seconds: 10)));
      await tester.pumpAndSettle();
      return result!;
    }

    testWidgets('website forum: it still renews the session, so the update signs no one out', (tester) async {
      final forum = _forum();
      final result =
          await renew(tester, forum, FCLoginResult(result: true, resultText: '', user: FCUser(id: '7', username: 'dan')));

      expect(result.success, isTrue);
      expect(forum.isLoggedIn, isTrue);
      expect(await SiteVisitTracker.instance.getCredentials(_site), {'username': 'dan', 'password': 'old-password'});
    });

    testWidgets('website forum asking for two-step: no two-step screen; forgotten, signed out', (tester) async {
      final forum = _forum();
      final result = await renew(
          tester, forum, FCLoginResult(result: false, resultText: '', tfaRequired: true));

      expect(user.passwordSignIns, ['dan']);
      expect(find.byType(TFAInputDialog), findsNothing);
      expect(find.byType(AlertDialog), findsNothing);
      expect(result.success, isFalse);
      // Callers open no sign-in page.
      expect(result.hadCredentials, isFalse);
      expect(forum.password, isNull);
      expect(forum.isLoggedIn, isFalse);
      expect(await SiteVisitTracker.instance.getCredentials(_site), isNull);
    });

    testWidgets('website forum turning the password down: no bar, no page; forgotten', (tester) async {
      final forum = _forum();
      final result =
          await renew(tester, forum, FCLoginResult(result: false, resultText: 'Incorrect password. Please try again.'));

      expect(result.success, isFalse);
      expect(result.hadCredentials, isFalse);
      expect(find.byType(SnackBar), findsNothing);
      expect(await SiteVisitTracker.instance.getCredentials(_site), isNull);
    });

    testWidgets('older add-on turning the password down: the sign-in page is offered, as before', (tester) async {
      final result = await renew(
          tester, _forum(website: false), FCLoginResult(result: false, resultText: 'Incorrect password. Please try again.'));

      expect(result.success, isFalse);
      expect(result.hadCredentials, isTrue);
    });
  });
}
