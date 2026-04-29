// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_user_result.dart';

class FCLoginResultMapper extends ClassMapperBase<FCLoginResult> {
  FCLoginResultMapper._();

  static FCLoginResultMapper? _instance;
  static FCLoginResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCLoginResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCUserMapper.ensureInitialized();
      FCTFAProviderMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCLoginResult';

  static bool _$result(FCLoginResult v) => v.result;
  static const Field<FCLoginResult, bool> _f$result = Field('result', _$result);
  static String? _$resultText(FCLoginResult v) => v.resultText;
  static const Field<FCLoginResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
  );
  static FCUser? _$user(FCLoginResult v) => v.user;
  static const Field<FCLoginResult, FCUser> _f$user = Field(
    'user',
    _$user,
    opt: true,
  );
  static bool _$canWhosonline(FCLoginResult v) => v.canWhosonline;
  static const Field<FCLoginResult, bool> _f$canWhosonline = Field(
    'canWhosonline',
    _$canWhosonline,
    opt: true,
    def: false,
  );
  static bool _$canProfile(FCLoginResult v) => v.canProfile;
  static const Field<FCLoginResult, bool> _f$canProfile = Field(
    'canProfile',
    _$canProfile,
    opt: true,
    def: false,
  );
  static bool _$canUploadAvatar(FCLoginResult v) => v.canUploadAvatar;
  static const Field<FCLoginResult, bool> _f$canUploadAvatar = Field(
    'canUploadAvatar',
    _$canUploadAvatar,
    opt: true,
    def: false,
  );
  static int _$maxAttachment(FCLoginResult v) => v.maxAttachment;
  static const Field<FCLoginResult, int> _f$maxAttachment = Field(
    'maxAttachment',
    _$maxAttachment,
    opt: true,
    def: 0,
  );
  static int _$maxPngSize(FCLoginResult v) => v.maxPngSize;
  static const Field<FCLoginResult, int> _f$maxPngSize = Field(
    'maxPngSize',
    _$maxPngSize,
    opt: true,
    def: 0,
  );
  static int _$maxJpgSize(FCLoginResult v) => v.maxJpgSize;
  static const Field<FCLoginResult, int> _f$maxJpgSize = Field(
    'maxJpgSize',
    _$maxJpgSize,
    opt: true,
    def: 0,
  );
  static String? _$ignoredUids(FCLoginResult v) => v.ignoredUids;
  static const Field<FCLoginResult, String> _f$ignoredUids = Field(
    'ignoredUids',
    _$ignoredUids,
    opt: true,
  );
  static String? _$allowedExtensions(FCLoginResult v) => v.allowedExtensions;
  static const Field<FCLoginResult, String> _f$allowedExtensions = Field(
    'allowedExtensions',
    _$allowedExtensions,
    opt: true,
  );
  static bool _$canUploadAttachment(FCLoginResult v) => v.canUploadAttachment;
  static const Field<FCLoginResult, bool> _f$canUploadAttachment = Field(
    'canUploadAttachment',
    _$canUploadAttachment,
    opt: true,
    def: false,
  );
  static bool _$canUploadConversationAttachment(FCLoginResult v) =>
      v.canUploadConversationAttachment;
  static const Field<FCLoginResult, bool> _f$canUploadConversationAttachment =
      Field(
        'canUploadConversationAttachment',
        _$canUploadConversationAttachment,
        opt: true,
        def: false,
      );
  static int _$maxAttachmentSize(FCLoginResult v) => v.maxAttachmentSize;
  static const Field<FCLoginResult, int> _f$maxAttachmentSize = Field(
    'maxAttachmentSize',
    _$maxAttachmentSize,
    opt: true,
    def: 0,
  );
  static List<String>? _$allowedFileExtensions(FCLoginResult v) =>
      v.allowedFileExtensions;
  static const Field<FCLoginResult, List<String>> _f$allowedFileExtensions =
      Field('allowedFileExtensions', _$allowedFileExtensions, opt: true);
  static int _$maxImageWidth(FCLoginResult v) => v.maxImageWidth;
  static const Field<FCLoginResult, int> _f$maxImageWidth = Field(
    'maxImageWidth',
    _$maxImageWidth,
    opt: true,
    def: 0,
  );
  static int _$maxImageHeight(FCLoginResult v) => v.maxImageHeight;
  static const Field<FCLoginResult, int> _f$maxImageHeight = Field(
    'maxImageHeight',
    _$maxImageHeight,
    opt: true,
    def: 0,
  );
  static int _$postCountdown(FCLoginResult v) => v.postCountdown;
  static const Field<FCLoginResult, int> _f$postCountdown = Field(
    'postCountdown',
    _$postCountdown,
    opt: true,
    def: 0,
  );
  static String? _$trustCode(FCLoginResult v) => v.trustCode;
  static const Field<FCLoginResult, String> _f$trustCode = Field(
    'trustCode',
    _$trustCode,
    opt: true,
  );
  static bool _$twoStepRequired(FCLoginResult v) => v.twoStepRequired;
  static const Field<FCLoginResult, bool> _f$twoStepRequired = Field(
    'twoStepRequired',
    _$twoStepRequired,
    opt: true,
    def: false,
  );
  static bool _$tfaRequired(FCLoginResult v) => v.tfaRequired;
  static const Field<FCLoginResult, bool> _f$tfaRequired = Field(
    'tfaRequired',
    _$tfaRequired,
    opt: true,
    def: false,
  );
  static List<FCTFAProvider>? _$providers(FCLoginResult v) => v.providers;
  static const Field<FCLoginResult, List<FCTFAProvider>> _f$providers = Field(
    'providers',
    _$providers,
    opt: true,
  );
  static String? _$providerId(FCLoginResult v) => v.providerId;
  static const Field<FCLoginResult, String> _f$providerId = Field(
    'providerId',
    _$providerId,
    opt: true,
  );
  static bool _$passkeyAvailable(FCLoginResult v) => v.passkeyAvailable;
  static const Field<FCLoginResult, bool> _f$passkeyAvailable = Field(
    'passkeyAvailable',
    _$passkeyAvailable,
    opt: true,
    def: false,
  );
  static bool _$codeAvailable(FCLoginResult v) => v.codeAvailable;
  static const Field<FCLoginResult, bool> _f$codeAvailable = Field(
    'codeAvailable',
    _$codeAvailable,
    opt: true,
    def: false,
  );
  static String? _$passkeyChallenge(FCLoginResult v) => v.passkeyChallenge;
  static const Field<FCLoginResult, String> _f$passkeyChallenge = Field(
    'passkeyChallenge',
    _$passkeyChallenge,
    opt: true,
  );
  static String? _$passkeyRpId(FCLoginResult v) => v.passkeyRpId;
  static const Field<FCLoginResult, String> _f$passkeyRpId = Field(
    'passkeyRpId',
    _$passkeyRpId,
    opt: true,
  );
  static int? _$passkeyTimeout(FCLoginResult v) => v.passkeyTimeout;
  static const Field<FCLoginResult, int> _f$passkeyTimeout = Field(
    'passkeyTimeout',
    _$passkeyTimeout,
    opt: true,
  );
  static String? _$userpassword(FCLoginResult v) => v.userpassword;
  static const Field<FCLoginResult, String> _f$userpassword = Field(
    'userpassword',
    _$userpassword,
    opt: true,
  );
  static bool _$isProblematicUrl(FCLoginResult v) => v.isProblematicUrl;
  static const Field<FCLoginResult, bool> _f$isProblematicUrl = Field(
    'isProblematicUrl',
    _$isProblematicUrl,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<FCLoginResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #user: _f$user,
    #canWhosonline: _f$canWhosonline,
    #canProfile: _f$canProfile,
    #canUploadAvatar: _f$canUploadAvatar,
    #maxAttachment: _f$maxAttachment,
    #maxPngSize: _f$maxPngSize,
    #maxJpgSize: _f$maxJpgSize,
    #ignoredUids: _f$ignoredUids,
    #allowedExtensions: _f$allowedExtensions,
    #canUploadAttachment: _f$canUploadAttachment,
    #canUploadConversationAttachment: _f$canUploadConversationAttachment,
    #maxAttachmentSize: _f$maxAttachmentSize,
    #allowedFileExtensions: _f$allowedFileExtensions,
    #maxImageWidth: _f$maxImageWidth,
    #maxImageHeight: _f$maxImageHeight,
    #postCountdown: _f$postCountdown,
    #trustCode: _f$trustCode,
    #twoStepRequired: _f$twoStepRequired,
    #tfaRequired: _f$tfaRequired,
    #providers: _f$providers,
    #providerId: _f$providerId,
    #passkeyAvailable: _f$passkeyAvailable,
    #codeAvailable: _f$codeAvailable,
    #passkeyChallenge: _f$passkeyChallenge,
    #passkeyRpId: _f$passkeyRpId,
    #passkeyTimeout: _f$passkeyTimeout,
    #userpassword: _f$userpassword,
    #isProblematicUrl: _f$isProblematicUrl,
  };

  static FCLoginResult _instantiate(DecodingData data) {
    return FCLoginResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      user: data.dec(_f$user),
      canWhosonline: data.dec(_f$canWhosonline),
      canProfile: data.dec(_f$canProfile),
      canUploadAvatar: data.dec(_f$canUploadAvatar),
      maxAttachment: data.dec(_f$maxAttachment),
      maxPngSize: data.dec(_f$maxPngSize),
      maxJpgSize: data.dec(_f$maxJpgSize),
      ignoredUids: data.dec(_f$ignoredUids),
      allowedExtensions: data.dec(_f$allowedExtensions),
      canUploadAttachment: data.dec(_f$canUploadAttachment),
      canUploadConversationAttachment: data.dec(
        _f$canUploadConversationAttachment,
      ),
      maxAttachmentSize: data.dec(_f$maxAttachmentSize),
      allowedFileExtensions: data.dec(_f$allowedFileExtensions),
      maxImageWidth: data.dec(_f$maxImageWidth),
      maxImageHeight: data.dec(_f$maxImageHeight),
      postCountdown: data.dec(_f$postCountdown),
      trustCode: data.dec(_f$trustCode),
      twoStepRequired: data.dec(_f$twoStepRequired),
      tfaRequired: data.dec(_f$tfaRequired),
      providers: data.dec(_f$providers),
      providerId: data.dec(_f$providerId),
      passkeyAvailable: data.dec(_f$passkeyAvailable),
      codeAvailable: data.dec(_f$codeAvailable),
      passkeyChallenge: data.dec(_f$passkeyChallenge),
      passkeyRpId: data.dec(_f$passkeyRpId),
      passkeyTimeout: data.dec(_f$passkeyTimeout),
      userpassword: data.dec(_f$userpassword),
      isProblematicUrl: data.dec(_f$isProblematicUrl),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCLoginResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCLoginResult>(map);
  }

  static FCLoginResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCLoginResult>(json);
  }
}

mixin FCLoginResultMappable {
  String toJson() {
    return FCLoginResultMapper.ensureInitialized().encodeJson<FCLoginResult>(
      this as FCLoginResult,
    );
  }

  Map<String, dynamic> toMap() {
    return FCLoginResultMapper.ensureInitialized().encodeMap<FCLoginResult>(
      this as FCLoginResult,
    );
  }

  FCLoginResultCopyWith<FCLoginResult, FCLoginResult, FCLoginResult>
  get copyWith => _FCLoginResultCopyWithImpl<FCLoginResult, FCLoginResult>(
    this as FCLoginResult,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCLoginResultMapper.ensureInitialized().stringifyValue(
      this as FCLoginResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCLoginResultMapper.ensureInitialized().equalsValue(
      this as FCLoginResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCLoginResultMapper.ensureInitialized().hashValue(
      this as FCLoginResult,
    );
  }
}

extension FCLoginResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCLoginResult, $Out> {
  FCLoginResultCopyWith<$R, FCLoginResult, $Out> get $asFCLoginResult =>
      $base.as((v, t, t2) => _FCLoginResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCLoginResultCopyWith<$R, $In extends FCLoginResult, $Out>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  FCUserCopyWith<$R, FCUser, FCUser>? get user;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get allowedFileExtensions;
  ListCopyWith<
    $R,
    FCTFAProvider,
    FCTFAProviderCopyWith<$R, FCTFAProvider, FCTFAProvider>
  >?
  get providers;
  @override
  $R call({
    bool? result,
    covariant String? resultText,
    FCUser? user,
    bool? canWhosonline,
    bool? canProfile,
    bool? canUploadAvatar,
    int? maxAttachment,
    int? maxPngSize,
    int? maxJpgSize,
    String? ignoredUids,
    String? allowedExtensions,
    bool? canUploadAttachment,
    bool? canUploadConversationAttachment,
    int? maxAttachmentSize,
    List<String>? allowedFileExtensions,
    int? maxImageWidth,
    int? maxImageHeight,
    int? postCountdown,
    String? trustCode,
    bool? twoStepRequired,
    bool? tfaRequired,
    List<FCTFAProvider>? providers,
    String? providerId,
    bool? passkeyAvailable,
    bool? codeAvailable,
    String? passkeyChallenge,
    String? passkeyRpId,
    int? passkeyTimeout,
    String? userpassword,
    bool? isProblematicUrl,
  });
  FCLoginResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCLoginResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCLoginResult, $Out>
    implements FCLoginResultCopyWith<$R, FCLoginResult, $Out> {
  _FCLoginResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCLoginResult> $mapper =
      FCLoginResultMapper.ensureInitialized();
  @override
  FCUserCopyWith<$R, FCUser, FCUser>? get user =>
      $value.user?.copyWith.$chain((v) => call(user: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get allowedFileExtensions => $value.allowedFileExtensions != null
      ? ListCopyWith(
          $value.allowedFileExtensions!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(allowedFileExtensions: v),
        )
      : null;
  @override
  ListCopyWith<
    $R,
    FCTFAProvider,
    FCTFAProviderCopyWith<$R, FCTFAProvider, FCTFAProvider>
  >?
  get providers => $value.providers != null
      ? ListCopyWith(
          $value.providers!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(providers: v),
        )
      : null;
  @override
  $R call({
    bool? result,
    String? resultText,
    Object? user = $none,
    bool? canWhosonline,
    bool? canProfile,
    bool? canUploadAvatar,
    int? maxAttachment,
    int? maxPngSize,
    int? maxJpgSize,
    Object? ignoredUids = $none,
    Object? allowedExtensions = $none,
    bool? canUploadAttachment,
    bool? canUploadConversationAttachment,
    int? maxAttachmentSize,
    Object? allowedFileExtensions = $none,
    int? maxImageWidth,
    int? maxImageHeight,
    int? postCountdown,
    Object? trustCode = $none,
    bool? twoStepRequired,
    bool? tfaRequired,
    Object? providers = $none,
    Object? providerId = $none,
    bool? passkeyAvailable,
    bool? codeAvailable,
    Object? passkeyChallenge = $none,
    Object? passkeyRpId = $none,
    Object? passkeyTimeout = $none,
    Object? userpassword = $none,
    bool? isProblematicUrl,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != null) #resultText: resultText,
      if (user != $none) #user: user,
      if (canWhosonline != null) #canWhosonline: canWhosonline,
      if (canProfile != null) #canProfile: canProfile,
      if (canUploadAvatar != null) #canUploadAvatar: canUploadAvatar,
      if (maxAttachment != null) #maxAttachment: maxAttachment,
      if (maxPngSize != null) #maxPngSize: maxPngSize,
      if (maxJpgSize != null) #maxJpgSize: maxJpgSize,
      if (ignoredUids != $none) #ignoredUids: ignoredUids,
      if (allowedExtensions != $none) #allowedExtensions: allowedExtensions,
      if (canUploadAttachment != null)
        #canUploadAttachment: canUploadAttachment,
      if (canUploadConversationAttachment != null)
        #canUploadConversationAttachment: canUploadConversationAttachment,
      if (maxAttachmentSize != null) #maxAttachmentSize: maxAttachmentSize,
      if (allowedFileExtensions != $none)
        #allowedFileExtensions: allowedFileExtensions,
      if (maxImageWidth != null) #maxImageWidth: maxImageWidth,
      if (maxImageHeight != null) #maxImageHeight: maxImageHeight,
      if (postCountdown != null) #postCountdown: postCountdown,
      if (trustCode != $none) #trustCode: trustCode,
      if (twoStepRequired != null) #twoStepRequired: twoStepRequired,
      if (tfaRequired != null) #tfaRequired: tfaRequired,
      if (providers != $none) #providers: providers,
      if (providerId != $none) #providerId: providerId,
      if (passkeyAvailable != null) #passkeyAvailable: passkeyAvailable,
      if (codeAvailable != null) #codeAvailable: codeAvailable,
      if (passkeyChallenge != $none) #passkeyChallenge: passkeyChallenge,
      if (passkeyRpId != $none) #passkeyRpId: passkeyRpId,
      if (passkeyTimeout != $none) #passkeyTimeout: passkeyTimeout,
      if (userpassword != $none) #userpassword: userpassword,
      if (isProblematicUrl != null) #isProblematicUrl: isProblematicUrl,
    }),
  );
  @override
  FCLoginResult $make(CopyWithData data) => FCLoginResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    user: data.get(#user, or: $value.user),
    canWhosonline: data.get(#canWhosonline, or: $value.canWhosonline),
    canProfile: data.get(#canProfile, or: $value.canProfile),
    canUploadAvatar: data.get(#canUploadAvatar, or: $value.canUploadAvatar),
    maxAttachment: data.get(#maxAttachment, or: $value.maxAttachment),
    maxPngSize: data.get(#maxPngSize, or: $value.maxPngSize),
    maxJpgSize: data.get(#maxJpgSize, or: $value.maxJpgSize),
    ignoredUids: data.get(#ignoredUids, or: $value.ignoredUids),
    allowedExtensions: data.get(
      #allowedExtensions,
      or: $value.allowedExtensions,
    ),
    canUploadAttachment: data.get(
      #canUploadAttachment,
      or: $value.canUploadAttachment,
    ),
    canUploadConversationAttachment: data.get(
      #canUploadConversationAttachment,
      or: $value.canUploadConversationAttachment,
    ),
    maxAttachmentSize: data.get(
      #maxAttachmentSize,
      or: $value.maxAttachmentSize,
    ),
    allowedFileExtensions: data.get(
      #allowedFileExtensions,
      or: $value.allowedFileExtensions,
    ),
    maxImageWidth: data.get(#maxImageWidth, or: $value.maxImageWidth),
    maxImageHeight: data.get(#maxImageHeight, or: $value.maxImageHeight),
    postCountdown: data.get(#postCountdown, or: $value.postCountdown),
    trustCode: data.get(#trustCode, or: $value.trustCode),
    twoStepRequired: data.get(#twoStepRequired, or: $value.twoStepRequired),
    tfaRequired: data.get(#tfaRequired, or: $value.tfaRequired),
    providers: data.get(#providers, or: $value.providers),
    providerId: data.get(#providerId, or: $value.providerId),
    passkeyAvailable: data.get(#passkeyAvailable, or: $value.passkeyAvailable),
    codeAvailable: data.get(#codeAvailable, or: $value.codeAvailable),
    passkeyChallenge: data.get(#passkeyChallenge, or: $value.passkeyChallenge),
    passkeyRpId: data.get(#passkeyRpId, or: $value.passkeyRpId),
    passkeyTimeout: data.get(#passkeyTimeout, or: $value.passkeyTimeout),
    userpassword: data.get(#userpassword, or: $value.userpassword),
    isProblematicUrl: data.get(#isProblematicUrl, or: $value.isProblematicUrl),
  );

  @override
  FCLoginResultCopyWith<$R2, FCLoginResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCLoginResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCLoginTwoStepResultMapper extends ClassMapperBase<FCLoginTwoStepResult> {
  FCLoginTwoStepResultMapper._();

  static FCLoginTwoStepResultMapper? _instance;
  static FCLoginTwoStepResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCLoginTwoStepResultMapper._());
      FCUserMapper.ensureInitialized();
      FCUserCustomFieldMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCLoginTwoStepResult';

  static bool _$result(FCLoginTwoStepResult v) => v.result;
  static const Field<FCLoginTwoStepResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCLoginTwoStepResult v) => v.resultText;
  static const Field<FCLoginTwoStepResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String _$id(FCLoginTwoStepResult v) => v.id;
  static const Field<FCLoginTwoStepResult, String> _f$id = Field('id', _$id);
  static String _$username(FCLoginTwoStepResult v) => v.username;
  static const Field<FCLoginTwoStepResult, String> _f$username = Field(
    'username',
    _$username,
  );
  static String? _$loginName(FCLoginTwoStepResult v) => v.loginName;
  static const Field<FCLoginTwoStepResult, String> _f$loginName = Field(
    'loginName',
    _$loginName,
    opt: true,
  );
  static String? _$email(FCLoginTwoStepResult v) => v.email;
  static const Field<FCLoginTwoStepResult, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static String? _$userType(FCLoginTwoStepResult v) => v.userType;
  static const Field<FCLoginTwoStepResult, String> _f$userType = Field(
    'userType',
    _$userType,
    opt: true,
  );
  static String? _$iconUrl(FCLoginTwoStepResult v) => v.iconUrl;
  static const Field<FCLoginTwoStepResult, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static int _$postCount(FCLoginTwoStepResult v) => v.postCount;
  static const Field<FCLoginTwoStepResult, int> _f$postCount = Field(
    'postCount',
    _$postCount,
    opt: true,
    def: 0,
  );
  static DateTime? _$registrationTime(FCLoginTwoStepResult v) =>
      v.registrationTime;
  static const Field<FCLoginTwoStepResult, DateTime> _f$registrationTime =
      Field('registrationTime', _$registrationTime, opt: true);
  static DateTime? _$lastActivityTime(FCLoginTwoStepResult v) =>
      v.lastActivityTime;
  static const Field<FCLoginTwoStepResult, DateTime> _f$lastActivityTime =
      Field('lastActivityTime', _$lastActivityTime, opt: true);
  static bool _$isOnline(FCLoginTwoStepResult v) => v.isOnline;
  static const Field<FCLoginTwoStepResult, bool> _f$isOnline = Field(
    'isOnline',
    _$isOnline,
    opt: true,
    def: false,
  );
  static String? _$currentActivity(FCLoginTwoStepResult v) => v.currentActivity;
  static const Field<FCLoginTwoStepResult, String> _f$currentActivity = Field(
    'currentActivity',
    _$currentActivity,
    opt: true,
  );
  static String? _$currentTopicId(FCLoginTwoStepResult v) => v.currentTopicId;
  static const Field<FCLoginTwoStepResult, String> _f$currentTopicId = Field(
    'currentTopicId',
    _$currentTopicId,
    opt: true,
  );
  static bool _$acceptsPM(FCLoginTwoStepResult v) => v.acceptsPM;
  static const Field<FCLoginTwoStepResult, bool> _f$acceptsPM = Field(
    'acceptsPM',
    _$acceptsPM,
    opt: true,
    def: false,
  );
  static bool _$canSendPM(FCLoginTwoStepResult v) => v.canSendPM;
  static const Field<FCLoginTwoStepResult, bool> _f$canSendPM = Field(
    'canSendPM',
    _$canSendPM,
    opt: true,
    def: false,
  );
  static bool _$canPM(FCLoginTwoStepResult v) => v.canPM;
  static const Field<FCLoginTwoStepResult, bool> _f$canPM = Field(
    'canPM',
    _$canPM,
    opt: true,
    def: false,
  );
  static bool _$isFollowing(FCLoginTwoStepResult v) => v.isFollowing;
  static const Field<FCLoginTwoStepResult, bool> _f$isFollowing = Field(
    'isFollowing',
    _$isFollowing,
    opt: true,
    def: false,
  );
  static bool _$isFollowingMe(FCLoginTwoStepResult v) => v.isFollowingMe;
  static const Field<FCLoginTwoStepResult, bool> _f$isFollowingMe = Field(
    'isFollowingMe',
    _$isFollowingMe,
    opt: true,
    def: false,
  );
  static bool _$acceptsFollowers(FCLoginTwoStepResult v) => v.acceptsFollowers;
  static const Field<FCLoginTwoStepResult, bool> _f$acceptsFollowers = Field(
    'acceptsFollowers',
    _$acceptsFollowers,
    opt: true,
    def: false,
  );
  static int _$followingCount(FCLoginTwoStepResult v) => v.followingCount;
  static const Field<FCLoginTwoStepResult, int> _f$followingCount = Field(
    'followingCount',
    _$followingCount,
    opt: true,
    def: 0,
  );
  static int _$followerCount(FCLoginTwoStepResult v) => v.followerCount;
  static const Field<FCLoginTwoStepResult, int> _f$followerCount = Field(
    'followerCount',
    _$followerCount,
    opt: true,
    def: 0,
  );
  static String? _$displayText(FCLoginTwoStepResult v) => v.displayText;
  static const Field<FCLoginTwoStepResult, String> _f$displayText = Field(
    'displayText',
    _$displayText,
    opt: true,
  );
  static List<FCUserCustomField> _$customFields(FCLoginTwoStepResult v) =>
      v.customFields;
  static const Field<FCLoginTwoStepResult, List<FCUserCustomField>>
  _f$customFields = Field(
    'customFields',
    _$customFields,
    opt: true,
    def: const [],
  );
  static bool _$canBan(FCLoginTwoStepResult v) => v.canBan;
  static const Field<FCLoginTwoStepResult, bool> _f$canBan = Field(
    'canBan',
    _$canBan,
    opt: true,
    def: false,
  );
  static bool _$isBanned(FCLoginTwoStepResult v) => v.isBanned;
  static const Field<FCLoginTwoStepResult, bool> _f$isBanned = Field(
    'isBanned',
    _$isBanned,
    opt: true,
    def: false,
  );
  static bool _$isIgnored(FCLoginTwoStepResult v) => v.isIgnored;
  static const Field<FCLoginTwoStepResult, bool> _f$isIgnored = Field(
    'isIgnored',
    _$isIgnored,
    opt: true,
    def: false,
  );
  static bool _$canSpamClean(FCLoginTwoStepResult v) => v.canSpamClean;
  static const Field<FCLoginTwoStepResult, bool> _f$canSpamClean = Field(
    'canSpamClean',
    _$canSpamClean,
    opt: true,
    def: false,
  );
  static bool _$canBeReported(FCLoginTwoStepResult v) => v.canBeReported;
  static const Field<FCLoginTwoStepResult, bool> _f$canBeReported = Field(
    'canBeReported',
    _$canBeReported,
    opt: true,
    def: false,
  );
  static List<String> _$userGroups(FCLoginTwoStepResult v) => v.userGroups;
  static const Field<FCLoginTwoStepResult, List<String>> _f$userGroups = Field(
    'userGroups',
    _$userGroups,
    opt: true,
    def: const [],
  );
  static bool _$canModerate(FCLoginTwoStepResult v) => v.canModerate;
  static const Field<FCLoginTwoStepResult, bool> _f$canModerate = Field(
    'canModerate',
    _$canModerate,
    opt: true,
    def: false,
  );
  static bool _$canSearch(FCLoginTwoStepResult v) => v.canSearch;
  static const Field<FCLoginTwoStepResult, bool> _f$canSearch = Field(
    'canSearch',
    _$canSearch,
    opt: true,
    def: false,
  );
  static String? _$userState(FCLoginTwoStepResult v) => v.userState;
  static const Field<FCLoginTwoStepResult, String> _f$userState = Field(
    'userState',
    _$userState,
    opt: true,
    def: 'valid',
  );
  static bool _$canWhosonline(FCLoginTwoStepResult v) => v.canWhosonline;
  static const Field<FCLoginTwoStepResult, bool> _f$canWhosonline = Field(
    'canWhosonline',
    _$canWhosonline,
    opt: true,
    def: false,
  );
  static bool _$canProfile(FCLoginTwoStepResult v) => v.canProfile;
  static const Field<FCLoginTwoStepResult, bool> _f$canProfile = Field(
    'canProfile',
    _$canProfile,
    opt: true,
    def: false,
  );
  static bool _$canUploadAvatar(FCLoginTwoStepResult v) => v.canUploadAvatar;
  static const Field<FCLoginTwoStepResult, bool> _f$canUploadAvatar = Field(
    'canUploadAvatar',
    _$canUploadAvatar,
    opt: true,
    def: false,
  );
  static int _$maxAttachment(FCLoginTwoStepResult v) => v.maxAttachment;
  static const Field<FCLoginTwoStepResult, int> _f$maxAttachment = Field(
    'maxAttachment',
    _$maxAttachment,
    opt: true,
    def: 0,
  );
  static int _$maxPngSize(FCLoginTwoStepResult v) => v.maxPngSize;
  static const Field<FCLoginTwoStepResult, int> _f$maxPngSize = Field(
    'maxPngSize',
    _$maxPngSize,
    opt: true,
    def: 0,
  );
  static int _$maxJpgSize(FCLoginTwoStepResult v) => v.maxJpgSize;
  static const Field<FCLoginTwoStepResult, int> _f$maxJpgSize = Field(
    'maxJpgSize',
    _$maxJpgSize,
    opt: true,
    def: 0,
  );
  static String? _$ignoredUids(FCLoginTwoStepResult v) => v.ignoredUids;
  static const Field<FCLoginTwoStepResult, String> _f$ignoredUids = Field(
    'ignoredUids',
    _$ignoredUids,
    opt: true,
  );
  static String? _$allowedExtensions(FCLoginTwoStepResult v) =>
      v.allowedExtensions;
  static const Field<FCLoginTwoStepResult, String> _f$allowedExtensions = Field(
    'allowedExtensions',
    _$allowedExtensions,
    opt: true,
  );
  static int _$postCountdown(FCLoginTwoStepResult v) => v.postCountdown;
  static const Field<FCLoginTwoStepResult, int> _f$postCountdown = Field(
    'postCountdown',
    _$postCountdown,
    opt: true,
    def: 0,
  );
  static String? _$trustCode(FCLoginTwoStepResult v) => v.trustCode;
  static const Field<FCLoginTwoStepResult, String> _f$trustCode = Field(
    'trustCode',
    _$trustCode,
    opt: true,
  );
  static bool _$twoStepRequired(FCLoginTwoStepResult v) => v.twoStepRequired;
  static const Field<FCLoginTwoStepResult, bool> _f$twoStepRequired = Field(
    'twoStepRequired',
    _$twoStepRequired,
    opt: true,
    def: false,
  );
  static String? _$userpassword(FCLoginTwoStepResult v) => v.userpassword;
  static const Field<FCLoginTwoStepResult, String> _f$userpassword = Field(
    'userpassword',
    _$userpassword,
    opt: true,
  );
  static bool _$isProblematicUrl(FCLoginTwoStepResult v) => v.isProblematicUrl;
  static const Field<FCLoginTwoStepResult, bool> _f$isProblematicUrl = Field(
    'isProblematicUrl',
    _$isProblematicUrl,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<FCLoginTwoStepResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
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
    #canWhosonline: _f$canWhosonline,
    #canProfile: _f$canProfile,
    #canUploadAvatar: _f$canUploadAvatar,
    #maxAttachment: _f$maxAttachment,
    #maxPngSize: _f$maxPngSize,
    #maxJpgSize: _f$maxJpgSize,
    #ignoredUids: _f$ignoredUids,
    #allowedExtensions: _f$allowedExtensions,
    #postCountdown: _f$postCountdown,
    #trustCode: _f$trustCode,
    #twoStepRequired: _f$twoStepRequired,
    #userpassword: _f$userpassword,
    #isProblematicUrl: _f$isProblematicUrl,
  };

  static FCLoginTwoStepResult _instantiate(DecodingData data) {
    return FCLoginTwoStepResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
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
      canWhosonline: data.dec(_f$canWhosonline),
      canProfile: data.dec(_f$canProfile),
      canUploadAvatar: data.dec(_f$canUploadAvatar),
      maxAttachment: data.dec(_f$maxAttachment),
      maxPngSize: data.dec(_f$maxPngSize),
      maxJpgSize: data.dec(_f$maxJpgSize),
      ignoredUids: data.dec(_f$ignoredUids),
      allowedExtensions: data.dec(_f$allowedExtensions),
      postCountdown: data.dec(_f$postCountdown),
      trustCode: data.dec(_f$trustCode),
      twoStepRequired: data.dec(_f$twoStepRequired),
      userpassword: data.dec(_f$userpassword),
      isProblematicUrl: data.dec(_f$isProblematicUrl),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCLoginTwoStepResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCLoginTwoStepResult>(map);
  }

  static FCLoginTwoStepResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCLoginTwoStepResult>(json);
  }
}

mixin FCLoginTwoStepResultMappable {
  String toJson() {
    return FCLoginTwoStepResultMapper.ensureInitialized()
        .encodeJson<FCLoginTwoStepResult>(this as FCLoginTwoStepResult);
  }

  Map<String, dynamic> toMap() {
    return FCLoginTwoStepResultMapper.ensureInitialized()
        .encodeMap<FCLoginTwoStepResult>(this as FCLoginTwoStepResult);
  }

  FCLoginTwoStepResultCopyWith<
    FCLoginTwoStepResult,
    FCLoginTwoStepResult,
    FCLoginTwoStepResult
  >
  get copyWith =>
      _FCLoginTwoStepResultCopyWithImpl<
        FCLoginTwoStepResult,
        FCLoginTwoStepResult
      >(this as FCLoginTwoStepResult, $identity, $identity);
  @override
  String toString() {
    return FCLoginTwoStepResultMapper.ensureInitialized().stringifyValue(
      this as FCLoginTwoStepResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCLoginTwoStepResultMapper.ensureInitialized().equalsValue(
      this as FCLoginTwoStepResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCLoginTwoStepResultMapper.ensureInitialized().hashValue(
      this as FCLoginTwoStepResult,
    );
  }
}

extension FCLoginTwoStepResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCLoginTwoStepResult, $Out> {
  FCLoginTwoStepResultCopyWith<$R, FCLoginTwoStepResult, $Out>
  get $asFCLoginTwoStepResult => $base.as(
    (v, t, t2) => _FCLoginTwoStepResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCLoginTwoStepResultCopyWith<
  $R,
  $In extends FCLoginTwoStepResult,
  $Out
>
    implements FCUserCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<
    $R,
    FCUserCustomField,
    FCUserCustomFieldCopyWith<$R, FCUserCustomField, FCUserCustomField>
  >
  get customFields;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get userGroups;
  @override
  $R call({
    bool? result,
    String? resultText,
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
    bool? canWhosonline,
    bool? canProfile,
    bool? canUploadAvatar,
    int? maxAttachment,
    int? maxPngSize,
    int? maxJpgSize,
    String? ignoredUids,
    String? allowedExtensions,
    int? postCountdown,
    String? trustCode,
    bool? twoStepRequired,
    String? userpassword,
    bool? isProblematicUrl,
  });
  FCLoginTwoStepResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCLoginTwoStepResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCLoginTwoStepResult, $Out>
    implements FCLoginTwoStepResultCopyWith<$R, FCLoginTwoStepResult, $Out> {
  _FCLoginTwoStepResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCLoginTwoStepResult> $mapper =
      FCLoginTwoStepResultMapper.ensureInitialized();
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
    bool? result,
    Object? resultText = $none,
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
    bool? canWhosonline,
    bool? canProfile,
    bool? canUploadAvatar,
    int? maxAttachment,
    int? maxPngSize,
    int? maxJpgSize,
    Object? ignoredUids = $none,
    Object? allowedExtensions = $none,
    int? postCountdown,
    Object? trustCode = $none,
    bool? twoStepRequired,
    Object? userpassword = $none,
    bool? isProblematicUrl,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
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
      if (canWhosonline != null) #canWhosonline: canWhosonline,
      if (canProfile != null) #canProfile: canProfile,
      if (canUploadAvatar != null) #canUploadAvatar: canUploadAvatar,
      if (maxAttachment != null) #maxAttachment: maxAttachment,
      if (maxPngSize != null) #maxPngSize: maxPngSize,
      if (maxJpgSize != null) #maxJpgSize: maxJpgSize,
      if (ignoredUids != $none) #ignoredUids: ignoredUids,
      if (allowedExtensions != $none) #allowedExtensions: allowedExtensions,
      if (postCountdown != null) #postCountdown: postCountdown,
      if (trustCode != $none) #trustCode: trustCode,
      if (twoStepRequired != null) #twoStepRequired: twoStepRequired,
      if (userpassword != $none) #userpassword: userpassword,
      if (isProblematicUrl != null) #isProblematicUrl: isProblematicUrl,
    }),
  );
  @override
  FCLoginTwoStepResult $make(CopyWithData data) => FCLoginTwoStepResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
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
    canWhosonline: data.get(#canWhosonline, or: $value.canWhosonline),
    canProfile: data.get(#canProfile, or: $value.canProfile),
    canUploadAvatar: data.get(#canUploadAvatar, or: $value.canUploadAvatar),
    maxAttachment: data.get(#maxAttachment, or: $value.maxAttachment),
    maxPngSize: data.get(#maxPngSize, or: $value.maxPngSize),
    maxJpgSize: data.get(#maxJpgSize, or: $value.maxJpgSize),
    ignoredUids: data.get(#ignoredUids, or: $value.ignoredUids),
    allowedExtensions: data.get(
      #allowedExtensions,
      or: $value.allowedExtensions,
    ),
    postCountdown: data.get(#postCountdown, or: $value.postCountdown),
    trustCode: data.get(#trustCode, or: $value.trustCode),
    twoStepRequired: data.get(#twoStepRequired, or: $value.twoStepRequired),
    userpassword: data.get(#userpassword, or: $value.userpassword),
    isProblematicUrl: data.get(#isProblematicUrl, or: $value.isProblematicUrl),
  );

  @override
  FCLoginTwoStepResultCopyWith<$R2, FCLoginTwoStepResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCLoginTwoStepResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCOnlineUserResultMapper extends ClassMapperBase<FCOnlineUserResult> {
  FCOnlineUserResultMapper._();

  static FCOnlineUserResultMapper? _instance;
  static FCOnlineUserResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCOnlineUserResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCOnlineUserMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCOnlineUserResult';

  static bool _$result(FCOnlineUserResult v) => v.result;
  static const Field<FCOnlineUserResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCOnlineUserResult v) => v.resultText;
  static const Field<FCOnlineUserResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$total(FCOnlineUserResult v) => v.total;
  static const Field<FCOnlineUserResult, int> _f$total = Field(
    'total',
    _$total,
    opt: true,
    def: 0,
  );
  static List<FCOnlineUser> _$list(FCOnlineUserResult v) => v.list;
  static const Field<FCOnlineUserResult, List<FCOnlineUser>> _f$list = Field(
    'list',
    _$list,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCOnlineUserResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #total: _f$total,
    #list: _f$list,
  };

  static FCOnlineUserResult _instantiate(DecodingData data) {
    return FCOnlineUserResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      total: data.dec(_f$total),
      list: data.dec(_f$list),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCOnlineUserResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCOnlineUserResult>(map);
  }

  static FCOnlineUserResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCOnlineUserResult>(json);
  }
}

mixin FCOnlineUserResultMappable {
  String toJson() {
    return FCOnlineUserResultMapper.ensureInitialized()
        .encodeJson<FCOnlineUserResult>(this as FCOnlineUserResult);
  }

  Map<String, dynamic> toMap() {
    return FCOnlineUserResultMapper.ensureInitialized()
        .encodeMap<FCOnlineUserResult>(this as FCOnlineUserResult);
  }

  FCOnlineUserResultCopyWith<
    FCOnlineUserResult,
    FCOnlineUserResult,
    FCOnlineUserResult
  >
  get copyWith =>
      _FCOnlineUserResultCopyWithImpl<FCOnlineUserResult, FCOnlineUserResult>(
        this as FCOnlineUserResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCOnlineUserResultMapper.ensureInitialized().stringifyValue(
      this as FCOnlineUserResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCOnlineUserResultMapper.ensureInitialized().equalsValue(
      this as FCOnlineUserResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCOnlineUserResultMapper.ensureInitialized().hashValue(
      this as FCOnlineUserResult,
    );
  }
}

extension FCOnlineUserResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCOnlineUserResult, $Out> {
  FCOnlineUserResultCopyWith<$R, FCOnlineUserResult, $Out>
  get $asFCOnlineUserResult => $base.as(
    (v, t, t2) => _FCOnlineUserResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCOnlineUserResultCopyWith<
  $R,
  $In extends FCOnlineUserResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCOnlineUser,
    FCOnlineUserCopyWith<$R, FCOnlineUser, FCOnlineUser>
  >
  get list;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? total,
    List<FCOnlineUser>? list,
  });
  FCOnlineUserResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCOnlineUserResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCOnlineUserResult, $Out>
    implements FCOnlineUserResultCopyWith<$R, FCOnlineUserResult, $Out> {
  _FCOnlineUserResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCOnlineUserResult> $mapper =
      FCOnlineUserResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCOnlineUser,
    FCOnlineUserCopyWith<$R, FCOnlineUser, FCOnlineUser>
  >
  get list => ListCopyWith(
    $value.list,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(list: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? total,
    List<FCOnlineUser>? list,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (total != null) #total: total,
      if (list != null) #list: list,
    }),
  );
  @override
  FCOnlineUserResult $make(CopyWithData data) => FCOnlineUserResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    total: data.get(#total, or: $value.total),
    list: data.get(#list, or: $value.list),
  );

  @override
  FCOnlineUserResultCopyWith<$R2, FCOnlineUserResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCOnlineUserResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCOnlineUserMapper extends ClassMapperBase<FCOnlineUser> {
  FCOnlineUserMapper._();

  static FCOnlineUserMapper? _instance;
  static FCOnlineUserMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCOnlineUserMapper._());
      FCUserMapper.ensureInitialized();
      FCUserCustomFieldMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCOnlineUser';

  static String _$id(FCOnlineUser v) => v.id;
  static const Field<FCOnlineUser, String> _f$id = Field('id', _$id);
  static String _$username(FCOnlineUser v) => v.username;
  static const Field<FCOnlineUser, String> _f$username = Field(
    'username',
    _$username,
  );
  static String? _$loginName(FCOnlineUser v) => v.loginName;
  static const Field<FCOnlineUser, String> _f$loginName = Field(
    'loginName',
    _$loginName,
    opt: true,
  );
  static String? _$email(FCOnlineUser v) => v.email;
  static const Field<FCOnlineUser, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static String? _$userType(FCOnlineUser v) => v.userType;
  static const Field<FCOnlineUser, String> _f$userType = Field(
    'userType',
    _$userType,
    opt: true,
  );
  static String? _$iconUrl(FCOnlineUser v) => v.iconUrl;
  static const Field<FCOnlineUser, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static int _$postCount(FCOnlineUser v) => v.postCount;
  static const Field<FCOnlineUser, int> _f$postCount = Field(
    'postCount',
    _$postCount,
    opt: true,
    def: 0,
  );
  static DateTime? _$registrationTime(FCOnlineUser v) => v.registrationTime;
  static const Field<FCOnlineUser, DateTime> _f$registrationTime = Field(
    'registrationTime',
    _$registrationTime,
    opt: true,
  );
  static DateTime? _$lastActivityTime(FCOnlineUser v) => v.lastActivityTime;
  static const Field<FCOnlineUser, DateTime> _f$lastActivityTime = Field(
    'lastActivityTime',
    _$lastActivityTime,
    opt: true,
  );
  static bool _$isOnline(FCOnlineUser v) => v.isOnline;
  static const Field<FCOnlineUser, bool> _f$isOnline = Field(
    'isOnline',
    _$isOnline,
    opt: true,
    def: false,
  );
  static String? _$currentActivity(FCOnlineUser v) => v.currentActivity;
  static const Field<FCOnlineUser, String> _f$currentActivity = Field(
    'currentActivity',
    _$currentActivity,
    opt: true,
  );
  static String? _$currentTopicId(FCOnlineUser v) => v.currentTopicId;
  static const Field<FCOnlineUser, String> _f$currentTopicId = Field(
    'currentTopicId',
    _$currentTopicId,
    opt: true,
  );
  static bool _$acceptsPM(FCOnlineUser v) => v.acceptsPM;
  static const Field<FCOnlineUser, bool> _f$acceptsPM = Field(
    'acceptsPM',
    _$acceptsPM,
    opt: true,
    def: false,
  );
  static bool _$canSendPM(FCOnlineUser v) => v.canSendPM;
  static const Field<FCOnlineUser, bool> _f$canSendPM = Field(
    'canSendPM',
    _$canSendPM,
    opt: true,
    def: false,
  );
  static bool _$canPM(FCOnlineUser v) => v.canPM;
  static const Field<FCOnlineUser, bool> _f$canPM = Field(
    'canPM',
    _$canPM,
    opt: true,
    def: false,
  );
  static bool _$isFollowing(FCOnlineUser v) => v.isFollowing;
  static const Field<FCOnlineUser, bool> _f$isFollowing = Field(
    'isFollowing',
    _$isFollowing,
    opt: true,
    def: false,
  );
  static bool _$isFollowingMe(FCOnlineUser v) => v.isFollowingMe;
  static const Field<FCOnlineUser, bool> _f$isFollowingMe = Field(
    'isFollowingMe',
    _$isFollowingMe,
    opt: true,
    def: false,
  );
  static bool _$acceptsFollowers(FCOnlineUser v) => v.acceptsFollowers;
  static const Field<FCOnlineUser, bool> _f$acceptsFollowers = Field(
    'acceptsFollowers',
    _$acceptsFollowers,
    opt: true,
    def: false,
  );
  static int _$followingCount(FCOnlineUser v) => v.followingCount;
  static const Field<FCOnlineUser, int> _f$followingCount = Field(
    'followingCount',
    _$followingCount,
    opt: true,
    def: 0,
  );
  static int _$followerCount(FCOnlineUser v) => v.followerCount;
  static const Field<FCOnlineUser, int> _f$followerCount = Field(
    'followerCount',
    _$followerCount,
    opt: true,
    def: 0,
  );
  static String? _$displayText(FCOnlineUser v) => v.displayText;
  static const Field<FCOnlineUser, String> _f$displayText = Field(
    'displayText',
    _$displayText,
    opt: true,
  );
  static List<FCUserCustomField> _$customFields(FCOnlineUser v) =>
      v.customFields;
  static const Field<FCOnlineUser, List<FCUserCustomField>> _f$customFields =
      Field('customFields', _$customFields, opt: true, def: const []);
  static bool _$canBan(FCOnlineUser v) => v.canBan;
  static const Field<FCOnlineUser, bool> _f$canBan = Field(
    'canBan',
    _$canBan,
    opt: true,
    def: false,
  );
  static bool _$isBanned(FCOnlineUser v) => v.isBanned;
  static const Field<FCOnlineUser, bool> _f$isBanned = Field(
    'isBanned',
    _$isBanned,
    opt: true,
    def: false,
  );
  static bool _$isIgnored(FCOnlineUser v) => v.isIgnored;
  static const Field<FCOnlineUser, bool> _f$isIgnored = Field(
    'isIgnored',
    _$isIgnored,
    opt: true,
    def: false,
  );
  static bool _$canSpamClean(FCOnlineUser v) => v.canSpamClean;
  static const Field<FCOnlineUser, bool> _f$canSpamClean = Field(
    'canSpamClean',
    _$canSpamClean,
    opt: true,
    def: false,
  );
  static bool _$canBeReported(FCOnlineUser v) => v.canBeReported;
  static const Field<FCOnlineUser, bool> _f$canBeReported = Field(
    'canBeReported',
    _$canBeReported,
    opt: true,
    def: false,
  );
  static List<String> _$userGroups(FCOnlineUser v) => v.userGroups;
  static const Field<FCOnlineUser, List<String>> _f$userGroups = Field(
    'userGroups',
    _$userGroups,
    opt: true,
    def: const [],
  );
  static bool _$canModerate(FCOnlineUser v) => v.canModerate;
  static const Field<FCOnlineUser, bool> _f$canModerate = Field(
    'canModerate',
    _$canModerate,
    opt: true,
    def: false,
  );
  static bool _$canSearch(FCOnlineUser v) => v.canSearch;
  static const Field<FCOnlineUser, bool> _f$canSearch = Field(
    'canSearch',
    _$canSearch,
    opt: true,
    def: false,
  );
  static String? _$userState(FCOnlineUser v) => v.userState;
  static const Field<FCOnlineUser, String> _f$userState = Field(
    'userState',
    _$userState,
    opt: true,
    def: 'valid',
  );
  static String? _$location(FCOnlineUser v) => v.location;
  static const Field<FCOnlineUser, String> _f$location = Field(
    'location',
    _$location,
    opt: true,
  );

  @override
  final MappableFields<FCOnlineUser> fields = const {
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
    #location: _f$location,
  };

  static FCOnlineUser _instantiate(DecodingData data) {
    return FCOnlineUser(
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
      location: data.dec(_f$location),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCOnlineUser fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCOnlineUser>(map);
  }

  static FCOnlineUser fromJson(String json) {
    return ensureInitialized().decodeJson<FCOnlineUser>(json);
  }
}

mixin FCOnlineUserMappable {
  String toJson() {
    return FCOnlineUserMapper.ensureInitialized().encodeJson<FCOnlineUser>(
      this as FCOnlineUser,
    );
  }

  Map<String, dynamic> toMap() {
    return FCOnlineUserMapper.ensureInitialized().encodeMap<FCOnlineUser>(
      this as FCOnlineUser,
    );
  }

  FCOnlineUserCopyWith<FCOnlineUser, FCOnlineUser, FCOnlineUser> get copyWith =>
      _FCOnlineUserCopyWithImpl<FCOnlineUser, FCOnlineUser>(
        this as FCOnlineUser,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCOnlineUserMapper.ensureInitialized().stringifyValue(
      this as FCOnlineUser,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCOnlineUserMapper.ensureInitialized().equalsValue(
      this as FCOnlineUser,
      other,
    );
  }

  @override
  int get hashCode {
    return FCOnlineUserMapper.ensureInitialized().hashValue(
      this as FCOnlineUser,
    );
  }
}

extension FCOnlineUserValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCOnlineUser, $Out> {
  FCOnlineUserCopyWith<$R, FCOnlineUser, $Out> get $asFCOnlineUser =>
      $base.as((v, t, t2) => _FCOnlineUserCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCOnlineUserCopyWith<$R, $In extends FCOnlineUser, $Out>
    implements FCUserCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<
    $R,
    FCUserCustomField,
    FCUserCustomFieldCopyWith<$R, FCUserCustomField, FCUserCustomField>
  >
  get customFields;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get userGroups;
  @override
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
    String? location,
  });
  FCOnlineUserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCOnlineUserCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCOnlineUser, $Out>
    implements FCOnlineUserCopyWith<$R, FCOnlineUser, $Out> {
  _FCOnlineUserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCOnlineUser> $mapper =
      FCOnlineUserMapper.ensureInitialized();
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
    Object? location = $none,
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
      if (location != $none) #location: location,
    }),
  );
  @override
  FCOnlineUser $make(CopyWithData data) => FCOnlineUser(
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
    location: data.get(#location, or: $value.location),
  );

  @override
  FCOnlineUserCopyWith<$R2, FCOnlineUser, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCOnlineUserCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUserInfoResultMapper extends ClassMapperBase<FCUserInfoResult> {
  FCUserInfoResultMapper._();

  static FCUserInfoResultMapper? _instance;
  static FCUserInfoResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUserInfoResultMapper._());
      FCUserMapper.ensureInitialized();
      FCUserCustomFieldMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUserInfoResult';

  static bool _$result(FCUserInfoResult v) => v.result;
  static const Field<FCUserInfoResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUserInfoResult v) => v.resultText;
  static const Field<FCUserInfoResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static String _$id(FCUserInfoResult v) => v.id;
  static const Field<FCUserInfoResult, String> _f$id = Field('id', _$id);
  static String _$username(FCUserInfoResult v) => v.username;
  static const Field<FCUserInfoResult, String> _f$username = Field(
    'username',
    _$username,
  );
  static String? _$loginName(FCUserInfoResult v) => v.loginName;
  static const Field<FCUserInfoResult, String> _f$loginName = Field(
    'loginName',
    _$loginName,
    opt: true,
  );
  static String? _$email(FCUserInfoResult v) => v.email;
  static const Field<FCUserInfoResult, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static String? _$userType(FCUserInfoResult v) => v.userType;
  static const Field<FCUserInfoResult, String> _f$userType = Field(
    'userType',
    _$userType,
    opt: true,
  );
  static String? _$iconUrl(FCUserInfoResult v) => v.iconUrl;
  static const Field<FCUserInfoResult, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static int _$postCount(FCUserInfoResult v) => v.postCount;
  static const Field<FCUserInfoResult, int> _f$postCount = Field(
    'postCount',
    _$postCount,
    opt: true,
    def: 0,
  );
  static DateTime? _$registrationTime(FCUserInfoResult v) => v.registrationTime;
  static const Field<FCUserInfoResult, DateTime> _f$registrationTime = Field(
    'registrationTime',
    _$registrationTime,
    opt: true,
  );
  static DateTime? _$lastActivityTime(FCUserInfoResult v) => v.lastActivityTime;
  static const Field<FCUserInfoResult, DateTime> _f$lastActivityTime = Field(
    'lastActivityTime',
    _$lastActivityTime,
    opt: true,
  );
  static bool _$isOnline(FCUserInfoResult v) => v.isOnline;
  static const Field<FCUserInfoResult, bool> _f$isOnline = Field(
    'isOnline',
    _$isOnline,
    opt: true,
    def: false,
  );
  static String? _$currentActivity(FCUserInfoResult v) => v.currentActivity;
  static const Field<FCUserInfoResult, String> _f$currentActivity = Field(
    'currentActivity',
    _$currentActivity,
    opt: true,
  );
  static String? _$currentTopicId(FCUserInfoResult v) => v.currentTopicId;
  static const Field<FCUserInfoResult, String> _f$currentTopicId = Field(
    'currentTopicId',
    _$currentTopicId,
    opt: true,
  );
  static bool _$acceptsPM(FCUserInfoResult v) => v.acceptsPM;
  static const Field<FCUserInfoResult, bool> _f$acceptsPM = Field(
    'acceptsPM',
    _$acceptsPM,
    opt: true,
    def: false,
  );
  static bool _$canSendPM(FCUserInfoResult v) => v.canSendPM;
  static const Field<FCUserInfoResult, bool> _f$canSendPM = Field(
    'canSendPM',
    _$canSendPM,
    opt: true,
    def: false,
  );
  static bool _$canPM(FCUserInfoResult v) => v.canPM;
  static const Field<FCUserInfoResult, bool> _f$canPM = Field(
    'canPM',
    _$canPM,
    opt: true,
    def: false,
  );
  static bool _$isFollowing(FCUserInfoResult v) => v.isFollowing;
  static const Field<FCUserInfoResult, bool> _f$isFollowing = Field(
    'isFollowing',
    _$isFollowing,
    opt: true,
    def: false,
  );
  static bool _$isFollowingMe(FCUserInfoResult v) => v.isFollowingMe;
  static const Field<FCUserInfoResult, bool> _f$isFollowingMe = Field(
    'isFollowingMe',
    _$isFollowingMe,
    opt: true,
    def: false,
  );
  static bool _$acceptsFollowers(FCUserInfoResult v) => v.acceptsFollowers;
  static const Field<FCUserInfoResult, bool> _f$acceptsFollowers = Field(
    'acceptsFollowers',
    _$acceptsFollowers,
    opt: true,
    def: false,
  );
  static int _$followingCount(FCUserInfoResult v) => v.followingCount;
  static const Field<FCUserInfoResult, int> _f$followingCount = Field(
    'followingCount',
    _$followingCount,
    opt: true,
    def: 0,
  );
  static int _$followerCount(FCUserInfoResult v) => v.followerCount;
  static const Field<FCUserInfoResult, int> _f$followerCount = Field(
    'followerCount',
    _$followerCount,
    opt: true,
    def: 0,
  );
  static String? _$displayText(FCUserInfoResult v) => v.displayText;
  static const Field<FCUserInfoResult, String> _f$displayText = Field(
    'displayText',
    _$displayText,
    opt: true,
  );
  static List<FCUserCustomField> _$customFields(FCUserInfoResult v) =>
      v.customFields;
  static const Field<FCUserInfoResult, List<FCUserCustomField>>
  _f$customFields = Field(
    'customFields',
    _$customFields,
    opt: true,
    def: const [],
  );
  static bool _$canBan(FCUserInfoResult v) => v.canBan;
  static const Field<FCUserInfoResult, bool> _f$canBan = Field(
    'canBan',
    _$canBan,
    opt: true,
    def: false,
  );
  static bool _$isBanned(FCUserInfoResult v) => v.isBanned;
  static const Field<FCUserInfoResult, bool> _f$isBanned = Field(
    'isBanned',
    _$isBanned,
    opt: true,
    def: false,
  );
  static bool _$isIgnored(FCUserInfoResult v) => v.isIgnored;
  static const Field<FCUserInfoResult, bool> _f$isIgnored = Field(
    'isIgnored',
    _$isIgnored,
    opt: true,
    def: false,
  );
  static bool _$canSpamClean(FCUserInfoResult v) => v.canSpamClean;
  static const Field<FCUserInfoResult, bool> _f$canSpamClean = Field(
    'canSpamClean',
    _$canSpamClean,
    opt: true,
    def: false,
  );
  static bool _$canBeReported(FCUserInfoResult v) => v.canBeReported;
  static const Field<FCUserInfoResult, bool> _f$canBeReported = Field(
    'canBeReported',
    _$canBeReported,
    opt: true,
    def: false,
  );
  static List<String> _$userGroups(FCUserInfoResult v) => v.userGroups;
  static const Field<FCUserInfoResult, List<String>> _f$userGroups = Field(
    'userGroups',
    _$userGroups,
    opt: true,
    def: const [],
  );
  static bool _$canModerate(FCUserInfoResult v) => v.canModerate;
  static const Field<FCUserInfoResult, bool> _f$canModerate = Field(
    'canModerate',
    _$canModerate,
    opt: true,
    def: false,
  );
  static bool _$canSearch(FCUserInfoResult v) => v.canSearch;
  static const Field<FCUserInfoResult, bool> _f$canSearch = Field(
    'canSearch',
    _$canSearch,
    opt: true,
    def: false,
  );
  static String? _$userState(FCUserInfoResult v) => v.userState;
  static const Field<FCUserInfoResult, String> _f$userState = Field(
    'userState',
    _$userState,
    opt: true,
    def: 'valid',
  );
  static String? _$status(FCUserInfoResult v) => v.status;
  static const Field<FCUserInfoResult, String> _f$status = Field(
    'status',
    _$status,
    opt: true,
  );
  static String? _$signature(FCUserInfoResult v) => v.signature;
  static const Field<FCUserInfoResult, String> _f$signature = Field(
    'signature',
    _$signature,
    opt: true,
  );
  static String? _$location(FCUserInfoResult v) => v.location;
  static const Field<FCUserInfoResult, String> _f$location = Field(
    'location',
    _$location,
    opt: true,
  );
  static String? _$website(FCUserInfoResult v) => v.website;
  static const Field<FCUserInfoResult, String> _f$website = Field(
    'website',
    _$website,
    opt: true,
  );
  static String? _$interests(FCUserInfoResult v) => v.interests;
  static const Field<FCUserInfoResult, String> _f$interests = Field(
    'interests',
    _$interests,
    opt: true,
  );
  static String? _$occupation(FCUserInfoResult v) => v.occupation;
  static const Field<FCUserInfoResult, String> _f$occupation = Field(
    'occupation',
    _$occupation,
    opt: true,
  );
  static String? _$bio(FCUserInfoResult v) => v.bio;
  static const Field<FCUserInfoResult, String> _f$bio = Field(
    'bio',
    _$bio,
    opt: true,
  );
  static DateTime? _$regTime(FCUserInfoResult v) => v.regTime;
  static const Field<FCUserInfoResult, DateTime> _f$regTime = Field(
    'regTime',
    _$regTime,
    opt: true,
  );
  static bool? _$infoIsOnline(FCUserInfoResult v) => v.infoIsOnline;
  static const Field<FCUserInfoResult, bool> _f$infoIsOnline = Field(
    'infoIsOnline',
    _$infoIsOnline,
    opt: true,
  );
  static bool? _$acceptPm(FCUserInfoResult v) => v.acceptPm;
  static const Field<FCUserInfoResult, bool> _f$acceptPm = Field(
    'acceptPm',
    _$acceptPm,
    opt: true,
  );
  static bool? _$canPm(FCUserInfoResult v) => v.canPm;
  static const Field<FCUserInfoResult, bool> _f$canPm = Field(
    'canPm',
    _$canPm,
    opt: true,
  );
  static bool? _$canSendPm(FCUserInfoResult v) => v.canSendPm;
  static const Field<FCUserInfoResult, bool> _f$canSendPm = Field(
    'canSendPm',
    _$canSendPm,
    opt: true,
  );
  static bool? _$iFollowU(FCUserInfoResult v) => v.iFollowU;
  static const Field<FCUserInfoResult, bool> _f$iFollowU = Field(
    'iFollowU',
    _$iFollowU,
    opt: true,
  );
  static bool? _$uFollowMe(FCUserInfoResult v) => v.uFollowMe;
  static const Field<FCUserInfoResult, bool> _f$uFollowMe = Field(
    'uFollowMe',
    _$uFollowMe,
    opt: true,
  );
  static bool? _$acceptFollow(FCUserInfoResult v) => v.acceptFollow;
  static const Field<FCUserInfoResult, bool> _f$acceptFollow = Field(
    'acceptFollow',
    _$acceptFollow,
    opt: true,
  );
  static int? _$infoFollowingCount(FCUserInfoResult v) => v.infoFollowingCount;
  static const Field<FCUserInfoResult, int> _f$infoFollowingCount = Field(
    'infoFollowingCount',
    _$infoFollowingCount,
    opt: true,
  );
  static String? _$follower(FCUserInfoResult v) => v.follower;
  static const Field<FCUserInfoResult, String> _f$follower = Field(
    'follower',
    _$follower,
    opt: true,
  );
  static String? _$infoCurrentActivity(FCUserInfoResult v) =>
      v.infoCurrentActivity;
  static const Field<FCUserInfoResult, String> _f$infoCurrentActivity = Field(
    'infoCurrentActivity',
    _$infoCurrentActivity,
    opt: true,
  );
  static String? _$currentAction(FCUserInfoResult v) => v.currentAction;
  static const Field<FCUserInfoResult, String> _f$currentAction = Field(
    'currentAction',
    _$currentAction,
    opt: true,
  );
  static String? _$topicId(FCUserInfoResult v) => v.topicId;
  static const Field<FCUserInfoResult, String> _f$topicId = Field(
    'topicId',
    _$topicId,
    opt: true,
  );
  static List<dynamic>? _$customFieldsList(FCUserInfoResult v) =>
      v.customFieldsList;
  static const Field<FCUserInfoResult, List<dynamic>> _f$customFieldsList =
      Field('customFieldsList', _$customFieldsList, opt: true);
  static bool? _$infoCanBan(FCUserInfoResult v) => v.infoCanBan;
  static const Field<FCUserInfoResult, bool> _f$infoCanBan = Field(
    'infoCanBan',
    _$infoCanBan,
    opt: true,
  );
  static bool? _$isBan(FCUserInfoResult v) => v.isBan;
  static const Field<FCUserInfoResult, bool> _f$isBan = Field(
    'isBan',
    _$isBan,
    opt: true,
  );
  static bool? _$canMarkSpam(FCUserInfoResult v) => v.canMarkSpam;
  static const Field<FCUserInfoResult, bool> _f$canMarkSpam = Field(
    'canMarkSpam',
    _$canMarkSpam,
    opt: true,
  );
  static bool? _$infoIsIgnored(FCUserInfoResult v) => v.infoIsIgnored;
  static const Field<FCUserInfoResult, bool> _f$infoIsIgnored = Field(
    'infoIsIgnored',
    _$infoIsIgnored,
    opt: true,
  );

  @override
  final MappableFields<FCUserInfoResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
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
    #status: _f$status,
    #signature: _f$signature,
    #location: _f$location,
    #website: _f$website,
    #interests: _f$interests,
    #occupation: _f$occupation,
    #bio: _f$bio,
    #regTime: _f$regTime,
    #infoIsOnline: _f$infoIsOnline,
    #acceptPm: _f$acceptPm,
    #canPm: _f$canPm,
    #canSendPm: _f$canSendPm,
    #iFollowU: _f$iFollowU,
    #uFollowMe: _f$uFollowMe,
    #acceptFollow: _f$acceptFollow,
    #infoFollowingCount: _f$infoFollowingCount,
    #follower: _f$follower,
    #infoCurrentActivity: _f$infoCurrentActivity,
    #currentAction: _f$currentAction,
    #topicId: _f$topicId,
    #customFieldsList: _f$customFieldsList,
    #infoCanBan: _f$infoCanBan,
    #isBan: _f$isBan,
    #canMarkSpam: _f$canMarkSpam,
    #infoIsIgnored: _f$infoIsIgnored,
  };

  static FCUserInfoResult _instantiate(DecodingData data) {
    return FCUserInfoResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
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
      status: data.dec(_f$status),
      signature: data.dec(_f$signature),
      location: data.dec(_f$location),
      website: data.dec(_f$website),
      interests: data.dec(_f$interests),
      occupation: data.dec(_f$occupation),
      bio: data.dec(_f$bio),
      regTime: data.dec(_f$regTime),
      infoIsOnline: data.dec(_f$infoIsOnline),
      acceptPm: data.dec(_f$acceptPm),
      canPm: data.dec(_f$canPm),
      canSendPm: data.dec(_f$canSendPm),
      iFollowU: data.dec(_f$iFollowU),
      uFollowMe: data.dec(_f$uFollowMe),
      acceptFollow: data.dec(_f$acceptFollow),
      infoFollowingCount: data.dec(_f$infoFollowingCount),
      follower: data.dec(_f$follower),
      infoCurrentActivity: data.dec(_f$infoCurrentActivity),
      currentAction: data.dec(_f$currentAction),
      topicId: data.dec(_f$topicId),
      customFieldsList: data.dec(_f$customFieldsList),
      infoCanBan: data.dec(_f$infoCanBan),
      isBan: data.dec(_f$isBan),
      canMarkSpam: data.dec(_f$canMarkSpam),
      infoIsIgnored: data.dec(_f$infoIsIgnored),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUserInfoResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUserInfoResult>(map);
  }

  static FCUserInfoResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUserInfoResult>(json);
  }
}

mixin FCUserInfoResultMappable {
  String toJson() {
    return FCUserInfoResultMapper.ensureInitialized()
        .encodeJson<FCUserInfoResult>(this as FCUserInfoResult);
  }

  Map<String, dynamic> toMap() {
    return FCUserInfoResultMapper.ensureInitialized()
        .encodeMap<FCUserInfoResult>(this as FCUserInfoResult);
  }

  FCUserInfoResultCopyWith<FCUserInfoResult, FCUserInfoResult, FCUserInfoResult>
  get copyWith =>
      _FCUserInfoResultCopyWithImpl<FCUserInfoResult, FCUserInfoResult>(
        this as FCUserInfoResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCUserInfoResultMapper.ensureInitialized().stringifyValue(
      this as FCUserInfoResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUserInfoResultMapper.ensureInitialized().equalsValue(
      this as FCUserInfoResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUserInfoResultMapper.ensureInitialized().hashValue(
      this as FCUserInfoResult,
    );
  }
}

extension FCUserInfoResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUserInfoResult, $Out> {
  FCUserInfoResultCopyWith<$R, FCUserInfoResult, $Out>
  get $asFCUserInfoResult =>
      $base.as((v, t, t2) => _FCUserInfoResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCUserInfoResultCopyWith<$R, $In extends FCUserInfoResult, $Out>
    implements FCUserCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<
    $R,
    FCUserCustomField,
    FCUserCustomFieldCopyWith<$R, FCUserCustomField, FCUserCustomField>
  >
  get customFields;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get userGroups;
  ListCopyWith<$R, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get customFieldsList;
  @override
  $R call({
    bool? result,
    String? resultText,
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
    String? status,
    String? signature,
    String? location,
    String? website,
    String? interests,
    String? occupation,
    String? bio,
    DateTime? regTime,
    bool? infoIsOnline,
    bool? acceptPm,
    bool? canPm,
    bool? canSendPm,
    bool? iFollowU,
    bool? uFollowMe,
    bool? acceptFollow,
    int? infoFollowingCount,
    String? follower,
    String? infoCurrentActivity,
    String? currentAction,
    String? topicId,
    List<dynamic>? customFieldsList,
    bool? infoCanBan,
    bool? isBan,
    bool? canMarkSpam,
    bool? infoIsIgnored,
  });
  FCUserInfoResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUserInfoResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUserInfoResult, $Out>
    implements FCUserInfoResultCopyWith<$R, FCUserInfoResult, $Out> {
  _FCUserInfoResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUserInfoResult> $mapper =
      FCUserInfoResultMapper.ensureInitialized();
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
  ListCopyWith<$R, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get customFieldsList => $value.customFieldsList != null
      ? ListCopyWith(
          $value.customFieldsList!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(customFieldsList: v),
        )
      : null;
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
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
    Object? status = $none,
    Object? signature = $none,
    Object? location = $none,
    Object? website = $none,
    Object? interests = $none,
    Object? occupation = $none,
    Object? bio = $none,
    Object? regTime = $none,
    Object? infoIsOnline = $none,
    Object? acceptPm = $none,
    Object? canPm = $none,
    Object? canSendPm = $none,
    Object? iFollowU = $none,
    Object? uFollowMe = $none,
    Object? acceptFollow = $none,
    Object? infoFollowingCount = $none,
    Object? follower = $none,
    Object? infoCurrentActivity = $none,
    Object? currentAction = $none,
    Object? topicId = $none,
    Object? customFieldsList = $none,
    Object? infoCanBan = $none,
    Object? isBan = $none,
    Object? canMarkSpam = $none,
    Object? infoIsIgnored = $none,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
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
      if (status != $none) #status: status,
      if (signature != $none) #signature: signature,
      if (location != $none) #location: location,
      if (website != $none) #website: website,
      if (interests != $none) #interests: interests,
      if (occupation != $none) #occupation: occupation,
      if (bio != $none) #bio: bio,
      if (regTime != $none) #regTime: regTime,
      if (infoIsOnline != $none) #infoIsOnline: infoIsOnline,
      if (acceptPm != $none) #acceptPm: acceptPm,
      if (canPm != $none) #canPm: canPm,
      if (canSendPm != $none) #canSendPm: canSendPm,
      if (iFollowU != $none) #iFollowU: iFollowU,
      if (uFollowMe != $none) #uFollowMe: uFollowMe,
      if (acceptFollow != $none) #acceptFollow: acceptFollow,
      if (infoFollowingCount != $none) #infoFollowingCount: infoFollowingCount,
      if (follower != $none) #follower: follower,
      if (infoCurrentActivity != $none)
        #infoCurrentActivity: infoCurrentActivity,
      if (currentAction != $none) #currentAction: currentAction,
      if (topicId != $none) #topicId: topicId,
      if (customFieldsList != $none) #customFieldsList: customFieldsList,
      if (infoCanBan != $none) #infoCanBan: infoCanBan,
      if (isBan != $none) #isBan: isBan,
      if (canMarkSpam != $none) #canMarkSpam: canMarkSpam,
      if (infoIsIgnored != $none) #infoIsIgnored: infoIsIgnored,
    }),
  );
  @override
  FCUserInfoResult $make(CopyWithData data) => FCUserInfoResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
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
    status: data.get(#status, or: $value.status),
    signature: data.get(#signature, or: $value.signature),
    location: data.get(#location, or: $value.location),
    website: data.get(#website, or: $value.website),
    interests: data.get(#interests, or: $value.interests),
    occupation: data.get(#occupation, or: $value.occupation),
    bio: data.get(#bio, or: $value.bio),
    regTime: data.get(#regTime, or: $value.regTime),
    infoIsOnline: data.get(#infoIsOnline, or: $value.infoIsOnline),
    acceptPm: data.get(#acceptPm, or: $value.acceptPm),
    canPm: data.get(#canPm, or: $value.canPm),
    canSendPm: data.get(#canSendPm, or: $value.canSendPm),
    iFollowU: data.get(#iFollowU, or: $value.iFollowU),
    uFollowMe: data.get(#uFollowMe, or: $value.uFollowMe),
    acceptFollow: data.get(#acceptFollow, or: $value.acceptFollow),
    infoFollowingCount: data.get(
      #infoFollowingCount,
      or: $value.infoFollowingCount,
    ),
    follower: data.get(#follower, or: $value.follower),
    infoCurrentActivity: data.get(
      #infoCurrentActivity,
      or: $value.infoCurrentActivity,
    ),
    currentAction: data.get(#currentAction, or: $value.currentAction),
    topicId: data.get(#topicId, or: $value.topicId),
    customFieldsList: data.get(#customFieldsList, or: $value.customFieldsList),
    infoCanBan: data.get(#infoCanBan, or: $value.infoCanBan),
    isBan: data.get(#isBan, or: $value.isBan),
    canMarkSpam: data.get(#canMarkSpam, or: $value.canMarkSpam),
    infoIsIgnored: data.get(#infoIsIgnored, or: $value.infoIsIgnored),
  );

  @override
  FCUserInfoResultCopyWith<$R2, FCUserInfoResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCUserInfoResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUserTopicResultMapper extends ClassMapperBase<FCUserTopicResult> {
  FCUserTopicResultMapper._();

  static FCUserTopicResultMapper? _instance;
  static FCUserTopicResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUserTopicResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCUserTopicMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUserTopicResult';

  static bool _$result(FCUserTopicResult v) => v.result;
  static const Field<FCUserTopicResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUserTopicResult v) => v.resultText;
  static const Field<FCUserTopicResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$total(FCUserTopicResult v) => v.total;
  static const Field<FCUserTopicResult, int> _f$total = Field(
    'total',
    _$total,
    opt: true,
    def: 0,
  );
  static List<FCUserTopic> _$list(FCUserTopicResult v) => v.list;
  static const Field<FCUserTopicResult, List<FCUserTopic>> _f$list = Field(
    'list',
    _$list,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCUserTopicResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #total: _f$total,
    #list: _f$list,
  };

  static FCUserTopicResult _instantiate(DecodingData data) {
    return FCUserTopicResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      total: data.dec(_f$total),
      list: data.dec(_f$list),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUserTopicResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUserTopicResult>(map);
  }

  static FCUserTopicResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUserTopicResult>(json);
  }
}

mixin FCUserTopicResultMappable {
  String toJson() {
    return FCUserTopicResultMapper.ensureInitialized()
        .encodeJson<FCUserTopicResult>(this as FCUserTopicResult);
  }

  Map<String, dynamic> toMap() {
    return FCUserTopicResultMapper.ensureInitialized()
        .encodeMap<FCUserTopicResult>(this as FCUserTopicResult);
  }

  FCUserTopicResultCopyWith<
    FCUserTopicResult,
    FCUserTopicResult,
    FCUserTopicResult
  >
  get copyWith =>
      _FCUserTopicResultCopyWithImpl<FCUserTopicResult, FCUserTopicResult>(
        this as FCUserTopicResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCUserTopicResultMapper.ensureInitialized().stringifyValue(
      this as FCUserTopicResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUserTopicResultMapper.ensureInitialized().equalsValue(
      this as FCUserTopicResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUserTopicResultMapper.ensureInitialized().hashValue(
      this as FCUserTopicResult,
    );
  }
}

extension FCUserTopicResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUserTopicResult, $Out> {
  FCUserTopicResultCopyWith<$R, FCUserTopicResult, $Out>
  get $asFCUserTopicResult => $base.as(
    (v, t, t2) => _FCUserTopicResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUserTopicResultCopyWith<
  $R,
  $In extends FCUserTopicResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCUserTopic,
    FCUserTopicCopyWith<$R, FCUserTopic, FCUserTopic>
  >
  get list;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? total,
    List<FCUserTopic>? list,
  });
  FCUserTopicResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUserTopicResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUserTopicResult, $Out>
    implements FCUserTopicResultCopyWith<$R, FCUserTopicResult, $Out> {
  _FCUserTopicResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUserTopicResult> $mapper =
      FCUserTopicResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCUserTopic,
    FCUserTopicCopyWith<$R, FCUserTopic, FCUserTopic>
  >
  get list => ListCopyWith(
    $value.list,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(list: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? total,
    List<FCUserTopic>? list,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (total != null) #total: total,
      if (list != null) #list: list,
    }),
  );
  @override
  FCUserTopicResult $make(CopyWithData data) => FCUserTopicResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    total: data.get(#total, or: $value.total),
    list: data.get(#list, or: $value.list),
  );

  @override
  FCUserTopicResultCopyWith<$R2, FCUserTopicResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCUserTopicResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUserTopicMapper extends ClassMapperBase<FCUserTopic> {
  FCUserTopicMapper._();

  static FCUserTopicMapper? _instance;
  static FCUserTopicMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUserTopicMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCUserTopic';

  static String _$topicId(FCUserTopic v) => v.topicId;
  static const Field<FCUserTopic, String> _f$topicId = Field(
    'topicId',
    _$topicId,
  );
  static String _$topicTitle(FCUserTopic v) => v.topicTitle;
  static const Field<FCUserTopic, String> _f$topicTitle = Field(
    'topicTitle',
    _$topicTitle,
  );
  static String _$forumId(FCUserTopic v) => v.forumId;
  static const Field<FCUserTopic, String> _f$forumId = Field(
    'forumId',
    _$forumId,
  );
  static String _$forumName(FCUserTopic v) => v.forumName;
  static const Field<FCUserTopic, String> _f$forumName = Field(
    'forumName',
    _$forumName,
  );
  static String _$authorId(FCUserTopic v) => v.authorId;
  static const Field<FCUserTopic, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCUserTopic v) => v.authorName;
  static const Field<FCUserTopic, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static DateTime _$postTime(FCUserTopic v) => v.postTime;
  static const Field<FCUserTopic, DateTime> _f$postTime = Field(
    'postTime',
    _$postTime,
  );
  static int _$replyCount(FCUserTopic v) => v.replyCount;
  static const Field<FCUserTopic, int> _f$replyCount = Field(
    'replyCount',
    _$replyCount,
    opt: true,
    def: 0,
  );
  static int _$viewCount(FCUserTopic v) => v.viewCount;
  static const Field<FCUserTopic, int> _f$viewCount = Field(
    'viewCount',
    _$viewCount,
    opt: true,
    def: 0,
  );
  static bool _$isClosed(FCUserTopic v) => v.isClosed;
  static const Field<FCUserTopic, bool> _f$isClosed = Field(
    'isClosed',
    _$isClosed,
    opt: true,
    def: false,
  );
  static bool _$isSticky(FCUserTopic v) => v.isSticky;
  static const Field<FCUserTopic, bool> _f$isSticky = Field(
    'isSticky',
    _$isSticky,
    opt: true,
    def: false,
  );
  static bool _$isAnnouncement(FCUserTopic v) => v.isAnnouncement;
  static const Field<FCUserTopic, bool> _f$isAnnouncement = Field(
    'isAnnouncement',
    _$isAnnouncement,
    opt: true,
    def: false,
  );
  static String? _$shortContent(FCUserTopic v) => v.shortContent;
  static const Field<FCUserTopic, String> _f$shortContent = Field(
    'shortContent',
    _$shortContent,
    opt: true,
  );

  @override
  final MappableFields<FCUserTopic> fields = const {
    #topicId: _f$topicId,
    #topicTitle: _f$topicTitle,
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #postTime: _f$postTime,
    #replyCount: _f$replyCount,
    #viewCount: _f$viewCount,
    #isClosed: _f$isClosed,
    #isSticky: _f$isSticky,
    #isAnnouncement: _f$isAnnouncement,
    #shortContent: _f$shortContent,
  };

  static FCUserTopic _instantiate(DecodingData data) {
    return FCUserTopic(
      topicId: data.dec(_f$topicId),
      topicTitle: data.dec(_f$topicTitle),
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      postTime: data.dec(_f$postTime),
      replyCount: data.dec(_f$replyCount),
      viewCount: data.dec(_f$viewCount),
      isClosed: data.dec(_f$isClosed),
      isSticky: data.dec(_f$isSticky),
      isAnnouncement: data.dec(_f$isAnnouncement),
      shortContent: data.dec(_f$shortContent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUserTopic fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUserTopic>(map);
  }

  static FCUserTopic fromJson(String json) {
    return ensureInitialized().decodeJson<FCUserTopic>(json);
  }
}

mixin FCUserTopicMappable {
  String toJson() {
    return FCUserTopicMapper.ensureInitialized().encodeJson<FCUserTopic>(
      this as FCUserTopic,
    );
  }

  Map<String, dynamic> toMap() {
    return FCUserTopicMapper.ensureInitialized().encodeMap<FCUserTopic>(
      this as FCUserTopic,
    );
  }

  FCUserTopicCopyWith<FCUserTopic, FCUserTopic, FCUserTopic> get copyWith =>
      _FCUserTopicCopyWithImpl<FCUserTopic, FCUserTopic>(
        this as FCUserTopic,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCUserTopicMapper.ensureInitialized().stringifyValue(
      this as FCUserTopic,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUserTopicMapper.ensureInitialized().equalsValue(
      this as FCUserTopic,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUserTopicMapper.ensureInitialized().hashValue(this as FCUserTopic);
  }
}

extension FCUserTopicValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUserTopic, $Out> {
  FCUserTopicCopyWith<$R, FCUserTopic, $Out> get $asFCUserTopic =>
      $base.as((v, t, t2) => _FCUserTopicCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCUserTopicCopyWith<$R, $In extends FCUserTopic, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? topicId,
    String? topicTitle,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    DateTime? postTime,
    int? replyCount,
    int? viewCount,
    bool? isClosed,
    bool? isSticky,
    bool? isAnnouncement,
    String? shortContent,
  });
  FCUserTopicCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCUserTopicCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUserTopic, $Out>
    implements FCUserTopicCopyWith<$R, FCUserTopic, $Out> {
  _FCUserTopicCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUserTopic> $mapper =
      FCUserTopicMapper.ensureInitialized();
  @override
  $R call({
    String? topicId,
    String? topicTitle,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    DateTime? postTime,
    int? replyCount,
    int? viewCount,
    bool? isClosed,
    bool? isSticky,
    bool? isAnnouncement,
    Object? shortContent = $none,
  }) => $apply(
    FieldCopyWithData({
      if (topicId != null) #topicId: topicId,
      if (topicTitle != null) #topicTitle: topicTitle,
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (postTime != null) #postTime: postTime,
      if (replyCount != null) #replyCount: replyCount,
      if (viewCount != null) #viewCount: viewCount,
      if (isClosed != null) #isClosed: isClosed,
      if (isSticky != null) #isSticky: isSticky,
      if (isAnnouncement != null) #isAnnouncement: isAnnouncement,
      if (shortContent != $none) #shortContent: shortContent,
    }),
  );
  @override
  FCUserTopic $make(CopyWithData data) => FCUserTopic(
    topicId: data.get(#topicId, or: $value.topicId),
    topicTitle: data.get(#topicTitle, or: $value.topicTitle),
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    postTime: data.get(#postTime, or: $value.postTime),
    replyCount: data.get(#replyCount, or: $value.replyCount),
    viewCount: data.get(#viewCount, or: $value.viewCount),
    isClosed: data.get(#isClosed, or: $value.isClosed),
    isSticky: data.get(#isSticky, or: $value.isSticky),
    isAnnouncement: data.get(#isAnnouncement, or: $value.isAnnouncement),
    shortContent: data.get(#shortContent, or: $value.shortContent),
  );

  @override
  FCUserTopicCopyWith<$R2, FCUserTopic, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCUserTopicCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUserReplyResultMapper extends ClassMapperBase<FCUserReplyResult> {
  FCUserReplyResultMapper._();

  static FCUserReplyResultMapper? _instance;
  static FCUserReplyResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUserReplyResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCUserReplyMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCUserReplyResult';

  static bool _$result(FCUserReplyResult v) => v.result;
  static const Field<FCUserReplyResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCUserReplyResult v) => v.resultText;
  static const Field<FCUserReplyResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$total(FCUserReplyResult v) => v.total;
  static const Field<FCUserReplyResult, int> _f$total = Field(
    'total',
    _$total,
    opt: true,
    def: 0,
  );
  static List<FCUserReply> _$list(FCUserReplyResult v) => v.list;
  static const Field<FCUserReplyResult, List<FCUserReply>> _f$list = Field(
    'list',
    _$list,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCUserReplyResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #total: _f$total,
    #list: _f$list,
  };

  static FCUserReplyResult _instantiate(DecodingData data) {
    return FCUserReplyResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      total: data.dec(_f$total),
      list: data.dec(_f$list),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUserReplyResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUserReplyResult>(map);
  }

  static FCUserReplyResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCUserReplyResult>(json);
  }
}

mixin FCUserReplyResultMappable {
  String toJson() {
    return FCUserReplyResultMapper.ensureInitialized()
        .encodeJson<FCUserReplyResult>(this as FCUserReplyResult);
  }

  Map<String, dynamic> toMap() {
    return FCUserReplyResultMapper.ensureInitialized()
        .encodeMap<FCUserReplyResult>(this as FCUserReplyResult);
  }

  FCUserReplyResultCopyWith<
    FCUserReplyResult,
    FCUserReplyResult,
    FCUserReplyResult
  >
  get copyWith =>
      _FCUserReplyResultCopyWithImpl<FCUserReplyResult, FCUserReplyResult>(
        this as FCUserReplyResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCUserReplyResultMapper.ensureInitialized().stringifyValue(
      this as FCUserReplyResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUserReplyResultMapper.ensureInitialized().equalsValue(
      this as FCUserReplyResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUserReplyResultMapper.ensureInitialized().hashValue(
      this as FCUserReplyResult,
    );
  }
}

extension FCUserReplyResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUserReplyResult, $Out> {
  FCUserReplyResultCopyWith<$R, FCUserReplyResult, $Out>
  get $asFCUserReplyResult => $base.as(
    (v, t, t2) => _FCUserReplyResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCUserReplyResultCopyWith<
  $R,
  $In extends FCUserReplyResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCUserReply,
    FCUserReplyCopyWith<$R, FCUserReply, FCUserReply>
  >
  get list;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? total,
    List<FCUserReply>? list,
  });
  FCUserReplyResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCUserReplyResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUserReplyResult, $Out>
    implements FCUserReplyResultCopyWith<$R, FCUserReplyResult, $Out> {
  _FCUserReplyResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUserReplyResult> $mapper =
      FCUserReplyResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCUserReply,
    FCUserReplyCopyWith<$R, FCUserReply, FCUserReply>
  >
  get list => ListCopyWith(
    $value.list,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(list: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? total,
    List<FCUserReply>? list,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (total != null) #total: total,
      if (list != null) #list: list,
    }),
  );
  @override
  FCUserReplyResult $make(CopyWithData data) => FCUserReplyResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    total: data.get(#total, or: $value.total),
    list: data.get(#list, or: $value.list),
  );

  @override
  FCUserReplyResultCopyWith<$R2, FCUserReplyResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCUserReplyResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCUserReplyMapper extends ClassMapperBase<FCUserReply> {
  FCUserReplyMapper._();

  static FCUserReplyMapper? _instance;
  static FCUserReplyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCUserReplyMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCUserReply';

  static String _$postId(FCUserReply v) => v.postId;
  static const Field<FCUserReply, String> _f$postId = Field('postId', _$postId);
  static String _$topicId(FCUserReply v) => v.topicId;
  static const Field<FCUserReply, String> _f$topicId = Field(
    'topicId',
    _$topicId,
  );
  static String _$topicTitle(FCUserReply v) => v.topicTitle;
  static const Field<FCUserReply, String> _f$topicTitle = Field(
    'topicTitle',
    _$topicTitle,
  );
  static String _$forumId(FCUserReply v) => v.forumId;
  static const Field<FCUserReply, String> _f$forumId = Field(
    'forumId',
    _$forumId,
  );
  static String _$forumName(FCUserReply v) => v.forumName;
  static const Field<FCUserReply, String> _f$forumName = Field(
    'forumName',
    _$forumName,
  );
  static String _$authorId(FCUserReply v) => v.authorId;
  static const Field<FCUserReply, String> _f$authorId = Field(
    'authorId',
    _$authorId,
  );
  static String _$authorName(FCUserReply v) => v.authorName;
  static const Field<FCUserReply, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static String? _$authorIconUrl(FCUserReply v) => v.authorIconUrl;
  static const Field<FCUserReply, String> _f$authorIconUrl = Field(
    'authorIconUrl',
    _$authorIconUrl,
  );
  static DateTime _$postTime(FCUserReply v) => v.postTime;
  static const Field<FCUserReply, DateTime> _f$postTime = Field(
    'postTime',
    _$postTime,
  );
  static int _$replyNumber(FCUserReply v) => v.replyNumber;
  static const Field<FCUserReply, int> _f$replyNumber = Field(
    'replyNumber',
    _$replyNumber,
    opt: true,
    def: 0,
  );
  static String? _$postContent(FCUserReply v) => v.postContent;
  static const Field<FCUserReply, String> _f$postContent = Field(
    'postContent',
    _$postContent,
    opt: true,
  );
  static String? _$shortContent(FCUserReply v) => v.shortContent;
  static const Field<FCUserReply, String> _f$shortContent = Field(
    'shortContent',
    _$shortContent,
    opt: true,
  );

  @override
  final MappableFields<FCUserReply> fields = const {
    #postId: _f$postId,
    #topicId: _f$topicId,
    #topicTitle: _f$topicTitle,
    #forumId: _f$forumId,
    #forumName: _f$forumName,
    #authorId: _f$authorId,
    #authorName: _f$authorName,
    #authorIconUrl: _f$authorIconUrl,
    #postTime: _f$postTime,
    #replyNumber: _f$replyNumber,
    #postContent: _f$postContent,
    #shortContent: _f$shortContent,
  };

  static FCUserReply _instantiate(DecodingData data) {
    return FCUserReply(
      postId: data.dec(_f$postId),
      topicId: data.dec(_f$topicId),
      topicTitle: data.dec(_f$topicTitle),
      forumId: data.dec(_f$forumId),
      forumName: data.dec(_f$forumName),
      authorId: data.dec(_f$authorId),
      authorName: data.dec(_f$authorName),
      authorIconUrl: data.dec(_f$authorIconUrl),
      postTime: data.dec(_f$postTime),
      replyNumber: data.dec(_f$replyNumber),
      postContent: data.dec(_f$postContent),
      shortContent: data.dec(_f$shortContent),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCUserReply fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCUserReply>(map);
  }

  static FCUserReply fromJson(String json) {
    return ensureInitialized().decodeJson<FCUserReply>(json);
  }
}

mixin FCUserReplyMappable {
  String toJson() {
    return FCUserReplyMapper.ensureInitialized().encodeJson<FCUserReply>(
      this as FCUserReply,
    );
  }

  Map<String, dynamic> toMap() {
    return FCUserReplyMapper.ensureInitialized().encodeMap<FCUserReply>(
      this as FCUserReply,
    );
  }

  FCUserReplyCopyWith<FCUserReply, FCUserReply, FCUserReply> get copyWith =>
      _FCUserReplyCopyWithImpl<FCUserReply, FCUserReply>(
        this as FCUserReply,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCUserReplyMapper.ensureInitialized().stringifyValue(
      this as FCUserReply,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCUserReplyMapper.ensureInitialized().equalsValue(
      this as FCUserReply,
      other,
    );
  }

  @override
  int get hashCode {
    return FCUserReplyMapper.ensureInitialized().hashValue(this as FCUserReply);
  }
}

extension FCUserReplyValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCUserReply, $Out> {
  FCUserReplyCopyWith<$R, FCUserReply, $Out> get $asFCUserReply =>
      $base.as((v, t, t2) => _FCUserReplyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCUserReplyCopyWith<$R, $In extends FCUserReply, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? postId,
    String? topicId,
    String? topicTitle,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    String? authorIconUrl,
    DateTime? postTime,
    int? replyNumber,
    String? postContent,
    String? shortContent,
  });
  FCUserReplyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCUserReplyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCUserReply, $Out>
    implements FCUserReplyCopyWith<$R, FCUserReply, $Out> {
  _FCUserReplyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCUserReply> $mapper =
      FCUserReplyMapper.ensureInitialized();
  @override
  $R call({
    String? postId,
    String? topicId,
    String? topicTitle,
    String? forumId,
    String? forumName,
    String? authorId,
    String? authorName,
    Object? authorIconUrl = $none,
    DateTime? postTime,
    int? replyNumber,
    Object? postContent = $none,
    Object? shortContent = $none,
  }) => $apply(
    FieldCopyWithData({
      if (postId != null) #postId: postId,
      if (topicId != null) #topicId: topicId,
      if (topicTitle != null) #topicTitle: topicTitle,
      if (forumId != null) #forumId: forumId,
      if (forumName != null) #forumName: forumName,
      if (authorId != null) #authorId: authorId,
      if (authorName != null) #authorName: authorName,
      if (authorIconUrl != $none) #authorIconUrl: authorIconUrl,
      if (postTime != null) #postTime: postTime,
      if (replyNumber != null) #replyNumber: replyNumber,
      if (postContent != $none) #postContent: postContent,
      if (shortContent != $none) #shortContent: shortContent,
    }),
  );
  @override
  FCUserReply $make(CopyWithData data) => FCUserReply(
    postId: data.get(#postId, or: $value.postId),
    topicId: data.get(#topicId, or: $value.topicId),
    topicTitle: data.get(#topicTitle, or: $value.topicTitle),
    forumId: data.get(#forumId, or: $value.forumId),
    forumName: data.get(#forumName, or: $value.forumName),
    authorId: data.get(#authorId, or: $value.authorId),
    authorName: data.get(#authorName, or: $value.authorName),
    authorIconUrl: data.get(#authorIconUrl, or: $value.authorIconUrl),
    postTime: data.get(#postTime, or: $value.postTime),
    replyNumber: data.get(#replyNumber, or: $value.replyNumber),
    postContent: data.get(#postContent, or: $value.postContent),
    shortContent: data.get(#shortContent, or: $value.shortContent),
  );

  @override
  FCUserReplyCopyWith<$R2, FCUserReply, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCUserReplyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCRecommendedUserResultMapper
    extends ClassMapperBase<FCRecommendedUserResult> {
  FCRecommendedUserResultMapper._();

  static FCRecommendedUserResultMapper? _instance;
  static FCRecommendedUserResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = FCRecommendedUserResultMapper._(),
      );
      FCBaseResultMapper.ensureInitialized();
      FCRecommendedUserMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCRecommendedUserResult';

  static bool _$result(FCRecommendedUserResult v) => v.result;
  static const Field<FCRecommendedUserResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCRecommendedUserResult v) => v.resultText;
  static const Field<FCRecommendedUserResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$total(FCRecommendedUserResult v) => v.total;
  static const Field<FCRecommendedUserResult, int> _f$total = Field(
    'total',
    _$total,
    opt: true,
    def: 0,
  );
  static List<FCRecommendedUser> _$list(FCRecommendedUserResult v) => v.list;
  static const Field<FCRecommendedUserResult, List<FCRecommendedUser>> _f$list =
      Field('list', _$list, opt: true, def: const []);

  @override
  final MappableFields<FCRecommendedUserResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #total: _f$total,
    #list: _f$list,
  };

  static FCRecommendedUserResult _instantiate(DecodingData data) {
    return FCRecommendedUserResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      total: data.dec(_f$total),
      list: data.dec(_f$list),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCRecommendedUserResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCRecommendedUserResult>(map);
  }

  static FCRecommendedUserResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCRecommendedUserResult>(json);
  }
}

mixin FCRecommendedUserResultMappable {
  String toJson() {
    return FCRecommendedUserResultMapper.ensureInitialized()
        .encodeJson<FCRecommendedUserResult>(this as FCRecommendedUserResult);
  }

  Map<String, dynamic> toMap() {
    return FCRecommendedUserResultMapper.ensureInitialized()
        .encodeMap<FCRecommendedUserResult>(this as FCRecommendedUserResult);
  }

  FCRecommendedUserResultCopyWith<
    FCRecommendedUserResult,
    FCRecommendedUserResult,
    FCRecommendedUserResult
  >
  get copyWith =>
      _FCRecommendedUserResultCopyWithImpl<
        FCRecommendedUserResult,
        FCRecommendedUserResult
      >(this as FCRecommendedUserResult, $identity, $identity);
  @override
  String toString() {
    return FCRecommendedUserResultMapper.ensureInitialized().stringifyValue(
      this as FCRecommendedUserResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCRecommendedUserResultMapper.ensureInitialized().equalsValue(
      this as FCRecommendedUserResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCRecommendedUserResultMapper.ensureInitialized().hashValue(
      this as FCRecommendedUserResult,
    );
  }
}

extension FCRecommendedUserResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCRecommendedUserResult, $Out> {
  FCRecommendedUserResultCopyWith<$R, FCRecommendedUserResult, $Out>
  get $asFCRecommendedUserResult => $base.as(
    (v, t, t2) => _FCRecommendedUserResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCRecommendedUserResultCopyWith<
  $R,
  $In extends FCRecommendedUserResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCRecommendedUser,
    FCRecommendedUserCopyWith<$R, FCRecommendedUser, FCRecommendedUser>
  >
  get list;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? total,
    List<FCRecommendedUser>? list,
  });
  FCRecommendedUserResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCRecommendedUserResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCRecommendedUserResult, $Out>
    implements
        FCRecommendedUserResultCopyWith<$R, FCRecommendedUserResult, $Out> {
  _FCRecommendedUserResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCRecommendedUserResult> $mapper =
      FCRecommendedUserResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCRecommendedUser,
    FCRecommendedUserCopyWith<$R, FCRecommendedUser, FCRecommendedUser>
  >
  get list => ListCopyWith(
    $value.list,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(list: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? total,
    List<FCRecommendedUser>? list,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (total != null) #total: total,
      if (list != null) #list: list,
    }),
  );
  @override
  FCRecommendedUserResult $make(CopyWithData data) => FCRecommendedUserResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    total: data.get(#total, or: $value.total),
    list: data.get(#list, or: $value.list),
  );

  @override
  FCRecommendedUserResultCopyWith<$R2, FCRecommendedUserResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCRecommendedUserResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCRecommendedUserMapper extends ClassMapperBase<FCRecommendedUser> {
  FCRecommendedUserMapper._();

  static FCRecommendedUserMapper? _instance;
  static FCRecommendedUserMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCRecommendedUserMapper._());
      FCUserMapper.ensureInitialized();
      FCUserCustomFieldMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCRecommendedUser';

  static String _$id(FCRecommendedUser v) => v.id;
  static const Field<FCRecommendedUser, String> _f$id = Field('id', _$id);
  static String _$username(FCRecommendedUser v) => v.username;
  static const Field<FCRecommendedUser, String> _f$username = Field(
    'username',
    _$username,
  );
  static String? _$loginName(FCRecommendedUser v) => v.loginName;
  static const Field<FCRecommendedUser, String> _f$loginName = Field(
    'loginName',
    _$loginName,
    opt: true,
  );
  static String? _$email(FCRecommendedUser v) => v.email;
  static const Field<FCRecommendedUser, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static String? _$userType(FCRecommendedUser v) => v.userType;
  static const Field<FCRecommendedUser, String> _f$userType = Field(
    'userType',
    _$userType,
    opt: true,
  );
  static String? _$iconUrl(FCRecommendedUser v) => v.iconUrl;
  static const Field<FCRecommendedUser, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static int _$postCount(FCRecommendedUser v) => v.postCount;
  static const Field<FCRecommendedUser, int> _f$postCount = Field(
    'postCount',
    _$postCount,
    opt: true,
    def: 0,
  );
  static DateTime? _$registrationTime(FCRecommendedUser v) =>
      v.registrationTime;
  static const Field<FCRecommendedUser, DateTime> _f$registrationTime = Field(
    'registrationTime',
    _$registrationTime,
    opt: true,
  );
  static DateTime? _$lastActivityTime(FCRecommendedUser v) =>
      v.lastActivityTime;
  static const Field<FCRecommendedUser, DateTime> _f$lastActivityTime = Field(
    'lastActivityTime',
    _$lastActivityTime,
    opt: true,
  );
  static bool _$isOnline(FCRecommendedUser v) => v.isOnline;
  static const Field<FCRecommendedUser, bool> _f$isOnline = Field(
    'isOnline',
    _$isOnline,
    opt: true,
    def: false,
  );
  static String? _$currentActivity(FCRecommendedUser v) => v.currentActivity;
  static const Field<FCRecommendedUser, String> _f$currentActivity = Field(
    'currentActivity',
    _$currentActivity,
    opt: true,
  );
  static String? _$currentTopicId(FCRecommendedUser v) => v.currentTopicId;
  static const Field<FCRecommendedUser, String> _f$currentTopicId = Field(
    'currentTopicId',
    _$currentTopicId,
    opt: true,
  );
  static bool _$acceptsPM(FCRecommendedUser v) => v.acceptsPM;
  static const Field<FCRecommendedUser, bool> _f$acceptsPM = Field(
    'acceptsPM',
    _$acceptsPM,
    opt: true,
    def: false,
  );
  static bool _$canSendPM(FCRecommendedUser v) => v.canSendPM;
  static const Field<FCRecommendedUser, bool> _f$canSendPM = Field(
    'canSendPM',
    _$canSendPM,
    opt: true,
    def: false,
  );
  static bool _$canPM(FCRecommendedUser v) => v.canPM;
  static const Field<FCRecommendedUser, bool> _f$canPM = Field(
    'canPM',
    _$canPM,
    opt: true,
    def: false,
  );
  static bool _$isFollowing(FCRecommendedUser v) => v.isFollowing;
  static const Field<FCRecommendedUser, bool> _f$isFollowing = Field(
    'isFollowing',
    _$isFollowing,
    opt: true,
    def: false,
  );
  static bool _$isFollowingMe(FCRecommendedUser v) => v.isFollowingMe;
  static const Field<FCRecommendedUser, bool> _f$isFollowingMe = Field(
    'isFollowingMe',
    _$isFollowingMe,
    opt: true,
    def: false,
  );
  static bool _$acceptsFollowers(FCRecommendedUser v) => v.acceptsFollowers;
  static const Field<FCRecommendedUser, bool> _f$acceptsFollowers = Field(
    'acceptsFollowers',
    _$acceptsFollowers,
    opt: true,
    def: false,
  );
  static int _$followingCount(FCRecommendedUser v) => v.followingCount;
  static const Field<FCRecommendedUser, int> _f$followingCount = Field(
    'followingCount',
    _$followingCount,
    opt: true,
    def: 0,
  );
  static int _$followerCount(FCRecommendedUser v) => v.followerCount;
  static const Field<FCRecommendedUser, int> _f$followerCount = Field(
    'followerCount',
    _$followerCount,
    opt: true,
    def: 0,
  );
  static String? _$displayText(FCRecommendedUser v) => v.displayText;
  static const Field<FCRecommendedUser, String> _f$displayText = Field(
    'displayText',
    _$displayText,
    opt: true,
  );
  static List<FCUserCustomField> _$customFields(FCRecommendedUser v) =>
      v.customFields;
  static const Field<FCRecommendedUser, List<FCUserCustomField>>
  _f$customFields = Field(
    'customFields',
    _$customFields,
    opt: true,
    def: const [],
  );
  static bool _$canBan(FCRecommendedUser v) => v.canBan;
  static const Field<FCRecommendedUser, bool> _f$canBan = Field(
    'canBan',
    _$canBan,
    opt: true,
    def: false,
  );
  static bool _$isBanned(FCRecommendedUser v) => v.isBanned;
  static const Field<FCRecommendedUser, bool> _f$isBanned = Field(
    'isBanned',
    _$isBanned,
    opt: true,
    def: false,
  );
  static bool _$isIgnored(FCRecommendedUser v) => v.isIgnored;
  static const Field<FCRecommendedUser, bool> _f$isIgnored = Field(
    'isIgnored',
    _$isIgnored,
    opt: true,
    def: false,
  );
  static bool _$canSpamClean(FCRecommendedUser v) => v.canSpamClean;
  static const Field<FCRecommendedUser, bool> _f$canSpamClean = Field(
    'canSpamClean',
    _$canSpamClean,
    opt: true,
    def: false,
  );
  static bool _$canBeReported(FCRecommendedUser v) => v.canBeReported;
  static const Field<FCRecommendedUser, bool> _f$canBeReported = Field(
    'canBeReported',
    _$canBeReported,
    opt: true,
    def: false,
  );
  static List<String> _$userGroups(FCRecommendedUser v) => v.userGroups;
  static const Field<FCRecommendedUser, List<String>> _f$userGroups = Field(
    'userGroups',
    _$userGroups,
    opt: true,
    def: const [],
  );
  static bool _$canModerate(FCRecommendedUser v) => v.canModerate;
  static const Field<FCRecommendedUser, bool> _f$canModerate = Field(
    'canModerate',
    _$canModerate,
    opt: true,
    def: false,
  );
  static bool _$canSearch(FCRecommendedUser v) => v.canSearch;
  static const Field<FCRecommendedUser, bool> _f$canSearch = Field(
    'canSearch',
    _$canSearch,
    opt: true,
    def: false,
  );
  static String? _$userState(FCRecommendedUser v) => v.userState;
  static const Field<FCRecommendedUser, String> _f$userState = Field(
    'userState',
    _$userState,
    opt: true,
    def: 'valid',
  );
  static String? _$status(FCRecommendedUser v) => v.status;
  static const Field<FCRecommendedUser, String> _f$status = Field(
    'status',
    _$status,
    opt: true,
  );

  @override
  final MappableFields<FCRecommendedUser> fields = const {
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
    #status: _f$status,
  };

  static FCRecommendedUser _instantiate(DecodingData data) {
    return FCRecommendedUser(
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
      status: data.dec(_f$status),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCRecommendedUser fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCRecommendedUser>(map);
  }

  static FCRecommendedUser fromJson(String json) {
    return ensureInitialized().decodeJson<FCRecommendedUser>(json);
  }
}

mixin FCRecommendedUserMappable {
  String toJson() {
    return FCRecommendedUserMapper.ensureInitialized()
        .encodeJson<FCRecommendedUser>(this as FCRecommendedUser);
  }

  Map<String, dynamic> toMap() {
    return FCRecommendedUserMapper.ensureInitialized()
        .encodeMap<FCRecommendedUser>(this as FCRecommendedUser);
  }

  FCRecommendedUserCopyWith<
    FCRecommendedUser,
    FCRecommendedUser,
    FCRecommendedUser
  >
  get copyWith =>
      _FCRecommendedUserCopyWithImpl<FCRecommendedUser, FCRecommendedUser>(
        this as FCRecommendedUser,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCRecommendedUserMapper.ensureInitialized().stringifyValue(
      this as FCRecommendedUser,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCRecommendedUserMapper.ensureInitialized().equalsValue(
      this as FCRecommendedUser,
      other,
    );
  }

  @override
  int get hashCode {
    return FCRecommendedUserMapper.ensureInitialized().hashValue(
      this as FCRecommendedUser,
    );
  }
}

extension FCRecommendedUserValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCRecommendedUser, $Out> {
  FCRecommendedUserCopyWith<$R, FCRecommendedUser, $Out>
  get $asFCRecommendedUser => $base.as(
    (v, t, t2) => _FCRecommendedUserCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCRecommendedUserCopyWith<
  $R,
  $In extends FCRecommendedUser,
  $Out
>
    implements FCUserCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<
    $R,
    FCUserCustomField,
    FCUserCustomFieldCopyWith<$R, FCUserCustomField, FCUserCustomField>
  >
  get customFields;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get userGroups;
  @override
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
    String? status,
  });
  FCRecommendedUserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCRecommendedUserCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCRecommendedUser, $Out>
    implements FCRecommendedUserCopyWith<$R, FCRecommendedUser, $Out> {
  _FCRecommendedUserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCRecommendedUser> $mapper =
      FCRecommendedUserMapper.ensureInitialized();
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
    Object? status = $none,
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
      if (status != $none) #status: status,
    }),
  );
  @override
  FCRecommendedUser $make(CopyWithData data) => FCRecommendedUser(
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
    status: data.get(#status, or: $value.status),
  );

  @override
  FCRecommendedUserCopyWith<$R2, FCRecommendedUser, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCRecommendedUserCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCSearchUserResultMapper extends ClassMapperBase<FCSearchUserResult> {
  FCSearchUserResultMapper._();

  static FCSearchUserResultMapper? _instance;
  static FCSearchUserResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSearchUserResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCSearchUserMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSearchUserResult';

  static bool _$result(FCSearchUserResult v) => v.result;
  static const Field<FCSearchUserResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCSearchUserResult v) => v.resultText;
  static const Field<FCSearchUserResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$total(FCSearchUserResult v) => v.total;
  static const Field<FCSearchUserResult, int> _f$total = Field(
    'total',
    _$total,
    opt: true,
    def: 0,
  );
  static List<FCSearchUser> _$list(FCSearchUserResult v) => v.list;
  static const Field<FCSearchUserResult, List<FCSearchUser>> _f$list = Field(
    'list',
    _$list,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCSearchUserResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #total: _f$total,
    #list: _f$list,
  };

  static FCSearchUserResult _instantiate(DecodingData data) {
    return FCSearchUserResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      total: data.dec(_f$total),
      list: data.dec(_f$list),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSearchUserResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSearchUserResult>(map);
  }

  static FCSearchUserResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCSearchUserResult>(json);
  }
}

mixin FCSearchUserResultMappable {
  String toJson() {
    return FCSearchUserResultMapper.ensureInitialized()
        .encodeJson<FCSearchUserResult>(this as FCSearchUserResult);
  }

  Map<String, dynamic> toMap() {
    return FCSearchUserResultMapper.ensureInitialized()
        .encodeMap<FCSearchUserResult>(this as FCSearchUserResult);
  }

  FCSearchUserResultCopyWith<
    FCSearchUserResult,
    FCSearchUserResult,
    FCSearchUserResult
  >
  get copyWith =>
      _FCSearchUserResultCopyWithImpl<FCSearchUserResult, FCSearchUserResult>(
        this as FCSearchUserResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCSearchUserResultMapper.ensureInitialized().stringifyValue(
      this as FCSearchUserResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSearchUserResultMapper.ensureInitialized().equalsValue(
      this as FCSearchUserResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSearchUserResultMapper.ensureInitialized().hashValue(
      this as FCSearchUserResult,
    );
  }
}

extension FCSearchUserResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSearchUserResult, $Out> {
  FCSearchUserResultCopyWith<$R, FCSearchUserResult, $Out>
  get $asFCSearchUserResult => $base.as(
    (v, t, t2) => _FCSearchUserResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCSearchUserResultCopyWith<
  $R,
  $In extends FCSearchUserResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCSearchUser,
    FCSearchUserCopyWith<$R, FCSearchUser, FCSearchUser>
  >
  get list;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? total,
    List<FCSearchUser>? list,
  });
  FCSearchUserResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCSearchUserResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSearchUserResult, $Out>
    implements FCSearchUserResultCopyWith<$R, FCSearchUserResult, $Out> {
  _FCSearchUserResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSearchUserResult> $mapper =
      FCSearchUserResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCSearchUser,
    FCSearchUserCopyWith<$R, FCSearchUser, FCSearchUser>
  >
  get list => ListCopyWith(
    $value.list,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(list: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? total,
    List<FCSearchUser>? list,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (total != null) #total: total,
      if (list != null) #list: list,
    }),
  );
  @override
  FCSearchUserResult $make(CopyWithData data) => FCSearchUserResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    total: data.get(#total, or: $value.total),
    list: data.get(#list, or: $value.list),
  );

  @override
  FCSearchUserResultCopyWith<$R2, FCSearchUserResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCSearchUserResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCSearchUserMapper extends ClassMapperBase<FCSearchUser> {
  FCSearchUserMapper._();

  static FCSearchUserMapper? _instance;
  static FCSearchUserMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCSearchUserMapper._());
      FCUserMapper.ensureInitialized();
      FCUserCustomFieldMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCSearchUser';

  static String _$id(FCSearchUser v) => v.id;
  static const Field<FCSearchUser, String> _f$id = Field('id', _$id);
  static String _$username(FCSearchUser v) => v.username;
  static const Field<FCSearchUser, String> _f$username = Field(
    'username',
    _$username,
  );
  static String? _$loginName(FCSearchUser v) => v.loginName;
  static const Field<FCSearchUser, String> _f$loginName = Field(
    'loginName',
    _$loginName,
    opt: true,
  );
  static String? _$email(FCSearchUser v) => v.email;
  static const Field<FCSearchUser, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static String? _$userType(FCSearchUser v) => v.userType;
  static const Field<FCSearchUser, String> _f$userType = Field(
    'userType',
    _$userType,
    opt: true,
  );
  static String? _$iconUrl(FCSearchUser v) => v.iconUrl;
  static const Field<FCSearchUser, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static int _$postCount(FCSearchUser v) => v.postCount;
  static const Field<FCSearchUser, int> _f$postCount = Field(
    'postCount',
    _$postCount,
    opt: true,
    def: 0,
  );
  static DateTime? _$registrationTime(FCSearchUser v) => v.registrationTime;
  static const Field<FCSearchUser, DateTime> _f$registrationTime = Field(
    'registrationTime',
    _$registrationTime,
    opt: true,
  );
  static DateTime? _$lastActivityTime(FCSearchUser v) => v.lastActivityTime;
  static const Field<FCSearchUser, DateTime> _f$lastActivityTime = Field(
    'lastActivityTime',
    _$lastActivityTime,
    opt: true,
  );
  static bool _$isOnline(FCSearchUser v) => v.isOnline;
  static const Field<FCSearchUser, bool> _f$isOnline = Field(
    'isOnline',
    _$isOnline,
    opt: true,
    def: false,
  );
  static String? _$currentActivity(FCSearchUser v) => v.currentActivity;
  static const Field<FCSearchUser, String> _f$currentActivity = Field(
    'currentActivity',
    _$currentActivity,
    opt: true,
  );
  static String? _$currentTopicId(FCSearchUser v) => v.currentTopicId;
  static const Field<FCSearchUser, String> _f$currentTopicId = Field(
    'currentTopicId',
    _$currentTopicId,
    opt: true,
  );
  static bool _$acceptsPM(FCSearchUser v) => v.acceptsPM;
  static const Field<FCSearchUser, bool> _f$acceptsPM = Field(
    'acceptsPM',
    _$acceptsPM,
    opt: true,
    def: false,
  );
  static bool _$canSendPM(FCSearchUser v) => v.canSendPM;
  static const Field<FCSearchUser, bool> _f$canSendPM = Field(
    'canSendPM',
    _$canSendPM,
    opt: true,
    def: false,
  );
  static bool _$canPM(FCSearchUser v) => v.canPM;
  static const Field<FCSearchUser, bool> _f$canPM = Field(
    'canPM',
    _$canPM,
    opt: true,
    def: false,
  );
  static bool _$isFollowing(FCSearchUser v) => v.isFollowing;
  static const Field<FCSearchUser, bool> _f$isFollowing = Field(
    'isFollowing',
    _$isFollowing,
    opt: true,
    def: false,
  );
  static bool _$isFollowingMe(FCSearchUser v) => v.isFollowingMe;
  static const Field<FCSearchUser, bool> _f$isFollowingMe = Field(
    'isFollowingMe',
    _$isFollowingMe,
    opt: true,
    def: false,
  );
  static bool _$acceptsFollowers(FCSearchUser v) => v.acceptsFollowers;
  static const Field<FCSearchUser, bool> _f$acceptsFollowers = Field(
    'acceptsFollowers',
    _$acceptsFollowers,
    opt: true,
    def: false,
  );
  static int _$followingCount(FCSearchUser v) => v.followingCount;
  static const Field<FCSearchUser, int> _f$followingCount = Field(
    'followingCount',
    _$followingCount,
    opt: true,
    def: 0,
  );
  static int _$followerCount(FCSearchUser v) => v.followerCount;
  static const Field<FCSearchUser, int> _f$followerCount = Field(
    'followerCount',
    _$followerCount,
    opt: true,
    def: 0,
  );
  static String? _$displayText(FCSearchUser v) => v.displayText;
  static const Field<FCSearchUser, String> _f$displayText = Field(
    'displayText',
    _$displayText,
    opt: true,
  );
  static List<FCUserCustomField> _$customFields(FCSearchUser v) =>
      v.customFields;
  static const Field<FCSearchUser, List<FCUserCustomField>> _f$customFields =
      Field('customFields', _$customFields, opt: true, def: const []);
  static bool _$canBan(FCSearchUser v) => v.canBan;
  static const Field<FCSearchUser, bool> _f$canBan = Field(
    'canBan',
    _$canBan,
    opt: true,
    def: false,
  );
  static bool _$isBanned(FCSearchUser v) => v.isBanned;
  static const Field<FCSearchUser, bool> _f$isBanned = Field(
    'isBanned',
    _$isBanned,
    opt: true,
    def: false,
  );
  static bool _$isIgnored(FCSearchUser v) => v.isIgnored;
  static const Field<FCSearchUser, bool> _f$isIgnored = Field(
    'isIgnored',
    _$isIgnored,
    opt: true,
    def: false,
  );
  static bool _$canSpamClean(FCSearchUser v) => v.canSpamClean;
  static const Field<FCSearchUser, bool> _f$canSpamClean = Field(
    'canSpamClean',
    _$canSpamClean,
    opt: true,
    def: false,
  );
  static bool _$canBeReported(FCSearchUser v) => v.canBeReported;
  static const Field<FCSearchUser, bool> _f$canBeReported = Field(
    'canBeReported',
    _$canBeReported,
    opt: true,
    def: false,
  );
  static List<String> _$userGroups(FCSearchUser v) => v.userGroups;
  static const Field<FCSearchUser, List<String>> _f$userGroups = Field(
    'userGroups',
    _$userGroups,
    opt: true,
    def: const [],
  );
  static bool _$canModerate(FCSearchUser v) => v.canModerate;
  static const Field<FCSearchUser, bool> _f$canModerate = Field(
    'canModerate',
    _$canModerate,
    opt: true,
    def: false,
  );
  static bool _$canSearch(FCSearchUser v) => v.canSearch;
  static const Field<FCSearchUser, bool> _f$canSearch = Field(
    'canSearch',
    _$canSearch,
    opt: true,
    def: false,
  );
  static String? _$userState(FCSearchUser v) => v.userState;
  static const Field<FCSearchUser, String> _f$userState = Field(
    'userState',
    _$userState,
    opt: true,
    def: 'valid',
  );
  static String? _$status(FCSearchUser v) => v.status;
  static const Field<FCSearchUser, String> _f$status = Field(
    'status',
    _$status,
    opt: true,
  );

  @override
  final MappableFields<FCSearchUser> fields = const {
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
    #status: _f$status,
  };

  static FCSearchUser _instantiate(DecodingData data) {
    return FCSearchUser(
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
      status: data.dec(_f$status),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCSearchUser fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCSearchUser>(map);
  }

  static FCSearchUser fromJson(String json) {
    return ensureInitialized().decodeJson<FCSearchUser>(json);
  }
}

mixin FCSearchUserMappable {
  String toJson() {
    return FCSearchUserMapper.ensureInitialized().encodeJson<FCSearchUser>(
      this as FCSearchUser,
    );
  }

  Map<String, dynamic> toMap() {
    return FCSearchUserMapper.ensureInitialized().encodeMap<FCSearchUser>(
      this as FCSearchUser,
    );
  }

  FCSearchUserCopyWith<FCSearchUser, FCSearchUser, FCSearchUser> get copyWith =>
      _FCSearchUserCopyWithImpl<FCSearchUser, FCSearchUser>(
        this as FCSearchUser,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCSearchUserMapper.ensureInitialized().stringifyValue(
      this as FCSearchUser,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCSearchUserMapper.ensureInitialized().equalsValue(
      this as FCSearchUser,
      other,
    );
  }

  @override
  int get hashCode {
    return FCSearchUserMapper.ensureInitialized().hashValue(
      this as FCSearchUser,
    );
  }
}

extension FCSearchUserValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCSearchUser, $Out> {
  FCSearchUserCopyWith<$R, FCSearchUser, $Out> get $asFCSearchUser =>
      $base.as((v, t, t2) => _FCSearchUserCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCSearchUserCopyWith<$R, $In extends FCSearchUser, $Out>
    implements FCUserCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<
    $R,
    FCUserCustomField,
    FCUserCustomFieldCopyWith<$R, FCUserCustomField, FCUserCustomField>
  >
  get customFields;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get userGroups;
  @override
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
    String? status,
  });
  FCSearchUserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCSearchUserCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCSearchUser, $Out>
    implements FCSearchUserCopyWith<$R, FCSearchUser, $Out> {
  _FCSearchUserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCSearchUser> $mapper =
      FCSearchUserMapper.ensureInitialized();
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
    Object? status = $none,
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
      if (status != $none) #status: status,
    }),
  );
  @override
  FCSearchUser $make(CopyWithData data) => FCSearchUser(
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
    status: data.get(#status, or: $value.status),
  );

  @override
  FCSearchUserCopyWith<$R2, FCSearchUser, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCSearchUserCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCReportUserResultMapper extends ClassMapperBase<FCReportUserResult> {
  FCReportUserResultMapper._();

  static FCReportUserResultMapper? _instance;
  static FCReportUserResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCReportUserResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCReportUserResult';

  static bool _$result(FCReportUserResult v) => v.result;
  static const Field<FCReportUserResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCReportUserResult v) => v.resultText;
  static const Field<FCReportUserResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCReportUserResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCReportUserResult _instantiate(DecodingData data) {
    return FCReportUserResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCReportUserResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCReportUserResult>(map);
  }

  static FCReportUserResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCReportUserResult>(json);
  }
}

mixin FCReportUserResultMappable {
  String toJson() {
    return FCReportUserResultMapper.ensureInitialized()
        .encodeJson<FCReportUserResult>(this as FCReportUserResult);
  }

  Map<String, dynamic> toMap() {
    return FCReportUserResultMapper.ensureInitialized()
        .encodeMap<FCReportUserResult>(this as FCReportUserResult);
  }

  FCReportUserResultCopyWith<
    FCReportUserResult,
    FCReportUserResult,
    FCReportUserResult
  >
  get copyWith =>
      _FCReportUserResultCopyWithImpl<FCReportUserResult, FCReportUserResult>(
        this as FCReportUserResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCReportUserResultMapper.ensureInitialized().stringifyValue(
      this as FCReportUserResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCReportUserResultMapper.ensureInitialized().equalsValue(
      this as FCReportUserResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCReportUserResultMapper.ensureInitialized().hashValue(
      this as FCReportUserResult,
    );
  }
}

extension FCReportUserResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCReportUserResult, $Out> {
  FCReportUserResultCopyWith<$R, FCReportUserResult, $Out>
  get $asFCReportUserResult => $base.as(
    (v, t, t2) => _FCReportUserResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCReportUserResultCopyWith<
  $R,
  $In extends FCReportUserResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCReportUserResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCReportUserResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCReportUserResult, $Out>
    implements FCReportUserResultCopyWith<$R, FCReportUserResult, $Out> {
  _FCReportUserResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCReportUserResult> $mapper =
      FCReportUserResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCReportUserResult $make(CopyWithData data) => FCReportUserResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCReportUserResultCopyWith<$R2, FCReportUserResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCReportUserResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCIgnoreUserResultMapper extends ClassMapperBase<FCIgnoreUserResult> {
  FCIgnoreUserResultMapper._();

  static FCIgnoreUserResultMapper? _instance;
  static FCIgnoreUserResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCIgnoreUserResultMapper._());
      FCBaseResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCIgnoreUserResult';

  static bool _$result(FCIgnoreUserResult v) => v.result;
  static const Field<FCIgnoreUserResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCIgnoreUserResult v) => v.resultText;
  static const Field<FCIgnoreUserResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );

  @override
  final MappableFields<FCIgnoreUserResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
  };

  static FCIgnoreUserResult _instantiate(DecodingData data) {
    return FCIgnoreUserResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCIgnoreUserResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCIgnoreUserResult>(map);
  }

  static FCIgnoreUserResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCIgnoreUserResult>(json);
  }
}

mixin FCIgnoreUserResultMappable {
  String toJson() {
    return FCIgnoreUserResultMapper.ensureInitialized()
        .encodeJson<FCIgnoreUserResult>(this as FCIgnoreUserResult);
  }

  Map<String, dynamic> toMap() {
    return FCIgnoreUserResultMapper.ensureInitialized()
        .encodeMap<FCIgnoreUserResult>(this as FCIgnoreUserResult);
  }

  FCIgnoreUserResultCopyWith<
    FCIgnoreUserResult,
    FCIgnoreUserResult,
    FCIgnoreUserResult
  >
  get copyWith =>
      _FCIgnoreUserResultCopyWithImpl<FCIgnoreUserResult, FCIgnoreUserResult>(
        this as FCIgnoreUserResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCIgnoreUserResultMapper.ensureInitialized().stringifyValue(
      this as FCIgnoreUserResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCIgnoreUserResultMapper.ensureInitialized().equalsValue(
      this as FCIgnoreUserResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCIgnoreUserResultMapper.ensureInitialized().hashValue(
      this as FCIgnoreUserResult,
    );
  }
}

extension FCIgnoreUserResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCIgnoreUserResult, $Out> {
  FCIgnoreUserResultCopyWith<$R, FCIgnoreUserResult, $Out>
  get $asFCIgnoreUserResult => $base.as(
    (v, t, t2) => _FCIgnoreUserResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCIgnoreUserResultCopyWith<
  $R,
  $In extends FCIgnoreUserResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  @override
  $R call({bool? result, String? resultText});
  FCIgnoreUserResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCIgnoreUserResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCIgnoreUserResult, $Out>
    implements FCIgnoreUserResultCopyWith<$R, FCIgnoreUserResult, $Out> {
  _FCIgnoreUserResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCIgnoreUserResult> $mapper =
      FCIgnoreUserResultMapper.ensureInitialized();
  @override
  $R call({bool? result, Object? resultText = $none}) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
    }),
  );
  @override
  FCIgnoreUserResult $make(CopyWithData data) => FCIgnoreUserResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
  );

  @override
  FCIgnoreUserResultCopyWith<$R2, FCIgnoreUserResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCIgnoreUserResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCIgnoredUserResultMapper extends ClassMapperBase<FCIgnoredUserResult> {
  FCIgnoredUserResultMapper._();

  static FCIgnoredUserResultMapper? _instance;
  static FCIgnoredUserResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCIgnoredUserResultMapper._());
      FCBaseResultMapper.ensureInitialized();
      FCIgnoredUserMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCIgnoredUserResult';

  static bool _$result(FCIgnoredUserResult v) => v.result;
  static const Field<FCIgnoredUserResult, bool> _f$result = Field(
    'result',
    _$result,
  );
  static String? _$resultText(FCIgnoredUserResult v) => v.resultText;
  static const Field<FCIgnoredUserResult, String> _f$resultText = Field(
    'resultText',
    _$resultText,
    opt: true,
  );
  static int _$total(FCIgnoredUserResult v) => v.total;
  static const Field<FCIgnoredUserResult, int> _f$total = Field(
    'total',
    _$total,
    opt: true,
    def: 0,
  );
  static List<FCIgnoredUser> _$list(FCIgnoredUserResult v) => v.list;
  static const Field<FCIgnoredUserResult, List<FCIgnoredUser>> _f$list = Field(
    'list',
    _$list,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<FCIgnoredUserResult> fields = const {
    #result: _f$result,
    #resultText: _f$resultText,
    #total: _f$total,
    #list: _f$list,
  };

  static FCIgnoredUserResult _instantiate(DecodingData data) {
    return FCIgnoredUserResult(
      result: data.dec(_f$result),
      resultText: data.dec(_f$resultText),
      total: data.dec(_f$total),
      list: data.dec(_f$list),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCIgnoredUserResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCIgnoredUserResult>(map);
  }

  static FCIgnoredUserResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCIgnoredUserResult>(json);
  }
}

mixin FCIgnoredUserResultMappable {
  String toJson() {
    return FCIgnoredUserResultMapper.ensureInitialized()
        .encodeJson<FCIgnoredUserResult>(this as FCIgnoredUserResult);
  }

  Map<String, dynamic> toMap() {
    return FCIgnoredUserResultMapper.ensureInitialized()
        .encodeMap<FCIgnoredUserResult>(this as FCIgnoredUserResult);
  }

  FCIgnoredUserResultCopyWith<
    FCIgnoredUserResult,
    FCIgnoredUserResult,
    FCIgnoredUserResult
  >
  get copyWith =>
      _FCIgnoredUserResultCopyWithImpl<
        FCIgnoredUserResult,
        FCIgnoredUserResult
      >(this as FCIgnoredUserResult, $identity, $identity);
  @override
  String toString() {
    return FCIgnoredUserResultMapper.ensureInitialized().stringifyValue(
      this as FCIgnoredUserResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCIgnoredUserResultMapper.ensureInitialized().equalsValue(
      this as FCIgnoredUserResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCIgnoredUserResultMapper.ensureInitialized().hashValue(
      this as FCIgnoredUserResult,
    );
  }
}

extension FCIgnoredUserResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCIgnoredUserResult, $Out> {
  FCIgnoredUserResultCopyWith<$R, FCIgnoredUserResult, $Out>
  get $asFCIgnoredUserResult => $base.as(
    (v, t, t2) => _FCIgnoredUserResultCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCIgnoredUserResultCopyWith<
  $R,
  $In extends FCIgnoredUserResult,
  $Out
>
    implements FCBaseResultCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    FCIgnoredUser,
    FCIgnoredUserCopyWith<$R, FCIgnoredUser, FCIgnoredUser>
  >
  get list;
  @override
  $R call({
    bool? result,
    String? resultText,
    int? total,
    List<FCIgnoredUser>? list,
  });
  FCIgnoredUserResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCIgnoredUserResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCIgnoredUserResult, $Out>
    implements FCIgnoredUserResultCopyWith<$R, FCIgnoredUserResult, $Out> {
  _FCIgnoredUserResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCIgnoredUserResult> $mapper =
      FCIgnoredUserResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    FCIgnoredUser,
    FCIgnoredUserCopyWith<$R, FCIgnoredUser, FCIgnoredUser>
  >
  get list => ListCopyWith(
    $value.list,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(list: v),
  );
  @override
  $R call({
    bool? result,
    Object? resultText = $none,
    int? total,
    List<FCIgnoredUser>? list,
  }) => $apply(
    FieldCopyWithData({
      if (result != null) #result: result,
      if (resultText != $none) #resultText: resultText,
      if (total != null) #total: total,
      if (list != null) #list: list,
    }),
  );
  @override
  FCIgnoredUserResult $make(CopyWithData data) => FCIgnoredUserResult(
    result: data.get(#result, or: $value.result),
    resultText: data.get(#resultText, or: $value.resultText),
    total: data.get(#total, or: $value.total),
    list: data.get(#list, or: $value.list),
  );

  @override
  FCIgnoredUserResultCopyWith<$R2, FCIgnoredUserResult, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCIgnoredUserResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FCIgnoredUserMapper extends ClassMapperBase<FCIgnoredUser> {
  FCIgnoredUserMapper._();

  static FCIgnoredUserMapper? _instance;
  static FCIgnoredUserMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCIgnoredUserMapper._());
      FCUserMapper.ensureInitialized();
      FCUserCustomFieldMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FCIgnoredUser';

  static String _$id(FCIgnoredUser v) => v.id;
  static const Field<FCIgnoredUser, String> _f$id = Field('id', _$id);
  static String _$username(FCIgnoredUser v) => v.username;
  static const Field<FCIgnoredUser, String> _f$username = Field(
    'username',
    _$username,
  );
  static String? _$loginName(FCIgnoredUser v) => v.loginName;
  static const Field<FCIgnoredUser, String> _f$loginName = Field(
    'loginName',
    _$loginName,
    opt: true,
  );
  static String? _$email(FCIgnoredUser v) => v.email;
  static const Field<FCIgnoredUser, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static String? _$userType(FCIgnoredUser v) => v.userType;
  static const Field<FCIgnoredUser, String> _f$userType = Field(
    'userType',
    _$userType,
    opt: true,
  );
  static String? _$iconUrl(FCIgnoredUser v) => v.iconUrl;
  static const Field<FCIgnoredUser, String> _f$iconUrl = Field(
    'iconUrl',
    _$iconUrl,
    opt: true,
  );
  static int _$postCount(FCIgnoredUser v) => v.postCount;
  static const Field<FCIgnoredUser, int> _f$postCount = Field(
    'postCount',
    _$postCount,
    opt: true,
    def: 0,
  );
  static DateTime? _$registrationTime(FCIgnoredUser v) => v.registrationTime;
  static const Field<FCIgnoredUser, DateTime> _f$registrationTime = Field(
    'registrationTime',
    _$registrationTime,
    opt: true,
  );
  static DateTime? _$lastActivityTime(FCIgnoredUser v) => v.lastActivityTime;
  static const Field<FCIgnoredUser, DateTime> _f$lastActivityTime = Field(
    'lastActivityTime',
    _$lastActivityTime,
    opt: true,
  );
  static bool _$isOnline(FCIgnoredUser v) => v.isOnline;
  static const Field<FCIgnoredUser, bool> _f$isOnline = Field(
    'isOnline',
    _$isOnline,
    opt: true,
    def: false,
  );
  static String? _$currentActivity(FCIgnoredUser v) => v.currentActivity;
  static const Field<FCIgnoredUser, String> _f$currentActivity = Field(
    'currentActivity',
    _$currentActivity,
    opt: true,
  );
  static String? _$currentTopicId(FCIgnoredUser v) => v.currentTopicId;
  static const Field<FCIgnoredUser, String> _f$currentTopicId = Field(
    'currentTopicId',
    _$currentTopicId,
    opt: true,
  );
  static bool _$acceptsPM(FCIgnoredUser v) => v.acceptsPM;
  static const Field<FCIgnoredUser, bool> _f$acceptsPM = Field(
    'acceptsPM',
    _$acceptsPM,
    opt: true,
    def: false,
  );
  static bool _$canSendPM(FCIgnoredUser v) => v.canSendPM;
  static const Field<FCIgnoredUser, bool> _f$canSendPM = Field(
    'canSendPM',
    _$canSendPM,
    opt: true,
    def: false,
  );
  static bool _$canPM(FCIgnoredUser v) => v.canPM;
  static const Field<FCIgnoredUser, bool> _f$canPM = Field(
    'canPM',
    _$canPM,
    opt: true,
    def: false,
  );
  static bool _$isFollowing(FCIgnoredUser v) => v.isFollowing;
  static const Field<FCIgnoredUser, bool> _f$isFollowing = Field(
    'isFollowing',
    _$isFollowing,
    opt: true,
    def: false,
  );
  static bool _$isFollowingMe(FCIgnoredUser v) => v.isFollowingMe;
  static const Field<FCIgnoredUser, bool> _f$isFollowingMe = Field(
    'isFollowingMe',
    _$isFollowingMe,
    opt: true,
    def: false,
  );
  static bool _$acceptsFollowers(FCIgnoredUser v) => v.acceptsFollowers;
  static const Field<FCIgnoredUser, bool> _f$acceptsFollowers = Field(
    'acceptsFollowers',
    _$acceptsFollowers,
    opt: true,
    def: false,
  );
  static int _$followingCount(FCIgnoredUser v) => v.followingCount;
  static const Field<FCIgnoredUser, int> _f$followingCount = Field(
    'followingCount',
    _$followingCount,
    opt: true,
    def: 0,
  );
  static int _$followerCount(FCIgnoredUser v) => v.followerCount;
  static const Field<FCIgnoredUser, int> _f$followerCount = Field(
    'followerCount',
    _$followerCount,
    opt: true,
    def: 0,
  );
  static String? _$displayText(FCIgnoredUser v) => v.displayText;
  static const Field<FCIgnoredUser, String> _f$displayText = Field(
    'displayText',
    _$displayText,
    opt: true,
  );
  static List<FCUserCustomField> _$customFields(FCIgnoredUser v) =>
      v.customFields;
  static const Field<FCIgnoredUser, List<FCUserCustomField>> _f$customFields =
      Field('customFields', _$customFields, opt: true, def: const []);
  static bool _$canBan(FCIgnoredUser v) => v.canBan;
  static const Field<FCIgnoredUser, bool> _f$canBan = Field(
    'canBan',
    _$canBan,
    opt: true,
    def: false,
  );
  static bool _$isBanned(FCIgnoredUser v) => v.isBanned;
  static const Field<FCIgnoredUser, bool> _f$isBanned = Field(
    'isBanned',
    _$isBanned,
    opt: true,
    def: false,
  );
  static bool _$isIgnored(FCIgnoredUser v) => v.isIgnored;
  static const Field<FCIgnoredUser, bool> _f$isIgnored = Field(
    'isIgnored',
    _$isIgnored,
    opt: true,
    def: false,
  );
  static bool _$canSpamClean(FCIgnoredUser v) => v.canSpamClean;
  static const Field<FCIgnoredUser, bool> _f$canSpamClean = Field(
    'canSpamClean',
    _$canSpamClean,
    opt: true,
    def: false,
  );
  static bool _$canBeReported(FCIgnoredUser v) => v.canBeReported;
  static const Field<FCIgnoredUser, bool> _f$canBeReported = Field(
    'canBeReported',
    _$canBeReported,
    opt: true,
    def: false,
  );
  static List<String> _$userGroups(FCIgnoredUser v) => v.userGroups;
  static const Field<FCIgnoredUser, List<String>> _f$userGroups = Field(
    'userGroups',
    _$userGroups,
    opt: true,
    def: const [],
  );
  static bool _$canModerate(FCIgnoredUser v) => v.canModerate;
  static const Field<FCIgnoredUser, bool> _f$canModerate = Field(
    'canModerate',
    _$canModerate,
    opt: true,
    def: false,
  );
  static bool _$canSearch(FCIgnoredUser v) => v.canSearch;
  static const Field<FCIgnoredUser, bool> _f$canSearch = Field(
    'canSearch',
    _$canSearch,
    opt: true,
    def: false,
  );
  static String? _$userState(FCIgnoredUser v) => v.userState;
  static const Field<FCIgnoredUser, String> _f$userState = Field(
    'userState',
    _$userState,
    opt: true,
    def: 'valid',
  );
  static String? _$status(FCIgnoredUser v) => v.status;
  static const Field<FCIgnoredUser, String> _f$status = Field(
    'status',
    _$status,
    opt: true,
  );

  @override
  final MappableFields<FCIgnoredUser> fields = const {
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
    #status: _f$status,
  };

  static FCIgnoredUser _instantiate(DecodingData data) {
    return FCIgnoredUser(
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
      status: data.dec(_f$status),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCIgnoredUser fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCIgnoredUser>(map);
  }

  static FCIgnoredUser fromJson(String json) {
    return ensureInitialized().decodeJson<FCIgnoredUser>(json);
  }
}

mixin FCIgnoredUserMappable {
  String toJson() {
    return FCIgnoredUserMapper.ensureInitialized().encodeJson<FCIgnoredUser>(
      this as FCIgnoredUser,
    );
  }

  Map<String, dynamic> toMap() {
    return FCIgnoredUserMapper.ensureInitialized().encodeMap<FCIgnoredUser>(
      this as FCIgnoredUser,
    );
  }

  FCIgnoredUserCopyWith<FCIgnoredUser, FCIgnoredUser, FCIgnoredUser>
  get copyWith => _FCIgnoredUserCopyWithImpl<FCIgnoredUser, FCIgnoredUser>(
    this as FCIgnoredUser,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCIgnoredUserMapper.ensureInitialized().stringifyValue(
      this as FCIgnoredUser,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCIgnoredUserMapper.ensureInitialized().equalsValue(
      this as FCIgnoredUser,
      other,
    );
  }

  @override
  int get hashCode {
    return FCIgnoredUserMapper.ensureInitialized().hashValue(
      this as FCIgnoredUser,
    );
  }
}

extension FCIgnoredUserValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCIgnoredUser, $Out> {
  FCIgnoredUserCopyWith<$R, FCIgnoredUser, $Out> get $asFCIgnoredUser =>
      $base.as((v, t, t2) => _FCIgnoredUserCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCIgnoredUserCopyWith<$R, $In extends FCIgnoredUser, $Out>
    implements FCUserCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<
    $R,
    FCUserCustomField,
    FCUserCustomFieldCopyWith<$R, FCUserCustomField, FCUserCustomField>
  >
  get customFields;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get userGroups;
  @override
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
    String? status,
  });
  FCIgnoredUserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCIgnoredUserCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCIgnoredUser, $Out>
    implements FCIgnoredUserCopyWith<$R, FCIgnoredUser, $Out> {
  _FCIgnoredUserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCIgnoredUser> $mapper =
      FCIgnoredUserMapper.ensureInitialized();
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
    Object? status = $none,
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
      if (status != $none) #status: status,
    }),
  );
  @override
  FCIgnoredUser $make(CopyWithData data) => FCIgnoredUser(
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
    status: data.get(#status, or: $value.status),
  );

  @override
  FCIgnoredUserCopyWith<$R2, FCIgnoredUser, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCIgnoredUserCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

