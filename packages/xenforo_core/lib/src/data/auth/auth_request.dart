import 'package:dart_mappable/dart_mappable.dart';

part 'auth_request.mapper.dart';

/// Authentication request model for XenForo
@MappableClass()
class AuthRequest with AuthRequestMappable {
  /// Username or email for login
  String login;

  /// Password for authentication
  String password;

  /// Remember me flag
  bool remember;

  /// Trust code for two-factor authentication
  String? trustCode;

  /// Client ID for OAuth2
  String? clientId;

  /// Client secret for OAuth2
  String? clientSecret;

  /// Redirect URI for OAuth2
  String? redirectUri;

  /// Scopes requested
  List<String>? scopes;

  AuthRequest({
    required this.login,
    required this.password,
    this.remember = false,
    this.trustCode,
    this.clientId,
    this.clientSecret,
    this.redirectUri,
    this.scopes,
  });

  /// Create login request
  factory AuthRequest.login({
    required String login,
    required String password,
    bool remember = false,
    String? trustCode,
  }) {
    return AuthRequest(
      login: login,
      password: password,
      remember: remember,
      trustCode: trustCode,
    );
  }

  /// Create OAuth2 authorization request
  factory AuthRequest.oauth2({
    required String login,
    required String password,
    required String clientId,
    String? clientSecret,
    String? redirectUri,
    List<String>? scopes,
  }) {
    return AuthRequest(
      login: login,
      password: password,
      clientId: clientId,
      clientSecret: clientSecret,
      redirectUri: redirectUri,
      scopes: scopes,
    );
  }

  /// Convert to form data for HTTP requests
  Map<String, dynamic> toFormData() {
    final data = <String, dynamic>{
      'login': login,
      'password': password,
      'remember': remember,
    };

    if (trustCode != null) data['trust_code'] = trustCode;
    if (clientId != null) data['client_id'] = clientId;
    if (clientSecret != null) data['client_secret'] = clientSecret;
    if (redirectUri != null) data['redirect_uri'] = redirectUri;
    if (scopes != null) data['scope'] = scopes!.join(' ');

    return data;
  }
}
