// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_user.dart';

class FCUserMapper extends ClassMapperBase<FCUser> {
  FCUserMapper._();

  static FCUserMapper? _instance;
  static FCUserMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUserMapper._());
      FCUserCustomFieldMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUser';

  static String _$id(FCUser v) => v.id;
  static const Field<FCUser, String> _f$id = Field('id', _$id);
  static String _$username(FCUser v) => v.username;
  static const Field<FCUser, String> _f$username = Field(
    'username',
    _$username,
  );
  static String? _$loginName(FCUser v) => v.loginName;
  static const Field<FCUser, String> _f$loginName = Field(
    'loginName',
    _$loginName,
    opt: true,
  );
  static String? _$email(FCUser v) => v.email;
  static const Field<FCUser, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static String? _$userType(FCUser v) => v.userType;
  static const Field<FCUser, String> _f$userType = Field(
    'userType',
    _$userType,
    opt: true,
  );
  static String? _$iconUrl(FCUser v) => v.iconUrl;
  static const Field<FCUser, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static int _$postCount(FCUser v) => v.postCount;
  static const Field<FCUser, int> _f$postCount = Field(
    'postCount',
    _$postCount,
    opt: true,
    def: 0,
  );
  static DateTime? _$registrationTime(FCUser v) => v.registrationTime;
  static const Field<FCUser, DateTime> _f$registrationTime = Field(
    'registrationTime',
    _$registrationTime,
    opt: true,
  );
  static DateTime? _$lastActivityTime(FCUser v) => v.lastActivityTime;
  static const Field<FCUser, DateTime> _f$lastActivityTime = Field(
    'lastActivityTime',
    _$lastActivityTime,
    opt: true,
  );
  static bool _$isOnline(FCUser v) => v.isOnline;
  static const Field<FCUser, bool> _f$isOnline = Field(
    'isOnline',
    _$isOnline,
    opt: true,
    def: false,
  );
  static String? _$currentActivity(FCUser v) => v.currentActivity;
  static const Field<FCUser, String> _f$currentActivity = Field(
    'currentActivity',
    _$currentActivity,
    opt: true,
  );
  static String? _$currentTopicId(FCUser v) => v.currentTopicId;
  static const Field<FCUser, String> _f$currentTopicId = Field(
    'currentTopicId',
    _$currentTopicId,
    opt: true,
  );
  static bool _$acceptsPM(FCUser v) => v.acceptsPM;
  static const Field<FCUser, bool> _f$acceptsPM = Field(
    'acceptsPM',
    _$acceptsPM,
    opt: true,
    def: false,
  );
  static bool _$canSendPM(FCUser v) => v.canSendPM;
  static const Field<FCUser, bool> _f$canSendPM = Field(
    'canSendPM',
    _$canSendPM,
    opt: true,
    def: false,
  );
  static bool _$canPM(FCUser v) => v.canPM;
  static const Field<FCUser, bool> _f$canPM = Field(
    'canPM',
    _$canPM,
    opt: true,
    def: false,
  );
  static bool _$isFollowing(FCUser v) => v.isFollowing;
  static const Field<FCUser, bool> _f$isFollowing = Field(
    'isFollowing',
    _$isFollowing,
    opt: true,
    def: false,
  );
  static bool _$isFollowingMe(FCUser v) => v.isFollowingMe;
  static const Field<FCUser, bool> _f$isFollowingMe = Field(
    'isFollowingMe',
    _$isFollowingMe,
    opt: true,
    def: false,
  );
  static bool _$acceptsFollowers(FCUser v) => v.acceptsFollowers;
  static const Field<FCUser, bool> _f$acceptsFollowers = Field(
    'acceptsFollowers',
    _$acceptsFollowers,
    opt: true,
    def: false,
  );
  static int _$followingCount(FCUser v) => v.followingCount;
  static const Field<FCUser, int> _f$followingCount = Field(
    'followingCount',
    _$followingCount,
    opt: true,
    def: 0,
  );
  static int _$followerCount(FCUser v) => v.followerCount;
  static const Field<FCUser, int> _f$followerCount = Field(
    'followerCount',
    _$followerCount,
    opt: true,
    def: 0,
  );
  static String? _$displayText(FCUser v) => v.displayText;
  static const Field<FCUser, String> _f$displayText = Field(
    'displayText',
    _$displayText,
    opt: true,
  );
  static List<FCUserCustomField> _$customFields(FCUser v) => v.customFields;
  static const Field<FCUser, List<FCUserCustomField>> _f$customFields = Field(
    'customFields',
    _$customFields,
    opt: true,
    def: const [],
  );
  static bool _$canBan(FCUser v) => v.canBan;
  static const Field<FCUser, bool> _f$canBan = Field(
    'canBan',
    _$canBan,
    opt: true,
    def: false,
  );
  static bool _$isBanned(FCUser v) => v.isBanned;
  static const Field<FCUser, bool> _f$isBanned = Field(
    'isBanned',
    _$isBanned,
    opt: true,
    def: false,
  );
  static bool _$isIgnored(FCUser v) => v.isIgnored;
  static const Field<FCUser, bool> _f$isIgnored = Field(
    'isIgnored',
    _$isIgnored,
    opt: true,
    def: false,
  );
  static bool _$canSpamClean(FCUser v) => v.canSpamClean;
  static const Field<FCUser, bool> _f$canSpamClean = Field(
    'canSpamClean',
    _$canSpamClean,
    opt: true,
    def: false,
  );
  static bool _$canBeReported(FCUser v) => v.canBeReported;
  static const Field<FCUser, bool> _f$canBeReported = Field(
    'canBeReported',
    _$canBeReported,
    opt: true,
    def: false,
  );
  static List<String> _$userGroups(FCUser v) => v.userGroups;
  static const Field<FCUser, List<String>> _f$userGroups = Field(
    'userGroups',
    _$userGroups,
    opt: true,
    def: const [],
  );
  static bool _$canModerate(FCUser v) => v.canModerate;
  static const Field<FCUser, bool> _f$canModerate = Field(
    'canModerate',
    _$canModerate,
    opt: true,
    def: false,
  );
  static bool _$canSearch(FCUser v) => v.canSearch;
  static const Field<FCUser, bool> _f$canSearch = Field(
    'canSearch',
    _$canSearch,
    opt: true,
    def: false,
  );
  static String? _$userState(FCUser v) => v.userState;
  static const Field<FCUser, String> _f$userState = Field(
    'userState',
    _$userState,
    opt: true,
    def: 'valid',
  );

  @override
  final MappableFields<FCUser> fields = const {
    #id: _f$id,
    #username: _f$username,
    #loginName: _f$loginName,
    #email: _f$email,
    #userType: _f$userType,
    #iconUrl: _f$iconUrl,
    #postCount: _f$postCount,
    #registrationTime: _f$registrationTime,
    #lastActivityTime: _f$lastActivityTime,
    #isOnline: _f$isOnline,
    #currentActivity: _f$currentActivity,
    #currentTopicId: _f$currentTopicId,
    #acceptsPM: _f$acceptsPM,
    #canSendPM: _f$canSendPM,
    #canPM: _f$canPM,
    #isFollowing: _f$isFollowing,
    #isFollowingMe: _f$isFollowingMe,
    #acceptsFollowers: _f$acceptsFollowers,
    #followingCount: _f$followingCount,
    #followerCount: _f$followerCount,
    #displayText: _f$displayText,
    #customFields: _f$customFields,
    #canBan: _f$canBan,
    #isBanned: _f$isBanned,
    #isIgnored: _f$isIgnored,
    #canSpamClean: _f$canSpamClean,
    #canBeReported: _f$canBeReported,
    #userGroups: _f$userGroups,
    #canModerate: _f$canModerate,
    #canSearch: _f$canSearch,
    #userState: _f$userState,
  };

  static FCUser _instantiate(DecodingData data) {
    return FCUser(
      id: data.dec(_f$id),
      username: data.dec(_f$username),
      loginName: data.dec(_f$loginName),
      email: data.dec(_f$email),
      userType: data.dec(_f$userType),
      iconUrl: data.dec(_f$iconUrl),
      postCount: data.dec(_f$postCount),
      registrationTime: data.dec(_f$registrationTime),
      lastActivityTime: data.dec(_f$lastActivityTime),
      isOnline: data.dec(_f$isOnline),
      currentActivity: data.dec(_f$currentActivity),
      currentTopicId: data.dec(_f$currentTopicId),
      acceptsPM: data.dec(_f$acceptsPM),
      canSendPM: data.dec(_f$canSendPM),
      canPM: data.dec(_f$canPM),
      isFollowing: data.dec(_f$isFollowing),
      isFollowingMe: data.dec(_f$isFollowingMe),
      acceptsFollowers: data.dec(_f$acceptsFollowers),
      followingCount: data.dec(_f$followingCount),
      followerCount: data.dec(_f$followerCount),
      displayText: data.dec(_f$displayText),
      customFields: data.dec(_f$customFields),
      canBan: data.dec(_f$canBan),
      isBanned: data.dec(_f$isBanned),
      isIgnored: data.dec(_f$isIgnored),
      canSpamClean: data.dec(_f$canSpamClean),
      canBeReported: data.dec(_f$canBeReported),
      userGroups: data.dec(_f$userGroups),
      canModerate: data.dec(_f$canModerate),
      canSearch: data.dec(_f$canSearch),
      userState: data.dec(_f$userState),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUser fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUser>(map);
  }

  static FCUser fromJson(String json) {
    return ensureInitialized().decodeJson<FCUser>(json);
  }
}

mixin FCUserMappable {
  String toJson() {
    return FCUserMapper.ensureInitialized().encodeJson<FCUser>(this as FCUser);
  }

  Map<String, dynamic> toMap() {
    return FCUserMapper.ensureInitialized().encodeMap<FCUser>(this as FCUser);
  }

  FCUserCopyWith<FCUser, FCUser, FCUser> get copyWith =>
      _FCUserCopyWithImpl<FCUser, FCUser>(this as FCUser, $identity, $identity);
  @override
  String toString() {
    return FCUserMapper.ensureInitialized().stringifyValue(this as FCUser);
  }

  @override
  bool operator ==(Object other) {
    return FCUserMapper.ensureInitialized().equalsValue(this as FCUser, other);
  }

  @override
  int get hashCode {
    return FCUserMapper.ensureInitialized().hashValue(this as FCUser);
  }
}

extension FCUserValueCopy<$R, $Out> on ObjectCopyWith<$R, FCUser, $Out> {
  FCUserCopyWith<$R, FCUser, $Out> get $asFCUser =>
      $base.as((v, t, t2) => _FCUserCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCUserCopyWith<$R, $In extends FCUser, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCUserCustomField,
    FCUserCustomFieldCopyWith<$R, FCUserCustomField, FCUserCustomField>
  >
  get customFields;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get userGroups;
  $R call({
    String? id,
    String? username,
    String? loginName,
    String? email,
    String? userType,
    String? iconUrl,
    int? postCount,
    DateTime? registrationTime,
    DateTime? lastActivityTime,
    bool? isOnline,
    String? currentActivity,
    String? currentTopicId,
    bool? acceptsPM,
    bool? canSendPM,
    bool? canPM,
    bool? isFollowing,
    bool? isFollowingMe,
    bool? acceptsFollowers,
    int? followingCount,
    int? followerCount,
    String? displayText,
    List<FCUserCustomField>? customFields,
    bool? canBan,
    bool? isBanned,
    bool? isIgnored,
    bool? canSpamClean,
    bool? canBeReported,
    List<String>? userGroups,
    bool? canModerate,
    bool? canSearch,
    String? userState,
  });
  FCUserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCUserCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, FCUser, $Out>
    implements FCUserCopyWith<$R, FCUser, $Out> {
  _FCUserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUser> $mapper = FCUserMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCUserCustomField,
    FCUserCustomFieldCopyWith<$R, FCUserCustomField, FCUserCustomField>
  >
  get customFields => ListCopyWith(
    $value.customFields,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(customFields: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get userGroups =>
      ListCopyWith(
        $value.userGroups,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(userGroups: v),
      );
  @override
  $R call({
    String? id,
    String? username,
    Object? loginName = $none,
    Object? email = $none,
    Object? userType = $none,
    Object? iconUrl = $none,
    int? postCount,
    Object? registrationTime = $none,
    Object? lastActivityTime = $none,
    bool? isOnline,
    Object? currentActivity = $none,
    Object? currentTopicId = $none,
    bool? acceptsPM,
    bool? canSendPM,
    bool? canPM,
    bool? isFollowing,
    bool? isFollowingMe,
    bool? acceptsFollowers,
    int? followingCount,
    int? followerCount,
    Object? displayText = $none,
    List<FCUserCustomField>? customFields,
    bool? canBan,
    bool? isBanned,
    bool? isIgnored,
    bool? canSpamClean,
    bool? canBeReported,
    List<String>? userGroups,
    bool? canModerate,
    bool? canSearch,
    Object? userState = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (username != null) #username: username,
      if (loginName != $none) #loginName: loginName,
      if (email != $none) #email: email,
      if (userType != $none) #userType: userType,
      if (iconUrl != $none) #iconUrl: iconUrl,
      if (postCount != null) #postCount: postCount,
      if (registrationTime != $none) #registrationTime: registrationTime,
      if (lastActivityTime != $none) #lastActivityTime: lastActivityTime,
      if (isOnline != null) #isOnline: isOnline,
      if (currentActivity != $none) #currentActivity: currentActivity,
      if (currentTopicId != $none) #currentTopicId: currentTopicId,
      if (acceptsPM != null) #acceptsPM: acceptsPM,
      if (canSendPM != null) #canSendPM: canSendPM,
      if (canPM != null) #canPM: canPM,
      if (isFollowing != null) #isFollowing: isFollowing,
      if (isFollowingMe != null) #isFollowingMe: isFollowingMe,
      if (acceptsFollowers != null) #acceptsFollowers: acceptsFollowers,
      if (followingCount != null) #followingCount: followingCount,
      if (followerCount != null) #followerCount: followerCount,
      if (displayText != $none) #displayText: displayText,
      if (customFields != null) #customFields: customFields,
      if (canBan != null) #canBan: canBan,
      if (isBanned != null) #isBanned: isBanned,
      if (isIgnored != null) #isIgnored: isIgnored,
      if (canSpamClean != null) #canSpamClean: canSpamClean,
      if (canBeReported != null) #canBeReported: canBeReported,
      if (userGroups != null) #userGroups: userGroups,
      if (canModerate != null) #canModerate: canModerate,
      if (canSearch != null) #canSearch: canSearch,
      if (userState != $none) #userState: userState,
    }),
  );
  @override
  FCUser $make(CopyWithData data) => FCUser(
    id: data.get(#id, or: $value.id),
    username: data.get(#username, or: $value.username),
    loginName: data.get(#loginName, or: $value.loginName),
    email: data.get(#email, or: $value.email),
    userType: data.get(#userType, or: $value.userType),
    iconUrl: data.get(#iconUrl, or: $value.iconUrl),
    postCount: data.get(#postCount, or: $value.postCount),
    registrationTime: data.get(#registrationTime, or: $value.registrationTime),
    lastActivityTime: data.get(#lastActivityTime, or: $value.lastActivityTime),
    isOnline: data.get(#isOnline, or: $value.isOnline),
    currentActivity: data.get(#currentActivity, or: $value.currentActivity),
    currentTopicId: data.get(#currentTopicId, or: $value.currentTopicId),
    acceptsPM: data.get(#acceptsPM, or: $value.acceptsPM),
    canSendPM: data.get(#canSendPM, or: $value.canSendPM),
    canPM: data.get(#canPM, or: $value.canPM),
    isFollowing: data.get(#isFollowing, or: $value.isFollowing),
    isFollowingMe: data.get(#isFollowingMe, or: $value.isFollowingMe),
    acceptsFollowers: data.get(#acceptsFollowers, or: $value.acceptsFollowers),
    followingCount: data.get(#followingCount, or: $value.followingCount),
    followerCount: data.get(#followerCount, or: $value.followerCount),
    displayText: data.get(#displayText, or: $value.displayText),
    customFields: data.get(#customFields, or: $value.customFields),
    canBan: data.get(#canBan, or: $value.canBan),
    isBanned: data.get(#isBanned, or: $value.isBanned),
    isIgnored: data.get(#isIgnored, or: $value.isIgnored),
    canSpamClean: data.get(#canSpamClean, or: $value.canSpamClean),
    canBeReported: data.get(#canBeReported, or: $value.canBeReported),
    userGroups: data.get(#userGroups, or: $value.userGroups),
    canModerate: data.get(#canModerate, or: $value.canModerate),
    canSearch: data.get(#canSearch, or: $value.canSearch),
    userState: data.get(#userState, or: $value.userState),
  );

  @override
  FCUserCopyWith<$R2, FCUser, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCUserCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUserCustomFieldMapper extends ClassMapperBase<FCUserCustomField> {
  FCUserCustomFieldMapper._();

  static FCUserCustomFieldMapper? _instance;
  static FCUserCustomFieldMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUserCustomFieldMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCUserCustomField';

  static String _$name(FCUserCustomField v) => v.name;
  static const Field<FCUserCustomField, String> _f$name = Field('name', _$name);
  static String _$value(FCUserCustomField v) => v.value;
  static const Field<FCUserCustomField, String> _f$value = Field(
    'value',
    _$value,
  );

  @override
  final MappableFields<FCUserCustomField> fields = const {
    #name: _f$name,
    #value: _f$value,
  };

  static FCUserCustomField _instantiate(DecodingData data) {
    return FCUserCustomField(
      name: data.dec(_f$name),
      value: data.dec(_f$value),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUserCustomField fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUserCustomField>(map);
  }

  static FCUserCustomField fromJson(String json) {
    return ensureInitialized().decodeJson<FCUserCustomField>(json);
  }
}

mixin FCUserCustomFieldMappable {
  String toJson() {
    return FCUserCustomFieldMapper.ensureInitialized()
        .encodeJson<FCUserCustomField>(this as FCUserCustomField);
  }

  Map<String, dynamic> toMap() {
    return FCUserCustomFieldMapper.ensureInitialized()
        .encodeMap<FCUserCustomField>(this as FCUserCustomField);
  }

  FCUserCustomFieldCopyWith<
    FCUserCustomField,
    FCUserCustomField,
    FCUserCustomField
  >
  get copyWith =>
      _FCUserCustomFieldCopyWithImpl<FCUserCustomField, FCUserCustomField>(
        this as FCUserCustomField,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCUserCustomFieldMapper.ensureInitialized().stringifyValue(
      this as FCUserCustomField,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUserCustomFieldMapper.ensureInitialized().equalsValue(
      this as FCUserCustomField,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUserCustomFieldMapper.ensureInitialized().hashValue(
      this as FCUserCustomField,
    );
  }
}

extension FCUserCustomFieldValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUserCustomField, $Out> {
  FCUserCustomFieldCopyWith<$R, FCUserCustomField, $Out>
  get $asFCUserCustomField => $base.as(
    (v, t, t2) => _FCUserCustomFieldCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUserCustomFieldCopyWith<
  $R,
  $In extends FCUserCustomField,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, String? value});
  FCUserCustomFieldCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUserCustomFieldCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUserCustomField, $Out>
    implements FCUserCustomFieldCopyWith<$R, FCUserCustomField, $Out> {
  _FCUserCustomFieldCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUserCustomField> $mapper =
      FCUserCustomFieldMapper.ensureInitialized();
  @override
  $R call({String? name, String? value}) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (value != null) #value: value,
    }),
  );
  @override
  FCUserCustomField $make(CopyWithData data) => FCUserCustomField(
    name: data.get(#name, or: $value.name),
    value: data.get(#value, or: $value.value),
  );

  @override
  FCUserCustomFieldCopyWith<$R2, FCUserCustomField, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCUserCustomFieldCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

