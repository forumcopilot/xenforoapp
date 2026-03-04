import 'dart:convert';
import 'package:forumcopilot_sdk/context/site_context.dart';
import '../data/user/user.dart';
import '../data/auth/auth_response.dart';
import '../context/xenforo_site_context_extension.dart';
import 'xenforo_client.dart';

/// Plugin-based authentication for XenForo
/// Simplified from OAuth2 to session-based authentication via plugin
class XenForoAuthManager {
  final SiteContext siteContext;
  final XenForoClient _client = XenForoClient();

  XenForoAuthManager({
    required this.siteContext,
  });

  /// Check if user is authenticated (session-based via plugin)
  /// This is a simple check that just verifies the site context is logged in
  bool get isAuthenticated {
    return siteContext.isLoggedIn;
  }

  /// Check if authentication is needed (not applicable in plugin mode)
  bool get needsTokenRefresh {
    return false; // Sessions are managed by XenForo browser/HTTP
  }

  /// Get current user information via plugin API
  Future<XenForoUser?> getCurrentUser() async {
    try {
      final response = await _client.forumcopilotApi(siteContext, {
        'method': 'getCurrentUser',
        'params': {},
      });

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final data = jsonDecode(response.body);
      if (data['result'] == true && data['user'] != null) {
        return XenForoUser.fromJson(data['user']);
      }

      return null;
    } catch (e) {
      print('Failed to get current user via plugin: $e');
      return null;
    }
  }

  /// Logout - clear session context (actual logout handled by XenForo)
  Future<void> logout() async {
    try {
      // Clear any local session data if needed
      siteContext.clearOAuthTokens(); // Legacy cleanup, no longer needed but safe
    } catch (e) {
      print('Logout error: $e');
      // Continue with local logout even if there are issues
    }
  }

  /// Login is handled by XenForo web interface - not via API
  /// This method is not applicable in plugin-only mode
  @deprecated
  Future<AuthResponse> loginWithPassword({
    required String username,
    required String password,
    String? limitIp,
    bool remember = false,
  }) async {
    throw UnsupportedError('Login should be handled via XenForo web interface in plugin mode');
  }

  /// Token refresh - not applicable in plugin mode
  @deprecated
  Future<bool> refreshToken() async {
    return true; // No-op in plugin mode
  }

  /// OAuth authorization URL - not applicable in plugin mode
  @deprecated
  String getAuthorizationUrl({
    required String redirectUri,
    String? state,
  }) {
    throw UnsupportedError('OAuth not supported in plugin-only mode');
  }

  /// OAuth authorization code handling - not applicable in plugin mode
  @deprecated
  Future<AuthResponse> handleAuthorizationCode({
    required String code,
    required String redirectUri,
    String? state,
  }) async {
    throw UnsupportedError('OAuth not supported in plugin-only mode');
  }
}
