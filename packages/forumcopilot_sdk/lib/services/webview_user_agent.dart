import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' show InAppWebViewController;
import 'package:shared_preferences/shared_preferences.dart';

/// The User-Agent the SDK sends: the platform WebView's own.
///
/// The SDK used to send a hard-coded "Chrome/131" string, chosen to pass
/// Cloudflare. Two years on, that string was itself the problem: forums
/// behind Cloudflare's bot rules (community.home-assistant.io) answered it
/// with a 403 challenge, and forums that turn away outdated browsers
/// (forum.codefloe.com, "Browser Update Required") refused it outright —
/// while the phone's real WebView User-Agent passed both (checked
/// 2026-09-23). A version-bumped copy did not reliably pass either; the
/// WebView's exact string did.
///
/// Reading it from the WebView also keeps the API client and the in-app
/// Cloudflare challenge WebView consistent: Cloudflare binds its clearance
/// cookie to the User-Agent that earned it.
///
/// The value is cached across launches. Reading it loads the system WebView,
/// which costs a few hundred milliseconds on the platform thread, so only
/// the first launch waits for it; later launches use the stored value at
/// once and refresh it a little after start-up for the next launch. A
/// session therefore never changes User-Agent midway, and a WebView update is
/// picked up one launch later.
class WebViewUserAgent {
  WebViewUserAgent._();

  static const String _prefsKey = 'fc_webview_user_agent';

  /// Reads the system WebView's default User-Agent. Replaceable in tests.
  @visibleForTesting
  static Future<String> Function() readPlatform =
      InAppWebViewController.getDefaultUserAgent;

  /// How long after start-up the cached value is refreshed. Tests shorten it.
  @visibleForTesting
  static Duration refreshDelay = const Duration(seconds: 10);

  /// Whether this platform has a system WebView to ask. Tests override it.
  @visibleForTesting
  static bool Function() hasSystemWebView = () =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);

  /// The WebView's User-Agent, or null where there is no system WebView
  /// (web, Windows, Linux) or it could not be read.
  static Future<String?> resolve() async {
    if (!hasSystemWebView()) return null;
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (_) {
      // Without storage we simply read it every launch.
    }
    final cached = prefs?.getString(_prefsKey);
    if (cached != null && cached.isNotEmpty) {
      unawaited(Future<void>.delayed(refreshDelay, () async {
        final fresh = await _read();
        if (fresh != null && fresh != cached) {
          await prefs?.setString(_prefsKey, fresh);
        }
      }));
      return cached;
    }
    final fresh = await _read();
    if (fresh != null) await prefs?.setString(_prefsKey, fresh);
    return fresh;
  }

  static Future<String?> _read() async {
    try {
      final ua = (await readPlatform().timeout(const Duration(seconds: 3))).trim();
      return ua.isEmpty ? null : ua;
    } catch (_) {
      return null;
    }
  }
}
