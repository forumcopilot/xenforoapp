// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_response.dart';

class AuthResponseMapper extends ClassMapperBase<AuthResponse> {
  AuthResponseMapper._();

  static AuthResponseMapper? _instance;
  static AuthResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthResponseMapper._());
      OAuthTokenMapper.ensureInitialized();
      XenForoUserMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthResponse';

  static bool _$success(AuthResponse v) => v.success;
  static const Field<AuthResponse, bool> _f$success =
      Field('success', _$success);
  static String? _$error(AuthResponse v) => v.error;
  static const Field<AuthResponse, String> _f$error =
      Field('error', _$error, opt: true);
  static String? _$errorCode(AuthResponse v) => v.errorCode;
  static const Field<AuthResponse, String> _f$errorCode =
      Field('errorCode', _$errorCode, opt: true);
  static OAuthToken? _$token(AuthResponse v) => v.token;
  static const Field<AuthResponse, OAuthToken> _f$token =
      Field('token', _$token, opt: true);
  static XenForoUser? _$user(AuthResponse v) => v.user;
  static const Field<AuthResponse, XenForoUser> _f$user =
      Field('user', _$user, opt: true);
  static Map<String, dynamic>? _$data(AuthResponse v) => v.data;
  static const Field<AuthResponse, Map<String, dynamic>> _f$data =
      Field('data', _$data, opt: true);

  @override
  final MappableFields<AuthResponse> fields = const {
    #success: _f$success,
    #error: _f$error,
    #errorCode: _f$errorCode,
    #token: _f$token,
    #user: _f$user,
    #data: _f$data,
  };

  static AuthResponse _instantiate(DecodingData data) {
    return AuthResponse(
        success: data.dec(_f$success),
        error: data.dec(_f$error),
        errorCode: data.dec(_f$errorCode),
        token: data.dec(_f$token),
        user: data.dec(_f$user),
        data: data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthResponse>(map);
  }

  static AuthResponse fromJson(String json) {
    return ensureInitialized().decodeJson<AuthResponse>(json);
  }
}

mixin AuthResponseMappable {
  String toJson() {
    return AuthResponseMapper.ensureInitialized()
        .encodeJson<AuthResponse>(this as AuthResponse);
  }

  Map<String, dynamic> toMap() {
    return AuthResponseMapper.ensureInitialized()
        .encodeMap<AuthResponse>(this as AuthResponse);
  }

  AuthResponseCopyWith<AuthResponse, AuthResponse, AuthResponse> get copyWith =>
      _AuthResponseCopyWithImpl<AuthResponse, AuthResponse>(
          this as AuthResponse, $identity, $identity);
  @override
  String toString() {
    return AuthResponseMapper.ensureInitialized()
        .stringifyValue(this as AuthResponse);
  }

  @override
  bool operator ==(Object other) {
    return AuthResponseMapper.ensureInitialized()
        .equalsValue(this as AuthResponse, other);
  }

  @override
  int get hashCode {
    return AuthResponseMapper.ensureInitialized()
        .hashValue(this as AuthResponse);
  }
}

extension AuthResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthResponse, $Out> {
  AuthResponseCopyWith<$R, AuthResponse, $Out> get $asAuthResponse =>
      $base.as((v, t, t2) => _AuthResponseCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthResponseCopyWith<$R, $In extends AuthResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  OAuthTokenCopyWith<$R, OAuthToken, OAuthToken>? get token;
  XenForoUserCopyWith<$R, XenForoUser, XenForoUser>? get user;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
      get data;
  $R call(
      {bool? success,
      String? error,
      String? errorCode,
      OAuthToken? token,
      XenForoUser? user,
      Map<String, dynamic>? data});
  AuthResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthResponse, $Out>
    implements AuthResponseCopyWith<$R, AuthResponse, $Out> {
  _AuthResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthResponse> $mapper =
      AuthResponseMapper.ensureInitialized();
  @override
  OAuthTokenCopyWith<$R, OAuthToken, OAuthToken>? get token =>
      $value.token?.copyWith.$chain((v) => call(token: v));
  @override
  XenForoUserCopyWith<$R, XenForoUser, XenForoUser>? get user =>
      $value.user?.copyWith.$chain((v) => call(user: v));
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
      get data => $value.data != null
          ? MapCopyWith($value.data!, (v, t) => ObjectCopyWith(v, $identity, t),
              (v) => call(data: v))
          : null;
  @override
  $R call(
          {bool? success,
          Object? error = $none,
          Object? errorCode = $none,
          Object? token = $none,
          Object? user = $none,
          Object? data = $none}) =>
      $apply(FieldCopyWithData({
        if (success != null) #success: success,
        if (error != $none) #error: error,
        if (errorCode != $none) #errorCode: errorCode,
        if (token != $none) #token: token,
        if (user != $none) #user: user,
        if (data != $none) #data: data
      }));
  @override
  AuthResponse $make(CopyWithData data) => AuthResponse(
      success: data.get(#success, or: $value.success),
      error: data.get(#error, or: $value.error),
      errorCode: data.get(#errorCode, or: $value.errorCode),
      token: data.get(#token, or: $value.token),
      user: data.get(#user, or: $value.user),
      data: data.get(#data, or: $value.data));

  @override
  AuthResponseCopyWith<$R2, AuthResponse, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AuthResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class XenForoOAuthTokenRequestMapper
    extends ClassMapperBase<XenForoOAuthTokenRequest> {
  XenForoOAuthTokenRequestMapper._();

  static XenForoOAuthTokenRequestMapper? _instance;
  static XenForoOAuthTokenRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = XenForoOAuthTokenRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoOAuthTokenRequest';

  static String _$grantType(XenForoOAuthTokenRequest v) => v.grantType;
  static const Field<XenForoOAuthTokenRequest, String> _f$grantType =
      Field('grantType', _$grantType);
  static String _$clientId(XenForoOAuthTokenRequest v) => v.clientId;
  static const Field<XenForoOAuthTokenRequest, String> _f$clientId =
      Field('clientId', _$clientId);
  static String _$clientSecret(XenForoOAuthTokenRequest v) => v.clientSecret;
  static const Field<XenForoOAuthTokenRequest, String> _f$clientSecret =
      Field('clientSecret', _$clientSecret);
  static String? _$username(XenForoOAuthTokenRequest v) => v.username;
  static const Field<XenForoOAuthTokenRequest, String> _f$username =
      Field('username', _$username, opt: true);
  static String? _$password(XenForoOAuthTokenRequest v) => v.password;
  static const Field<XenForoOAuthTokenRequest, String> _f$password =
      Field('password', _$password, opt: true);
  static String? _$refreshToken(XenForoOAuthTokenRequest v) => v.refreshToken;
  static const Field<XenForoOAuthTokenRequest, String> _f$refreshToken =
      Field('refreshToken', _$refreshToken, opt: true);
  static String? _$scope(XenForoOAuthTokenRequest v) => v.scope;
  static const Field<XenForoOAuthTokenRequest, String> _f$scope =
      Field('scope', _$scope, opt: true);

  @override
  final MappableFields<XenForoOAuthTokenRequest> fields = const {
    #grantType: _f$grantType,
    #clientId: _f$clientId,
    #clientSecret: _f$clientSecret,
    #username: _f$username,
    #password: _f$password,
    #refreshToken: _f$refreshToken,
    #scope: _f$scope,
  };

  static XenForoOAuthTokenRequest _instantiate(DecodingData data) {
    return XenForoOAuthTokenRequest(
        grantType: data.dec(_f$grantType),
        clientId: data.dec(_f$clientId),
        clientSecret: data.dec(_f$clientSecret),
        username: data.dec(_f$username),
        password: data.dec(_f$password),
        refreshToken: data.dec(_f$refreshToken),
        scope: data.dec(_f$scope));
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoOAuthTokenRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoOAuthTokenRequest>(map);
  }

  static XenForoOAuthTokenRequest fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoOAuthTokenRequest>(json);
  }
}

mixin XenForoOAuthTokenRequestMappable {
  String toJson() {
    return XenForoOAuthTokenRequestMapper.ensureInitialized()
        .encodeJson<XenForoOAuthTokenRequest>(this as XenForoOAuthTokenRequest);
  }

  Map<String, dynamic> toMap() {
    return XenForoOAuthTokenRequestMapper.ensureInitialized()
        .encodeMap<XenForoOAuthTokenRequest>(this as XenForoOAuthTokenRequest);
  }

  XenForoOAuthTokenRequestCopyWith<XenForoOAuthTokenRequest,
          XenForoOAuthTokenRequest, XenForoOAuthTokenRequest>
      get copyWith => _XenForoOAuthTokenRequestCopyWithImpl<
              XenForoOAuthTokenRequest, XenForoOAuthTokenRequest>(
          this as XenForoOAuthTokenRequest, $identity, $identity);
  @override
  String toString() {
    return XenForoOAuthTokenRequestMapper.ensureInitialized()
        .stringifyValue(this as XenForoOAuthTokenRequest);
  }

  @override
  bool operator ==(Object other) {
    return XenForoOAuthTokenRequestMapper.ensureInitialized()
        .equalsValue(this as XenForoOAuthTokenRequest, other);
  }

  @override
  int get hashCode {
    return XenForoOAuthTokenRequestMapper.ensureInitialized()
        .hashValue(this as XenForoOAuthTokenRequest);
  }
}

extension XenForoOAuthTokenRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoOAuthTokenRequest, $Out> {
  XenForoOAuthTokenRequestCopyWith<$R, XenForoOAuthTokenRequest, $Out>
      get $asXenForoOAuthTokenRequest => $base.as((v, t, t2) =>
          _XenForoOAuthTokenRequestCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoOAuthTokenRequestCopyWith<
    $R,
    $In extends XenForoOAuthTokenRequest,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? grantType,
      String? clientId,
      String? clientSecret,
      String? username,
      String? password,
      String? refreshToken,
      String? scope});
  XenForoOAuthTokenRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _XenForoOAuthTokenRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoOAuthTokenRequest, $Out>
    implements
        XenForoOAuthTokenRequestCopyWith<$R, XenForoOAuthTokenRequest, $Out> {
  _XenForoOAuthTokenRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoOAuthTokenRequest> $mapper =
      XenForoOAuthTokenRequestMapper.ensureInitialized();
  @override
  $R call(
          {String? grantType,
          String? clientId,
          String? clientSecret,
          Object? username = $none,
          Object? password = $none,
          Object? refreshToken = $none,
          Object? scope = $none}) =>
      $apply(FieldCopyWithData({
        if (grantType != null) #grantType: grantType,
        if (clientId != null) #clientId: clientId,
        if (clientSecret != null) #clientSecret: clientSecret,
        if (username != $none) #username: username,
        if (password != $none) #password: password,
        if (refreshToken != $none) #refreshToken: refreshToken,
        if (scope != $none) #scope: scope
      }));
  @override
  XenForoOAuthTokenRequest $make(CopyWithData data) => XenForoOAuthTokenRequest(
      grantType: data.get(#grantType, or: $value.grantType),
      clientId: data.get(#clientId, or: $value.clientId),
      clientSecret: data.get(#clientSecret, or: $value.clientSecret),
      username: data.get(#username, or: $value.username),
      password: data.get(#password, or: $value.password),
      refreshToken: data.get(#refreshToken, or: $value.refreshToken),
      scope: data.get(#scope, or: $value.scope));

  @override
  XenForoOAuthTokenRequestCopyWith<$R2, XenForoOAuthTokenRequest, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _XenForoOAuthTokenRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class XenForoOAuthTokenResponseMapper
    extends ClassMapperBase<XenForoOAuthTokenResponse> {
  XenForoOAuthTokenResponseMapper._();

  static XenForoOAuthTokenResponseMapper? _instance;
  static XenForoOAuthTokenResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = XenForoOAuthTokenResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoOAuthTokenResponse';

  static String _$accessToken(XenForoOAuthTokenResponse v) => v.accessToken;
  static const Field<XenForoOAuthTokenResponse, String> _f$accessToken =
      Field('accessToken', _$accessToken);
  static String? _$refreshToken(XenForoOAuthTokenResponse v) => v.refreshToken;
  static const Field<XenForoOAuthTokenResponse, String> _f$refreshToken =
      Field('refreshToken', _$refreshToken, opt: true);
  static String _$tokenType(XenForoOAuthTokenResponse v) => v.tokenType;
  static const Field<XenForoOAuthTokenResponse, String> _f$tokenType =
      Field('tokenType', _$tokenType);
  static int _$expiresIn(XenForoOAuthTokenResponse v) => v.expiresIn;
  static const Field<XenForoOAuthTokenResponse, int> _f$expiresIn =
      Field('expiresIn', _$expiresIn);
  static String? _$scope(XenForoOAuthTokenResponse v) => v.scope;
  static const Field<XenForoOAuthTokenResponse, String> _f$scope =
      Field('scope', _$scope, opt: true);
  static DateTime? _$createdAt(XenForoOAuthTokenResponse v) => v.createdAt;
  static const Field<XenForoOAuthTokenResponse, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, opt: true);

  @override
  final MappableFields<XenForoOAuthTokenResponse> fields = const {
    #accessToken: _f$accessToken,
    #refreshToken: _f$refreshToken,
    #tokenType: _f$tokenType,
    #expiresIn: _f$expiresIn,
    #scope: _f$scope,
    #createdAt: _f$createdAt,
  };

  static XenForoOAuthTokenResponse _instantiate(DecodingData data) {
    return XenForoOAuthTokenResponse(
        accessToken: data.dec(_f$accessToken),
        refreshToken: data.dec(_f$refreshToken),
        tokenType: data.dec(_f$tokenType),
        expiresIn: data.dec(_f$expiresIn),
        scope: data.dec(_f$scope),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoOAuthTokenResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoOAuthTokenResponse>(map);
  }

  static XenForoOAuthTokenResponse fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoOAuthTokenResponse>(json);
  }
}

mixin XenForoOAuthTokenResponseMappable {
  String toJson() {
    return XenForoOAuthTokenResponseMapper.ensureInitialized()
        .encodeJson<XenForoOAuthTokenResponse>(
            this as XenForoOAuthTokenResponse);
  }

  Map<String, dynamic> toMap() {
    return XenForoOAuthTokenResponseMapper.ensureInitialized()
        .encodeMap<XenForoOAuthTokenResponse>(
            this as XenForoOAuthTokenResponse);
  }

  XenForoOAuthTokenResponseCopyWith<XenForoOAuthTokenResponse,
          XenForoOAuthTokenResponse, XenForoOAuthTokenResponse>
      get copyWith => _XenForoOAuthTokenResponseCopyWithImpl<
              XenForoOAuthTokenResponse, XenForoOAuthTokenResponse>(
          this as XenForoOAuthTokenResponse, $identity, $identity);
  @override
  String toString() {
    return XenForoOAuthTokenResponseMapper.ensureInitialized()
        .stringifyValue(this as XenForoOAuthTokenResponse);
  }

  @override
  bool operator ==(Object other) {
    return XenForoOAuthTokenResponseMapper.ensureInitialized()
        .equalsValue(this as XenForoOAuthTokenResponse, other);
  }

  @override
  int get hashCode {
    return XenForoOAuthTokenResponseMapper.ensureInitialized()
        .hashValue(this as XenForoOAuthTokenResponse);
  }
}

extension XenForoOAuthTokenResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoOAuthTokenResponse, $Out> {
  XenForoOAuthTokenResponseCopyWith<$R, XenForoOAuthTokenResponse, $Out>
      get $asXenForoOAuthTokenResponse => $base.as((v, t, t2) =>
          _XenForoOAuthTokenResponseCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoOAuthTokenResponseCopyWith<
    $R,
    $In extends XenForoOAuthTokenResponse,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? accessToken,
      String? refreshToken,
      String? tokenType,
      int? expiresIn,
      String? scope,
      DateTime? createdAt});
  XenForoOAuthTokenResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _XenForoOAuthTokenResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoOAuthTokenResponse, $Out>
    implements
        XenForoOAuthTokenResponseCopyWith<$R, XenForoOAuthTokenResponse, $Out> {
  _XenForoOAuthTokenResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoOAuthTokenResponse> $mapper =
      XenForoOAuthTokenResponseMapper.ensureInitialized();
  @override
  $R call(
          {String? accessToken,
          Object? refreshToken = $none,
          String? tokenType,
          int? expiresIn,
          Object? scope = $none,
          Object? createdAt = $none}) =>
      $apply(FieldCopyWithData({
        if (accessToken != null) #accessToken: accessToken,
        if (refreshToken != $none) #refreshToken: refreshToken,
        if (tokenType != null) #tokenType: tokenType,
        if (expiresIn != null) #expiresIn: expiresIn,
        if (scope != $none) #scope: scope,
        if (createdAt != $none) #createdAt: createdAt
      }));
  @override
  XenForoOAuthTokenResponse $make(CopyWithData data) =>
      XenForoOAuthTokenResponse(
          accessToken: data.get(#accessToken, or: $value.accessToken),
          refreshToken: data.get(#refreshToken, or: $value.refreshToken),
          tokenType: data.get(#tokenType, or: $value.tokenType),
          expiresIn: data.get(#expiresIn, or: $value.expiresIn),
          scope: data.get(#scope, or: $value.scope),
          createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  XenForoOAuthTokenResponseCopyWith<$R2, XenForoOAuthTokenResponse, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _XenForoOAuthTokenResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
