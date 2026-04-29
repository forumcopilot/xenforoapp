// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_custom_field_definition.dart';

class FCCustomFieldDefinitionMapper
    extends ClassMapperBase<FCCustomFieldDefinition> {
  FCCustomFieldDefinitionMapper._();

  static FCCustomFieldDefinitionMapper? _instance;
  static FCCustomFieldDefinitionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCCustomFieldDefinitionMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'FCCustomFieldDefinition';

  static String _$name(FCCustomFieldDefinition v) => v.name;
  static const Field<FCCustomFieldDefinition, String> _f$name = Field(
    'name',
    _$name,
  );
  static String _$description(FCCustomFieldDefinition v) => v.description;
  static const Field<FCCustomFieldDefinition, String> _f$description = Field(
    'description',
    _$description,
  );
  static String _$key(FCCustomFieldDefinition v) => v.key;
  static const Field<FCCustomFieldDefinition, String> _f$key = Field(
    'key',
    _$key,
  );
  static String? _$fieldId(FCCustomFieldDefinition v) => v.fieldId;
  static const Field<FCCustomFieldDefinition, String> _f$fieldId = Field(
    'fieldId',
    _$fieldId,
    opt: true,
  );
  static String _$type(FCCustomFieldDefinition v) => v.type;
  static const Field<FCCustomFieldDefinition, String> _f$type = Field(
    'type',
    _$type,
  );
  static String _$format(FCCustomFieldDefinition v) => v.format;
  static const Field<FCCustomFieldDefinition, String> _f$format = Field(
    'format',
    _$format,
  );
  static dynamic _$defaultValue(FCCustomFieldDefinition v) => v.defaultValue;
  static const Field<FCCustomFieldDefinition, dynamic> _f$defaultValue = Field(
    'defaultValue',
    _$defaultValue,
  );
  static String _$options(FCCustomFieldDefinition v) => v.options;
  static const Field<FCCustomFieldDefinition, String> _f$options = Field(
    'options',
    _$options,
  );
  static int? _$displayOrder(FCCustomFieldDefinition v) => v.displayOrder;
  static const Field<FCCustomFieldDefinition, int> _f$displayOrder = Field(
    'displayOrder',
    _$displayOrder,
    opt: true,
  );
  static Map<String, String>? _$choices(FCCustomFieldDefinition v) => v.choices;
  static const Field<FCCustomFieldDefinition, Map<String, String>> _f$choices =
      Field('choices', _$choices, opt: true);
  static bool _$required(FCCustomFieldDefinition v) => v.required;
  static const Field<FCCustomFieldDefinition, bool> _f$required = Field(
    'required',
    _$required,
    opt: true,
    def: false,
  );
  static int? _$maxLength(FCCustomFieldDefinition v) => v.maxLength;
  static const Field<FCCustomFieldDefinition, int> _f$maxLength = Field(
    'maxLength',
    _$maxLength,
    opt: true,
  );

  @override
  final MappableFields<FCCustomFieldDefinition> fields = const {
    #name: _f$name,
    #description: _f$description,
    #key: _f$key,
    #fieldId: _f$fieldId,
    #type: _f$type,
    #format: _f$format,
    #defaultValue: _f$defaultValue,
    #options: _f$options,
    #displayOrder: _f$displayOrder,
    #choices: _f$choices,
    #required: _f$required,
    #maxLength: _f$maxLength,
  };

  static FCCustomFieldDefinition _instantiate(DecodingData data) {
    return FCCustomFieldDefinition(
      name: data.dec(_f$name),
      description: data.dec(_f$description),
      key: data.dec(_f$key),
      fieldId: data.dec(_f$fieldId),
      type: data.dec(_f$type),
      format: data.dec(_f$format),
      defaultValue: data.dec(_f$defaultValue),
      options: data.dec(_f$options),
      displayOrder: data.dec(_f$displayOrder),
      choices: data.dec(_f$choices),
      required: data.dec(_f$required),
      maxLength: data.dec(_f$maxLength),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCCustomFieldDefinition fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCCustomFieldDefinition>(map);
  }

  static FCCustomFieldDefinition fromJson(String json) {
    return ensureInitialized().decodeJson<FCCustomFieldDefinition>(json);
  }
}

mixin FCCustomFieldDefinitionMappable {
  String toJson() {
    return FCCustomFieldDefinitionMapper.ensureInitialized()
        .encodeJson<FCCustomFieldDefinition>(this as FCCustomFieldDefinition);
  }

  Map<String, dynamic> toMap() {
    return FCCustomFieldDefinitionMapper.ensureInitialized()
        .encodeMap<FCCustomFieldDefinition>(this as FCCustomFieldDefinition);
  }

  FCCustomFieldDefinitionCopyWith<
    FCCustomFieldDefinition,
    FCCustomFieldDefinition,
    FCCustomFieldDefinition
  >
  get copyWith =>
      _FCCustomFieldDefinitionCopyWithImpl<
        FCCustomFieldDefinition,
        FCCustomFieldDefinition
      >(this as FCCustomFieldDefinition, $identity, $identity);
  @override
  String toString() {
    return FCCustomFieldDefinitionMapper.ensureInitialized().stringifyValue(
      this as FCCustomFieldDefinition,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCCustomFieldDefinitionMapper.ensureInitialized().equalsValue(
      this as FCCustomFieldDefinition,
      other,
    );
  }

  @override
  int get hashCode {
    return FCCustomFieldDefinitionMapper.ensureInitialized().hashValue(
      this as FCCustomFieldDefinition,
    );
  }
}

extension FCCustomFieldDefinitionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCCustomFieldDefinition, $Out> {
  FCCustomFieldDefinitionCopyWith<$R, FCCustomFieldDefinition, $Out>
  get $asFCCustomFieldDefinition => $base.as(
    (v, t, t2) => _FCCustomFieldDefinitionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCCustomFieldDefinitionCopyWith<
  $R,
  $In extends FCCustomFieldDefinition,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>?
  get choices;
  $R call({
    String? name,
    String? description,
    String? key,
    String? fieldId,
    String? type,
    String? format,
    dynamic defaultValue,
    String? options,
    int? displayOrder,
    Map<String, String>? choices,
    bool? required,
    int? maxLength,
  });
  FCCustomFieldDefinitionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCCustomFieldDefinitionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCCustomFieldDefinition, $Out>
    implements
        FCCustomFieldDefinitionCopyWith<$R, FCCustomFieldDefinition, $Out> {
  _FCCustomFieldDefinitionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCCustomFieldDefinition> $mapper =
      FCCustomFieldDefinitionMapper.ensureInitialized();
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
  $R call({
    String? name,
    String? description,
    String? key,
    Object? fieldId = $none,
    String? type,
    String? format,
    Object? defaultValue = $none,
    String? options,
    Object? displayOrder = $none,
    Object? choices = $none,
    bool? required,
    Object? maxLength = $none,
  }) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (description != null) #description: description,
      if (key != null) #key: key,
      if (fieldId != $none) #fieldId: fieldId,
      if (type != null) #type: type,
      if (format != null) #format: format,
      if (defaultValue != $none) #defaultValue: defaultValue,
      if (options != null) #options: options,
      if (displayOrder != $none) #displayOrder: displayOrder,
      if (choices != $none) #choices: choices,
      if (required != null) #required: required,
      if (maxLength != $none) #maxLength: maxLength,
    }),
  );
  @override
  FCCustomFieldDefinition $make(CopyWithData data) => FCCustomFieldDefinition(
    name: data.get(#name, or: $value.name),
    description: data.get(#description, or: $value.description),
    key: data.get(#key, or: $value.key),
    fieldId: data.get(#fieldId, or: $value.fieldId),
    type: data.get(#type, or: $value.type),
    format: data.get(#format, or: $value.format),
    defaultValue: data.get(#defaultValue, or: $value.defaultValue),
    options: data.get(#options, or: $value.options),
    displayOrder: data.get(#displayOrder, or: $value.displayOrder),
    choices: data.get(#choices, or: $value.choices),
    required: data.get(#required, or: $value.required),
    maxLength: data.get(#maxLength, or: $value.maxLength),
  );

  @override
  FCCustomFieldDefinitionCopyWith<$R2, FCCustomFieldDefinition, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCCustomFieldDefinitionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

