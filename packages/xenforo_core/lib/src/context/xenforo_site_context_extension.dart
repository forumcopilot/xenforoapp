import 'package:forumcopilot_sdk/context/site_context.dart';

/// Extension to add XenForo-specific authentication fields to SiteContext
extension XenForoSiteContextExtension on SiteContext {
  // In-memory storage for XenForo-specific context values during runtime/tests
  static final Expando<Map<String, dynamic>> _xfStore = Expando<Map<String, dynamic>>('xfStore');

  Map<String, dynamic> _store() => _xfStore[this] ??= <String, dynamic>{};

  /// Guest API key for unauthenticated access
  String? get guestApiKey => _store()['guestApiKey'] as String?;

  /// OAuth2 access token for authenticated users
  String? get oauthAccessToken => _store()['oauthAccessToken'] as String?;

  /// OAuth2 refresh token
  String? get oauthRefreshToken => _store()['oauthRefreshToken'] as String?;

  /// OAuth2 token expiry timestamp (Unix timestamp)
  int? get oauthTokenExpiry => _store()['oauthTokenExpiry'] as int?;

  /// Set guest API key
  void setGuestApiKey(String? apiKey) {
    _store()['guestApiKey'] = apiKey;
  }

  /// Set OAuth2 tokens
  void setOAuthTokens({
    String? accessToken,
    String? refreshToken,
    int? expiry,
  }) {
    _store()['oauthAccessToken'] = accessToken;
    _store()['oauthRefreshToken'] = refreshToken;
    _store()['oauthTokenExpiry'] = expiry;
  }

  /// Clear OAuth2 tokens
  void clearOAuthTokens() {
    _store()['oauthAccessToken'] = null;
    _store()['oauthRefreshToken'] = null;
    _store()['oauthTokenExpiry'] = null;
  }

  /// Check if OAuth2 token is expired
  bool get isOAuthTokenExpired {
    final expiry = oauthTokenExpiry;
    if (expiry == null) return true;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return expiry <= now;
  }

  /// Check if user has valid OAuth2 authentication
  bool get hasValidOAuthToken {
    return oauthAccessToken != null && !isOAuthTokenExpired;
  }

  /// Get appropriate authentication header for XenForo API
  String? getAuthHeader() {
    if (hasValidOAuthToken) {
      return 'Bearer $oauthAccessToken';
    } else if (guestApiKey != null) {
      return guestApiKey;
    }
    return null;
  }

  /// Get authentication method being used
  XenForoAuthMethod get authMethod {
    if (hasValidOAuthToken) {
      return XenForoAuthMethod.oauth2;
    } else if (guestApiKey != null) {
      return XenForoAuthMethod.apiKey;
    }
    return XenForoAuthMethod.none;
  }

  // Note: No persistence here; tests only need in-memory storage per context instance
}

/// XenForo authentication methods
enum XenForoAuthMethod {
  none,
  apiKey,
  oauth2,
}
