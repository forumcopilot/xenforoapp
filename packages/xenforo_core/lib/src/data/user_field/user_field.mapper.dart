// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_field.dart';

class XenForoUserFieldMapper extends ClassMapperBase<XenForoUserField> {
  XenForoUserFieldMapper._();

  static XenForoUserFieldMapper? _instance;
  static XenForoUserFieldMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoUserFieldMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoUserField';

  static String _$fieldId(XenForoUserField v) => v.fieldId;
  static const Field<XenForoUserField, String> _f$fieldId = Field(
    'fieldId',
    _$fieldId,
  );
  static String? _$title(XenForoUserField v) => v.title;
  static const Field<XenForoUserField, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
  );
  static String? _$description(XenForoUserField v) => v.description;
  static const Field<XenForoUserField, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static int? _$displayOrder(XenForoUserField v) => v.displayOrder;
  static const Field<XenForoUserField, int> _f$displayOrder = Field(
    'displayOrder',
    _$displayOrder,
    opt: true,
  );
  static String? _$fieldType(XenForoUserField v) => v.fieldType;
  static const Field<XenForoUserField, String> _f$fieldType = Field(
    'fieldType',
    _$fieldType,
    opt: true,
  );
  static Map<String, dynamic>? _$fieldChoices(XenForoUserField v) =>
      v.fieldChoices;
  static const Field<XenForoUserField, Map<String, dynamic>> _f$fieldChoices =
      Field('fieldChoices', _$fieldChoices, opt: true);
  static String? _$matchType(XenForoUserField v) => v.matchType;
  static const Field<XenForoUserField, String> _f$matchType = Field(
    'matchType',
    _$matchType,
    opt: true,
  );
  static List<dynamic>? _$matchParams(XenForoUserField v) => v.matchParams;
  static const Field<XenForoUserField, List<dynamic>> _f$matchParams = Field(
    'matchParams',
    _$matchParams,
    opt: true,
  );
  static int? _$maxLength(XenForoUserField v) => v.maxLength;
  static const Field<XenForoUserField, int> _f$maxLength = Field(
    'maxLength',
    _$maxLength,
    opt: true,
  );
  static bool? _$required(XenForoUserField v) => v.required;
  static const Field<XenForoUserField, bool> _f$required = Field(
    'required',
    _$required,
    opt: true,
  );
  static String? _$displayGroup(XenForoUserField v) => v.displayGroup;
  static const Field<XenForoUserField, String> _f$displayGroup = Field(
    'displayGroup',
    _$displayGroup,
    opt: true,
  );

  @override
  final MappableFields<XenForoUserField> fields = const {
    #fieldId: _f$fieldId,
    #title: _f$title,
    #description: _f$description,
    #displayOrder: _f$displayOrder,
    #fieldType: _f$fieldType,
    #fieldChoices: _f$fieldChoices,
    #matchType: _f$matchType,
    #matchParams: _f$matchParams,
    #maxLength: _f$maxLength,
    #required: _f$required,
    #displayGroup: _f$displayGroup,
  };

  static XenForoUserField _instantiate(DecodingData data) {
    return XenForoUserField(
      fieldId: data.dec(_f$fieldId),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      displayOrder: data.dec(_f$displayOrder),
      fieldType: data.dec(_f$fieldType),
      fieldChoices: data.dec(_f$fieldChoices),
      matchType: data.dec(_f$matchType),
      matchParams: data.dec(_f$matchParams),
      maxLength: data.dec(_f$maxLength),
      required: data.dec(_f$required),
      displayGroup: data.dec(_f$displayGroup),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoUserField fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoUserField>(map);
  }

  static XenForoUserField fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoUserField>(json);
  }
}

mixin XenForoUserFieldMappable {
  String toJson() {
    return XenForoUserFieldMapper.ensureInitialized()
        .encodeJson<XenForoUserField>(this as XenForoUserField);
  }

  Map<String, dynamic> toMap() {
    return XenForoUserFieldMapper.ensureInitialized()
        .encodeMap<XenForoUserField>(this as XenForoUserField);
  }

  XenForoUserFieldCopyWith<XenForoUserField, XenForoUserField, XenForoUserField>
  get copyWith =>
      _XenForoUserFieldCopyWithImpl<XenForoUserField, XenForoUserField>(
        this as XenForoUserField,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return XenForoUserFieldMapper.ensureInitialized().stringifyValue(
      this as XenForoUserField,
    );
  }

  @override
  bool operator ==(Object other) {
    return XenForoUserFieldMapper.ensureInitialized().equalsValue(
      this as XenForoUserField,
      other,
    );
  }

  @override
  int get hashCode {
    return XenForoUserFieldMapper.ensureInitialized().hashValue(
      this as XenForoUserField,
    );
  }
}

extension XenForoUserFieldValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoUserField, $Out> {
  XenForoUserFieldCopyWith<$R, XenForoUserField, $Out>
  get $asXenForoUserField =>
      $base.as((v, t, t2) => _XenForoUserFieldCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoUserFieldCopyWith<$R, $In extends XenForoUserField, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get fieldChoices;
  ListCopyWith<$R, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get matchParams;
  $R call({
    String? fieldId,
    String? title,
    String? description,
    int? displayOrder,
    String? fieldType,
    Map<String, dynamic>? fieldChoices,
    String? matchType,
    List<dynamic>? matchParams,
    int? maxLength,
    bool? required,
    String? displayGroup,
  });
  XenForoUserFieldCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _XenForoUserFieldCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoUserField, $Out>
    implements XenForoUserFieldCopyWith<$R, XenForoUserField, $Out> {
  _XenForoUserFieldCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoUserField> $mapper =
      XenForoUserFieldMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get fieldChoices => $value.fieldChoices != null
      ? MapCopyWith(
          $value.fieldChoices!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(fieldChoices: v),
        )
      : null;
  @override
  ListCopyWith<$R, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get matchParams => $value.matchParams != null
      ? ListCopyWith(
          $value.matchParams!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(matchParams: v),
        )
      : null;
  @override
  $R call({
    String? fieldId,
    Object? title = $none,
    Object? description = $none,
    Object? displayOrder = $none,
    Object? fieldType = $none,
    Object? fieldChoices = $none,
    Object? matchType = $none,
    Object? matchParams = $none,
    Object? maxLength = $none,
    Object? required = $none,
    Object? displayGroup = $none,
  }) => $apply(
    FieldCopyWithData({
      if (fieldId != null) #fieldId: fieldId,
      if (title != $none) #title: title,
      if (description != $none) #description: description,
      if (displayOrder != $none) #displayOrder: displayOrder,
      if (fieldType != $none) #fieldType: fieldType,
      if (fieldChoices != $none) #fieldChoices: fieldChoices,
      if (matchType != $none) #matchType: matchType,
      if (matchParams != $none) #matchParams: matchParams,
      if (maxLength != $none) #maxLength: maxLength,
      if (required != $none) #required: required,
      if (displayGroup != $none) #displayGroup: displayGroup,
    }),
  );
  @override
  XenForoUserField $make(CopyWithData data) => XenForoUserField(
    fieldId: data.get(#fieldId, or: $value.fieldId),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    displayOrder: data.get(#displayOrder, or: $value.displayOrder),
    fieldType: data.get(#fieldType, or: $value.fieldType),
    fieldChoices: data.get(#fieldChoices, or: $value.fieldChoices),
    matchType: data.get(#matchType, or: $value.matchType),
    matchParams: data.get(#matchParams, or: $value.matchParams),
    maxLength: data.get(#maxLength, or: $value.maxLength),
    required: data.get(#required, or: $value.required),
    displayGroup: data.get(#displayGroup, or: $value.displayGroup),
  );

  @override
  XenForoUserFieldCopyWith<$R2, XenForoUserField, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _XenForoUserFieldCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

