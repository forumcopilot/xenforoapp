// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_thanks.dart';

class FCThanksMapper extends ClassMapperBase<FCThanks> {
  FCThanksMapper._();

  static FCThanksMapper? _instance;
  static FCThanksMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCThanksMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCThanks';

  static String _$userId(FCThanks v) => v.userId;
  static const Field<FCThanks, String> _f$userId = Field('userId', _$userId);
  static String _$username(FCThanks v) => v.username;
  static const Field<FCThanks, String> _f$username = Field(
    'username',
    _$username,
  );
  static String _$avatarUrl(FCThanks v) => v.avatarUrl;
  static const Field<FCThanks, String> _f$avatarUrl = Field(
    'avatarUrl',
    _$avatarUrl,
  );
  static DateTime? _$timestamp(FCThanks v) => v.timestamp;
  static const Field<FCThanks, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
    opt: true,
  );

  @override
  final MappableFields<FCThanks> fields = const {
    #userId: _f$userId,
    #username: _f$username,
    #avatarUrl: _f$avatarUrl,
    #timestamp: _f$timestamp,
  };

  static FCThanks _instantiate(DecodingData data) {
    return FCThanks(
      userId: data.dec(_f$userId),
      username: data.dec(_f$username),
      avatarUrl: data.dec(_f$avatarUrl),
      timestamp: data.dec(_f$timestamp),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCThanks fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCThanks>(map);
  }

  static FCThanks fromJson(String json) {
    return ensureInitialized().decodeJson<FCThanks>(json);
  }
}

mixin FCThanksMappable {
  String toJson() {
    return FCThanksMapper.ensureInitialized().encodeJson<FCThanks>(
      this as FCThanks,
    );
  }

  Map<String, dynamic> toMap() {
    return FCThanksMapper.ensureInitialized().encodeMap<FCThanks>(
      this as FCThanks,
    );
  }

  FCThanksCopyWith<FCThanks, FCThanks, FCThanks> get copyWith =>
      _FCThanksCopyWithImpl<FCThanks, FCThanks>(
        this as FCThanks,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCThanksMapper.ensureInitialized().stringifyValue(this as FCThanks);
  }

  @override
  bool operator ==(Object other) {
    return FCThanksMapper.ensureInitialized().equalsValue(
      this as FCThanks,
      other,
    );
  }

  @override
  int get hashCode {
    return FCThanksMapper.ensureInitialized().hashValue(this as FCThanks);
  }
}

extension FCThanksValueCopy<$R, $Out> on ObjectCopyWith<$R, FCThanks, $Out> {
  FCThanksCopyWith<$R, FCThanks, $Out> get $asFCThanks =>
      $base.as((v, t, t2) => _FCThanksCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCThanksCopyWith<$R, $In extends FCThanks, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? userId,
    String? username,
    String? avatarUrl,
    DateTime? timestamp,
  });
  FCThanksCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCThanksCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCThanks, $Out>
    implements FCThanksCopyWith<$R, FCThanks, $Out> {
  _FCThanksCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCThanks> $mapper =
      FCThanksMapper.ensureInitialized();
  @override
  $R call({
    String? userId,
    String? username,
    String? avatarUrl,
    Object? timestamp = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (username != null) #username: username,
      if (avatarUrl != null) #avatarUrl: avatarUrl,
      if (timestamp != $none) #timestamp: timestamp,
    }),
  );
  @override
  FCThanks $make(CopyWithData data) => FCThanks(
    userId: data.get(#userId, or: $value.userId),
    username: data.get(#username, or: $value.username),
    avatarUrl: data.get(#avatarUrl, or: $value.avatarUrl),
    timestamp: data.get(#timestamp, or: $value.timestamp),
  );

  @override
  FCThanksCopyWith<$R2, FCThanks, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCThanksCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

