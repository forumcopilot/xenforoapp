// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'oauth_token.dart';

class OAuthTokenMapper extends ClassMapperBase<OAuthToken> {
  OAuthTokenMapper._();

  static OAuthTokenMapper? _instance;
  static OAuthTokenMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OAuthTokenMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'OAuthToken';

  static String _$accessToken(OAuthToken v) => v.accessToken;
  static const Field<OAuthToken, String> _f$accessToken =
      Field('accessToken', _$accessToken);
  static String? _$refreshToken(OAuthToken v) => v.refreshToken;
  static const Field<OAuthToken, String> _f$refreshToken =
      Field('refreshToken', _$refreshToken, opt: true);
  static String _$tokenType(OAuthToken v) => v.tokenType;
  static const Field<OAuthToken, String> _f$tokenType =
      Field('tokenType', _$tokenType, opt: true, def: 'Bearer');
  static int? _$expiresIn(OAuthToken v) => v.expiresIn;
  static const Field<OAuthToken, int> _f$expiresIn =
      Field('expiresIn', _$expiresIn, opt: true);
  static int? _$expiresAt(OAuthToken v) => v.expiresAt;
  static const Field<OAuthToken, int> _f$expiresAt =
      Field('expiresAt', _$expiresAt, opt: true);
  static List<String>? _$scopes(OAuthToken v) => v.scopes;
  static const Field<OAuthToken, List<String>> _f$scopes =
      Field('scopes', _$scopes, opt: true);

  @override
  final MappableFields<OAuthToken> fields = const {
    #accessToken: _f$accessToken,
    #refreshToken: _f$refreshToken,
    #tokenType: _f$tokenType,
    #expiresIn: _f$expiresIn,
    #expiresAt: _f$expiresAt,
    #scopes: _f$scopes,
  };

  static OAuthToken _instantiate(DecodingData data) {
    return OAuthToken(
        accessToken: data.dec(_f$accessToken),
        refreshToken: data.dec(_f$refreshToken),
        tokenType: data.dec(_f$tokenType),
        expiresIn: data.dec(_f$expiresIn),
        expiresAt: data.dec(_f$expiresAt),
        scopes: data.dec(_f$scopes));
  }

  @override
  final Function instantiate = _instantiate;

  static OAuthToken fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<OAuthToken>(map);
  }

  static OAuthToken fromJson(String json) {
    return ensureInitialized().decodeJson<OAuthToken>(json);
  }
}

mixin OAuthTokenMappable {
  String toJson() {
    return OAuthTokenMapper.ensureInitialized()
        .encodeJson<OAuthToken>(this as OAuthToken);
  }

  Map<String, dynamic> toMap() {
    return OAuthTokenMapper.ensureInitialized()
        .encodeMap<OAuthToken>(this as OAuthToken);
  }

  OAuthTokenCopyWith<OAuthToken, OAuthToken, OAuthToken> get copyWith =>
      _OAuthTokenCopyWithImpl<OAuthToken, OAuthToken>(
          this as OAuthToken, $identity, $identity);
  @override
  String toString() {
    return OAuthTokenMapper.ensureInitialized()
        .stringifyValue(this as OAuthToken);
  }

  @override
  bool operator ==(Object other) {
    return OAuthTokenMapper.ensureInitialized()
        .equalsValue(this as OAuthToken, other);
  }

  @override
  int get hashCode {
    return OAuthTokenMapper.ensureInitialized().hashValue(this as OAuthToken);
  }
}

extension OAuthTokenValueCopy<$R, $Out>
    on ObjectCopyWith<$R, OAuthToken, $Out> {
  OAuthTokenCopyWith<$R, OAuthToken, $Out> get $asOAuthToken =>
      $base.as((v, t, t2) => _OAuthTokenCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class OAuthTokenCopyWith<$R, $In extends OAuthToken, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get scopes;
  $R call(
      {String? accessToken,
      String? refreshToken,
      String? tokenType,
      int? expiresIn,
      int? expiresAt,
      List<String>? scopes});
  OAuthTokenCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _OAuthTokenCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, OAuthToken, $Out>
    implements OAuthTokenCopyWith<$R, OAuthToken, $Out> {
  _OAuthTokenCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<OAuthToken> $mapper =
      OAuthTokenMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get scopes =>
      $value.scopes != null
          ? ListCopyWith($value.scopes!,
              (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(scopes: v))
          : null;
  @override
  $R call(
          {String? accessToken,
          Object? refreshToken = $none,
          String? tokenType,
          Object? expiresIn = $none,
          Object? expiresAt = $none,
          Object? scopes = $none}) =>
      $apply(FieldCopyWithData({
        if (accessToken != null) #accessToken: accessToken,
        if (refreshToken != $none) #refreshToken: refreshToken,
        if (tokenType != null) #tokenType: tokenType,
        if (expiresIn != $none) #expiresIn: expiresIn,
        if (expiresAt != $none) #expiresAt: expiresAt,
        if (scopes != $none) #scopes: scopes
      }));
  @override
  OAuthToken $make(CopyWithData data) => OAuthToken(
      accessToken: data.get(#accessToken, or: $value.accessToken),
      refreshToken: data.get(#refreshToken, or: $value.refreshToken),
      tokenType: data.get(#tokenType, or: $value.tokenType),
      expiresIn: data.get(#expiresIn, or: $value.expiresIn),
      expiresAt: data.get(#expiresAt, or: $value.expiresAt),
      scopes: data.get(#scopes, or: $value.scopes));

  @override
  OAuthTokenCopyWith<$R2, OAuthToken, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _OAuthTokenCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
