// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_draft.dart';

class FCDraftMapper extends ClassMapperBase<FCDraft> {
  FCDraftMapper._();

  static FCDraftMapper? _instance;
  static FCDraftMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCDraftMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCDraft';

  static String _$draftKey(FCDraft v) => v.draftKey;
  static const Field<FCDraft, String> _f$draftKey = Field(
    'draftKey',
    _$draftKey,
  );
  static int _$sequence(FCDraft v) => v.sequence;
  static const Field<FCDraft, int> _f$sequence = Field('sequence', _$sequence);
  static Map<String, dynamic> _$data(FCDraft v) => v.data;
  static const Field<FCDraft, Map<String, dynamic>> _f$data = Field(
    'data',
    _$data,
  );
  static int? _$topicId(FCDraft v) => v.topicId;
  static const Field<FCDraft, int> _f$topicId = Field(
    'topicId',
    _$topicId,
    opt: true,
  );
  static String? _$title(FCDraft v) => v.title;
  static const Field<FCDraft, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
  );
  static int? _$categoryId(FCDraft v) => v.categoryId;
  static const Field<FCDraft, int> _f$categoryId = Field(
    'categoryId',
    _$categoryId,
    opt: true,
  );
  static DateTime? _$updatedAt(FCDraft v) => v.updatedAt;
  static const Field<FCDraft, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    opt: true,
  );

  @override
  final MappableFields<FCDraft> fields = const {
    #draftKey: _f$draftKey,
    #sequence: _f$sequence,
    #data: _f$data,
    #topicId: _f$topicId,
    #title: _f$title,
    #categoryId: _f$categoryId,
    #updatedAt: _f$updatedAt,
  };

  static FCDraft _instantiate(DecodingData data) {
    return FCDraft(
      draftKey: data.dec(_f$draftKey),
      sequence: data.dec(_f$sequence),
      data: data.dec(_f$data),
      topicId: data.dec(_f$topicId),
      title: data.dec(_f$title),
      categoryId: data.dec(_f$categoryId),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCDraft fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCDraft>(map);
  }

  static FCDraft fromJson(String json) {
    return ensureInitialized().decodeJson<FCDraft>(json);
  }
}

mixin FCDraftMappable {
  String toJson() {
    return FCDraftMapper.ensureInitialized().encodeJson<FCDraft>(
      this as FCDraft,
    );
  }

  Map<String, dynamic> toMap() {
    return FCDraftMapper.ensureInitialized().encodeMap<FCDraft>(
      this as FCDraft,
    );
  }

  FCDraftCopyWith<FCDraft, FCDraft, FCDraft> get copyWith =>
      _FCDraftCopyWithImpl<FCDraft, FCDraft>(
        this as FCDraft,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCDraftMapper.ensureInitialized().stringifyValue(this as FCDraft);
  }

  @override
  bool operator ==(Object other) {
    return FCDraftMapper.ensureInitialized().equalsValue(
      this as FCDraft,
      other,
    );
  }

  @override
  int get hashCode {
    return FCDraftMapper.ensureInitialized().hashValue(this as FCDraft);
  }
}

extension FCDraftValueCopy<$R, $Out> on ObjectCopyWith<$R, FCDraft, $Out> {
  FCDraftCopyWith<$R, FCDraft, $Out> get $asFCDraft =>
      $base.as((v, t, t2) => _FCDraftCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCDraftCopyWith<$R, $In extends FCDraft, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get data;
  $R call({
    String? draftKey,
    int? sequence,
    Map<String, dynamic>? data,
    int? topicId,
    String? title,
    int? categoryId,
    DateTime? updatedAt,
  });
  FCDraftCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCDraftCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCDraft, $Out>
    implements FCDraftCopyWith<$R, FCDraft, $Out> {
  _FCDraftCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCDraft> $mapper =
      FCDraftMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>
  get data => MapCopyWith(
    $value.data,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(data: v),
  );
  @override
  $R call({
    String? draftKey,
    int? sequence,
    Map<String, dynamic>? data,
    Object? topicId = $none,
    Object? title = $none,
    Object? categoryId = $none,
    Object? updatedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (draftKey != null) #draftKey: draftKey,
      if (sequence != null) #sequence: sequence,
      if (data != null) #data: data,
      if (topicId != $none) #topicId: topicId,
      if (title != $none) #title: title,
      if (categoryId != $none) #categoryId: categoryId,
      if (updatedAt != $none) #updatedAt: updatedAt,
    }),
  );
  @override
  FCDraft $make(CopyWithData data) => FCDraft(
    draftKey: data.get(#draftKey, or: $value.draftKey),
    sequence: data.get(#sequence, or: $value.sequence),
    data: data.get(#data, or: $value.data),
    topicId: data.get(#topicId, or: $value.topicId),
    title: data.get(#title, or: $value.title),
    categoryId: data.get(#categoryId, or: $value.categoryId),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  FCDraftCopyWith<$R2, FCDraft, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCDraftCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

