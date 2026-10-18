import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';

import '../config/app_forum_config.dart';
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

  /// Whether [siteContext]'s forum offers it to this app.
  static bool isOffered(SiteContext siteContext) =>
      siteContext.configDataOutput?.browserLoginSchemes?.contains(scheme) ?? false;

  /// Opens the forum's sign-in page and waits for the hand-back. Null when
  /// the member closed the sheet; throws [BrowserLoginException] when the
  /// reply is not one this request asked for.
  static Future<BrowserLoginCode?> requestCode(SiteContext siteContext) async {
    final root = ForumLinks.rootOf(siteContext.site);
    if (root == null) throw const BrowserLoginException('no forum address');

    final verifier = _random(48);
    final state = _random(24);
    final url = signInUrl(root, state: state, challenge: challengeFor(verifier));

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

  /// The PKCE S256 challenge for [verifier] (RFC 7636).
  static String challengeFor(String verifier) =>
      base64UrlEncode(sha256.convert(ascii.encode(verifier)).bytes).replaceAll('=', '');

  /// The forum's sign-in page for this app, under the forum's [root].
  static String signInUrl(Uri root, {required String state, required String challenge}) =>
      '${root.scheme}://${root.authority}${root.path}index.php?forumcopilot-app-login/&'
      '${Uri(queryParameters: {'scheme': scheme, 'state': state, 'challenge': challenge}).query}';

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
