// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_custom_field.dart';

class FCCustomFieldMapper extends ClassMapperBase<FCCustomField> {
  FCCustomFieldMapper._();

  static FCCustomFieldMapper? _instance;
  static FCCustomFieldMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCCustomFieldMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCCustomField';

  static String _$name(FCCustomField v) => v.name;
  static const Field<FCCustomField, String> _f$name = Field('name', _$name);
  static String _$value(FCCustomField v) => v.value;
  static const Field<FCCustomField, String> _f$value = Field('value', _$value);

  @override
  final MappableFields<FCCustomField> fields = const {
    #name: _f$name,
    #value: _f$value,
  };

  static FCCustomField _instantiate(DecodingData data) {
    return FCCustomField(name: data.dec(_f$name), value: data.dec(_f$value));
  }

  @override
  final Function instantiate = _instantiate;

  static FCCustomField fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCCustomField>(map);
  }

  static FCCustomField fromJson(String json) {
    return ensureInitialized().decodeJson<FCCustomField>(json);
  }
}

mixin FCCustomFieldMappable {
  String toJson() {
    return FCCustomFieldMapper.ensureInitialized().encodeJson<FCCustomField>(
      this as FCCustomField,
    );
  }

  Map<String, dynamic> toMap() {
    return FCCustomFieldMapper.ensureInitialized().encodeMap<FCCustomField>(
      this as FCCustomField,
    );
  }

  FCCustomFieldCopyWith<FCCustomField, FCCustomField, FCCustomField>
  get copyWith => _FCCustomFieldCopyWithImpl<FCCustomField, FCCustomField>(
    this as FCCustomField,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCCustomFieldMapper.ensureInitialized().stringifyValue(
      this as FCCustomField,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCCustomFieldMapper.ensureInitialized().equalsValue(
      this as FCCustomField,
      other,
    );
  }

  @override
  int get hashCode {
    return FCCustomFieldMapper.ensureInitialized().hashValue(
      this as FCCustomField,
    );
  }
}

extension FCCustomFieldValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCCustomField, $Out> {
  FCCustomFieldCopyWith<$R, FCCustomField, $Out> get $asFCCustomField =>
      $base.as((v, t, t2) => _FCCustomFieldCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCCustomFieldCopyWith<$R, $In extends FCCustomField, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, String? value});
  FCCustomFieldCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCCustomFieldCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCCustomField, $Out>
    implements FCCustomFieldCopyWith<$R, FCCustomField, $Out> {
  _FCCustomFieldCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCCustomField> $mapper =
      FCCustomFieldMapper.ensureInitialized();
  @override
  $R call({String? name, String? value}) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (value != null) #value: value,
    }),
  );
  @override
  FCCustomField $make(CopyWithData data) => FCCustomField(
    name: data.get(#name, or: $value.name),
    value: data.get(#value, or: $value.value),
  );

  @override
  FCCustomFieldCopyWith<$R2, FCCustomField, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCCustomFieldCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

