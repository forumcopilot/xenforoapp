// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_request.dart';

class AuthRequestMapper extends ClassMapperBase<AuthRequest> {
  AuthRequestMapper._();

  static AuthRequestMapper? _instance;
  static AuthRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthRequest';

  static String _$login(AuthRequest v) => v.login;
  static const Field<AuthRequest, String> _f$login = Field('login', _$login);
  static String _$password(AuthRequest v) => v.password;
  static const Field<AuthRequest, String> _f$password =
      Field('password', _$password);
  static bool _$remember(AuthRequest v) => v.remember;
  static const Field<AuthRequest, bool> _f$remember =
      Field('remember', _$remember, opt: true, def: false);
  static String? _$trustCode(AuthRequest v) => v.trustCode;
  static const Field<AuthRequest, String> _f$trustCode =
      Field('trustCode', _$trustCode, opt: true);
  static String? _$clientId(AuthRequest v) => v.clientId;
  static const Field<AuthRequest, String> _f$clientId =
      Field('clientId', _$clientId, opt: true);
  static String? _$clientSecret(AuthRequest v) => v.clientSecret;
  static const Field<AuthRequest, String> _f$clientSecret =
      Field('clientSecret', _$clientSecret, opt: true);
  static String? _$redirectUri(AuthRequest v) => v.redirectUri;
  static const Field<AuthRequest, String> _f$redirectUri =
      Field('redirectUri', _$redirectUri, opt: true);
  static List<String>? _$scopes(AuthRequest v) => v.scopes;
  static const Field<AuthRequest, List<String>> _f$scopes =
      Field('scopes', _$scopes, opt: true);

  @override
  final MappableFields<AuthRequest> fields = const {
    #login: _f$login,
    #password: _f$password,
    #remember: _f$remember,
    #trustCode: _f$trustCode,
    #clientId: _f$clientId,
    #clientSecret: _f$clientSecret,
    #redirectUri: _f$redirectUri,
    #scopes: _f$scopes,
  };

  static AuthRequest _instantiate(DecodingData data) {
    return AuthRequest(
        login: data.dec(_f$login),
        password: data.dec(_f$password),
        remember: data.dec(_f$remember),
        trustCode: data.dec(_f$trustCode),
        clientId: data.dec(_f$clientId),
        clientSecret: data.dec(_f$clientSecret),
        redirectUri: data.dec(_f$redirectUri),
        scopes: data.dec(_f$scopes));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthRequest>(map);
  }

  static AuthRequest fromJson(String json) {
    return ensureInitialized().decodeJson<AuthRequest>(json);
  }
}

mixin AuthRequestMappable {
  String toJson() {
    return AuthRequestMapper.ensureInitialized()
        .encodeJson<AuthRequest>(this as AuthRequest);
  }

  Map<String, dynamic> toMap() {
    return AuthRequestMapper.ensureInitialized()
        .encodeMap<AuthRequest>(this as AuthRequest);
  }

  AuthRequestCopyWith<AuthRequest, AuthRequest, AuthRequest> get copyWith =>
      _AuthRequestCopyWithImpl<AuthRequest, AuthRequest>(
          this as AuthRequest, $identity, $identity);
  @override
  String toString() {
    return AuthRequestMapper.ensureInitialized()
        .stringifyValue(this as AuthRequest);
  }

  @override
  bool operator ==(Object other) {
    return AuthRequestMapper.ensureInitialized()
        .equalsValue(this as AuthRequest, other);
  }

  @override
  int get hashCode {
    return AuthRequestMapper.ensureInitialized().hashValue(this as AuthRequest);
  }
}

extension AuthRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthRequest, $Out> {
  AuthRequestCopyWith<$R, AuthRequest, $Out> get $asAuthRequest =>
      $base.as((v, t, t2) => _AuthRequestCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthRequestCopyWith<$R, $In extends AuthRequest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get scopes;
  $R call(
      {String? login,
      String? password,
      bool? remember,
      String? trustCode,
      String? clientId,
      String? clientSecret,
      String? redirectUri,
      List<String>? scopes});
  AuthRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthRequest, $Out>
    implements AuthRequestCopyWith<$R, AuthRequest, $Out> {
  _AuthRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthRequest> $mapper =
      AuthRequestMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get scopes =>
      $value.scopes != null
          ? ListCopyWith($value.scopes!,
              (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(scopes: v))
          : null;
  @override
  $R call(
          {String? login,
          String? password,
          bool? remember,
          Object? trustCode = $none,
          Object? clientId = $none,
          Object? clientSecret = $none,
          Object? redirectUri = $none,
          Object? scopes = $none}) =>
      $apply(FieldCopyWithData({
        if (login != null) #login: login,
        if (password != null) #password: password,
        if (remember != null) #remember: remember,
        if (trustCode != $none) #trustCode: trustCode,
        if (clientId != $none) #clientId: clientId,
        if (clientSecret != $none) #clientSecret: clientSecret,
        if (redirectUri != $none) #redirectUri: redirectUri,
        if (scopes != $none) #scopes: scopes
      }));
  @override
  AuthRequest $make(CopyWithData data) => AuthRequest(
      login: data.get(#login, or: $value.login),
      password: data.get(#password, or: $value.password),
      remember: data.get(#remember, or: $value.remember),
      trustCode: data.get(#trustCode, or: $value.trustCode),
      clientId: data.get(#clientId, or: $value.clientId),
      clientSecret: data.get(#clientSecret, or: $value.clientSecret),
      redirectUri: data.get(#redirectUri, or: $value.redirectUri),
      scopes: data.get(#scopes, or: $value.scopes));

  @override
  AuthRequestCopyWith<$R2, AuthRequest, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AuthRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
