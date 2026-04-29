// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_like.dart';

class FCLikeMapper extends ClassMapperBase<FCLike> {
  FCLikeMapper._();

  static FCLikeMapper? _instance;
  static FCLikeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCLikeMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCLike';

  static String _$userId(FCLike v) => v.userId;
  static const Field<FCLike, String> _f$userId = Field('userId', _$userId);
  static String _$username(FCLike v) => v.username;
  static const Field<FCLike, String> _f$username = Field(
    'username',
    _$username,
  );
  static String _$avatarUrl(FCLike v) => v.avatarUrl;
  static const Field<FCLike, String> _f$avatarUrl = Field(
    'avatarUrl',
    _$avatarUrl,
  );
  static DateTime? _$timestamp(FCLike v) => v.timestamp;
  static const Field<FCLike, DateTime> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
    opt: true,
  );
  static int? _$reactionId(FCLike v) => v.reactionId;
  static const Field<FCLike, int> _f$reactionId = Field(
    'reactionId',
    _$reactionId,
    opt: true,
  );
  static String? _$reactionName(FCLike v) => v.reactionName;
  static const Field<FCLike, String> _f$reactionName = Field(
    'reactionName',
    _$reactionName,
    opt: true,
  );
  static String? _$reactionEmoji(FCLike v) => v.reactionEmoji;
  static const Field<FCLike, String> _f$reactionEmoji = Field(
    'reactionEmoji',
    _$reactionEmoji,
    opt: true,
  );
  static String? _$reactionIconUrl(FCLike v) => v.reactionIconUrl;
  static const Field<FCLike, String> _f$reactionIconUrl = Field(
    'reactionIconUrl',
    _$reactionIconUrl,
    opt: true,
  );

  @override
  final MappableFields<FCLike> fields = const {
    #userId: _f$userId,
    #username: _f$username,
    #avatarUrl: _f$avatarUrl,
    #timestamp: _f$timestamp,
    #reactionId: _f$reactionId,
    #reactionName: _f$reactionName,
    #reactionEmoji: _f$reactionEmoji,
    #reactionIconUrl: _f$reactionIconUrl,
  };

  static FCLike _instantiate(DecodingData data) {
    return FCLike(
      userId: data.dec(_f$userId),
      username: data.dec(_f$username),
      avatarUrl: data.dec(_f$avatarUrl),
      timestamp: data.dec(_f$timestamp),
      reactionId: data.dec(_f$reactionId),
      reactionName: data.dec(_f$reactionName),
      reactionEmoji: data.dec(_f$reactionEmoji),
      reactionIconUrl: data.dec(_f$reactionIconUrl),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCLike fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCLike>(map);
  }

  static FCLike fromJson(String json) {
    return ensureInitialized().decodeJson<FCLike>(json);
  }
}

mixin FCLikeMappable {
  String toJson() {
    return FCLikeMapper.ensureInitialized().encodeJson<FCLike>(this as FCLike);
  }

  Map<String, dynamic> toMap() {
    return FCLikeMapper.ensureInitialized().encodeMap<FCLike>(this as FCLike);
  }

  FCLikeCopyWith<FCLike, FCLike, FCLike> get copyWith =>
      _FCLikeCopyWithImpl<FCLike, FCLike>(this as FCLike, $identity, $identity);
  @override
  String toString() {
    return FCLikeMapper.ensureInitialized().stringifyValue(this as FCLike);
  }

  @override
  bool operator ==(Object other) {
    return FCLikeMapper.ensureInitialized().equalsValue(this as FCLike, other);
  }

  @override
  int get hashCode {
    return FCLikeMapper.ensureInitialized().hashValue(this as FCLike);
  }
}

extension FCLikeValueCopy<$R, $Out> on ObjectCopyWith<$R, FCLike, $Out> {
  FCLikeCopyWith<$R, FCLike, $Out> get $asFCLike =>
      $base.as((v, t, t2) => _FCLikeCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCLikeCopyWith<$R, $In extends FCLike, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? userId,
    String? username,
    String? avatarUrl,
    DateTime? timestamp,
    int? reactionId,
    String? reactionName,
    String? reactionEmoji,
    String? reactionIconUrl,
  });
  FCLikeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCLikeCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, FCLike, $Out>
    implements FCLikeCopyWith<$R, FCLike, $Out> {
  _FCLikeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCLike> $mapper = FCLikeMapper.ensureInitialized();
  @override
  $R call({
    String? userId,
    String? username,
    String? avatarUrl,
    Object? timestamp = $none,
    Object? reactionId = $none,
    Object? reactionName = $none,
    Object? reactionEmoji = $none,
    Object? reactionIconUrl = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (username != null) #username: username,
      if (avatarUrl != null) #avatarUrl: avatarUrl,
      if (timestamp != $none) #timestamp: timestamp,
      if (reactionId != $none) #reactionId: reactionId,
      if (reactionName != $none) #reactionName: reactionName,
      if (reactionEmoji != $none) #reactionEmoji: reactionEmoji,
      if (reactionIconUrl != $none) #reactionIconUrl: reactionIconUrl,
    }),
  );
  @override
  FCLike $make(CopyWithData data) => FCLike(
    userId: data.get(#userId, or: $value.userId),
    username: data.get(#username, or: $value.username),
    avatarUrl: data.get(#avatarUrl, or: $value.avatarUrl),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    reactionId: data.get(#reactionId, or: $value.reactionId),
    reactionName: data.get(#reactionName, or: $value.reactionName),
    reactionEmoji: data.get(#reactionEmoji, or: $value.reactionEmoji),
    reactionIconUrl: data.get(#reactionIconUrl, or: $value.reactionIconUrl),
  );

  @override
  FCLikeCopyWith<$R2, FCLike, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCLikeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

