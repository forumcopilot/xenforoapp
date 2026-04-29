// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_forum_result.dart';

class FCForumDataResultMapper extends ClassMapperBase<FCForumDataResult> {
  FCForumDataResultMapper._();

  static FCForumDataResultMapper? _instance;
  static FCForumDataResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCForumDataResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCForumMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCForumDataResult';

  static bool _$result(FCForumDataResult v) => v.result;
  static const Field<FCForumDataResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCForumDataResult v) => v.resultText;
  static const Field<FCForumDataResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
  );
  static List<FCForum> _$forums(FCForumDataResult v) => v.forums;
  static const Field<FCForumDataResult, List<FCForum>> _f$forums = Field(
    'forums',
    _$forums,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCForumDataResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #forums: _f$forums,
  };

  static FCForumDataResult _instantiate(DecodingData data) {
    return FCForumDataResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      forums: data.dec(_f$forums),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCForumDataResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCForumDataResult>(map);
  }

  static FCForumDataResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCForumDataResult>(json);
  }
}

mixin FCForumDataResultMappable {
  String toJson() {
    return FCForumDataResultMapper.ensureInitialized()
        .encodeJson<FCForumDataResult>(this as FCForumDataResult);
  }

  Map<String, dynamic> toMap() {
    return FCForumDataResultMapper.ensureInitialized()
        .encodeMap<FCForumDataResult>(this as FCForumDataResult);
  }

  FCForumDataResultCopyWith<
    FCForumDataResult,
    FCForumDataResult,
    FCForumDataResult
  >
  get copyWith =>
      _FCForumDataResultCopyWithImpl<FCForumDataResult, FCForumDataResult>(
        this as FCForumDataResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCForumDataResultMapper.ensureInitialized().stringifyValue(
      this as FCForumDataResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCForumDataResultMapper.ensureInitialized().equalsValue(
      this as FCForumDataResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCForumDataResultMapper.ensureInitialized().hashValue(
      this as FCForumDataResult,
    );
  }
}

extension FCForumDataResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCForumDataResult, $Out> {
  FCForumDataResultCopyWith<$R, FCForumDataResult, $Out>
  get $asFCForumDataResult => $base.as(
    (v, t, t2) => _FCForumDataResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCForumDataResultCopyWith<
  $R,
  $In extends FCForumDataResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCForum, FCForumCopyWith<$R, FCForum, FCForum>> get forums;
  @override
  $R call({bool? result, covariant String? resultText, List<FCForum>? forums});
  FCForumDataResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCForumDataResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCForumDataResult, $Out>
    implements FCForumDataResultCopyWith<$R, FCForumDataResult, $Out> {
  _FCForumDataResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCForumDataResult> $mapper =
      FCForumDataResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCForum, FCForumCopyWith<$R, FCForum, FCForum>> get forums =>
      ListCopyWith(
        $value.forums,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(forums: v),
      );
  @override
  $R call({bool? result, String? resultText, List<FCForum>? forums}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != null) #resultText: resultText,
      if (forums != null) #forums: forums,
    }),
  );
  @override
  FCForumDataResult $make(CopyWithData data) => FCForumDataResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    forums: data.get(#forums, or: $value.forums),
  );

  @override
  FCForumDataResultCopyWith<$R2, FCForumDataResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCForumDataResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCBoardStatResultMapper extends ClassMapperBase<FCBoardStatResult> {
  FCBoardStatResultMapper._();

  static FCBoardStatResultMapper? _instance;
  static FCBoardStatResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCBoardStatResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCBoardStatResult';

  static bool _$result(FCBoardStatResult v) => v.result;
  static const Field<FCBoardStatResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCBoardStatResult v) => v.resultText;
  static const Field<FCBoardStatResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
  );
  static int _$totalThreads(FCBoardStatResult v) => v.totalThreads;
  static const Field<FCBoardStatResult, int> _f$totalThreads = Field(
    'totalThreads',
    _$totalThreads,
    opt: true,
    def: 0,
  );
  static int _$totalPosts(FCBoardStatResult v) => v.totalPosts;
  static const Field<FCBoardStatResult, int> _f$totalPosts = Field(
    'totalPosts',
    _$totalPosts,
    opt: true,
    def: 0,
  );
  static int _$totalMembers(FCBoardStatResult v) => v.totalMembers;
  static const Field<FCBoardStatResult, int> _f$totalMembers = Field(
    'totalMembers',
    _$totalMembers,
    opt: true,
    def: 0,
  );
  static int _$activeMembers(FCBoardStatResult v) => v.activeMembers;
  static const Field<FCBoardStatResult, int> _f$activeMembers = Field(
    'activeMembers',
    _$activeMembers,
    opt: true,
    def: 0,
  );
  static int _$totalOnline(FCBoardStatResult v) => v.totalOnline;
  static const Field<FCBoardStatResult, int> _f$totalOnline = Field(
    'totalOnline',
    _$totalOnline,
    opt: true,
    def: 0,
  );
  static int _$guestOnline(FCBoardStatResult v) => v.guestOnline;
  static const Field<FCBoardStatResult, int> _f$guestOnline = Field(
    'guestOnline',
    _$guestOnline,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<FCBoardStatResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #totalThreads: _f$totalThreads,
    #totalPosts: _f$totalPosts,
    #totalMembers: _f$totalMembers,
    #activeMembers: _f$activeMembers,
    #totalOnline: _f$totalOnline,
    #guestOnline: _f$guestOnline,
  };

  static FCBoardStatResult _instantiate(DecodingData data) {
    return FCBoardStatResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      totalThreads: data.dec(_f$totalThreads),
      totalPosts: data.dec(_f$totalPosts),
      totalMembers: data.dec(_f$totalMembers),
      activeMembers: data.dec(_f$activeMembers),
      totalOnline: data.dec(_f$totalOnline),
      guestOnline: data.dec(_f$guestOnline),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCBoardStatResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCBoardStatResult>(map);
  }

  static FCBoardStatResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCBoardStatResult>(json);
  }
}

mixin FCBoardStatResultMappable {
  String toJson() {
    return FCBoardStatResultMapper.ensureInitialized()
        .encodeJson<FCBoardStatResult>(this as FCBoardStatResult);
  }

  Map<String, dynamic> toMap() {
    return FCBoardStatResultMapper.ensureInitialized()
        .encodeMap<FCBoardStatResult>(this as FCBoardStatResult);
  }

  FCBoardStatResultCopyWith<
    FCBoardStatResult,
    FCBoardStatResult,
    FCBoardStatResult
  >
  get copyWith =>
      _FCBoardStatResultCopyWithImpl<FCBoardStatResult, FCBoardStatResult>(
        this as FCBoardStatResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCBoardStatResultMapper.ensureInitialized().stringifyValue(
      this as FCBoardStatResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCBoardStatResultMapper.ensureInitialized().equalsValue(
      this as FCBoardStatResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCBoardStatResultMapper.ensureInitialized().hashValue(
      this as FCBoardStatResult,
    );
  }
}

extension FCBoardStatResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCBoardStatResult, $Out> {
  FCBoardStatResultCopyWith<$R, FCBoardStatResult, $Out>
  get $asFCBoardStatResult => $base.as(
    (v, t, t2) => _FCBoardStatResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCBoardStatResultCopyWith<
  $R,
  $In extends FCBoardStatResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({
    bool? result,
    covariant String? resultText,
    int? totalThreads,
    int? totalPosts,
    int? totalMembers,
    int? activeMembers,
    int? totalOnline,
    int? guestOnline,
  });
  FCBoardStatResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCBoardStatResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCBoardStatResult, $Out>
    implements FCBoardStatResultCopyWith<$R, FCBoardStatResult, $Out> {
  _FCBoardStatResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCBoardStatResult> $mapper =
      FCBoardStatResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    String? resultText,
    int? totalThreads,
    int? totalPosts,
    int? totalMembers,
    int? activeMembers,
    int? totalOnline,
    int? guestOnline,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != null) #resultText: resultText,
      if (totalThreads != null) #totalThreads: totalThreads,
      if (totalPosts != null) #totalPosts: totalPosts,
      if (totalMembers != null) #totalMembers: totalMembers,
      if (activeMembers != null) #activeMembers: activeMembers,
      if (totalOnline != null) #totalOnline: totalOnline,
      if (guestOnline != null) #guestOnline: guestOnline,
    }),
  );
  @override
  FCBoardStatResult $make(CopyWithData data) => FCBoardStatResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    totalThreads: data.get(#totalThreads, or: $value.totalThreads),
    totalPosts: data.get(#totalPosts, or: $value.totalPosts),
    totalMembers: data.get(#totalMembers, or: $value.totalMembers),
    activeMembers: data.get(#activeMembers, or: $value.activeMembers),
    totalOnline: data.get(#totalOnline, or: $value.totalOnline),
    guestOnline: data.get(#guestOnline, or: $value.guestOnline),
  );

  @override
  FCBoardStatResultCopyWith<$R2, FCBoardStatResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCBoardStatResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCParticipatedForumResultMapper
    extends ClassMapperBase<FCParticipatedForumResult> {
  FCParticipatedForumResultMapper._();

  static FCParticipatedForumResultMapper? _instance;
  static FCParticipatedForumResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCParticipatedForumResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
      FCForumMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCParticipatedForumResult';

  static bool _$result(FCParticipatedForumResult v) => v.result;
  static const Field<FCParticipatedForumResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCParticipatedForumResult v) => v.resultText;
  static const Field<FCParticipatedForumResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
  );
  static List<FCForum> _$forums(FCParticipatedForumResult v) => v.forums;
  static const Field<FCParticipatedForumResult, List<FCForum>> _f$forums =
      Field('forums', _$forums, opt: true, def: const []);

  @override
  final MappableFields<FCParticipatedForumResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #forums: _f$forums,
  };

  static FCParticipatedForumResult _instantiate(DecodingData data) {
    return FCParticipatedForumResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      forums: data.dec(_f$forums),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCParticipatedForumResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCParticipatedForumResult>(map);
  }

  static FCParticipatedForumResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCParticipatedForumResult>(json);
  }
}

mixin FCParticipatedForumResultMappable {
  String toJson() {
    return FCParticipatedForumResultMapper.ensureInitialized()
        .encodeJson<FCParticipatedForumResult>(
          this as FCParticipatedForumResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCParticipatedForumResultMapper.ensureInitialized()
        .encodeMap<FCParticipatedForumResult>(
          this as FCParticipatedForumResult,
        );
  }

  FCParticipatedForumResultCopyWith<
    FCParticipatedForumResult,
    FCParticipatedForumResult,
    FCParticipatedForumResult
  >
  get copyWith =>
      _FCParticipatedForumResultCopyWithImpl<
        FCParticipatedForumResult,
        FCParticipatedForumResult
      >(this as FCParticipatedForumResult, $identity, $identity);
  @override
  String toString() {
    return FCParticipatedForumResultMapper.ensureInitialized().stringifyValue(
      this as FCParticipatedForumResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCParticipatedForumResultMapper.ensureInitialized().equalsValue(
      this as FCParticipatedForumResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCParticipatedForumResultMapper.ensureInitialized().hashValue(
      this as FCParticipatedForumResult,
    );
  }
}

extension FCParticipatedForumResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCParticipatedForumResult, $Out> {
  FCParticipatedForumResultCopyWith<$R, FCParticipatedForumResult, $Out>
  get $asFCParticipatedForumResult => $base.as(
    (v, t, t2) => _FCParticipatedForumResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCParticipatedForumResultCopyWith<
  $R,
  $In extends FCParticipatedForumResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCForum, FCForumCopyWith<$R, FCForum, FCForum>> get forums;
  @override
  $R call({bool? result, covariant String? resultText, List<FCForum>? forums});
  FCParticipatedForumResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCParticipatedForumResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCParticipatedForumResult, $Out>
    implements
        FCParticipatedForumResultCopyWith<$R, FCParticipatedForumResult, $Out> {
  _FCParticipatedForumResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCParticipatedForumResult> $mapper =
      FCParticipatedForumResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCForum, FCForumCopyWith<$R, FCForum, FCForum>> get forums =>
      ListCopyWith(
        $value.forums,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(forums: v),
      );
  @override
  $R call({bool? result, String? resultText, List<FCForum>? forums}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != null) #resultText: resultText,
      if (forums != null) #forums: forums,
    }),
  );
  @override
  FCParticipatedForumResult $make(CopyWithData data) =>
      FCParticipatedForumResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
        forums: data.get(#forums, or: $value.forums),
      );

  @override
  FCParticipatedForumResultCopyWith<$R2, FCParticipatedForumResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCParticipatedForumResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCMarkAllAsReadResultMapper
    extends ClassMapperBase<FCMarkAllAsReadResult> {
  FCMarkAllAsReadResultMapper._();

  static FCMarkAllAsReadResultMapper? _instance;
  static FCMarkAllAsReadResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCMarkAllAsReadResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCMarkAllAsReadResult';

  static bool _$result(FCMarkAllAsReadResult v) => v.result;
  static const Field<FCMarkAllAsReadResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCMarkAllAsReadResult v) => v.resultText;
  static const Field<FCMarkAllAsReadResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
  );

  @override
  final MappableFields<FCMarkAllAsReadResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCMarkAllAsReadResult _instantiate(DecodingData data) {
    return FCMarkAllAsReadResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCMarkAllAsReadResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCMarkAllAsReadResult>(map);
  }

  static FCMarkAllAsReadResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCMarkAllAsReadResult>(json);
  }
}

mixin FCMarkAllAsReadResultMappable {
  String toJson() {
    return FCMarkAllAsReadResultMapper.ensureInitialized()
        .encodeJson<FCMarkAllAsReadResult>(this as FCMarkAllAsReadResult);
  }

  Map<String, dynamic> toMap() {
    return FCMarkAllAsReadResultMapper.ensureInitialized()
        .encodeMap<FCMarkAllAsReadResult>(this as FCMarkAllAsReadResult);
  }

  FCMarkAllAsReadResultCopyWith<
    FCMarkAllAsReadResult,
    FCMarkAllAsReadResult,
    FCMarkAllAsReadResult
  >
  get copyWith =>
      _FCMarkAllAsReadResultCopyWithImpl<
        FCMarkAllAsReadResult,
        FCMarkAllAsReadResult
      >(this as FCMarkAllAsReadResult, $identity, $identity);
  @override
  String toString() {
    return FCMarkAllAsReadResultMapper.ensureInitialized().stringifyValue(
      this as FCMarkAllAsReadResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCMarkAllAsReadResultMapper.ensureInitialized().equalsValue(
      this as FCMarkAllAsReadResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCMarkAllAsReadResultMapper.ensureInitialized().hashValue(
      this as FCMarkAllAsReadResult,
    );
  }
}

extension FCMarkAllAsReadResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCMarkAllAsReadResult, $Out> {
  FCMarkAllAsReadResultCopyWith<$R, FCMarkAllAsReadResult, $Out>
  get $asFCMarkAllAsReadResult => $base.as(
    (v, t, t2) => _FCMarkAllAsReadResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCMarkAllAsReadResultCopyWith<
  $R,
  $In extends FCMarkAllAsReadResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, covariant String? resultText});
  FCMarkAllAsReadResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCMarkAllAsReadResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCMarkAllAsReadResult, $Out>
    implements FCMarkAllAsReadResultCopyWith<$R, FCMarkAllAsReadResult, $Out> {
  _FCMarkAllAsReadResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCMarkAllAsReadResult> $mapper =
      FCMarkAllAsReadResultMapper.ensureInitialized();
  @override
  $R call({bool? result, String? resultText}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != null) #resultText: resultText,
    }),
  );
  @override
  FCMarkAllAsReadResult $make(CopyWithData data) => FCMarkAllAsReadResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCMarkAllAsReadResultCopyWith<$R2, FCMarkAllAsReadResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCMarkAllAsReadResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCLoginForumResultMapper extends ClassMapperBase<FCLoginForumResult> {
  FCLoginForumResultMapper._();

  static FCLoginForumResultMapper? _instance;
  static FCLoginForumResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCLoginForumResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCLoginForumResult';

  static bool _$result(FCLoginForumResult v) => v.result;
  static const Field<FCLoginForumResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCLoginForumResult v) => v.resultText;
  static const Field<FCLoginForumResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
  );
  static String? _$cookies(FCLoginForumResult v) => v.cookies;
  static const Field<FCLoginForumResult, String> _f$cookies = Field(
    'cookies',
    _$cookies,
    opt: true,
  );

  @override
  final MappableFields<FCLoginForumResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #cookies: _f$cookies,
  };

  static FCLoginForumResult _instantiate(DecodingData data) {
    return FCLoginForumResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      cookies: data.dec(_f$cookies),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCLoginForumResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCLoginForumResult>(map);
  }

  static FCLoginForumResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCLoginForumResult>(json);
  }
}

mixin FCLoginForumResultMappable {
  String toJson() {
    return FCLoginForumResultMapper.ensureInitialized()
        .encodeJson<FCLoginForumResult>(this as FCLoginForumResult);
  }

  Map<String, dynamic> toMap() {
    return FCLoginForumResultMapper.ensureInitialized()
        .encodeMap<FCLoginForumResult>(this as FCLoginForumResult);
  }

  FCLoginForumResultCopyWith<
    FCLoginForumResult,
    FCLoginForumResult,
    FCLoginForumResult
  >
  get copyWith =>
      _FCLoginForumResultCopyWithImpl<FCLoginForumResult, FCLoginForumResult>(
        this as FCLoginForumResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCLoginForumResultMapper.ensureInitialized().stringifyValue(
      this as FCLoginForumResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCLoginForumResultMapper.ensureInitialized().equalsValue(
      this as FCLoginForumResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCLoginForumResultMapper.ensureInitialized().hashValue(
      this as FCLoginForumResult,
    );
  }
}

extension FCLoginForumResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCLoginForumResult, $Out> {
  FCLoginForumResultCopyWith<$R, FCLoginForumResult, $Out>
  get $asFCLoginForumResult => $base.as(
    (v, t, t2) => _FCLoginForumResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCLoginForumResultCopyWith<
  $R,
  $In extends FCLoginForumResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, covariant String? resultText, String? cookies});
  FCLoginForumResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCLoginForumResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCLoginForumResult, $Out>
    implements FCLoginForumResultCopyWith<$R, FCLoginForumResult, $Out> {
  _FCLoginForumResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCLoginForumResult> $mapper =
      FCLoginForumResultMapper.ensureInitialized();
  @override
  $R call({bool? result, String? resultText, Object? cookies = $none}) =>
      $apply(
        FieldCopyWithData({
          if (result != null) #result: result,
          if (resultText != null) #resultText: resultText,
          if (cookies != $none) #cookies: cookies,
        }),
      );
  @override
  FCLoginForumResult $make(CopyWithData data) => FCLoginForumResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    cookies: data.get(#cookies, or: $value.cookies),
  );

  @override
  FCLoginForumResultCopyWith<$R2, FCLoginForumResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCLoginForumResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCIdByUrlResultMapper extends ClassMapperBase<FCIdByUrlResult> {
  FCIdByUrlResultMapper._();

  static FCIdByUrlResultMapper? _instance;
  static FCIdByUrlResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCIdByUrlResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCIdByUrlResult';

  static bool _$result(FCIdByUrlResult v) => v.result;
  static const Field<FCIdByUrlResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCIdByUrlResult v) => v.resultText;
  static const Field<FCIdByUrlResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
  );
  static String? _$topicId(FCIdByUrlResult v) => v.topicId;
  static const Field<FCIdByUrlResult, String> _f$topicId = Field(
    'topicId',
    _$topicId,
    opt: true,
  );
  static String? _$postId(FCIdByUrlResult v) => v.postId;
  static const Field<FCIdByUrlResult, String> _f$postId = Field(
    'postId',
    _$postId,
    opt: true,
  );
  static String? _$forumId(FCIdByUrlResult v) => v.forumId;
  static const Field<FCIdByUrlResult, String> _f$forumId = Field(
    'forumId',
    _$forumId,
    opt: true,
  );

  @override
  final MappableFields<FCIdByUrlResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #topicId: _f$topicId,
    #postId: _f$postId,
    #forumId: _f$forumId,
  };

  static FCIdByUrlResult _instantiate(DecodingData data) {
    return FCIdByUrlResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      topicId: data.dec(_f$topicId),
      postId: data.dec(_f$postId),
      forumId: data.dec(_f$forumId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCIdByUrlResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCIdByUrlResult>(map);
  }

  static FCIdByUrlResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCIdByUrlResult>(json);
  }
}

mixin FCIdByUrlResultMappable {
  String toJson() {
    return FCIdByUrlResultMapper.ensureInitialized()
        .encodeJson<FCIdByUrlResult>(this as FCIdByUrlResult);
  }

  Map<String, dynamic> toMap() {
    return FCIdByUrlResultMapper.ensureInitialized().encodeMap<FCIdByUrlResult>(
      this as FCIdByUrlResult,
    );
  }

  FCIdByUrlResultCopyWith<FCIdByUrlResult, FCIdByUrlResult, FCIdByUrlResult>
  get copyWith =>
      _FCIdByUrlResultCopyWithImpl<FCIdByUrlResult, FCIdByUrlResult>(
        this as FCIdByUrlResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCIdByUrlResultMapper.ensureInitialized().stringifyValue(
      this as FCIdByUrlResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCIdByUrlResultMapper.ensureInitialized().equalsValue(
      this as FCIdByUrlResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCIdByUrlResultMapper.ensureInitialized().hashValue(
      this as FCIdByUrlResult,
    );
  }
}

extension FCIdByUrlResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCIdByUrlResult, $Out> {
  FCIdByUrlResultCopyWith<$R, FCIdByUrlResult, $Out> get $asFCIdByUrlResult =>
      $base.as((v, t, t2) => _FCIdByUrlResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCIdByUrlResultCopyWith<$R, $In extends FCIdByUrlResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({
    bool? result,
    covariant String? resultText,
    String? topicId,
    String? postId,
    String? forumId,
  });
  FCIdByUrlResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCIdByUrlResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCIdByUrlResult, $Out>
    implements FCIdByUrlResultCopyWith<$R, FCIdByUrlResult, $Out> {
  _FCIdByUrlResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCIdByUrlResult> $mapper =
      FCIdByUrlResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    String? resultText,
    Object? topicId = $none,
    Object? postId = $none,
    Object? forumId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != null) #resultText: resultText,
      if (topicId != $none) #topicId: topicId,
      if (postId != $none) #postId: postId,
      if (forumId != $none) #forumId: forumId,
    }),
  );
  @override
  FCIdByUrlResult $make(CopyWithData data) => FCIdByUrlResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    topicId: data.get(#topicId, or: $value.topicId),
    postId: data.get(#postId, or: $value.postId),
    forumId: data.get(#forumId, or: $value.forumId),
  );

  @override
  FCIdByUrlResultCopyWith<$R2, FCIdByUrlResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCIdByUrlResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUrlByIdResultMapper extends ClassMapperBase<FCUrlByIdResult> {
  FCUrlByIdResultMapper._();

  static FCUrlByIdResultMapper? _instance;
  static FCUrlByIdResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUrlByIdResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUrlByIdResult';

  static bool _$result(FCUrlByIdResult v) => v.result;
  static const Field<FCUrlByIdResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUrlByIdResult v) => v.resultText;
  static const Field<FCUrlByIdResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
  );
  static String? _$url(FCUrlByIdResult v) => v.url;
  static const Field<FCUrlByIdResult, String> _f$url = Field(
    'url',
    _$url,
    opt: true,
  );

  @override
  final MappableFields<FCUrlByIdResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #url: _f$url,
  };

  static FCUrlByIdResult _instantiate(DecodingData data) {
    return FCUrlByIdResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      url: data.dec(_f$url),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUrlByIdResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUrlByIdResult>(map);
  }

  static FCUrlByIdResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUrlByIdResult>(json);
  }
}

mixin FCUrlByIdResultMappable {
  String toJson() {
    return FCUrlByIdResultMapper.ensureInitialized()
        .encodeJson<FCUrlByIdResult>(this as FCUrlByIdResult);
  }

  Map<String, dynamic> toMap() {
    return FCUrlByIdResultMapper.ensureInitialized().encodeMap<FCUrlByIdResult>(
      this as FCUrlByIdResult,
    );
  }

  FCUrlByIdResultCopyWith<FCUrlByIdResult, FCUrlByIdResult, FCUrlByIdResult>
  get copyWith =>
      _FCUrlByIdResultCopyWithImpl<FCUrlByIdResult, FCUrlByIdResult>(
        this as FCUrlByIdResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCUrlByIdResultMapper.ensureInitialized().stringifyValue(
      this as FCUrlByIdResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUrlByIdResultMapper.ensureInitialized().equalsValue(
      this as FCUrlByIdResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUrlByIdResultMapper.ensureInitialized().hashValue(
      this as FCUrlByIdResult,
    );
  }
}

extension FCUrlByIdResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUrlByIdResult, $Out> {
  FCUrlByIdResultCopyWith<$R, FCUrlByIdResult, $Out> get $asFCUrlByIdResult =>
      $base.as((v, t, t2) => _FCUrlByIdResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCUrlByIdResultCopyWith<$R, $In extends FCUrlByIdResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, covariant String? resultText, String? url});
  FCUrlByIdResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUrlByIdResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUrlByIdResult, $Out>
    implements FCUrlByIdResultCopyWith<$R, FCUrlByIdResult, $Out> {
  _FCUrlByIdResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUrlByIdResult> $mapper =
      FCUrlByIdResultMapper.ensureInitialized();
  @override
  $R call({bool? result, String? resultText, Object? url = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != null) #resultText: resultText,
      if (url != $none) #url: url,
    }),
  );
  @override
  FCUrlByIdResult $make(CopyWithData data) => FCUrlByIdResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    url: data.get(#url, or: $value.url),
  );

  @override
  FCUrlByIdResultCopyWith<$R2, FCUrlByIdResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCUrlByIdResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCForumStatusResultMapper extends ClassMapperBase<FCForumStatusResult> {
  FCForumStatusResultMapper._();

  static FCForumStatusResultMapper? _instance;
  static FCForumStatusResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCForumStatusResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCForumMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCForumStatusResult';

  static bool _$result(FCForumStatusResult v) => v.result;
  static const Field<FCForumStatusResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCForumStatusResult v) => v.resultText;
  static const Field<FCForumStatusResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
  );
  static List<FCForum> _$forums(FCForumStatusResult v) => v.forums;
  static const Field<FCForumStatusResult, List<FCForum>> _f$forums = Field(
    'forums',
    _$forums,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCForumStatusResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #forums: _f$forums,
  };

  static FCForumStatusResult _instantiate(DecodingData data) {
    return FCForumStatusResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      forums: data.dec(_f$forums),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCForumStatusResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCForumStatusResult>(map);
  }

  static FCForumStatusResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCForumStatusResult>(json);
  }
}

mixin FCForumStatusResultMappable {
  String toJson() {
    return FCForumStatusResultMapper.ensureInitialized()
        .encodeJson<FCForumStatusResult>(this as FCForumStatusResult);
  }

  Map<String, dynamic> toMap() {
    return FCForumStatusResultMapper.ensureInitialized()
        .encodeMap<FCForumStatusResult>(this as FCForumStatusResult);
  }

  FCForumStatusResultCopyWith<
    FCForumStatusResult,
    FCForumStatusResult,
    FCForumStatusResult
  >
  get copyWith =>
      _FCForumStatusResultCopyWithImpl<
        FCForumStatusResult,
        FCForumStatusResult
      >(this as FCForumStatusResult, $identity, $identity);
  @override
  String toString() {
    return FCForumStatusResultMapper.ensureInitialized().stringifyValue(
      this as FCForumStatusResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCForumStatusResultMapper.ensureInitialized().equalsValue(
      this as FCForumStatusResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCForumStatusResultMapper.ensureInitialized().hashValue(
      this as FCForumStatusResult,
    );
  }
}

extension FCForumStatusResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCForumStatusResult, $Out> {
  FCForumStatusResultCopyWith<$R, FCForumStatusResult, $Out>
  get $asFCForumStatusResult => $base.as(
    (v, t, t2) => _FCForumStatusResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCForumStatusResultCopyWith<
  $R,
  $In extends FCForumStatusResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, FCForum, FCForumCopyWith<$R, FCForum, FCForum>> get forums;
  @override
  $R call({bool? result, covariant String? resultText, List<FCForum>? forums});
  FCForumStatusResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCForumStatusResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCForumStatusResult, $Out>
    implements FCForumStatusResultCopyWith<$R, FCForumStatusResult, $Out> {
  _FCForumStatusResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCForumStatusResult> $mapper =
      FCForumStatusResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, FCForum, FCForumCopyWith<$R, FCForum, FCForum>> get forums =>
      ListCopyWith(
        $value.forums,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(forums: v),
      );
  @override
  $R call({bool? result, String? resultText, List<FCForum>? forums}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != null) #resultText: resultText,
      if (forums != null) #forums: forums,
    }),
  );
  @override
  FCForumStatusResult $make(CopyWithData data) => FCForumStatusResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    forums: data.get(#forums, or: $value.forums),
  );

  @override
  FCForumStatusResultCopyWith<$R2, FCForumStatusResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCForumStatusResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

