// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_user_setting.dart';

class FCSettingDependencyMapper extends ClassMapperBase<FCSettingDependency> {
  FCSettingDependencyMapper._();

  static FCSettingDependencyMapper? _instance;
  static FCSettingDependencyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSettingDependencyMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCSettingDependency';

  static String _$key(FCSettingDependency v) => v.key;
  static const Field<FCSettingDependency, String> _f$key = Field('key', _$key);
  static dynamic _$value(FCSettingDependency v) => v.value;
  static const Field<FCSettingDependency, dynamic> _f$value = Field(
    'value',
    _$value,
  );

  @override
  final MappableFields<FCSettingDependency> fields = const {
    #key: _f$key,
    #value: _f$value,
  };

  static FCSettingDependency _instantiate(DecodingData data) {
    return FCSettingDependency(
      key: data.dec(_f$key),
      value: data.dec(_f$value),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSettingDependency fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSettingDependency>(map);
  }

  static FCSettingDependency fromJson(String json) {
    return ensureInitialized().decodeJson<FCSettingDependency>(json);
  }
}

mixin FCSettingDependencyMappable {
  String toJson() {
    return FCSettingDependencyMapper.ensureInitialized()
        .encodeJson<FCSettingDependency>(this as FCSettingDependency);
  }

  Map<String, dynamic> toMap() {
    return FCSettingDependencyMapper.ensureInitialized()
        .encodeMap<FCSettingDependency>(this as FCSettingDependency);
  }

  FCSettingDependencyCopyWith<
    FCSettingDependency,
    FCSettingDependency,
    FCSettingDependency
  >
  get copyWith =>
      _FCSettingDependencyCopyWithImpl<
        FCSettingDependency,
        FCSettingDependency
      >(this as FCSettingDependency, $identity, $identity);
  @override
  String toString() {
    return FCSettingDependencyMapper.ensureInitialized().stringifyValue(
      this as FCSettingDependency,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSettingDependencyMapper.ensureInitialized().equalsValue(
      this as FCSettingDependency,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSettingDependencyMapper.ensureInitialized().hashValue(
      this as FCSettingDependency,
    );
  }
}

extension FCSettingDependencyValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSettingDependency, $Out> {
  FCSettingDependencyCopyWith<$R, FCSettingDependency, $Out>
  get $asFCSettingDependency => $base.as(
    (v, t, t2) => _FCSettingDependencyCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSettingDependencyCopyWith<
  $R,
  $In extends FCSettingDependency,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? key, dynamic value});
  FCSettingDependencyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSettingDependencyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSettingDependency, $Out>
    implements FCSettingDependencyCopyWith<$R, FCSettingDependency, $Out> {
  _FCSettingDependencyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSettingDependency> $mapper =
      FCSettingDependencyMapper.ensureInitialized();
  @override
  $R call({String? key, Object? value = $none}) => $apply(
    FieldCopyWithData({
      if (key != null) #key: key,
      if (value != $none) #value: value,
    }),
  );
  @override
  FCSettingDependency $make(CopyWithData data) => FCSettingDependency(
    key: data.get(#key, or: $value.key),
    value: data.get(#value, or: $value.value),
  );

  @override
  FCSettingDependencyCopyWith<$R2, FCSettingDependency, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCSettingDependencyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUserSettingMapper extends ClassMapperBase<FCUserSetting> {
  FCUserSettingMapper._();

  static FCUserSettingMapper? _instance;
  static FCUserSettingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUserSettingMapper._());
      FCSettingDependencyMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUserSetting';

  static String _$fieldId(FCUserSetting v) => v.fieldId;
  static const Field<FCUserSetting, String> _f$fieldId = Field(
    'fieldId',
    _$fieldId,
  );
  static String _$title(FCUserSetting v) => v.title;
  static const Field<FCUserSetting, String> _f$title = Field('title', _$title);
  static String _$description(FCUserSetting v) => v.description;
  static const Field<FCUserSetting, String> _f$description = Field(
    'description',
    _$description,
  );
  static String _$fieldType(FCUserSetting v) => v.fieldType;
  static const Field<FCUserSetting, String> _f$fieldType = Field(
    'fieldType',
    _$fieldType,
  );
  static String _$dataType(FCUserSetting v) => v.dataType;
  static const Field<FCUserSetting, String> _f$dataType = Field(
    'dataType',
    _$dataType,
  );
  static dynamic _$value(FCUserSetting v) => v.value;
  static const Field<FCUserSetting, dynamic> _f$value = Field('value', _$value);
  static dynamic _$defaultValue(FCUserSetting v) => v.defaultValue;
  static const Field<FCUserSetting, dynamic> _f$defaultValue = Field(
    'defaultValue',
    _$defaultValue,
  );
  static Map<String, String>? _$choices(FCUserSetting v) => v.choices;
  static const Field<FCUserSetting, Map<String, String>> _f$choices = Field(
    'choices',
    _$choices,
    opt: true,
  );
  static bool _$required(FCUserSetting v) => v.required;
  static const Field<FCUserSetting, bool> _f$required = Field(
    'required',
    _$required,
    opt: true,
    def: false,
  );
  static bool _$readOnly(FCUserSetting v) => v.readOnly;
  static const Field<FCUserSetting, bool> _f$readOnly = Field(
    'readOnly',
    _$readOnly,
    opt: true,
    def: false,
  );
  static int? _$maxLength(FCUserSetting v) => v.maxLength;
  static const Field<FCUserSetting, int> _f$maxLength = Field(
    'maxLength',
    _$maxLength,
    opt: true,
  );
  static String? _$matchType(FCUserSetting v) => v.matchType;
  static const Field<FCUserSetting, String> _f$matchType = Field(
    'matchType',
    _$matchType,
    opt: true,
  );
  static Map<String, dynamic>? _$matchParams(FCUserSetting v) => v.matchParams;
  static const Field<FCUserSetting, Map<String, dynamic>> _f$matchParams =
      Field('matchParams', _$matchParams, opt: true);
  static num? _$min(FCUserSetting v) => v.min;
  static const Field<FCUserSetting, num> _f$min = Field(
    'min',
    _$min,
    opt: true,
  );
  static num? _$max(FCUserSetting v) => v.max;
  static const Field<FCUserSetting, num> _f$max = Field(
    'max',
    _$max,
    opt: true,
  );
  static String? _$pattern(FCUserSetting v) => v.pattern;
  static const Field<FCUserSetting, String> _f$pattern = Field(
    'pattern',
    _$pattern,
    opt: true,
  );
  static String? _$placeholder(FCUserSetting v) => v.placeholder;
  static const Field<FCUserSetting, String> _f$placeholder = Field(
    'placeholder',
    _$placeholder,
    opt: true,
  );
  static int _$displayOrder(FCUserSetting v) => v.displayOrder;
  static const Field<FCUserSetting, int> _f$displayOrder = Field(
    'displayOrder',
    _$displayOrder,
    opt: true,
    def: 0,
  );
  static String? _$group(FCUserSetting v) => v.group;
  static const Field<FCUserSetting, String> _f$group = Field(
    'group',
    _$group,
    opt: true,
  );
  static FCSettingDependency? _$dependsOn(FCUserSetting v) => v.dependsOn;
  static const Field<FCUserSetting, FCSettingDependency> _f$dependsOn = Field(
    'dependsOn',
    _$dependsOn,
    opt: true,
  );

  @override
  final MappableFields<FCUserSetting> fields = const {
    #fieldId: _f$fieldId,
    #title: _f$title,
    #description: _f$description,
    #fieldType: _f$fieldType,
    #dataType: _f$dataType,
    #value: _f$value,
    #defaultValue: _f$defaultValue,
    #choices: _f$choices,
    #required: _f$required,
    #readOnly: _f$readOnly,
    #maxLength: _f$maxLength,
    #matchType: _f$matchType,
    #matchParams: _f$matchParams,
    #min: _f$min,
    #max: _f$max,
    #pattern: _f$pattern,
    #placeholder: _f$placeholder,
    #displayOrder: _f$displayOrder,
    #group: _f$group,
    #dependsOn: _f$dependsOn,
  };

  static FCUserSetting _instantiate(DecodingData data) {
    return FCUserSetting(
      fieldId: data.dec(_f$fieldId),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      fieldType: data.dec(_f$fieldType),
      dataType: data.dec(_f$dataType),
      value: data.dec(_f$value),
      defaultValue: data.dec(_f$defaultValue),
      choices: data.dec(_f$choices),
      required: data.dec(_f$required),
      readOnly: data.dec(_f$readOnly),
      maxLength: data.dec(_f$maxLength),
      matchType: data.dec(_f$matchType),
      matchParams: data.dec(_f$matchParams),
      min: data.dec(_f$min),
      max: data.dec(_f$max),
      pattern: data.dec(_f$pattern),
      placeholder: data.dec(_f$placeholder),
      displayOrder: data.dec(_f$displayOrder),
      group: data.dec(_f$group),
      dependsOn: data.dec(_f$dependsOn),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUserSetting fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUserSetting>(map);
  }

  static FCUserSetting fromJson(String json) {
    return ensureInitialized().decodeJson<FCUserSetting>(json);
  }
}

mixin FCUserSettingMappable {
  String toJson() {
    return FCUserSettingMapper.ensureInitialized().encodeJson<FCUserSetting>(
      this as FCUserSetting,
    );
  }

  Map<String, dynamic> toMap() {
    return FCUserSettingMapper.ensureInitialized().encodeMap<FCUserSetting>(
      this as FCUserSetting,
    );
  }

  FCUserSettingCopyWith<FCUserSetting, FCUserSetting, FCUserSetting>
  get copyWith => _FCUserSettingCopyWithImpl<FCUserSetting, FCUserSetting>(
    this as FCUserSetting,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCUserSettingMapper.ensureInitialized().stringifyValue(
      this as FCUserSetting,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUserSettingMapper.ensureInitialized().equalsValue(
      this as FCUserSetting,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUserSettingMapper.ensureInitialized().hashValue(
      this as FCUserSetting,
    );
  }
}

extension FCUserSettingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUserSetting, $Out> {
  FCUserSettingCopyWith<$R, FCUserSetting, $Out> get $asFCUserSetting =>
      $base.as((v, t, t2) => _FCUserSettingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCUserSettingCopyWith<$R, $In extends FCUserSetting, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>?
  get choices;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get matchParams;
  FCSettingDependencyCopyWith<$R, FCSettingDependency, FCSettingDependency>?
  get dependsOn;
  $R call({
    String? fieldId,
    String? title,
    String? description,
    String? fieldType,
    String? dataType,
    dynamic value,
    dynamic defaultValue,
    Map<String, String>? choices,
    bool? required,
    bool? readOnly,
    int? maxLength,
    String? matchType,
    Map<String, dynamic>? matchParams,
    num? min,
    num? max,
    String? pattern,
    String? placeholder,
    int? displayOrder,
    String? group,
    FCSettingDependency? dependsOn,
  });
  FCUserSettingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCUserSettingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUserSetting, $Out>
    implements FCUserSettingCopyWith<$R, FCUserSetting, $Out> {
  _FCUserSettingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUserSetting> $mapper =
      FCUserSettingMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>?
  get choices => $value.choices != null
      ? MapCopyWith(
          $value.choices!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(choices: v),
        )
      : null;
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get matchParams => $value.matchParams != null
      ? MapCopyWith(
          $value.matchParams!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(matchParams: v),
        )
      : null;
  @override
  FCSettingDependencyCopyWith<$R, FCSettingDependency, FCSettingDependency>?
  get dependsOn => $value.dependsOn?.copyWith.$chain((v) => call(dependsOn: v));
  @override
  $R call({
    String? fieldId,
    String? title,
    String? description,
    String? fieldType,
    String? dataType,
    Object? value = $none,
    Object? defaultValue = $none,
    Object? choices = $none,
    bool? required,
    bool? readOnly,
    Object? maxLength = $none,
    Object? matchType = $none,
    Object? matchParams = $none,
    Object? min = $none,
    Object? max = $none,
    Object? pattern = $none,
    Object? placeholder = $none,
    int? displayOrder,
    Object? group = $none,
    Object? dependsOn = $none,
  }) => $apply(
    FieldCopyWithData({
      if (fieldId != null) #fieldId: fieldId,
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (fieldType != null) #fieldType: fieldType,
      if (dataType != null) #dataType: dataType,
      if (value != $none) #value: value,
      if (defaultValue != $none) #defaultValue: defaultValue,
      if (choices != $none) #choices: choices,
      if (required != null) #required: required,
      if (readOnly != null) #readOnly: readOnly,
      if (maxLength != $none) #maxLength: maxLength,
      if (matchType != $none) #matchType: matchType,
      if (matchParams != $none) #matchParams: matchParams,
      if (min != $none) #min: min,
      if (max != $none) #max: max,
      if (pattern != $none) #pattern: pattern,
      if (placeholder != $none) #placeholder: placeholder,
      if (displayOrder != null) #displayOrder: displayOrder,
      if (group != $none) #group: group,
      if (dependsOn != $none) #dependsOn: dependsOn,
    }),
  );
  @override
  FCUserSetting $make(CopyWithData data) => FCUserSetting(
    fieldId: data.get(#fieldId, or: $value.fieldId),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    fieldType: data.get(#fieldType, or: $value.fieldType),
    dataType: data.get(#dataType, or: $value.dataType),
    value: data.get(#value, or: $value.value),
    defaultValue: data.get(#defaultValue, or: $value.defaultValue),
    choices: data.get(#choices, or: $value.choices),
    required: data.get(#required, or: $value.required),
    readOnly: data.get(#readOnly, or: $value.readOnly),
    maxLength: data.get(#maxLength, or: $value.maxLength),
    matchType: data.get(#matchType, or: $value.matchType),
    matchParams: data.get(#matchParams, or: $value.matchParams),
    min: data.get(#min, or: $value.min),
    max: data.get(#max, or: $value.max),
    pattern: data.get(#pattern, or: $value.pattern),
    placeholder: data.get(#placeholder, or: $value.placeholder),
    displayOrder: data.get(#displayOrder, or: $value.displayOrder),
    group: data.get(#group, or: $value.group),
    dependsOn: data.get(#dependsOn, or: $value.dependsOn),
  );

  @override
  FCUserSettingCopyWith<$R2, FCUserSetting, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCUserSettingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

