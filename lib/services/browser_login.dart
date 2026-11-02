import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_forum_config.dart';
import '../core/logging/app_logger.dart';
import '../utils/forum_links.dart';

/// Signing in through the forum's website, for members who sign in there
/// with Google, Facebook, a passkey or two-step and have no password to type
/// here. The forum's page opens in the system browser sheet (sharing the
/// browser's sign-in), the member confirms, and the page hands a one-time
/// code to this app's scheme; the code is redeemed with the PKCE verifier
/// (IFCBrowserLogin).
class BrowserLogin {
  BrowserLogin._();

  /// This app's URL scheme for the hand-back (AppForumConfig); the forum
  /// must list it (add-on option "App sign-in schemes"), and the Android
  /// callback activity in AndroidManifest.xml declares the same scheme.
  static const String scheme = AppForumConfig.browserLoginScheme;

  /// Whether this platform has the system browser sheet the hand-back needs
  /// (ASWebAuthenticationSession, Custom Tabs). flutter_web_auth_2 cannot
  /// come back to an app scheme on Windows, Linux or the web.
  static bool get hasSystemSheet =>
      debugHasSystemSheet ??
      (!kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.macOS));

  /// Stands in for the platform check in tests.
  @visibleForTesting
  static bool? debugHasSystemSheet;

  /// Whether [siteContext]'s forum offers it to this app (add-on 1.9.0 and
  /// later), on a platform where it can come back.
  static bool isOffered(SiteContext siteContext) =>
      hasSystemSheet && (siteContext.configDataOutput?.browserLoginSchemes?.contains(scheme) ?? false);

  /// Opens the forum's sign-in page and waits for the hand-back. Null when
  /// the member closed the sheet; throws [BrowserLoginException] when the
  /// reply is not one this request asked for.
  ///
  /// With [signUp], the forum's register page opens instead, with the same
  /// sign-in page as where to go next (`_xfRedirect`). XenForo itself drops
  /// that after signing up (add-on 1.9.0 included), so the sheet then closes
  /// without a code and WebsiteSignUp offers Continue; an add-on that keeps
  /// it hands the new account straight back, with no change here.
  static Future<BrowserLoginCode?> requestCode(SiteContext siteContext, {bool signUp = false}) async {
    final root = ForumLinks.rootOf(siteContext.site);
    if (root == null) throw const BrowserLoginException('no forum address');

    final verifier = _random(48);
    final state = _random(24);
    final signIn = signInUrl(root, state: state, challenge: challengeFor(verifier));
    final url = signUp ? signUpUrl(root, then: signIn) : signIn;

    final String result;
    try {
      result = await FlutterWebAuth2.authenticate(url: url, callbackUrlScheme: scheme);
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') return null;
      rethrow;
    }
    final reply = Uri.parse(result);
    final code = reply.queryParameters['code'];
    if (reply.queryParameters['state'] != state || code == null || code.isEmpty) {
      throw const BrowserLoginException('unexpected reply');
    }
    return BrowserLoginCode(code, verifier);
  }

  /// Opens [url] in the system browser sheet and returns once the member
  /// closes it: a page that hands nothing back, such as the register page of
  /// a forum whose add-on predates website sign-in.
  static Future<void> openUntilClosed(String url) async {
    try {
      await FlutterWebAuth2.authenticate(url: url, callbackUrlScheme: scheme);
    } on PlatformException catch (e) {
      if (e.code != 'CANCELED') rethrow;
    }
  }

  /// Opens [url], a page of the forum's website that hands nothing back, in
  /// the browser sheet where there is one, else in the browser: the register
  /// page of a forum whose add-on predates website sign-in, or the forum's
  /// lost-password page. Returns once the member closes the sheet.
  static Future<void> openPage(String url) async {
    if (hasSystemSheet) {
      try {
        await openUntilClosed(url);
        return;
      } on PlatformException catch (e) {
        AppLogger.warning('[BrowserLogin] browser sheet unavailable (${e.code}); opening the browser');
      }
    }
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  /// The PKCE S256 challenge for [verifier] (RFC 7636).
  static String challengeFor(String verifier) =>
      base64UrlEncode(sha256.convert(ascii.encode(verifier)).bytes).replaceAll('=', '');

  /// The forum's sign-in page for this app, under the forum's [root].
  static String signInUrl(Uri root, {required String state, required String challenge}) =>
      '${root.scheme}://${root.authority}${root.path}index.php?forumcopilot-app-login/&'
      '${Uri(queryParameters: {'scheme': scheme, 'state': state, 'challenge': challenge}).query}';

  /// The forum's register page, under the forum's [root], with or without
  /// friendly URLs. [then] is where XenForo goes next (`_xfRedirect`).
  static String signUpUrl(Uri root, {String? then}) =>
      '${root.scheme}://${root.authority}${root.path}index.php?register/'
      '${then == null ? '' : '&${Uri(queryParameters: {'_xfRedirect': then}).query}'}';

  /// URL-safe random text: [bytes] random bytes, base64url without padding.
  static String _random(int bytes) {
    final random = Random.secure();
    return base64UrlEncode(List<int>.generate(bytes, (_) => random.nextInt(256))).replaceAll('=', '');
  }
}

class BrowserLoginCode {
  const BrowserLoginCode(this.code, this.verifier);
  final String code;
  final String verifier;
}

class BrowserLoginException implements Exception {
  const BrowserLoginException(this.reason);
  final String reason;
  @override
  String toString() => 'BrowserLoginException: $reason';
}
