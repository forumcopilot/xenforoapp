// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_group.dart';

class FCGroupMapper extends ClassMapperBase<FCGroup> {
  FCGroupMapper._();

  static FCGroupMapper? _instance;
  static FCGroupMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCGroupMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCGroup';

  static int _$id(FCGroup v) => v.id;
  static const Field<FCGroup, int> _f$id = Field('id', _$id);
  static String _$name(FCGroup v) => v.name;
  static const Field<FCGroup, String> _f$name = Field('name', _$name);
  static String? _$fullName(FCGroup v) => v.fullName;
  static const Field<FCGroup, String> _f$fullName = Field(
    'fullName',
    _$fullName,
    opt: true,
  );
  static String? _$bio(FCGroup v) => v.bio;
  static const Field<FCGroup, String> _f$bio = Field('bio', _$bio, opt: true);
  static int _$memberCount(FCGroup v) => v.memberCount;
  static const Field<FCGroup, int> _f$memberCount = Field(
    'memberCount',
    _$memberCount,
    opt: true,
    def: 0,
  );
  static bool _$automatic(FCGroup v) => v.automatic;
  static const Field<FCGroup, bool> _f$automatic = Field(
    'automatic',
    _$automatic,
    opt: true,
    def: false,
  );
  static bool _$visible(FCGroup v) => v.visible;
  static const Field<FCGroup, bool> _f$visible = Field(
    'visible',
    _$visible,
    opt: true,
    def: true,
  );
  static bool _$publicAdmission(FCGroup v) => v.publicAdmission;
  static const Field<FCGroup, bool> _f$publicAdmission = Field(
    'publicAdmission',
    _$publicAdmission,
    opt: true,
    def: false,
  );
  static bool _$publicExit(FCGroup v) => v.publicExit;
  static const Field<FCGroup, bool> _f$publicExit = Field(
    'publicExit',
    _$publicExit,
    opt: true,
    def: false,
  );
  static bool _$allowMembershipRequests(FCGroup v) => v.allowMembershipRequests;
  static const Field<FCGroup, bool> _f$allowMembershipRequests = Field(
    'allowMembershipRequests',
    _$allowMembershipRequests,
    opt: true,
    def: false,
  );
  static bool _$isMember(FCGroup v) => v.isMember;
  static const Field<FCGroup, bool> _f$isMember = Field(
    'isMember',
    _$isMember,
    opt: true,
    def: false,
  );
  static bool _$isOwner(FCGroup v) => v.isOwner;
  static const Field<FCGroup, bool> _f$isOwner = Field(
    'isOwner',
    _$isOwner,
    opt: true,
    def: false,
  );
  static int? _$mentionableLevel(FCGroup v) => v.mentionableLevel;
  static const Field<FCGroup, int> _f$mentionableLevel = Field(
    'mentionableLevel',
    _$mentionableLevel,
    opt: true,
  );
  static int? _$messageableLevel(FCGroup v) => v.messageableLevel;
  static const Field<FCGroup, int> _f$messageableLevel = Field(
    'messageableLevel',
    _$messageableLevel,
    opt: true,
  );
  static String? _$flairColor(FCGroup v) => v.flairColor;
  static const Field<FCGroup, String> _f$flairColor = Field(
    'flairColor',
    _$flairColor,
    opt: true,
  );
  static String? _$flairBgColor(FCGroup v) => v.flairBgColor;
  static const Field<FCGroup, String> _f$flairBgColor = Field(
    'flairBgColor',
    _$flairBgColor,
    opt: true,
  );
  static String? _$flairUrl(FCGroup v) => v.flairUrl;
  static const Field<FCGroup, String> _f$flairUrl = Field(
    'flairUrl',
    _$flairUrl,
    opt: true,
  );

  @override
  final MappableFields<FCGroup> fields = const {
    #id: _f$id,
    #name: _f$name,
    #fullName: _f$fullName,
    #bio: _f$bio,
    #memberCount: _f$memberCount,
    #automatic: _f$automatic,
    #visible: _f$visible,
    #publicAdmission: _f$publicAdmission,
    #publicExit: _f$publicExit,
    #allowMembershipRequests: _f$allowMembershipRequests,
    #isMember: _f$isMember,
    #isOwner: _f$isOwner,
    #mentionableLevel: _f$mentionableLevel,
    #messageableLevel: _f$messageableLevel,
    #flairColor: _f$flairColor,
    #flairBgColor: _f$flairBgColor,
    #flairUrl: _f$flairUrl,
  };

  static FCGroup _instantiate(DecodingData data) {
    return FCGroup(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      fullName: data.dec(_f$fullName),
      bio: data.dec(_f$bio),
      memberCount: data.dec(_f$memberCount),
      automatic: data.dec(_f$automatic),
      visible: data.dec(_f$visible),
      publicAdmission: data.dec(_f$publicAdmission),
      publicExit: data.dec(_f$publicExit),
      allowMembershipRequests: data.dec(_f$allowMembershipRequests),
      isMember: data.dec(_f$isMember),
      isOwner: data.dec(_f$isOwner),
      mentionableLevel: data.dec(_f$mentionableLevel),
      messageableLevel: data.dec(_f$messageableLevel),
      flairColor: data.dec(_f$flairColor),
      flairBgColor: data.dec(_f$flairBgColor),
      flairUrl: data.dec(_f$flairUrl),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCGroup fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCGroup>(map);
  }

  static FCGroup fromJson(String json) {
    return ensureInitialized().decodeJson<FCGroup>(json);
  }
}

mixin FCGroupMappable {
  String toJson() {
    return FCGroupMapper.ensureInitialized().encodeJson<FCGroup>(
      this as FCGroup,
    );
  }

  Map<String, dynamic> toMap() {
    return FCGroupMapper.ensureInitialized().encodeMap<FCGroup>(
      this as FCGroup,
    );
  }

  FCGroupCopyWith<FCGroup, FCGroup, FCGroup> get copyWith =>
      _FCGroupCopyWithImpl<FCGroup, FCGroup>(
        this as FCGroup,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FCGroupMapper.ensureInitialized().stringifyValue(this as FCGroup);
  }

  @override
  bool operator ==(Object other) {
    return FCGroupMapper.ensureInitialized().equalsValue(
      this as FCGroup,
      other,
    );
  }

  @override
  int get hashCode {
    return FCGroupMapper.ensureInitialized().hashValue(this as FCGroup);
  }
}

extension FCGroupValueCopy<$R, $Out> on ObjectCopyWith<$R, FCGroup, $Out> {
  FCGroupCopyWith<$R, FCGroup, $Out> get $asFCGroup =>
      $base.as((v, t, t2) => _FCGroupCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCGroupCopyWith<$R, $In extends FCGroup, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? id,
    String? name,
    String? fullName,
    String? bio,
    int? memberCount,
    bool? automatic,
    bool? visible,
    bool? publicAdmission,
    bool? publicExit,
    bool? allowMembershipRequests,
    bool? isMember,
    bool? isOwner,
    int? mentionableLevel,
    int? messageableLevel,
    String? flairColor,
    String? flairBgColor,
    String? flairUrl,
  });
  FCGroupCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FCGroupCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCGroup, $Out>
    implements FCGroupCopyWith<$R, FCGroup, $Out> {
  _FCGroupCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCGroup> $mapper =
      FCGroupMapper.ensureInitialized();
  @override
  $R call({
    int? id,
    String? name,
    Object? fullName = $none,
    Object? bio = $none,
    int? memberCount,
    bool? automatic,
    bool? visible,
    bool? publicAdmission,
    bool? publicExit,
    bool? allowMembershipRequests,
    bool? isMember,
    bool? isOwner,
    Object? mentionableLevel = $none,
    Object? messageableLevel = $none,
    Object? flairColor = $none,
    Object? flairBgColor = $none,
    Object? flairUrl = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (fullName != $none) #fullName: fullName,
      if (bio != $none) #bio: bio,
      if (memberCount != null) #memberCount: memberCount,
      if (automatic != null) #automatic: automatic,
      if (visible != null) #visible: visible,
      if (publicAdmission != null) #publicAdmission: publicAdmission,
      if (publicExit != null) #publicExit: publicExit,
      if (allowMembershipRequests != null)
        #allowMembershipRequests: allowMembershipRequests,
      if (isMember != null) #isMember: isMember,
      if (isOwner != null) #isOwner: isOwner,
      if (mentionableLevel != $none) #mentionableLevel: mentionableLevel,
      if (messageableLevel != $none) #messageableLevel: messageableLevel,
      if (flairColor != $none) #flairColor: flairColor,
      if (flairBgColor != $none) #flairBgColor: flairBgColor,
      if (flairUrl != $none) #flairUrl: flairUrl,
    }),
  );
  @override
  FCGroup $make(CopyWithData data) => FCGroup(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    fullName: data.get(#fullName, or: $value.fullName),
    bio: data.get(#bio, or: $value.bio),
    memberCount: data.get(#memberCount, or: $value.memberCount),
    automatic: data.get(#automatic, or: $value.automatic),
    visible: data.get(#visible, or: $value.visible),
    publicAdmission: data.get(#publicAdmission, or: $value.publicAdmission),
    publicExit: data.get(#publicExit, or: $value.publicExit),
    allowMembershipRequests: data.get(
      #allowMembershipRequests,
      or: $value.allowMembershipRequests,
    ),
    isMember: data.get(#isMember, or: $value.isMember),
    isOwner: data.get(#isOwner, or: $value.isOwner),
    mentionableLevel: data.get(#mentionableLevel, or: $value.mentionableLevel),
    messageableLevel: data.get(#messageableLevel, or: $value.messageableLevel),
    flairColor: data.get(#flairColor, or: $value.flairColor),
    flairBgColor: data.get(#flairBgColor, or: $value.flairBgColor),
    flairUrl: data.get(#flairUrl, or: $value.flairUrl),
  );

  @override
  FCGroupCopyWith<$R2, FCGroup, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FCGroupCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

