// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_social_result.dart';

class FCThankPostResultMapper extends ClassMapperBase<FCThankPostResult> {
  FCThankPostResultMapper._();

  static FCThankPostResultMapper? _instance;
  static FCThankPostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCThankPostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCThankPostResult';

  static bool _$result(FCThankPostResult v) => v.result;
  static const Field<FCThankPostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCThankPostResult v) => v.resultText;
  static const Field<FCThankPostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCThankPostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCThankPostResult _instantiate(DecodingData data) {
    return FCThankPostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCThankPostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCThankPostResult>(map);
  }

  static FCThankPostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCThankPostResult>(json);
  }
}

mixin FCThankPostResultMappable {
  String toJson() {
    return FCThankPostResultMapper.ensureInitialized()
        .encodeJson<FCThankPostResult>(this as FCThankPostResult);
  }

  Map<String, dynamic> toMap() {
    return FCThankPostResultMapper.ensureInitialized()
        .encodeMap<FCThankPostResult>(this as FCThankPostResult);
  }

  FCThankPostResultCopyWith<
    FCThankPostResult,
    FCThankPostResult,
    FCThankPostResult
  >
  get copyWith =>
      _FCThankPostResultCopyWithImpl<FCThankPostResult, FCThankPostResult>(
        this as FCThankPostResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCThankPostResultMapper.ensureInitialized().stringifyValue(
      this as FCThankPostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCThankPostResultMapper.ensureInitialized().equalsValue(
      this as FCThankPostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCThankPostResultMapper.ensureInitialized().hashValue(
      this as FCThankPostResult,
    );
  }
}

extension FCThankPostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCThankPostResult, $Out> {
  FCThankPostResultCopyWith<$R, FCThankPostResult, $Out>
  get $asFCThankPostResult => $base.as(
    (v, t, t2) => _FCThankPostResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCThankPostResultCopyWith<
  $R,
  $In extends FCThankPostResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCThankPostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCThankPostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCThankPostResult, $Out>
    implements FCThankPostResultCopyWith<$R, FCThankPostResult, $Out> {
  _FCThankPostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCThankPostResult> $mapper =
      FCThankPostResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCThankPostResult $make(CopyWithData data) => FCThankPostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCThankPostResultCopyWith<$R2, FCThankPostResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCThankPostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCFollowResultMapper extends ClassMapperBase<FCFollowResult> {
  FCFollowResultMapper._();

  static FCFollowResultMapper? _instance;
  static FCFollowResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCFollowResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCFollowResult';

  static bool _$result(FCFollowResult v) => v.result;
  static const Field<FCFollowResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCFollowResult v) => v.resultText;
  static const Field<FCFollowResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCFollowResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCFollowResult _instantiate(DecodingData data) {
    return FCFollowResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCFollowResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCFollowResult>(map);
  }

  static FCFollowResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCFollowResult>(json);
  }
}

mixin FCFollowResultMappable {
  String toJson() {
    return FCFollowResultMapper.ensureInitialized().encodeJson<FCFollowResult>(
      this as FCFollowResult,
    );
  }

  Map<String, dynamic> toMap() {
    return FCFollowResultMapper.ensureInitialized().encodeMap<FCFollowResult>(
      this as FCFollowResult,
    );
  }

  FCFollowResultCopyWith<FCFollowResult, FCFollowResult, FCFollowResult>
  get copyWith => _FCFollowResultCopyWithImpl<FCFollowResult, FCFollowResult>(
    this as FCFollowResult,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCFollowResultMapper.ensureInitialized().stringifyValue(
      this as FCFollowResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCFollowResultMapper.ensureInitialized().equalsValue(
      this as FCFollowResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCFollowResultMapper.ensureInitialized().hashValue(
      this as FCFollowResult,
    );
  }
}

extension FCFollowResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCFollowResult, $Out> {
  FCFollowResultCopyWith<$R, FCFollowResult, $Out> get $asFCFollowResult =>
      $base.as((v, t, t2) => _FCFollowResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCFollowResultCopyWith<$R, $In extends FCFollowResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCFollowResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCFollowResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCFollowResult, $Out>
    implements FCFollowResultCopyWith<$R, FCFollowResult, $Out> {
  _FCFollowResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCFollowResult> $mapper =
      FCFollowResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCFollowResult $make(CopyWithData data) => FCFollowResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCFollowResultCopyWith<$R2, FCFollowResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCFollowResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUnfollowResultMapper extends ClassMapperBase<FCUnfollowResult> {
  FCUnfollowResultMapper._();

  static FCUnfollowResultMapper? _instance;
  static FCUnfollowResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUnfollowResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUnfollowResult';

  static bool _$result(FCUnfollowResult v) => v.result;
  static const Field<FCUnfollowResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUnfollowResult v) => v.resultText;
  static const Field<FCUnfollowResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCUnfollowResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCUnfollowResult _instantiate(DecodingData data) {
    return FCUnfollowResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUnfollowResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUnfollowResult>(map);
  }

  static FCUnfollowResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUnfollowResult>(json);
  }
}

mixin FCUnfollowResultMappable {
  String toJson() {
    return FCUnfollowResultMapper.ensureInitialized()
        .encodeJson<FCUnfollowResult>(this as FCUnfollowResult);
  }

  Map<String, dynamic> toMap() {
    return FCUnfollowResultMapper.ensureInitialized()
        .encodeMap<FCUnfollowResult>(this as FCUnfollowResult);
  }

  FCUnfollowResultCopyWith<FCUnfollowResult, FCUnfollowResult, FCUnfollowResult>
  get copyWith =>
      _FCUnfollowResultCopyWithImpl<FCUnfollowResult, FCUnfollowResult>(
        this as FCUnfollowResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCUnfollowResultMapper.ensureInitialized().stringifyValue(
      this as FCUnfollowResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUnfollowResultMapper.ensureInitialized().equalsValue(
      this as FCUnfollowResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUnfollowResultMapper.ensureInitialized().hashValue(
      this as FCUnfollowResult,
    );
  }
}

extension FCUnfollowResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUnfollowResult, $Out> {
  FCUnfollowResultCopyWith<$R, FCUnfollowResult, $Out>
  get $asFCUnfollowResult =>
      $base.as((v, t, t2) => _FCUnfollowResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCUnfollowResultCopyWith<$R, $In extends FCUnfollowResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCUnfollowResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUnfollowResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUnfollowResult, $Out>
    implements FCUnfollowResultCopyWith<$R, FCUnfollowResult, $Out> {
  _FCUnfollowResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUnfollowResult> $mapper =
      FCUnfollowResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCUnfollowResult $make(CopyWithData data) => FCUnfollowResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCUnfollowResultCopyWith<$R2, FCUnfollowResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCUnfollowResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCLikePostResultMapper extends ClassMapperBase<FCLikePostResult> {
  FCLikePostResultMapper._();

  static FCLikePostResultMapper? _instance;
  static FCLikePostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCLikePostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCLikePostResult';

  static bool _$result(FCLikePostResult v) => v.result;
  static const Field<FCLikePostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCLikePostResult v) => v.resultText;
  static const Field<FCLikePostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLiked(FCLikePostResult v) => v.isLiked;
  static const Field<FCLikePostResult, bool> _f$isLiked = Field(
    'isLiked',
    _$isLiked,
    opt: true,
    def: false,
  );
  static int _$likeCount(FCLikePostResult v) => v.likeCount;
  static const Field<FCLikePostResult, int> _f$likeCount = Field(
    'likeCount',
    _$likeCount,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<FCLikePostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLiked: _f$isLiked,
    #likeCount: _f$likeCount,
  };

  static FCLikePostResult _instantiate(DecodingData data) {
    return FCLikePostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLiked: data.dec(_f$isLiked),
      likeCount: data.dec(_f$likeCount),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCLikePostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCLikePostResult>(map);
  }

  static FCLikePostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCLikePostResult>(json);
  }
}

mixin FCLikePostResultMappable {
  String toJson() {
    return FCLikePostResultMapper.ensureInitialized()
        .encodeJson<FCLikePostResult>(this as FCLikePostResult);
  }

  Map<String, dynamic> toMap() {
    return FCLikePostResultMapper.ensureInitialized()
        .encodeMap<FCLikePostResult>(this as FCLikePostResult);
  }

  FCLikePostResultCopyWith<FCLikePostResult, FCLikePostResult, FCLikePostResult>
  get copyWith =>
      _FCLikePostResultCopyWithImpl<FCLikePostResult, FCLikePostResult>(
        this as FCLikePostResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCLikePostResultMapper.ensureInitialized().stringifyValue(
      this as FCLikePostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCLikePostResultMapper.ensureInitialized().equalsValue(
      this as FCLikePostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCLikePostResultMapper.ensureInitialized().hashValue(
      this as FCLikePostResult,
    );
  }
}

extension FCLikePostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCLikePostResult, $Out> {
  FCLikePostResultCopyWith<$R, FCLikePostResult, $Out>
  get $asFCLikePostResult =>
      $base.as((v, t, t2) => _FCLikePostResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCLikePostResultCopyWith<$R, $In extends FCLikePostResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLiked, int? likeCount});
  FCLikePostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCLikePostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCLikePostResult, $Out>
    implements FCLikePostResultCopyWith<$R, FCLikePostResult, $Out> {
  _FCLikePostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCLikePostResult> $mapper =
      FCLikePostResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    bool? isLiked,
    int? likeCount,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (isLiked != null) #isLiked: isLiked,
      if (likeCount != null) #likeCount: likeCount,
    }),
  );
  @override
  FCLikePostResult $make(CopyWithData data) => FCLikePostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLiked: data.get(#isLiked, or: $value.isLiked),
    likeCount: data.get(#likeCount, or: $value.likeCount),
  );

  @override
  FCLikePostResultCopyWith<$R2, FCLikePostResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCLikePostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUnlikePostResultMapper extends ClassMapperBase<FCUnlikePostResult> {
  FCUnlikePostResultMapper._();

  static FCUnlikePostResultMapper? _instance;
  static FCUnlikePostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUnlikePostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUnlikePostResult';

  static bool _$result(FCUnlikePostResult v) => v.result;
  static const Field<FCUnlikePostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUnlikePostResult v) => v.resultText;
  static const Field<FCUnlikePostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLiked(FCUnlikePostResult v) => v.isLiked;
  static const Field<FCUnlikePostResult, bool> _f$isLiked = Field(
    'isLiked',
    _$isLiked,
    opt: true,
    def: false,
  );
  static int _$likeCount(FCUnlikePostResult v) => v.likeCount;
  static const Field<FCUnlikePostResult, int> _f$likeCount = Field(
    'likeCount',
    _$likeCount,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<FCUnlikePostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLiked: _f$isLiked,
    #likeCount: _f$likeCount,
  };

  static FCUnlikePostResult _instantiate(DecodingData data) {
    return FCUnlikePostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLiked: data.dec(_f$isLiked),
      likeCount: data.dec(_f$likeCount),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUnlikePostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUnlikePostResult>(map);
  }

  static FCUnlikePostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUnlikePostResult>(json);
  }
}

mixin FCUnlikePostResultMappable {
  String toJson() {
    return FCUnlikePostResultMapper.ensureInitialized()
        .encodeJson<FCUnlikePostResult>(this as FCUnlikePostResult);
  }

  Map<String, dynamic> toMap() {
    return FCUnlikePostResultMapper.ensureInitialized()
        .encodeMap<FCUnlikePostResult>(this as FCUnlikePostResult);
  }

  FCUnlikePostResultCopyWith<
    FCUnlikePostResult,
    FCUnlikePostResult,
    FCUnlikePostResult
  >
  get copyWith =>
      _FCUnlikePostResultCopyWithImpl<FCUnlikePostResult, FCUnlikePostResult>(
        this as FCUnlikePostResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCUnlikePostResultMapper.ensureInitialized().stringifyValue(
      this as FCUnlikePostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUnlikePostResultMapper.ensureInitialized().equalsValue(
      this as FCUnlikePostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUnlikePostResultMapper.ensureInitialized().hashValue(
      this as FCUnlikePostResult,
    );
  }
}

extension FCUnlikePostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUnlikePostResult, $Out> {
  FCUnlikePostResultCopyWith<$R, FCUnlikePostResult, $Out>
  get $asFCUnlikePostResult => $base.as(
    (v, t, t2) => _FCUnlikePostResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUnlikePostResultCopyWith<
  $R,
  $In extends FCUnlikePostResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLiked, int? likeCount});
  FCUnlikePostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUnlikePostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUnlikePostResult, $Out>
    implements FCUnlikePostResultCopyWith<$R, FCUnlikePostResult, $Out> {
  _FCUnlikePostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUnlikePostResult> $mapper =
      FCUnlikePostResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    bool? isLiked,
    int? likeCount,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (isLiked != null) #isLiked: isLiked,
      if (likeCount != null) #likeCount: likeCount,
    }),
  );
  @override
  FCUnlikePostResult $make(CopyWithData data) => FCUnlikePostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLiked: data.get(#isLiked, or: $value.isLiked),
    likeCount: data.get(#likeCount, or: $value.likeCount),
  );

  @override
  FCUnlikePostResultCopyWith<$R2, FCUnlikePostResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCUnlikePostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCAlertResultMapper extends ClassMapperBase<FCAlertResult> {
  FCAlertResultMapper._();

  static FCAlertResultMapper? _instance;
  static FCAlertResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCAlertResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCAlertMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCAlertResult';

  static bool _$result(FCAlertResult v) => v.result;
  static const Field<FCAlertResult, bool> _f$result = Field('result', _$result);
  static String? _$resultText(FCAlertResult v) => v.resultText;
  static const Field<FCAlertResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$total(FCAlertResult v) => v.total;
  static const Field<FCAlertResult, int> _f$total = Field('total', _$total);
  static List<FCAlert> _$items(FCAlertResult v) => v.items;
  static const Field<FCAlertResult, List<FCAlert>> _f$items = Field(
    'items',
    _$items,
  );

  @override
  final MappableFields<FCAlertResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #total: _f$total,
    #items: _f$items,
  };

  static FCAlertResult _instantiate(DecodingData data) {
    return FCAlertResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      total: data.dec(_f$total),
      items: data.dec(_f$items),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCAlertResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCAlertResult>(map);
  }

  static FCAlertResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCAlertResult>(json);
  }
}

mixin FCAlertResultMappable {
  String toJson() {
    return FCAlertResultMapper.ensureInitialized().encodeJson<FCAlertResult>(
      this as FCAlertResult,
    );
  }

  Map<String, dynamic> toMap() {
    return FCAlertResultMapper.ensureInitialized().encodeMap<FCAlertResult>(
      this as FCAlertResult,
    );
  }

  FCAlertResultCopyWith<FCAlertResult, FCAlertResult, FCAlertResult>
  get copyWith => _FCAlertResultCopyWithImpl<FCAlertResult, FCAlertResult>(
    this as FCAlertResult,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCAlertResultMapper.ensureInitialized().stringifyValue(
      this as FCAlertResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCAlertResultMapper.ensureInitialized().equalsValue(
      this as FCAlertResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCAlertResultMapper.ensureInitialized().hashValue(
      this as FCAlertResult,
    );
  }
}

extension FCAlertResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCAlertResult, $Out> {
  FCAlertResultCopyWith<$R, FCAlertResult, $Out> get $asFCAlertResult =>
      $base.as((v, t, t2) => _FCAlertResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCAlertResultCopyWith<$R, $In extends FCAlertResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCAlert, FCAlertCopyWith<$R, FCAlert, FCAlert>> get items;
  @override
  $R call({bool? result, String? resultText, int? total, List<FCAlert>? items});
  FCAlertResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCAlertResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCAlertResult, $Out>
    implements FCAlertResultCopyWith<$R, FCAlertResult, $Out> {
  _FCAlertResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCAlertResult> $mapper =
      FCAlertResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCAlert, FCAlertCopyWith<$R, FCAlert, FCAlert>> get items =>
      ListCopyWith(
        $value.items,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(items: v),
      );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? total,
    List<FCAlert>? items,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (total != null) #total: total,
      if (items != null) #items: items,
    }),
  );
  @override
  FCAlertResult $make(CopyWithData data) => FCAlertResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    total: data.get(#total, or: $value.total),
    items: data.get(#items, or: $value.items),
  );

  @override
  FCAlertResultCopyWith<$R2, FCAlertResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCAlertResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCAlertMapper extends ClassMapperBase<FCAlert> {
  FCAlertMapper._();

  static FCAlertMapper? _instance;
  static FCAlertMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCAlertMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCAlert';

  static String _$userId(FCAlert v) => v.userId;
  static const Field<FCAlert, String> _f$userId = Field('userId', _$userId);
  static String _$username(FCAlert v) => v.username;
  static const Field<FCAlert, String> _f$username = Field(
    'username',
    _$username,
  );
  static String _$iconUrl(FCAlert v) => v.iconUrl;
  static const Field<FCAlert, String> _f$iconUrl = Field('iconUrl', _$iconUrl);
  static String _$message(FCAlert v) => v.message;
  static const Field<FCAlert, String> _f$message = Field('message', _$message);
  static String _$timestamp(FCAlert v) => v.timestamp;
  static const Field<FCAlert, String> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
  );
  static String _$contentType(FCAlert v) => v.contentType;
  static const Field<FCAlert, String> _f$contentType = Field(
    'contentType',
    _$contentType,
  );
  static String _$contentId(FCAlert v) => v.contentId;
  static const Field<FCAlert, String> _f$contentId = Field(
    'contentId',
    _$contentId,
  );
  static String? _$topicId(FCAlert v) => v.topicId;
  static const Field<FCAlert, String> _f$topicId = Field(
    'topicId',
    _$topicId,
    opt: true,
  );
  static int? _$position(FCAlert v) => v.position;
  static const Field<FCAlert, int> _f$position = Field(
    'position',
    _$position,
    opt: true,
  );
  static String? _$postId(FCAlert v) => v.postId;
  static const Field<FCAlert, String> _f$postId = Field(
    'postId',
    _$postId,
    opt: true,
  );
  static String? _$conversationId(FCAlert v) => v.conversationId;
  static const Field<FCAlert, String> _f$conversationId = Field(
    'conversationId',
    _$conversationId,
    opt: true,
  );
  static String? _$actionUrl(FCAlert v) => v.actionUrl;
  static const Field<FCAlert, String> _f$actionUrl = Field(
    'actionUrl',
    _$actionUrl,
    opt: true,
  );
  static String? _$fromUsername(FCAlert v) => v.fromUsername;
  static const Field<FCAlert, String> _f$fromUsername = Field(
    'fromUsername',
    _$fromUsername,
    opt: true,
  );
  static String? _$action(FCAlert v) => v.action;
  static const Field<FCAlert, String> _f$action = Field(
    'action',
    _$action,
    opt: true,
  );

  @override
  final MappableFields<FCAlert> fields = const {
    #userId: _f$userId,
    #username: _f$username,
    #iconUrl: _f$iconUrl,
    #message: _f$message,
    #timestamp: _f$timestamp,
    #contentType: _f$contentType,
    #contentId: _f$contentId,
    #topicId: _f$topicId,
    #position: _f$position,
    #postId: _f$postId,
    #conversationId: _f$conversationId,
    #actionUrl: _f$actionUrl,
    #fromUsername: _f$fromUsername,
    #action: _f$action,
  };

  static FCAlert _instantiate(DecodingData data) {
    return FCAlert(
      userId: data.dec(_f$userId),
      username: data.dec(_f$username),
      iconUrl: data.dec(_f$iconUrl),
      message: data.dec(_f$message),
      timestamp: data.dec(_f$timestamp),
      contentType: data.dec(_f$contentType),
      contentId: data.dec(_f$contentId),
      topicId: data.dec(_f$topicId),
      position: data.dec(_f$position),
      postId: data.dec(_f$postId),
      conversationId: data.dec(_f$conversationId),
      actionUrl: data.dec(_f$actionUrl),
      fromUsername: data.dec(_f$fromUsername),
      action: data.dec(_f$action),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCAlert fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCAlert>(map);
  }

  static FCAlert fromJson(String json) {
    return ensureInitialized().decodeJson<FCAlert>(json);
  }
}

mixin FCAlertMappable {
  String toJson() {
    return FCAlertMapper.ensureInitialized().encodeJson<FCAlert>(
      this as FCAlert,
    );
  }

  Map<String, dynamic> toMap() {
    return FCAlertMapper.ensureInitialized().encodeMap<FCAlert>(
      this as FCAlert,
    );
  }

  FCAlertCopyWith<FCAlert, FCAlert, FCAlert> get copyWith =>
      _FCAlertCopyWithImpl<FCAlert, FCAlert>(
        this as FCAlert,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCAlertMapper.ensureInitialized().stringifyValue(this as FCAlert);
  }

  @override
  bool operator ==(Object other) {
    return FCAlertMapper.ensureInitialized().equalsValue(
      this as FCAlert,
      other,
    );
  }

  @override
  int get hashCode {
    return FCAlertMapper.ensureInitialized().hashValue(this as FCAlert);
  }
}

extension FCAlertValueCopy<$R, $Out> on ObjectCopyWith<$R, FCAlert, $Out> {
  FCAlertCopyWith<$R, FCAlert, $Out> get $asFCAlert =>
      $base.as((v, t, t2) => _FCAlertCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCAlertCopyWith<$R, $In extends FCAlert, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? userId,
    String? username,
    String? iconUrl,
    String? message,
    String? timestamp,
    String? contentType,
    String? contentId,
    String? topicId,
    int? position,
    String? postId,
    String? conversationId,
    String? actionUrl,
    String? fromUsername,
    String? action,
  });
  FCAlertCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCAlertCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCAlert, $Out>
    implements FCAlertCopyWith<$R, FCAlert, $Out> {
  _FCAlertCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCAlert> $mapper =
      FCAlertMapper.ensureInitialized();
  @override
  $R call({
    String? userId,
    String? username,
    String? iconUrl,
    String? message,
    String? timestamp,
    String? contentType,
    String? contentId,
    Object? topicId = $none,
    Object? position = $none,
    Object? postId = $none,
    Object? conversationId = $none,
    Object? actionUrl = $none,
    Object? fromUsername = $none,
    Object? action = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (username != null) #username: username,
      if (iconUrl != null) #iconUrl: iconUrl,
      if (message != null) #message: message,
      if (timestamp != null) #timestamp: timestamp,
      if (contentType != null) #contentType: contentType,
      if (contentId != null) #contentId: contentId,
      if (topicId != $none) #topicId: topicId,
      if (position != $none) #position: position,
      if (postId != $none) #postId: postId,
      if (conversationId != $none) #conversationId: conversationId,
      if (actionUrl != $none) #actionUrl: actionUrl,
      if (fromUsername != $none) #fromUsername: fromUsername,
      if (action != $none) #action: action,
    }),
  );
  @override
  FCAlert $make(CopyWithData data) => FCAlert(
    userId: data.get(#userId, or: $value.userId),
    username: data.get(#username, or: $value.username),
    iconUrl: data.get(#iconUrl, or: $value.iconUrl),
    message: data.get(#message, or: $value.message),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    contentType: data.get(#contentType, or: $value.contentType),
    contentId: data.get(#contentId, or: $value.contentId),
    topicId: data.get(#topicId, or: $value.topicId),
    position: data.get(#position, or: $value.position),
    postId: data.get(#postId, or: $value.postId),
    conversationId: data.get(#conversationId, or: $value.conversationId),
    actionUrl: data.get(#actionUrl, or: $value.actionUrl),
    fromUsername: data.get(#fromUsername, or: $value.fromUsername),
    action: data.get(#action, or: $value.action),
  );

  @override
  FCAlertCopyWith<$R2, FCAlert, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCAlertCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCActivityResultMapper extends ClassMapperBase<FCActivityResult> {
  FCActivityResultMapper._();

  static FCActivityResultMapper? _instance;
  static FCActivityResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCActivityResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCActivityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCActivityResult';

  static bool _$result(FCActivityResult v) => v.result;
  static const Field<FCActivityResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCActivityResult v) => v.resultText;
  static const Field<FCActivityResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$total(FCActivityResult v) => v.total;
  static const Field<FCActivityResult, int> _f$total = Field('total', _$total);
  static List<FCActivity> _$items(FCActivityResult v) => v.items;
  static const Field<FCActivityResult, List<FCActivity>> _f$items = Field(
    'items',
    _$items,
  );

  @override
  final MappableFields<FCActivityResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #total: _f$total,
    #items: _f$items,
  };

  static FCActivityResult _instantiate(DecodingData data) {
    return FCActivityResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      total: data.dec(_f$total),
      items: data.dec(_f$items),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCActivityResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCActivityResult>(map);
  }

  static FCActivityResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCActivityResult>(json);
  }
}

mixin FCActivityResultMappable {
  String toJson() {
    return FCActivityResultMapper.ensureInitialized()
        .encodeJson<FCActivityResult>(this as FCActivityResult);
  }

  Map<String, dynamic> toMap() {
    return FCActivityResultMapper.ensureInitialized()
        .encodeMap<FCActivityResult>(this as FCActivityResult);
  }

  FCActivityResultCopyWith<FCActivityResult, FCActivityResult, FCActivityResult>
  get copyWith =>
      _FCActivityResultCopyWithImpl<FCActivityResult, FCActivityResult>(
        this as FCActivityResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCActivityResultMapper.ensureInitialized().stringifyValue(
      this as FCActivityResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCActivityResultMapper.ensureInitialized().equalsValue(
      this as FCActivityResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCActivityResultMapper.ensureInitialized().hashValue(
      this as FCActivityResult,
    );
  }
}

extension FCActivityResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCActivityResult, $Out> {
  FCActivityResultCopyWith<$R, FCActivityResult, $Out>
  get $asFCActivityResult =>
      $base.as((v, t, t2) => _FCActivityResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCActivityResultCopyWith<$R, $In extends FCActivityResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCActivity, FCActivityCopyWith<$R, FCActivity, FCActivity>>
  get items;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? total,
    List<FCActivity>? items,
  });
  FCActivityResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCActivityResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCActivityResult, $Out>
    implements FCActivityResultCopyWith<$R, FCActivityResult, $Out> {
  _FCActivityResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCActivityResult> $mapper =
      FCActivityResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCActivity, FCActivityCopyWith<$R, FCActivity, FCActivity>>
  get items => ListCopyWith(
    $value.items,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(items: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? total,
    List<FCActivity>? items,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (total != null) #total: total,
      if (items != null) #items: items,
    }),
  );
  @override
  FCActivityResult $make(CopyWithData data) => FCActivityResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    total: data.get(#total, or: $value.total),
    items: data.get(#items, or: $value.items),
  );

  @override
  FCActivityResultCopyWith<$R2, FCActivityResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCActivityResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCActivityMapper extends ClassMapperBase<FCActivity> {
  FCActivityMapper._();

  static FCActivityMapper? _instance;
  static FCActivityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCActivityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCActivity';

  static String _$userId(FCActivity v) => v.userId;
  static const Field<FCActivity, String> _f$userId = Field('userId', _$userId);
  static String _$username(FCActivity v) => v.username;
  static const Field<FCActivity, String> _f$username = Field(
    'username',
    _$username,
  );
  static String _$iconUrl(FCActivity v) => v.iconUrl;
  static const Field<FCActivity, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
  );
  static String _$message(FCActivity v) => v.message;
  static const Field<FCActivity, String> _f$message = Field(
    'message',
    _$message,
  );
  static String _$timestamp(FCActivity v) => v.timestamp;
  static const Field<FCActivity, String> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
  );
  static String _$contentType(FCActivity v) => v.contentType;
  static const Field<FCActivity, String> _f$contentType = Field(
    'contentType',
    _$contentType,
  );
  static String _$contentId(FCActivity v) => v.contentId;
  static const Field<FCActivity, String> _f$contentId = Field(
    'contentId',
    _$contentId,
  );
  static String? _$topicId(FCActivity v) => v.topicId;
  static const Field<FCActivity, String> _f$topicId = Field(
    'topicId',
    _$topicId,
    opt: true,
  );

  @override
  final MappableFields<FCActivity> fields = const {
    #userId: _f$userId,
    #username: _f$username,
    #iconUrl: _f$iconUrl,
    #message: _f$message,
    #timestamp: _f$timestamp,
    #contentType: _f$contentType,
    #contentId: _f$contentId,
    #topicId: _f$topicId,
  };

  static FCActivity _instantiate(DecodingData data) {
    return FCActivity(
      userId: data.dec(_f$userId),
      username: data.dec(_f$username),
      iconUrl: data.dec(_f$iconUrl),
      message: data.dec(_f$message),
      timestamp: data.dec(_f$timestamp),
      contentType: data.dec(_f$contentType),
      contentId: data.dec(_f$contentId),
      topicId: data.dec(_f$topicId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCActivity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCActivity>(map);
  }

  static FCActivity fromJson(String json) {
    return ensureInitialized().decodeJson<FCActivity>(json);
  }
}

mixin FCActivityMappable {
  String toJson() {
    return FCActivityMapper.ensureInitialized().encodeJson<FCActivity>(
      this as FCActivity,
    );
  }

  Map<String, dynamic> toMap() {
    return FCActivityMapper.ensureInitialized().encodeMap<FCActivity>(
      this as FCActivity,
    );
  }

  FCActivityCopyWith<FCActivity, FCActivity, FCActivity> get copyWith =>
      _FCActivityCopyWithImpl<FCActivity, FCActivity>(
        this as FCActivity,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCActivityMapper.ensureInitialized().stringifyValue(
      this as FCActivity,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCActivityMapper.ensureInitialized().equalsValue(
      this as FCActivity,
      other,
    );
  }

  @override
  int get hashCode {
    return FCActivityMapper.ensureInitialized().hashValue(this as FCActivity);
  }
}

extension FCActivityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCActivity, $Out> {
  FCActivityCopyWith<$R, FCActivity, $Out> get $asFCActivity =>
      $base.as((v, t, t2) => _FCActivityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCActivityCopyWith<$R, $In extends FCActivity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? userId,
    String? username,
    String? iconUrl,
    String? message,
    String? timestamp,
    String? contentType,
    String? contentId,
    String? topicId,
  });
  FCActivityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCActivityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCActivity, $Out>
    implements FCActivityCopyWith<$R, FCActivity, $Out> {
  _FCActivityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCActivity> $mapper =
      FCActivityMapper.ensureInitialized();
  @override
  $R call({
    String? userId,
    String? username,
    String? iconUrl,
    String? message,
    String? timestamp,
    String? contentType,
    String? contentId,
    Object? topicId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (username != null) #username: username,
      if (iconUrl != null) #iconUrl: iconUrl,
      if (message != null) #message: message,
      if (timestamp != null) #timestamp: timestamp,
      if (contentType != null) #contentType: contentType,
      if (contentId != null) #contentId: contentId,
      if (topicId != $none) #topicId: topicId,
    }),
  );
  @override
  FCActivity $make(CopyWithData data) => FCActivity(
    userId: data.get(#userId, or: $value.userId),
    username: data.get(#username, or: $value.username),
    iconUrl: data.get(#iconUrl, or: $value.iconUrl),
    message: data.get(#message, or: $value.message),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    contentType: data.get(#contentType, or: $value.contentType),
    contentId: data.get(#contentId, or: $value.contentId),
    topicId: data.get(#topicId, or: $value.topicId),
  );

  @override
  FCActivityCopyWith<$R2, FCActivity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCActivityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

