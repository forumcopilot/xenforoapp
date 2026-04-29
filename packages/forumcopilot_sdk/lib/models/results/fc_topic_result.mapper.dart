// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_topic_result.dart';

class FCTopicDataResultMapper extends ClassMapperBase<FCTopicDataResult> {
  FCTopicDataResultMapper._();

  static FCTopicDataResultMapper? _instance;
  static FCTopicDataResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCTopicDataResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCPrefixMapper.ensureInitialized();
      FCTopicMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCTopicDataResult';

  static bool _$result(FCTopicDataResult v) => v.result;
  static const Field<FCTopicDataResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCTopicDataResult v) => v.resultText;
  static const Field<FCTopicDataResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
  );
  static int _$totalTopicNum(FCTopicDataResult v) => v.totalTopicNum;
  static const Field<FCTopicDataResult, int> _f$totalTopicNum = Field(
    'totalTopicNum',
    _$totalTopicNum,
  );
  static String _$forumId(FCTopicDataResult v) => v.forumId;
  static const Field<FCTopicDataResult, String> _f$forumId = Field(
    'forumId',
    _$forumId,
    opt: true,
    def: "",
  );
  static String _$forumName(FCTopicDataResult v) => v.forumName;
  static const Field<FCTopicDataResult, String> _f$forumName = Field(
    'forumName',
    _$forumName,
    opt: true,
    def: "",
  );
  static bool _$canPost(FCTopicDataResult v) => v.canPost;
  static const Field<FCTopicDataResult, bool> _f$canPost = Field(
    'canPost',
    _$canPost,
    opt: true,
    def: false,
  );
  static bool _$canUpload(FCTopicDataResult v) => v.canUpload;
  static const Field<FCTopicDataResult, bool> _f$canUpload = Field(
    'canUpload',
    _$canUpload,
    opt: true,
    def: false,
  );
  static int _$unreadStickyCount(FCTopicDataResult v) => v.unreadStickyCount;
  static const Field<FCTopicDataResult, int> _f$unreadStickyCount = Field(
    'unreadStickyCount',
    _$unreadStickyCount,
    opt: true,
    def: 0,
  );
  static int _$unreadAnnounceCount(FCTopicDataResult v) =>
      v.unreadAnnounceCount;
  static const Field<FCTopicDataResult, int> _f$unreadAnnounceCount = Field(
    'unreadAnnounceCount',
    _$unreadAnnounceCount,
    opt: true,
    def: 0,
  );
  static bool _$canSubscribe(FCTopicDataResult v) => v.canSubscribe;
  static const Field<FCTopicDataResult, bool> _f$canSubscribe = Field(
    'canSubscribe',
    _$canSubscribe,
    opt: true,
    def: false,
  );
  static bool _$isSubscribed(FCTopicDataResult v) => v.isSubscribed;
  static const Field<FCTopicDataResult, bool> _f$isSubscribed = Field(
    'isSubscribed',
    _$isSubscribed,
    opt: true,
    def: false,
  );
  static bool _$requirePrefix(FCTopicDataResult v) => v.requirePrefix;
  static const Field<FCTopicDataResult, bool> _f$requirePrefix = Field(
    'requirePrefix',
    _$requirePrefix,
    opt: true,
    def: false,
  );
  static List<FCPrefix> _$prefixes(FCTopicDataResult v) => v.prefixes;
  static const Field<FCTopicDataResult, List<FCPrefix>> _f$prefixes = Field(
    'prefixes',
    _$prefixes,
    opt: true,
    def: const [],
  );
  static List<FCTopic> _$topics(FCTopicDataResult v) => v.topics;
  static const Field<FCTopicDataResult, List<FCTopic>> _f$topics = Field(
    'topics',
    _$topics,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCTopicDataResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalTopicNum: _f$totalTopicNum,
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #canPost: _f$canPost,
    #canUpload: _f$canUpload,
    #unreadStickyCount: _f$unreadStickyCount,
    #unreadAnnounceCount: _f$unreadAnnounceCount,
    #canSubscribe: _f$canSubscribe,
    #isSubscribed: _f$isSubscribed,
    #requirePrefix: _f$requirePrefix,
    #prefixes: _f$prefixes,
    #topics: _f$topics,
  };

  static FCTopicDataResult _instantiate(DecodingData data) {
    return FCTopicDataResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalTopicNum: data.dec(_f$totalTopicNum),
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      canPost: data.dec(_f$canPost),
      canUpload: data.dec(_f$canUpload),
      unreadStickyCount: data.dec(_f$unreadStickyCount),
      unreadAnnounceCount: data.dec(_f$unreadAnnounceCount),
      canSubscribe: data.dec(_f$canSubscribe),
      isSubscribed: data.dec(_f$isSubscribed),
      requirePrefix: data.dec(_f$requirePrefix),
      prefixes: data.dec(_f$prefixes),
      topics: data.dec(_f$topics),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCTopicDataResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCTopicDataResult>(map);
  }

  static FCTopicDataResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCTopicDataResult>(json);
  }
}

mixin FCTopicDataResultMappable {
  String toJson() {
    return FCTopicDataResultMapper.ensureInitialized()
        .encodeJson<FCTopicDataResult>(this as FCTopicDataResult);
  }

  Map<String, dynamic> toMap() {
    return FCTopicDataResultMapper.ensureInitialized()
        .encodeMap<FCTopicDataResult>(this as FCTopicDataResult);
  }

  FCTopicDataResultCopyWith<
    FCTopicDataResult,
    FCTopicDataResult,
    FCTopicDataResult
  >
  get copyWith =>
      _FCTopicDataResultCopyWithImpl<FCTopicDataResult, FCTopicDataResult>(
        this as FCTopicDataResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCTopicDataResultMapper.ensureInitialized().stringifyValue(
      this as FCTopicDataResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCTopicDataResultMapper.ensureInitialized().equalsValue(
      this as FCTopicDataResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCTopicDataResultMapper.ensureInitialized().hashValue(
      this as FCTopicDataResult,
    );
  }
}

extension FCTopicDataResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCTopicDataResult, $Out> {
  FCTopicDataResultCopyWith<$R, FCTopicDataResult, $Out>
  get $asFCTopicDataResult => $base.as(
    (v, t, t2) => _FCTopicDataResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCTopicDataResultCopyWith<
  $R,
  $In extends FCTopicDataResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCPrefix, FCPrefixCopyWith<$R, FCPrefix, FCPrefix>>
  get prefixes;
  ListCopyWith<$R, FCTopic, FCTopicCopyWith<$R, FCTopic, FCTopic>> get topics;
  @override
  $R call({
    bool? result,
    covariant String? resultText,
    int? totalTopicNum,
    String? forumId,
    String? forumName,
    bool? canPost,
    bool? canUpload,
    int? unreadStickyCount,
    int? unreadAnnounceCount,
    bool? canSubscribe,
    bool? isSubscribed,
    bool? requirePrefix,
    List<FCPrefix>? prefixes,
    List<FCTopic>? topics,
  });
  FCTopicDataResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCTopicDataResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCTopicDataResult, $Out>
    implements FCTopicDataResultCopyWith<$R, FCTopicDataResult, $Out> {
  _FCTopicDataResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCTopicDataResult> $mapper =
      FCTopicDataResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCPrefix, FCPrefixCopyWith<$R, FCPrefix, FCPrefix>>
  get prefixes => ListCopyWith(
    $value.prefixes,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(prefixes: v),
  );
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
    String? resultText,
    int? totalTopicNum,
    String? forumId,
    String? forumName,
    bool? canPost,
    bool? canUpload,
    int? unreadStickyCount,
    int? unreadAnnounceCount,
    bool? canSubscribe,
    bool? isSubscribed,
    bool? requirePrefix,
    List<FCPrefix>? prefixes,
    List<FCTopic>? topics,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != null) #resultText: resultText,
      if (totalTopicNum != null) #totalTopicNum: totalTopicNum,
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (canPost != null) #canPost: canPost,
      if (canUpload != null) #canUpload: canUpload,
      if (unreadStickyCount != null) #unreadStickyCount: unreadStickyCount,
      if (unreadAnnounceCount != null)
        #unreadAnnounceCount: unreadAnnounceCount,
      if (canSubscribe != null) #canSubscribe: canSubscribe,
      if (isSubscribed != null) #isSubscribed: isSubscribed,
      if (requirePrefix != null) #requirePrefix: requirePrefix,
      if (prefixes != null) #prefixes: prefixes,
      if (topics != null) #topics: topics,
    }),
  );
  @override
  FCTopicDataResult $make(CopyWithData data) => FCTopicDataResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalTopicNum: data.get(#totalTopicNum, or: $value.totalTopicNum),
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    canPost: data.get(#canPost, or: $value.canPost),
    canUpload: data.get(#canUpload, or: $value.canUpload),
    unreadStickyCount: data.get(
      #unreadStickyCount,
      or: $value.unreadStickyCount,
    ),
    unreadAnnounceCount: data.get(
      #unreadAnnounceCount,
      or: $value.unreadAnnounceCount,
    ),
    canSubscribe: data.get(#canSubscribe, or: $value.canSubscribe),
    isSubscribed: data.get(#isSubscribed, or: $value.isSubscribed),
    requirePrefix: data.get(#requirePrefix, or: $value.requirePrefix),
    prefixes: data.get(#prefixes, or: $value.prefixes),
    topics: data.get(#topics, or: $value.topics),
  );

  @override
  FCTopicDataResultCopyWith<$R2, FCTopicDataResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCTopicDataResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCPrefixMapper extends ClassMapperBase<FCPrefix> {
  FCPrefixMapper._();

  static FCPrefixMapper? _instance;
  static FCPrefixMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCPrefixMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCPrefix';

  static String _$prefixId(FCPrefix v) => v.prefixId;
  static const Field<FCPrefix, String> _f$prefixId = Field(
    'prefixId',
    _$prefixId,
  );
  static String _$prefixDisplayName(FCPrefix v) => v.prefixDisplayName;
  static const Field<FCPrefix, String> _f$prefixDisplayName = Field(
    'prefixDisplayName',
    _$prefixDisplayName,
  );

  @override
  final MappableFields<FCPrefix> fields = const {
    #prefixId: _f$prefixId,
    #prefixDisplayName: _f$prefixDisplayName,
  };

  static FCPrefix _instantiate(DecodingData data) {
    return FCPrefix(
      prefixId: data.dec(_f$prefixId),
      prefixDisplayName: data.dec(_f$prefixDisplayName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCPrefix fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCPrefix>(map);
  }

  static FCPrefix fromJson(String json) {
    return ensureInitialized().decodeJson<FCPrefix>(json);
  }
}

mixin FCPrefixMappable {
  String toJson() {
    return FCPrefixMapper.ensureInitialized().encodeJson<FCPrefix>(
      this as FCPrefix,
    );
  }

  Map<String, dynamic> toMap() {
    return FCPrefixMapper.ensureInitialized().encodeMap<FCPrefix>(
      this as FCPrefix,
    );
  }

  FCPrefixCopyWith<FCPrefix, FCPrefix, FCPrefix> get copyWith =>
      _FCPrefixCopyWithImpl<FCPrefix, FCPrefix>(
        this as FCPrefix,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCPrefixMapper.ensureInitialized().stringifyValue(this as FCPrefix);
  }

  @override
  bool operator ==(Object other) {
    return FCPrefixMapper.ensureInitialized().equalsValue(
      this as FCPrefix,
      other,
    );
  }

  @override
  int get hashCode {
    return FCPrefixMapper.ensureInitialized().hashValue(this as FCPrefix);
  }
}

extension FCPrefixValueCopy<$R, $Out> on ObjectCopyWith<$R, FCPrefix, $Out> {
  FCPrefixCopyWith<$R, FCPrefix, $Out> get $asFCPrefix =>
      $base.as((v, t, t2) => _FCPrefixCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCPrefixCopyWith<$R, $In extends FCPrefix, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? prefixId, String? prefixDisplayName});
  FCPrefixCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCPrefixCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCPrefix, $Out>
    implements FCPrefixCopyWith<$R, FCPrefix, $Out> {
  _FCPrefixCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCPrefix> $mapper =
      FCPrefixMapper.ensureInitialized();
  @override
  $R call({String? prefixId, String? prefixDisplayName}) => $apply(
    FieldCopyWithData({
      if (prefixId != null) #prefixId: prefixId,
      if (prefixDisplayName != null) #prefixDisplayName: prefixDisplayName,
    }),
  );
  @override
  FCPrefix $make(CopyWithData data) => FCPrefix(
    prefixId: data.get(#prefixId, or: $value.prefixId),
    prefixDisplayName: data.get(
      #prefixDisplayName,
      or: $value.prefixDisplayName,
    ),
  );

  @override
  FCPrefixCopyWith<$R2, FCPrefix, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCPrefixCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCNewTopicResultMapper extends ClassMapperBase<FCNewTopicResult> {
  FCNewTopicResultMapper._();

  static FCNewTopicResultMapper? _instance;
  static FCNewTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCNewTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCNewTopicResult';

  static bool _$result(FCNewTopicResult v) => v.result;
  static const Field<FCNewTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCNewTopicResult v) => v.resultText;
  static const Field<FCNewTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String _$topicId(FCNewTopicResult v) => v.topicId;
  static const Field<FCNewTopicResult, String> _f$topicId = Field(
    'topicId',
    _$topicId,
  );
  static int _$state(FCNewTopicResult v) => v.state;
  static const Field<FCNewTopicResult, int> _f$state = Field(
    'state',
    _$state,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<FCNewTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #topicId: _f$topicId,
    #state: _f$state,
  };

  static FCNewTopicResult _instantiate(DecodingData data) {
    return FCNewTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      topicId: data.dec(_f$topicId),
      state: data.dec(_f$state),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCNewTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCNewTopicResult>(map);
  }

  static FCNewTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCNewTopicResult>(json);
  }
}

mixin FCNewTopicResultMappable {
  String toJson() {
    return FCNewTopicResultMapper.ensureInitialized()
        .encodeJson<FCNewTopicResult>(this as FCNewTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCNewTopicResultMapper.ensureInitialized()
        .encodeMap<FCNewTopicResult>(this as FCNewTopicResult);
  }

  FCNewTopicResultCopyWith<FCNewTopicResult, FCNewTopicResult, FCNewTopicResult>
  get copyWith =>
      _FCNewTopicResultCopyWithImpl<FCNewTopicResult, FCNewTopicResult>(
        this as FCNewTopicResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCNewTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCNewTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCNewTopicResultMapper.ensureInitialized().equalsValue(
      this as FCNewTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCNewTopicResultMapper.ensureInitialized().hashValue(
      this as FCNewTopicResult,
    );
  }
}

extension FCNewTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCNewTopicResult, $Out> {
  FCNewTopicResultCopyWith<$R, FCNewTopicResult, $Out>
  get $asFCNewTopicResult =>
      $base.as((v, t, t2) => _FCNewTopicResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCNewTopicResultCopyWith<$R, $In extends FCNewTopicResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, String? topicId, int? state});
  FCNewTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCNewTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCNewTopicResult, $Out>
    implements FCNewTopicResultCopyWith<$R, FCNewTopicResult, $Out> {
  _FCNewTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCNewTopicResult> $mapper =
      FCNewTopicResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    String? topicId,
    int? state,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (topicId != null) #topicId: topicId,
      if (state != null) #state: state,
    }),
  );
  @override
  FCNewTopicResult $make(CopyWithData data) => FCNewTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    topicId: data.get(#topicId, or: $value.topicId),
    state: data.get(#state, or: $value.state),
  );

  @override
  FCNewTopicResultCopyWith<$R2, FCNewTopicResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCNewTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCMarkTopicReadResultMapper
    extends ClassMapperBase<FCMarkTopicReadResult> {
  FCMarkTopicReadResultMapper._();

  static FCMarkTopicReadResultMapper? _instance;
  static FCMarkTopicReadResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCMarkTopicReadResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCMarkTopicReadResult';

  static bool _$result(FCMarkTopicReadResult v) => v.result;
  static const Field<FCMarkTopicReadResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCMarkTopicReadResult v) => v.resultText;
  static const Field<FCMarkTopicReadResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCMarkTopicReadResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCMarkTopicReadResult _instantiate(DecodingData data) {
    return FCMarkTopicReadResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCMarkTopicReadResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCMarkTopicReadResult>(map);
  }

  static FCMarkTopicReadResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCMarkTopicReadResult>(json);
  }
}

mixin FCMarkTopicReadResultMappable {
  String toJson() {
    return FCMarkTopicReadResultMapper.ensureInitialized()
        .encodeJson<FCMarkTopicReadResult>(this as FCMarkTopicReadResult);
  }

  Map<String, dynamic> toMap() {
    return FCMarkTopicReadResultMapper.ensureInitialized()
        .encodeMap<FCMarkTopicReadResult>(this as FCMarkTopicReadResult);
  }

  FCMarkTopicReadResultCopyWith<
    FCMarkTopicReadResult,
    FCMarkTopicReadResult,
    FCMarkTopicReadResult
  >
  get copyWith =>
      _FCMarkTopicReadResultCopyWithImpl<
        FCMarkTopicReadResult,
        FCMarkTopicReadResult
      >(this as FCMarkTopicReadResult, $identity, $identity);
  @override
  String toString() {
    return FCMarkTopicReadResultMapper.ensureInitialized().stringifyValue(
      this as FCMarkTopicReadResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCMarkTopicReadResultMapper.ensureInitialized().equalsValue(
      this as FCMarkTopicReadResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCMarkTopicReadResultMapper.ensureInitialized().hashValue(
      this as FCMarkTopicReadResult,
    );
  }
}

extension FCMarkTopicReadResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCMarkTopicReadResult, $Out> {
  FCMarkTopicReadResultCopyWith<$R, FCMarkTopicReadResult, $Out>
  get $asFCMarkTopicReadResult => $base.as(
    (v, t, t2) => _FCMarkTopicReadResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCMarkTopicReadResultCopyWith<
  $R,
  $In extends FCMarkTopicReadResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCMarkTopicReadResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCMarkTopicReadResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCMarkTopicReadResult, $Out>
    implements FCMarkTopicReadResultCopyWith<$R, FCMarkTopicReadResult, $Out> {
  _FCMarkTopicReadResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCMarkTopicReadResult> $mapper =
      FCMarkTopicReadResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCMarkTopicReadResult $make(CopyWithData data) => FCMarkTopicReadResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCMarkTopicReadResultCopyWith<$R2, FCMarkTopicReadResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCMarkTopicReadResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCTopicStatusResultMapper extends ClassMapperBase<FCTopicStatusResult> {
  FCTopicStatusResultMapper._();

  static FCTopicStatusResultMapper? _instance;
  static FCTopicStatusResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCTopicStatusResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCTopicStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCTopicStatusResult';

  static bool _$result(FCTopicStatusResult v) => v.result;
  static const Field<FCTopicStatusResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCTopicStatusResult v) => v.resultText;
  static const Field<FCTopicStatusResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static List<FCTopicStatus> _$topics(FCTopicStatusResult v) => v.topics;
  static const Field<FCTopicStatusResult, List<FCTopicStatus>> _f$topics =
      Field('topics', _$topics, opt: true, def: const []);

  @override
  final MappableFields<FCTopicStatusResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #topics: _f$topics,
  };

  static FCTopicStatusResult _instantiate(DecodingData data) {
    return FCTopicStatusResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      topics: data.dec(_f$topics),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCTopicStatusResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCTopicStatusResult>(map);
  }

  static FCTopicStatusResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCTopicStatusResult>(json);
  }
}

mixin FCTopicStatusResultMappable {
  String toJson() {
    return FCTopicStatusResultMapper.ensureInitialized()
        .encodeJson<FCTopicStatusResult>(this as FCTopicStatusResult);
  }

  Map<String, dynamic> toMap() {
    return FCTopicStatusResultMapper.ensureInitialized()
        .encodeMap<FCTopicStatusResult>(this as FCTopicStatusResult);
  }

  FCTopicStatusResultCopyWith<
    FCTopicStatusResult,
    FCTopicStatusResult,
    FCTopicStatusResult
  >
  get copyWith =>
      _FCTopicStatusResultCopyWithImpl<
        FCTopicStatusResult,
        FCTopicStatusResult
      >(this as FCTopicStatusResult, $identity, $identity);
  @override
  String toString() {
    return FCTopicStatusResultMapper.ensureInitialized().stringifyValue(
      this as FCTopicStatusResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCTopicStatusResultMapper.ensureInitialized().equalsValue(
      this as FCTopicStatusResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCTopicStatusResultMapper.ensureInitialized().hashValue(
      this as FCTopicStatusResult,
    );
  }
}

extension FCTopicStatusResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCTopicStatusResult, $Out> {
  FCTopicStatusResultCopyWith<$R, FCTopicStatusResult, $Out>
  get $asFCTopicStatusResult => $base.as(
    (v, t, t2) => _FCTopicStatusResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCTopicStatusResultCopyWith<
  $R,
  $In extends FCTopicStatusResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCTopicStatus,
    FCTopicStatusCopyWith<$R, FCTopicStatus, FCTopicStatus>
  >
  get topics;
  @override
  $R call({bool? result, String? resultText, List<FCTopicStatus>? topics});
  FCTopicStatusResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCTopicStatusResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCTopicStatusResult, $Out>
    implements FCTopicStatusResultCopyWith<$R, FCTopicStatusResult, $Out> {
  _FCTopicStatusResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCTopicStatusResult> $mapper =
      FCTopicStatusResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCTopicStatus,
    FCTopicStatusCopyWith<$R, FCTopicStatus, FCTopicStatus>
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
    List<FCTopicStatus>? topics,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (topics != null) #topics: topics,
    }),
  );
  @override
  FCTopicStatusResult $make(CopyWithData data) => FCTopicStatusResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    topics: data.get(#topics, or: $value.topics),
  );

  @override
  FCTopicStatusResultCopyWith<$R2, FCTopicStatusResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCTopicStatusResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCTopicStatusMapper extends ClassMapperBase<FCTopicStatus> {
  FCTopicStatusMapper._();

  static FCTopicStatusMapper? _instance;
  static FCTopicStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCTopicStatusMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCTopicStatus';

  static String _$topicId(FCTopicStatus v) => v.topicId;
  static const Field<FCTopicStatus, String> _f$topicId = Field(
    'topicId',
    _$topicId,
  );
  static bool _$newPost(FCTopicStatus v) => v.newPost;
  static const Field<FCTopicStatus, bool> _f$newPost = Field(
    'newPost',
    _$newPost,
  );
  static int _$replyNumber(FCTopicStatus v) => v.replyNumber;
  static const Field<FCTopicStatus, int> _f$replyNumber = Field(
    'replyNumber',
    _$replyNumber,
  );
  static int _$viewNumber(FCTopicStatus v) => v.viewNumber;
  static const Field<FCTopicStatus, int> _f$viewNumber = Field(
    'viewNumber',
    _$viewNumber,
  );
  static bool _$isClosed(FCTopicStatus v) => v.isClosed;
  static const Field<FCTopicStatus, bool> _f$isClosed = Field(
    'isClosed',
    _$isClosed,
  );
  static bool _$isSubscribed(FCTopicStatus v) => v.isSubscribed;
  static const Field<FCTopicStatus, bool> _f$isSubscribed = Field(
    'isSubscribed',
    _$isSubscribed,
  );
  static bool _$canSubscribe(FCTopicStatus v) => v.canSubscribe;
  static const Field<FCTopicStatus, bool> _f$canSubscribe = Field(
    'canSubscribe',
    _$canSubscribe,
  );
  static DateTime? _$lastReplyTime(FCTopicStatus v) => v.lastReplyTime;
  static const Field<FCTopicStatus, DateTime> _f$lastReplyTime = Field(
    'lastReplyTime',
    _$lastReplyTime,
    opt: true,
  );
  static String? _$timestamp(FCTopicStatus v) => v.timestamp;
  static const Field<FCTopicStatus, String> _f$timestamp = Field(
    'timestamp',
    _$timestamp,
    opt: true,
  );

  @override
  final MappableFields<FCTopicStatus> fields = const {
    #topicId: _f$topicId,
    #newPost: _f$newPost,
    #replyNumber: _f$replyNumber,
    #viewNumber: _f$viewNumber,
    #isClosed: _f$isClosed,
    #isSubscribed: _f$isSubscribed,
    #canSubscribe: _f$canSubscribe,
    #lastReplyTime: _f$lastReplyTime,
    #timestamp: _f$timestamp,
  };

  static FCTopicStatus _instantiate(DecodingData data) {
    return FCTopicStatus(
      topicId: data.dec(_f$topicId),
      newPost: data.dec(_f$newPost),
      replyNumber: data.dec(_f$replyNumber),
      viewNumber: data.dec(_f$viewNumber),
      isClosed: data.dec(_f$isClosed),
      isSubscribed: data.dec(_f$isSubscribed),
      canSubscribe: data.dec(_f$canSubscribe),
      lastReplyTime: data.dec(_f$lastReplyTime),
      timestamp: data.dec(_f$timestamp),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCTopicStatus fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCTopicStatus>(map);
  }

  static FCTopicStatus fromJson(String json) {
    return ensureInitialized().decodeJson<FCTopicStatus>(json);
  }
}

mixin FCTopicStatusMappable {
  String toJson() {
    return FCTopicStatusMapper.ensureInitialized().encodeJson<FCTopicStatus>(
      this as FCTopicStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return FCTopicStatusMapper.ensureInitialized().encodeMap<FCTopicStatus>(
      this as FCTopicStatus,
    );
  }

  FCTopicStatusCopyWith<FCTopicStatus, FCTopicStatus, FCTopicStatus>
  get copyWith => _FCTopicStatusCopyWithImpl<FCTopicStatus, FCTopicStatus>(
    this as FCTopicStatus,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCTopicStatusMapper.ensureInitialized().stringifyValue(
      this as FCTopicStatus,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCTopicStatusMapper.ensureInitialized().equalsValue(
      this as FCTopicStatus,
      other,
    );
  }

  @override
  int get hashCode {
    return FCTopicStatusMapper.ensureInitialized().hashValue(
      this as FCTopicStatus,
    );
  }
}

extension FCTopicStatusValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCTopicStatus, $Out> {
  FCTopicStatusCopyWith<$R, FCTopicStatus, $Out> get $asFCTopicStatus =>
      $base.as((v, t, t2) => _FCTopicStatusCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCTopicStatusCopyWith<$R, $In extends FCTopicStatus, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? topicId,
    bool? newPost,
    int? replyNumber,
    int? viewNumber,
    bool? isClosed,
    bool? isSubscribed,
    bool? canSubscribe,
    DateTime? lastReplyTime,
    String? timestamp,
  });
  FCTopicStatusCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCTopicStatusCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCTopicStatus, $Out>
    implements FCTopicStatusCopyWith<$R, FCTopicStatus, $Out> {
  _FCTopicStatusCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCTopicStatus> $mapper =
      FCTopicStatusMapper.ensureInitialized();
  @override
  $R call({
    String? topicId,
    bool? newPost,
    int? replyNumber,
    int? viewNumber,
    bool? isClosed,
    bool? isSubscribed,
    bool? canSubscribe,
    Object? lastReplyTime = $none,
    Object? timestamp = $none,
  }) => $apply(
    FieldCopyWithData({
      if (topicId != null) #topicId: topicId,
      if (newPost != null) #newPost: newPost,
      if (replyNumber != null) #replyNumber: replyNumber,
      if (viewNumber != null) #viewNumber: viewNumber,
      if (isClosed != null) #isClosed: isClosed,
      if (isSubscribed != null) #isSubscribed: isSubscribed,
      if (canSubscribe != null) #canSubscribe: canSubscribe,
      if (lastReplyTime != $none) #lastReplyTime: lastReplyTime,
      if (timestamp != $none) #timestamp: timestamp,
    }),
  );
  @override
  FCTopicStatus $make(CopyWithData data) => FCTopicStatus(
    topicId: data.get(#topicId, or: $value.topicId),
    newPost: data.get(#newPost, or: $value.newPost),
    replyNumber: data.get(#replyNumber, or: $value.replyNumber),
    viewNumber: data.get(#viewNumber, or: $value.viewNumber),
    isClosed: data.get(#isClosed, or: $value.isClosed),
    isSubscribed: data.get(#isSubscribed, or: $value.isSubscribed),
    canSubscribe: data.get(#canSubscribe, or: $value.canSubscribe),
    lastReplyTime: data.get(#lastReplyTime, or: $value.lastReplyTime),
    timestamp: data.get(#timestamp, or: $value.timestamp),
  );

  @override
  FCTopicStatusCopyWith<$R2, FCTopicStatus, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCTopicStatusCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUnreadTopicResultMapper extends ClassMapperBase<FCUnreadTopicResult> {
  FCUnreadTopicResultMapper._();

  static FCUnreadTopicResultMapper? _instance;
  static FCUnreadTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUnreadTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCTopicMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUnreadTopicResult';

  static bool _$result(FCUnreadTopicResult v) => v.result;
  static const Field<FCUnreadTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUnreadTopicResult v) => v.resultText;
  static const Field<FCUnreadTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalUnreadNum(FCUnreadTopicResult v) => v.totalUnreadNum;
  static const Field<FCUnreadTopicResult, int> _f$totalUnreadNum = Field(
    'totalUnreadNum',
    _$totalUnreadNum,
  );
  static List<FCTopic> _$topics(FCUnreadTopicResult v) => v.topics;
  static const Field<FCUnreadTopicResult, List<FCTopic>> _f$topics = Field(
    'topics',
    _$topics,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCUnreadTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalUnreadNum: _f$totalUnreadNum,
    #topics: _f$topics,
  };

  static FCUnreadTopicResult _instantiate(DecodingData data) {
    return FCUnreadTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalUnreadNum: data.dec(_f$totalUnreadNum),
      topics: data.dec(_f$topics),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUnreadTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUnreadTopicResult>(map);
  }

  static FCUnreadTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUnreadTopicResult>(json);
  }
}

mixin FCUnreadTopicResultMappable {
  String toJson() {
    return FCUnreadTopicResultMapper.ensureInitialized()
        .encodeJson<FCUnreadTopicResult>(this as FCUnreadTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCUnreadTopicResultMapper.ensureInitialized()
        .encodeMap<FCUnreadTopicResult>(this as FCUnreadTopicResult);
  }

  FCUnreadTopicResultCopyWith<
    FCUnreadTopicResult,
    FCUnreadTopicResult,
    FCUnreadTopicResult
  >
  get copyWith =>
      _FCUnreadTopicResultCopyWithImpl<
        FCUnreadTopicResult,
        FCUnreadTopicResult
      >(this as FCUnreadTopicResult, $identity, $identity);
  @override
  String toString() {
    return FCUnreadTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCUnreadTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUnreadTopicResultMapper.ensureInitialized().equalsValue(
      this as FCUnreadTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUnreadTopicResultMapper.ensureInitialized().hashValue(
      this as FCUnreadTopicResult,
    );
  }
}

extension FCUnreadTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUnreadTopicResult, $Out> {
  FCUnreadTopicResultCopyWith<$R, FCUnreadTopicResult, $Out>
  get $asFCUnreadTopicResult => $base.as(
    (v, t, t2) => _FCUnreadTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUnreadTopicResultCopyWith<
  $R,
  $In extends FCUnreadTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCTopic, FCTopicCopyWith<$R, FCTopic, FCTopic>> get topics;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalUnreadNum,
    List<FCTopic>? topics,
  });
  FCUnreadTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUnreadTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUnreadTopicResult, $Out>
    implements FCUnreadTopicResultCopyWith<$R, FCUnreadTopicResult, $Out> {
  _FCUnreadTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUnreadTopicResult> $mapper =
      FCUnreadTopicResultMapper.ensureInitialized();
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
    int? totalUnreadNum,
    List<FCTopic>? topics,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalUnreadNum != null) #totalUnreadNum: totalUnreadNum,
      if (topics != null) #topics: topics,
    }),
  );
  @override
  FCUnreadTopicResult $make(CopyWithData data) => FCUnreadTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalUnreadNum: data.get(#totalUnreadNum, or: $value.totalUnreadNum),
    topics: data.get(#topics, or: $value.topics),
  );

  @override
  FCUnreadTopicResultCopyWith<$R2, FCUnreadTopicResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCUnreadTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCParticipatedTopicResultMapper
    extends ClassMapperBase<FCParticipatedTopicResult> {
  FCParticipatedTopicResultMapper._();

  static FCParticipatedTopicResultMapper? _instance;
  static FCParticipatedTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCParticipatedTopicResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
      FCTopicMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCParticipatedTopicResult';

  static bool _$result(FCParticipatedTopicResult v) => v.result;
  static const Field<FCParticipatedTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCParticipatedTopicResult v) => v.resultText;
  static const Field<FCParticipatedTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalParticipatedNum(FCParticipatedTopicResult v) =>
      v.totalParticipatedNum;
  static const Field<FCParticipatedTopicResult, int> _f$totalParticipatedNum =
      Field('totalParticipatedNum', _$totalParticipatedNum);
  static List<FCTopic> _$topics(FCParticipatedTopicResult v) => v.topics;
  static const Field<FCParticipatedTopicResult, List<FCTopic>> _f$topics =
      Field('topics', _$topics, opt: true, def: const []);

  @override
  final MappableFields<FCParticipatedTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalParticipatedNum: _f$totalParticipatedNum,
    #topics: _f$topics,
  };

  static FCParticipatedTopicResult _instantiate(DecodingData data) {
    return FCParticipatedTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalParticipatedNum: data.dec(_f$totalParticipatedNum),
      topics: data.dec(_f$topics),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCParticipatedTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCParticipatedTopicResult>(map);
  }

  static FCParticipatedTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCParticipatedTopicResult>(json);
  }
}

mixin FCParticipatedTopicResultMappable {
  String toJson() {
    return FCParticipatedTopicResultMapper.ensureInitialized()
        .encodeJson<FCParticipatedTopicResult>(
          this as FCParticipatedTopicResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCParticipatedTopicResultMapper.ensureInitialized()
        .encodeMap<FCParticipatedTopicResult>(
          this as FCParticipatedTopicResult,
        );
  }

  FCParticipatedTopicResultCopyWith<
    FCParticipatedTopicResult,
    FCParticipatedTopicResult,
    FCParticipatedTopicResult
  >
  get copyWith =>
      _FCParticipatedTopicResultCopyWithImpl<
        FCParticipatedTopicResult,
        FCParticipatedTopicResult
      >(this as FCParticipatedTopicResult, $identity, $identity);
  @override
  String toString() {
    return FCParticipatedTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCParticipatedTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCParticipatedTopicResultMapper.ensureInitialized().equalsValue(
      this as FCParticipatedTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCParticipatedTopicResultMapper.ensureInitialized().hashValue(
      this as FCParticipatedTopicResult,
    );
  }
}

extension FCParticipatedTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCParticipatedTopicResult, $Out> {
  FCParticipatedTopicResultCopyWith<$R, FCParticipatedTopicResult, $Out>
  get $asFCParticipatedTopicResult => $base.as(
    (v, t, t2) => _FCParticipatedTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCParticipatedTopicResultCopyWith<
  $R,
  $In extends FCParticipatedTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCTopic, FCTopicCopyWith<$R, FCTopic, FCTopic>> get topics;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalParticipatedNum,
    List<FCTopic>? topics,
  });
  FCParticipatedTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCParticipatedTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCParticipatedTopicResult, $Out>
    implements
        FCParticipatedTopicResultCopyWith<$R, FCParticipatedTopicResult, $Out> {
  _FCParticipatedTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCParticipatedTopicResult> $mapper =
      FCParticipatedTopicResultMapper.ensureInitialized();
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
    int? totalParticipatedNum,
    List<FCTopic>? topics,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalParticipatedNum != null)
        #totalParticipatedNum: totalParticipatedNum,
      if (topics != null) #topics: topics,
    }),
  );
  @override
  FCParticipatedTopicResult $make(CopyWithData data) =>
      FCParticipatedTopicResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
        totalParticipatedNum: data.get(
          #totalParticipatedNum,
          or: $value.totalParticipatedNum,
        ),
        topics: data.get(#topics, or: $value.topics),
      );

  @override
  FCParticipatedTopicResultCopyWith<$R2, FCParticipatedTopicResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCParticipatedTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCLatestTopicResultMapper extends ClassMapperBase<FCLatestTopicResult> {
  FCLatestTopicResultMapper._();

  static FCLatestTopicResultMapper? _instance;
  static FCLatestTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCLatestTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCTopicMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCLatestTopicResult';

  static bool _$result(FCLatestTopicResult v) => v.result;
  static const Field<FCLatestTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCLatestTopicResult v) => v.resultText;
  static const Field<FCLatestTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$totalLatestNum(FCLatestTopicResult v) => v.totalLatestNum;
  static const Field<FCLatestTopicResult, int> _f$totalLatestNum = Field(
    'totalLatestNum',
    _$totalLatestNum,
  );
  static List<FCTopic> _$topics(FCLatestTopicResult v) => v.topics;
  static const Field<FCLatestTopicResult, List<FCTopic>> _f$topics = Field(
    'topics',
    _$topics,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCLatestTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalLatestNum: _f$totalLatestNum,
    #topics: _f$topics,
  };

  static FCLatestTopicResult _instantiate(DecodingData data) {
    return FCLatestTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalLatestNum: data.dec(_f$totalLatestNum),
      topics: data.dec(_f$topics),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCLatestTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCLatestTopicResult>(map);
  }

  static FCLatestTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCLatestTopicResult>(json);
  }
}

mixin FCLatestTopicResultMappable {
  String toJson() {
    return FCLatestTopicResultMapper.ensureInitialized()
        .encodeJson<FCLatestTopicResult>(this as FCLatestTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCLatestTopicResultMapper.ensureInitialized()
        .encodeMap<FCLatestTopicResult>(this as FCLatestTopicResult);
  }

  FCLatestTopicResultCopyWith<
    FCLatestTopicResult,
    FCLatestTopicResult,
    FCLatestTopicResult
  >
  get copyWith =>
      _FCLatestTopicResultCopyWithImpl<
        FCLatestTopicResult,
        FCLatestTopicResult
      >(this as FCLatestTopicResult, $identity, $identity);
  @override
  String toString() {
    return FCLatestTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCLatestTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCLatestTopicResultMapper.ensureInitialized().equalsValue(
      this as FCLatestTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCLatestTopicResultMapper.ensureInitialized().hashValue(
      this as FCLatestTopicResult,
    );
  }
}

extension FCLatestTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCLatestTopicResult, $Out> {
  FCLatestTopicResultCopyWith<$R, FCLatestTopicResult, $Out>
  get $asFCLatestTopicResult => $base.as(
    (v, t, t2) => _FCLatestTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCLatestTopicResultCopyWith<
  $R,
  $In extends FCLatestTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCTopic, FCTopicCopyWith<$R, FCTopic, FCTopic>> get topics;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalLatestNum,
    List<FCTopic>? topics,
  });
  FCLatestTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCLatestTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCLatestTopicResult, $Out>
    implements FCLatestTopicResultCopyWith<$R, FCLatestTopicResult, $Out> {
  _FCLatestTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCLatestTopicResult> $mapper =
      FCLatestTopicResultMapper.ensureInitialized();
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
    int? totalLatestNum,
    List<FCTopic>? topics,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (totalLatestNum != null) #totalLatestNum: totalLatestNum,
      if (topics != null) #topics: topics,
    }),
  );
  @override
  FCLatestTopicResult $make(CopyWithData data) => FCLatestTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalLatestNum: data.get(#totalLatestNum, or: $value.totalLatestNum),
    topics: data.get(#topics, or: $value.topics),
  );

  @override
  FCLatestTopicResultCopyWith<$R2, FCLatestTopicResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCLatestTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCTopicByIdsResultMapper extends ClassMapperBase<FCTopicByIdsResult> {
  FCTopicByIdsResultMapper._();

  static FCTopicByIdsResultMapper? _instance;
  static FCTopicByIdsResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCTopicByIdsResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCTopicMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCTopicByIdsResult';

  static bool _$result(FCTopicByIdsResult v) => v.result;
  static const Field<FCTopicByIdsResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCTopicByIdsResult v) => v.resultText;
  static const Field<FCTopicByIdsResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static List<FCTopic> _$topics(FCTopicByIdsResult v) => v.topics;
  static const Field<FCTopicByIdsResult, List<FCTopic>> _f$topics = Field(
    'topics',
    _$topics,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCTopicByIdsResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #topics: _f$topics,
  };

  static FCTopicByIdsResult _instantiate(DecodingData data) {
    return FCTopicByIdsResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      topics: data.dec(_f$topics),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCTopicByIdsResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCTopicByIdsResult>(map);
  }

  static FCTopicByIdsResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCTopicByIdsResult>(json);
  }
}

mixin FCTopicByIdsResultMappable {
  String toJson() {
    return FCTopicByIdsResultMapper.ensureInitialized()
        .encodeJson<FCTopicByIdsResult>(this as FCTopicByIdsResult);
  }

  Map<String, dynamic> toMap() {
    return FCTopicByIdsResultMapper.ensureInitialized()
        .encodeMap<FCTopicByIdsResult>(this as FCTopicByIdsResult);
  }

  FCTopicByIdsResultCopyWith<
    FCTopicByIdsResult,
    FCTopicByIdsResult,
    FCTopicByIdsResult
  >
  get copyWith =>
      _FCTopicByIdsResultCopyWithImpl<FCTopicByIdsResult, FCTopicByIdsResult>(
        this as FCTopicByIdsResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCTopicByIdsResultMapper.ensureInitialized().stringifyValue(
      this as FCTopicByIdsResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCTopicByIdsResultMapper.ensureInitialized().equalsValue(
      this as FCTopicByIdsResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCTopicByIdsResultMapper.ensureInitialized().hashValue(
      this as FCTopicByIdsResult,
    );
  }
}

extension FCTopicByIdsResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCTopicByIdsResult, $Out> {
  FCTopicByIdsResultCopyWith<$R, FCTopicByIdsResult, $Out>
  get $asFCTopicByIdsResult => $base.as(
    (v, t, t2) => _FCTopicByIdsResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCTopicByIdsResultCopyWith<
  $R,
  $In extends FCTopicByIdsResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCTopic, FCTopicCopyWith<$R, FCTopic, FCTopic>> get topics;
  @override
  $R call({bool? result, String? resultText, List<FCTopic>? topics});
  FCTopicByIdsResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCTopicByIdsResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCTopicByIdsResult, $Out>
    implements FCTopicByIdsResultCopyWith<$R, FCTopicByIdsResult, $Out> {
  _FCTopicByIdsResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCTopicByIdsResult> $mapper =
      FCTopicByIdsResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCTopic, FCTopicCopyWith<$R, FCTopic, FCTopic>> get topics =>
      ListCopyWith(
        $value.topics,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(topics: v),
      );
  @override
  $R call({bool? result, Object? resultText = $none, List<FCTopic>? topics}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != $none) #resultText: resultText,
          if (topics != null) #topics: topics,
        }),
      );
  @override
  FCTopicByIdsResult $make(CopyWithData data) => FCTopicByIdsResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    topics: data.get(#topics, or: $value.topics),
  );

  @override
  FCTopicByIdsResultCopyWith<$R2, FCTopicByIdsResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCTopicByIdsResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

