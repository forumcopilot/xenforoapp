import 'package:dart_mappable/dart_mappable.dart';

part 'oauth_token.mapper.dart';

/// OAuth2 token model for XenForo authentication
@MappableClass()
class OAuthToken with OAuthTokenMappable {
  /// Access token for API requests
  String accessToken;

  /// Refresh token for getting new access tokens
  String? refreshToken;

  /// Token type (usually "Bearer")
  String tokenType;

  /// Expires in seconds from now
  int? expiresIn;

  /// Expiry timestamp (Unix timestamp)
  int? expiresAt;

  /// Scopes granted to this token
  List<String>? scopes;

  OAuthToken({
    required this.accessToken,
    this.refreshToken,
    this.tokenType = 'Bearer',
    this.expiresIn,
    this.expiresAt,
    this.scopes,
  });

  /// Check if the token is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return expiresAt! <= now;
  }

  /// Check if the token will expire soon (within 5 minutes)
  bool get isExpiringSoon {
    if (expiresAt == null) return false;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return expiresAt! <= (now + 300); // 5 minutes
  }

  /// Create token from response data
  factory OAuthToken.fromResponse(Map<String, dynamic> data) {
    final expiresIn = data['expires_in'] as int?;
    final expiresAt = expiresIn != null ? DateTime.now().millisecondsSinceEpoch ~/ 1000 + expiresIn : null;

    return OAuthToken(
      accessToken: data['access_token'] ?? '',
      refreshToken: data['refresh_token'],
      tokenType: data['token_type'] ?? 'Bearer',
      expiresIn: expiresIn,
      expiresAt: expiresAt,
      scopes: data['scope']?.toString().split(' '),
    );
  }
}
