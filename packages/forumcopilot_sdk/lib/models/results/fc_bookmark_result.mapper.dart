// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_bookmark_result.dart';

class FCAddBookmarkResultMapper extends ClassMapperBase<FCAddBookmarkResult> {
  FCAddBookmarkResultMapper._();

  static FCAddBookmarkResultMapper? _instance;
  static FCAddBookmarkResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCAddBookmarkResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCAddBookmarkResult';

  static bool _$result(FCAddBookmarkResult v) => v.result;
  static const Field<FCAddBookmarkResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCAddBookmarkResult v) => v.resultText;
  static const Field<FCAddBookmarkResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isBookmarked(FCAddBookmarkResult v) => v.isBookmarked;
  static const Field<FCAddBookmarkResult, bool> _f$isBookmarked = Field(
    'isBookmarked',
    _$isBookmarked,
    opt: true,
    def: false,
  );
  static int? _$bookmarkId(FCAddBookmarkResult v) => v.bookmarkId;
  static const Field<FCAddBookmarkResult, int> _f$bookmarkId = Field(
    'bookmarkId',
    _$bookmarkId,
    opt: true,
  );

  @override
  final MappableFields<FCAddBookmarkResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isBookmarked: _f$isBookmarked,
    #bookmarkId: _f$bookmarkId,
  };

  static FCAddBookmarkResult _instantiate(DecodingData data) {
    return FCAddBookmarkResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isBookmarked: data.dec(_f$isBookmarked),
      bookmarkId: data.dec(_f$bookmarkId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCAddBookmarkResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCAddBookmarkResult>(map);
  }

  static FCAddBookmarkResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCAddBookmarkResult>(json);
  }
}

mixin FCAddBookmarkResultMappable {
  String toJson() {
    return FCAddBookmarkResultMapper.ensureInitialized()
        .encodeJson<FCAddBookmarkResult>(this as FCAddBookmarkResult);
  }

  Map<String, dynamic> toMap() {
    return FCAddBookmarkResultMapper.ensureInitialized()
        .encodeMap<FCAddBookmarkResult>(this as FCAddBookmarkResult);
  }

  FCAddBookmarkResultCopyWith<
    FCAddBookmarkResult,
    FCAddBookmarkResult,
    FCAddBookmarkResult
  >
  get copyWith =>
      _FCAddBookmarkResultCopyWithImpl<
        FCAddBookmarkResult,
        FCAddBookmarkResult
      >(this as FCAddBookmarkResult, $identity, $identity);
  @override
  String toString() {
    return FCAddBookmarkResultMapper.ensureInitialized().stringifyValue(
      this as FCAddBookmarkResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCAddBookmarkResultMapper.ensureInitialized().equalsValue(
      this as FCAddBookmarkResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCAddBookmarkResultMapper.ensureInitialized().hashValue(
      this as FCAddBookmarkResult,
    );
  }
}

extension FCAddBookmarkResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCAddBookmarkResult, $Out> {
  FCAddBookmarkResultCopyWith<$R, FCAddBookmarkResult, $Out>
  get $asFCAddBookmarkResult => $base.as(
    (v, t, t2) => _FCAddBookmarkResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCAddBookmarkResultCopyWith<
  $R,
  $In extends FCAddBookmarkResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({
    bool? result,
    String? resultText,
    bool? isBookmarked,
    int? bookmarkId,
  });
  FCAddBookmarkResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCAddBookmarkResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCAddBookmarkResult, $Out>
    implements FCAddBookmarkResultCopyWith<$R, FCAddBookmarkResult, $Out> {
  _FCAddBookmarkResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCAddBookmarkResult> $mapper =
      FCAddBookmarkResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    bool? isBookmarked,
    Object? bookmarkId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (isBookmarked != null) #isBookmarked: isBookmarked,
      if (bookmarkId != $none) #bookmarkId: bookmarkId,
    }),
  );
  @override
  FCAddBookmarkResult $make(CopyWithData data) => FCAddBookmarkResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isBookmarked: data.get(#isBookmarked, or: $value.isBookmarked),
    bookmarkId: data.get(#bookmarkId, or: $value.bookmarkId),
  );

  @override
  FCAddBookmarkResultCopyWith<$R2, FCAddBookmarkResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCAddBookmarkResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCRemoveBookmarkResultMapper
    extends ClassMapperBase<FCRemoveBookmarkResult> {
  FCRemoveBookmarkResultMapper._();

  static FCRemoveBookmarkResultMapper? _instance;
  static FCRemoveBookmarkResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCRemoveBookmarkResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCRemoveBookmarkResult';

  static bool _$result(FCRemoveBookmarkResult v) => v.result;
  static const Field<FCRemoveBookmarkResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCRemoveBookmarkResult v) => v.resultText;
  static const Field<FCRemoveBookmarkResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$isBookmarked(FCRemoveBookmarkResult v) => v.isBookmarked;
  static const Field<FCRemoveBookmarkResult, bool> _f$isBookmarked = Field(
    'isBookmarked',
    _$isBookmarked,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCRemoveBookmarkResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #isBookmarked: _f$isBookmarked,
  };

  static FCRemoveBookmarkResult _instantiate(DecodingData data) {
    return FCRemoveBookmarkResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      isBookmarked: data.dec(_f$isBookmarked),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCRemoveBookmarkResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCRemoveBookmarkResult>(map);
  }

  static FCRemoveBookmarkResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCRemoveBookmarkResult>(json);
  }
}

mixin FCRemoveBookmarkResultMappable {
  String toJson() {
    return FCRemoveBookmarkResultMapper.ensureInitialized()
        .encodeJson<FCRemoveBookmarkResult>(this as FCRemoveBookmarkResult);
  }

  Map<String, dynamic> toMap() {
    return FCRemoveBookmarkResultMapper.ensureInitialized()
        .encodeMap<FCRemoveBookmarkResult>(this as FCRemoveBookmarkResult);
  }

  FCRemoveBookmarkResultCopyWith<
    FCRemoveBookmarkResult,
    FCRemoveBookmarkResult,
    FCRemoveBookmarkResult
  >
  get copyWith =>
      _FCRemoveBookmarkResultCopyWithImpl<
        FCRemoveBookmarkResult,
        FCRemoveBookmarkResult
      >(this as FCRemoveBookmarkResult, $identity, $identity);
  @override
  String toString() {
    return FCRemoveBookmarkResultMapper.ensureInitialized().stringifyValue(
      this as FCRemoveBookmarkResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCRemoveBookmarkResultMapper.ensureInitialized().equalsValue(
      this as FCRemoveBookmarkResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCRemoveBookmarkResultMapper.ensureInitialized().hashValue(
      this as FCRemoveBookmarkResult,
    );
  }
}

extension FCRemoveBookmarkResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCRemoveBookmarkResult, $Out> {
  FCRemoveBookmarkResultCopyWith<$R, FCRemoveBookmarkResult, $Out>
  get $asFCRemoveBookmarkResult => $base.as(
    (v, t, t2) => _FCRemoveBookmarkResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCRemoveBookmarkResultCopyWith<
  $R,
  $In extends FCRemoveBookmarkResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? isBookmarked});
  FCRemoveBookmarkResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCRemoveBookmarkResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCRemoveBookmarkResult, $Out>
    implements
        FCRemoveBookmarkResultCopyWith<$R, FCRemoveBookmarkResult, $Out> {
  _FCRemoveBookmarkResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCRemoveBookmarkResult> $mapper =
      FCRemoveBookmarkResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? isBookmarked}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (isBookmarked != null) #isBookmarked: isBookmarked,
        }),
      );
  @override
  FCRemoveBookmarkResult $make(CopyWithData data) => FCRemoveBookmarkResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    isBookmarked: data.get(#isBookmarked, or: $value.isBookmarked),
  );

  @override
  FCRemoveBookmarkResultCopyWith<$R2, FCRemoveBookmarkResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCRemoveBookmarkResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCBookmarkListResultMapper extends ClassMapperBase<FCBookmarkListResult> {
  FCBookmarkListResultMapper._();

  static FCBookmarkListResultMapper? _instance;
  static FCBookmarkListResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCBookmarkListResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCBookmarkMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCBookmarkListResult';

  static bool _$result(FCBookmarkListResult v) => v.result;
  static const Field<FCBookmarkListResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCBookmarkListResult v) => v.resultText;
  static const Field<FCBookmarkListResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$total(FCBookmarkListResult v) => v.total;
  static const Field<FCBookmarkListResult, int> _f$total = Field(
    'total',
    _$total,
  );
  static List<FCBookmark> _$items(FCBookmarkListResult v) => v.items;
  static const Field<FCBookmarkListResult, List<FCBookmark>> _f$items = Field(
    'items',
    _$items,
  );

  @override
  final MappableFields<FCBookmarkListResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #total: _f$total,
    #items: _f$items,
  };

  static FCBookmarkListResult _instantiate(DecodingData data) {
    return FCBookmarkListResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      total: data.dec(_f$total),
      items: data.dec(_f$items),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCBookmarkListResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCBookmarkListResult>(map);
  }

  static FCBookmarkListResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCBookmarkListResult>(json);
  }
}

mixin FCBookmarkListResultMappable {
  String toJson() {
    return FCBookmarkListResultMapper.ensureInitialized()
        .encodeJson<FCBookmarkListResult>(this as FCBookmarkListResult);
  }

  Map<String, dynamic> toMap() {
    return FCBookmarkListResultMapper.ensureInitialized()
        .encodeMap<FCBookmarkListResult>(this as FCBookmarkListResult);
  }

  FCBookmarkListResultCopyWith<
    FCBookmarkListResult,
    FCBookmarkListResult,
    FCBookmarkListResult
  >
  get copyWith =>
      _FCBookmarkListResultCopyWithImpl<
        FCBookmarkListResult,
        FCBookmarkListResult
      >(this as FCBookmarkListResult, $identity, $identity);
  @override
  String toString() {
    return FCBookmarkListResultMapper.ensureInitialized().stringifyValue(
      this as FCBookmarkListResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCBookmarkListResultMapper.ensureInitialized().equalsValue(
      this as FCBookmarkListResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCBookmarkListResultMapper.ensureInitialized().hashValue(
      this as FCBookmarkListResult,
    );
  }
}

extension FCBookmarkListResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCBookmarkListResult, $Out> {
  FCBookmarkListResultCopyWith<$R, FCBookmarkListResult, $Out>
  get $asFCBookmarkListResult => $base.as(
    (v, t, t2) => _FCBookmarkListResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCBookmarkListResultCopyWith<
  $R,
  $In extends FCBookmarkListResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCBookmark, FCBookmarkCopyWith<$R, FCBookmark, FCBookmark>>
  get items;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? total,
    List<FCBookmark>? items,
  });
  FCBookmarkListResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCBookmarkListResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCBookmarkListResult, $Out>
    implements FCBookmarkListResultCopyWith<$R, FCBookmarkListResult, $Out> {
  _FCBookmarkListResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCBookmarkListResult> $mapper =
      FCBookmarkListResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCBookmark, FCBookmarkCopyWith<$R, FCBookmark, FCBookmark>>
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
    List<FCBookmark>? items,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (total != null) #total: total,
      if (items != null) #items: items,
    }),
  );
  @override
  FCBookmarkListResult $make(CopyWithData data) => FCBookmarkListResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    total: data.get(#total, or: $value.total),
    items: data.get(#items, or: $value.items),
  );

  @override
  FCBookmarkListResultCopyWith<$R2, FCBookmarkListResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCBookmarkListResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

