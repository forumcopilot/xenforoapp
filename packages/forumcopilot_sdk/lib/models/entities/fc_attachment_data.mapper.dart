// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_attachment_data.dart';

class FCAttachmentDataMapper extends ClassMapperBase<FCAttachmentData> {
  FCAttachmentDataMapper._();

  static FCAttachmentDataMapper? _instance;
  static FCAttachmentDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCAttachmentDataMapper._());
      FCAttachmentContextMapper.ensureInitialized();
      FCAttachmentConstraintsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCAttachmentData';

  static String _$type(FCAttachmentData v) => v.type;
  static const Field<FCAttachmentData, String> _f$type = Field('type', _$type);
  static String _$hash(FCAttachmentData v) => v.hash;
  static const Field<FCAttachmentData, String> _f$hash = Field('hash', _$hash);
  static FCAttachmentContext? _$context(FCAttachmentData v) => v.context;
  static const Field<FCAttachmentData, FCAttachmentContext> _f$context = Field(
    'context',
    _$context,
    opt: true,
  );
  static FCAttachmentConstraints? _$constraints(FCAttachmentData v) =>
      v.constraints;
  static const Field<FCAttachmentData, FCAttachmentConstraints> _f$constraints =
      Field('constraints', _$constraints, opt: true);

  @override
  final MappableFields<FCAttachmentData> fields = const {
    #type: _f$type,
    #hash: _f$hash,
    #context: _f$context,
    #constraints: _f$constraints,
  };

  static FCAttachmentData _instantiate(DecodingData data) {
    return FCAttachmentData(
      type: data.dec(_f$type),
      hash: data.dec(_f$hash),
      context: data.dec(_f$context),
      constraints: data.dec(_f$constraints),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCAttachmentData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCAttachmentData>(map);
  }

  static FCAttachmentData fromJson(String json) {
    return ensureInitialized().decodeJson<FCAttachmentData>(json);
  }
}

mixin FCAttachmentDataMappable {
  String toJson() {
    return FCAttachmentDataMapper.ensureInitialized()
        .encodeJson<FCAttachmentData>(this as FCAttachmentData);
  }

  Map<String, dynamic> toMap() {
    return FCAttachmentDataMapper.ensureInitialized()
        .encodeMap<FCAttachmentData>(this as FCAttachmentData);
  }

  FCAttachmentDataCopyWith<FCAttachmentData, FCAttachmentData, FCAttachmentData>
  get copyWith =>
      _FCAttachmentDataCopyWithImpl<FCAttachmentData, FCAttachmentData>(
        this as FCAttachmentData,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCAttachmentDataMapper.ensureInitialized().stringifyValue(
      this as FCAttachmentData,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCAttachmentDataMapper.ensureInitialized().equalsValue(
      this as FCAttachmentData,
      other,
    );
  }

  @override
  int get hashCode {
    return FCAttachmentDataMapper.ensureInitialized().hashValue(
      this as FCAttachmentData,
    );
  }
}

extension FCAttachmentDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCAttachmentData, $Out> {
  FCAttachmentDataCopyWith<$R, FCAttachmentData, $Out>
  get $asFCAttachmentData =>
      $base.as((v, t, t2) => _FCAttachmentDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCAttachmentDataCopyWith<$R, $In extends FCAttachmentData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  FCAttachmentContextCopyWith<$R, FCAttachmentContext, FCAttachmentContext>?
  get context;
  FCAttachmentConstraintsCopyWith<
    $R,
    FCAttachmentConstraints,
    FCAttachmentConstraints
  >?
  get constraints;
  $R call({
    String? type,
    String? hash,
    FCAttachmentContext? context,
    FCAttachmentConstraints? constraints,
  });
  FCAttachmentDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCAttachmentDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCAttachmentData, $Out>
    implements FCAttachmentDataCopyWith<$R, FCAttachmentData, $Out> {
  _FCAttachmentDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCAttachmentData> $mapper =
      FCAttachmentDataMapper.ensureInitialized();
  @override
  FCAttachmentContextCopyWith<$R, FCAttachmentContext, FCAttachmentContext>?
  get context => $value.context?.copyWith.$chain((v) => call(context: v));
  @override
  FCAttachmentConstraintsCopyWith<
    $R,
    FCAttachmentConstraints,
    FCAttachmentConstraints
  >?
  get constraints =>
      $value.constraints?.copyWith.$chain((v) => call(constraints: v));
  @override
  $R call({
    String? type,
    String? hash,
    Object? context = $none,
    Object? constraints = $none,
  }) => $apply(
    FieldCopyWithData({
      if (type != null) #type: type,
      if (hash != null) #hash: hash,
      if (context != $none) #context: context,
      if (constraints != $none) #constraints: constraints,
    }),
  );
  @override
  FCAttachmentData $make(CopyWithData data) => FCAttachmentData(
    type: data.get(#type, or: $value.type),
    hash: data.get(#hash, or: $value.hash),
    context: data.get(#context, or: $value.context),
    constraints: data.get(#constraints, or: $value.constraints),
  );

  @override
  FCAttachmentDataCopyWith<$R2, FCAttachmentData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCAttachmentDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCAttachmentContextMapper extends ClassMapperBase<FCAttachmentContext> {
  FCAttachmentContextMapper._();

  static FCAttachmentContextMapper? _instance;
  static FCAttachmentContextMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCAttachmentContextMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCAttachmentContext';

  static int? _$nodeId(FCAttachmentContext v) => v.nodeId;
  static const Field<FCAttachmentContext, int> _f$nodeId = Field(
    'nodeId',
    _$nodeId,
    key: r'node_id',
    opt: true,
  );

  @override
  final MappableFields<FCAttachmentContext> fields = const {#nodeId: _f$nodeId};

  static FCAttachmentContext _instantiate(DecodingData data) {
    return FCAttachmentContext(nodeId: data.dec(_f$nodeId));
  }

  @override
  final Function instantiate = _instantiate;

  static FCAttachmentContext fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCAttachmentContext>(map);
  }

  static FCAttachmentContext fromJson(String json) {
    return ensureInitialized().decodeJson<FCAttachmentContext>(json);
  }
}

mixin FCAttachmentContextMappable {
  String toJson() {
    return FCAttachmentContextMapper.ensureInitialized()
        .encodeJson<FCAttachmentContext>(this as FCAttachmentContext);
  }

  Map<String, dynamic> toMap() {
    return FCAttachmentContextMapper.ensureInitialized()
        .encodeMap<FCAttachmentContext>(this as FCAttachmentContext);
  }

  FCAttachmentContextCopyWith<
    FCAttachmentContext,
    FCAttachmentContext,
    FCAttachmentContext
  >
  get copyWith =>
      _FCAttachmentContextCopyWithImpl<
        FCAttachmentContext,
        FCAttachmentContext
      >(this as FCAttachmentContext, $identity, $identity);
  @override
  String toString() {
    return FCAttachmentContextMapper.ensureInitialized().stringifyValue(
      this as FCAttachmentContext,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCAttachmentContextMapper.ensureInitialized().equalsValue(
      this as FCAttachmentContext,
      other,
    );
  }

  @override
  int get hashCode {
    return FCAttachmentContextMapper.ensureInitialized().hashValue(
      this as FCAttachmentContext,
    );
  }
}

extension FCAttachmentContextValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCAttachmentContext, $Out> {
  FCAttachmentContextCopyWith<$R, FCAttachmentContext, $Out>
  get $asFCAttachmentContext => $base.as(
    (v, t, t2) => _FCAttachmentContextCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCAttachmentContextCopyWith<
  $R,
  $In extends FCAttachmentContext,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? nodeId});
  FCAttachmentContextCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCAttachmentContextCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCAttachmentContext, $Out>
    implements FCAttachmentContextCopyWith<$R, FCAttachmentContext, $Out> {
  _FCAttachmentContextCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCAttachmentContext> $mapper =
      FCAttachmentContextMapper.ensureInitialized();
  @override
  $R call({Object? nodeId = $none}) =>
      $apply(FieldCopyWithData({if (nodeId != $none) #nodeId: nodeId}));
  @override
  FCAttachmentContext $make(CopyWithData data) =>
      FCAttachmentContext(nodeId: data.get(#nodeId, or: $value.nodeId));

  @override
  FCAttachmentContextCopyWith<$R2, FCAttachmentContext, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCAttachmentContextCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCAttachmentConstraintsMapper
    extends ClassMapperBase<FCAttachmentConstraints> {
  FCAttachmentConstraintsMapper._();

  static FCAttachmentConstraintsMapper? _instance;
  static FCAttachmentConstraintsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCAttachmentConstraintsMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'FCAttachmentConstraints';

  static List<String>? _$extensions(FCAttachmentConstraints v) => v.extensions;
  static const Field<FCAttachmentConstraints, List<String>> _f$extensions =
      Field('extensions', _$extensions, opt: true);
  static int? _$size(FCAttachmentConstraints v) => v.size;
  static const Field<FCAttachmentConstraints, int> _f$size = Field(
    'size',
    _$size,
    opt: true,
  );
  static int? _$width(FCAttachmentConstraints v) => v.width;
  static const Field<FCAttachmentConstraints, int> _f$width = Field(
    'width',
    _$width,
    opt: true,
  );
  static int? _$height(FCAttachmentConstraints v) => v.height;
  static const Field<FCAttachmentConstraints, int> _f$height = Field(
    'height',
    _$height,
    opt: true,
  );
  static int? _$count(FCAttachmentConstraints v) => v.count;
  static const Field<FCAttachmentConstraints, int> _f$count = Field(
    'count',
    _$count,
    opt: true,
  );

  @override
  final MappableFields<FCAttachmentConstraints> fields = const {
    #extensions: _f$extensions,
    #size: _f$size,
    #width: _f$width,
    #height: _f$height,
    #count: _f$count,
  };

  static FCAttachmentConstraints _instantiate(DecodingData data) {
    return FCAttachmentConstraints(
      extensions: data.dec(_f$extensions),
      size: data.dec(_f$size),
      width: data.dec(_f$width),
      height: data.dec(_f$height),
      count: data.dec(_f$count),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCAttachmentConstraints fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCAttachmentConstraints>(map);
  }

  static FCAttachmentConstraints fromJson(String json) {
    return ensureInitialized().decodeJson<FCAttachmentConstraints>(json);
  }
}

mixin FCAttachmentConstraintsMappable {
  String toJson() {
    return FCAttachmentConstraintsMapper.ensureInitialized()
        .encodeJson<FCAttachmentConstraints>(this as FCAttachmentConstraints);
  }

  Map<String, dynamic> toMap() {
    return FCAttachmentConstraintsMapper.ensureInitialized()
        .encodeMap<FCAttachmentConstraints>(this as FCAttachmentConstraints);
  }

  FCAttachmentConstraintsCopyWith<
    FCAttachmentConstraints,
    FCAttachmentConstraints,
    FCAttachmentConstraints
  >
  get copyWith =>
      _FCAttachmentConstraintsCopyWithImpl<
        FCAttachmentConstraints,
        FCAttachmentConstraints
      >(this as FCAttachmentConstraints, $identity, $identity);
  @override
  String toString() {
    return FCAttachmentConstraintsMapper.ensureInitialized().stringifyValue(
      this as FCAttachmentConstraints,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCAttachmentConstraintsMapper.ensureInitialized().equalsValue(
      this as FCAttachmentConstraints,
      other,
    );
  }

  @override
  int get hashCode {
    return FCAttachmentConstraintsMapper.ensureInitialized().hashValue(
      this as FCAttachmentConstraints,
    );
  }
}

extension FCAttachmentConstraintsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCAttachmentConstraints, $Out> {
  FCAttachmentConstraintsCopyWith<$R, FCAttachmentConstraints, $Out>
  get $asFCAttachmentConstraints => $base.as(
    (v, t, t2) => _FCAttachmentConstraintsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCAttachmentConstraintsCopyWith<
  $R,
  $In extends FCAttachmentConstraints,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get extensions;
  $R call({
    List<String>? extensions,
    int? size,
    int? width,
    int? height,
    int? count,
  });
  FCAttachmentConstraintsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCAttachmentConstraintsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCAttachmentConstraints, $Out>
    implements
        FCAttachmentConstraintsCopyWith<$R, FCAttachmentConstraints, $Out> {
  _FCAttachmentConstraintsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCAttachmentConstraints> $mapper =
      FCAttachmentConstraintsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get extensions => $value.extensions != null
      ? ListCopyWith(
          $value.extensions!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(extensions: v),
        )
      : null;
  @override
  $R call({
    Object? extensions = $none,
    Object? size = $none,
    Object? width = $none,
    Object? height = $none,
    Object? count = $none,
  }) => $apply(
    FieldCopyWithData({
      if (extensions != $none) #extensions: extensions,
      if (size != $none) #size: size,
      if (width != $none) #width: width,
      if (height != $none) #height: height,
      if (count != $none) #count: count,
    }),
  );
  @override
  FCAttachmentConstraints $make(CopyWithData data) => FCAttachmentConstraints(
    extensions: data.get(#extensions, or: $value.extensions),
    size: data.get(#size, or: $value.size),
    width: data.get(#width, or: $value.width),
    height: data.get(#height, or: $value.height),
    count: data.get(#count, or: $value.count),
  );

  @override
  FCAttachmentConstraintsCopyWith<$R2, FCAttachmentConstraints, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCAttachmentConstraintsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

