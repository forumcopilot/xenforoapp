// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_search_result.dart';

class FCSearchTopicResultMapper extends ClassMapperBase<FCSearchTopicResult> {
  FCSearchTopicResultMapper._();

  static FCSearchTopicResultMapper? _instance;
  static FCSearchTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSearchTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCTopicMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSearchTopicResult';

  static bool _$result(FCSearchTopicResult v) => v.result;
  static const Field<FCSearchTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSearchTopicResult v) => v.resultText;
  static const Field<FCSearchTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalTopicNum(FCSearchTopicResult v) => v.totalTopicNum;
  static const Field<FCSearchTopicResult, int> _f$totalTopicNum = Field(
    'totalTopicNum',
    _$totalTopicNum,
  );
  static String? _$searchId(FCSearchTopicResult v) => v.searchId;
  static const Field<FCSearchTopicResult, String> _f$searchId = Field(
    'searchId',
    _$searchId,
    opt: true,
  );
  static List<FCTopic> _$topics(FCSearchTopicResult v) => v.topics;
  static const Field<FCSearchTopicResult, List<FCTopic>> _f$topics = Field(
    'topics',
    _$topics,
  );

  @override
  final MappableFields<FCSearchTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalTopicNum: _f$totalTopicNum,
    #searchId: _f$searchId,
    #topics: _f$topics,
  };

  static FCSearchTopicResult _instantiate(DecodingData data) {
    return FCSearchTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalTopicNum: data.dec(_f$totalTopicNum),
      searchId: data.dec(_f$searchId),
      topics: data.dec(_f$topics),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSearchTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSearchTopicResult>(map);
  }

  static FCSearchTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCSearchTopicResult>(json);
  }
}

mixin FCSearchTopicResultMappable {
  String toJson() {
    return FCSearchTopicResultMapper.ensureInitialized()
        .encodeJson<FCSearchTopicResult>(this as FCSearchTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCSearchTopicResultMapper.ensureInitialized()
        .encodeMap<FCSearchTopicResult>(this as FCSearchTopicResult);
  }

  FCSearchTopicResultCopyWith<
    FCSearchTopicResult,
    FCSearchTopicResult,
    FCSearchTopicResult
  >
  get copyWith =>
      _FCSearchTopicResultCopyWithImpl<
        FCSearchTopicResult,
        FCSearchTopicResult
      >(this as FCSearchTopicResult, $identity, $identity);
  @override
  String toString() {
    return FCSearchTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCSearchTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSearchTopicResultMapper.ensureInitialized().equalsValue(
      this as FCSearchTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSearchTopicResultMapper.ensureInitialized().hashValue(
      this as FCSearchTopicResult,
    );
  }
}

extension FCSearchTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSearchTopicResult, $Out> {
  FCSearchTopicResultCopyWith<$R, FCSearchTopicResult, $Out>
  get $asFCSearchTopicResult => $base.as(
    (v, t, t2) => _FCSearchTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSearchTopicResultCopyWith<
  $R,
  $In extends FCSearchTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCTopic, FCTopicCopyWith<$R, FCTopic, FCTopic>> get topics;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalTopicNum,
    String? searchId,
    List<FCTopic>? topics,
  });
  FCSearchTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSearchTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSearchTopicResult, $Out>
    implements FCSearchTopicResultCopyWith<$R, FCSearchTopicResult, $Out> {
  _FCSearchTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSearchTopicResult> $mapper =
      FCSearchTopicResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCTopic, FCTopicCopyWith<$R, FCTopic, FCTopic>> get topics =>
      ListCopyWith(
        $value.topics,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(topics: v),
      );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? totalTopicNum,
    Object? searchId = $none,
    List<FCTopic>? topics,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalTopicNum != null) #totalTopicNum: totalTopicNum,
      if (searchId != $none) #searchId: searchId,
      if (topics != null) #topics: topics,
    }),
  );
  @override
  FCSearchTopicResult $make(CopyWithData data) => FCSearchTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalTopicNum: data.get(#totalTopicNum, or: $value.totalTopicNum),
    searchId: data.get(#searchId, or: $value.searchId),
    topics: data.get(#topics, or: $value.topics),
  );

  @override
  FCSearchTopicResultCopyWith<$R2, FCSearchTopicResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCSearchTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCSearchPostResultMapper extends ClassMapperBase<FCSearchPostResult> {
  FCSearchPostResultMapper._();

  static FCSearchPostResultMapper? _instance;
  static FCSearchPostResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSearchPostResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCPostMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSearchPostResult';

  static bool _$result(FCSearchPostResult v) => v.result;
  static const Field<FCSearchPostResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSearchPostResult v) => v.resultText;
  static const Field<FCSearchPostResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalPostNum(FCSearchPostResult v) => v.totalPostNum;
  static const Field<FCSearchPostResult, int> _f$totalPostNum = Field(
    'totalPostNum',
    _$totalPostNum,
  );
  static String? _$searchId(FCSearchPostResult v) => v.searchId;
  static const Field<FCSearchPostResult, String> _f$searchId = Field(
    'searchId',
    _$searchId,
    opt: true,
  );
  static List<FCPost> _$posts(FCSearchPostResult v) => v.posts;
  static const Field<FCSearchPostResult, List<FCPost>> _f$posts = Field(
    'posts',
    _$posts,
  );

  @override
  final MappableFields<FCSearchPostResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalPostNum: _f$totalPostNum,
    #searchId: _f$searchId,
    #posts: _f$posts,
  };

  static FCSearchPostResult _instantiate(DecodingData data) {
    return FCSearchPostResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalPostNum: data.dec(_f$totalPostNum),
      searchId: data.dec(_f$searchId),
      posts: data.dec(_f$posts),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSearchPostResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSearchPostResult>(map);
  }

  static FCSearchPostResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCSearchPostResult>(json);
  }
}

mixin FCSearchPostResultMappable {
  String toJson() {
    return FCSearchPostResultMapper.ensureInitialized()
        .encodeJson<FCSearchPostResult>(this as FCSearchPostResult);
  }

  Map<String, dynamic> toMap() {
    return FCSearchPostResultMapper.ensureInitialized()
        .encodeMap<FCSearchPostResult>(this as FCSearchPostResult);
  }

  FCSearchPostResultCopyWith<
    FCSearchPostResult,
    FCSearchPostResult,
    FCSearchPostResult
  >
  get copyWith =>
      _FCSearchPostResultCopyWithImpl<FCSearchPostResult, FCSearchPostResult>(
        this as FCSearchPostResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCSearchPostResultMapper.ensureInitialized().stringifyValue(
      this as FCSearchPostResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSearchPostResultMapper.ensureInitialized().equalsValue(
      this as FCSearchPostResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSearchPostResultMapper.ensureInitialized().hashValue(
      this as FCSearchPostResult,
    );
  }
}

extension FCSearchPostResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSearchPostResult, $Out> {
  FCSearchPostResultCopyWith<$R, FCSearchPostResult, $Out>
  get $asFCSearchPostResult => $base.as(
    (v, t, t2) => _FCSearchPostResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSearchPostResultCopyWith<
  $R,
  $In extends FCSearchPostResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCPost, FCPostCopyWith<$R, FCPost, FCPost>> get posts;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalPostNum,
    String? searchId,
    List<FCPost>? posts,
  });
  FCSearchPostResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSearchPostResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSearchPostResult, $Out>
    implements FCSearchPostResultCopyWith<$R, FCSearchPostResult, $Out> {
  _FCSearchPostResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSearchPostResult> $mapper =
      FCSearchPostResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCPost, FCPostCopyWith<$R, FCPost, FCPost>> get posts =>
      ListCopyWith(
        $value.posts,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(posts: v),
      );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? totalPostNum,
    Object? searchId = $none,
    List<FCPost>? posts,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalPostNum != null) #totalPostNum: totalPostNum,
      if (searchId != $none) #searchId: searchId,
      if (posts != null) #posts: posts,
    }),
  );
  @override
  FCSearchPostResult $make(CopyWithData data) => FCSearchPostResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalPostNum: data.get(#totalPostNum, or: $value.totalPostNum),
    searchId: data.get(#searchId, or: $value.searchId),
    posts: data.get(#posts, or: $value.posts),
  );

  @override
  FCSearchPostResultCopyWith<$R2, FCSearchPostResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCSearchPostResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCSearchDataResultPostMapper
    extends ClassMapperBase<FCSearchDataResultPost> {
  FCSearchDataResultPostMapper._();

  static FCSearchDataResultPostMapper? _instance;
  static FCSearchDataResultPostMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSearchDataResultPostMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCPostMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSearchDataResultPost';

  static bool _$result(FCSearchDataResultPost v) => v.result;
  static const Field<FCSearchDataResultPost, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSearchDataResultPost v) => v.resultText;
  static const Field<FCSearchDataResultPost, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalPostNum(FCSearchDataResultPost v) => v.totalPostNum;
  static const Field<FCSearchDataResultPost, int> _f$totalPostNum = Field(
    'totalPostNum',
    _$totalPostNum,
  );
  static String? _$searchId(FCSearchDataResultPost v) => v.searchId;
  static const Field<FCSearchDataResultPost, String> _f$searchId = Field(
    'searchId',
    _$searchId,
    opt: true,
  );
  static List<FCPost> _$posts(FCSearchDataResultPost v) => v.posts;
  static const Field<FCSearchDataResultPost, List<FCPost>> _f$posts = Field(
    'posts',
    _$posts,
  );

  @override
  final MappableFields<FCSearchDataResultPost> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalPostNum: _f$totalPostNum,
    #searchId: _f$searchId,
    #posts: _f$posts,
  };

  static FCSearchDataResultPost _instantiate(DecodingData data) {
    return FCSearchDataResultPost(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalPostNum: data.dec(_f$totalPostNum),
      searchId: data.dec(_f$searchId),
      posts: data.dec(_f$posts),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSearchDataResultPost fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSearchDataResultPost>(map);
  }

  static FCSearchDataResultPost fromJson(String json) {
    return ensureInitialized().decodeJson<FCSearchDataResultPost>(json);
  }
}

mixin FCSearchDataResultPostMappable {
  String toJson() {
    return FCSearchDataResultPostMapper.ensureInitialized()
        .encodeJson<FCSearchDataResultPost>(this as FCSearchDataResultPost);
  }

  Map<String, dynamic> toMap() {
    return FCSearchDataResultPostMapper.ensureInitialized()
        .encodeMap<FCSearchDataResultPost>(this as FCSearchDataResultPost);
  }

  FCSearchDataResultPostCopyWith<
    FCSearchDataResultPost,
    FCSearchDataResultPost,
    FCSearchDataResultPost
  >
  get copyWith =>
      _FCSearchDataResultPostCopyWithImpl<
        FCSearchDataResultPost,
        FCSearchDataResultPost
      >(this as FCSearchDataResultPost, $identity, $identity);
  @override
  String toString() {
    return FCSearchDataResultPostMapper.ensureInitialized().stringifyValue(
      this as FCSearchDataResultPost,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSearchDataResultPostMapper.ensureInitialized().equalsValue(
      this as FCSearchDataResultPost,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSearchDataResultPostMapper.ensureInitialized().hashValue(
      this as FCSearchDataResultPost,
    );
  }
}

extension FCSearchDataResultPostValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSearchDataResultPost, $Out> {
  FCSearchDataResultPostCopyWith<$R, FCSearchDataResultPost, $Out>
  get $asFCSearchDataResultPost => $base.as(
    (v, t, t2) => _FCSearchDataResultPostCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSearchDataResultPostCopyWith<
  $R,
  $In extends FCSearchDataResultPost,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCPost, FCPostCopyWith<$R, FCPost, FCPost>> get posts;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalPostNum,
    String? searchId,
    List<FCPost>? posts,
  });
  FCSearchDataResultPostCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSearchDataResultPostCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSearchDataResultPost, $Out>
    implements
        FCSearchDataResultPostCopyWith<$R, FCSearchDataResultPost, $Out> {
  _FCSearchDataResultPostCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSearchDataResultPost> $mapper =
      FCSearchDataResultPostMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCPost, FCPostCopyWith<$R, FCPost, FCPost>> get posts =>
      ListCopyWith(
        $value.posts,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(posts: v),
      );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? totalPostNum,
    Object? searchId = $none,
    List<FCPost>? posts,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalPostNum != null) #totalPostNum: totalPostNum,
      if (searchId != $none) #searchId: searchId,
      if (posts != null) #posts: posts,
    }),
  );
  @override
  FCSearchDataResultPost $make(CopyWithData data) => FCSearchDataResultPost(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalPostNum: data.get(#totalPostNum, or: $value.totalPostNum),
    searchId: data.get(#searchId, or: $value.searchId),
    posts: data.get(#posts, or: $value.posts),
  );

  @override
  FCSearchDataResultPostCopyWith<$R2, FCSearchDataResultPost, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCSearchDataResultPostCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCSearchDataResultTopicMapper
    extends ClassMapperBase<FCSearchDataResultTopic> {
  FCSearchDataResultTopicMapper._();

  static FCSearchDataResultTopicMapper? _instance;
  static FCSearchDataResultTopicMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCSearchDataResultTopicMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
      FCTopicMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSearchDataResultTopic';

  static bool _$result(FCSearchDataResultTopic v) => v.result;
  static const Field<FCSearchDataResultTopic, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSearchDataResultTopic v) => v.resultText;
  static const Field<FCSearchDataResultTopic, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalTopicNum(FCSearchDataResultTopic v) => v.totalTopicNum;
  static const Field<FCSearchDataResultTopic, int> _f$totalTopicNum = Field(
    'totalTopicNum',
    _$totalTopicNum,
  );
  static String? _$searchId(FCSearchDataResultTopic v) => v.searchId;
  static const Field<FCSearchDataResultTopic, String> _f$searchId = Field(
    'searchId',
    _$searchId,
    opt: true,
  );
  static List<FCTopic> _$topics(FCSearchDataResultTopic v) => v.topics;
  static const Field<FCSearchDataResultTopic, List<FCTopic>> _f$topics = Field(
    'topics',
    _$topics,
  );

  @override
  final MappableFields<FCSearchDataResultTopic> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalTopicNum: _f$totalTopicNum,
    #searchId: _f$searchId,
    #topics: _f$topics,
  };

  static FCSearchDataResultTopic _instantiate(DecodingData data) {
    return FCSearchDataResultTopic(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalTopicNum: data.dec(_f$totalTopicNum),
      searchId: data.dec(_f$searchId),
      topics: data.dec(_f$topics),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSearchDataResultTopic fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSearchDataResultTopic>(map);
  }

  static FCSearchDataResultTopic fromJson(String json) {
    return ensureInitialized().decodeJson<FCSearchDataResultTopic>(json);
  }
}

mixin FCSearchDataResultTopicMappable {
  String toJson() {
    return FCSearchDataResultTopicMapper.ensureInitialized()
        .encodeJson<FCSearchDataResultTopic>(this as FCSearchDataResultTopic);
  }

  Map<String, dynamic> toMap() {
    return FCSearchDataResultTopicMapper.ensureInitialized()
        .encodeMap<FCSearchDataResultTopic>(this as FCSearchDataResultTopic);
  }

  FCSearchDataResultTopicCopyWith<
    FCSearchDataResultTopic,
    FCSearchDataResultTopic,
    FCSearchDataResultTopic
  >
  get copyWith =>
      _FCSearchDataResultTopicCopyWithImpl<
        FCSearchDataResultTopic,
        FCSearchDataResultTopic
      >(this as FCSearchDataResultTopic, $identity, $identity);
  @override
  String toString() {
    return FCSearchDataResultTopicMapper.ensureInitialized().stringifyValue(
      this as FCSearchDataResultTopic,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSearchDataResultTopicMapper.ensureInitialized().equalsValue(
      this as FCSearchDataResultTopic,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSearchDataResultTopicMapper.ensureInitialized().hashValue(
      this as FCSearchDataResultTopic,
    );
  }
}

extension FCSearchDataResultTopicValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSearchDataResultTopic, $Out> {
  FCSearchDataResultTopicCopyWith<$R, FCSearchDataResultTopic, $Out>
  get $asFCSearchDataResultTopic => $base.as(
    (v, t, t2) => _FCSearchDataResultTopicCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSearchDataResultTopicCopyWith<
  $R,
  $In extends FCSearchDataResultTopic,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCTopic, FCTopicCopyWith<$R, FCTopic, FCTopic>> get topics;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalTopicNum,
    String? searchId,
    List<FCTopic>? topics,
  });
  FCSearchDataResultTopicCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSearchDataResultTopicCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSearchDataResultTopic, $Out>
    implements
        FCSearchDataResultTopicCopyWith<$R, FCSearchDataResultTopic, $Out> {
  _FCSearchDataResultTopicCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSearchDataResultTopic> $mapper =
      FCSearchDataResultTopicMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCTopic, FCTopicCopyWith<$R, FCTopic, FCTopic>> get topics =>
      ListCopyWith(
        $value.topics,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(topics: v),
      );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? totalTopicNum,
    Object? searchId = $none,
    List<FCTopic>? topics,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalTopicNum != null) #totalTopicNum: totalTopicNum,
      if (searchId != $none) #searchId: searchId,
      if (topics != null) #topics: topics,
    }),
  );
  @override
  FCSearchDataResultTopic $make(CopyWithData data) => FCSearchDataResultTopic(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalTopicNum: data.get(#totalTopicNum, or: $value.totalTopicNum),
    searchId: data.get(#searchId, or: $value.searchId),
    topics: data.get(#topics, or: $value.topics),
  );

  @override
  FCSearchDataResultTopicCopyWith<$R2, FCSearchDataResultTopic, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCSearchDataResultTopicCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

