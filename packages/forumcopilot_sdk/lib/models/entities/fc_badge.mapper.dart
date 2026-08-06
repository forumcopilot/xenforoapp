// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_badge.dart';

class FCBadgeMapper extends ClassMapperBase<FCBadge> {
  FCBadgeMapper._();

  static FCBadgeMapper? _instance;
  static FCBadgeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCBadgeMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCBadge';

  static int _$id(FCBadge v) => v.id;
  static const Field<FCBadge, int> _f$id = Field('id', _$id);
  static String _$name(FCBadge v) => v.name;
  static const Field<FCBadge, String> _f$name = Field('name', _$name);
  static String? _$description(FCBadge v) => v.description;
  static const Field<FCBadge, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static String? _$icon(FCBadge v) => v.icon;
  static const Field<FCBadge, String> _f$icon = Field(
    'icon',
    _$icon,
    opt: true,
  );
  static String? _$imageUrl(FCBadge v) => v.imageUrl;
  static const Field<FCBadge, String> _f$imageUrl = Field(
    'imageUrl',
    _$imageUrl,
    opt: true,
  );
  static int _$badgeTypeId(FCBadge v) => v.badgeTypeId;
  static const Field<FCBadge, int> _f$badgeTypeId = Field(
    'badgeTypeId',
    _$badgeTypeId,
    opt: true,
    def: 1,
  );
  static DateTime? _$grantedAt(FCBadge v) => v.grantedAt;
  static const Field<FCBadge, DateTime> _f$grantedAt = Field(
    'grantedAt',
    _$grantedAt,
    opt: true,
  );
  static int _$grantCount(FCBadge v) => v.grantCount;
  static const Field<FCBadge, int> _f$grantCount = Field(
    'grantCount',
    _$grantCount,
    opt: true,
    def: 1,
  );
  static bool _$granted(FCBadge v) => v.granted;
  static const Field<FCBadge, bool> _f$granted = Field(
    'granted',
    _$granted,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCBadge> fields = const {
    #id: _f$id,
    #name: _f$name,
    #description: _f$description,
    #icon: _f$icon,
    #imageUrl: _f$imageUrl,
    #badgeTypeId: _f$badgeTypeId,
    #grantedAt: _f$grantedAt,
    #grantCount: _f$grantCount,
    #granted: _f$granted,
  };

  static FCBadge _instantiate(DecodingData data) {
    return FCBadge(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      description: data.dec(_f$description),
      icon: data.dec(_f$icon),
      imageUrl: data.dec(_f$imageUrl),
      badgeTypeId: data.dec(_f$badgeTypeId),
      grantedAt: data.dec(_f$grantedAt),
      grantCount: data.dec(_f$grantCount),
      granted: data.dec(_f$granted),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCBadge fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCBadge>(map);
  }

  static FCBadge fromJson(String json) {
    return ensureInitialized().decodeJson<FCBadge>(json);
  }
}

mixin FCBadgeMappable {
  String toJson() {
    return FCBadgeMapper.ensureInitialized().encodeJson<FCBadge>(
      this as FCBadge,
    );
  }

  Map<String, dynamic> toMap() {
    return FCBadgeMapper.ensureInitialized().encodeMap<FCBadge>(
      this as FCBadge,
    );
  }

  FCBadgeCopyWith<FCBadge, FCBadge, FCBadge> get copyWith =>
      _FCBadgeCopyWithImpl<FCBadge, FCBadge>(
        this as FCBadge,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCBadgeMapper.ensureInitialized().stringifyValue(this as FCBadge);
  }

  @override
  bool operator ==(Object other) {
    return FCBadgeMapper.ensureInitialized().equalsValue(
      this as FCBadge,
      other,
    );
  }

  @override
  int get hashCode {
    return FCBadgeMapper.ensureInitialized().hashValue(this as FCBadge);
  }
}

extension FCBadgeValueCopy<$R, $Out> on ObjectCopyWith<$R, FCBadge, $Out> {
  FCBadgeCopyWith<$R, FCBadge, $Out> get $asFCBadge =>
      $base.as((v, t, t2) => _FCBadgeCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCBadgeCopyWith<$R, $In extends FCBadge, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? id,
    String? name,
    String? description,
    String? icon,
    String? imageUrl,
    int? badgeTypeId,
    DateTime? grantedAt,
    int? grantCount,
    bool? granted,
  });
  FCBadgeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCBadgeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCBadge, $Out>
    implements FCBadgeCopyWith<$R, FCBadge, $Out> {
  _FCBadgeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCBadge> $mapper =
      FCBadgeMapper.ensureInitialized();
  @override
  $R call({
    int? id,
    String? name,
    Object? description = $none,
    Object? icon = $none,
    Object? imageUrl = $none,
    int? badgeTypeId,
    Object? grantedAt = $none,
    int? grantCount,
    bool? granted,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (description != $none) #description: description,
      if (icon != $none) #icon: icon,
      if (imageUrl != $none) #imageUrl: imageUrl,
      if (badgeTypeId != null) #badgeTypeId: badgeTypeId,
      if (grantedAt != $none) #grantedAt: grantedAt,
      if (grantCount != null) #grantCount: grantCount,
      if (granted != null) #granted: granted,
    }),
  );
  @override
  FCBadge $make(CopyWithData data) => FCBadge(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    description: data.get(#description, or: $value.description),
    icon: data.get(#icon, or: $value.icon),
    imageUrl: data.get(#imageUrl, or: $value.imageUrl),
    badgeTypeId: data.get(#badgeTypeId, or: $value.badgeTypeId),
    grantedAt: data.get(#grantedAt, or: $value.grantedAt),
    grantCount: data.get(#grantCount, or: $value.grantCount),
    granted: data.get(#granted, or: $value.granted),
  );

  @override
  FCBadgeCopyWith<$R2, FCBadge, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCBadgeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

