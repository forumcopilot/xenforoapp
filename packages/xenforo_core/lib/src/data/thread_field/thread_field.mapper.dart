// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'thread_field.dart';

class XenForoThreadFieldMapper extends ClassMapperBase<XenForoThreadField> {
  XenForoThreadFieldMapper._();

  static XenForoThreadFieldMapper? _instance;
  static XenForoThreadFieldMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoThreadFieldMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoThreadField';

  static String _$fieldId(XenForoThreadField v) => v.fieldId;
  static const Field<XenForoThreadField, String> _f$fieldId = Field(
    'fieldId',
    _$fieldId,
  );
  static String? _$title(XenForoThreadField v) => v.title;
  static const Field<XenForoThreadField, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
  );
  static String? _$description(XenForoThreadField v) => v.description;
  static const Field<XenForoThreadField, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static int? _$displayOrder(XenForoThreadField v) => v.displayOrder;
  static const Field<XenForoThreadField, int> _f$displayOrder = Field(
    'displayOrder',
    _$displayOrder,
    opt: true,
  );
  static String? _$fieldType(XenForoThreadField v) => v.fieldType;
  static const Field<XenForoThreadField, String> _f$fieldType = Field(
    'fieldType',
    _$fieldType,
    opt: true,
  );
  static Map<String, dynamic>? _$fieldChoices(XenForoThreadField v) =>
      v.fieldChoices;
  static const Field<XenForoThreadField, Map<String, dynamic>> _f$fieldChoices =
      Field('fieldChoices', _$fieldChoices, opt: true);
  static String? _$matchType(XenForoThreadField v) => v.matchType;
  static const Field<XenForoThreadField, String> _f$matchType = Field(
    'matchType',
    _$matchType,
    opt: true,
  );
  static List<dynamic>? _$matchParams(XenForoThreadField v) => v.matchParams;
  static const Field<XenForoThreadField, List<dynamic>> _f$matchParams = Field(
    'matchParams',
    _$matchParams,
    opt: true,
  );
  static int? _$maxLength(XenForoThreadField v) => v.maxLength;
  static const Field<XenForoThreadField, int> _f$maxLength = Field(
    'maxLength',
    _$maxLength,
    opt: true,
  );
  static bool? _$required(XenForoThreadField v) => v.required;
  static const Field<XenForoThreadField, bool> _f$required = Field(
    'required',
    _$required,
    opt: true,
  );
  static String? _$displayGroup(XenForoThreadField v) => v.displayGroup;
  static const Field<XenForoThreadField, String> _f$displayGroup = Field(
    'displayGroup',
    _$displayGroup,
    opt: true,
  );

  @override
  final MappableFields<XenForoThreadField> fields = const {
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

  static XenForoThreadField _instantiate(DecodingData data) {
    return XenForoThreadField(
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

  static XenForoThreadField fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoThreadField>(map);
  }

  static XenForoThreadField fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoThreadField>(json);
  }
}

mixin XenForoThreadFieldMappable {
  String toJson() {
    return XenForoThreadFieldMapper.ensureInitialized()
        .encodeJson<XenForoThreadField>(this as XenForoThreadField);
  }

  Map<String, dynamic> toMap() {
    return XenForoThreadFieldMapper.ensureInitialized()
        .encodeMap<XenForoThreadField>(this as XenForoThreadField);
  }

  XenForoThreadFieldCopyWith<
    XenForoThreadField,
    XenForoThreadField,
    XenForoThreadField
  >
  get copyWith =>
      _XenForoThreadFieldCopyWithImpl<XenForoThreadField, XenForoThreadField>(
        this as XenForoThreadField,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return XenForoThreadFieldMapper.ensureInitialized().stringifyValue(
      this as XenForoThreadField,
    );
  }

  @override
  bool operator ==(Object other) {
    return XenForoThreadFieldMapper.ensureInitialized().equalsValue(
      this as XenForoThreadField,
      other,
    );
  }

  @override
  int get hashCode {
    return XenForoThreadFieldMapper.ensureInitialized().hashValue(
      this as XenForoThreadField,
    );
  }
}

extension XenForoThreadFieldValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoThreadField, $Out> {
  XenForoThreadFieldCopyWith<$R, XenForoThreadField, $Out>
  get $asXenForoThreadField => $base.as(
    (v, t, t2) => _XenForoThreadFieldCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class XenForoThreadFieldCopyWith<
  $R,
  $In extends XenForoThreadField,
  $Out
>
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
  XenForoThreadFieldCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _XenForoThreadFieldCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoThreadField, $Out>
    implements XenForoThreadFieldCopyWith<$R, XenForoThreadField, $Out> {
  _XenForoThreadFieldCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoThreadField> $mapper =
      XenForoThreadFieldMapper.ensureInitialized();
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
  XenForoThreadField $make(CopyWithData data) => XenForoThreadField(
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
  XenForoThreadFieldCopyWith<$R2, XenForoThreadField, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _XenForoThreadFieldCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

