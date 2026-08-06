// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_draft_result.dart';

class FCSaveDraftResultMapper extends ClassMapperBase<FCSaveDraftResult> {
  FCSaveDraftResultMapper._();

  static FCSaveDraftResultMapper? _instance;
  static FCSaveDraftResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSaveDraftResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSaveDraftResult';

  static bool _$result(FCSaveDraftResult v) => v.result;
  static const Field<FCSaveDraftResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSaveDraftResult v) => v.resultText;
  static const Field<FCSaveDraftResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int? _$sequence(FCSaveDraftResult v) => v.sequence;
  static const Field<FCSaveDraftResult, int> _f$sequence = Field(
    'sequence',
    _$sequence,
    opt: true,
  );

  @override
  final MappableFields<FCSaveDraftResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #sequence: _f$sequence,
  };

  static FCSaveDraftResult _instantiate(DecodingData data) {
    return FCSaveDraftResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      sequence: data.dec(_f$sequence),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSaveDraftResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSaveDraftResult>(map);
  }

  static FCSaveDraftResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCSaveDraftResult>(json);
  }
}

mixin FCSaveDraftResultMappable {
  String toJson() {
    return FCSaveDraftResultMapper.ensureInitialized()
        .encodeJson<FCSaveDraftResult>(this as FCSaveDraftResult);
  }

  Map<String, dynamic> toMap() {
    return FCSaveDraftResultMapper.ensureInitialized()
        .encodeMap<FCSaveDraftResult>(this as FCSaveDraftResult);
  }

  FCSaveDraftResultCopyWith<
    FCSaveDraftResult,
    FCSaveDraftResult,
    FCSaveDraftResult
  >
  get copyWith =>
      _FCSaveDraftResultCopyWithImpl<FCSaveDraftResult, FCSaveDraftResult>(
        this as FCSaveDraftResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCSaveDraftResultMapper.ensureInitialized().stringifyValue(
      this as FCSaveDraftResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSaveDraftResultMapper.ensureInitialized().equalsValue(
      this as FCSaveDraftResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSaveDraftResultMapper.ensureInitialized().hashValue(
      this as FCSaveDraftResult,
    );
  }
}

extension FCSaveDraftResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSaveDraftResult, $Out> {
  FCSaveDraftResultCopyWith<$R, FCSaveDraftResult, $Out>
  get $asFCSaveDraftResult => $base.as(
    (v, t, t2) => _FCSaveDraftResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSaveDraftResultCopyWith<
  $R,
  $In extends FCSaveDraftResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, int? sequence});
  FCSaveDraftResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSaveDraftResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSaveDraftResult, $Out>
    implements FCSaveDraftResultCopyWith<$R, FCSaveDraftResult, $Out> {
  _FCSaveDraftResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSaveDraftResult> $mapper =
      FCSaveDraftResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? sequence = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (sequence != $none) #sequence: sequence,
    }),
  );
  @override
  FCSaveDraftResult $make(CopyWithData data) => FCSaveDraftResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    sequence: data.get(#sequence, or: $value.sequence),
  );

  @override
  FCSaveDraftResultCopyWith<$R2, FCSaveDraftResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCSaveDraftResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCLoadDraftResultMapper extends ClassMapperBase<FCLoadDraftResult> {
  FCLoadDraftResultMapper._();

  static FCLoadDraftResultMapper? _instance;
  static FCLoadDraftResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCLoadDraftResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCDraftMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCLoadDraftResult';

  static bool _$result(FCLoadDraftResult v) => v.result;
  static const Field<FCLoadDraftResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCLoadDraftResult v) => v.resultText;
  static const Field<FCLoadDraftResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static FCDraft? _$draft(FCLoadDraftResult v) => v.draft;
  static const Field<FCLoadDraftResult, FCDraft> _f$draft = Field(
    'draft',
    _$draft,
    opt: true,
  );

  @override
  final MappableFields<FCLoadDraftResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #draft: _f$draft,
  };

  static FCLoadDraftResult _instantiate(DecodingData data) {
    return FCLoadDraftResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      draft: data.dec(_f$draft),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCLoadDraftResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCLoadDraftResult>(map);
  }

  static FCLoadDraftResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCLoadDraftResult>(json);
  }
}

mixin FCLoadDraftResultMappable {
  String toJson() {
    return FCLoadDraftResultMapper.ensureInitialized()
        .encodeJson<FCLoadDraftResult>(this as FCLoadDraftResult);
  }

  Map<String, dynamic> toMap() {
    return FCLoadDraftResultMapper.ensureInitialized()
        .encodeMap<FCLoadDraftResult>(this as FCLoadDraftResult);
  }

  FCLoadDraftResultCopyWith<
    FCLoadDraftResult,
    FCLoadDraftResult,
    FCLoadDraftResult
  >
  get copyWith =>
      _FCLoadDraftResultCopyWithImpl<FCLoadDraftResult, FCLoadDraftResult>(
        this as FCLoadDraftResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCLoadDraftResultMapper.ensureInitialized().stringifyValue(
      this as FCLoadDraftResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCLoadDraftResultMapper.ensureInitialized().equalsValue(
      this as FCLoadDraftResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCLoadDraftResultMapper.ensureInitialized().hashValue(
      this as FCLoadDraftResult,
    );
  }
}

extension FCLoadDraftResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCLoadDraftResult, $Out> {
  FCLoadDraftResultCopyWith<$R, FCLoadDraftResult, $Out>
  get $asFCLoadDraftResult => $base.as(
    (v, t, t2) => _FCLoadDraftResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCLoadDraftResultCopyWith<
  $R,
  $In extends FCLoadDraftResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  FCDraftCopyWith<$R, FCDraft, FCDraft>? get draft;
  @override
  $R call({bool? result, String? resultText, FCDraft? draft});
  FCLoadDraftResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCLoadDraftResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCLoadDraftResult, $Out>
    implements FCLoadDraftResultCopyWith<$R, FCLoadDraftResult, $Out> {
  _FCLoadDraftResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCLoadDraftResult> $mapper =
      FCLoadDraftResultMapper.ensureInitialized();
  @override
  FCDraftCopyWith<$R, FCDraft, FCDraft>? get draft =>
      $value.draft?.copyWith.$chain((v) => call(draft: v));
  @override
  $R call({bool? result, Object? resultText = $none, Object? draft = $none}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (draft != $none) #draft: draft,
        }),
      );
  @override
  FCLoadDraftResult $make(CopyWithData data) => FCLoadDraftResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    draft: data.get(#draft, or: $value.draft),
  );

  @override
  FCLoadDraftResultCopyWith<$R2, FCLoadDraftResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCLoadDraftResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCDeleteDraftResultMapper extends ClassMapperBase<FCDeleteDraftResult> {
  FCDeleteDraftResultMapper._();

  static FCDeleteDraftResultMapper? _instance;
  static FCDeleteDraftResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCDeleteDraftResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCDeleteDraftResult';

  static bool _$result(FCDeleteDraftResult v) => v.result;
  static const Field<FCDeleteDraftResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCDeleteDraftResult v) => v.resultText;
  static const Field<FCDeleteDraftResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCDeleteDraftResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCDeleteDraftResult _instantiate(DecodingData data) {
    return FCDeleteDraftResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCDeleteDraftResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCDeleteDraftResult>(map);
  }

  static FCDeleteDraftResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCDeleteDraftResult>(json);
  }
}

mixin FCDeleteDraftResultMappable {
  String toJson() {
    return FCDeleteDraftResultMapper.ensureInitialized()
        .encodeJson<FCDeleteDraftResult>(this as FCDeleteDraftResult);
  }

  Map<String, dynamic> toMap() {
    return FCDeleteDraftResultMapper.ensureInitialized()
        .encodeMap<FCDeleteDraftResult>(this as FCDeleteDraftResult);
  }

  FCDeleteDraftResultCopyWith<
    FCDeleteDraftResult,
    FCDeleteDraftResult,
    FCDeleteDraftResult
  >
  get copyWith =>
      _FCDeleteDraftResultCopyWithImpl<
        FCDeleteDraftResult,
        FCDeleteDraftResult
      >(this as FCDeleteDraftResult, $identity, $identity);
  @override
  String toString() {
    return FCDeleteDraftResultMapper.ensureInitialized().stringifyValue(
      this as FCDeleteDraftResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCDeleteDraftResultMapper.ensureInitialized().equalsValue(
      this as FCDeleteDraftResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCDeleteDraftResultMapper.ensureInitialized().hashValue(
      this as FCDeleteDraftResult,
    );
  }
}

extension FCDeleteDraftResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCDeleteDraftResult, $Out> {
  FCDeleteDraftResultCopyWith<$R, FCDeleteDraftResult, $Out>
  get $asFCDeleteDraftResult => $base.as(
    (v, t, t2) => _FCDeleteDraftResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCDeleteDraftResultCopyWith<
  $R,
  $In extends FCDeleteDraftResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCDeleteDraftResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCDeleteDraftResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCDeleteDraftResult, $Out>
    implements FCDeleteDraftResultCopyWith<$R, FCDeleteDraftResult, $Out> {
  _FCDeleteDraftResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCDeleteDraftResult> $mapper =
      FCDeleteDraftResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCDeleteDraftResult $make(CopyWithData data) => FCDeleteDraftResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCDeleteDraftResultCopyWith<$R2, FCDeleteDraftResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCDeleteDraftResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCDraftListResultMapper extends ClassMapperBase<FCDraftListResult> {
  FCDraftListResultMapper._();

  static FCDraftListResultMapper? _instance;
  static FCDraftListResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCDraftListResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCDraftMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCDraftListResult';

  static bool _$result(FCDraftListResult v) => v.result;
  static const Field<FCDraftListResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCDraftListResult v) => v.resultText;
  static const Field<FCDraftListResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$total(FCDraftListResult v) => v.total;
  static const Field<FCDraftListResult, int> _f$total = Field('total', _$total);
  static List<FCDraft> _$items(FCDraftListResult v) => v.items;
  static const Field<FCDraftListResult, List<FCDraft>> _f$items = Field(
    'items',
    _$items,
  );

  @override
  final MappableFields<FCDraftListResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #total: _f$total,
    #items: _f$items,
  };

  static FCDraftListResult _instantiate(DecodingData data) {
    return FCDraftListResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      total: data.dec(_f$total),
      items: data.dec(_f$items),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCDraftListResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCDraftListResult>(map);
  }

  static FCDraftListResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCDraftListResult>(json);
  }
}

mixin FCDraftListResultMappable {
  String toJson() {
    return FCDraftListResultMapper.ensureInitialized()
        .encodeJson<FCDraftListResult>(this as FCDraftListResult);
  }

  Map<String, dynamic> toMap() {
    return FCDraftListResultMapper.ensureInitialized()
        .encodeMap<FCDraftListResult>(this as FCDraftListResult);
  }

  FCDraftListResultCopyWith<
    FCDraftListResult,
    FCDraftListResult,
    FCDraftListResult
  >
  get copyWith =>
      _FCDraftListResultCopyWithImpl<FCDraftListResult, FCDraftListResult>(
        this as FCDraftListResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCDraftListResultMapper.ensureInitialized().stringifyValue(
      this as FCDraftListResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCDraftListResultMapper.ensureInitialized().equalsValue(
      this as FCDraftListResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCDraftListResultMapper.ensureInitialized().hashValue(
      this as FCDraftListResult,
    );
  }
}

extension FCDraftListResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCDraftListResult, $Out> {
  FCDraftListResultCopyWith<$R, FCDraftListResult, $Out>
  get $asFCDraftListResult => $base.as(
    (v, t, t2) => _FCDraftListResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCDraftListResultCopyWith<
  $R,
  $In extends FCDraftListResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCDraft, FCDraftCopyWith<$R, FCDraft, FCDraft>> get items;
  @override
  $R call({bool? result, String? resultText, int? total, List<FCDraft>? items});
  FCDraftListResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCDraftListResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCDraftListResult, $Out>
    implements FCDraftListResultCopyWith<$R, FCDraftListResult, $Out> {
  _FCDraftListResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCDraftListResult> $mapper =
      FCDraftListResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCDraft, FCDraftCopyWith<$R, FCDraft, FCDraft>> get items =>
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
    List<FCDraft>? items,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (total != null) #total: total,
      if (items != null) #items: items,
    }),
  );
  @override
  FCDraftListResult $make(CopyWithData data) => FCDraftListResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    total: data.get(#total, or: $value.total),
    items: data.get(#items, or: $value.items),
  );

  @override
  FCDraftListResultCopyWith<$R2, FCDraftListResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCDraftListResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

