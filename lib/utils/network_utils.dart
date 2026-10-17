import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';

class NetworkUtils {
  /// Whether [text] (a failed call's result text or exception) says the forum
  /// was not reached: no connection, refused, timed out. The proxies put the
  /// transport error itself there, which is no message for a reader.
  static bool isUnreachable(String? text) {
    if (text == null || text.isEmpty) return false;
    return _unreachable.hasMatch(text);
  }

  static final RegExp _unreachable = RegExp(
    r'DioException|SocketException|HandshakeException|Connection (refused|reset|closed|errored)|'
    r'Failed host lookup|Network is unreachable|timed out|status 0\b',
    caseSensitive: false,
  );

  /// Follows HTTP redirects and returns the final URL
  static Future<String> resolveRedirects(String url, {int maxRedirects = 5}) async {
    if (maxRedirects <= 0) {
      return url; // Prevent infinite redirects
    }

    try {
      final response = await FCHttpClient.head(Uri.parse(url));

      debugPrint('NetworkUtils.resolveRedirects: Checking URL $url');
      final statusCode = response.statusCode ?? 0;
      debugPrint('NetworkUtils.resolveRedirects: Status code $statusCode');

      if ((statusCode >= 300 && statusCode < 400) || statusCode == 404) {
        final String? redirectUrl = response.headers.value('location');
        debugPrint('NetworkUtils.resolveRedirects: Found location header: $redirectUrl');

        if (redirectUrl != null) {
          // Handle relative URLs
          final Uri redirectUri = Uri.parse(redirectUrl);
          final Uri resolvedUri = redirectUri.isAbsolute ? redirectUri : Uri.parse(url).resolveUri(redirectUri);

          debugPrint('NetworkUtils.resolveRedirects: Resolved redirect to: ${resolvedUri.toString()}');

          // Follow the redirect recursively
          return resolveRedirects(resolvedUri.toString(), maxRedirects: maxRedirects - 1);
        }
      }

      debugPrint('NetworkUtils.resolveRedirects: No redirect found for $url');
      return url; // No redirect or couldn't resolve
    } catch (e) {
      debugPrint('Error resolving redirect for $url: $e');
      return url; // Return original URL on error
    }
  }
}
