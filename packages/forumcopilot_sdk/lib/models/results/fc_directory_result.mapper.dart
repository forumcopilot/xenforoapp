// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_directory_result.dart';

class FCDirectoryItemResultMapper
    extends ClassMapperBase<FCDirectoryItemResult> {
  FCDirectoryItemResultMapper._();

  static FCDirectoryItemResultMapper? _instance;
  static FCDirectoryItemResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCDirectoryItemResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCDirectoryItemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCDirectoryItemResult';

  static bool _$result(FCDirectoryItemResult v) => v.result;
  static const Field<FCDirectoryItemResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCDirectoryItemResult v) => v.resultText;
  static const Field<FCDirectoryItemResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$total(FCDirectoryItemResult v) => v.total;
  static const Field<FCDirectoryItemResult, int> _f$total = Field(
    'total',
    _$total,
  );
  static List<FCDirectoryItem> _$items(FCDirectoryItemResult v) => v.items;
  static const Field<FCDirectoryItemResult, List<FCDirectoryItem>> _f$items =
      Field('items', _$items);

  @override
  final MappableFields<FCDirectoryItemResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #total: _f$total,
    #items: _f$items,
  };

  static FCDirectoryItemResult _instantiate(DecodingData data) {
    return FCDirectoryItemResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      total: data.dec(_f$total),
      items: data.dec(_f$items),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCDirectoryItemResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCDirectoryItemResult>(map);
  }

  static FCDirectoryItemResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCDirectoryItemResult>(json);
  }
}

mixin FCDirectoryItemResultMappable {
  String toJson() {
    return FCDirectoryItemResultMapper.ensureInitialized()
        .encodeJson<FCDirectoryItemResult>(this as FCDirectoryItemResult);
  }

  Map<String, dynamic> toMap() {
    return FCDirectoryItemResultMapper.ensureInitialized()
        .encodeMap<FCDirectoryItemResult>(this as FCDirectoryItemResult);
  }

  FCDirectoryItemResultCopyWith<
    FCDirectoryItemResult,
    FCDirectoryItemResult,
    FCDirectoryItemResult
  >
  get copyWith =>
      _FCDirectoryItemResultCopyWithImpl<
        FCDirectoryItemResult,
        FCDirectoryItemResult
      >(this as FCDirectoryItemResult, $identity, $identity);
  @override
  String toString() {
    return FCDirectoryItemResultMapper.ensureInitialized().stringifyValue(
      this as FCDirectoryItemResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCDirectoryItemResultMapper.ensureInitialized().equalsValue(
      this as FCDirectoryItemResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCDirectoryItemResultMapper.ensureInitialized().hashValue(
      this as FCDirectoryItemResult,
    );
  }
}

extension FCDirectoryItemResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCDirectoryItemResult, $Out> {
  FCDirectoryItemResultCopyWith<$R, FCDirectoryItemResult, $Out>
  get $asFCDirectoryItemResult => $base.as(
    (v, t, t2) => _FCDirectoryItemResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCDirectoryItemResultCopyWith<
  $R,
  $In extends FCDirectoryItemResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCDirectoryItem,
    FCDirectoryItemCopyWith<$R, FCDirectoryItem, FCDirectoryItem>
  >
  get items;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? total,
    List<FCDirectoryItem>? items,
  });
  FCDirectoryItemResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCDirectoryItemResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCDirectoryItemResult, $Out>
    implements FCDirectoryItemResultCopyWith<$R, FCDirectoryItemResult, $Out> {
  _FCDirectoryItemResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCDirectoryItemResult> $mapper =
      FCDirectoryItemResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCDirectoryItem,
    FCDirectoryItemCopyWith<$R, FCDirectoryItem, FCDirectoryItem>
  >
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
    List<FCDirectoryItem>? items,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (total != null) #total: total,
      if (items != null) #items: items,
    }),
  );
  @override
  FCDirectoryItemResult $make(CopyWithData data) => FCDirectoryItemResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    total: data.get(#total, or: $value.total),
    items: data.get(#items, or: $value.items),
  );

  @override
  FCDirectoryItemResultCopyWith<$R2, FCDirectoryItemResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCDirectoryItemResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCBadgeResultMapper extends ClassMapperBase<FCBadgeResult> {
  FCBadgeResultMapper._();

  static FCBadgeResultMapper? _instance;
  static FCBadgeResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCBadgeResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCBadgeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCBadgeResult';

  static bool _$result(FCBadgeResult v) => v.result;
  static const Field<FCBadgeResult, bool> _f$result = Field('result', _$result);
  static String? _$resultText(FCBadgeResult v) => v.resultText;
  static const Field<FCBadgeResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static List<FCBadge> _$badges(FCBadgeResult v) => v.badges;
  static const Field<FCBadgeResult, List<FCBadge>> _f$badges = Field(
    'badges',
    _$badges,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCBadgeResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #badges: _f$badges,
  };

  static FCBadgeResult _instantiate(DecodingData data) {
    return FCBadgeResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      badges: data.dec(_f$badges),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCBadgeResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCBadgeResult>(map);
  }

  static FCBadgeResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCBadgeResult>(json);
  }
}

mixin FCBadgeResultMappable {
  String toJson() {
    return FCBadgeResultMapper.ensureInitialized().encodeJson<FCBadgeResult>(
      this as FCBadgeResult,
    );
  }

  Map<String, dynamic> toMap() {
    return FCBadgeResultMapper.ensureInitialized().encodeMap<FCBadgeResult>(
      this as FCBadgeResult,
    );
  }

  FCBadgeResultCopyWith<FCBadgeResult, FCBadgeResult, FCBadgeResult>
  get copyWith => _FCBadgeResultCopyWithImpl<FCBadgeResult, FCBadgeResult>(
    this as FCBadgeResult,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCBadgeResultMapper.ensureInitialized().stringifyValue(
      this as FCBadgeResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCBadgeResultMapper.ensureInitialized().equalsValue(
      this as FCBadgeResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCBadgeResultMapper.ensureInitialized().hashValue(
      this as FCBadgeResult,
    );
  }
}

extension FCBadgeResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCBadgeResult, $Out> {
  FCBadgeResultCopyWith<$R, FCBadgeResult, $Out> get $asFCBadgeResult =>
      $base.as((v, t, t2) => _FCBadgeResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCBadgeResultCopyWith<$R, $In extends FCBadgeResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCBadge, FCBadgeCopyWith<$R, FCBadge, FCBadge>> get badges;
  @override
  $R call({bool? result, String? resultText, List<FCBadge>? badges});
  FCBadgeResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCBadgeResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCBadgeResult, $Out>
    implements FCBadgeResultCopyWith<$R, FCBadgeResult, $Out> {
  _FCBadgeResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCBadgeResult> $mapper =
      FCBadgeResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCBadge, FCBadgeCopyWith<$R, FCBadge, FCBadge>> get badges =>
      ListCopyWith(
        $value.badges,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(badges: v),
      );
  @override
  $R call({bool? result, Object? resultText = $none, List<FCBadge>? badges}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (badges != null) #badges: badges,
        }),
      );
  @override
  FCBadgeResult $make(CopyWithData data) => FCBadgeResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    badges: data.get(#badges, or: $value.badges),
  );

  @override
  FCBadgeResultCopyWith<$R2, FCBadgeResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCBadgeResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

