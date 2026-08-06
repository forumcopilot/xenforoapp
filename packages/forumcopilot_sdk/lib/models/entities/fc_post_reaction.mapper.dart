// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_post_reaction.dart';

class FCPostReactionMapper extends ClassMapperBase<FCPostReaction> {
  FCPostReactionMapper._();

  static FCPostReactionMapper? _instance;
  static FCPostReactionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCPostReactionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCPostReaction';

  static String _$id(FCPostReaction v) => v.id;
  static const Field<FCPostReaction, String> _f$id = Field('id', _$id);
  static String _$type(FCPostReaction v) => v.type;
  static const Field<FCPostReaction, String> _f$type = Field(
    'type',
    _$type,
    opt: true,
    def: 'emoji',
  );
  static int _$count(FCPostReaction v) => v.count;
  static const Field<FCPostReaction, int> _f$count = Field('count', _$count);
  static bool _$viewerReacted(FCPostReaction v) => v.viewerReacted;
  static const Field<FCPostReaction, bool> _f$viewerReacted = Field(
    'viewerReacted',
    _$viewerReacted,
    opt: true,
    def: false,
  );
  static bool _$canUndo(FCPostReaction v) => v.canUndo;
  static const Field<FCPostReaction, bool> _f$canUndo = Field(
    'canUndo',
    _$canUndo,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<FCPostReaction> fields = const {
    #id: _f$id,
    #type: _f$type,
    #count: _f$count,
    #viewerReacted: _f$viewerReacted,
    #canUndo: _f$canUndo,
  };

  static FCPostReaction _instantiate(DecodingData data) {
    return FCPostReaction(
      id: data.dec(_f$id),
      type: data.dec(_f$type),
      count: data.dec(_f$count),
      viewerReacted: data.dec(_f$viewerReacted),
      canUndo: data.dec(_f$canUndo),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCPostReaction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCPostReaction>(map);
  }

  static FCPostReaction fromJson(String json) {
    return ensureInitialized().decodeJson<FCPostReaction>(json);
  }
}

mixin FCPostReactionMappable {
  String toJson() {
    return FCPostReactionMapper.ensureInitialized().encodeJson<FCPostReaction>(
      this as FCPostReaction,
    );
  }

  Map<String, dynamic> toMap() {
    return FCPostReactionMapper.ensureInitialized().encodeMap<FCPostReaction>(
      this as FCPostReaction,
    );
  }

  FCPostReactionCopyWith<FCPostReaction, FCPostReaction, FCPostReaction>
  get copyWith => _FCPostReactionCopyWithImpl<FCPostReaction, FCPostReaction>(
    this as FCPostReaction,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCPostReactionMapper.ensureInitialized().stringifyValue(
      this as FCPostReaction,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCPostReactionMapper.ensureInitialized().equalsValue(
      this as FCPostReaction,
      other,
    );
  }

  @override
  int get hashCode {
    return FCPostReactionMapper.ensureInitialized().hashValue(
      this as FCPostReaction,
    );
  }
}

extension FCPostReactionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCPostReaction, $Out> {
  FCPostReactionCopyWith<$R, FCPostReaction, $Out> get $asFCPostReaction =>
      $base.as((v, t, t2) => _FCPostReactionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCPostReactionCopyWith<$R, $In extends FCPostReaction, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? type,
    int? count,
    bool? viewerReacted,
    bool? canUndo,
  });
  FCPostReactionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCPostReactionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCPostReaction, $Out>
    implements FCPostReactionCopyWith<$R, FCPostReaction, $Out> {
  _FCPostReactionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCPostReaction> $mapper =
      FCPostReactionMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? type,
    int? count,
    bool? viewerReacted,
    bool? canUndo,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (type != null) #type: type,
      if (count != null) #count: count,
      if (viewerReacted != null) #viewerReacted: viewerReacted,
      if (canUndo != null) #canUndo: canUndo,
    }),
  );
  @override
  FCPostReaction $make(CopyWithData data) => FCPostReaction(
    id: data.get(#id, or: $value.id),
    type: data.get(#type, or: $value.type),
    count: data.get(#count, or: $value.count),
    viewerReacted: data.get(#viewerReacted, or: $value.viewerReacted),
    canUndo: data.get(#canUndo, or: $value.canUndo),
  );

  @override
  FCPostReactionCopyWith<$R2, FCPostReaction, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCPostReactionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

