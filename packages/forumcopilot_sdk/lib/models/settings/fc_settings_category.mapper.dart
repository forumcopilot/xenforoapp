// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_settings_category.dart';

class FCSettingsCategoryMapper extends ClassMapperBase<FCSettingsCategory> {
  FCSettingsCategoryMapper._();

  static FCSettingsCategoryMapper? _instance;
  static FCSettingsCategoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSettingsCategoryMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCSettingsCategory';

  static String _$key(FCSettingsCategory v) => v.key;
  static const Field<FCSettingsCategory, String> _f$key = Field('key', _$key);
  static String _$displayName(FCSettingsCategory v) => v.displayName;
  static const Field<FCSettingsCategory, String> _f$displayName = Field(
    'displayName',
    _$displayName,
  );
  static String _$description(FCSettingsCategory v) => v.description;
  static const Field<FCSettingsCategory, String> _f$description = Field(
    'description',
    _$description,
  );
  static bool _$enabled(FCSettingsCategory v) => v.enabled;
  static const Field<FCSettingsCategory, bool> _f$enabled = Field(
    'enabled',
    _$enabled,
  );

  @override
  final MappableFields<FCSettingsCategory> fields = const {
    #key: _f$key,
    #displayName: _f$displayName,
    #description: _f$description,
    #enabled: _f$enabled,
  };

  static FCSettingsCategory _instantiate(DecodingData data) {
    return FCSettingsCategory(
      key: data.dec(_f$key),
      displayName: data.dec(_f$displayName),
      description: data.dec(_f$description),
      enabled: data.dec(_f$enabled),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSettingsCategory fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSettingsCategory>(map);
  }

  static FCSettingsCategory fromJson(String json) {
    return ensureInitialized().decodeJson<FCSettingsCategory>(json);
  }
}

mixin FCSettingsCategoryMappable {
  String toJson() {
    return FCSettingsCategoryMapper.ensureInitialized()
        .encodeJson<FCSettingsCategory>(this as FCSettingsCategory);
  }

  Map<String, dynamic> toMap() {
    return FCSettingsCategoryMapper.ensureInitialized()
        .encodeMap<FCSettingsCategory>(this as FCSettingsCategory);
  }

  FCSettingsCategoryCopyWith<
    FCSettingsCategory,
    FCSettingsCategory,
    FCSettingsCategory
  >
  get copyWith =>
      _FCSettingsCategoryCopyWithImpl<FCSettingsCategory, FCSettingsCategory>(
        this as FCSettingsCategory,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCSettingsCategoryMapper.ensureInitialized().stringifyValue(
      this as FCSettingsCategory,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSettingsCategoryMapper.ensureInitialized().equalsValue(
      this as FCSettingsCategory,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSettingsCategoryMapper.ensureInitialized().hashValue(
      this as FCSettingsCategory,
    );
  }
}

extension FCSettingsCategoryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSettingsCategory, $Out> {
  FCSettingsCategoryCopyWith<$R, FCSettingsCategory, $Out>
  get $asFCSettingsCategory => $base.as(
    (v, t, t2) => _FCSettingsCategoryCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSettingsCategoryCopyWith<
  $R,
  $In extends FCSettingsCategory,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? key,
    String? displayName,
    String? description,
    bool? enabled,
  });
  FCSettingsCategoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSettingsCategoryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSettingsCategory, $Out>
    implements FCSettingsCategoryCopyWith<$R, FCSettingsCategory, $Out> {
  _FCSettingsCategoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSettingsCategory> $mapper =
      FCSettingsCategoryMapper.ensureInitialized();
  @override
  $R call({
    String? key,
    String? displayName,
    String? description,
    bool? enabled,
  }) => $apply(
    FieldCopyWithData({
      if (key != null) #key: key,
      if (displayName != null) #displayName: displayName,
      if (description != null) #description: description,
      if (enabled != null) #enabled: enabled,
    }),
  );
  @override
  FCSettingsCategory $make(CopyWithData data) => FCSettingsCategory(
    key: data.get(#key, or: $value.key),
    displayName: data.get(#displayName, or: $value.displayName),
    description: data.get(#description, or: $value.description),
    enabled: data.get(#enabled, or: $value.enabled),
  );

  @override
  FCSettingsCategoryCopyWith<$R2, FCSettingsCategory, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCSettingsCategoryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

