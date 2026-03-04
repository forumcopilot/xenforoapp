import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'request_options_extension.dart';

/// Fork of cloudflare_interceptor 0.0.3 to allow internal modifications.
class CloudflareInterceptor extends Interceptor {
  final Dio dio;
  final CookieJar cookieJar;
  final BuildContext context;

  Completer<String?> _completer = Completer<String?>.sync();
  bool _usingDialog = false;

  CloudflareInterceptor({
    required this.dio,
    required this.cookieJar,
    required this.context,
    this.onChallengeStart,
    this.onChallengeEnd,
  });

  final VoidCallback? onChallengeStart;
  final VoidCallback? onChallengeEnd;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final cfMitigated = response.headers['cf-mitigated'];
    if (cfMitigated == null || !cfMitigated.contains('challenge')) {
      handler.next(response);
      return;
    }

    print('🔒 [CLOUDFLARE] Response headers: ${response.requestOptions.headers}');
    _notifyStart();
    try {
      _solveCloudflare(response.requestOptions);
      final solvedData = await _completer.future;
      if (solvedData != null) {
        final newResponse = Response(
          requestOptions: response.requestOptions,
          data: solvedData,
          statusCode: 200,
          extra: {'cloudflare': true},
        );
        handler.next(newResponse);
      }
    } catch (e) {
      handler.reject(DioException(requestOptions: response.requestOptions, error: e));
    } finally {
      _notifyEnd();
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final cfMitigated = err.response?.headers['cf-mitigated'];
    if (err.response == null || cfMitigated == null || !cfMitigated.contains('challenge')) {
      handler.next(err);
      return;
    }

    print('🔒 [CLOUDFLARE] Error headers: ${err.requestOptions.headers}');
    _notifyStart();
    try {
      _solveCloudflare(err.requestOptions);
      final solvedData = await _completer.future;
      if (solvedData != null) {
        final newResponse = Response(
          requestOptions: err.requestOptions,
          data: solvedData,
          statusCode: 200,
          extra: {'cloudflare': true},
        );
        handler.resolve(newResponse);
      }
    } catch (e) {
      handler.reject(DioException(requestOptions: err.requestOptions, error: e));
    } finally {
      _notifyEnd();
    }
  }

  void _notifyStart() {
    try {
      onChallengeStart?.call();
    } catch (_) {}
  }

  void _notifyEnd() {
    try {
      onChallengeEnd?.call();
    } catch (_) {}
  }

  void _solveCloudflare(RequestOptions requestOptions) async {
    _completer = Completer<String?>.sync();

    final targetUri = requestOptions.uri;

    // Step 1: Pre-resolve DNS to warm up system cache - ensures WebView uses same IP as Dio
    try {
      debugPrint('🌐 [WEBVIEW_DNS] Pre-resolving ${targetUri.host} to warm DNS cache');
      await InternetAddress.lookup(targetUri.host);
      debugPrint('🌐 [WEBVIEW_DNS] DNS pre-resolution complete');
    } catch (e) {
      debugPrint('⚠️ [WEBVIEW_DNS] DNS pre-resolution failed: $e');
    }

    // Step 2: Inject Dio cookies into WebView before loading
    await _injectDioCookiesToWebView(targetUri);

    final initialSettings = requestOptions.getWebViewSettings();
    final initialUrlRequest = await requestOptions.getURLRequest();

    if (!context.mounted) throw Exception('Context is not mounted');

    _usingDialog = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog.fullscreen(
        child: Stack(
          children: [
            InAppWebView(
              initialSettings: initialSettings,
              initialUrlRequest: initialUrlRequest,
              onLoadStop: (controller, uri) => _onLoadStop(controller, uri, targetUri),
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final url = navigationAction.request.url?.toString() ?? '';
                final isMain = navigationAction.isForMainFrame;
                if (isMain) {
                  debugPrint('🔒 [CLOUDFLARE][MAIN] Navigation request to: $url');
                }
                return NavigationActionPolicy.ALLOW;
              },
            ),
            Positioned(
              top: 12,
              right: 12,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: Theme.of(dialogContext).colorScheme.onSurface,
                  tooltip: 'Close challenge',
                  onPressed: () => _dismissChallenge(dialogContext),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Optional timeout to auto-close if it hangs
    /* Future.delayed(const Duration(seconds: 30)).then((_) {
      if (!_completer.isCompleted && _usingDialog && context.mounted) {
        Navigator.of(context).maybePop();
        _completer.complete(null);
        _usingDialog = false;
      }
    });*/
  }

  void _onLoadStop(InAppWebViewController controller, WebUri? uri, Uri targetUri) async {
    if (_completer.isCompleted) return;
    if (uri == null) return;
    final currentUri = Uri.parse(uri.toString());
    if (currentUri.scheme.startsWith('about')) return;

    if (currentUri.host != targetUri.host || currentUri.path != targetUri.path) {
      // Still navigating or redirected?
      // If strict matching is required as per user instruction:
      return;
    }

    final html = await controller.getHtml();

    if (html == null) return;

    final pageTitle = await controller.getTitle();
    final title = pageTitle?.toLowerCase() ?? '';

    if (title.contains('cloudflare') || title.contains('just a moment') || title.contains('verification required')) return;

    if (html.contains('Ray ID')) return;

    final inAppCookies = await CookieManager.instance().getCookies(url: uri);

    final ioCookies = inAppCookies.map((c) {
      final cookie = io.Cookie(c.name, c.value);
      cookie.domain = c.domain;
      cookie.path = c.path ?? '/';
      if (c.expiresDate != null) {
        cookie.expires = DateTime.fromMillisecondsSinceEpoch(c.expiresDate!);
      }
      cookie.secure = c.isSecure ?? false;
      cookie.httpOnly = c.isHttpOnly ?? false;
      return cookie;
    }).toList();

    cookieJar.saveFromResponse(Uri.parse(uri.toString()), ioCookies);

    String? resultData = html;
    try {
      final innerText = await controller.evaluateJavascript(source: "document.body.innerText");
      if (innerText != null && innerText is String && innerText.trim().startsWith('{')) {
        resultData = innerText;
      }
    } catch (e) {
      debugPrint('Error extracting innerText: $e');
    }

    // Guard again in case the user closed the dialog while we were awaiting above.
    if (!_completer.isCompleted) {
      _completer.complete(resultData);
    }

    if (_usingDialog) {
      if (!context.mounted) throw Exception('Context is not mounted');

      Navigator.of(context).pop();

      _usingDialog = false;
    }
  }

  /// Inject Dio cookies into WebView before loading to ensure same session
  Future<void> _injectDioCookiesToWebView(Uri uri) async {
    try {
      // Get all cookies from Dio's cookie jar for this domain
      final dioCookies = await cookieJar.loadForRequest(uri);

      if (dioCookies.isEmpty) {
        debugPrint('🍪 [COOKIE_SYNC] No Dio cookies to inject for ${uri.host}');
        return;
      }

      debugPrint('🍪 [COOKIE_SYNC] Injecting ${dioCookies.length} Dio cookies into WebView for ${uri.host}');

      // Convert Dio cookies to WebView cookies and inject them
      final cookieManager = CookieManager.instance();
      for (final cookie in dioCookies) {
        try {
          final domain = cookie.domain?.isNotEmpty == true ? cookie.domain! : uri.host;
          final path = cookie.path ?? '/';
          final expiresDate = cookie.expires?.millisecondsSinceEpoch;
          final isSecure = cookie.secure == true || uri.scheme == 'https';
          final isHttpOnly = cookie.httpOnly == true;

          // Use setCookie to inject Dio cookie into WebView
          await cookieManager.setCookie(
            url: WebUri(uri.toString()),
            name: cookie.name,
            value: cookie.value,
            domain: domain,
            path: path,
            expiresDate: expiresDate,
            isSecure: isSecure,
            isHttpOnly: isHttpOnly,
            sameSite: HTTPCookieSameSitePolicy.LAX,
          );

          debugPrint('🍪 [COOKIE_SYNC] Injected cookie: ${cookie.name}');
        } catch (e) {
          debugPrint('⚠️ [COOKIE_SYNC] Failed to inject cookie ${cookie.name}: $e');
        }
      }

      debugPrint('🍪 [COOKIE_SYNC] Cookie injection complete');
    } catch (e) {
      debugPrint('⚠️ [COOKIE_SYNC] Failed to inject Dio cookies: $e');
    }
  }

  void _dismissChallenge(BuildContext dialogContext) {
    Navigator.of(dialogContext).maybePop();
    _usingDialog = false;

    if (!_completer.isCompleted) {
      _completer.complete(null);
    }
  }
}
