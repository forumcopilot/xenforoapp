// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_tag.dart';

class FCTagMapper extends ClassMapperBase<FCTag> {
  FCTagMapper._();

  static FCTagMapper? _instance;
  static FCTagMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCTagMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCTag';

  static String _$name(FCTag v) => v.name;
  static const Field<FCTag, String> _f$name = Field('name', _$name);
  static String _$text(FCTag v) => v.text;
  static const Field<FCTag, String> _f$text = Field('text', _$text);
  static int? _$id(FCTag v) => v.id;
  static const Field<FCTag, int> _f$id = Field('id', _$id, opt: true);
  static int _$count(FCTag v) => v.count;
  static const Field<FCTag, int> _f$count = Field(
    'count',
    _$count,
    opt: true,
    def: 0,
  );
  static String? _$description(FCTag v) => v.description;
  static const Field<FCTag, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static bool _$pmOnly(FCTag v) => v.pmOnly;
  static const Field<FCTag, bool> _f$pmOnly = Field(
    'pmOnly',
    _$pmOnly,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<FCTag> fields = const {
    #name: _f$name,
    #text: _f$text,
    #id: _f$id,
    #count: _f$count,
    #description: _f$description,
    #pmOnly: _f$pmOnly,
  };

  static FCTag _instantiate(DecodingData data) {
    return FCTag(
      name: data.dec(_f$name),
      text: data.dec(_f$text),
      id: data.dec(_f$id),
      count: data.dec(_f$count),
      description: data.dec(_f$description),
      pmOnly: data.dec(_f$pmOnly),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCTag fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCTag>(map);
  }

  static FCTag fromJson(String json) {
    return ensureInitialized().decodeJson<FCTag>(json);
  }
}

mixin FCTagMappable {
  String toJson() {
    return FCTagMapper.ensureInitialized().encodeJson<FCTag>(this as FCTag);
  }

  Map<String, dynamic> toMap() {
    return FCTagMapper.ensureInitialized().encodeMap<FCTag>(this as FCTag);
  }

  FCTagCopyWith<FCTag, FCTag, FCTag> get copyWith =>
      _FCTagCopyWithImpl<FCTag, FCTag>(this as FCTag, $identity, $identity);
  @override
  String toString() {
    return FCTagMapper.ensureInitialized().stringifyValue(this as FCTag);
  }

  @override
  bool operator ==(Object other) {
    return FCTagMapper.ensureInitialized().equalsValue(this as FCTag, other);
  }

  @override
  int get hashCode {
    return FCTagMapper.ensureInitialized().hashValue(this as FCTag);
  }
}

extension FCTagValueCopy<$R, $Out> on ObjectCopyWith<$R, FCTag, $Out> {
  FCTagCopyWith<$R, FCTag, $Out> get $asFCTag =>
      $base.as((v, t, t2) => _FCTagCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCTagCopyWith<$R, $In extends FCTag, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? name,
    String? text,
    int? id,
    int? count,
    String? description,
    bool? pmOnly,
  });
  FCTagCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCTagCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, FCTag, $Out>
    implements FCTagCopyWith<$R, FCTag, $Out> {
  _FCTagCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCTag> $mapper = FCTagMapper.ensureInitialized();
  @override
  $R call({
    String? name,
    String? text,
    Object? id = $none,
    int? count,
    Object? description = $none,
    bool? pmOnly,
  }) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (text != null) #text: text,
      if (id != $none) #id: id,
      if (count != null) #count: count,
      if (description != $none) #description: description,
      if (pmOnly != null) #pmOnly: pmOnly,
    }),
  );
  @override
  FCTag $make(CopyWithData data) => FCTag(
    name: data.get(#name, or: $value.name),
    text: data.get(#text, or: $value.text),
    id: data.get(#id, or: $value.id),
    count: data.get(#count, or: $value.count),
    description: data.get(#description, or: $value.description),
    pmOnly: data.get(#pmOnly, or: $value.pmOnly),
  );

  @override
  FCTagCopyWith<$R2, FCTag, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCTagCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

