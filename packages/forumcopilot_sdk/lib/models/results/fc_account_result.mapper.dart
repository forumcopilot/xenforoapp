// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_account_result.dart';

class FCSigninResultMapper extends ClassMapperBase<FCSigninResult> {
  FCSigninResultMapper._();

  static FCSigninResultMapper? _instance;
  static FCSigninResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSigninResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSigninResult';

  static bool _$result(FCSigninResult v) => v.result;
  static const Field<FCSigninResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSigninResult v) => v.resultText;
  static const Field<FCSigninResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String? _$userId(FCSigninResult v) => v.userId;
  static const Field<FCSigninResult, String> _f$userId = Field(
    'userId',
    _$userId,
    opt: true,
  );
  static String? _$email(FCSigninResult v) => v.email;
  static const Field<FCSigninResult, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static String? _$userType(FCSigninResult v) => v.userType;
  static const Field<FCSigninResult, String> _f$userType = Field(
    'userType',
    _$userType,
    opt: true,
  );
  static String? _$username(FCSigninResult v) => v.username;
  static const Field<FCSigninResult, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
  );
  static String? _$login(FCSigninResult v) => v.login;
  static const Field<FCSigninResult, String> _f$login = Field(
    'login',
    _$login,
    opt: true,
  );
  static List<String>? _$usergroupId(FCSigninResult v) => v.usergroupId;
  static const Field<FCSigninResult, List<String>> _f$usergroupId = Field(
    'usergroupId',
    _$usergroupId,
    opt: true,
  );
  static String? _$iconUrl(FCSigninResult v) => v.iconUrl;
  static const Field<FCSigninResult, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static int _$postCount(FCSigninResult v) => v.postCount;
  static const Field<FCSigninResult, int> _f$postCount = Field(
    'postCount',
    _$postCount,
    opt: true,
    def: 0,
  );
  static bool _$canPm(FCSigninResult v) => v.canPm;
  static const Field<FCSigninResult, bool> _f$canPm = Field(
    'canPm',
    _$canPm,
    opt: true,
    def: false,
  );
  static bool _$canSendPm(FCSigninResult v) => v.canSendPm;
  static const Field<FCSigninResult, bool> _f$canSendPm = Field(
    'canSendPm',
    _$canSendPm,
    opt: true,
    def: false,
  );
  static bool _$canModerate(FCSigninResult v) => v.canModerate;
  static const Field<FCSigninResult, bool> _f$canModerate = Field(
    'canModerate',
    _$canModerate,
    opt: true,
    def: false,
  );
  static bool _$canSearch(FCSigninResult v) => v.canSearch;
  static const Field<FCSigninResult, bool> _f$canSearch = Field(
    'canSearch',
    _$canSearch,
    opt: true,
    def: false,
  );
  static bool _$canWhosonline(FCSigninResult v) => v.canWhosonline;
  static const Field<FCSigninResult, bool> _f$canWhosonline = Field(
    'canWhosonline',
    _$canWhosonline,
    opt: true,
    def: false,
  );
  static bool _$canProfile(FCSigninResult v) => v.canProfile;
  static const Field<FCSigninResult, bool> _f$canProfile = Field(
    'canProfile',
    _$canProfile,
    opt: true,
    def: false,
  );
  static bool _$canUploadAvatar(FCSigninResult v) => v.canUploadAvatar;
  static const Field<FCSigninResult, bool> _f$canUploadAvatar = Field(
    'canUploadAvatar',
    _$canUploadAvatar,
    opt: true,
    def: false,
  );
  static int _$maxAttachment(FCSigninResult v) => v.maxAttachment;
  static const Field<FCSigninResult, int> _f$maxAttachment = Field(
    'maxAttachment',
    _$maxAttachment,
    opt: true,
    def: 0,
  );
  static int _$maxPngSize(FCSigninResult v) => v.maxPngSize;
  static const Field<FCSigninResult, int> _f$maxPngSize = Field(
    'maxPngSize',
    _$maxPngSize,
    opt: true,
    def: 0,
  );
  static int _$maxJpgSize(FCSigninResult v) => v.maxJpgSize;
  static const Field<FCSigninResult, int> _f$maxJpgSize = Field(
    'maxJpgSize',
    _$maxJpgSize,
    opt: true,
    def: 0,
  );
  static bool _$register(FCSigninResult v) => v.register;
  static const Field<FCSigninResult, bool> _f$register = Field(
    'register',
    _$register,
    opt: true,
    def: false,
  );
  static String _$status(FCSigninResult v) => v.status;
  static const Field<FCSigninResult, String> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: '',
  );

  @override
  final MappableFields<FCSigninResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #userId: _f$userId,
    #email: _f$email,
    #userType: _f$userType,
    #username: _f$username,
    #login: _f$login,
    #usergroupId: _f$usergroupId,
    #iconUrl: _f$iconUrl,
    #postCount: _f$postCount,
    #canPm: _f$canPm,
    #canSendPm: _f$canSendPm,
    #canModerate: _f$canModerate,
    #canSearch: _f$canSearch,
    #canWhosonline: _f$canWhosonline,
    #canProfile: _f$canProfile,
    #canUploadAvatar: _f$canUploadAvatar,
    #maxAttachment: _f$maxAttachment,
    #maxPngSize: _f$maxPngSize,
    #maxJpgSize: _f$maxJpgSize,
    #register: _f$register,
    #status: _f$status,
  };

  static FCSigninResult _instantiate(DecodingData data) {
    return FCSigninResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      userId: data.dec(_f$userId),
      email: data.dec(_f$email),
      userType: data.dec(_f$userType),
      username: data.dec(_f$username),
      login: data.dec(_f$login),
      usergroupId: data.dec(_f$usergroupId),
      iconUrl: data.dec(_f$iconUrl),
      postCount: data.dec(_f$postCount),
      canPm: data.dec(_f$canPm),
      canSendPm: data.dec(_f$canSendPm),
      canModerate: data.dec(_f$canModerate),
      canSearch: data.dec(_f$canSearch),
      canWhosonline: data.dec(_f$canWhosonline),
      canProfile: data.dec(_f$canProfile),
      canUploadAvatar: data.dec(_f$canUploadAvatar),
      maxAttachment: data.dec(_f$maxAttachment),
      maxPngSize: data.dec(_f$maxPngSize),
      maxJpgSize: data.dec(_f$maxJpgSize),
      register: data.dec(_f$register),
      status: data.dec(_f$status),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSigninResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSigninResult>(map);
  }

  static FCSigninResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCSigninResult>(json);
  }
}

mixin FCSigninResultMappable {
  String toJson() {
    return FCSigninResultMapper.ensureInitialized().encodeJson<FCSigninResult>(
      this as FCSigninResult,
    );
  }

  Map<String, dynamic> toMap() {
    return FCSigninResultMapper.ensureInitialized().encodeMap<FCSigninResult>(
      this as FCSigninResult,
    );
  }

  FCSigninResultCopyWith<FCSigninResult, FCSigninResult, FCSigninResult>
  get copyWith => _FCSigninResultCopyWithImpl<FCSigninResult, FCSigninResult>(
    this as FCSigninResult,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCSigninResultMapper.ensureInitialized().stringifyValue(
      this as FCSigninResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSigninResultMapper.ensureInitialized().equalsValue(
      this as FCSigninResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSigninResultMapper.ensureInitialized().hashValue(
      this as FCSigninResult,
    );
  }
}

extension FCSigninResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSigninResult, $Out> {
  FCSigninResultCopyWith<$R, FCSigninResult, $Out> get $asFCSigninResult =>
      $base.as((v, t, t2) => _FCSigninResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCSigninResultCopyWith<$R, $In extends FCSigninResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get usergroupId;
  @override
  $R call({
    bool? result,
    String? resultText,
    String? userId,
    String? email,
    String? userType,
    String? username,
    String? login,
    List<String>? usergroupId,
    String? iconUrl,
    int? postCount,
    bool? canPm,
    bool? canSendPm,
    bool? canModerate,
    bool? canSearch,
    bool? canWhosonline,
    bool? canProfile,
    bool? canUploadAvatar,
    int? maxAttachment,
    int? maxPngSize,
    int? maxJpgSize,
    bool? register,
    String? status,
  });
  FCSigninResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSigninResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSigninResult, $Out>
    implements FCSigninResultCopyWith<$R, FCSigninResult, $Out> {
  _FCSigninResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSigninResult> $mapper =
      FCSigninResultMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get usergroupId => $value.usergroupId != null
      ? ListCopyWith(
          $value.usergroupId!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(usergroupId: v),
        )
      : null;
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    Object? userId = $none,
    Object? email = $none,
    Object? userType = $none,
    Object? username = $none,
    Object? login = $none,
    Object? usergroupId = $none,
    Object? iconUrl = $none,
    int? postCount,
    bool? canPm,
    bool? canSendPm,
    bool? canModerate,
    bool? canSearch,
    bool? canWhosonline,
    bool? canProfile,
    bool? canUploadAvatar,
    int? maxAttachment,
    int? maxPngSize,
    int? maxJpgSize,
    bool? register,
    String? status,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (userId != $none) #userId: userId,
      if (email != $none) #email: email,
      if (userType != $none) #userType: userType,
      if (username != $none) #username: username,
      if (login != $none) #login: login,
      if (usergroupId != $none) #usergroupId: usergroupId,
      if (iconUrl != $none) #iconUrl: iconUrl,
      if (postCount != null) #postCount: postCount,
      if (canPm != null) #canPm: canPm,
      if (canSendPm != null) #canSendPm: canSendPm,
      if (canModerate != null) #canModerate: canModerate,
      if (canSearch != null) #canSearch: canSearch,
      if (canWhosonline != null) #canWhosonline: canWhosonline,
      if (canProfile != null) #canProfile: canProfile,
      if (canUploadAvatar != null) #canUploadAvatar: canUploadAvatar,
      if (maxAttachment != null) #maxAttachment: maxAttachment,
      if (maxPngSize != null) #maxPngSize: maxPngSize,
      if (maxJpgSize != null) #maxJpgSize: maxJpgSize,
      if (register != null) #register: register,
      if (status != null) #status: status,
    }),
  );
  @override
  FCSigninResult $make(CopyWithData data) => FCSigninResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    userId: data.get(#userId, or: $value.userId),
    email: data.get(#email, or: $value.email),
    userType: data.get(#userType, or: $value.userType),
    username: data.get(#username, or: $value.username),
    login: data.get(#login, or: $value.login),
    usergroupId: data.get(#usergroupId, or: $value.usergroupId),
    iconUrl: data.get(#iconUrl, or: $value.iconUrl),
    postCount: data.get(#postCount, or: $value.postCount),
    canPm: data.get(#canPm, or: $value.canPm),
    canSendPm: data.get(#canSendPm, or: $value.canSendPm),
    canModerate: data.get(#canModerate, or: $value.canModerate),
    canSearch: data.get(#canSearch, or: $value.canSearch),
    canWhosonline: data.get(#canWhosonline, or: $value.canWhosonline),
    canProfile: data.get(#canProfile, or: $value.canProfile),
    canUploadAvatar: data.get(#canUploadAvatar, or: $value.canUploadAvatar),
    maxAttachment: data.get(#maxAttachment, or: $value.maxAttachment),
    maxPngSize: data.get(#maxPngSize, or: $value.maxPngSize),
    maxJpgSize: data.get(#maxJpgSize, or: $value.maxJpgSize),
    register: data.get(#register, or: $value.register),
    status: data.get(#status, or: $value.status),
  );

  @override
  FCSigninResultCopyWith<$R2, FCSigninResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCSigninResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCForgetPasswordResultMapper
    extends ClassMapperBase<FCForgetPasswordResult> {
  FCForgetPasswordResultMapper._();

  static FCForgetPasswordResultMapper? _instance;
  static FCForgetPasswordResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCForgetPasswordResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCForgetPasswordResult';

  static bool _$result(FCForgetPasswordResult v) => v.result;
  static const Field<FCForgetPasswordResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCForgetPasswordResult v) => v.resultText;
  static const Field<FCForgetPasswordResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$verified(FCForgetPasswordResult v) => v.verified;
  static const Field<FCForgetPasswordResult, bool> _f$verified = Field(
    'verified',
    _$verified,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<FCForgetPasswordResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #verified: _f$verified,
  };

  static FCForgetPasswordResult _instantiate(DecodingData data) {
    return FCForgetPasswordResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      verified: data.dec(_f$verified),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCForgetPasswordResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCForgetPasswordResult>(map);
  }

  static FCForgetPasswordResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCForgetPasswordResult>(json);
  }
}

mixin FCForgetPasswordResultMappable {
  String toJson() {
    return FCForgetPasswordResultMapper.ensureInitialized()
        .encodeJson<FCForgetPasswordResult>(this as FCForgetPasswordResult);
  }

  Map<String, dynamic> toMap() {
    return FCForgetPasswordResultMapper.ensureInitialized()
        .encodeMap<FCForgetPasswordResult>(this as FCForgetPasswordResult);
  }

  FCForgetPasswordResultCopyWith<
    FCForgetPasswordResult,
    FCForgetPasswordResult,
    FCForgetPasswordResult
  >
  get copyWith =>
      _FCForgetPasswordResultCopyWithImpl<
        FCForgetPasswordResult,
        FCForgetPasswordResult
      >(this as FCForgetPasswordResult, $identity, $identity);
  @override
  String toString() {
    return FCForgetPasswordResultMapper.ensureInitialized().stringifyValue(
      this as FCForgetPasswordResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCForgetPasswordResultMapper.ensureInitialized().equalsValue(
      this as FCForgetPasswordResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCForgetPasswordResultMapper.ensureInitialized().hashValue(
      this as FCForgetPasswordResult,
    );
  }
}

extension FCForgetPasswordResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCForgetPasswordResult, $Out> {
  FCForgetPasswordResultCopyWith<$R, FCForgetPasswordResult, $Out>
  get $asFCForgetPasswordResult => $base.as(
    (v, t, t2) => _FCForgetPasswordResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCForgetPasswordResultCopyWith<
  $R,
  $In extends FCForgetPasswordResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText, bool? verified});
  FCForgetPasswordResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCForgetPasswordResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCForgetPasswordResult, $Out>
    implements
        FCForgetPasswordResultCopyWith<$R, FCForgetPasswordResult, $Out> {
  _FCForgetPasswordResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCForgetPasswordResult> $mapper =
      FCForgetPasswordResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none, bool? verified}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (verified != null) #verified: verified,
    }),
  );
  @override
  FCForgetPasswordResult $make(CopyWithData data) => FCForgetPasswordResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    verified: data.get(#verified, or: $value.verified),
  );

  @override
  FCForgetPasswordResultCopyWith<$R2, FCForgetPasswordResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCForgetPasswordResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUpdatePasswordResultMapper
    extends ClassMapperBase<FCUpdatePasswordResult> {
  FCUpdatePasswordResultMapper._();

  static FCUpdatePasswordResultMapper? _instance;
  static FCUpdatePasswordResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUpdatePasswordResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUpdatePasswordResult';

  static bool _$result(FCUpdatePasswordResult v) => v.result;
  static const Field<FCUpdatePasswordResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUpdatePasswordResult v) => v.resultText;
  static const Field<FCUpdatePasswordResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCUpdatePasswordResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCUpdatePasswordResult _instantiate(DecodingData data) {
    return FCUpdatePasswordResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUpdatePasswordResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUpdatePasswordResult>(map);
  }

  static FCUpdatePasswordResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUpdatePasswordResult>(json);
  }
}

mixin FCUpdatePasswordResultMappable {
  String toJson() {
    return FCUpdatePasswordResultMapper.ensureInitialized()
        .encodeJson<FCUpdatePasswordResult>(this as FCUpdatePasswordResult);
  }

  Map<String, dynamic> toMap() {
    return FCUpdatePasswordResultMapper.ensureInitialized()
        .encodeMap<FCUpdatePasswordResult>(this as FCUpdatePasswordResult);
  }

  FCUpdatePasswordResultCopyWith<
    FCUpdatePasswordResult,
    FCUpdatePasswordResult,
    FCUpdatePasswordResult
  >
  get copyWith =>
      _FCUpdatePasswordResultCopyWithImpl<
        FCUpdatePasswordResult,
        FCUpdatePasswordResult
      >(this as FCUpdatePasswordResult, $identity, $identity);
  @override
  String toString() {
    return FCUpdatePasswordResultMapper.ensureInitialized().stringifyValue(
      this as FCUpdatePasswordResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUpdatePasswordResultMapper.ensureInitialized().equalsValue(
      this as FCUpdatePasswordResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUpdatePasswordResultMapper.ensureInitialized().hashValue(
      this as FCUpdatePasswordResult,
    );
  }
}

extension FCUpdatePasswordResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUpdatePasswordResult, $Out> {
  FCUpdatePasswordResultCopyWith<$R, FCUpdatePasswordResult, $Out>
  get $asFCUpdatePasswordResult => $base.as(
    (v, t, t2) => _FCUpdatePasswordResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUpdatePasswordResultCopyWith<
  $R,
  $In extends FCUpdatePasswordResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCUpdatePasswordResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUpdatePasswordResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUpdatePasswordResult, $Out>
    implements
        FCUpdatePasswordResultCopyWith<$R, FCUpdatePasswordResult, $Out> {
  _FCUpdatePasswordResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUpdatePasswordResult> $mapper =
      FCUpdatePasswordResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCUpdatePasswordResult $make(CopyWithData data) => FCUpdatePasswordResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCUpdatePasswordResultCopyWith<$R2, FCUpdatePasswordResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCUpdatePasswordResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUpdateProfileResultMapper
    extends ClassMapperBase<FCUpdateProfileResult> {
  FCUpdateProfileResultMapper._();

  static FCUpdateProfileResultMapper? _instance;
  static FCUpdateProfileResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUpdateProfileResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUpdateProfileResult';

  static bool _$result(FCUpdateProfileResult v) => v.result;
  static const Field<FCUpdateProfileResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUpdateProfileResult v) => v.resultText;
  static const Field<FCUpdateProfileResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCUpdateProfileResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCUpdateProfileResult _instantiate(DecodingData data) {
    return FCUpdateProfileResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUpdateProfileResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUpdateProfileResult>(map);
  }

  static FCUpdateProfileResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUpdateProfileResult>(json);
  }
}

mixin FCUpdateProfileResultMappable {
  String toJson() {
    return FCUpdateProfileResultMapper.ensureInitialized()
        .encodeJson<FCUpdateProfileResult>(this as FCUpdateProfileResult);
  }

  Map<String, dynamic> toMap() {
    return FCUpdateProfileResultMapper.ensureInitialized()
        .encodeMap<FCUpdateProfileResult>(this as FCUpdateProfileResult);
  }

  FCUpdateProfileResultCopyWith<
    FCUpdateProfileResult,
    FCUpdateProfileResult,
    FCUpdateProfileResult
  >
  get copyWith =>
      _FCUpdateProfileResultCopyWithImpl<
        FCUpdateProfileResult,
        FCUpdateProfileResult
      >(this as FCUpdateProfileResult, $identity, $identity);
  @override
  String toString() {
    return FCUpdateProfileResultMapper.ensureInitialized().stringifyValue(
      this as FCUpdateProfileResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUpdateProfileResultMapper.ensureInitialized().equalsValue(
      this as FCUpdateProfileResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUpdateProfileResultMapper.ensureInitialized().hashValue(
      this as FCUpdateProfileResult,
    );
  }
}

extension FCUpdateProfileResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUpdateProfileResult, $Out> {
  FCUpdateProfileResultCopyWith<$R, FCUpdateProfileResult, $Out>
  get $asFCUpdateProfileResult => $base.as(
    (v, t, t2) => _FCUpdateProfileResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUpdateProfileResultCopyWith<
  $R,
  $In extends FCUpdateProfileResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCUpdateProfileResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUpdateProfileResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUpdateProfileResult, $Out>
    implements FCUpdateProfileResultCopyWith<$R, FCUpdateProfileResult, $Out> {
  _FCUpdateProfileResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUpdateProfileResult> $mapper =
      FCUpdateProfileResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCUpdateProfileResult $make(CopyWithData data) => FCUpdateProfileResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCUpdateProfileResultCopyWith<$R2, FCUpdateProfileResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCUpdateProfileResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUpdatePasswordSSOResultMapper
    extends ClassMapperBase<FCUpdatePasswordSSOResult> {
  FCUpdatePasswordSSOResultMapper._();

  static FCUpdatePasswordSSOResultMapper? _instance;
  static FCUpdatePasswordSSOResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCUpdatePasswordSSOResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUpdatePasswordSSOResult';

  static bool _$result(FCUpdatePasswordSSOResult v) => v.result;
  static const Field<FCUpdatePasswordSSOResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUpdatePasswordSSOResult v) => v.resultText;
  static const Field<FCUpdatePasswordSSOResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCUpdatePasswordSSOResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCUpdatePasswordSSOResult _instantiate(DecodingData data) {
    return FCUpdatePasswordSSOResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUpdatePasswordSSOResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUpdatePasswordSSOResult>(map);
  }

  static FCUpdatePasswordSSOResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUpdatePasswordSSOResult>(json);
  }
}

mixin FCUpdatePasswordSSOResultMappable {
  String toJson() {
    return FCUpdatePasswordSSOResultMapper.ensureInitialized()
        .encodeJson<FCUpdatePasswordSSOResult>(
          this as FCUpdatePasswordSSOResult,
        );
  }

  Map<String, dynamic> toMap() {
    return FCUpdatePasswordSSOResultMapper.ensureInitialized()
        .encodeMap<FCUpdatePasswordSSOResult>(
          this as FCUpdatePasswordSSOResult,
        );
  }

  FCUpdatePasswordSSOResultCopyWith<
    FCUpdatePasswordSSOResult,
    FCUpdatePasswordSSOResult,
    FCUpdatePasswordSSOResult
  >
  get copyWith =>
      _FCUpdatePasswordSSOResultCopyWithImpl<
        FCUpdatePasswordSSOResult,
        FCUpdatePasswordSSOResult
      >(this as FCUpdatePasswordSSOResult, $identity, $identity);
  @override
  String toString() {
    return FCUpdatePasswordSSOResultMapper.ensureInitialized().stringifyValue(
      this as FCUpdatePasswordSSOResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUpdatePasswordSSOResultMapper.ensureInitialized().equalsValue(
      this as FCUpdatePasswordSSOResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUpdatePasswordSSOResultMapper.ensureInitialized().hashValue(
      this as FCUpdatePasswordSSOResult,
    );
  }
}

extension FCUpdatePasswordSSOResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUpdatePasswordSSOResult, $Out> {
  FCUpdatePasswordSSOResultCopyWith<$R, FCUpdatePasswordSSOResult, $Out>
  get $asFCUpdatePasswordSSOResult => $base.as(
    (v, t, t2) => _FCUpdatePasswordSSOResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUpdatePasswordSSOResultCopyWith<
  $R,
  $In extends FCUpdatePasswordSSOResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCUpdatePasswordSSOResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUpdatePasswordSSOResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUpdatePasswordSSOResult, $Out>
    implements
        FCUpdatePasswordSSOResultCopyWith<$R, FCUpdatePasswordSSOResult, $Out> {
  _FCUpdatePasswordSSOResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUpdatePasswordSSOResult> $mapper =
      FCUpdatePasswordSSOResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCUpdatePasswordSSOResult $make(CopyWithData data) =>
      FCUpdatePasswordSSOResult(
        result: data.get(#result, or: $value.result),
        resultText: data.get(#resultText, or: $value.resultText),
      );

  @override
  FCUpdatePasswordSSOResultCopyWith<$R2, FCUpdatePasswordSSOResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCUpdatePasswordSSOResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUpdateEmailResultMapper extends ClassMapperBase<FCUpdateEmailResult> {
  FCUpdateEmailResultMapper._();

  static FCUpdateEmailResultMapper? _instance;
  static FCUpdateEmailResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUpdateEmailResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUpdateEmailResult';

  static bool _$result(FCUpdateEmailResult v) => v.result;
  static const Field<FCUpdateEmailResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUpdateEmailResult v) => v.resultText;
  static const Field<FCUpdateEmailResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCUpdateEmailResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCUpdateEmailResult _instantiate(DecodingData data) {
    return FCUpdateEmailResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUpdateEmailResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUpdateEmailResult>(map);
  }

  static FCUpdateEmailResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUpdateEmailResult>(json);
  }
}

mixin FCUpdateEmailResultMappable {
  String toJson() {
    return FCUpdateEmailResultMapper.ensureInitialized()
        .encodeJson<FCUpdateEmailResult>(this as FCUpdateEmailResult);
  }

  Map<String, dynamic> toMap() {
    return FCUpdateEmailResultMapper.ensureInitialized()
        .encodeMap<FCUpdateEmailResult>(this as FCUpdateEmailResult);
  }

  FCUpdateEmailResultCopyWith<
    FCUpdateEmailResult,
    FCUpdateEmailResult,
    FCUpdateEmailResult
  >
  get copyWith =>
      _FCUpdateEmailResultCopyWithImpl<
        FCUpdateEmailResult,
        FCUpdateEmailResult
      >(this as FCUpdateEmailResult, $identity, $identity);
  @override
  String toString() {
    return FCUpdateEmailResultMapper.ensureInitialized().stringifyValue(
      this as FCUpdateEmailResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUpdateEmailResultMapper.ensureInitialized().equalsValue(
      this as FCUpdateEmailResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUpdateEmailResultMapper.ensureInitialized().hashValue(
      this as FCUpdateEmailResult,
    );
  }
}

extension FCUpdateEmailResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUpdateEmailResult, $Out> {
  FCUpdateEmailResultCopyWith<$R, FCUpdateEmailResult, $Out>
  get $asFCUpdateEmailResult => $base.as(
    (v, t, t2) => _FCUpdateEmailResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUpdateEmailResultCopyWith<
  $R,
  $In extends FCUpdateEmailResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCUpdateEmailResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUpdateEmailResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUpdateEmailResult, $Out>
    implements FCUpdateEmailResultCopyWith<$R, FCUpdateEmailResult, $Out> {
  _FCUpdateEmailResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUpdateEmailResult> $mapper =
      FCUpdateEmailResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCUpdateEmailResult $make(CopyWithData data) => FCUpdateEmailResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCUpdateEmailResultCopyWith<$R2, FCUpdateEmailResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCUpdateEmailResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCRegisterResultMapper extends ClassMapperBase<FCRegisterResult> {
  FCRegisterResultMapper._();

  static FCRegisterResultMapper? _instance;
  static FCRegisterResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCRegisterResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCRegisterResult';

  static bool _$result(FCRegisterResult v) => v.result;
  static const Field<FCRegisterResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCRegisterResult v) => v.resultText;
  static const Field<FCRegisterResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String _$previewTopicId(FCRegisterResult v) => v.previewTopicId;
  static const Field<FCRegisterResult, String> _f$previewTopicId = Field(
    'previewTopicId',
    _$previewTopicId,
    opt: true,
    def: '',
  );
  static String? _$userId(FCRegisterResult v) => v.userId;
  static const Field<FCRegisterResult, String> _f$userId = Field(
    'userId',
    _$userId,
    opt: true,
  );
  static String? _$username(FCRegisterResult v) => v.username;
  static const Field<FCRegisterResult, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
  );
  static String? _$userState(FCRegisterResult v) => v.userState;
  static const Field<FCRegisterResult, String> _f$userState = Field(
    'userState',
    _$userState,
    opt: true,
  );
  static bool? _$requiresEmailConfirmation(FCRegisterResult v) =>
      v.requiresEmailConfirmation;
  static const Field<FCRegisterResult, bool> _f$requiresEmailConfirmation =
      Field(
        'requiresEmailConfirmation',
        _$requiresEmailConfirmation,
        opt: true,
      );
  static bool? _$requiresManualApproval(FCRegisterResult v) =>
      v.requiresManualApproval;
  static const Field<FCRegisterResult, bool> _f$requiresManualApproval = Field(
    'requiresManualApproval',
    _$requiresManualApproval,
    opt: true,
  );
  static String? _$message(FCRegisterResult v) => v.message;
  static const Field<FCRegisterResult, String> _f$message = Field(
    'message',
    _$message,
    opt: true,
  );

  @override
  final MappableFields<FCRegisterResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #previewTopicId: _f$previewTopicId,
    #userId: _f$userId,
    #username: _f$username,
    #userState: _f$userState,
    #requiresEmailConfirmation: _f$requiresEmailConfirmation,
    #requiresManualApproval: _f$requiresManualApproval,
    #message: _f$message,
  };

  static FCRegisterResult _instantiate(DecodingData data) {
    return FCRegisterResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      previewTopicId: data.dec(_f$previewTopicId),
      userId: data.dec(_f$userId),
      username: data.dec(_f$username),
      userState: data.dec(_f$userState),
      requiresEmailConfirmation: data.dec(_f$requiresEmailConfirmation),
      requiresManualApproval: data.dec(_f$requiresManualApproval),
      message: data.dec(_f$message),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCRegisterResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCRegisterResult>(map);
  }

  static FCRegisterResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCRegisterResult>(json);
  }
}

mixin FCRegisterResultMappable {
  String toJson() {
    return FCRegisterResultMapper.ensureInitialized()
        .encodeJson<FCRegisterResult>(this as FCRegisterResult);
  }

  Map<String, dynamic> toMap() {
    return FCRegisterResultMapper.ensureInitialized()
        .encodeMap<FCRegisterResult>(this as FCRegisterResult);
  }

  FCRegisterResultCopyWith<FCRegisterResult, FCRegisterResult, FCRegisterResult>
  get copyWith =>
      _FCRegisterResultCopyWithImpl<FCRegisterResult, FCRegisterResult>(
        this as FCRegisterResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCRegisterResultMapper.ensureInitialized().stringifyValue(
      this as FCRegisterResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCRegisterResultMapper.ensureInitialized().equalsValue(
      this as FCRegisterResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCRegisterResultMapper.ensureInitialized().hashValue(
      this as FCRegisterResult,
    );
  }
}

extension FCRegisterResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCRegisterResult, $Out> {
  FCRegisterResultCopyWith<$R, FCRegisterResult, $Out>
  get $asFCRegisterResult =>
      $base.as((v, t, t2) => _FCRegisterResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCRegisterResultCopyWith<$R, $In extends FCRegisterResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({
    bool? result,
    String? resultText,
    String? previewTopicId,
    String? userId,
    String? username,
    String? userState,
    bool? requiresEmailConfirmation,
    bool? requiresManualApproval,
    String? message,
  });
  FCRegisterResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCRegisterResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCRegisterResult, $Out>
    implements FCRegisterResultCopyWith<$R, FCRegisterResult, $Out> {
  _FCRegisterResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCRegisterResult> $mapper =
      FCRegisterResultMapper.ensureInitialized();
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    String? previewTopicId,
    Object? userId = $none,
    Object? username = $none,
    Object? userState = $none,
    Object? requiresEmailConfirmation = $none,
    Object? requiresManualApproval = $none,
    Object? message = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (previewTopicId != null) #previewTopicId: previewTopicId,
      if (userId != $none) #userId: userId,
      if (username != $none) #username: username,
      if (userState != $none) #userState: userState,
      if (requiresEmailConfirmation != $none)
        #requiresEmailConfirmation: requiresEmailConfirmation,
      if (requiresManualApproval != $none)
        #requiresManualApproval: requiresManualApproval,
      if (message != $none) #message: message,
    }),
  );
  @override
  FCRegisterResult $make(CopyWithData data) => FCRegisterResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    previewTopicId: data.get(#previewTopicId, or: $value.previewTopicId),
    userId: data.get(#userId, or: $value.userId),
    username: data.get(#username, or: $value.username),
    userState: data.get(#userState, or: $value.userState),
    requiresEmailConfirmation: data.get(
      #requiresEmailConfirmation,
      or: $value.requiresEmailConfirmation,
    ),
    requiresManualApproval: data.get(
      #requiresManualApproval,
      or: $value.requiresManualApproval,
    ),
    message: data.get(#message, or: $value.message),
  );

  @override
  FCRegisterResultCopyWith<$R2, FCRegisterResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCRegisterResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCCustomRegisterFieldMapper
    extends ClassMapperBase<FCCustomRegisterField> {
  FCCustomRegisterFieldMapper._();

  static FCCustomRegisterFieldMapper? _instance;
  static FCCustomRegisterFieldMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCCustomRegisterFieldMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCCustomRegisterField';

  static String _$name(FCCustomRegisterField v) => v.name;
  static const Field<FCCustomRegisterField, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
    def: "",
  );
  static String _$description(FCCustomRegisterField v) => v.description;
  static const Field<FCCustomRegisterField, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
    def: "",
  );
  static String _$key(FCCustomRegisterField v) => v.key;
  static const Field<FCCustomRegisterField, String> _f$key = Field(
    'key',
    _$key,
    opt: true,
    def: "",
  );
  static String _$type(FCCustomRegisterField v) => v.type;
  static const Field<FCCustomRegisterField, String> _f$type = Field(
    'type',
    _$type,
    opt: true,
    def: "",
  );
  static String _$format(FCCustomRegisterField v) => v.format;
  static const Field<FCCustomRegisterField, String> _f$format = Field(
    'format',
    _$format,
    opt: true,
    def: "",
  );
  static dynamic _$defaultValue(FCCustomRegisterField v) => v.defaultValue;
  static const Field<FCCustomRegisterField, dynamic> _f$defaultValue = Field(
    'defaultValue',
    _$defaultValue,
    opt: true,
  );
  static String _$options(FCCustomRegisterField v) => v.options;
  static const Field<FCCustomRegisterField, String> _f$options = Field(
    'options',
    _$options,
    opt: true,
    def: "",
  );

  @override
  final MappableFields<FCCustomRegisterField> fields = const {
    #name: _f$name,
    #description: _f$description,
    #key: _f$key,
    #type: _f$type,
    #format: _f$format,
    #defaultValue: _f$defaultValue,
    #options: _f$options,
  };

  static FCCustomRegisterField _instantiate(DecodingData data) {
    return FCCustomRegisterField(
      name: data.dec(_f$name),
      description: data.dec(_f$description),
      key: data.dec(_f$key),
      type: data.dec(_f$type),
      format: data.dec(_f$format),
      defaultValue: data.dec(_f$defaultValue),
      options: data.dec(_f$options),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCCustomRegisterField fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCCustomRegisterField>(map);
  }

  static FCCustomRegisterField fromJson(String json) {
    return ensureInitialized().decodeJson<FCCustomRegisterField>(json);
  }
}

mixin FCCustomRegisterFieldMappable {
  String toJson() {
    return FCCustomRegisterFieldMapper.ensureInitialized()
        .encodeJson<FCCustomRegisterField>(this as FCCustomRegisterField);
  }

  Map<String, dynamic> toMap() {
    return FCCustomRegisterFieldMapper.ensureInitialized()
        .encodeMap<FCCustomRegisterField>(this as FCCustomRegisterField);
  }

  FCCustomRegisterFieldCopyWith<
    FCCustomRegisterField,
    FCCustomRegisterField,
    FCCustomRegisterField
  >
  get copyWith =>
      _FCCustomRegisterFieldCopyWithImpl<
        FCCustomRegisterField,
        FCCustomRegisterField
      >(this as FCCustomRegisterField, $identity, $identity);
  @override
  String toString() {
    return FCCustomRegisterFieldMapper.ensureInitialized().stringifyValue(
      this as FCCustomRegisterField,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCCustomRegisterFieldMapper.ensureInitialized().equalsValue(
      this as FCCustomRegisterField,
      other,
    );
  }

  @override
  int get hashCode {
    return FCCustomRegisterFieldMapper.ensureInitialized().hashValue(
      this as FCCustomRegisterField,
    );
  }
}

extension FCCustomRegisterFieldValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCCustomRegisterField, $Out> {
  FCCustomRegisterFieldCopyWith<$R, FCCustomRegisterField, $Out>
  get $asFCCustomRegisterField => $base.as(
    (v, t, t2) => _FCCustomRegisterFieldCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCCustomRegisterFieldCopyWith<
  $R,
  $In extends FCCustomRegisterField,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? name,
    String? description,
    String? key,
    String? type,
    String? format,
    dynamic defaultValue,
    String? options,
  });
  FCCustomRegisterFieldCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCCustomRegisterFieldCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCCustomRegisterField, $Out>
    implements FCCustomRegisterFieldCopyWith<$R, FCCustomRegisterField, $Out> {
  _FCCustomRegisterFieldCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCCustomRegisterField> $mapper =
      FCCustomRegisterFieldMapper.ensureInitialized();
  @override
  $R call({
    String? name,
    String? description,
    String? key,
    String? type,
    String? format,
    Object? defaultValue = $none,
    String? options,
  }) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (description != null) #description: description,
      if (key != null) #key: key,
      if (type != null) #type: type,
      if (format != null) #format: format,
      if (defaultValue != $none) #defaultValue: defaultValue,
      if (options != null) #options: options,
    }),
  );
  @override
  FCCustomRegisterField $make(CopyWithData data) => FCCustomRegisterField(
    name: data.get(#name, or: $value.name),
    description: data.get(#description, or: $value.description),
    key: data.get(#key, or: $value.key),
    type: data.get(#type, or: $value.type),
    format: data.get(#format, or: $value.format),
    defaultValue: data.get(#defaultValue, or: $value.defaultValue),
    options: data.get(#options, or: $value.options),
  );

  @override
  FCCustomRegisterFieldCopyWith<$R2, FCCustomRegisterField, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCCustomRegisterFieldCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCPrefetchAccountResultMapper
    extends ClassMapperBase<FCPrefetchAccountResult> {
  FCPrefetchAccountResultMapper._();

  static FCPrefetchAccountResultMapper? _instance;
  static FCPrefetchAccountResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCPrefetchAccountResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
      FCRegistrationRequirementsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCPrefetchAccountResult';

  static bool _$result(FCPrefetchAccountResult v) => v.result;
  static const Field<FCPrefetchAccountResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCPrefetchAccountResult v) => v.resultText;
  static const Field<FCPrefetchAccountResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static bool _$accountExists(FCPrefetchAccountResult v) => v.accountExists;
  static const Field<FCPrefetchAccountResult, bool> _f$accountExists = Field(
    'accountExists',
    _$accountExists,
    opt: true,
    def: false,
  );
  static String? _$username(FCPrefetchAccountResult v) => v.username;
  static const Field<FCPrefetchAccountResult, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
  );
  static String? _$email(FCPrefetchAccountResult v) => v.email;
  static const Field<FCPrefetchAccountResult, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static bool _$registrationOpen(FCPrefetchAccountResult v) =>
      v.registrationOpen;
  static const Field<FCPrefetchAccountResult, bool> _f$registrationOpen = Field(
    'registrationOpen',
    _$registrationOpen,
    opt: true,
    def: false,
  );
  static bool _$canRegisterViaAPI(FCPrefetchAccountResult v) =>
      v.canRegisterViaAPI;
  static const Field<FCPrefetchAccountResult, bool> _f$canRegisterViaAPI =
      Field('canRegisterViaAPI', _$canRegisterViaAPI, opt: true, def: false);
  static String _$registerViaWebUrl(FCPrefetchAccountResult v) =>
      v.registerViaWebUrl;
  static const Field<FCPrefetchAccountResult, String> _f$registerViaWebUrl =
      Field('registerViaWebUrl', _$registerViaWebUrl, opt: true, def: '');
  static FCRegistrationRequirements? _$registrationRequirements(
    FCPrefetchAccountResult v,
  ) => v.registrationRequirements;
  static const Field<FCPrefetchAccountResult, FCRegistrationRequirements>
  _f$registrationRequirements = Field(
    'registrationRequirements',
    _$registrationRequirements,
    opt: true,
  );

  @override
  final MappableFields<FCPrefetchAccountResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #accountExists: _f$accountExists,
    #username: _f$username,
    #email: _f$email,
    #registrationOpen: _f$registrationOpen,
    #canRegisterViaAPI: _f$canRegisterViaAPI,
    #registerViaWebUrl: _f$registerViaWebUrl,
    #registrationRequirements: _f$registrationRequirements,
  };

  static FCPrefetchAccountResult _instantiate(DecodingData data) {
    return FCPrefetchAccountResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      accountExists: data.dec(_f$accountExists),
      username: data.dec(_f$username),
      email: data.dec(_f$email),
      registrationOpen: data.dec(_f$registrationOpen),
      canRegisterViaAPI: data.dec(_f$canRegisterViaAPI),
      registerViaWebUrl: data.dec(_f$registerViaWebUrl),
      registrationRequirements: data.dec(_f$registrationRequirements),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCPrefetchAccountResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCPrefetchAccountResult>(map);
  }

  static FCPrefetchAccountResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCPrefetchAccountResult>(json);
  }
}

mixin FCPrefetchAccountResultMappable {
  String toJson() {
    return FCPrefetchAccountResultMapper.ensureInitialized()
        .encodeJson<FCPrefetchAccountResult>(this as FCPrefetchAccountResult);
  }

  Map<String, dynamic> toMap() {
    return FCPrefetchAccountResultMapper.ensureInitialized()
        .encodeMap<FCPrefetchAccountResult>(this as FCPrefetchAccountResult);
  }

  FCPrefetchAccountResultCopyWith<
    FCPrefetchAccountResult,
    FCPrefetchAccountResult,
    FCPrefetchAccountResult
  >
  get copyWith =>
      _FCPrefetchAccountResultCopyWithImpl<
        FCPrefetchAccountResult,
        FCPrefetchAccountResult
      >(this as FCPrefetchAccountResult, $identity, $identity);
  @override
  String toString() {
    return FCPrefetchAccountResultMapper.ensureInitialized().stringifyValue(
      this as FCPrefetchAccountResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCPrefetchAccountResultMapper.ensureInitialized().equalsValue(
      this as FCPrefetchAccountResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCPrefetchAccountResultMapper.ensureInitialized().hashValue(
      this as FCPrefetchAccountResult,
    );
  }
}

extension FCPrefetchAccountResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCPrefetchAccountResult, $Out> {
  FCPrefetchAccountResultCopyWith<$R, FCPrefetchAccountResult, $Out>
  get $asFCPrefetchAccountResult => $base.as(
    (v, t, t2) => _FCPrefetchAccountResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCPrefetchAccountResultCopyWith<
  $R,
  $In extends FCPrefetchAccountResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  FCRegistrationRequirementsCopyWith<
    $R,
    FCRegistrationRequirements,
    FCRegistrationRequirements
  >?
  get registrationRequirements;
  @override
  $R call({
    bool? result,
    String? resultText,
    bool? accountExists,
    String? username,
    String? email,
    bool? registrationOpen,
    bool? canRegisterViaAPI,
    String? registerViaWebUrl,
    FCRegistrationRequirements? registrationRequirements,
  });
  FCPrefetchAccountResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCPrefetchAccountResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCPrefetchAccountResult, $Out>
    implements
        FCPrefetchAccountResultCopyWith<$R, FCPrefetchAccountResult, $Out> {
  _FCPrefetchAccountResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCPrefetchAccountResult> $mapper =
      FCPrefetchAccountResultMapper.ensureInitialized();
  @override
  FCRegistrationRequirementsCopyWith<
    $R,
    FCRegistrationRequirements,
    FCRegistrationRequirements
  >?
  get registrationRequirements => $value.registrationRequirements?.copyWith
      .$chain((v) => call(registrationRequirements: v));
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    bool? accountExists,
    Object? username = $none,
    Object? email = $none,
    bool? registrationOpen,
    bool? canRegisterViaAPI,
    String? registerViaWebUrl,
    Object? registrationRequirements = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (accountExists != null) #accountExists: accountExists,
      if (username != $none) #username: username,
      if (email != $none) #email: email,
      if (registrationOpen != null) #registrationOpen: registrationOpen,
      if (canRegisterViaAPI != null) #canRegisterViaAPI: canRegisterViaAPI,
      if (registerViaWebUrl != null) #registerViaWebUrl: registerViaWebUrl,
      if (registrationRequirements != $none)
        #registrationRequirements: registrationRequirements,
    }),
  );
  @override
  FCPrefetchAccountResult $make(CopyWithData data) => FCPrefetchAccountResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    accountExists: data.get(#accountExists, or: $value.accountExists),
    username: data.get(#username, or: $value.username),
    email: data.get(#email, or: $value.email),
    registrationOpen: data.get(#registrationOpen, or: $value.registrationOpen),
    canRegisterViaAPI: data.get(
      #canRegisterViaAPI,
      or: $value.canRegisterViaAPI,
    ),
    registerViaWebUrl: data.get(
      #registerViaWebUrl,
      or: $value.registerViaWebUrl,
    ),
    registrationRequirements: data.get(
      #registrationRequirements,
      or: $value.registrationRequirements,
    ),
  );

  @override
  FCPrefetchAccountResultCopyWith<$R2, FCPrefetchAccountResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCPrefetchAccountResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

