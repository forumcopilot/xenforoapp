// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'search.dart';

class XenForoSearchMapper extends ClassMapperBase<XenForoSearch> {
  XenForoSearchMapper._();

  static XenForoSearchMapper? _instance;
  static XenForoSearchMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoSearchMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoSearch';

  static int _$searchId(XenForoSearch v) => v.searchId;
  static const Field<XenForoSearch, int> _f$searchId = Field(
    'searchId',
    _$searchId,
  );
  static int? _$resultCount(XenForoSearch v) => v.resultCount;
  static const Field<XenForoSearch, int> _f$resultCount = Field(
    'resultCount',
    _$resultCount,
    opt: true,
  );
  static String? _$searchType(XenForoSearch v) => v.searchType;
  static const Field<XenForoSearch, String> _f$searchType = Field(
    'searchType',
    _$searchType,
    opt: true,
  );
  static String? _$searchQuery(XenForoSearch v) => v.searchQuery;
  static const Field<XenForoSearch, String> _f$searchQuery = Field(
    'searchQuery',
    _$searchQuery,
    opt: true,
  );
  static List<dynamic>? _$searchConstraints(XenForoSearch v) =>
      v.searchConstraints;
  static const Field<XenForoSearch, List<dynamic>> _f$searchConstraints = Field(
    'searchConstraints',
    _$searchConstraints,
    opt: true,
  );
  static String? _$searchOrder(XenForoSearch v) => v.searchOrder;
  static const Field<XenForoSearch, String> _f$searchOrder = Field(
    'searchOrder',
    _$searchOrder,
    opt: true,
  );
  static bool? _$searchGrouping(XenForoSearch v) => v.searchGrouping;
  static const Field<XenForoSearch, bool> _f$searchGrouping = Field(
    'searchGrouping',
    _$searchGrouping,
    opt: true,
  );
  static List<dynamic>? _$warnings(XenForoSearch v) => v.warnings;
  static const Field<XenForoSearch, List<dynamic>> _f$warnings = Field(
    'warnings',
    _$warnings,
    opt: true,
  );
  static int? _$userId(XenForoSearch v) => v.userId;
  static const Field<XenForoSearch, int> _f$userId = Field(
    'userId',
    _$userId,
    opt: true,
  );
  static int? _$searchDate(XenForoSearch v) => v.searchDate;
  static const Field<XenForoSearch, int> _f$searchDate = Field(
    'searchDate',
    _$searchDate,
    opt: true,
  );
  static String? _$queryHash(XenForoSearch v) => v.queryHash;
  static const Field<XenForoSearch, String> _f$queryHash = Field(
    'queryHash',
    _$queryHash,
    opt: true,
  );

  @override
  final MappableFields<XenForoSearch> fields = const {
    #searchId: _f$searchId,
    #resultCount: _f$resultCount,
    #searchType: _f$searchType,
    #searchQuery: _f$searchQuery,
    #searchConstraints: _f$searchConstraints,
    #searchOrder: _f$searchOrder,
    #searchGrouping: _f$searchGrouping,
    #warnings: _f$warnings,
    #userId: _f$userId,
    #searchDate: _f$searchDate,
    #queryHash: _f$queryHash,
  };

  static XenForoSearch _instantiate(DecodingData data) {
    return XenForoSearch(
      searchId: data.dec(_f$searchId),
      resultCount: data.dec(_f$resultCount),
      searchType: data.dec(_f$searchType),
      searchQuery: data.dec(_f$searchQuery),
      searchConstraints: data.dec(_f$searchConstraints),
      searchOrder: data.dec(_f$searchOrder),
      searchGrouping: data.dec(_f$searchGrouping),
      warnings: data.dec(_f$warnings),
      userId: data.dec(_f$userId),
      searchDate: data.dec(_f$searchDate),
      queryHash: data.dec(_f$queryHash),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoSearch fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoSearch>(map);
  }

  static XenForoSearch fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoSearch>(json);
  }
}

mixin XenForoSearchMappable {
  String toJson() {
    return XenForoSearchMapper.ensureInitialized().encodeJson<XenForoSearch>(
      this as XenForoSearch,
    );
  }

  Map<String, dynamic> toMap() {
    return XenForoSearchMapper.ensureInitialized().encodeMap<XenForoSearch>(
      this as XenForoSearch,
    );
  }

  XenForoSearchCopyWith<XenForoSearch, XenForoSearch, XenForoSearch>
  get copyWith => _XenForoSearchCopyWithImpl<XenForoSearch, XenForoSearch>(
    this as XenForoSearch,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return XenForoSearchMapper.ensureInitialized().stringifyValue(
      this as XenForoSearch,
    );
  }

  @override
  bool operator ==(Object other) {
    return XenForoSearchMapper.ensureInitialized().equalsValue(
      this as XenForoSearch,
      other,
    );
  }

  @override
  int get hashCode {
    return XenForoSearchMapper.ensureInitialized().hashValue(
      this as XenForoSearch,
    );
  }
}

extension XenForoSearchValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoSearch, $Out> {
  XenForoSearchCopyWith<$R, XenForoSearch, $Out> get $asXenForoSearch =>
      $base.as((v, t, t2) => _XenForoSearchCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoSearchCopyWith<$R, $In extends XenForoSearch, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get searchConstraints;
  ListCopyWith<$R, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>? get warnings;
  $R call({
    int? searchId,
    int? resultCount,
    String? searchType,
    String? searchQuery,
    List<dynamic>? searchConstraints,
    String? searchOrder,
    bool? searchGrouping,
    List<dynamic>? warnings,
    int? userId,
    int? searchDate,
    String? queryHash,
  });
  XenForoSearchCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _XenForoSearchCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoSearch, $Out>
    implements XenForoSearchCopyWith<$R, XenForoSearch, $Out> {
  _XenForoSearchCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoSearch> $mapper =
      XenForoSearchMapper.ensureInitialized();
  @override
  ListCopyWith<$R, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get searchConstraints => $value.searchConstraints != null
      ? ListCopyWith(
          $value.searchConstraints!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(searchConstraints: v),
        )
      : null;
  @override
  ListCopyWith<$R, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get warnings => $value.warnings != null
      ? ListCopyWith(
          $value.warnings!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(warnings: v),
        )
      : null;
  @override
  $R call({
    int? searchId,
    Object? resultCount = $none,
    Object? searchType = $none,
    Object? searchQuery = $none,
    Object? searchConstraints = $none,
    Object? searchOrder = $none,
    Object? searchGrouping = $none,
    Object? warnings = $none,
    Object? userId = $none,
    Object? searchDate = $none,
    Object? queryHash = $none,
  }) => $apply(
    FieldCopyWithData({
      if (searchId != null) #searchId: searchId,
      if (resultCount != $none) #resultCount: resultCount,
      if (searchType != $none) #searchType: searchType,
      if (searchQuery != $none) #searchQuery: searchQuery,
      if (searchConstraints != $none) #searchConstraints: searchConstraints,
      if (searchOrder != $none) #searchOrder: searchOrder,
      if (searchGrouping != $none) #searchGrouping: searchGrouping,
      if (warnings != $none) #warnings: warnings,
      if (userId != $none) #userId: userId,
      if (searchDate != $none) #searchDate: searchDate,
      if (queryHash != $none) #queryHash: queryHash,
    }),
  );
  @override
  XenForoSearch $make(CopyWithData data) => XenForoSearch(
    searchId: data.get(#searchId, or: $value.searchId),
    resultCount: data.get(#resultCount, or: $value.resultCount),
    searchType: data.get(#searchType, or: $value.searchType),
    searchQuery: data.get(#searchQuery, or: $value.searchQuery),
    searchConstraints: data.get(
      #searchConstraints,
      or: $value.searchConstraints,
    ),
    searchOrder: data.get(#searchOrder, or: $value.searchOrder),
    searchGrouping: data.get(#searchGrouping, or: $value.searchGrouping),
    warnings: data.get(#warnings, or: $value.warnings),
    userId: data.get(#userId, or: $value.userId),
    searchDate: data.get(#searchDate, or: $value.searchDate),
    queryHash: data.get(#queryHash, or: $value.queryHash),
  );

  @override
  XenForoSearchCopyWith<$R2, XenForoSearch, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _XenForoSearchCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

