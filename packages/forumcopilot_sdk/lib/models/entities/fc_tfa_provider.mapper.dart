// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_tfa_provider.dart';

class FCTFAProviderMapper extends ClassMapperBase<FCTFAProvider> {
  FCTFAProviderMapper._();

  static FCTFAProviderMapper? _instance;
  static FCTFAProviderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCTFAProviderMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCTFAProvider';

  static String _$id(FCTFAProvider v) => v.id;
  static const Field<FCTFAProvider, String> _f$id = Field('id', _$id);
  static String _$title(FCTFAProvider v) => v.title;
  static const Field<FCTFAProvider, String> _f$title = Field('title', _$title);
  static String _$description(FCTFAProvider v) => v.description;
  static const Field<FCTFAProvider, String> _f$description = Field(
    'description',
    _$description,
  );
  static String? _$type(FCTFAProvider v) => v.type;
  static const Field<FCTFAProvider, String> _f$type = Field(
    'type',
    _$type,
    opt: true,
  );

  @override
  final MappableFields<FCTFAProvider> fields = const {
    #id: _f$id,
    #title: _f$title,
    #description: _f$description,
    #type: _f$type,
  };

  static FCTFAProvider _instantiate(DecodingData data) {
    return FCTFAProvider(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      type: data.dec(_f$type),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCTFAProvider fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCTFAProvider>(map);
  }

  static FCTFAProvider fromJson(String json) {
    return ensureInitialized().decodeJson<FCTFAProvider>(json);
  }
}

mixin FCTFAProviderMappable {
  String toJson() {
    return FCTFAProviderMapper.ensureInitialized().encodeJson<FCTFAProvider>(
      this as FCTFAProvider,
    );
  }

  Map<String, dynamic> toMap() {
    return FCTFAProviderMapper.ensureInitialized().encodeMap<FCTFAProvider>(
      this as FCTFAProvider,
    );
  }

  FCTFAProviderCopyWith<FCTFAProvider, FCTFAProvider, FCTFAProvider>
  get copyWith => _FCTFAProviderCopyWithImpl<FCTFAProvider, FCTFAProvider>(
    this as FCTFAProvider,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCTFAProviderMapper.ensureInitialized().stringifyValue(
      this as FCTFAProvider,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCTFAProviderMapper.ensureInitialized().equalsValue(
      this as FCTFAProvider,
      other,
    );
  }

  @override
  int get hashCode {
    return FCTFAProviderMapper.ensureInitialized().hashValue(
      this as FCTFAProvider,
    );
  }
}

extension FCTFAProviderValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCTFAProvider, $Out> {
  FCTFAProviderCopyWith<$R, FCTFAProvider, $Out> get $asFCTFAProvider =>
      $base.as((v, t, t2) => _FCTFAProviderCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCTFAProviderCopyWith<$R, $In extends FCTFAProvider, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? title, String? description, String? type});
  FCTFAProviderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCTFAProviderCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCTFAProvider, $Out>
    implements FCTFAProviderCopyWith<$R, FCTFAProvider, $Out> {
  _FCTFAProviderCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCTFAProvider> $mapper =
      FCTFAProviderMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? title,
    String? description,
    Object? type = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (type != $none) #type: type,
    }),
  );
  @override
  FCTFAProvider $make(CopyWithData data) => FCTFAProvider(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    type: data.get(#type, or: $value.type),
  );

  @override
  FCTFAProviderCopyWith<$R2, FCTFAProvider, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCTFAProviderCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

