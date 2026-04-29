// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_moderation_result.dart';

class FCLoginModResultMapper extends ClassMapperBase<FCLoginModResult> {
  FCLoginModResultMapper._();

  static FCLoginModResultMapper? _instance;
  static FCLoginModResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCLoginModResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCLoginModResult';

  static bool _$result(FCLoginModResult v) => v.result;
  static const Field<FCLoginModResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCLoginModResult v) => v.resultText;
  static const Field<FCLoginModResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCLoginModResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCLoginModResult _instantiate(DecodingData data) {
    return FCLoginModResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCLoginModResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCLoginModResult>(map);
  }

  static FCLoginModResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCLoginModResult>(json);
  }
}

mixin FCLoginModResultMappable {
  String toJson() {
    return FCLoginModResultMapper.ensureInitialized()
        .encodeJson<FCLoginModResult>(this as FCLoginModResult);
  }

  Map<String, dynamic> toMap() {
    return FCLoginModResultMapper.ensureInitialized()
        .encodeMap<FCLoginModResult>(this as FCLoginModResult);
  }

  FCLoginModResultCopyWith<FCLoginModResult, FCLoginModResult, FCLoginModResult>
  get copyWith =>
      _FCLoginModResultCopyWithImpl<FCLoginModResult, FCLoginModResult>(
        this as FCLoginModResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCLoginModResultMapper.ensureInitialized().stringifyValue(
      this as FCLoginModResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCLoginModResultMapper.ensureInitialized().equalsValue(
      this as FCLoginModResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCLoginModResultMapper.ensureInitialized().hashValue(
      this as FCLoginModResult,
    );
  }
}

extension FCLoginModResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCLoginModResult, $Out> {
  FCLoginModResultCopyWith<$R, FCLoginModResult, $Out>
  get $asFCLoginModResult =>
      $base.as((v, t, t2) => _FCLoginModResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCLoginModResultCopyWith<$R, $In extends FCLoginModResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCLoginModResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCLoginModResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCLoginModResult, $Out>
    implements FCLoginModResultCopyWith<$R, FCLoginModResult, $Out> {
  _FCLoginModResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCLoginModResult> $mapper =
      FCLoginModResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCLoginModResult $make(CopyWithData data) => FCLoginModResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCLoginModResultCopyWith<$R2, FCLoginModResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCLoginModResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCStickTopicResultMapper extends ClassMapperBase<FCStickTopicResult> {
  FCStickTopicResultMapper._();

  static FCStickTopicResultMapper? _instance;
  static FCStickTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCStickTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCStickTopicResult';

  static bool _$result(FCStickTopicResult v) => v.result;
  static const Field<FCStickTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCStickTopicResult v) => v.resultText;
  static const Field<FCStickTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCStickTopicResult v) => v.isLoginMod;
  static const Field<FCStickTopicResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCStickTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCStickTopicResult _instantiate(DecodingData data) {
    return FCStickTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCStickTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCStickTopicResult>(map);
  }

  static FCStickTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCStickTopicResult>(json);
  }
}

mixin FCStickTopicResultMappable {
  String toJson() {
    return FCStickTopicResultMapper.ensureInitialized()
        .encodeJson<FCStickTopicResult>(this as FCStickTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCStickTopicResultMapper.ensureInitialized()
        .encodeMap<FCStickTopicResult>(this as FCStickTopicResult);
  }

  FCStickTopicResultCopyWith<
    FCStickTopicResult,
    FCStickTopicResult,
    FCStickTopicResult
  >
  get copyWith =>
      _FCStickTopicResultCopyWithImpl<FCStickTopicResult, FCStickTopicResult>(
        this as FCStickTopicResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCStickTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCStickTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCStickTopicResultMapper.ensureInitialized().equalsValue(
      this as FCStickTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCStickTopicResultMapper.ensureInitialized().hashValue(
      this as FCStickTopicResult,
    );
  }
}

extension FCStickTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCStickTopicResult, $Out> {
  FCStickTopicResultCopyWith<$R, FCStickTopicResult, $Out>
  get $asFCStickTopicResult => $base.as(
    (v, t, t2) => _FCStickTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCStickTopicResultCopyWith<
  $R,
  $In extends FCStickTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCStickTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCStickTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCStickTopicResult, $Out>
    implements FCStickTopicResultCopyWith<$R, FCStickTopicResult, $Out> {
  _FCStickTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCStickTopicResult> $mapper =
      FCStickTopicResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCStickTopicResult $make(CopyWithData data) => FCStickTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCStickTopicResultCopyWith<$R2, FCStickTopicResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCStickTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCCloseTopicResultMapper extends ClassMapperBase<FCCloseTopicResult> {
  FCCloseTopicResultMapper._();

  static FCCloseTopicResultMapper? _instance;
  static FCCloseTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCCloseTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCCloseTopicResult';

  static bool _$result(FCCloseTopicResult v) => v.result;
  static const Field<FCCloseTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCCloseTopicResult v) => v.resultText;
  static const Field<FCCloseTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCCloseTopicResult v) => v.isLoginMod;
  static const Field<FCCloseTopicResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCCloseTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCCloseTopicResult _instantiate(DecodingData data) {
    return FCCloseTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCCloseTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCCloseTopicResult>(map);
  }

  static FCCloseTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCCloseTopicResult>(json);
  }
}

mixin FCCloseTopicResultMappable {
  String toJson() {
    return FCCloseTopicResultMapper.ensureInitialized()
        .encodeJson<FCCloseTopicResult>(this as FCCloseTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCCloseTopicResultMapper.ensureInitialized()
        .encodeMap<FCCloseTopicResult>(this as FCCloseTopicResult);
  }

  FCCloseTopicResultCopyWith<
    FCCloseTopicResult,
    FCCloseTopicResult,
    FCCloseTopicResult
  >
  get copyWith =>
      _FCCloseTopicResultCopyWithImpl<FCCloseTopicResult, FCCloseTopicResult>(
        this as FCCloseTopicResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCCloseTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCCloseTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCCloseTopicResultMapper.ensureInitialized().equalsValue(
      this as FCCloseTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCCloseTopicResultMapper.ensureInitialized().hashValue(
      this as FCCloseTopicResult,
    );
  }
}

extension FCCloseTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCCloseTopicResult, $Out> {
  FCCloseTopicResultCopyWith<$R, FCCloseTopicResult, $Out>
  get $asFCCloseTopicResult => $base.as(
    (v, t, t2) => _FCCloseTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCCloseTopicResultCopyWith<
  $R,
  $In extends FCCloseTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCCloseTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCCloseTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCCloseTopicResult, $Out>
    implements FCCloseTopicResultCopyWith<$R, FCCloseTopicResult, $Out> {
  _FCCloseTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCCloseTopicResult> $mapper =
      FCCloseTopicResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCCloseTopicResult $make(CopyWithData data) => FCCloseTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCCloseTopicResultCopyWith<$R2, FCCloseTopicResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCCloseTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCDeleteTopicResultMapper extends ClassMapperBase<FCDeleteTopicResult> {
  FCDeleteTopicResultMapper._();

  static FCDeleteTopicResultMapper? _instance;
  static FCDeleteTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCDeleteTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCDeleteTopicResult';

  static bool _$result(FCDeleteTopicResult v) => v.result;
  static const Field<FCDeleteTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCDeleteTopicResult v) => v.resultText;
  static const Field<FCDeleteTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCDeleteTopicResult v) => v.isLoginMod;
  static const Field<FCDeleteTopicResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCDeleteTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCDeleteTopicResult _instantiate(DecodingData data) {
    return FCDeleteTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCDeleteTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCDeleteTopicResult>(map);
  }

  static FCDeleteTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCDeleteTopicResult>(json);
  }
}

mixin FCDeleteTopicResultMappable {
  String toJson() {
    return FCDeleteTopicResultMapper.ensureInitialized()
        .encodeJson<FCDeleteTopicResult>(this as FCDeleteTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCDeleteTopicResultMapper.ensureInitialized()
        .encodeMap<FCDeleteTopicResult>(this as FCDeleteTopicResult);
  }

  FCDeleteTopicResultCopyWith<
    FCDeleteTopicResult,
    FCDeleteTopicResult,
    FCDeleteTopicResult
  >
  get copyWith =>
      _FCDeleteTopicResultCopyWithImpl<
        FCDeleteTopicResult,
        FCDeleteTopicResult
      >(this as FCDeleteTopicResult, $identity, $identity);
  @override
  String toString() {
    return FCDeleteTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCDeleteTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCDeleteTopicResultMapper.ensureInitialized().equalsValue(
      this as FCDeleteTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCDeleteTopicResultMapper.ensureInitialized().hashValue(
      this as FCDeleteTopicResult,
    );
  }
}

extension FCDeleteTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCDeleteTopicResult, $Out> {
  FCDeleteTopicResultCopyWith<$R, FCDeleteTopicResult, $Out>
  get $asFCDeleteTopicResult => $base.as(
    (v, t, t2) => _FCDeleteTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCDeleteTopicResultCopyWith<
  $R,
  $In extends FCDeleteTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCDeleteTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCDeleteTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCDeleteTopicResult, $Out>
    implements FCDeleteTopicResultCopyWith<$R, FCDeleteTopicResult, $Out> {
  _FCDeleteTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCDeleteTopicResult> $mapper =
      FCDeleteTopicResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCDeleteTopicResult $make(CopyWithData data) => FCDeleteTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCDeleteTopicResultCopyWith<$R2, FCDeleteTopicResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCDeleteTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCDeletePostResultMapper extends ClassMapperBase<FCDeletePostResult> {
  FCDeletePostResultMapper._();

  static FCDeletePostResultMapper? _instance;
  static FCDeletePostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCDeletePostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCDeletePostResult';

  static bool _$result(FCDeletePostResult v) => v.result;
  static const Field<FCDeletePostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCDeletePostResult v) => v.resultText;
  static const Field<FCDeletePostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCDeletePostResult v) => v.isLoginMod;
  static const Field<FCDeletePostResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCDeletePostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCDeletePostResult _instantiate(DecodingData data) {
    return FCDeletePostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCDeletePostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCDeletePostResult>(map);
  }

  static FCDeletePostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCDeletePostResult>(json);
  }
}

mixin FCDeletePostResultMappable {
  String toJson() {
    return FCDeletePostResultMapper.ensureInitialized()
        .encodeJson<FCDeletePostResult>(this as FCDeletePostResult);
  }

  Map<String, dynamic> toMap() {
    return FCDeletePostResultMapper.ensureInitialized()
        .encodeMap<FCDeletePostResult>(this as FCDeletePostResult);
  }

  FCDeletePostResultCopyWith<
    FCDeletePostResult,
    FCDeletePostResult,
    FCDeletePostResult
  >
  get copyWith =>
      _FCDeletePostResultCopyWithImpl<FCDeletePostResult, FCDeletePostResult>(
        this as FCDeletePostResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCDeletePostResultMapper.ensureInitialized().stringifyValue(
      this as FCDeletePostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCDeletePostResultMapper.ensureInitialized().equalsValue(
      this as FCDeletePostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCDeletePostResultMapper.ensureInitialized().hashValue(
      this as FCDeletePostResult,
    );
  }
}

extension FCDeletePostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCDeletePostResult, $Out> {
  FCDeletePostResultCopyWith<$R, FCDeletePostResult, $Out>
  get $asFCDeletePostResult => $base.as(
    (v, t, t2) => _FCDeletePostResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCDeletePostResultCopyWith<
  $R,
  $In extends FCDeletePostResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCDeletePostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCDeletePostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCDeletePostResult, $Out>
    implements FCDeletePostResultCopyWith<$R, FCDeletePostResult, $Out> {
  _FCDeletePostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCDeletePostResult> $mapper =
      FCDeletePostResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCDeletePostResult $make(CopyWithData data) => FCDeletePostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCDeletePostResultCopyWith<$R2, FCDeletePostResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCDeletePostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUndeleteTopicResultMapper
    extends ClassMapperBase<FCUndeleteTopicResult> {
  FCUndeleteTopicResultMapper._();

  static FCUndeleteTopicResultMapper? _instance;
  static FCUndeleteTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUndeleteTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUndeleteTopicResult';

  static bool _$result(FCUndeleteTopicResult v) => v.result;
  static const Field<FCUndeleteTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUndeleteTopicResult v) => v.resultText;
  static const Field<FCUndeleteTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCUndeleteTopicResult v) => v.isLoginMod;
  static const Field<FCUndeleteTopicResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCUndeleteTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCUndeleteTopicResult _instantiate(DecodingData data) {
    return FCUndeleteTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUndeleteTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUndeleteTopicResult>(map);
  }

  static FCUndeleteTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUndeleteTopicResult>(json);
  }
}

mixin FCUndeleteTopicResultMappable {
  String toJson() {
    return FCUndeleteTopicResultMapper.ensureInitialized()
        .encodeJson<FCUndeleteTopicResult>(this as FCUndeleteTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCUndeleteTopicResultMapper.ensureInitialized()
        .encodeMap<FCUndeleteTopicResult>(this as FCUndeleteTopicResult);
  }

  FCUndeleteTopicResultCopyWith<
    FCUndeleteTopicResult,
    FCUndeleteTopicResult,
    FCUndeleteTopicResult
  >
  get copyWith =>
      _FCUndeleteTopicResultCopyWithImpl<
        FCUndeleteTopicResult,
        FCUndeleteTopicResult
      >(this as FCUndeleteTopicResult, $identity, $identity);
  @override
  String toString() {
    return FCUndeleteTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCUndeleteTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUndeleteTopicResultMapper.ensureInitialized().equalsValue(
      this as FCUndeleteTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUndeleteTopicResultMapper.ensureInitialized().hashValue(
      this as FCUndeleteTopicResult,
    );
  }
}

extension FCUndeleteTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUndeleteTopicResult, $Out> {
  FCUndeleteTopicResultCopyWith<$R, FCUndeleteTopicResult, $Out>
  get $asFCUndeleteTopicResult => $base.as(
    (v, t, t2) => _FCUndeleteTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUndeleteTopicResultCopyWith<
  $R,
  $In extends FCUndeleteTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCUndeleteTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUndeleteTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUndeleteTopicResult, $Out>
    implements FCUndeleteTopicResultCopyWith<$R, FCUndeleteTopicResult, $Out> {
  _FCUndeleteTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUndeleteTopicResult> $mapper =
      FCUndeleteTopicResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCUndeleteTopicResult $make(CopyWithData data) => FCUndeleteTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCUndeleteTopicResultCopyWith<$R2, FCUndeleteTopicResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCUndeleteTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUndeletePostResultMapper extends ClassMapperBase<FCUndeletePostResult> {
  FCUndeletePostResultMapper._();

  static FCUndeletePostResultMapper? _instance;
  static FCUndeletePostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUndeletePostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUndeletePostResult';

  static bool _$result(FCUndeletePostResult v) => v.result;
  static const Field<FCUndeletePostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUndeletePostResult v) => v.resultText;
  static const Field<FCUndeletePostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCUndeletePostResult v) => v.isLoginMod;
  static const Field<FCUndeletePostResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCUndeletePostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCUndeletePostResult _instantiate(DecodingData data) {
    return FCUndeletePostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUndeletePostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUndeletePostResult>(map);
  }

  static FCUndeletePostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUndeletePostResult>(json);
  }
}

mixin FCUndeletePostResultMappable {
  String toJson() {
    return FCUndeletePostResultMapper.ensureInitialized()
        .encodeJson<FCUndeletePostResult>(this as FCUndeletePostResult);
  }

  Map<String, dynamic> toMap() {
    return FCUndeletePostResultMapper.ensureInitialized()
        .encodeMap<FCUndeletePostResult>(this as FCUndeletePostResult);
  }

  FCUndeletePostResultCopyWith<
    FCUndeletePostResult,
    FCUndeletePostResult,
    FCUndeletePostResult
  >
  get copyWith =>
      _FCUndeletePostResultCopyWithImpl<
        FCUndeletePostResult,
        FCUndeletePostResult
      >(this as FCUndeletePostResult, $identity, $identity);
  @override
  String toString() {
    return FCUndeletePostResultMapper.ensureInitialized().stringifyValue(
      this as FCUndeletePostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUndeletePostResultMapper.ensureInitialized().equalsValue(
      this as FCUndeletePostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUndeletePostResultMapper.ensureInitialized().hashValue(
      this as FCUndeletePostResult,
    );
  }
}

extension FCUndeletePostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUndeletePostResult, $Out> {
  FCUndeletePostResultCopyWith<$R, FCUndeletePostResult, $Out>
  get $asFCUndeletePostResult => $base.as(
    (v, t, t2) => _FCUndeletePostResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUndeletePostResultCopyWith<
  $R,
  $In extends FCUndeletePostResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCUndeletePostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUndeletePostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUndeletePostResult, $Out>
    implements FCUndeletePostResultCopyWith<$R, FCUndeletePostResult, $Out> {
  _FCUndeletePostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUndeletePostResult> $mapper =
      FCUndeletePostResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCUndeletePostResult $make(CopyWithData data) => FCUndeletePostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCUndeletePostResultCopyWith<$R2, FCUndeletePostResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCUndeletePostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCMoveTopicResultMapper extends ClassMapperBase<FCMoveTopicResult> {
  FCMoveTopicResultMapper._();

  static FCMoveTopicResultMapper? _instance;
  static FCMoveTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCMoveTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCMoveTopicResult';

  static bool _$result(FCMoveTopicResult v) => v.result;
  static const Field<FCMoveTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCMoveTopicResult v) => v.resultText;
  static const Field<FCMoveTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCMoveTopicResult v) => v.isLoginMod;
  static const Field<FCMoveTopicResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCMoveTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCMoveTopicResult _instantiate(DecodingData data) {
    return FCMoveTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCMoveTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCMoveTopicResult>(map);
  }

  static FCMoveTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCMoveTopicResult>(json);
  }
}

mixin FCMoveTopicResultMappable {
  String toJson() {
    return FCMoveTopicResultMapper.ensureInitialized()
        .encodeJson<FCMoveTopicResult>(this as FCMoveTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCMoveTopicResultMapper.ensureInitialized()
        .encodeMap<FCMoveTopicResult>(this as FCMoveTopicResult);
  }

  FCMoveTopicResultCopyWith<
    FCMoveTopicResult,
    FCMoveTopicResult,
    FCMoveTopicResult
  >
  get copyWith =>
      _FCMoveTopicResultCopyWithImpl<FCMoveTopicResult, FCMoveTopicResult>(
        this as FCMoveTopicResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCMoveTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCMoveTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCMoveTopicResultMapper.ensureInitialized().equalsValue(
      this as FCMoveTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCMoveTopicResultMapper.ensureInitialized().hashValue(
      this as FCMoveTopicResult,
    );
  }
}

extension FCMoveTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCMoveTopicResult, $Out> {
  FCMoveTopicResultCopyWith<$R, FCMoveTopicResult, $Out>
  get $asFCMoveTopicResult => $base.as(
    (v, t, t2) => _FCMoveTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCMoveTopicResultCopyWith<
  $R,
  $In extends FCMoveTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCMoveTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCMoveTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCMoveTopicResult, $Out>
    implements FCMoveTopicResultCopyWith<$R, FCMoveTopicResult, $Out> {
  _FCMoveTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCMoveTopicResult> $mapper =
      FCMoveTopicResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCMoveTopicResult $make(CopyWithData data) => FCMoveTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCMoveTopicResultCopyWith<$R2, FCMoveTopicResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCMoveTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCRenameTopicResultMapper extends ClassMapperBase<FCRenameTopicResult> {
  FCRenameTopicResultMapper._();

  static FCRenameTopicResultMapper? _instance;
  static FCRenameTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCRenameTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCRenameTopicResult';

  static bool _$result(FCRenameTopicResult v) => v.result;
  static const Field<FCRenameTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCRenameTopicResult v) => v.resultText;
  static const Field<FCRenameTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCRenameTopicResult v) => v.isLoginMod;
  static const Field<FCRenameTopicResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCRenameTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCRenameTopicResult _instantiate(DecodingData data) {
    return FCRenameTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCRenameTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCRenameTopicResult>(map);
  }

  static FCRenameTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCRenameTopicResult>(json);
  }
}

mixin FCRenameTopicResultMappable {
  String toJson() {
    return FCRenameTopicResultMapper.ensureInitialized()
        .encodeJson<FCRenameTopicResult>(this as FCRenameTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCRenameTopicResultMapper.ensureInitialized()
        .encodeMap<FCRenameTopicResult>(this as FCRenameTopicResult);
  }

  FCRenameTopicResultCopyWith<
    FCRenameTopicResult,
    FCRenameTopicResult,
    FCRenameTopicResult
  >
  get copyWith =>
      _FCRenameTopicResultCopyWithImpl<
        FCRenameTopicResult,
        FCRenameTopicResult
      >(this as FCRenameTopicResult, $identity, $identity);
  @override
  String toString() {
    return FCRenameTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCRenameTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCRenameTopicResultMapper.ensureInitialized().equalsValue(
      this as FCRenameTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCRenameTopicResultMapper.ensureInitialized().hashValue(
      this as FCRenameTopicResult,
    );
  }
}

extension FCRenameTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCRenameTopicResult, $Out> {
  FCRenameTopicResultCopyWith<$R, FCRenameTopicResult, $Out>
  get $asFCRenameTopicResult => $base.as(
    (v, t, t2) => _FCRenameTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCRenameTopicResultCopyWith<
  $R,
  $In extends FCRenameTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCRenameTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCRenameTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCRenameTopicResult, $Out>
    implements FCRenameTopicResultCopyWith<$R, FCRenameTopicResult, $Out> {
  _FCRenameTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCRenameTopicResult> $mapper =
      FCRenameTopicResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCRenameTopicResult $make(CopyWithData data) => FCRenameTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCRenameTopicResultCopyWith<$R2, FCRenameTopicResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCRenameTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCMovePostResultMapper extends ClassMapperBase<FCMovePostResult> {
  FCMovePostResultMapper._();

  static FCMovePostResultMapper? _instance;
  static FCMovePostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCMovePostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCMovePostResult';

  static bool _$result(FCMovePostResult v) => v.result;
  static const Field<FCMovePostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCMovePostResult v) => v.resultText;
  static const Field<FCMovePostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCMovePostResult v) => v.isLoginMod;
  static const Field<FCMovePostResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCMovePostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCMovePostResult _instantiate(DecodingData data) {
    return FCMovePostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCMovePostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCMovePostResult>(map);
  }

  static FCMovePostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCMovePostResult>(json);
  }
}

mixin FCMovePostResultMappable {
  String toJson() {
    return FCMovePostResultMapper.ensureInitialized()
        .encodeJson<FCMovePostResult>(this as FCMovePostResult);
  }

  Map<String, dynamic> toMap() {
    return FCMovePostResultMapper.ensureInitialized()
        .encodeMap<FCMovePostResult>(this as FCMovePostResult);
  }

  FCMovePostResultCopyWith<FCMovePostResult, FCMovePostResult, FCMovePostResult>
  get copyWith =>
      _FCMovePostResultCopyWithImpl<FCMovePostResult, FCMovePostResult>(
        this as FCMovePostResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCMovePostResultMapper.ensureInitialized().stringifyValue(
      this as FCMovePostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCMovePostResultMapper.ensureInitialized().equalsValue(
      this as FCMovePostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCMovePostResultMapper.ensureInitialized().hashValue(
      this as FCMovePostResult,
    );
  }
}

extension FCMovePostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCMovePostResult, $Out> {
  FCMovePostResultCopyWith<$R, FCMovePostResult, $Out>
  get $asFCMovePostResult =>
      $base.as((v, t, t2) => _FCMovePostResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCMovePostResultCopyWith<$R, $In extends FCMovePostResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCMovePostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCMovePostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCMovePostResult, $Out>
    implements FCMovePostResultCopyWith<$R, FCMovePostResult, $Out> {
  _FCMovePostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCMovePostResult> $mapper =
      FCMovePostResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCMovePostResult $make(CopyWithData data) => FCMovePostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCMovePostResultCopyWith<$R2, FCMovePostResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCMovePostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCMergeTopicResultMapper extends ClassMapperBase<FCMergeTopicResult> {
  FCMergeTopicResultMapper._();

  static FCMergeTopicResultMapper? _instance;
  static FCMergeTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCMergeTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCMergeTopicResult';

  static bool _$result(FCMergeTopicResult v) => v.result;
  static const Field<FCMergeTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCMergeTopicResult v) => v.resultText;
  static const Field<FCMergeTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCMergeTopicResult v) => v.isLoginMod;
  static const Field<FCMergeTopicResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCMergeTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCMergeTopicResult _instantiate(DecodingData data) {
    return FCMergeTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCMergeTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCMergeTopicResult>(map);
  }

  static FCMergeTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCMergeTopicResult>(json);
  }
}

mixin FCMergeTopicResultMappable {
  String toJson() {
    return FCMergeTopicResultMapper.ensureInitialized()
        .encodeJson<FCMergeTopicResult>(this as FCMergeTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCMergeTopicResultMapper.ensureInitialized()
        .encodeMap<FCMergeTopicResult>(this as FCMergeTopicResult);
  }

  FCMergeTopicResultCopyWith<
    FCMergeTopicResult,
    FCMergeTopicResult,
    FCMergeTopicResult
  >
  get copyWith =>
      _FCMergeTopicResultCopyWithImpl<FCMergeTopicResult, FCMergeTopicResult>(
        this as FCMergeTopicResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCMergeTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCMergeTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCMergeTopicResultMapper.ensureInitialized().equalsValue(
      this as FCMergeTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCMergeTopicResultMapper.ensureInitialized().hashValue(
      this as FCMergeTopicResult,
    );
  }
}

extension FCMergeTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCMergeTopicResult, $Out> {
  FCMergeTopicResultCopyWith<$R, FCMergeTopicResult, $Out>
  get $asFCMergeTopicResult => $base.as(
    (v, t, t2) => _FCMergeTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCMergeTopicResultCopyWith<
  $R,
  $In extends FCMergeTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCMergeTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCMergeTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCMergeTopicResult, $Out>
    implements FCMergeTopicResultCopyWith<$R, FCMergeTopicResult, $Out> {
  _FCMergeTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCMergeTopicResult> $mapper =
      FCMergeTopicResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCMergeTopicResult $make(CopyWithData data) => FCMergeTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCMergeTopicResultCopyWith<$R2, FCMergeTopicResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCMergeTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCModerateTopicResultMapper
    extends ClassMapperBase<FCModerateTopicResult> {
  FCModerateTopicResultMapper._();

  static FCModerateTopicResultMapper? _instance;
  static FCModerateTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCModerateTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCModerateTopicMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCModerateTopicResult';

  static bool _$result(FCModerateTopicResult v) => v.result;
  static const Field<FCModerateTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCModerateTopicResult v) => v.resultText;
  static const Field<FCModerateTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCModerateTopicResult v) => v.isLoginMod;
  static const Field<FCModerateTopicResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );
  static int _$total(FCModerateTopicResult v) => v.total;
  static const Field<FCModerateTopicResult, int> _f$total = Field(
    'total',
    _$total,
  );
  static List<FCModerateTopic> _$list(FCModerateTopicResult v) => v.list;
  static const Field<FCModerateTopicResult, List<FCModerateTopic>> _f$list =
      Field('list', _$list);

  @override
  final MappableFields<FCModerateTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
    #total: _f$total,
    #list: _f$list,
  };

  static FCModerateTopicResult _instantiate(DecodingData data) {
    return FCModerateTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
      total: data.dec(_f$total),
      list: data.dec(_f$list),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCModerateTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCModerateTopicResult>(map);
  }

  static FCModerateTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCModerateTopicResult>(json);
  }
}

mixin FCModerateTopicResultMappable {
  String toJson() {
    return FCModerateTopicResultMapper.ensureInitialized()
        .encodeJson<FCModerateTopicResult>(this as FCModerateTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCModerateTopicResultMapper.ensureInitialized()
        .encodeMap<FCModerateTopicResult>(this as FCModerateTopicResult);
  }

  FCModerateTopicResultCopyWith<
    FCModerateTopicResult,
    FCModerateTopicResult,
    FCModerateTopicResult
  >
  get copyWith =>
      _FCModerateTopicResultCopyWithImpl<
        FCModerateTopicResult,
        FCModerateTopicResult
      >(this as FCModerateTopicResult, $identity, $identity);
  @override
  String toString() {
    return FCModerateTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCModerateTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCModerateTopicResultMapper.ensureInitialized().equalsValue(
      this as FCModerateTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCModerateTopicResultMapper.ensureInitialized().hashValue(
      this as FCModerateTopicResult,
    );
  }
}

extension FCModerateTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCModerateTopicResult, $Out> {
  FCModerateTopicResultCopyWith<$R, FCModerateTopicResult, $Out>
  get $asFCModerateTopicResult => $base.as(
    (v, t, t2) => _FCModerateTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCModerateTopicResultCopyWith<
  $R,
  $In extends FCModerateTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCModerateTopic,
    FCModerateTopicCopyWith<$R, FCModerateTopic, FCModerateTopic>
  >
  get list;
  @override
  $R call({
    bool? result,
    String? resultText,
    bool? isLoginMod,
    int? total,
    List<FCModerateTopic>? list,
  });
  FCModerateTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCModerateTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCModerateTopicResult, $Out>
    implements FCModerateTopicResultCopyWith<$R, FCModerateTopicResult, $Out> {
  _FCModerateTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCModerateTopicResult> $mapper =
      FCModerateTopicResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCModerateTopic,
    FCModerateTopicCopyWith<$R, FCModerateTopic, FCModerateTopic>
  >
  get list => ListCopyWith(
    $value.list,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(list: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    bool? isLoginMod,
    int? total,
    List<FCModerateTopic>? list,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (isLoginMod != null) #isLoginMod: isLoginMod,
      if (total != null) #total: total,
      if (list != null) #list: list,
    }),
  );
  @override
  FCModerateTopicResult $make(CopyWithData data) => FCModerateTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
    total: data.get(#total, or: $value.total),
    list: data.get(#list, or: $value.list),
  );

  @override
  FCModerateTopicResultCopyWith<$R2, FCModerateTopicResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCModerateTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCModerateTopicMapper extends ClassMapperBase<FCModerateTopic> {
  FCModerateTopicMapper._();

  static FCModerateTopicMapper? _instance;
  static FCModerateTopicMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCModerateTopicMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCModerateTopic';

  static String _$topicId(FCModerateTopic v) => v.topicId;
  static const Field<FCModerateTopic, String> _f$topicId = Field(
    'topicId',
    _$topicId,
  );
  static String _$topicTitle(FCModerateTopic v) => v.topicTitle;
  static const Field<FCModerateTopic, String> _f$topicTitle = Field(
    'topicTitle',
    _$topicTitle,
  );
  static String _$forumId(FCModerateTopic v) => v.forumId;
  static const Field<FCModerateTopic, String> _f$forumId = Field(
    'forumId',
    _$forumId,
  );
  static String _$forumName(FCModerateTopic v) => v.forumName;
  static const Field<FCModerateTopic, String> _f$forumName = Field(
    'forumName',
    _$forumName,
  );
  static String _$authorId(FCModerateTopic v) => v.authorId;
  static const Field<FCModerateTopic, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCModerateTopic v) => v.authorName;
  static const Field<FCModerateTopic, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static DateTime _$postTime(FCModerateTopic v) => v.postTime;
  static const Field<FCModerateTopic, DateTime> _f$postTime = Field(
    'postTime',
    _$postTime,
  );
  static int _$replyCount(FCModerateTopic v) => v.replyCount;
  static const Field<FCModerateTopic, int> _f$replyCount = Field(
    'replyCount',
    _$replyCount,
  );
  static int _$viewCount(FCModerateTopic v) => v.viewCount;
  static const Field<FCModerateTopic, int> _f$viewCount = Field(
    'viewCount',
    _$viewCount,
  );
  static String? _$shortContent(FCModerateTopic v) => v.shortContent;
  static const Field<FCModerateTopic, String> _f$shortContent = Field(
    'shortContent',
    _$shortContent,
    opt: true,
  );

  @override
  final MappableFields<FCModerateTopic> fields = const {
    #topicId: _f$topicId,
    #topicTitle: _f$topicTitle,
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #postTime: _f$postTime,
    #replyCount: _f$replyCount,
    #viewCount: _f$viewCount,
    #shortContent: _f$shortContent,
  };

  static FCModerateTopic _instantiate(DecodingData data) {
    return FCModerateTopic(
      topicId: data.dec(_f$topicId),
      topicTitle: data.dec(_f$topicTitle),
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      postTime: data.dec(_f$postTime),
      replyCount: data.dec(_f$replyCount),
      viewCount: data.dec(_f$viewCount),
      shortContent: data.dec(_f$shortContent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCModerateTopic fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCModerateTopic>(map);
  }

  static FCModerateTopic fromJson(String json) {
    return ensureInitialized().decodeJson<FCModerateTopic>(json);
  }
}

mixin FCModerateTopicMappable {
  String toJson() {
    return FCModerateTopicMapper.ensureInitialized()
        .encodeJson<FCModerateTopic>(this as FCModerateTopic);
  }

  Map<String, dynamic> toMap() {
    return FCModerateTopicMapper.ensureInitialized().encodeMap<FCModerateTopic>(
      this as FCModerateTopic,
    );
  }

  FCModerateTopicCopyWith<FCModerateTopic, FCModerateTopic, FCModerateTopic>
  get copyWith =>
      _FCModerateTopicCopyWithImpl<FCModerateTopic, FCModerateTopic>(
        this as FCModerateTopic,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCModerateTopicMapper.ensureInitialized().stringifyValue(
      this as FCModerateTopic,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCModerateTopicMapper.ensureInitialized().equalsValue(
      this as FCModerateTopic,
      other,
    );
  }

  @override
  int get hashCode {
    return FCModerateTopicMapper.ensureInitialized().hashValue(
      this as FCModerateTopic,
    );
  }
}

extension FCModerateTopicValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCModerateTopic, $Out> {
  FCModerateTopicCopyWith<$R, FCModerateTopic, $Out> get $asFCModerateTopic =>
      $base.as((v, t, t2) => _FCModerateTopicCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCModerateTopicCopyWith<$R, $In extends FCModerateTopic, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? topicId,
    String? topicTitle,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    DateTime? postTime,
    int? replyCount,
    int? viewCount,
    String? shortContent,
  });
  FCModerateTopicCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCModerateTopicCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCModerateTopic, $Out>
    implements FCModerateTopicCopyWith<$R, FCModerateTopic, $Out> {
  _FCModerateTopicCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCModerateTopic> $mapper =
      FCModerateTopicMapper.ensureInitialized();
  @override
  $R call({
    String? topicId,
    String? topicTitle,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    DateTime? postTime,
    int? replyCount,
    int? viewCount,
    Object? shortContent = $none,
  }) => $apply(
    FieldCopyWithData({
      if (topicId != null) #topicId: topicId,
      if (topicTitle != null) #topicTitle: topicTitle,
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (postTime != null) #postTime: postTime,
      if (replyCount != null) #replyCount: replyCount,
      if (viewCount != null) #viewCount: viewCount,
      if (shortContent != $none) #shortContent: shortContent,
    }),
  );
  @override
  FCModerateTopic $make(CopyWithData data) => FCModerateTopic(
    topicId: data.get(#topicId, or: $value.topicId),
    topicTitle: data.get(#topicTitle, or: $value.topicTitle),
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    postTime: data.get(#postTime, or: $value.postTime),
    replyCount: data.get(#replyCount, or: $value.replyCount),
    viewCount: data.get(#viewCount, or: $value.viewCount),
    shortContent: data.get(#shortContent, or: $value.shortContent),
  );

  @override
  FCModerateTopicCopyWith<$R2, FCModerateTopic, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCModerateTopicCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCModeratePostResultMapper extends ClassMapperBase<FCModeratePostResult> {
  FCModeratePostResultMapper._();

  static FCModeratePostResultMapper? _instance;
  static FCModeratePostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCModeratePostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCModeratePostMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCModeratePostResult';

  static bool _$result(FCModeratePostResult v) => v.result;
  static const Field<FCModeratePostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCModeratePostResult v) => v.resultText;
  static const Field<FCModeratePostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCModeratePostResult v) => v.isLoginMod;
  static const Field<FCModeratePostResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );
  static int _$total(FCModeratePostResult v) => v.total;
  static const Field<FCModeratePostResult, int> _f$total = Field(
    'total',
    _$total,
  );
  static List<FCModeratePost> _$list(FCModeratePostResult v) => v.list;
  static const Field<FCModeratePostResult, List<FCModeratePost>> _f$list =
      Field('list', _$list);

  @override
  final MappableFields<FCModeratePostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
    #total: _f$total,
    #list: _f$list,
  };

  static FCModeratePostResult _instantiate(DecodingData data) {
    return FCModeratePostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
      total: data.dec(_f$total),
      list: data.dec(_f$list),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCModeratePostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCModeratePostResult>(map);
  }

  static FCModeratePostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCModeratePostResult>(json);
  }
}

mixin FCModeratePostResultMappable {
  String toJson() {
    return FCModeratePostResultMapper.ensureInitialized()
        .encodeJson<FCModeratePostResult>(this as FCModeratePostResult);
  }

  Map<String, dynamic> toMap() {
    return FCModeratePostResultMapper.ensureInitialized()
        .encodeMap<FCModeratePostResult>(this as FCModeratePostResult);
  }

  FCModeratePostResultCopyWith<
    FCModeratePostResult,
    FCModeratePostResult,
    FCModeratePostResult
  >
  get copyWith =>
      _FCModeratePostResultCopyWithImpl<
        FCModeratePostResult,
        FCModeratePostResult
      >(this as FCModeratePostResult, $identity, $identity);
  @override
  String toString() {
    return FCModeratePostResultMapper.ensureInitialized().stringifyValue(
      this as FCModeratePostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCModeratePostResultMapper.ensureInitialized().equalsValue(
      this as FCModeratePostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCModeratePostResultMapper.ensureInitialized().hashValue(
      this as FCModeratePostResult,
    );
  }
}

extension FCModeratePostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCModeratePostResult, $Out> {
  FCModeratePostResultCopyWith<$R, FCModeratePostResult, $Out>
  get $asFCModeratePostResult => $base.as(
    (v, t, t2) => _FCModeratePostResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCModeratePostResultCopyWith<
  $R,
  $In extends FCModeratePostResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCModeratePost,
    FCModeratePostCopyWith<$R, FCModeratePost, FCModeratePost>
  >
  get list;
  @override
  $R call({
    bool? result,
    String? resultText,
    bool? isLoginMod,
    int? total,
    List<FCModeratePost>? list,
  });
  FCModeratePostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCModeratePostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCModeratePostResult, $Out>
    implements FCModeratePostResultCopyWith<$R, FCModeratePostResult, $Out> {
  _FCModeratePostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCModeratePostResult> $mapper =
      FCModeratePostResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCModeratePost,
    FCModeratePostCopyWith<$R, FCModeratePost, FCModeratePost>
  >
  get list => ListCopyWith(
    $value.list,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(list: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    bool? isLoginMod,
    int? total,
    List<FCModeratePost>? list,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (isLoginMod != null) #isLoginMod: isLoginMod,
      if (total != null) #total: total,
      if (list != null) #list: list,
    }),
  );
  @override
  FCModeratePostResult $make(CopyWithData data) => FCModeratePostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
    total: data.get(#total, or: $value.total),
    list: data.get(#list, or: $value.list),
  );

  @override
  FCModeratePostResultCopyWith<$R2, FCModeratePostResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCModeratePostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCModeratePostMapper extends ClassMapperBase<FCModeratePost> {
  FCModeratePostMapper._();

  static FCModeratePostMapper? _instance;
  static FCModeratePostMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCModeratePostMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCModeratePost';

  static String _$postId(FCModeratePost v) => v.postId;
  static const Field<FCModeratePost, String> _f$postId = Field(
    'postId',
    _$postId,
  );
  static String? _$postTitle(FCModeratePost v) => v.postTitle;
  static const Field<FCModeratePost, String> _f$postTitle = Field(
    'postTitle',
    _$postTitle,
    opt: true,
  );
  static String _$topicId(FCModeratePost v) => v.topicId;
  static const Field<FCModeratePost, String> _f$topicId = Field(
    'topicId',
    _$topicId,
  );
  static String _$topicTitle(FCModeratePost v) => v.topicTitle;
  static const Field<FCModeratePost, String> _f$topicTitle = Field(
    'topicTitle',
    _$topicTitle,
  );
  static String _$forumId(FCModeratePost v) => v.forumId;
  static const Field<FCModeratePost, String> _f$forumId = Field(
    'forumId',
    _$forumId,
  );
  static String _$forumName(FCModeratePost v) => v.forumName;
  static const Field<FCModeratePost, String> _f$forumName = Field(
    'forumName',
    _$forumName,
  );
  static String _$authorId(FCModeratePost v) => v.authorId;
  static const Field<FCModeratePost, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCModeratePost v) => v.authorName;
  static const Field<FCModeratePost, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static DateTime _$postTime(FCModeratePost v) => v.postTime;
  static const Field<FCModeratePost, DateTime> _f$postTime = Field(
    'postTime',
    _$postTime,
  );
  static String? _$postContent(FCModeratePost v) => v.postContent;
  static const Field<FCModeratePost, String> _f$postContent = Field(
    'postContent',
    _$postContent,
    opt: true,
  );

  @override
  final MappableFields<FCModeratePost> fields = const {
    #postId: _f$postId,
    #postTitle: _f$postTitle,
    #topicId: _f$topicId,
    #topicTitle: _f$topicTitle,
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #postTime: _f$postTime,
    #postContent: _f$postContent,
  };

  static FCModeratePost _instantiate(DecodingData data) {
    return FCModeratePost(
      postId: data.dec(_f$postId),
      postTitle: data.dec(_f$postTitle),
      topicId: data.dec(_f$topicId),
      topicTitle: data.dec(_f$topicTitle),
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      postTime: data.dec(_f$postTime),
      postContent: data.dec(_f$postContent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCModeratePost fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCModeratePost>(map);
  }

  static FCModeratePost fromJson(String json) {
    return ensureInitialized().decodeJson<FCModeratePost>(json);
  }
}

mixin FCModeratePostMappable {
  String toJson() {
    return FCModeratePostMapper.ensureInitialized().encodeJson<FCModeratePost>(
      this as FCModeratePost,
    );
  }

  Map<String, dynamic> toMap() {
    return FCModeratePostMapper.ensureInitialized().encodeMap<FCModeratePost>(
      this as FCModeratePost,
    );
  }

  FCModeratePostCopyWith<FCModeratePost, FCModeratePost, FCModeratePost>
  get copyWith => _FCModeratePostCopyWithImpl<FCModeratePost, FCModeratePost>(
    this as FCModeratePost,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCModeratePostMapper.ensureInitialized().stringifyValue(
      this as FCModeratePost,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCModeratePostMapper.ensureInitialized().equalsValue(
      this as FCModeratePost,
      other,
    );
  }

  @override
  int get hashCode {
    return FCModeratePostMapper.ensureInitialized().hashValue(
      this as FCModeratePost,
    );
  }
}

extension FCModeratePostValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCModeratePost, $Out> {
  FCModeratePostCopyWith<$R, FCModeratePost, $Out> get $asFCModeratePost =>
      $base.as((v, t, t2) => _FCModeratePostCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCModeratePostCopyWith<$R, $In extends FCModeratePost, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? postId,
    String? postTitle,
    String? topicId,
    String? topicTitle,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    DateTime? postTime,
    String? postContent,
  });
  FCModeratePostCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCModeratePostCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCModeratePost, $Out>
    implements FCModeratePostCopyWith<$R, FCModeratePost, $Out> {
  _FCModeratePostCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCModeratePost> $mapper =
      FCModeratePostMapper.ensureInitialized();
  @override
  $R call({
    String? postId,
    Object? postTitle = $none,
    String? topicId,
    String? topicTitle,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    DateTime? postTime,
    Object? postContent = $none,
  }) => $apply(
    FieldCopyWithData({
      if (postId != null) #postId: postId,
      if (postTitle != $none) #postTitle: postTitle,
      if (topicId != null) #topicId: topicId,
      if (topicTitle != null) #topicTitle: topicTitle,
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (postTime != null) #postTime: postTime,
      if (postContent != $none) #postContent: postContent,
    }),
  );
  @override
  FCModeratePost $make(CopyWithData data) => FCModeratePost(
    postId: data.get(#postId, or: $value.postId),
    postTitle: data.get(#postTitle, or: $value.postTitle),
    topicId: data.get(#topicId, or: $value.topicId),
    topicTitle: data.get(#topicTitle, or: $value.topicTitle),
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    postTime: data.get(#postTime, or: $value.postTime),
    postContent: data.get(#postContent, or: $value.postContent),
  );

  @override
  FCModeratePostCopyWith<$R2, FCModeratePost, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCModeratePostCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCDeletedTopicResultMapper extends ClassMapperBase<FCDeletedTopicResult> {
  FCDeletedTopicResultMapper._();

  static FCDeletedTopicResultMapper? _instance;
  static FCDeletedTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCDeletedTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCDeletedTopicMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCDeletedTopicResult';

  static bool _$result(FCDeletedTopicResult v) => v.result;
  static const Field<FCDeletedTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCDeletedTopicResult v) => v.resultText;
  static const Field<FCDeletedTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCDeletedTopicResult v) => v.isLoginMod;
  static const Field<FCDeletedTopicResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );
  static int _$total(FCDeletedTopicResult v) => v.total;
  static const Field<FCDeletedTopicResult, int> _f$total = Field(
    'total',
    _$total,
  );
  static List<FCDeletedTopic> _$list(FCDeletedTopicResult v) => v.list;
  static const Field<FCDeletedTopicResult, List<FCDeletedTopic>> _f$list =
      Field('list', _$list);

  @override
  final MappableFields<FCDeletedTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
    #total: _f$total,
    #list: _f$list,
  };

  static FCDeletedTopicResult _instantiate(DecodingData data) {
    return FCDeletedTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
      total: data.dec(_f$total),
      list: data.dec(_f$list),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCDeletedTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCDeletedTopicResult>(map);
  }

  static FCDeletedTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCDeletedTopicResult>(json);
  }
}

mixin FCDeletedTopicResultMappable {
  String toJson() {
    return FCDeletedTopicResultMapper.ensureInitialized()
        .encodeJson<FCDeletedTopicResult>(this as FCDeletedTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCDeletedTopicResultMapper.ensureInitialized()
        .encodeMap<FCDeletedTopicResult>(this as FCDeletedTopicResult);
  }

  FCDeletedTopicResultCopyWith<
    FCDeletedTopicResult,
    FCDeletedTopicResult,
    FCDeletedTopicResult
  >
  get copyWith =>
      _FCDeletedTopicResultCopyWithImpl<
        FCDeletedTopicResult,
        FCDeletedTopicResult
      >(this as FCDeletedTopicResult, $identity, $identity);
  @override
  String toString() {
    return FCDeletedTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCDeletedTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCDeletedTopicResultMapper.ensureInitialized().equalsValue(
      this as FCDeletedTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCDeletedTopicResultMapper.ensureInitialized().hashValue(
      this as FCDeletedTopicResult,
    );
  }
}

extension FCDeletedTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCDeletedTopicResult, $Out> {
  FCDeletedTopicResultCopyWith<$R, FCDeletedTopicResult, $Out>
  get $asFCDeletedTopicResult => $base.as(
    (v, t, t2) => _FCDeletedTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCDeletedTopicResultCopyWith<
  $R,
  $In extends FCDeletedTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCDeletedTopic,
    FCDeletedTopicCopyWith<$R, FCDeletedTopic, FCDeletedTopic>
  >
  get list;
  @override
  $R call({
    bool? result,
    String? resultText,
    bool? isLoginMod,
    int? total,
    List<FCDeletedTopic>? list,
  });
  FCDeletedTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCDeletedTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCDeletedTopicResult, $Out>
    implements FCDeletedTopicResultCopyWith<$R, FCDeletedTopicResult, $Out> {
  _FCDeletedTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCDeletedTopicResult> $mapper =
      FCDeletedTopicResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCDeletedTopic,
    FCDeletedTopicCopyWith<$R, FCDeletedTopic, FCDeletedTopic>
  >
  get list => ListCopyWith(
    $value.list,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(list: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    bool? isLoginMod,
    int? total,
    List<FCDeletedTopic>? list,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (isLoginMod != null) #isLoginMod: isLoginMod,
      if (total != null) #total: total,
      if (list != null) #list: list,
    }),
  );
  @override
  FCDeletedTopicResult $make(CopyWithData data) => FCDeletedTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
    total: data.get(#total, or: $value.total),
    list: data.get(#list, or: $value.list),
  );

  @override
  FCDeletedTopicResultCopyWith<$R2, FCDeletedTopicResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCDeletedTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCDeletedTopicMapper extends ClassMapperBase<FCDeletedTopic> {
  FCDeletedTopicMapper._();

  static FCDeletedTopicMapper? _instance;
  static FCDeletedTopicMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCDeletedTopicMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCDeletedTopic';

  static String _$topicId(FCDeletedTopic v) => v.topicId;
  static const Field<FCDeletedTopic, String> _f$topicId = Field(
    'topicId',
    _$topicId,
  );
  static String _$topicTitle(FCDeletedTopic v) => v.topicTitle;
  static const Field<FCDeletedTopic, String> _f$topicTitle = Field(
    'topicTitle',
    _$topicTitle,
  );
  static String _$forumId(FCDeletedTopic v) => v.forumId;
  static const Field<FCDeletedTopic, String> _f$forumId = Field(
    'forumId',
    _$forumId,
  );
  static String _$forumName(FCDeletedTopic v) => v.forumName;
  static const Field<FCDeletedTopic, String> _f$forumName = Field(
    'forumName',
    _$forumName,
  );
  static String _$authorId(FCDeletedTopic v) => v.authorId;
  static const Field<FCDeletedTopic, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCDeletedTopic v) => v.authorName;
  static const Field<FCDeletedTopic, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static DateTime _$postTime(FCDeletedTopic v) => v.postTime;
  static const Field<FCDeletedTopic, DateTime> _f$postTime = Field(
    'postTime',
    _$postTime,
  );
  static int _$replyCount(FCDeletedTopic v) => v.replyCount;
  static const Field<FCDeletedTopic, int> _f$replyCount = Field(
    'replyCount',
    _$replyCount,
  );
  static int _$viewCount(FCDeletedTopic v) => v.viewCount;
  static const Field<FCDeletedTopic, int> _f$viewCount = Field(
    'viewCount',
    _$viewCount,
  );
  static String? _$shortContent(FCDeletedTopic v) => v.shortContent;
  static const Field<FCDeletedTopic, String> _f$shortContent = Field(
    'shortContent',
    _$shortContent,
    opt: true,
  );

  @override
  final MappableFields<FCDeletedTopic> fields = const {
    #topicId: _f$topicId,
    #topicTitle: _f$topicTitle,
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #postTime: _f$postTime,
    #replyCount: _f$replyCount,
    #viewCount: _f$viewCount,
    #shortContent: _f$shortContent,
  };

  static FCDeletedTopic _instantiate(DecodingData data) {
    return FCDeletedTopic(
      topicId: data.dec(_f$topicId),
      topicTitle: data.dec(_f$topicTitle),
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      postTime: data.dec(_f$postTime),
      replyCount: data.dec(_f$replyCount),
      viewCount: data.dec(_f$viewCount),
      shortContent: data.dec(_f$shortContent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCDeletedTopic fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCDeletedTopic>(map);
  }

  static FCDeletedTopic fromJson(String json) {
    return ensureInitialized().decodeJson<FCDeletedTopic>(json);
  }
}

mixin FCDeletedTopicMappable {
  String toJson() {
    return FCDeletedTopicMapper.ensureInitialized().encodeJson<FCDeletedTopic>(
      this as FCDeletedTopic,
    );
  }

  Map<String, dynamic> toMap() {
    return FCDeletedTopicMapper.ensureInitialized().encodeMap<FCDeletedTopic>(
      this as FCDeletedTopic,
    );
  }

  FCDeletedTopicCopyWith<FCDeletedTopic, FCDeletedTopic, FCDeletedTopic>
  get copyWith => _FCDeletedTopicCopyWithImpl<FCDeletedTopic, FCDeletedTopic>(
    this as FCDeletedTopic,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCDeletedTopicMapper.ensureInitialized().stringifyValue(
      this as FCDeletedTopic,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCDeletedTopicMapper.ensureInitialized().equalsValue(
      this as FCDeletedTopic,
      other,
    );
  }

  @override
  int get hashCode {
    return FCDeletedTopicMapper.ensureInitialized().hashValue(
      this as FCDeletedTopic,
    );
  }
}

extension FCDeletedTopicValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCDeletedTopic, $Out> {
  FCDeletedTopicCopyWith<$R, FCDeletedTopic, $Out> get $asFCDeletedTopic =>
      $base.as((v, t, t2) => _FCDeletedTopicCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCDeletedTopicCopyWith<$R, $In extends FCDeletedTopic, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? topicId,
    String? topicTitle,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    DateTime? postTime,
    int? replyCount,
    int? viewCount,
    String? shortContent,
  });
  FCDeletedTopicCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCDeletedTopicCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCDeletedTopic, $Out>
    implements FCDeletedTopicCopyWith<$R, FCDeletedTopic, $Out> {
  _FCDeletedTopicCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCDeletedTopic> $mapper =
      FCDeletedTopicMapper.ensureInitialized();
  @override
  $R call({
    String? topicId,
    String? topicTitle,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    DateTime? postTime,
    int? replyCount,
    int? viewCount,
    Object? shortContent = $none,
  }) => $apply(
    FieldCopyWithData({
      if (topicId != null) #topicId: topicId,
      if (topicTitle != null) #topicTitle: topicTitle,
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (postTime != null) #postTime: postTime,
      if (replyCount != null) #replyCount: replyCount,
      if (viewCount != null) #viewCount: viewCount,
      if (shortContent != $none) #shortContent: shortContent,
    }),
  );
  @override
  FCDeletedTopic $make(CopyWithData data) => FCDeletedTopic(
    topicId: data.get(#topicId, or: $value.topicId),
    topicTitle: data.get(#topicTitle, or: $value.topicTitle),
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    postTime: data.get(#postTime, or: $value.postTime),
    replyCount: data.get(#replyCount, or: $value.replyCount),
    viewCount: data.get(#viewCount, or: $value.viewCount),
    shortContent: data.get(#shortContent, or: $value.shortContent),
  );

  @override
  FCDeletedTopicCopyWith<$R2, FCDeletedTopic, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCDeletedTopicCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCDeletedPostResultMapper extends ClassMapperBase<FCDeletedPostResult> {
  FCDeletedPostResultMapper._();

  static FCDeletedPostResultMapper? _instance;
  static FCDeletedPostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCDeletedPostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCDeletedPostMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCDeletedPostResult';

  static bool _$result(FCDeletedPostResult v) => v.result;
  static const Field<FCDeletedPostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCDeletedPostResult v) => v.resultText;
  static const Field<FCDeletedPostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCDeletedPostResult v) => v.isLoginMod;
  static const Field<FCDeletedPostResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );
  static int _$total(FCDeletedPostResult v) => v.total;
  static const Field<FCDeletedPostResult, int> _f$total = Field(
    'total',
    _$total,
  );
  static List<FCDeletedPost> _$list(FCDeletedPostResult v) => v.list;
  static const Field<FCDeletedPostResult, List<FCDeletedPost>> _f$list = Field(
    'list',
    _$list,
  );

  @override
  final MappableFields<FCDeletedPostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
    #total: _f$total,
    #list: _f$list,
  };

  static FCDeletedPostResult _instantiate(DecodingData data) {
    return FCDeletedPostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
      total: data.dec(_f$total),
      list: data.dec(_f$list),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCDeletedPostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCDeletedPostResult>(map);
  }

  static FCDeletedPostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCDeletedPostResult>(json);
  }
}

mixin FCDeletedPostResultMappable {
  String toJson() {
    return FCDeletedPostResultMapper.ensureInitialized()
        .encodeJson<FCDeletedPostResult>(this as FCDeletedPostResult);
  }

  Map<String, dynamic> toMap() {
    return FCDeletedPostResultMapper.ensureInitialized()
        .encodeMap<FCDeletedPostResult>(this as FCDeletedPostResult);
  }

  FCDeletedPostResultCopyWith<
    FCDeletedPostResult,
    FCDeletedPostResult,
    FCDeletedPostResult
  >
  get copyWith =>
      _FCDeletedPostResultCopyWithImpl<
        FCDeletedPostResult,
        FCDeletedPostResult
      >(this as FCDeletedPostResult, $identity, $identity);
  @override
  String toString() {
    return FCDeletedPostResultMapper.ensureInitialized().stringifyValue(
      this as FCDeletedPostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCDeletedPostResultMapper.ensureInitialized().equalsValue(
      this as FCDeletedPostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCDeletedPostResultMapper.ensureInitialized().hashValue(
      this as FCDeletedPostResult,
    );
  }
}

extension FCDeletedPostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCDeletedPostResult, $Out> {
  FCDeletedPostResultCopyWith<$R, FCDeletedPostResult, $Out>
  get $asFCDeletedPostResult => $base.as(
    (v, t, t2) => _FCDeletedPostResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCDeletedPostResultCopyWith<
  $R,
  $In extends FCDeletedPostResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCDeletedPost,
    FCDeletedPostCopyWith<$R, FCDeletedPost, FCDeletedPost>
  >
  get list;
  @override
  $R call({
    bool? result,
    String? resultText,
    bool? isLoginMod,
    int? total,
    List<FCDeletedPost>? list,
  });
  FCDeletedPostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCDeletedPostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCDeletedPostResult, $Out>
    implements FCDeletedPostResultCopyWith<$R, FCDeletedPostResult, $Out> {
  _FCDeletedPostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCDeletedPostResult> $mapper =
      FCDeletedPostResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCDeletedPost,
    FCDeletedPostCopyWith<$R, FCDeletedPost, FCDeletedPost>
  >
  get list => ListCopyWith(
    $value.list,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(list: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    bool? isLoginMod,
    int? total,
    List<FCDeletedPost>? list,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (isLoginMod != null) #isLoginMod: isLoginMod,
      if (total != null) #total: total,
      if (list != null) #list: list,
    }),
  );
  @override
  FCDeletedPostResult $make(CopyWithData data) => FCDeletedPostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
    total: data.get(#total, or: $value.total),
    list: data.get(#list, or: $value.list),
  );

  @override
  FCDeletedPostResultCopyWith<$R2, FCDeletedPostResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCDeletedPostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCDeletedPostMapper extends ClassMapperBase<FCDeletedPost> {
  FCDeletedPostMapper._();

  static FCDeletedPostMapper? _instance;
  static FCDeletedPostMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCDeletedPostMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCDeletedPost';

  static String _$postId(FCDeletedPost v) => v.postId;
  static const Field<FCDeletedPost, String> _f$postId = Field(
    'postId',
    _$postId,
  );
  static String? _$postTitle(FCDeletedPost v) => v.postTitle;
  static const Field<FCDeletedPost, String> _f$postTitle = Field(
    'postTitle',
    _$postTitle,
    opt: true,
  );
  static String _$topicId(FCDeletedPost v) => v.topicId;
  static const Field<FCDeletedPost, String> _f$topicId = Field(
    'topicId',
    _$topicId,
  );
  static String _$topicTitle(FCDeletedPost v) => v.topicTitle;
  static const Field<FCDeletedPost, String> _f$topicTitle = Field(
    'topicTitle',
    _$topicTitle,
  );
  static String _$forumId(FCDeletedPost v) => v.forumId;
  static const Field<FCDeletedPost, String> _f$forumId = Field(
    'forumId',
    _$forumId,
  );
  static String _$forumName(FCDeletedPost v) => v.forumName;
  static const Field<FCDeletedPost, String> _f$forumName = Field(
    'forumName',
    _$forumName,
  );
  static String _$authorId(FCDeletedPost v) => v.authorId;
  static const Field<FCDeletedPost, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCDeletedPost v) => v.authorName;
  static const Field<FCDeletedPost, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static DateTime _$postTime(FCDeletedPost v) => v.postTime;
  static const Field<FCDeletedPost, DateTime> _f$postTime = Field(
    'postTime',
    _$postTime,
  );
  static String? _$postContent(FCDeletedPost v) => v.postContent;
  static const Field<FCDeletedPost, String> _f$postContent = Field(
    'postContent',
    _$postContent,
    opt: true,
  );

  @override
  final MappableFields<FCDeletedPost> fields = const {
    #postId: _f$postId,
    #postTitle: _f$postTitle,
    #topicId: _f$topicId,
    #topicTitle: _f$topicTitle,
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #postTime: _f$postTime,
    #postContent: _f$postContent,
  };

  static FCDeletedPost _instantiate(DecodingData data) {
    return FCDeletedPost(
      postId: data.dec(_f$postId),
      postTitle: data.dec(_f$postTitle),
      topicId: data.dec(_f$topicId),
      topicTitle: data.dec(_f$topicTitle),
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      postTime: data.dec(_f$postTime),
      postContent: data.dec(_f$postContent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCDeletedPost fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCDeletedPost>(map);
  }

  static FCDeletedPost fromJson(String json) {
    return ensureInitialized().decodeJson<FCDeletedPost>(json);
  }
}

mixin FCDeletedPostMappable {
  String toJson() {
    return FCDeletedPostMapper.ensureInitialized().encodeJson<FCDeletedPost>(
      this as FCDeletedPost,
    );
  }

  Map<String, dynamic> toMap() {
    return FCDeletedPostMapper.ensureInitialized().encodeMap<FCDeletedPost>(
      this as FCDeletedPost,
    );
  }

  FCDeletedPostCopyWith<FCDeletedPost, FCDeletedPost, FCDeletedPost>
  get copyWith => _FCDeletedPostCopyWithImpl<FCDeletedPost, FCDeletedPost>(
    this as FCDeletedPost,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCDeletedPostMapper.ensureInitialized().stringifyValue(
      this as FCDeletedPost,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCDeletedPostMapper.ensureInitialized().equalsValue(
      this as FCDeletedPost,
      other,
    );
  }

  @override
  int get hashCode {
    return FCDeletedPostMapper.ensureInitialized().hashValue(
      this as FCDeletedPost,
    );
  }
}

extension FCDeletedPostValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCDeletedPost, $Out> {
  FCDeletedPostCopyWith<$R, FCDeletedPost, $Out> get $asFCDeletedPost =>
      $base.as((v, t, t2) => _FCDeletedPostCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCDeletedPostCopyWith<$R, $In extends FCDeletedPost, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? postId,
    String? postTitle,
    String? topicId,
    String? topicTitle,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    DateTime? postTime,
    String? postContent,
  });
  FCDeletedPostCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCDeletedPostCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCDeletedPost, $Out>
    implements FCDeletedPostCopyWith<$R, FCDeletedPost, $Out> {
  _FCDeletedPostCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCDeletedPost> $mapper =
      FCDeletedPostMapper.ensureInitialized();
  @override
  $R call({
    String? postId,
    Object? postTitle = $none,
    String? topicId,
    String? topicTitle,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    DateTime? postTime,
    Object? postContent = $none,
  }) => $apply(
    FieldCopyWithData({
      if (postId != null) #postId: postId,
      if (postTitle != $none) #postTitle: postTitle,
      if (topicId != null) #topicId: topicId,
      if (topicTitle != null) #topicTitle: topicTitle,
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (postTime != null) #postTime: postTime,
      if (postContent != $none) #postContent: postContent,
    }),
  );
  @override
  FCDeletedPost $make(CopyWithData data) => FCDeletedPost(
    postId: data.get(#postId, or: $value.postId),
    postTitle: data.get(#postTitle, or: $value.postTitle),
    topicId: data.get(#topicId, or: $value.topicId),
    topicTitle: data.get(#topicTitle, or: $value.topicTitle),
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    postTime: data.get(#postTime, or: $value.postTime),
    postContent: data.get(#postContent, or: $value.postContent),
  );

  @override
  FCDeletedPostCopyWith<$R2, FCDeletedPost, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCDeletedPostCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCReportedPostResultMapper extends ClassMapperBase<FCReportedPostResult> {
  FCReportedPostResultMapper._();

  static FCReportedPostResultMapper? _instance;
  static FCReportedPostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCReportedPostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCReportedPostMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCReportedPostResult';

  static bool _$result(FCReportedPostResult v) => v.result;
  static const Field<FCReportedPostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCReportedPostResult v) => v.resultText;
  static const Field<FCReportedPostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCReportedPostResult v) => v.isLoginMod;
  static const Field<FCReportedPostResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );
  static int _$total(FCReportedPostResult v) => v.total;
  static const Field<FCReportedPostResult, int> _f$total = Field(
    'total',
    _$total,
  );
  static List<FCReportedPost> _$list(FCReportedPostResult v) => v.list;
  static const Field<FCReportedPostResult, List<FCReportedPost>> _f$list =
      Field('list', _$list);

  @override
  final MappableFields<FCReportedPostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
    #total: _f$total,
    #list: _f$list,
  };

  static FCReportedPostResult _instantiate(DecodingData data) {
    return FCReportedPostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
      total: data.dec(_f$total),
      list: data.dec(_f$list),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCReportedPostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCReportedPostResult>(map);
  }

  static FCReportedPostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCReportedPostResult>(json);
  }
}

mixin FCReportedPostResultMappable {
  String toJson() {
    return FCReportedPostResultMapper.ensureInitialized()
        .encodeJson<FCReportedPostResult>(this as FCReportedPostResult);
  }

  Map<String, dynamic> toMap() {
    return FCReportedPostResultMapper.ensureInitialized()
        .encodeMap<FCReportedPostResult>(this as FCReportedPostResult);
  }

  FCReportedPostResultCopyWith<
    FCReportedPostResult,
    FCReportedPostResult,
    FCReportedPostResult
  >
  get copyWith =>
      _FCReportedPostResultCopyWithImpl<
        FCReportedPostResult,
        FCReportedPostResult
      >(this as FCReportedPostResult, $identity, $identity);
  @override
  String toString() {
    return FCReportedPostResultMapper.ensureInitialized().stringifyValue(
      this as FCReportedPostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCReportedPostResultMapper.ensureInitialized().equalsValue(
      this as FCReportedPostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCReportedPostResultMapper.ensureInitialized().hashValue(
      this as FCReportedPostResult,
    );
  }
}

extension FCReportedPostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCReportedPostResult, $Out> {
  FCReportedPostResultCopyWith<$R, FCReportedPostResult, $Out>
  get $asFCReportedPostResult => $base.as(
    (v, t, t2) => _FCReportedPostResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCReportedPostResultCopyWith<
  $R,
  $In extends FCReportedPostResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCReportedPost,
    FCReportedPostCopyWith<$R, FCReportedPost, FCReportedPost>
  >
  get list;
  @override
  $R call({
    bool? result,
    String? resultText,
    bool? isLoginMod,
    int? total,
    List<FCReportedPost>? list,
  });
  FCReportedPostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCReportedPostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCReportedPostResult, $Out>
    implements FCReportedPostResultCopyWith<$R, FCReportedPostResult, $Out> {
  _FCReportedPostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCReportedPostResult> $mapper =
      FCReportedPostResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCReportedPost,
    FCReportedPostCopyWith<$R, FCReportedPost, FCReportedPost>
  >
  get list => ListCopyWith(
    $value.list,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(list: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    bool? isLoginMod,
    int? total,
    List<FCReportedPost>? list,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (isLoginMod != null) #isLoginMod: isLoginMod,
      if (total != null) #total: total,
      if (list != null) #list: list,
    }),
  );
  @override
  FCReportedPostResult $make(CopyWithData data) => FCReportedPostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
    total: data.get(#total, or: $value.total),
    list: data.get(#list, or: $value.list),
  );

  @override
  FCReportedPostResultCopyWith<$R2, FCReportedPostResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCReportedPostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCReportedPostMapper extends ClassMapperBase<FCReportedPost> {
  FCReportedPostMapper._();

  static FCReportedPostMapper? _instance;
  static FCReportedPostMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCReportedPostMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCReportedPost';

  static String _$postId(FCReportedPost v) => v.postId;
  static const Field<FCReportedPost, String> _f$postId = Field(
    'postId',
    _$postId,
  );
  static String? _$postTitle(FCReportedPost v) => v.postTitle;
  static const Field<FCReportedPost, String> _f$postTitle = Field(
    'postTitle',
    _$postTitle,
    opt: true,
  );
  static String _$topicId(FCReportedPost v) => v.topicId;
  static const Field<FCReportedPost, String> _f$topicId = Field(
    'topicId',
    _$topicId,
  );
  static String _$topicTitle(FCReportedPost v) => v.topicTitle;
  static const Field<FCReportedPost, String> _f$topicTitle = Field(
    'topicTitle',
    _$topicTitle,
  );
  static String _$forumId(FCReportedPost v) => v.forumId;
  static const Field<FCReportedPost, String> _f$forumId = Field(
    'forumId',
    _$forumId,
  );
  static String _$forumName(FCReportedPost v) => v.forumName;
  static const Field<FCReportedPost, String> _f$forumName = Field(
    'forumName',
    _$forumName,
  );
  static String _$authorId(FCReportedPost v) => v.authorId;
  static const Field<FCReportedPost, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCReportedPost v) => v.authorName;
  static const Field<FCReportedPost, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static DateTime _$postTime(FCReportedPost v) => v.postTime;
  static const Field<FCReportedPost, DateTime> _f$postTime = Field(
    'postTime',
    _$postTime,
  );
  static String? _$postContent(FCReportedPost v) => v.postContent;
  static const Field<FCReportedPost, String> _f$postContent = Field(
    'postContent',
    _$postContent,
    opt: true,
  );
  static String? _$reportReason(FCReportedPost v) => v.reportReason;
  static const Field<FCReportedPost, String> _f$reportReason = Field(
    'reportReason',
    _$reportReason,
    opt: true,
  );
  static String? _$reporterId(FCReportedPost v) => v.reporterId;
  static const Field<FCReportedPost, String> _f$reporterId = Field(
    'reporterId',
    _$reporterId,
    opt: true,
  );
  static String? _$reporterName(FCReportedPost v) => v.reporterName;
  static const Field<FCReportedPost, String> _f$reporterName = Field(
    'reporterName',
    _$reporterName,
    opt: true,
  );
  static DateTime? _$reportTime(FCReportedPost v) => v.reportTime;
  static const Field<FCReportedPost, DateTime> _f$reportTime = Field(
    'reportTime',
    _$reportTime,
    opt: true,
  );

  @override
  final MappableFields<FCReportedPost> fields = const {
    #postId: _f$postId,
    #postTitle: _f$postTitle,
    #topicId: _f$topicId,
    #topicTitle: _f$topicTitle,
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #postTime: _f$postTime,
    #postContent: _f$postContent,
    #reportReason: _f$reportReason,
    #reporterId: _f$reporterId,
    #reporterName: _f$reporterName,
    #reportTime: _f$reportTime,
  };

  static FCReportedPost _instantiate(DecodingData data) {
    return FCReportedPost(
      postId: data.dec(_f$postId),
      postTitle: data.dec(_f$postTitle),
      topicId: data.dec(_f$topicId),
      topicTitle: data.dec(_f$topicTitle),
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      postTime: data.dec(_f$postTime),
      postContent: data.dec(_f$postContent),
      reportReason: data.dec(_f$reportReason),
      reporterId: data.dec(_f$reporterId),
      reporterName: data.dec(_f$reporterName),
      reportTime: data.dec(_f$reportTime),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCReportedPost fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCReportedPost>(map);
  }

  static FCReportedPost fromJson(String json) {
    return ensureInitialized().decodeJson<FCReportedPost>(json);
  }
}

mixin FCReportedPostMappable {
  String toJson() {
    return FCReportedPostMapper.ensureInitialized().encodeJson<FCReportedPost>(
      this as FCReportedPost,
    );
  }

  Map<String, dynamic> toMap() {
    return FCReportedPostMapper.ensureInitialized().encodeMap<FCReportedPost>(
      this as FCReportedPost,
    );
  }

  FCReportedPostCopyWith<FCReportedPost, FCReportedPost, FCReportedPost>
  get copyWith => _FCReportedPostCopyWithImpl<FCReportedPost, FCReportedPost>(
    this as FCReportedPost,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCReportedPostMapper.ensureInitialized().stringifyValue(
      this as FCReportedPost,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCReportedPostMapper.ensureInitialized().equalsValue(
      this as FCReportedPost,
      other,
    );
  }

  @override
  int get hashCode {
    return FCReportedPostMapper.ensureInitialized().hashValue(
      this as FCReportedPost,
    );
  }
}

extension FCReportedPostValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCReportedPost, $Out> {
  FCReportedPostCopyWith<$R, FCReportedPost, $Out> get $asFCReportedPost =>
      $base.as((v, t, t2) => _FCReportedPostCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCReportedPostCopyWith<$R, $In extends FCReportedPost, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? postId,
    String? postTitle,
    String? topicId,
    String? topicTitle,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    DateTime? postTime,
    String? postContent,
    String? reportReason,
    String? reporterId,
    String? reporterName,
    DateTime? reportTime,
  });
  FCReportedPostCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCReportedPostCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCReportedPost, $Out>
    implements FCReportedPostCopyWith<$R, FCReportedPost, $Out> {
  _FCReportedPostCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCReportedPost> $mapper =
      FCReportedPostMapper.ensureInitialized();
  @override
  $R call({
    String? postId,
    Object? postTitle = $none,
    String? topicId,
    String? topicTitle,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    DateTime? postTime,
    Object? postContent = $none,
    Object? reportReason = $none,
    Object? reporterId = $none,
    Object? reporterName = $none,
    Object? reportTime = $none,
  }) => $apply(
    FieldCopyWithData({
      if (postId != null) #postId: postId,
      if (postTitle != $none) #postTitle: postTitle,
      if (topicId != null) #topicId: topicId,
      if (topicTitle != null) #topicTitle: topicTitle,
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (postTime != null) #postTime: postTime,
      if (postContent != $none) #postContent: postContent,
      if (reportReason != $none) #reportReason: reportReason,
      if (reporterId != $none) #reporterId: reporterId,
      if (reporterName != $none) #reporterName: reporterName,
      if (reportTime != $none) #reportTime: reportTime,
    }),
  );
  @override
  FCReportedPost $make(CopyWithData data) => FCReportedPost(
    postId: data.get(#postId, or: $value.postId),
    postTitle: data.get(#postTitle, or: $value.postTitle),
    topicId: data.get(#topicId, or: $value.topicId),
    topicTitle: data.get(#topicTitle, or: $value.topicTitle),
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    postTime: data.get(#postTime, or: $value.postTime),
    postContent: data.get(#postContent, or: $value.postContent),
    reportReason: data.get(#reportReason, or: $value.reportReason),
    reporterId: data.get(#reporterId, or: $value.reporterId),
    reporterName: data.get(#reporterName, or: $value.reporterName),
    reportTime: data.get(#reportTime, or: $value.reportTime),
  );

  @override
  FCReportedPostCopyWith<$R2, FCReportedPost, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCReportedPostCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCApproveTopicResultMapper extends ClassMapperBase<FCApproveTopicResult> {
  FCApproveTopicResultMapper._();

  static FCApproveTopicResultMapper? _instance;
  static FCApproveTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCApproveTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCApproveTopicResult';

  static bool _$result(FCApproveTopicResult v) => v.result;
  static const Field<FCApproveTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCApproveTopicResult v) => v.resultText;
  static const Field<FCApproveTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCApproveTopicResult v) => v.isLoginMod;
  static const Field<FCApproveTopicResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCApproveTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCApproveTopicResult _instantiate(DecodingData data) {
    return FCApproveTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCApproveTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCApproveTopicResult>(map);
  }

  static FCApproveTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCApproveTopicResult>(json);
  }
}

mixin FCApproveTopicResultMappable {
  String toJson() {
    return FCApproveTopicResultMapper.ensureInitialized()
        .encodeJson<FCApproveTopicResult>(this as FCApproveTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCApproveTopicResultMapper.ensureInitialized()
        .encodeMap<FCApproveTopicResult>(this as FCApproveTopicResult);
  }

  FCApproveTopicResultCopyWith<
    FCApproveTopicResult,
    FCApproveTopicResult,
    FCApproveTopicResult
  >
  get copyWith =>
      _FCApproveTopicResultCopyWithImpl<
        FCApproveTopicResult,
        FCApproveTopicResult
      >(this as FCApproveTopicResult, $identity, $identity);
  @override
  String toString() {
    return FCApproveTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCApproveTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCApproveTopicResultMapper.ensureInitialized().equalsValue(
      this as FCApproveTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCApproveTopicResultMapper.ensureInitialized().hashValue(
      this as FCApproveTopicResult,
    );
  }
}

extension FCApproveTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCApproveTopicResult, $Out> {
  FCApproveTopicResultCopyWith<$R, FCApproveTopicResult, $Out>
  get $asFCApproveTopicResult => $base.as(
    (v, t, t2) => _FCApproveTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCApproveTopicResultCopyWith<
  $R,
  $In extends FCApproveTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCApproveTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCApproveTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCApproveTopicResult, $Out>
    implements FCApproveTopicResultCopyWith<$R, FCApproveTopicResult, $Out> {
  _FCApproveTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCApproveTopicResult> $mapper =
      FCApproveTopicResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCApproveTopicResult $make(CopyWithData data) => FCApproveTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCApproveTopicResultCopyWith<$R2, FCApproveTopicResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCApproveTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCApprovePostResultMapper extends ClassMapperBase<FCApprovePostResult> {
  FCApprovePostResultMapper._();

  static FCApprovePostResultMapper? _instance;
  static FCApprovePostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCApprovePostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCApprovePostResult';

  static bool _$result(FCApprovePostResult v) => v.result;
  static const Field<FCApprovePostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCApprovePostResult v) => v.resultText;
  static const Field<FCApprovePostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCApprovePostResult v) => v.isLoginMod;
  static const Field<FCApprovePostResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCApprovePostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCApprovePostResult _instantiate(DecodingData data) {
    return FCApprovePostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCApprovePostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCApprovePostResult>(map);
  }

  static FCApprovePostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCApprovePostResult>(json);
  }
}

mixin FCApprovePostResultMappable {
  String toJson() {
    return FCApprovePostResultMapper.ensureInitialized()
        .encodeJson<FCApprovePostResult>(this as FCApprovePostResult);
  }

  Map<String, dynamic> toMap() {
    return FCApprovePostResultMapper.ensureInitialized()
        .encodeMap<FCApprovePostResult>(this as FCApprovePostResult);
  }

  FCApprovePostResultCopyWith<
    FCApprovePostResult,
    FCApprovePostResult,
    FCApprovePostResult
  >
  get copyWith =>
      _FCApprovePostResultCopyWithImpl<
        FCApprovePostResult,
        FCApprovePostResult
      >(this as FCApprovePostResult, $identity, $identity);
  @override
  String toString() {
    return FCApprovePostResultMapper.ensureInitialized().stringifyValue(
      this as FCApprovePostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCApprovePostResultMapper.ensureInitialized().equalsValue(
      this as FCApprovePostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCApprovePostResultMapper.ensureInitialized().hashValue(
      this as FCApprovePostResult,
    );
  }
}

extension FCApprovePostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCApprovePostResult, $Out> {
  FCApprovePostResultCopyWith<$R, FCApprovePostResult, $Out>
  get $asFCApprovePostResult => $base.as(
    (v, t, t2) => _FCApprovePostResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCApprovePostResultCopyWith<
  $R,
  $In extends FCApprovePostResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCApprovePostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCApprovePostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCApprovePostResult, $Out>
    implements FCApprovePostResultCopyWith<$R, FCApprovePostResult, $Out> {
  _FCApprovePostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCApprovePostResult> $mapper =
      FCApprovePostResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCApprovePostResult $make(CopyWithData data) => FCApprovePostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCApprovePostResultCopyWith<$R2, FCApprovePostResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCApprovePostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCBanUserResultMapper extends ClassMapperBase<FCBanUserResult> {
  FCBanUserResultMapper._();

  static FCBanUserResultMapper? _instance;
  static FCBanUserResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCBanUserResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCBanUserResult';

  static bool _$result(FCBanUserResult v) => v.result;
  static const Field<FCBanUserResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCBanUserResult v) => v.resultText;
  static const Field<FCBanUserResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCBanUserResult v) => v.isLoginMod;
  static const Field<FCBanUserResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCBanUserResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCBanUserResult _instantiate(DecodingData data) {
    return FCBanUserResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCBanUserResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCBanUserResult>(map);
  }

  static FCBanUserResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCBanUserResult>(json);
  }
}

mixin FCBanUserResultMappable {
  String toJson() {
    return FCBanUserResultMapper.ensureInitialized()
        .encodeJson<FCBanUserResult>(this as FCBanUserResult);
  }

  Map<String, dynamic> toMap() {
    return FCBanUserResultMapper.ensureInitialized().encodeMap<FCBanUserResult>(
      this as FCBanUserResult,
    );
  }

  FCBanUserResultCopyWith<FCBanUserResult, FCBanUserResult, FCBanUserResult>
  get copyWith =>
      _FCBanUserResultCopyWithImpl<FCBanUserResult, FCBanUserResult>(
        this as FCBanUserResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCBanUserResultMapper.ensureInitialized().stringifyValue(
      this as FCBanUserResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCBanUserResultMapper.ensureInitialized().equalsValue(
      this as FCBanUserResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCBanUserResultMapper.ensureInitialized().hashValue(
      this as FCBanUserResult,
    );
  }
}

extension FCBanUserResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCBanUserResult, $Out> {
  FCBanUserResultCopyWith<$R, FCBanUserResult, $Out> get $asFCBanUserResult =>
      $base.as((v, t, t2) => _FCBanUserResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCBanUserResultCopyWith<$R, $In extends FCBanUserResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCBanUserResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCBanUserResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCBanUserResult, $Out>
    implements FCBanUserResultCopyWith<$R, FCBanUserResult, $Out> {
  _FCBanUserResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCBanUserResult> $mapper =
      FCBanUserResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCBanUserResult $make(CopyWithData data) => FCBanUserResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCBanUserResultCopyWith<$R2, FCBanUserResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCBanUserResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUnbanUserResultMapper extends ClassMapperBase<FCUnbanUserResult> {
  FCUnbanUserResultMapper._();

  static FCUnbanUserResultMapper? _instance;
  static FCUnbanUserResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUnbanUserResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUnbanUserResult';

  static bool _$result(FCUnbanUserResult v) => v.result;
  static const Field<FCUnbanUserResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUnbanUserResult v) => v.resultText;
  static const Field<FCUnbanUserResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCUnbanUserResult v) => v.isLoginMod;
  static const Field<FCUnbanUserResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCUnbanUserResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCUnbanUserResult _instantiate(DecodingData data) {
    return FCUnbanUserResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUnbanUserResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUnbanUserResult>(map);
  }

  static FCUnbanUserResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUnbanUserResult>(json);
  }
}

mixin FCUnbanUserResultMappable {
  String toJson() {
    return FCUnbanUserResultMapper.ensureInitialized()
        .encodeJson<FCUnbanUserResult>(this as FCUnbanUserResult);
  }

  Map<String, dynamic> toMap() {
    return FCUnbanUserResultMapper.ensureInitialized()
        .encodeMap<FCUnbanUserResult>(this as FCUnbanUserResult);
  }

  FCUnbanUserResultCopyWith<
    FCUnbanUserResult,
    FCUnbanUserResult,
    FCUnbanUserResult
  >
  get copyWith =>
      _FCUnbanUserResultCopyWithImpl<FCUnbanUserResult, FCUnbanUserResult>(
        this as FCUnbanUserResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCUnbanUserResultMapper.ensureInitialized().stringifyValue(
      this as FCUnbanUserResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUnbanUserResultMapper.ensureInitialized().equalsValue(
      this as FCUnbanUserResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUnbanUserResultMapper.ensureInitialized().hashValue(
      this as FCUnbanUserResult,
    );
  }
}

extension FCUnbanUserResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUnbanUserResult, $Out> {
  FCUnbanUserResultCopyWith<$R, FCUnbanUserResult, $Out>
  get $asFCUnbanUserResult => $base.as(
    (v, t, t2) => _FCUnbanUserResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUnbanUserResultCopyWith<
  $R,
  $In extends FCUnbanUserResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCUnbanUserResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUnbanUserResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUnbanUserResult, $Out>
    implements FCUnbanUserResultCopyWith<$R, FCUnbanUserResult, $Out> {
  _FCUnbanUserResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUnbanUserResult> $mapper =
      FCUnbanUserResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCUnbanUserResult $make(CopyWithData data) => FCUnbanUserResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCUnbanUserResultCopyWith<$R2, FCUnbanUserResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCUnbanUserResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCMarkAsSpamResultMapper extends ClassMapperBase<FCMarkAsSpamResult> {
  FCMarkAsSpamResultMapper._();

  static FCMarkAsSpamResultMapper? _instance;
  static FCMarkAsSpamResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCMarkAsSpamResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCMarkAsSpamResult';

  static bool _$result(FCMarkAsSpamResult v) => v.result;
  static const Field<FCMarkAsSpamResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCMarkAsSpamResult v) => v.resultText;
  static const Field<FCMarkAsSpamResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isLoginMod(FCMarkAsSpamResult v) => v.isLoginMod;
  static const Field<FCMarkAsSpamResult, bool> _f$isLoginMod = Field(
    'isLoginMod',
    _$isLoginMod,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCMarkAsSpamResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isLoginMod: _f$isLoginMod,
  };

  static FCMarkAsSpamResult _instantiate(DecodingData data) {
    return FCMarkAsSpamResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isLoginMod: data.dec(_f$isLoginMod),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCMarkAsSpamResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCMarkAsSpamResult>(map);
  }

  static FCMarkAsSpamResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCMarkAsSpamResult>(json);
  }
}

mixin FCMarkAsSpamResultMappable {
  String toJson() {
    return FCMarkAsSpamResultMapper.ensureInitialized()
        .encodeJson<FCMarkAsSpamResult>(this as FCMarkAsSpamResult);
  }

  Map<String, dynamic> toMap() {
    return FCMarkAsSpamResultMapper.ensureInitialized()
        .encodeMap<FCMarkAsSpamResult>(this as FCMarkAsSpamResult);
  }

  FCMarkAsSpamResultCopyWith<
    FCMarkAsSpamResult,
    FCMarkAsSpamResult,
    FCMarkAsSpamResult
  >
  get copyWith =>
      _FCMarkAsSpamResultCopyWithImpl<FCMarkAsSpamResult, FCMarkAsSpamResult>(
        this as FCMarkAsSpamResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCMarkAsSpamResultMapper.ensureInitialized().stringifyValue(
      this as FCMarkAsSpamResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCMarkAsSpamResultMapper.ensureInitialized().equalsValue(
      this as FCMarkAsSpamResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCMarkAsSpamResultMapper.ensureInitialized().hashValue(
      this as FCMarkAsSpamResult,
    );
  }
}

extension FCMarkAsSpamResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCMarkAsSpamResult, $Out> {
  FCMarkAsSpamResultCopyWith<$R, FCMarkAsSpamResult, $Out>
  get $asFCMarkAsSpamResult => $base.as(
    (v, t, t2) => _FCMarkAsSpamResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCMarkAsSpamResultCopyWith<
  $R,
  $In extends FCMarkAsSpamResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isLoginMod});
  FCMarkAsSpamResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCMarkAsSpamResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCMarkAsSpamResult, $Out>
    implements FCMarkAsSpamResultCopyWith<$R, FCMarkAsSpamResult, $Out> {
  _FCMarkAsSpamResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCMarkAsSpamResult> $mapper =
      FCMarkAsSpamResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isLoginMod}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isLoginMod != null) #isLoginMod: isLoginMod,
        }),
      );
  @override
  FCMarkAsSpamResult $make(CopyWithData data) => FCMarkAsSpamResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isLoginMod: data.get(#isLoginMod, or: $value.isLoginMod),
  );

  @override
  FCMarkAsSpamResultCopyWith<$R2, FCMarkAsSpamResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCMarkAsSpamResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCSpamCleanUserResultMapper
    extends ClassMapperBase<FCSpamCleanUserResult> {
  FCSpamCleanUserResultMapper._();

  static FCSpamCleanUserResultMapper? _instance;
  static FCSpamCleanUserResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSpamCleanUserResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSpamCleanUserResult';

  static bool _$result(FCSpamCleanUserResult v) => v.result;
  static const Field<FCSpamCleanUserResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSpamCleanUserResult v) => v.resultText;
  static const Field<FCSpamCleanUserResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$userId(FCSpamCleanUserResult v) => v.userId;
  static const Field<FCSpamCleanUserResult, String> _f$userId = Field(
    'userId',
    _$userId,
    opt: true,
  );
  static String? _$username(FCSpamCleanUserResult v) => v.username;
  static const Field<FCSpamCleanUserResult, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
  );
  static Map<String, bool>? _$actions(FCSpamCleanUserResult v) => v.actions;
  static const Field<FCSpamCleanUserResult, Map<String, bool>> _f$actions =
      Field('actions', _$actions, opt: true);

  @override
  final MappableFields<FCSpamCleanUserResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #userId: _f$userId,
    #username: _f$username,
    #actions: _f$actions,
  };

  static FCSpamCleanUserResult _instantiate(DecodingData data) {
    return FCSpamCleanUserResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      userId: data.dec(_f$userId),
      username: data.dec(_f$username),
      actions: data.dec(_f$actions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSpamCleanUserResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSpamCleanUserResult>(map);
  }

  static FCSpamCleanUserResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCSpamCleanUserResult>(json);
  }
}

mixin FCSpamCleanUserResultMappable {
  String toJson() {
    return FCSpamCleanUserResultMapper.ensureInitialized()
        .encodeJson<FCSpamCleanUserResult>(this as FCSpamCleanUserResult);
  }

  Map<String, dynamic> toMap() {
    return FCSpamCleanUserResultMapper.ensureInitialized()
        .encodeMap<FCSpamCleanUserResult>(this as FCSpamCleanUserResult);
  }

  FCSpamCleanUserResultCopyWith<
    FCSpamCleanUserResult,
    FCSpamCleanUserResult,
    FCSpamCleanUserResult
  >
  get copyWith =>
      _FCSpamCleanUserResultCopyWithImpl<
        FCSpamCleanUserResult,
        FCSpamCleanUserResult
      >(this as FCSpamCleanUserResult, $identity, $identity);
  @override
  String toString() {
    return FCSpamCleanUserResultMapper.ensureInitialized().stringifyValue(
      this as FCSpamCleanUserResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSpamCleanUserResultMapper.ensureInitialized().equalsValue(
      this as FCSpamCleanUserResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSpamCleanUserResultMapper.ensureInitialized().hashValue(
      this as FCSpamCleanUserResult,
    );
  }
}

extension FCSpamCleanUserResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSpamCleanUserResult, $Out> {
  FCSpamCleanUserResultCopyWith<$R, FCSpamCleanUserResult, $Out>
  get $asFCSpamCleanUserResult => $base.as(
    (v, t, t2) => _FCSpamCleanUserResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSpamCleanUserResultCopyWith<
  $R,
  $In extends FCSpamCleanUserResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, bool, ObjectCopyWith<$R, bool, bool>>? get actions;
  @override
  $R call({
    bool? result,
    String? resultText,
    String? userId,
    String? username,
    Map<String, bool>? actions,
  });
  FCSpamCleanUserResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSpamCleanUserResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSpamCleanUserResult, $Out>
    implements FCSpamCleanUserResultCopyWith<$R, FCSpamCleanUserResult, $Out> {
  _FCSpamCleanUserResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSpamCleanUserResult> $mapper =
      FCSpamCleanUserResultMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, bool, ObjectCopyWith<$R, bool, bool>>? get actions =>
      $value.actions != null
      ? MapCopyWith(
          $value.actions!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(actions: v),
        )
      : null;
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? userId = $none,
    Object? username = $none,
    Object? actions = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (userId != $none) #userId: userId,
      if (username != $none) #username: username,
      if (actions != $none) #actions: actions,
    }),
  );
  @override
  FCSpamCleanUserResult $make(CopyWithData data) => FCSpamCleanUserResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    userId: data.get(#userId, or: $value.userId),
    username: data.get(#username, or: $value.username),
    actions: data.get(#actions, or: $value.actions),
  );

  @override
  FCSpamCleanUserResultCopyWith<$R2, FCSpamCleanUserResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCSpamCleanUserResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

