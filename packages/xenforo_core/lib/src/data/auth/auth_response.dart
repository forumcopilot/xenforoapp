import 'package:dart_mappable/dart_mappable.dart';
import 'oauth_token.dart';
import '../user/user.dart';

part 'auth_response.mapper.dart';

/// Authentication response model for XenForo
@MappableClass()
class AuthResponse with AuthResponseMappable {
  /// Whether authentication was successful
  bool success;

  /// Error message if authentication failed
  String? error;

  /// Error code if authentication failed
  String? errorCode;

  /// OAuth2 token if successful
  OAuthToken? token;

  /// User information if successful
  XenForoUser? user;

  /// Additional data from response
  Map<String, dynamic>? data;

  AuthResponse({
    required this.success,
    this.error,
    this.errorCode,
    this.token,
    this.user,
    this.data,
  });

  /// Create successful response
  factory AuthResponse.success({
    OAuthToken? token,
    XenForoUser? user,
    Map<String, dynamic>? data,
  }) {
    return AuthResponse(
      success: true,
      token: token,
      user: user,
      data: data,
    );
  }

  /// Create error response
  factory AuthResponse.error({
    required String error,
    String? errorCode,
    Map<String, dynamic>? data,
  }) {
    return AuthResponse(
      success: false,
      error: error,
      errorCode: errorCode,
      data: data,
    );
  }

  /// Create from API response
  factory AuthResponse.fromResponse(Map<String, dynamic> response) {
    if (response.containsKey('errors')) {
      final errors = response['errors'] as List<dynamic>?;
      final firstError = errors?.isNotEmpty == true ? errors!.first : null;

      return AuthResponse.error(
        error: firstError?['message'] ?? 'Authentication failed',
        errorCode: firstError?['code']?.toString(),
        data: response,
      );
    }

    if (response.containsKey('access_token')) {
      final token = OAuthToken.fromResponse(response);
      final user = response.containsKey('user') ? XenForoUser.fromJson(response['user']) : null;

      return AuthResponse.success(
        token: token,
        user: user,
        data: response,
      );
    }

    return AuthResponse.error(
      error: 'Invalid response format',
      data: response,
    );
  }
}

/// XenForo OAuth token request model
@MappableClass()
class XenForoOAuthTokenRequest with XenForoOAuthTokenRequestMappable {
  final String grantType;
  final String clientId;
  final String clientSecret;
  final String? username;
  final String? password;
  final String? refreshToken;
  final String? scope;

  const XenForoOAuthTokenRequest({
    required this.grantType,
    required this.clientId,
    required this.clientSecret,
    this.username,
    this.password,
    this.refreshToken,
    this.scope,
  });

  /// Convert to JSON map for API requests
  Map<String, dynamic> toRequestJson() {
    return {
      'grant_type': grantType,
      'client_id': clientId,
      'client_secret': clientSecret,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (scope != null) 'scope': scope,
    };
  }
}

/// XenForo OAuth token response model
@MappableClass()
class XenForoOAuthTokenResponse with XenForoOAuthTokenResponseMappable {
  final String accessToken;
  final String? refreshToken;
  final String tokenType;
  final int expiresIn;
  final String? scope;
  final DateTime? createdAt;

  const XenForoOAuthTokenResponse({
    required this.accessToken,
    this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    this.scope,
    this.createdAt,
  });

  factory XenForoOAuthTokenResponse.fromJson(Map<String, dynamic> json) {
    return XenForoOAuthTokenResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'] ?? 'Bearer',
      expiresIn: json['expires_in'] ?? 3600,
      scope: json['scope'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }
}
