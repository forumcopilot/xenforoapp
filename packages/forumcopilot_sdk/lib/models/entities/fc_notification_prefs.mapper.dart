// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_notification_prefs.dart';

class FCNotificationPrefsMapper extends ClassMapperBase<FCNotificationPrefs> {
  FCNotificationPrefsMapper._();

  static FCNotificationPrefsMapper? _instance;
  static FCNotificationPrefsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCNotificationPrefsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCNotificationPrefs';

  static int _$emailLevel(FCNotificationPrefs v) => v.emailLevel;
  static const Field<FCNotificationPrefs, int> _f$emailLevel = Field(
    'emailLevel',
    _$emailLevel,
    opt: true,
    def: 1,
  );
  static int _$emailMessagesLevel(FCNotificationPrefs v) =>
      v.emailMessagesLevel;
  static const Field<FCNotificationPrefs, int> _f$emailMessagesLevel = Field(
    'emailMessagesLevel',
    _$emailMessagesLevel,
    opt: true,
    def: 1,
  );
  static bool _$emailDigests(FCNotificationPrefs v) => v.emailDigests;
  static const Field<FCNotificationPrefs, bool> _f$emailDigests = Field(
    'emailDigests',
    _$emailDigests,
    opt: true,
    def: true,
  );
  static int _$digestAfterMinutes(FCNotificationPrefs v) =>
      v.digestAfterMinutes;
  static const Field<FCNotificationPrefs, int> _f$digestAfterMinutes = Field(
    'digestAfterMinutes',
    _$digestAfterMinutes,
    opt: true,
    def: 10080,
  );
  static bool _$mailingListMode(FCNotificationPrefs v) => v.mailingListMode;
  static const Field<FCNotificationPrefs, bool> _f$mailingListMode = Field(
    'mailingListMode',
    _$mailingListMode,
    opt: true,
    def: false,
  );
  static int _$likeNotificationFrequency(FCNotificationPrefs v) =>
      v.likeNotificationFrequency;
  static const Field<FCNotificationPrefs, int> _f$likeNotificationFrequency =
      Field(
        'likeNotificationFrequency',
        _$likeNotificationFrequency,
        opt: true,
        def: 0,
      );
  static int _$notificationLevelWhenReplying(FCNotificationPrefs v) =>
      v.notificationLevelWhenReplying;
  static const Field<FCNotificationPrefs, int>
  _f$notificationLevelWhenReplying = Field(
    'notificationLevelWhenReplying',
    _$notificationLevelWhenReplying,
    opt: true,
    def: 2,
  );

  @override
  final MappableFields<FCNotificationPrefs> fields = const {
    #emailLevel: _f$emailLevel,
    #emailMessagesLevel: _f$emailMessagesLevel,
    #emailDigests: _f$emailDigests,
    #digestAfterMinutes: _f$digestAfterMinutes,
    #mailingListMode: _f$mailingListMode,
    #likeNotificationFrequency: _f$likeNotificationFrequency,
    #notificationLevelWhenReplying: _f$notificationLevelWhenReplying,
  };

  static FCNotificationPrefs _instantiate(DecodingData data) {
    return FCNotificationPrefs(
      emailLevel: data.dec(_f$emailLevel),
      emailMessagesLevel: data.dec(_f$emailMessagesLevel),
      emailDigests: data.dec(_f$emailDigests),
      digestAfterMinutes: data.dec(_f$digestAfterMinutes),
      mailingListMode: data.dec(_f$mailingListMode),
      likeNotificationFrequency: data.dec(_f$likeNotificationFrequency),
      notificationLevelWhenReplying: data.dec(_f$notificationLevelWhenReplying),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCNotificationPrefs fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCNotificationPrefs>(map);
  }

  static FCNotificationPrefs fromJson(String json) {
    return ensureInitialized().decodeJson<FCNotificationPrefs>(json);
  }
}

mixin FCNotificationPrefsMappable {
  String toJson() {
    return FCNotificationPrefsMapper.ensureInitialized()
        .encodeJson<FCNotificationPrefs>(this as FCNotificationPrefs);
  }

  Map<String, dynamic> toMap() {
    return FCNotificationPrefsMapper.ensureInitialized()
        .encodeMap<FCNotificationPrefs>(this as FCNotificationPrefs);
  }

  FCNotificationPrefsCopyWith<
    FCNotificationPrefs,
    FCNotificationPrefs,
    FCNotificationPrefs
  >
  get copyWith =>
      _FCNotificationPrefsCopyWithImpl<
        FCNotificationPrefs,
        FCNotificationPrefs
      >(this as FCNotificationPrefs, $identity, $identity);
  @override
  String toString() {
    return FCNotificationPrefsMapper.ensureInitialized().stringifyValue(
      this as FCNotificationPrefs,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCNotificationPrefsMapper.ensureInitialized().equalsValue(
      this as FCNotificationPrefs,
      other,
    );
  }

  @override
  int get hashCode {
    return FCNotificationPrefsMapper.ensureInitialized().hashValue(
      this as FCNotificationPrefs,
    );
  }
}

extension FCNotificationPrefsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCNotificationPrefs, $Out> {
  FCNotificationPrefsCopyWith<$R, FCNotificationPrefs, $Out>
  get $asFCNotificationPrefs => $base.as(
    (v, t, t2) => _FCNotificationPrefsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FCNotificationPrefsCopyWith<
  $R,
  $In extends FCNotificationPrefs,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? emailLevel,
    int? emailMessagesLevel,
    bool? emailDigests,
    int? digestAfterMinutes,
    bool? mailingListMode,
    int? likeNotificationFrequency,
    int? notificationLevelWhenReplying,
  });
  FCNotificationPrefsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCNotificationPrefsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCNotificationPrefs, $Out>
    implements FCNotificationPrefsCopyWith<$R, FCNotificationPrefs, $Out> {
  _FCNotificationPrefsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCNotificationPrefs> $mapper =
      FCNotificationPrefsMapper.ensureInitialized();
  @override
  $R call({
    int? emailLevel,
    int? emailMessagesLevel,
    bool? emailDigests,
    int? digestAfterMinutes,
    bool? mailingListMode,
    int? likeNotificationFrequency,
    int? notificationLevelWhenReplying,
  }) => $apply(
    FieldCopyWithData({
      if (emailLevel != null) #emailLevel: emailLevel,
      if (emailMessagesLevel != null) #emailMessagesLevel: emailMessagesLevel,
      if (emailDigests != null) #emailDigests: emailDigests,
      if (digestAfterMinutes != null) #digestAfterMinutes: digestAfterMinutes,
      if (mailingListMode != null) #mailingListMode: mailingListMode,
      if (likeNotificationFrequency != null)
        #likeNotificationFrequency: likeNotificationFrequency,
      if (notificationLevelWhenReplying != null)
        #notificationLevelWhenReplying: notificationLevelWhenReplying,
    }),
  );
  @override
  FCNotificationPrefs $make(CopyWithData data) => FCNotificationPrefs(
    emailLevel: data.get(#emailLevel, or: $value.emailLevel),
    emailMessagesLevel: data.get(
      #emailMessagesLevel,
      or: $value.emailMessagesLevel,
    ),
    emailDigests: data.get(#emailDigests, or: $value.emailDigests),
    digestAfterMinutes: data.get(
      #digestAfterMinutes,
      or: $value.digestAfterMinutes,
    ),
    mailingListMode: data.get(#mailingListMode, or: $value.mailingListMode),
    likeNotificationFrequency: data.get(
      #likeNotificationFrequency,
      or: $value.likeNotificationFrequency,
    ),
    notificationLevelWhenReplying: data.get(
      #notificationLevelWhenReplying,
      or: $value.notificationLevelWhenReplying,
    ),
  );

  @override
  FCNotificationPrefsCopyWith<$R2, FCNotificationPrefs, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCNotificationPrefsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

