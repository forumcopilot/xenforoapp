// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_tag_result.dart';

class FCTagListResultMapper extends ClassMapperBase<FCTagListResult> {
  FCTagListResultMapper._();

  static FCTagListResultMapper? _instance;
  static FCTagListResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCTagListResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCTagMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCTagListResult';

  static bool _$result(FCTagListResult v) => v.result;
  static const Field<FCTagListResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCTagListResult v) => v.resultText;
  static const Field<FCTagListResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$total(FCTagListResult v) => v.total;
  static const Field<FCTagListResult, int> _f$total = Field('total', _$total);
  static List<FCTag> _$items(FCTagListResult v) => v.items;
  static const Field<FCTagListResult, List<FCTag>> _f$items = Field(
    'items',
    _$items,
  );

  @override
  final MappableFields<FCTagListResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #total: _f$total,
    #items: _f$items,
  };

  static FCTagListResult _instantiate(DecodingData data) {
    return FCTagListResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      total: data.dec(_f$total),
      items: data.dec(_f$items),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCTagListResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCTagListResult>(map);
  }

  static FCTagListResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCTagListResult>(json);
  }
}

mixin FCTagListResultMappable {
  String toJson() {
    return FCTagListResultMapper.ensureInitialized()
        .encodeJson<FCTagListResult>(this as FCTagListResult);
  }

  Map<String, dynamic> toMap() {
    return FCTagListResultMapper.ensureInitialized().encodeMap<FCTagListResult>(
      this as FCTagListResult,
    );
  }

  FCTagListResultCopyWith<FCTagListResult, FCTagListResult, FCTagListResult>
  get copyWith =>
      _FCTagListResultCopyWithImpl<FCTagListResult, FCTagListResult>(
        this as FCTagListResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCTagListResultMapper.ensureInitialized().stringifyValue(
      this as FCTagListResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCTagListResultMapper.ensureInitialized().equalsValue(
      this as FCTagListResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCTagListResultMapper.ensureInitialized().hashValue(
      this as FCTagListResult,
    );
  }
}

extension FCTagListResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCTagListResult, $Out> {
  FCTagListResultCopyWith<$R, FCTagListResult, $Out> get $asFCTagListResult =>
      $base.as((v, t, t2) => _FCTagListResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCTagListResultCopyWith<$R, $In extends FCTagListResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCTag, FCTagCopyWith<$R, FCTag, FCTag>> get items;
  @override
  $R call({bool? result, String? resultText, int? total, List<FCTag>? items});
  FCTagListResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCTagListResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCTagListResult, $Out>
    implements FCTagListResultCopyWith<$R, FCTagListResult, $Out> {
  _FCTagListResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCTagListResult> $mapper =
      FCTagListResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCTag, FCTagCopyWith<$R, FCTag, FCTag>> get items =>
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
    List<FCTag>? items,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (total != null) #total: total,
      if (items != null) #items: items,
    }),
  );
  @override
  FCTagListResult $make(CopyWithData data) => FCTagListResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    total: data.get(#total, or: $value.total),
    items: data.get(#items, or: $value.items),
  );

  @override
  FCTagListResultCopyWith<$R2, FCTagListResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCTagListResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCTagSearchResultMapper extends ClassMapperBase<FCTagSearchResult> {
  FCTagSearchResultMapper._();

  static FCTagSearchResultMapper? _instance;
  static FCTagSearchResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCTagSearchResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCTagSearchResult';

  static bool _$result(FCTagSearchResult v) => v.result;
  static const Field<FCTagSearchResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCTagSearchResult v) => v.resultText;
  static const Field<FCTagSearchResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static List<String> _$names(FCTagSearchResult v) => v.names;
  static const Field<FCTagSearchResult, List<String>> _f$names = Field(
    'names',
    _$names,
  );

  @override
  final MappableFields<FCTagSearchResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #names: _f$names,
  };

  static FCTagSearchResult _instantiate(DecodingData data) {
    return FCTagSearchResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      names: data.dec(_f$names),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCTagSearchResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCTagSearchResult>(map);
  }

  static FCTagSearchResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCTagSearchResult>(json);
  }
}

mixin FCTagSearchResultMappable {
  String toJson() {
    return FCTagSearchResultMapper.ensureInitialized()
        .encodeJson<FCTagSearchResult>(this as FCTagSearchResult);
  }

  Map<String, dynamic> toMap() {
    return FCTagSearchResultMapper.ensureInitialized()
        .encodeMap<FCTagSearchResult>(this as FCTagSearchResult);
  }

  FCTagSearchResultCopyWith<
    FCTagSearchResult,
    FCTagSearchResult,
    FCTagSearchResult
  >
  get copyWith =>
      _FCTagSearchResultCopyWithImpl<FCTagSearchResult, FCTagSearchResult>(
        this as FCTagSearchResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCTagSearchResultMapper.ensureInitialized().stringifyValue(
      this as FCTagSearchResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCTagSearchResultMapper.ensureInitialized().equalsValue(
      this as FCTagSearchResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCTagSearchResultMapper.ensureInitialized().hashValue(
      this as FCTagSearchResult,
    );
  }
}

extension FCTagSearchResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCTagSearchResult, $Out> {
  FCTagSearchResultCopyWith<$R, FCTagSearchResult, $Out>
  get $asFCTagSearchResult => $base.as(
    (v, t, t2) => _FCTagSearchResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCTagSearchResultCopyWith<
  $R,
  $In extends FCTagSearchResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get names;
  @override
  $R call({bool? result, String? resultText, List<String>? names});
  FCTagSearchResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCTagSearchResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCTagSearchResult, $Out>
    implements FCTagSearchResultCopyWith<$R, FCTagSearchResult, $Out> {
  _FCTagSearchResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCTagSearchResult> $mapper =
      FCTagSearchResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get names =>
      ListCopyWith(
        $value.names,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(names: v),
      );
  @override
  $R call({bool? result, Object? resultText = $none, List<String>? names}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (names != null) #names: names,
        }),
      );
  @override
  FCTagSearchResult $make(CopyWithData data) => FCTagSearchResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    names: data.get(#names, or: $value.names),
  );

  @override
  FCTagSearchResultCopyWith<$R2, FCTagSearchResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCTagSearchResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

