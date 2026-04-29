// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_subscription_result.dart';

class FCSubscribedForumResultMapper
    extends ClassMapperBase<FCSubscribedForumResult> {
  FCSubscribedForumResultMapper._();

  static FCSubscribedForumResultMapper? _instance;
  static FCSubscribedForumResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCSubscribedForumResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
      FCSubscribedForumMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSubscribedForumResult';

  static bool _$result(FCSubscribedForumResult v) => v.result;
  static const Field<FCSubscribedForumResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSubscribedForumResult v) => v.resultText;
  static const Field<FCSubscribedForumResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalForumsNum(FCSubscribedForumResult v) => v.totalForumsNum;
  static const Field<FCSubscribedForumResult, int> _f$totalForumsNum = Field(
    'totalForumsNum',
    _$totalForumsNum,
    opt: true,
    def: 0,
  );
  static List<FCSubscribedForum> _$forums(FCSubscribedForumResult v) =>
      v.forums;
  static const Field<FCSubscribedForumResult, List<FCSubscribedForum>>
  _f$forums = Field('forums', _$forums, opt: true, def: const []);

  @override
  final MappableFields<FCSubscribedForumResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalForumsNum: _f$totalForumsNum,
    #forums: _f$forums,
  };

  static FCSubscribedForumResult _instantiate(DecodingData data) {
    return FCSubscribedForumResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalForumsNum: data.dec(_f$totalForumsNum),
      forums: data.dec(_f$forums),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSubscribedForumResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSubscribedForumResult>(map);
  }

  static FCSubscribedForumResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCSubscribedForumResult>(json);
  }
}

mixin FCSubscribedForumResultMappable {
  String toJson() {
    return FCSubscribedForumResultMapper.ensureInitialized()
        .encodeJson<FCSubscribedForumResult>(this as FCSubscribedForumResult);
  }

  Map<String, dynamic> toMap() {
    return FCSubscribedForumResultMapper.ensureInitialized()
        .encodeMap<FCSubscribedForumResult>(this as FCSubscribedForumResult);
  }

  FCSubscribedForumResultCopyWith<
    FCSubscribedForumResult,
    FCSubscribedForumResult,
    FCSubscribedForumResult
  >
  get copyWith =>
      _FCSubscribedForumResultCopyWithImpl<
        FCSubscribedForumResult,
        FCSubscribedForumResult
      >(this as FCSubscribedForumResult, $identity, $identity);
  @override
  String toString() {
    return FCSubscribedForumResultMapper.ensureInitialized().stringifyValue(
      this as FCSubscribedForumResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSubscribedForumResultMapper.ensureInitialized().equalsValue(
      this as FCSubscribedForumResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSubscribedForumResultMapper.ensureInitialized().hashValue(
      this as FCSubscribedForumResult,
    );
  }
}

extension FCSubscribedForumResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSubscribedForumResult, $Out> {
  FCSubscribedForumResultCopyWith<$R, FCSubscribedForumResult, $Out>
  get $asFCSubscribedForumResult => $base.as(
    (v, t, t2) => _FCSubscribedForumResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSubscribedForumResultCopyWith<
  $R,
  $In extends FCSubscribedForumResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCSubscribedForum,
    FCSubscribedForumCopyWith<$R, FCSubscribedForum, FCSubscribedForum>
  >
  get forums;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalForumsNum,
    List<FCSubscribedForum>? forums,
  });
  FCSubscribedForumResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSubscribedForumResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSubscribedForumResult, $Out>
    implements
        FCSubscribedForumResultCopyWith<$R, FCSubscribedForumResult, $Out> {
  _FCSubscribedForumResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSubscribedForumResult> $mapper =
      FCSubscribedForumResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCSubscribedForum,
    FCSubscribedForumCopyWith<$R, FCSubscribedForum, FCSubscribedForum>
  >
  get forums => ListCopyWith(
    $value.forums,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(forums: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? totalForumsNum,
    List<FCSubscribedForum>? forums,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalForumsNum != null) #totalForumsNum: totalForumsNum,
      if (forums != null) #forums: forums,
    }),
  );
  @override
  FCSubscribedForumResult $make(CopyWithData data) => FCSubscribedForumResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalForumsNum: data.get(#totalForumsNum, or: $value.totalForumsNum),
    forums: data.get(#forums, or: $value.forums),
  );

  @override
  FCSubscribedForumResultCopyWith<$R2, FCSubscribedForumResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCSubscribedForumResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCSubscribedForumMapper extends ClassMapperBase<FCSubscribedForum> {
  FCSubscribedForumMapper._();

  static FCSubscribedForumMapper? _instance;
  static FCSubscribedForumMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSubscribedForumMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCSubscribedForum';

  static String _$forumId(FCSubscribedForum v) => v.forumId;
  static const Field<FCSubscribedForum, String> _f$forumId = Field(
    'forumId',
    _$forumId,
  );
  static String _$forumName(FCSubscribedForum v) => v.forumName;
  static const Field<FCSubscribedForum, String> _f$forumName = Field(
    'forumName',
    _$forumName,
  );
  static String? _$iconUrl(FCSubscribedForum v) => v.iconUrl;
  static const Field<FCSubscribedForum, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static bool _$isProtected(FCSubscribedForum v) => v.isProtected;
  static const Field<FCSubscribedForum, bool> _f$isProtected = Field(
    'isProtected',
    _$isProtected,
    opt: true,
    def: false,
  );
  static bool _$newPost(FCSubscribedForum v) => v.newPost;
  static const Field<FCSubscribedForum, bool> _f$newPost = Field(
    'newPost',
    _$newPost,
    opt: true,
    def: false,
  );
  static bool? _$canPost(FCSubscribedForum v) => v.canPost;
  static const Field<FCSubscribedForum, bool> _f$canPost = Field(
    'canPost',
    _$canPost,
    opt: true,
  );
  static int _$subscribeMode(FCSubscribedForum v) => v.subscribeMode;
  static const Field<FCSubscribedForum, int> _f$subscribeMode = Field(
    'subscribeMode',
    _$subscribeMode,
    opt: true,
    def: 0,
  );
  static bool _$isSubscribed(FCSubscribedForum v) => v.isSubscribed;
  static const Field<FCSubscribedForum, bool> _f$isSubscribed = Field(
    'isSubscribed',
    _$isSubscribed,
    opt: true,
    def: true,
  );
  static bool _$canSubscribe(FCSubscribedForum v) => v.canSubscribe;
  static const Field<FCSubscribedForum, bool> _f$canSubscribe = Field(
    'canSubscribe',
    _$canSubscribe,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<FCSubscribedForum> fields = const {
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #iconUrl: _f$iconUrl,
    #isProtected: _f$isProtected,
    #newPost: _f$newPost,
    #canPost: _f$canPost,
    #subscribeMode: _f$subscribeMode,
    #isSubscribed: _f$isSubscribed,
    #canSubscribe: _f$canSubscribe,
  };

  static FCSubscribedForum _instantiate(DecodingData data) {
    return FCSubscribedForum(
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      iconUrl: data.dec(_f$iconUrl),
      isProtected: data.dec(_f$isProtected),
      newPost: data.dec(_f$newPost),
      canPost: data.dec(_f$canPost),
      subscribeMode: data.dec(_f$subscribeMode),
      isSubscribed: data.dec(_f$isSubscribed),
      canSubscribe: data.dec(_f$canSubscribe),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSubscribedForum fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSubscribedForum>(map);
  }

  static FCSubscribedForum fromJson(String json) {
    return ensureInitialized().decodeJson<FCSubscribedForum>(json);
  }
}

mixin FCSubscribedForumMappable {
  String toJson() {
    return FCSubscribedForumMapper.ensureInitialized()
        .encodeJson<FCSubscribedForum>(this as FCSubscribedForum);
  }

  Map<String, dynamic> toMap() {
    return FCSubscribedForumMapper.ensureInitialized()
        .encodeMap<FCSubscribedForum>(this as FCSubscribedForum);
  }

  FCSubscribedForumCopyWith<
    FCSubscribedForum,
    FCSubscribedForum,
    FCSubscribedForum
  >
  get copyWith =>
      _FCSubscribedForumCopyWithImpl<FCSubscribedForum, FCSubscribedForum>(
        this as FCSubscribedForum,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCSubscribedForumMapper.ensureInitialized().stringifyValue(
      this as FCSubscribedForum,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSubscribedForumMapper.ensureInitialized().equalsValue(
      this as FCSubscribedForum,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSubscribedForumMapper.ensureInitialized().hashValue(
      this as FCSubscribedForum,
    );
  }
}

extension FCSubscribedForumValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSubscribedForum, $Out> {
  FCSubscribedForumCopyWith<$R, FCSubscribedForum, $Out>
  get $asFCSubscribedForum => $base.as(
    (v, t, t2) => _FCSubscribedForumCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSubscribedForumCopyWith<
  $R,
  $In extends FCSubscribedForum,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? forumId,
    String? forumName,
    String? iconUrl,
    bool? isProtected,
    bool? newPost,
    bool? canPost,
    int? subscribeMode,
    bool? isSubscribed,
    bool? canSubscribe,
  });
  FCSubscribedForumCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSubscribedForumCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSubscribedForum, $Out>
    implements FCSubscribedForumCopyWith<$R, FCSubscribedForum, $Out> {
  _FCSubscribedForumCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSubscribedForum> $mapper =
      FCSubscribedForumMapper.ensureInitialized();
  @override
  $R call({
    String? forumId,
    String? forumName,
    Object? iconUrl = $none,
    bool? isProtected,
    bool? newPost,
    Object? canPost = $none,
    int? subscribeMode,
    bool? isSubscribed,
    bool? canSubscribe,
  }) => $apply(
    FieldCopyWithData({
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (iconUrl != $none) #iconUrl: iconUrl,
      if (isProtected != null) #isProtected: isProtected,
      if (newPost != null) #newPost: newPost,
      if (canPost != $none) #canPost: canPost,
      if (subscribeMode != null) #subscribeMode: subscribeMode,
      if (isSubscribed != null) #isSubscribed: isSubscribed,
      if (canSubscribe != null) #canSubscribe: canSubscribe,
    }),
  );
  @override
  FCSubscribedForum $make(CopyWithData data) => FCSubscribedForum(
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    iconUrl: data.get(#iconUrl, or: $value.iconUrl),
    isProtected: data.get(#isProtected, or: $value.isProtected),
    newPost: data.get(#newPost, or: $value.newPost),
    canPost: data.get(#canPost, or: $value.canPost),
    subscribeMode: data.get(#subscribeMode, or: $value.subscribeMode),
    isSubscribed: data.get(#isSubscribed, or: $value.isSubscribed),
    canSubscribe: data.get(#canSubscribe, or: $value.canSubscribe),
  );

  @override
  FCSubscribedForumCopyWith<$R2, FCSubscribedForum, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCSubscribedForumCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCSubscribeForumResultMapper
    extends ClassMapperBase<FCSubscribeForumResult> {
  FCSubscribeForumResultMapper._();

  static FCSubscribeForumResultMapper? _instance;
  static FCSubscribeForumResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSubscribeForumResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSubscribeForumResult';

  static bool _$result(FCSubscribeForumResult v) => v.result;
  static const Field<FCSubscribeForumResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSubscribeForumResult v) => v.resultText;
  static const Field<FCSubscribeForumResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCSubscribeForumResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCSubscribeForumResult _instantiate(DecodingData data) {
    return FCSubscribeForumResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSubscribeForumResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSubscribeForumResult>(map);
  }

  static FCSubscribeForumResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCSubscribeForumResult>(json);
  }
}

mixin FCSubscribeForumResultMappable {
  String toJson() {
    return FCSubscribeForumResultMapper.ensureInitialized()
        .encodeJson<FCSubscribeForumResult>(this as FCSubscribeForumResult);
  }

  Map<String, dynamic> toMap() {
    return FCSubscribeForumResultMapper.ensureInitialized()
        .encodeMap<FCSubscribeForumResult>(this as FCSubscribeForumResult);
  }

  FCSubscribeForumResultCopyWith<
    FCSubscribeForumResult,
    FCSubscribeForumResult,
    FCSubscribeForumResult
  >
  get copyWith =>
      _FCSubscribeForumResultCopyWithImpl<
        FCSubscribeForumResult,
        FCSubscribeForumResult
      >(this as FCSubscribeForumResult, $identity, $identity);
  @override
  String toString() {
    return FCSubscribeForumResultMapper.ensureInitialized().stringifyValue(
      this as FCSubscribeForumResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSubscribeForumResultMapper.ensureInitialized().equalsValue(
      this as FCSubscribeForumResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSubscribeForumResultMapper.ensureInitialized().hashValue(
      this as FCSubscribeForumResult,
    );
  }
}

extension FCSubscribeForumResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSubscribeForumResult, $Out> {
  FCSubscribeForumResultCopyWith<$R, FCSubscribeForumResult, $Out>
  get $asFCSubscribeForumResult => $base.as(
    (v, t, t2) => _FCSubscribeForumResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSubscribeForumResultCopyWith<
  $R,
  $In extends FCSubscribeForumResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCSubscribeForumResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSubscribeForumResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSubscribeForumResult, $Out>
    implements
        FCSubscribeForumResultCopyWith<$R, FCSubscribeForumResult, $Out> {
  _FCSubscribeForumResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSubscribeForumResult> $mapper =
      FCSubscribeForumResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCSubscribeForumResult $make(CopyWithData data) => FCSubscribeForumResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCSubscribeForumResultCopyWith<$R2, FCSubscribeForumResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCSubscribeForumResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUnsubscribeForumResultMapper
    extends ClassMapperBase<FCUnsubscribeForumResult> {
  FCUnsubscribeForumResultMapper._();

  static FCUnsubscribeForumResultMapper? _instance;
  static FCUnsubscribeForumResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCUnsubscribeForumResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUnsubscribeForumResult';

  static bool _$result(FCUnsubscribeForumResult v) => v.result;
  static const Field<FCUnsubscribeForumResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUnsubscribeForumResult v) => v.resultText;
  static const Field<FCUnsubscribeForumResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCUnsubscribeForumResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCUnsubscribeForumResult _instantiate(DecodingData data) {
    return FCUnsubscribeForumResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUnsubscribeForumResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUnsubscribeForumResult>(map);
  }

  static FCUnsubscribeForumResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUnsubscribeForumResult>(json);
  }
}

mixin FCUnsubscribeForumResultMappable {
  String toJson() {
    return FCUnsubscribeForumResultMapper.ensureInitialized()
        .encodeJson<FCUnsubscribeForumResult>(this as FCUnsubscribeForumResult);
  }

  Map<String, dynamic> toMap() {
    return FCUnsubscribeForumResultMapper.ensureInitialized()
        .encodeMap<FCUnsubscribeForumResult>(this as FCUnsubscribeForumResult);
  }

  FCUnsubscribeForumResultCopyWith<
    FCUnsubscribeForumResult,
    FCUnsubscribeForumResult,
    FCUnsubscribeForumResult
  >
  get copyWith =>
      _FCUnsubscribeForumResultCopyWithImpl<
        FCUnsubscribeForumResult,
        FCUnsubscribeForumResult
      >(this as FCUnsubscribeForumResult, $identity, $identity);
  @override
  String toString() {
    return FCUnsubscribeForumResultMapper.ensureInitialized().stringifyValue(
      this as FCUnsubscribeForumResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUnsubscribeForumResultMapper.ensureInitialized().equalsValue(
      this as FCUnsubscribeForumResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUnsubscribeForumResultMapper.ensureInitialized().hashValue(
      this as FCUnsubscribeForumResult,
    );
  }
}

extension FCUnsubscribeForumResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUnsubscribeForumResult, $Out> {
  FCUnsubscribeForumResultCopyWith<$R, FCUnsubscribeForumResult, $Out>
  get $asFCUnsubscribeForumResult => $base.as(
    (v, t, t2) => _FCUnsubscribeForumResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUnsubscribeForumResultCopyWith<
  $R,
  $In extends FCUnsubscribeForumResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCUnsubscribeForumResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUnsubscribeForumResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUnsubscribeForumResult, $Out>
    implements
        FCUnsubscribeForumResultCopyWith<$R, FCUnsubscribeForumResult, $Out> {
  _FCUnsubscribeForumResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUnsubscribeForumResult> $mapper =
      FCUnsubscribeForumResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCUnsubscribeForumResult $make(CopyWithData data) => FCUnsubscribeForumResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCUnsubscribeForumResultCopyWith<$R2, FCUnsubscribeForumResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCUnsubscribeForumResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCSubscribedTopicResultMapper
    extends ClassMapperBase<FCSubscribedTopicResult> {
  FCSubscribedTopicResultMapper._();

  static FCSubscribedTopicResultMapper? _instance;
  static FCSubscribedTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCSubscribedTopicResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
      FCSubscribedTopicMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSubscribedTopicResult';

  static bool _$result(FCSubscribedTopicResult v) => v.result;
  static const Field<FCSubscribedTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSubscribedTopicResult v) => v.resultText;
  static const Field<FCSubscribedTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalTopicNum(FCSubscribedTopicResult v) => v.totalTopicNum;
  static const Field<FCSubscribedTopicResult, int> _f$totalTopicNum = Field(
    'totalTopicNum',
    _$totalTopicNum,
    opt: true,
    def: 0,
  );
  static List<FCSubscribedTopic> _$topics(FCSubscribedTopicResult v) =>
      v.topics;
  static const Field<FCSubscribedTopicResult, List<FCSubscribedTopic>>
  _f$topics = Field('topics', _$topics, opt: true, def: const []);

  @override
  final MappableFields<FCSubscribedTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalTopicNum: _f$totalTopicNum,
    #topics: _f$topics,
  };

  static FCSubscribedTopicResult _instantiate(DecodingData data) {
    return FCSubscribedTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalTopicNum: data.dec(_f$totalTopicNum),
      topics: data.dec(_f$topics),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSubscribedTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSubscribedTopicResult>(map);
  }

  static FCSubscribedTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCSubscribedTopicResult>(json);
  }
}

mixin FCSubscribedTopicResultMappable {
  String toJson() {
    return FCSubscribedTopicResultMapper.ensureInitialized()
        .encodeJson<FCSubscribedTopicResult>(this as FCSubscribedTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCSubscribedTopicResultMapper.ensureInitialized()
        .encodeMap<FCSubscribedTopicResult>(this as FCSubscribedTopicResult);
  }

  FCSubscribedTopicResultCopyWith<
    FCSubscribedTopicResult,
    FCSubscribedTopicResult,
    FCSubscribedTopicResult
  >
  get copyWith =>
      _FCSubscribedTopicResultCopyWithImpl<
        FCSubscribedTopicResult,
        FCSubscribedTopicResult
      >(this as FCSubscribedTopicResult, $identity, $identity);
  @override
  String toString() {
    return FCSubscribedTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCSubscribedTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSubscribedTopicResultMapper.ensureInitialized().equalsValue(
      this as FCSubscribedTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSubscribedTopicResultMapper.ensureInitialized().hashValue(
      this as FCSubscribedTopicResult,
    );
  }
}

extension FCSubscribedTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSubscribedTopicResult, $Out> {
  FCSubscribedTopicResultCopyWith<$R, FCSubscribedTopicResult, $Out>
  get $asFCSubscribedTopicResult => $base.as(
    (v, t, t2) => _FCSubscribedTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSubscribedTopicResultCopyWith<
  $R,
  $In extends FCSubscribedTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCSubscribedTopic,
    FCSubscribedTopicCopyWith<$R, FCSubscribedTopic, FCSubscribedTopic>
  >
  get topics;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalTopicNum,
    List<FCSubscribedTopic>? topics,
  });
  FCSubscribedTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSubscribedTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSubscribedTopicResult, $Out>
    implements
        FCSubscribedTopicResultCopyWith<$R, FCSubscribedTopicResult, $Out> {
  _FCSubscribedTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSubscribedTopicResult> $mapper =
      FCSubscribedTopicResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCSubscribedTopic,
    FCSubscribedTopicCopyWith<$R, FCSubscribedTopic, FCSubscribedTopic>
  >
  get topics => ListCopyWith(
    $value.topics,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(topics: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? totalTopicNum,
    List<FCSubscribedTopic>? topics,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalTopicNum != null) #totalTopicNum: totalTopicNum,
      if (topics != null) #topics: topics,
    }),
  );
  @override
  FCSubscribedTopicResult $make(CopyWithData data) => FCSubscribedTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalTopicNum: data.get(#totalTopicNum, or: $value.totalTopicNum),
    topics: data.get(#topics, or: $value.topics),
  );

  @override
  FCSubscribedTopicResultCopyWith<$R2, FCSubscribedTopicResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCSubscribedTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCSubscribedTopicMapper extends ClassMapperBase<FCSubscribedTopic> {
  FCSubscribedTopicMapper._();

  static FCSubscribedTopicMapper? _instance;
  static FCSubscribedTopicMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSubscribedTopicMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCSubscribedTopic';

  static String _$forumId(FCSubscribedTopic v) => v.forumId;
  static const Field<FCSubscribedTopic, String> _f$forumId = Field(
    'forumId',
    _$forumId,
  );
  static String _$forumName(FCSubscribedTopic v) => v.forumName;
  static const Field<FCSubscribedTopic, String> _f$forumName = Field(
    'forumName',
    _$forumName,
  );
  static String _$topicId(FCSubscribedTopic v) => v.topicId;
  static const Field<FCSubscribedTopic, String> _f$topicId = Field(
    'topicId',
    _$topicId,
  );
  static String _$topicTitle(FCSubscribedTopic v) => v.topicTitle;
  static const Field<FCSubscribedTopic, String> _f$topicTitle = Field(
    'topicTitle',
    _$topicTitle,
  );
  static String _$postAuthorName(FCSubscribedTopic v) => v.postAuthorName;
  static const Field<FCSubscribedTopic, String> _f$postAuthorName = Field(
    'postAuthorName',
    _$postAuthorName,
  );
  static String? _$postAuthorUserType(FCSubscribedTopic v) =>
      v.postAuthorUserType;
  static const Field<FCSubscribedTopic, String> _f$postAuthorUserType = Field(
    'postAuthorUserType',
    _$postAuthorUserType,
    opt: true,
  );
  static String _$postAuthorId(FCSubscribedTopic v) => v.postAuthorId;
  static const Field<FCSubscribedTopic, String> _f$postAuthorId = Field(
    'postAuthorId',
    _$postAuthorId,
  );
  static bool _$isClosed(FCSubscribedTopic v) => v.isClosed;
  static const Field<FCSubscribedTopic, bool> _f$isClosed = Field(
    'isClosed',
    _$isClosed,
    opt: true,
    def: false,
  );
  static String? _$iconUrl(FCSubscribedTopic v) => v.iconUrl;
  static const Field<FCSubscribedTopic, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static DateTime _$postTime(FCSubscribedTopic v) => v.postTime;
  static const Field<FCSubscribedTopic, DateTime> _f$postTime = Field(
    'postTime',
    _$postTime,
  );
  static String? _$timestamp(FCSubscribedTopic v) => v.timestamp;
  static const Field<FCSubscribedTopic, String> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
    opt: true,
  );
  static int _$replyNumber(FCSubscribedTopic v) => v.replyNumber;
  static const Field<FCSubscribedTopic, int> _f$replyNumber = Field(
    'replyNumber',
    _$replyNumber,
    opt: true,
    def: 0,
  );
  static bool _$newPost(FCSubscribedTopic v) => v.newPost;
  static const Field<FCSubscribedTopic, bool> _f$newPost = Field(
    'newPost',
    _$newPost,
    opt: true,
    def: false,
  );
  static int _$subscribeMode(FCSubscribedTopic v) => v.subscribeMode;
  static const Field<FCSubscribedTopic, int> _f$subscribeMode = Field(
    'subscribeMode',
    _$subscribeMode,
    opt: true,
    def: 0,
  );
  static int _$viewNumber(FCSubscribedTopic v) => v.viewNumber;
  static const Field<FCSubscribedTopic, int> _f$viewNumber = Field(
    'viewNumber',
    _$viewNumber,
    opt: true,
    def: 0,
  );
  static String? _$shortContent(FCSubscribedTopic v) => v.shortContent;
  static const Field<FCSubscribedTopic, String> _f$shortContent = Field(
    'shortContent',
    _$shortContent,
    opt: true,
  );
  static bool _$isSticky(FCSubscribedTopic v) => v.isSticky;
  static const Field<FCSubscribedTopic, bool> _f$isSticky = Field(
    'isSticky',
    _$isSticky,
    opt: true,
    def: false,
  );
  static bool _$isAnnouncement(FCSubscribedTopic v) => v.isAnnouncement;
  static const Field<FCSubscribedTopic, bool> _f$isAnnouncement = Field(
    'isAnnouncement',
    _$isAnnouncement,
    opt: true,
    def: false,
  );
  static bool _$isGlobalAnnouncement(FCSubscribedTopic v) =>
      v.isGlobalAnnouncement;
  static const Field<FCSubscribedTopic, bool> _f$isGlobalAnnouncement = Field(
    'isGlobalAnnouncement',
    _$isGlobalAnnouncement,
    opt: true,
    def: false,
  );
  static bool _$isLocked(FCSubscribedTopic v) => v.isLocked;
  static const Field<FCSubscribedTopic, bool> _f$isLocked = Field(
    'isLocked',
    _$isLocked,
    opt: true,
    def: false,
  );
  static bool _$isMoved(FCSubscribedTopic v) => v.isMoved;
  static const Field<FCSubscribedTopic, bool> _f$isMoved = Field(
    'isMoved',
    _$isMoved,
    opt: true,
    def: false,
  );
  static bool _$isPoll(FCSubscribedTopic v) => v.isPoll;
  static const Field<FCSubscribedTopic, bool> _f$isPoll = Field(
    'isPoll',
    _$isPoll,
    opt: true,
    def: false,
  );
  static bool _$isVoted(FCSubscribedTopic v) => v.isVoted;
  static const Field<FCSubscribedTopic, bool> _f$isVoted = Field(
    'isVoted',
    _$isVoted,
    opt: true,
    def: false,
  );
  static bool _$isHot(FCSubscribedTopic v) => v.isHot;
  static const Field<FCSubscribedTopic, bool> _f$isHot = Field(
    'isHot',
    _$isHot,
    opt: true,
    def: false,
  );
  static bool _$isSolved(FCSubscribedTopic v) => v.isSolved;
  static const Field<FCSubscribedTopic, bool> _f$isSolved = Field(
    'isSolved',
    _$isSolved,
    opt: true,
    def: false,
  );
  static bool _$isUnsolved(FCSubscribedTopic v) => v.isUnsolved;
  static const Field<FCSubscribedTopic, bool> _f$isUnsolved = Field(
    'isUnsolved',
    _$isUnsolved,
    opt: true,
    def: false,
  );
  static bool _$isDeleted(FCSubscribedTopic v) => v.isDeleted;
  static const Field<FCSubscribedTopic, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    opt: true,
    def: false,
  );
  static bool _$isApproved(FCSubscribedTopic v) => v.isApproved;
  static const Field<FCSubscribedTopic, bool> _f$isApproved = Field(
    'isApproved',
    _$isApproved,
    opt: true,
    def: false,
  );
  static bool _$isUnapproved(FCSubscribedTopic v) => v.isUnapproved;
  static const Field<FCSubscribedTopic, bool> _f$isUnapproved = Field(
    'isUnapproved',
    _$isUnapproved,
    opt: true,
    def: false,
  );
  static bool _$isMerged(FCSubscribedTopic v) => v.isMerged;
  static const Field<FCSubscribedTopic, bool> _f$isMerged = Field(
    'isMerged',
    _$isMerged,
    opt: true,
    def: false,
  );
  static bool _$isSplit(FCSubscribedTopic v) => v.isSplit;
  static const Field<FCSubscribedTopic, bool> _f$isSplit = Field(
    'isSplit',
    _$isSplit,
    opt: true,
    def: false,
  );
  static bool _$isMovedToTrash(FCSubscribedTopic v) => v.isMovedToTrash;
  static const Field<FCSubscribedTopic, bool> _f$isMovedToTrash = Field(
    'isMovedToTrash',
    _$isMovedToTrash,
    opt: true,
    def: false,
  );
  static bool _$isRestoredFromTrash(FCSubscribedTopic v) =>
      v.isRestoredFromTrash;
  static const Field<FCSubscribedTopic, bool> _f$isRestoredFromTrash = Field(
    'isRestoredFromTrash',
    _$isRestoredFromTrash,
    opt: true,
    def: false,
  );
  static bool _$isPinned(FCSubscribedTopic v) => v.isPinned;
  static const Field<FCSubscribedTopic, bool> _f$isPinned = Field(
    'isPinned',
    _$isPinned,
    opt: true,
    def: false,
  );
  static bool _$isUnpinned(FCSubscribedTopic v) => v.isUnpinned;
  static const Field<FCSubscribedTopic, bool> _f$isUnpinned = Field(
    'isUnpinned',
    _$isUnpinned,
    opt: true,
    def: false,
  );
  static bool _$isFeatured(FCSubscribedTopic v) => v.isFeatured;
  static const Field<FCSubscribedTopic, bool> _f$isFeatured = Field(
    'isFeatured',
    _$isFeatured,
    opt: true,
    def: false,
  );
  static bool _$isUnfeatured(FCSubscribedTopic v) => v.isUnfeatured;
  static const Field<FCSubscribedTopic, bool> _f$isUnfeatured = Field(
    'isUnfeatured',
    _$isUnfeatured,
    opt: true,
    def: false,
  );
  static bool _$isHighlighted(FCSubscribedTopic v) => v.isHighlighted;
  static const Field<FCSubscribedTopic, bool> _f$isHighlighted = Field(
    'isHighlighted',
    _$isHighlighted,
    opt: true,
    def: false,
  );
  static bool _$isUnhighlighted(FCSubscribedTopic v) => v.isUnhighlighted;
  static const Field<FCSubscribedTopic, bool> _f$isUnhighlighted = Field(
    'isUnhighlighted',
    _$isUnhighlighted,
    opt: true,
    def: false,
  );
  static bool _$isBookmarked(FCSubscribedTopic v) => v.isBookmarked;
  static const Field<FCSubscribedTopic, bool> _f$isBookmarked = Field(
    'isBookmarked',
    _$isBookmarked,
    opt: true,
    def: false,
  );
  static bool _$isUnbookmarked(FCSubscribedTopic v) => v.isUnbookmarked;
  static const Field<FCSubscribedTopic, bool> _f$isUnbookmarked = Field(
    'isUnbookmarked',
    _$isUnbookmarked,
    opt: true,
    def: false,
  );
  static bool _$isSubscribed(FCSubscribedTopic v) => v.isSubscribed;
  static const Field<FCSubscribedTopic, bool> _f$isSubscribed = Field(
    'isSubscribed',
    _$isSubscribed,
    opt: true,
    def: false,
  );
  static bool _$isUnsubscribed(FCSubscribedTopic v) => v.isUnsubscribed;
  static const Field<FCSubscribedTopic, bool> _f$isUnsubscribed = Field(
    'isUnsubscribed',
    _$isUnsubscribed,
    opt: true,
    def: false,
  );
  static bool _$isLiked(FCSubscribedTopic v) => v.isLiked;
  static const Field<FCSubscribedTopic, bool> _f$isLiked = Field(
    'isLiked',
    _$isLiked,
    opt: true,
    def: false,
  );
  static bool _$isUnliked(FCSubscribedTopic v) => v.isUnliked;
  static const Field<FCSubscribedTopic, bool> _f$isUnliked = Field(
    'isUnliked',
    _$isUnliked,
    opt: true,
    def: false,
  );
  static bool _$isThanked(FCSubscribedTopic v) => v.isThanked;
  static const Field<FCSubscribedTopic, bool> _f$isThanked = Field(
    'isThanked',
    _$isThanked,
    opt: true,
    def: false,
  );
  static bool _$isUnthanked(FCSubscribedTopic v) => v.isUnthanked;
  static const Field<FCSubscribedTopic, bool> _f$isUnthanked = Field(
    'isUnthanked',
    _$isUnthanked,
    opt: true,
    def: false,
  );
  static bool _$isReported(FCSubscribedTopic v) => v.isReported;
  static const Field<FCSubscribedTopic, bool> _f$isReported = Field(
    'isReported',
    _$isReported,
    opt: true,
    def: false,
  );
  static bool _$isUnreported(FCSubscribedTopic v) => v.isUnreported;
  static const Field<FCSubscribedTopic, bool> _f$isUnreported = Field(
    'isUnreported',
    _$isUnreported,
    opt: true,
    def: false,
  );
  static bool _$isHidden(FCSubscribedTopic v) => v.isHidden;
  static const Field<FCSubscribedTopic, bool> _f$isHidden = Field(
    'isHidden',
    _$isHidden,
    opt: true,
    def: false,
  );
  static bool _$isUnhidden(FCSubscribedTopic v) => v.isUnhidden;
  static const Field<FCSubscribedTopic, bool> _f$isUnhidden = Field(
    'isUnhidden',
    _$isUnhidden,
    opt: true,
    def: false,
  );
  static bool _$isArchived(FCSubscribedTopic v) => v.isArchived;
  static const Field<FCSubscribedTopic, bool> _f$isArchived = Field(
    'isArchived',
    _$isArchived,
    opt: true,
    def: false,
  );
  static bool _$isUnarchived(FCSubscribedTopic v) => v.isUnarchived;
  static const Field<FCSubscribedTopic, bool> _f$isUnarchived = Field(
    'isUnarchived',
    _$isUnarchived,
    opt: true,
    def: false,
  );
  static bool _$isLockedForEditing(FCSubscribedTopic v) => v.isLockedForEditing;
  static const Field<FCSubscribedTopic, bool> _f$isLockedForEditing = Field(
    'isLockedForEditing',
    _$isLockedForEditing,
    opt: true,
    def: false,
  );
  static bool _$isUnlockedForEditing(FCSubscribedTopic v) =>
      v.isUnlockedForEditing;
  static const Field<FCSubscribedTopic, bool> _f$isUnlockedForEditing = Field(
    'isUnlockedForEditing',
    _$isUnlockedForEditing,
    opt: true,
    def: false,
  );
  static bool _$isLockedForReplies(FCSubscribedTopic v) => v.isLockedForReplies;
  static const Field<FCSubscribedTopic, bool> _f$isLockedForReplies = Field(
    'isLockedForReplies',
    _$isLockedForReplies,
    opt: true,
    def: false,
  );
  static bool _$isUnlockedForReplies(FCSubscribedTopic v) =>
      v.isUnlockedForReplies;
  static const Field<FCSubscribedTopic, bool> _f$isUnlockedForReplies = Field(
    'isUnlockedForReplies',
    _$isUnlockedForReplies,
    opt: true,
    def: false,
  );
  static bool _$isLockedForVoting(FCSubscribedTopic v) => v.isLockedForVoting;
  static const Field<FCSubscribedTopic, bool> _f$isLockedForVoting = Field(
    'isLockedForVoting',
    _$isLockedForVoting,
    opt: true,
    def: false,
  );
  static bool _$isUnlockedForVoting(FCSubscribedTopic v) =>
      v.isUnlockedForVoting;
  static const Field<FCSubscribedTopic, bool> _f$isUnlockedForVoting = Field(
    'isUnlockedForVoting',
    _$isUnlockedForVoting,
    opt: true,
    def: false,
  );
  static bool _$isLockedForRating(FCSubscribedTopic v) => v.isLockedForRating;
  static const Field<FCSubscribedTopic, bool> _f$isLockedForRating = Field(
    'isLockedForRating',
    _$isLockedForRating,
    opt: true,
    def: false,
  );
  static bool _$isUnlockedForRating(FCSubscribedTopic v) =>
      v.isUnlockedForRating;
  static const Field<FCSubscribedTopic, bool> _f$isUnlockedForRating = Field(
    'isUnlockedForRating',
    _$isUnlockedForRating,
    opt: true,
    def: false,
  );
  static bool _$isLockedForBookmarking(FCSubscribedTopic v) =>
      v.isLockedForBookmarking;
  static const Field<FCSubscribedTopic, bool> _f$isLockedForBookmarking = Field(
    'isLockedForBookmarking',
    _$isLockedForBookmarking,
    opt: true,
    def: false,
  );
  static bool _$isUnlockedForBookmarking(FCSubscribedTopic v) =>
      v.isUnlockedForBookmarking;
  static const Field<FCSubscribedTopic, bool> _f$isUnlockedForBookmarking =
      Field(
        'isUnlockedForBookmarking',
        _$isUnlockedForBookmarking,
        opt: true,
        def: false,
      );
  static bool _$isLockedForSubscription(FCSubscribedTopic v) =>
      v.isLockedForSubscription;
  static const Field<FCSubscribedTopic, bool> _f$isLockedForSubscription =
      Field(
        'isLockedForSubscription',
        _$isLockedForSubscription,
        opt: true,
        def: false,
      );
  static bool _$isUnlockedForSubscription(FCSubscribedTopic v) =>
      v.isUnlockedForSubscription;
  static const Field<FCSubscribedTopic, bool> _f$isUnlockedForSubscription =
      Field(
        'isUnlockedForSubscription',
        _$isUnlockedForSubscription,
        opt: true,
        def: false,
      );
  static bool _$isLockedForLiking(FCSubscribedTopic v) => v.isLockedForLiking;
  static const Field<FCSubscribedTopic, bool> _f$isLockedForLiking = Field(
    'isLockedForLiking',
    _$isLockedForLiking,
    opt: true,
    def: false,
  );
  static bool _$isUnlockedForLiking(FCSubscribedTopic v) =>
      v.isUnlockedForLiking;
  static const Field<FCSubscribedTopic, bool> _f$isUnlockedForLiking = Field(
    'isUnlockedForLiking',
    _$isUnlockedForLiking,
    opt: true,
    def: false,
  );
  static bool _$isLockedForThanking(FCSubscribedTopic v) =>
      v.isLockedForThanking;
  static const Field<FCSubscribedTopic, bool> _f$isLockedForThanking = Field(
    'isLockedForThanking',
    _$isLockedForThanking,
    opt: true,
    def: false,
  );
  static bool _$isUnlockedForThanking(FCSubscribedTopic v) =>
      v.isUnlockedForThanking;
  static const Field<FCSubscribedTopic, bool> _f$isUnlockedForThanking = Field(
    'isUnlockedForThanking',
    _$isUnlockedForThanking,
    opt: true,
    def: false,
  );
  static bool _$isLockedForReporting(FCSubscribedTopic v) =>
      v.isLockedForReporting;
  static const Field<FCSubscribedTopic, bool> _f$isLockedForReporting = Field(
    'isLockedForReporting',
    _$isLockedForReporting,
    opt: true,
    def: false,
  );
  static bool _$isUnlockedForReporting(FCSubscribedTopic v) =>
      v.isUnlockedForReporting;
  static const Field<FCSubscribedTopic, bool> _f$isUnlockedForReporting = Field(
    'isUnlockedForReporting',
    _$isUnlockedForReporting,
    opt: true,
    def: false,
  );
  static bool _$isLockedForHiding(FCSubscribedTopic v) => v.isLockedForHiding;
  static const Field<FCSubscribedTopic, bool> _f$isLockedForHiding = Field(
    'isLockedForHiding',
    _$isLockedForHiding,
    opt: true,
    def: false,
  );
  static bool _$isUnlockedForHiding(FCSubscribedTopic v) =>
      v.isUnlockedForHiding;
  static const Field<FCSubscribedTopic, bool> _f$isUnlockedForHiding = Field(
    'isUnlockedForHiding',
    _$isUnlockedForHiding,
    opt: true,
    def: false,
  );
  static bool _$isLockedForArchiving(FCSubscribedTopic v) =>
      v.isLockedForArchiving;
  static const Field<FCSubscribedTopic, bool> _f$isLockedForArchiving = Field(
    'isLockedForArchiving',
    _$isLockedForArchiving,
    opt: true,
    def: false,
  );
  static bool _$isUnlockedForArchiving(FCSubscribedTopic v) =>
      v.isUnlockedForArchiving;
  static const Field<FCSubscribedTopic, bool> _f$isUnlockedForArchiving = Field(
    'isUnlockedForArchiving',
    _$isUnlockedForArchiving,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<FCSubscribedTopic> fields = const {
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #topicId: _f$topicId,
    #topicTitle: _f$topicTitle,
    #postAuthorName: _f$postAuthorName,
    #postAuthorUserType: _f$postAuthorUserType,
    #postAuthorId: _f$postAuthorId,
    #isClosed: _f$isClosed,
    #iconUrl: _f$iconUrl,
    #postTime: _f$postTime,
    #timestamp: _f$timestamp,
    #replyNumber: _f$replyNumber,
    #newPost: _f$newPost,
    #subscribeMode: _f$subscribeMode,
    #viewNumber: _f$viewNumber,
    #shortContent: _f$shortContent,
    #isSticky: _f$isSticky,
    #isAnnouncement: _f$isAnnouncement,
    #isGlobalAnnouncement: _f$isGlobalAnnouncement,
    #isLocked: _f$isLocked,
    #isMoved: _f$isMoved,
    #isPoll: _f$isPoll,
    #isVoted: _f$isVoted,
    #isHot: _f$isHot,
    #isSolved: _f$isSolved,
    #isUnsolved: _f$isUnsolved,
    #isDeleted: _f$isDeleted,
    #isApproved: _f$isApproved,
    #isUnapproved: _f$isUnapproved,
    #isMerged: _f$isMerged,
    #isSplit: _f$isSplit,
    #isMovedToTrash: _f$isMovedToTrash,
    #isRestoredFromTrash: _f$isRestoredFromTrash,
    #isPinned: _f$isPinned,
    #isUnpinned: _f$isUnpinned,
    #isFeatured: _f$isFeatured,
    #isUnfeatured: _f$isUnfeatured,
    #isHighlighted: _f$isHighlighted,
    #isUnhighlighted: _f$isUnhighlighted,
    #isBookmarked: _f$isBookmarked,
    #isUnbookmarked: _f$isUnbookmarked,
    #isSubscribed: _f$isSubscribed,
    #isUnsubscribed: _f$isUnsubscribed,
    #isLiked: _f$isLiked,
    #isUnliked: _f$isUnliked,
    #isThanked: _f$isThanked,
    #isUnthanked: _f$isUnthanked,
    #isReported: _f$isReported,
    #isUnreported: _f$isUnreported,
    #isHidden: _f$isHidden,
    #isUnhidden: _f$isUnhidden,
    #isArchived: _f$isArchived,
    #isUnarchived: _f$isUnarchived,
    #isLockedForEditing: _f$isLockedForEditing,
    #isUnlockedForEditing: _f$isUnlockedForEditing,
    #isLockedForReplies: _f$isLockedForReplies,
    #isUnlockedForReplies: _f$isUnlockedForReplies,
    #isLockedForVoting: _f$isLockedForVoting,
    #isUnlockedForVoting: _f$isUnlockedForVoting,
    #isLockedForRating: _f$isLockedForRating,
    #isUnlockedForRating: _f$isUnlockedForRating,
    #isLockedForBookmarking: _f$isLockedForBookmarking,
    #isUnlockedForBookmarking: _f$isUnlockedForBookmarking,
    #isLockedForSubscription: _f$isLockedForSubscription,
    #isUnlockedForSubscription: _f$isUnlockedForSubscription,
    #isLockedForLiking: _f$isLockedForLiking,
    #isUnlockedForLiking: _f$isUnlockedForLiking,
    #isLockedForThanking: _f$isLockedForThanking,
    #isUnlockedForThanking: _f$isUnlockedForThanking,
    #isLockedForReporting: _f$isLockedForReporting,
    #isUnlockedForReporting: _f$isUnlockedForReporting,
    #isLockedForHiding: _f$isLockedForHiding,
    #isUnlockedForHiding: _f$isUnlockedForHiding,
    #isLockedForArchiving: _f$isLockedForArchiving,
    #isUnlockedForArchiving: _f$isUnlockedForArchiving,
  };

  static FCSubscribedTopic _instantiate(DecodingData data) {
    return FCSubscribedTopic(
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      topicId: data.dec(_f$topicId),
      topicTitle: data.dec(_f$topicTitle),
      postAuthorName: data.dec(_f$postAuthorName),
      postAuthorUserType: data.dec(_f$postAuthorUserType),
      postAuthorId: data.dec(_f$postAuthorId),
      isClosed: data.dec(_f$isClosed),
      iconUrl: data.dec(_f$iconUrl),
      postTime: data.dec(_f$postTime),
      timestamp: data.dec(_f$timestamp),
      replyNumber: data.dec(_f$replyNumber),
      newPost: data.dec(_f$newPost),
      subscribeMode: data.dec(_f$subscribeMode),
      viewNumber: data.dec(_f$viewNumber),
      shortContent: data.dec(_f$shortContent),
      isSticky: data.dec(_f$isSticky),
      isAnnouncement: data.dec(_f$isAnnouncement),
      isGlobalAnnouncement: data.dec(_f$isGlobalAnnouncement),
      isLocked: data.dec(_f$isLocked),
      isMoved: data.dec(_f$isMoved),
      isPoll: data.dec(_f$isPoll),
      isVoted: data.dec(_f$isVoted),
      isHot: data.dec(_f$isHot),
      isSolved: data.dec(_f$isSolved),
      isUnsolved: data.dec(_f$isUnsolved),
      isDeleted: data.dec(_f$isDeleted),
      isApproved: data.dec(_f$isApproved),
      isUnapproved: data.dec(_f$isUnapproved),
      isMerged: data.dec(_f$isMerged),
      isSplit: data.dec(_f$isSplit),
      isMovedToTrash: data.dec(_f$isMovedToTrash),
      isRestoredFromTrash: data.dec(_f$isRestoredFromTrash),
      isPinned: data.dec(_f$isPinned),
      isUnpinned: data.dec(_f$isUnpinned),
      isFeatured: data.dec(_f$isFeatured),
      isUnfeatured: data.dec(_f$isUnfeatured),
      isHighlighted: data.dec(_f$isHighlighted),
      isUnhighlighted: data.dec(_f$isUnhighlighted),
      isBookmarked: data.dec(_f$isBookmarked),
      isUnbookmarked: data.dec(_f$isUnbookmarked),
      isSubscribed: data.dec(_f$isSubscribed),
      isUnsubscribed: data.dec(_f$isUnsubscribed),
      isLiked: data.dec(_f$isLiked),
      isUnliked: data.dec(_f$isUnliked),
      isThanked: data.dec(_f$isThanked),
      isUnthanked: data.dec(_f$isUnthanked),
      isReported: data.dec(_f$isReported),
      isUnreported: data.dec(_f$isUnreported),
      isHidden: data.dec(_f$isHidden),
      isUnhidden: data.dec(_f$isUnhidden),
      isArchived: data.dec(_f$isArchived),
      isUnarchived: data.dec(_f$isUnarchived),
      isLockedForEditing: data.dec(_f$isLockedForEditing),
      isUnlockedForEditing: data.dec(_f$isUnlockedForEditing),
      isLockedForReplies: data.dec(_f$isLockedForReplies),
      isUnlockedForReplies: data.dec(_f$isUnlockedForReplies),
      isLockedForVoting: data.dec(_f$isLockedForVoting),
      isUnlockedForVoting: data.dec(_f$isUnlockedForVoting),
      isLockedForRating: data.dec(_f$isLockedForRating),
      isUnlockedForRating: data.dec(_f$isUnlockedForRating),
      isLockedForBookmarking: data.dec(_f$isLockedForBookmarking),
      isUnlockedForBookmarking: data.dec(_f$isUnlockedForBookmarking),
      isLockedForSubscription: data.dec(_f$isLockedForSubscription),
      isUnlockedForSubscription: data.dec(_f$isUnlockedForSubscription),
      isLockedForLiking: data.dec(_f$isLockedForLiking),
      isUnlockedForLiking: data.dec(_f$isUnlockedForLiking),
      isLockedForThanking: data.dec(_f$isLockedForThanking),
      isUnlockedForThanking: data.dec(_f$isUnlockedForThanking),
      isLockedForReporting: data.dec(_f$isLockedForReporting),
      isUnlockedForReporting: data.dec(_f$isUnlockedForReporting),
      isLockedForHiding: data.dec(_f$isLockedForHiding),
      isUnlockedForHiding: data.dec(_f$isUnlockedForHiding),
      isLockedForArchiving: data.dec(_f$isLockedForArchiving),
      isUnlockedForArchiving: data.dec(_f$isUnlockedForArchiving),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSubscribedTopic fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSubscribedTopic>(map);
  }

  static FCSubscribedTopic fromJson(String json) {
    return ensureInitialized().decodeJson<FCSubscribedTopic>(json);
  }
}

mixin FCSubscribedTopicMappable {
  String toJson() {
    return FCSubscribedTopicMapper.ensureInitialized()
        .encodeJson<FCSubscribedTopic>(this as FCSubscribedTopic);
  }

  Map<String, dynamic> toMap() {
    return FCSubscribedTopicMapper.ensureInitialized()
        .encodeMap<FCSubscribedTopic>(this as FCSubscribedTopic);
  }

  FCSubscribedTopicCopyWith<
    FCSubscribedTopic,
    FCSubscribedTopic,
    FCSubscribedTopic
  >
  get copyWith =>
      _FCSubscribedTopicCopyWithImpl<FCSubscribedTopic, FCSubscribedTopic>(
        this as FCSubscribedTopic,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCSubscribedTopicMapper.ensureInitialized().stringifyValue(
      this as FCSubscribedTopic,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSubscribedTopicMapper.ensureInitialized().equalsValue(
      this as FCSubscribedTopic,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSubscribedTopicMapper.ensureInitialized().hashValue(
      this as FCSubscribedTopic,
    );
  }
}

extension FCSubscribedTopicValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSubscribedTopic, $Out> {
  FCSubscribedTopicCopyWith<$R, FCSubscribedTopic, $Out>
  get $asFCSubscribedTopic => $base.as(
    (v, t, t2) => _FCSubscribedTopicCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSubscribedTopicCopyWith<
  $R,
  $In extends FCSubscribedTopic,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? forumId,
    String? forumName,
    String? topicId,
    String? topicTitle,
    String? postAuthorName,
    String? postAuthorUserType,
    String? postAuthorId,
    bool? isClosed,
    String? iconUrl,
    DateTime? postTime,
    String? timestamp,
    int? replyNumber,
    bool? newPost,
    int? subscribeMode,
    int? viewNumber,
    String? shortContent,
    bool? isSticky,
    bool? isAnnouncement,
    bool? isGlobalAnnouncement,
    bool? isLocked,
    bool? isMoved,
    bool? isPoll,
    bool? isVoted,
    bool? isHot,
    bool? isSolved,
    bool? isUnsolved,
    bool? isDeleted,
    bool? isApproved,
    bool? isUnapproved,
    bool? isMerged,
    bool? isSplit,
    bool? isMovedToTrash,
    bool? isRestoredFromTrash,
    bool? isPinned,
    bool? isUnpinned,
    bool? isFeatured,
    bool? isUnfeatured,
    bool? isHighlighted,
    bool? isUnhighlighted,
    bool? isBookmarked,
    bool? isUnbookmarked,
    bool? isSubscribed,
    bool? isUnsubscribed,
    bool? isLiked,
    bool? isUnliked,
    bool? isThanked,
    bool? isUnthanked,
    bool? isReported,
    bool? isUnreported,
    bool? isHidden,
    bool? isUnhidden,
    bool? isArchived,
    bool? isUnarchived,
    bool? isLockedForEditing,
    bool? isUnlockedForEditing,
    bool? isLockedForReplies,
    bool? isUnlockedForReplies,
    bool? isLockedForVoting,
    bool? isUnlockedForVoting,
    bool? isLockedForRating,
    bool? isUnlockedForRating,
    bool? isLockedForBookmarking,
    bool? isUnlockedForBookmarking,
    bool? isLockedForSubscription,
    bool? isUnlockedForSubscription,
    bool? isLockedForLiking,
    bool? isUnlockedForLiking,
    bool? isLockedForThanking,
    bool? isUnlockedForThanking,
    bool? isLockedForReporting,
    bool? isUnlockedForReporting,
    bool? isLockedForHiding,
    bool? isUnlockedForHiding,
    bool? isLockedForArchiving,
    bool? isUnlockedForArchiving,
  });
  FCSubscribedTopicCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSubscribedTopicCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSubscribedTopic, $Out>
    implements FCSubscribedTopicCopyWith<$R, FCSubscribedTopic, $Out> {
  _FCSubscribedTopicCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSubscribedTopic> $mapper =
      FCSubscribedTopicMapper.ensureInitialized();
  @override
  $R call({
    String? forumId,
    String? forumName,
    String? topicId,
    String? topicTitle,
    String? postAuthorName,
    Object? postAuthorUserType = $none,
    String? postAuthorId,
    bool? isClosed,
    Object? iconUrl = $none,
    DateTime? postTime,
    Object? timestamp = $none,
    int? replyNumber,
    bool? newPost,
    int? subscribeMode,
    int? viewNumber,
    Object? shortContent = $none,
    bool? isSticky,
    bool? isAnnouncement,
    bool? isGlobalAnnouncement,
    bool? isLocked,
    bool? isMoved,
    bool? isPoll,
    bool? isVoted,
    bool? isHot,
    bool? isSolved,
    bool? isUnsolved,
    bool? isDeleted,
    bool? isApproved,
    bool? isUnapproved,
    bool? isMerged,
    bool? isSplit,
    bool? isMovedToTrash,
    bool? isRestoredFromTrash,
    bool? isPinned,
    bool? isUnpinned,
    bool? isFeatured,
    bool? isUnfeatured,
    bool? isHighlighted,
    bool? isUnhighlighted,
    bool? isBookmarked,
    bool? isUnbookmarked,
    bool? isSubscribed,
    bool? isUnsubscribed,
    bool? isLiked,
    bool? isUnliked,
    bool? isThanked,
    bool? isUnthanked,
    bool? isReported,
    bool? isUnreported,
    bool? isHidden,
    bool? isUnhidden,
    bool? isArchived,
    bool? isUnarchived,
    bool? isLockedForEditing,
    bool? isUnlockedForEditing,
    bool? isLockedForReplies,
    bool? isUnlockedForReplies,
    bool? isLockedForVoting,
    bool? isUnlockedForVoting,
    bool? isLockedForRating,
    bool? isUnlockedForRating,
    bool? isLockedForBookmarking,
    bool? isUnlockedForBookmarking,
    bool? isLockedForSubscription,
    bool? isUnlockedForSubscription,
    bool? isLockedForLiking,
    bool? isUnlockedForLiking,
    bool? isLockedForThanking,
    bool? isUnlockedForThanking,
    bool? isLockedForReporting,
    bool? isUnlockedForReporting,
    bool? isLockedForHiding,
    bool? isUnlockedForHiding,
    bool? isLockedForArchiving,
    bool? isUnlockedForArchiving,
  }) => $apply(
    FieldCopyWithData({
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (topicId != null) #topicId: topicId,
      if (topicTitle != null) #topicTitle: topicTitle,
      if (postAuthorName != null) #postAuthorName: postAuthorName,
      if (postAuthorUserType != $none) #postAuthorUserType: postAuthorUserType,
      if (postAuthorId != null) #postAuthorId: postAuthorId,
      if (isClosed != null) #isClosed: isClosed,
      if (iconUrl != $none) #iconUrl: iconUrl,
      if (postTime != null) #postTime: postTime,
      if (timestamp != $none) #timestamp: timestamp,
      if (replyNumber != null) #replyNumber: replyNumber,
      if (newPost != null) #newPost: newPost,
      if (subscribeMode != null) #subscribeMode: subscribeMode,
      if (viewNumber != null) #viewNumber: viewNumber,
      if (shortContent != $none) #shortContent: shortContent,
      if (isSticky != null) #isSticky: isSticky,
      if (isAnnouncement != null) #isAnnouncement: isAnnouncement,
      if (isGlobalAnnouncement != null)
        #isGlobalAnnouncement: isGlobalAnnouncement,
      if (isLocked != null) #isLocked: isLocked,
      if (isMoved != null) #isMoved: isMoved,
      if (isPoll != null) #isPoll: isPoll,
      if (isVoted != null) #isVoted: isVoted,
      if (isHot != null) #isHot: isHot,
      if (isSolved != null) #isSolved: isSolved,
      if (isUnsolved != null) #isUnsolved: isUnsolved,
      if (isDeleted != null) #isDeleted: isDeleted,
      if (isApproved != null) #isApproved: isApproved,
      if (isUnapproved != null) #isUnapproved: isUnapproved,
      if (isMerged != null) #isMerged: isMerged,
      if (isSplit != null) #isSplit: isSplit,
      if (isMovedToTrash != null) #isMovedToTrash: isMovedToTrash,
      if (isRestoredFromTrash != null)
        #isRestoredFromTrash: isRestoredFromTrash,
      if (isPinned != null) #isPinned: isPinned,
      if (isUnpinned != null) #isUnpinned: isUnpinned,
      if (isFeatured != null) #isFeatured: isFeatured,
      if (isUnfeatured != null) #isUnfeatured: isUnfeatured,
      if (isHighlighted != null) #isHighlighted: isHighlighted,
      if (isUnhighlighted != null) #isUnhighlighted: isUnhighlighted,
      if (isBookmarked != null) #isBookmarked: isBookmarked,
      if (isUnbookmarked != null) #isUnbookmarked: isUnbookmarked,
      if (isSubscribed != null) #isSubscribed: isSubscribed,
      if (isUnsubscribed != null) #isUnsubscribed: isUnsubscribed,
      if (isLiked != null) #isLiked: isLiked,
      if (isUnliked != null) #isUnliked: isUnliked,
      if (isThanked != null) #isThanked: isThanked,
      if (isUnthanked != null) #isUnthanked: isUnthanked,
      if (isReported != null) #isReported: isReported,
      if (isUnreported != null) #isUnreported: isUnreported,
      if (isHidden != null) #isHidden: isHidden,
      if (isUnhidden != null) #isUnhidden: isUnhidden,
      if (isArchived != null) #isArchived: isArchived,
      if (isUnarchived != null) #isUnarchived: isUnarchived,
      if (isLockedForEditing != null) #isLockedForEditing: isLockedForEditing,
      if (isUnlockedForEditing != null)
        #isUnlockedForEditing: isUnlockedForEditing,
      if (isLockedForReplies != null) #isLockedForReplies: isLockedForReplies,
      if (isUnlockedForReplies != null)
        #isUnlockedForReplies: isUnlockedForReplies,
      if (isLockedForVoting != null) #isLockedForVoting: isLockedForVoting,
      if (isUnlockedForVoting != null)
        #isUnlockedForVoting: isUnlockedForVoting,
      if (isLockedForRating != null) #isLockedForRating: isLockedForRating,
      if (isUnlockedForRating != null)
        #isUnlockedForRating: isUnlockedForRating,
      if (isLockedForBookmarking != null)
        #isLockedForBookmarking: isLockedForBookmarking,
      if (isUnlockedForBookmarking != null)
        #isUnlockedForBookmarking: isUnlockedForBookmarking,
      if (isLockedForSubscription != null)
        #isLockedForSubscription: isLockedForSubscription,
      if (isUnlockedForSubscription != null)
        #isUnlockedForSubscription: isUnlockedForSubscription,
      if (isLockedForLiking != null) #isLockedForLiking: isLockedForLiking,
      if (isUnlockedForLiking != null)
        #isUnlockedForLiking: isUnlockedForLiking,
      if (isLockedForThanking != null)
        #isLockedForThanking: isLockedForThanking,
      if (isUnlockedForThanking != null)
        #isUnlockedForThanking: isUnlockedForThanking,
      if (isLockedForReporting != null)
        #isLockedForReporting: isLockedForReporting,
      if (isUnlockedForReporting != null)
        #isUnlockedForReporting: isUnlockedForReporting,
      if (isLockedForHiding != null) #isLockedForHiding: isLockedForHiding,
      if (isUnlockedForHiding != null)
        #isUnlockedForHiding: isUnlockedForHiding,
      if (isLockedForArchiving != null)
        #isLockedForArchiving: isLockedForArchiving,
      if (isUnlockedForArchiving != null)
        #isUnlockedForArchiving: isUnlockedForArchiving,
    }),
  );
  @override
  FCSubscribedTopic $make(CopyWithData data) => FCSubscribedTopic(
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    topicId: data.get(#topicId, or: $value.topicId),
    topicTitle: data.get(#topicTitle, or: $value.topicTitle),
    postAuthorName: data.get(#postAuthorName, or: $value.postAuthorName),
    postAuthorUserType: data.get(
      #postAuthorUserType,
      or: $value.postAuthorUserType,
    ),
    postAuthorId: data.get(#postAuthorId, or: $value.postAuthorId),
    isClosed: data.get(#isClosed, or: $value.isClosed),
    iconUrl: data.get(#iconUrl, or: $value.iconUrl),
    postTime: data.get(#postTime, or: $value.postTime),
    timestamp: data.get(#timestamp, or: $value.timestamp),
    replyNumber: data.get(#replyNumber, or: $value.replyNumber),
    newPost: data.get(#newPost, or: $value.newPost),
    subscribeMode: data.get(#subscribeMode, or: $value.subscribeMode),
    viewNumber: data.get(#viewNumber, or: $value.viewNumber),
    shortContent: data.get(#shortContent, or: $value.shortContent),
    isSticky: data.get(#isSticky, or: $value.isSticky),
    isAnnouncement: data.get(#isAnnouncement, or: $value.isAnnouncement),
    isGlobalAnnouncement: data.get(
      #isGlobalAnnouncement,
      or: $value.isGlobalAnnouncement,
    ),
    isLocked: data.get(#isLocked, or: $value.isLocked),
    isMoved: data.get(#isMoved, or: $value.isMoved),
    isPoll: data.get(#isPoll, or: $value.isPoll),
    isVoted: data.get(#isVoted, or: $value.isVoted),
    isHot: data.get(#isHot, or: $value.isHot),
    isSolved: data.get(#isSolved, or: $value.isSolved),
    isUnsolved: data.get(#isUnsolved, or: $value.isUnsolved),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
    isApproved: data.get(#isApproved, or: $value.isApproved),
    isUnapproved: data.get(#isUnapproved, or: $value.isUnapproved),
    isMerged: data.get(#isMerged, or: $value.isMerged),
    isSplit: data.get(#isSplit, or: $value.isSplit),
    isMovedToTrash: data.get(#isMovedToTrash, or: $value.isMovedToTrash),
    isRestoredFromTrash: data.get(
      #isRestoredFromTrash,
      or: $value.isRestoredFromTrash,
    ),
    isPinned: data.get(#isPinned, or: $value.isPinned),
    isUnpinned: data.get(#isUnpinned, or: $value.isUnpinned),
    isFeatured: data.get(#isFeatured, or: $value.isFeatured),
    isUnfeatured: data.get(#isUnfeatured, or: $value.isUnfeatured),
    isHighlighted: data.get(#isHighlighted, or: $value.isHighlighted),
    isUnhighlighted: data.get(#isUnhighlighted, or: $value.isUnhighlighted),
    isBookmarked: data.get(#isBookmarked, or: $value.isBookmarked),
    isUnbookmarked: data.get(#isUnbookmarked, or: $value.isUnbookmarked),
    isSubscribed: data.get(#isSubscribed, or: $value.isSubscribed),
    isUnsubscribed: data.get(#isUnsubscribed, or: $value.isUnsubscribed),
    isLiked: data.get(#isLiked, or: $value.isLiked),
    isUnliked: data.get(#isUnliked, or: $value.isUnliked),
    isThanked: data.get(#isThanked, or: $value.isThanked),
    isUnthanked: data.get(#isUnthanked, or: $value.isUnthanked),
    isReported: data.get(#isReported, or: $value.isReported),
    isUnreported: data.get(#isUnreported, or: $value.isUnreported),
    isHidden: data.get(#isHidden, or: $value.isHidden),
    isUnhidden: data.get(#isUnhidden, or: $value.isUnhidden),
    isArchived: data.get(#isArchived, or: $value.isArchived),
    isUnarchived: data.get(#isUnarchived, or: $value.isUnarchived),
    isLockedForEditing: data.get(
      #isLockedForEditing,
      or: $value.isLockedForEditing,
    ),
    isUnlockedForEditing: data.get(
      #isUnlockedForEditing,
      or: $value.isUnlockedForEditing,
    ),
    isLockedForReplies: data.get(
      #isLockedForReplies,
      or: $value.isLockedForReplies,
    ),
    isUnlockedForReplies: data.get(
      #isUnlockedForReplies,
      or: $value.isUnlockedForReplies,
    ),
    isLockedForVoting: data.get(
      #isLockedForVoting,
      or: $value.isLockedForVoting,
    ),
    isUnlockedForVoting: data.get(
      #isUnlockedForVoting,
      or: $value.isUnlockedForVoting,
    ),
    isLockedForRating: data.get(
      #isLockedForRating,
      or: $value.isLockedForRating,
    ),
    isUnlockedForRating: data.get(
      #isUnlockedForRating,
      or: $value.isUnlockedForRating,
    ),
    isLockedForBookmarking: data.get(
      #isLockedForBookmarking,
      or: $value.isLockedForBookmarking,
    ),
    isUnlockedForBookmarking: data.get(
      #isUnlockedForBookmarking,
      or: $value.isUnlockedForBookmarking,
    ),
    isLockedForSubscription: data.get(
      #isLockedForSubscription,
      or: $value.isLockedForSubscription,
    ),
    isUnlockedForSubscription: data.get(
      #isUnlockedForSubscription,
      or: $value.isUnlockedForSubscription,
    ),
    isLockedForLiking: data.get(
      #isLockedForLiking,
      or: $value.isLockedForLiking,
    ),
    isUnlockedForLiking: data.get(
      #isUnlockedForLiking,
      or: $value.isUnlockedForLiking,
    ),
    isLockedForThanking: data.get(
      #isLockedForThanking,
      or: $value.isLockedForThanking,
    ),
    isUnlockedForThanking: data.get(
      #isUnlockedForThanking,
      or: $value.isUnlockedForThanking,
    ),
    isLockedForReporting: data.get(
      #isLockedForReporting,
      or: $value.isLockedForReporting,
    ),
    isUnlockedForReporting: data.get(
      #isUnlockedForReporting,
      or: $value.isUnlockedForReporting,
    ),
    isLockedForHiding: data.get(
      #isLockedForHiding,
      or: $value.isLockedForHiding,
    ),
    isUnlockedForHiding: data.get(
      #isUnlockedForHiding,
      or: $value.isUnlockedForHiding,
    ),
    isLockedForArchiving: data.get(
      #isLockedForArchiving,
      or: $value.isLockedForArchiving,
    ),
    isUnlockedForArchiving: data.get(
      #isUnlockedForArchiving,
      or: $value.isUnlockedForArchiving,
    ),
  );

  @override
  FCSubscribedTopicCopyWith<$R2, FCSubscribedTopic, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCSubscribedTopicCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCSubscribeTopicResultMapper
    extends ClassMapperBase<FCSubscribeTopicResult> {
  FCSubscribeTopicResultMapper._();

  static FCSubscribeTopicResultMapper? _instance;
  static FCSubscribeTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSubscribeTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSubscribeTopicResult';

  static bool _$result(FCSubscribeTopicResult v) => v.result;
  static const Field<FCSubscribeTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSubscribeTopicResult v) => v.resultText;
  static const Field<FCSubscribeTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCSubscribeTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCSubscribeTopicResult _instantiate(DecodingData data) {
    return FCSubscribeTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSubscribeTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSubscribeTopicResult>(map);
  }

  static FCSubscribeTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCSubscribeTopicResult>(json);
  }
}

mixin FCSubscribeTopicResultMappable {
  String toJson() {
    return FCSubscribeTopicResultMapper.ensureInitialized()
        .encodeJson<FCSubscribeTopicResult>(this as FCSubscribeTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCSubscribeTopicResultMapper.ensureInitialized()
        .encodeMap<FCSubscribeTopicResult>(this as FCSubscribeTopicResult);
  }

  FCSubscribeTopicResultCopyWith<
    FCSubscribeTopicResult,
    FCSubscribeTopicResult,
    FCSubscribeTopicResult
  >
  get copyWith =>
      _FCSubscribeTopicResultCopyWithImpl<
        FCSubscribeTopicResult,
        FCSubscribeTopicResult
      >(this as FCSubscribeTopicResult, $identity, $identity);
  @override
  String toString() {
    return FCSubscribeTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCSubscribeTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSubscribeTopicResultMapper.ensureInitialized().equalsValue(
      this as FCSubscribeTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSubscribeTopicResultMapper.ensureInitialized().hashValue(
      this as FCSubscribeTopicResult,
    );
  }
}

extension FCSubscribeTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSubscribeTopicResult, $Out> {
  FCSubscribeTopicResultCopyWith<$R, FCSubscribeTopicResult, $Out>
  get $asFCSubscribeTopicResult => $base.as(
    (v, t, t2) => _FCSubscribeTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSubscribeTopicResultCopyWith<
  $R,
  $In extends FCSubscribeTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCSubscribeTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSubscribeTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSubscribeTopicResult, $Out>
    implements
        FCSubscribeTopicResultCopyWith<$R, FCSubscribeTopicResult, $Out> {
  _FCSubscribeTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSubscribeTopicResult> $mapper =
      FCSubscribeTopicResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCSubscribeTopicResult $make(CopyWithData data) => FCSubscribeTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCSubscribeTopicResultCopyWith<$R2, FCSubscribeTopicResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCSubscribeTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUnsubscribeTopicResultMapper
    extends ClassMapperBase<FCUnsubscribeTopicResult> {
  FCUnsubscribeTopicResultMapper._();

  static FCUnsubscribeTopicResultMapper? _instance;
  static FCUnsubscribeTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCUnsubscribeTopicResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUnsubscribeTopicResult';

  static bool _$result(FCUnsubscribeTopicResult v) => v.result;
  static const Field<FCUnsubscribeTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUnsubscribeTopicResult v) => v.resultText;
  static const Field<FCUnsubscribeTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCUnsubscribeTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCUnsubscribeTopicResult _instantiate(DecodingData data) {
    return FCUnsubscribeTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUnsubscribeTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUnsubscribeTopicResult>(map);
  }

  static FCUnsubscribeTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUnsubscribeTopicResult>(json);
  }
}

mixin FCUnsubscribeTopicResultMappable {
  String toJson() {
    return FCUnsubscribeTopicResultMapper.ensureInitialized()
        .encodeJson<FCUnsubscribeTopicResult>(this as FCUnsubscribeTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCUnsubscribeTopicResultMapper.ensureInitialized()
        .encodeMap<FCUnsubscribeTopicResult>(this as FCUnsubscribeTopicResult);
  }

  FCUnsubscribeTopicResultCopyWith<
    FCUnsubscribeTopicResult,
    FCUnsubscribeTopicResult,
    FCUnsubscribeTopicResult
  >
  get copyWith =>
      _FCUnsubscribeTopicResultCopyWithImpl<
        FCUnsubscribeTopicResult,
        FCUnsubscribeTopicResult
      >(this as FCUnsubscribeTopicResult, $identity, $identity);
  @override
  String toString() {
    return FCUnsubscribeTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCUnsubscribeTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUnsubscribeTopicResultMapper.ensureInitialized().equalsValue(
      this as FCUnsubscribeTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUnsubscribeTopicResultMapper.ensureInitialized().hashValue(
      this as FCUnsubscribeTopicResult,
    );
  }
}

extension FCUnsubscribeTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUnsubscribeTopicResult, $Out> {
  FCUnsubscribeTopicResultCopyWith<$R, FCUnsubscribeTopicResult, $Out>
  get $asFCUnsubscribeTopicResult => $base.as(
    (v, t, t2) => _FCUnsubscribeTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUnsubscribeTopicResultCopyWith<
  $R,
  $In extends FCUnsubscribeTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCUnsubscribeTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUnsubscribeTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUnsubscribeTopicResult, $Out>
    implements
        FCUnsubscribeTopicResultCopyWith<$R, FCUnsubscribeTopicResult, $Out> {
  _FCUnsubscribeTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUnsubscribeTopicResult> $mapper =
      FCUnsubscribeTopicResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCUnsubscribeTopicResult $make(CopyWithData data) => FCUnsubscribeTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCUnsubscribeTopicResultCopyWith<$R2, FCUnsubscribeTopicResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCUnsubscribeTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

