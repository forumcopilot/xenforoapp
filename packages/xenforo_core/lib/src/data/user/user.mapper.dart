// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user.dart';

class XenForoUserMapper extends ClassMapperBase<XenForoUser> {
  XenForoUserMapper._();

  static XenForoUserMapper? _instance;
  static XenForoUserMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = XenForoUserMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'XenForoUser';

  static int _$userId(XenForoUser v) => v.userId;
  static const Field<XenForoUser, int> _f$userId = Field('userId', _$userId);
  static String _$username(XenForoUser v) => v.username;
  static const Field<XenForoUser, String> _f$username = Field(
    'username',
    _$username,
  );
  static String? _$email(XenForoUser v) => v.email;
  static const Field<XenForoUser, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static int? _$userGroupId(XenForoUser v) => v.userGroupId;
  static const Field<XenForoUser, int> _f$userGroupId = Field(
    'userGroupId',
    _$userGroupId,
    opt: true,
  );
  static String? _$userTitle(XenForoUser v) => v.userTitle;
  static const Field<XenForoUser, String> _f$userTitle = Field(
    'userTitle',
    _$userTitle,
    opt: true,
  );
  static String? _$customTitle(XenForoUser v) => v.customTitle;
  static const Field<XenForoUser, String> _f$customTitle = Field(
    'customTitle',
    _$customTitle,
    opt: true,
  );
  static String? _$about(XenForoUser v) => v.about;
  static const Field<XenForoUser, String> _f$about = Field(
    'about',
    _$about,
    opt: true,
  );
  static bool? _$activityVisible(XenForoUser v) => v.activityVisible;
  static const Field<XenForoUser, bool> _f$activityVisible = Field(
    'activityVisible',
    _$activityVisible,
    opt: true,
  );
  static int? _$age(XenForoUser v) => v.age;
  static const Field<XenForoUser, int> _f$age = Field('age', _$age, opt: true);
  static List<String>? _$alertOptout(XenForoUser v) => v.alertOptout;
  static const Field<XenForoUser, List<String>> _f$alertOptout = Field(
    'alertOptout',
    _$alertOptout,
    opt: true,
  );
  static String? _$allowPostProfile(XenForoUser v) => v.allowPostProfile;
  static const Field<XenForoUser, String> _f$allowPostProfile = Field(
    'allowPostProfile',
    _$allowPostProfile,
    opt: true,
  );
  static String? _$allowReceiveNewsFeed(XenForoUser v) =>
      v.allowReceiveNewsFeed;
  static const Field<XenForoUser, String> _f$allowReceiveNewsFeed = Field(
    'allowReceiveNewsFeed',
    _$allowReceiveNewsFeed,
    opt: true,
  );
  static String? _$allowSendPersonalConversation(XenForoUser v) =>
      v.allowSendPersonalConversation;
  static const Field<XenForoUser, String> _f$allowSendPersonalConversation =
      Field(
        'allowSendPersonalConversation',
        _$allowSendPersonalConversation,
        opt: true,
      );
  static String? _$allowViewIdentities(XenForoUser v) => v.allowViewIdentities;
  static const Field<XenForoUser, String> _f$allowViewIdentities = Field(
    'allowViewIdentities',
    _$allowViewIdentities,
    opt: true,
  );
  static String? _$allowViewProfile(XenForoUser v) => v.allowViewProfile;
  static const Field<XenForoUser, String> _f$allowViewProfile = Field(
    'allowViewProfile',
    _$allowViewProfile,
    opt: true,
  );
  static Map<String, String>? _$avatarUrls(XenForoUser v) => v.avatarUrls;
  static const Field<XenForoUser, Map<String, String>> _f$avatarUrls = Field(
    'avatarUrls',
    _$avatarUrls,
    opt: true,
  );
  static Map<String, String>? _$profileBannerUrls(XenForoUser v) =>
      v.profileBannerUrls;
  static const Field<XenForoUser, Map<String, String>> _f$profileBannerUrls =
      Field('profileBannerUrls', _$profileBannerUrls, opt: true);
  static bool? _$canBan(XenForoUser v) => v.canBan;
  static const Field<XenForoUser, bool> _f$canBan = Field(
    'canBan',
    _$canBan,
    opt: true,
  );
  static bool? _$canConverse(XenForoUser v) => v.canConverse;
  static const Field<XenForoUser, bool> _f$canConverse = Field(
    'canConverse',
    _$canConverse,
    opt: true,
  );
  static bool? _$canEdit(XenForoUser v) => v.canEdit;
  static const Field<XenForoUser, bool> _f$canEdit = Field(
    'canEdit',
    _$canEdit,
    opt: true,
  );
  static bool? _$canFollow(XenForoUser v) => v.canFollow;
  static const Field<XenForoUser, bool> _f$canFollow = Field(
    'canFollow',
    _$canFollow,
    opt: true,
  );
  static bool? _$canIgnore(XenForoUser v) => v.canIgnore;
  static const Field<XenForoUser, bool> _f$canIgnore = Field(
    'canIgnore',
    _$canIgnore,
    opt: true,
  );
  static bool? _$canPostProfile(XenForoUser v) => v.canPostProfile;
  static const Field<XenForoUser, bool> _f$canPostProfile = Field(
    'canPostProfile',
    _$canPostProfile,
    opt: true,
  );
  static bool? _$canViewProfile(XenForoUser v) => v.canViewProfile;
  static const Field<XenForoUser, bool> _f$canViewProfile = Field(
    'canViewProfile',
    _$canViewProfile,
    opt: true,
  );
  static bool? _$canViewProfilePosts(XenForoUser v) => v.canViewProfilePosts;
  static const Field<XenForoUser, bool> _f$canViewProfilePosts = Field(
    'canViewProfilePosts',
    _$canViewProfilePosts,
    opt: true,
  );
  static bool? _$canWarn(XenForoUser v) => v.canWarn;
  static const Field<XenForoUser, bool> _f$canWarn = Field(
    'canWarn',
    _$canWarn,
    opt: true,
  );
  static bool? _$contentShowSignature(XenForoUser v) => v.contentShowSignature;
  static const Field<XenForoUser, bool> _f$contentShowSignature = Field(
    'contentShowSignature',
    _$contentShowSignature,
    opt: true,
  );
  static String? _$creationWatchState(XenForoUser v) => v.creationWatchState;
  static const Field<XenForoUser, String> _f$creationWatchState = Field(
    'creationWatchState',
    _$creationWatchState,
    opt: true,
  );
  static Map<String, dynamic>? _$customFields(XenForoUser v) => v.customFields;
  static const Field<XenForoUser, Map<String, dynamic>> _f$customFields = Field(
    'customFields',
    _$customFields,
    opt: true,
  );
  static Map<String, dynamic>? _$dob(XenForoUser v) => v.dob;
  static const Field<XenForoUser, Map<String, dynamic>> _f$dob = Field(
    'dob',
    _$dob,
    opt: true,
  );
  static bool? _$emailOnConversation(XenForoUser v) => v.emailOnConversation;
  static const Field<XenForoUser, bool> _f$emailOnConversation = Field(
    'emailOnConversation',
    _$emailOnConversation,
    opt: true,
  );
  static String? _$gravatar(XenForoUser v) => v.gravatar;
  static const Field<XenForoUser, String> _f$gravatar = Field(
    'gravatar',
    _$gravatar,
    opt: true,
  );
  static bool? _$interactionWatchState(XenForoUser v) =>
      v.interactionWatchState;
  static const Field<XenForoUser, bool> _f$interactionWatchState = Field(
    'interactionWatchState',
    _$interactionWatchState,
    opt: true,
  );
  static bool? _$isAdmin(XenForoUser v) => v.isAdmin;
  static const Field<XenForoUser, bool> _f$isAdmin = Field(
    'isAdmin',
    _$isAdmin,
    opt: true,
  );
  static bool? _$isBanned(XenForoUser v) => v.isBanned;
  static const Field<XenForoUser, bool> _f$isBanned = Field(
    'isBanned',
    _$isBanned,
    opt: true,
  );
  static bool? _$isDiscouraged(XenForoUser v) => v.isDiscouraged;
  static const Field<XenForoUser, bool> _f$isDiscouraged = Field(
    'isDiscouraged',
    _$isDiscouraged,
    opt: true,
  );
  static bool? _$isFollowed(XenForoUser v) => v.isFollowed;
  static const Field<XenForoUser, bool> _f$isFollowed = Field(
    'isFollowed',
    _$isFollowed,
    opt: true,
  );
  static bool? _$isIgnored(XenForoUser v) => v.isIgnored;
  static const Field<XenForoUser, bool> _f$isIgnored = Field(
    'isIgnored',
    _$isIgnored,
    opt: true,
  );
  static bool? _$isModerator(XenForoUser v) => v.isModerator;
  static const Field<XenForoUser, bool> _f$isModerator = Field(
    'isModerator',
    _$isModerator,
    opt: true,
  );
  static bool? _$isSuperAdmin(XenForoUser v) => v.isSuperAdmin;
  static const Field<XenForoUser, bool> _f$isSuperAdmin = Field(
    'isSuperAdmin',
    _$isSuperAdmin,
    opt: true,
  );
  static int? _$lastActivity(XenForoUser v) => v.lastActivity;
  static const Field<XenForoUser, int> _f$lastActivity = Field(
    'lastActivity',
    _$lastActivity,
    opt: true,
  );
  static String? _$location(XenForoUser v) => v.location;
  static const Field<XenForoUser, String> _f$location = Field(
    'location',
    _$location,
    opt: true,
  );
  static bool? _$pushOnConversation(XenForoUser v) => v.pushOnConversation;
  static const Field<XenForoUser, bool> _f$pushOnConversation = Field(
    'pushOnConversation',
    _$pushOnConversation,
    opt: true,
  );
  static List<String>? _$pushOptout(XenForoUser v) => v.pushOptout;
  static const Field<XenForoUser, List<String>> _f$pushOptout = Field(
    'pushOptout',
    _$pushOptout,
    opt: true,
  );
  static bool? _$receiveAdminEmail(XenForoUser v) => v.receiveAdminEmail;
  static const Field<XenForoUser, bool> _f$receiveAdminEmail = Field(
    'receiveAdminEmail',
    _$receiveAdminEmail,
    opt: true,
  );
  static List<int>? _$secondaryGroupIds(XenForoUser v) => v.secondaryGroupIds;
  static const Field<XenForoUser, List<int>> _f$secondaryGroupIds = Field(
    'secondaryGroupIds',
    _$secondaryGroupIds,
    opt: true,
  );
  static bool? _$showDobDate(XenForoUser v) => v.showDobDate;
  static const Field<XenForoUser, bool> _f$showDobDate = Field(
    'showDobDate',
    _$showDobDate,
    opt: true,
  );
  static bool? _$showDobYear(XenForoUser v) => v.showDobYear;
  static const Field<XenForoUser, bool> _f$showDobYear = Field(
    'showDobYear',
    _$showDobYear,
    opt: true,
  );
  static String? _$signature(XenForoUser v) => v.signature;
  static const Field<XenForoUser, String> _f$signature = Field(
    'signature',
    _$signature,
    opt: true,
  );
  static String? _$timezone(XenForoUser v) => v.timezone;
  static const Field<XenForoUser, String> _f$timezone = Field(
    'timezone',
    _$timezone,
    opt: true,
  );
  static bool? _$useTfa(XenForoUser v) => v.useTfa;
  static const Field<XenForoUser, bool> _f$useTfa = Field(
    'useTfa',
    _$useTfa,
    opt: true,
  );
  static String? _$userState(XenForoUser v) => v.userState;
  static const Field<XenForoUser, String> _f$userState = Field(
    'userState',
    _$userState,
    opt: true,
  );
  static bool? _$visible(XenForoUser v) => v.visible;
  static const Field<XenForoUser, bool> _f$visible = Field(
    'visible',
    _$visible,
    opt: true,
  );
  static int? _$warningPoints(XenForoUser v) => v.warningPoints;
  static const Field<XenForoUser, int> _f$warningPoints = Field(
    'warningPoints',
    _$warningPoints,
    opt: true,
  );
  static String? _$website(XenForoUser v) => v.website;
  static const Field<XenForoUser, String> _f$website = Field(
    'website',
    _$website,
    opt: true,
  );
  static String? _$viewUrl(XenForoUser v) => v.viewUrl;
  static const Field<XenForoUser, String> _f$viewUrl = Field(
    'viewUrl',
    _$viewUrl,
    opt: true,
  );
  static int? _$messageCount(XenForoUser v) => v.messageCount;
  static const Field<XenForoUser, int> _f$messageCount = Field(
    'messageCount',
    _$messageCount,
    opt: true,
  );
  static int? _$questionSolutionCount(XenForoUser v) => v.questionSolutionCount;
  static const Field<XenForoUser, int> _f$questionSolutionCount = Field(
    'questionSolutionCount',
    _$questionSolutionCount,
    opt: true,
  );
  static int? _$registerDate(XenForoUser v) => v.registerDate;
  static const Field<XenForoUser, int> _f$registerDate = Field(
    'registerDate',
    _$registerDate,
    opt: true,
  );
  static int? _$trophyPoints(XenForoUser v) => v.trophyPoints;
  static const Field<XenForoUser, int> _f$trophyPoints = Field(
    'trophyPoints',
    _$trophyPoints,
    opt: true,
  );
  static bool? _$isStaff(XenForoUser v) => v.isStaff;
  static const Field<XenForoUser, bool> _f$isStaff = Field(
    'isStaff',
    _$isStaff,
    opt: true,
  );
  static int? _$reactionScore(XenForoUser v) => v.reactionScore;
  static const Field<XenForoUser, int> _f$reactionScore = Field(
    'reactionScore',
    _$reactionScore,
    opt: true,
  );
  static int? _$voteScore(XenForoUser v) => v.voteScore;
  static const Field<XenForoUser, int> _f$voteScore = Field(
    'voteScore',
    _$voteScore,
    opt: true,
  );

  @override
  final MappableFields<XenForoUser> fields = const {
    #userId: _f$userId,
    #username: _f$username,
    #email: _f$email,
    #userGroupId: _f$userGroupId,
    #userTitle: _f$userTitle,
    #customTitle: _f$customTitle,
    #about: _f$about,
    #activityVisible: _f$activityVisible,
    #age: _f$age,
    #alertOptout: _f$alertOptout,
    #allowPostProfile: _f$allowPostProfile,
    #allowReceiveNewsFeed: _f$allowReceiveNewsFeed,
    #allowSendPersonalConversation: _f$allowSendPersonalConversation,
    #allowViewIdentities: _f$allowViewIdentities,
    #allowViewProfile: _f$allowViewProfile,
    #avatarUrls: _f$avatarUrls,
    #profileBannerUrls: _f$profileBannerUrls,
    #canBan: _f$canBan,
    #canConverse: _f$canConverse,
    #canEdit: _f$canEdit,
    #canFollow: _f$canFollow,
    #canIgnore: _f$canIgnore,
    #canPostProfile: _f$canPostProfile,
    #canViewProfile: _f$canViewProfile,
    #canViewProfilePosts: _f$canViewProfilePosts,
    #canWarn: _f$canWarn,
    #contentShowSignature: _f$contentShowSignature,
    #creationWatchState: _f$creationWatchState,
    #customFields: _f$customFields,
    #dob: _f$dob,
    #emailOnConversation: _f$emailOnConversation,
    #gravatar: _f$gravatar,
    #interactionWatchState: _f$interactionWatchState,
    #isAdmin: _f$isAdmin,
    #isBanned: _f$isBanned,
    #isDiscouraged: _f$isDiscouraged,
    #isFollowed: _f$isFollowed,
    #isIgnored: _f$isIgnored,
    #isModerator: _f$isModerator,
    #isSuperAdmin: _f$isSuperAdmin,
    #lastActivity: _f$lastActivity,
    #location: _f$location,
    #pushOnConversation: _f$pushOnConversation,
    #pushOptout: _f$pushOptout,
    #receiveAdminEmail: _f$receiveAdminEmail,
    #secondaryGroupIds: _f$secondaryGroupIds,
    #showDobDate: _f$showDobDate,
    #showDobYear: _f$showDobYear,
    #signature: _f$signature,
    #timezone: _f$timezone,
    #useTfa: _f$useTfa,
    #userState: _f$userState,
    #visible: _f$visible,
    #warningPoints: _f$warningPoints,
    #website: _f$website,
    #viewUrl: _f$viewUrl,
    #messageCount: _f$messageCount,
    #questionSolutionCount: _f$questionSolutionCount,
    #registerDate: _f$registerDate,
    #trophyPoints: _f$trophyPoints,
    #isStaff: _f$isStaff,
    #reactionScore: _f$reactionScore,
    #voteScore: _f$voteScore,
  };

  static XenForoUser _instantiate(DecodingData data) {
    return XenForoUser(
      userId: data.dec(_f$userId),
      username: data.dec(_f$username),
      email: data.dec(_f$email),
      userGroupId: data.dec(_f$userGroupId),
      userTitle: data.dec(_f$userTitle),
      customTitle: data.dec(_f$customTitle),
      about: data.dec(_f$about),
      activityVisible: data.dec(_f$activityVisible),
      age: data.dec(_f$age),
      alertOptout: data.dec(_f$alertOptout),
      allowPostProfile: data.dec(_f$allowPostProfile),
      allowReceiveNewsFeed: data.dec(_f$allowReceiveNewsFeed),
      allowSendPersonalConversation: data.dec(_f$allowSendPersonalConversation),
      allowViewIdentities: data.dec(_f$allowViewIdentities),
      allowViewProfile: data.dec(_f$allowViewProfile),
      avatarUrls: data.dec(_f$avatarUrls),
      profileBannerUrls: data.dec(_f$profileBannerUrls),
      canBan: data.dec(_f$canBan),
      canConverse: data.dec(_f$canConverse),
      canEdit: data.dec(_f$canEdit),
      canFollow: data.dec(_f$canFollow),
      canIgnore: data.dec(_f$canIgnore),
      canPostProfile: data.dec(_f$canPostProfile),
      canViewProfile: data.dec(_f$canViewProfile),
      canViewProfilePosts: data.dec(_f$canViewProfilePosts),
      canWarn: data.dec(_f$canWarn),
      contentShowSignature: data.dec(_f$contentShowSignature),
      creationWatchState: data.dec(_f$creationWatchState),
      customFields: data.dec(_f$customFields),
      dob: data.dec(_f$dob),
      emailOnConversation: data.dec(_f$emailOnConversation),
      gravatar: data.dec(_f$gravatar),
      interactionWatchState: data.dec(_f$interactionWatchState),
      isAdmin: data.dec(_f$isAdmin),
      isBanned: data.dec(_f$isBanned),
      isDiscouraged: data.dec(_f$isDiscouraged),
      isFollowed: data.dec(_f$isFollowed),
      isIgnored: data.dec(_f$isIgnored),
      isModerator: data.dec(_f$isModerator),
      isSuperAdmin: data.dec(_f$isSuperAdmin),
      lastActivity: data.dec(_f$lastActivity),
      location: data.dec(_f$location),
      pushOnConversation: data.dec(_f$pushOnConversation),
      pushOptout: data.dec(_f$pushOptout),
      receiveAdminEmail: data.dec(_f$receiveAdminEmail),
      secondaryGroupIds: data.dec(_f$secondaryGroupIds),
      showDobDate: data.dec(_f$showDobDate),
      showDobYear: data.dec(_f$showDobYear),
      signature: data.dec(_f$signature),
      timezone: data.dec(_f$timezone),
      useTfa: data.dec(_f$useTfa),
      userState: data.dec(_f$userState),
      visible: data.dec(_f$visible),
      warningPoints: data.dec(_f$warningPoints),
      website: data.dec(_f$website),
      viewUrl: data.dec(_f$viewUrl),
      messageCount: data.dec(_f$messageCount),
      questionSolutionCount: data.dec(_f$questionSolutionCount),
      registerDate: data.dec(_f$registerDate),
      trophyPoints: data.dec(_f$trophyPoints),
      isStaff: data.dec(_f$isStaff),
      reactionScore: data.dec(_f$reactionScore),
      voteScore: data.dec(_f$voteScore),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static XenForoUser fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<XenForoUser>(map);
  }

  static XenForoUser fromJson(String json) {
    return ensureInitialized().decodeJson<XenForoUser>(json);
  }
}

mixin XenForoUserMappable {
  String toJson() {
    return XenForoUserMapper.ensureInitialized().encodeJson<XenForoUser>(
      this as XenForoUser,
    );
  }

  Map<String, dynamic> toMap() {
    return XenForoUserMapper.ensureInitialized().encodeMap<XenForoUser>(
      this as XenForoUser,
    );
  }

  XenForoUserCopyWith<XenForoUser, XenForoUser, XenForoUser> get copyWith =>
      _XenForoUserCopyWithImpl<XenForoUser, XenForoUser>(
        this as XenForoUser,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return XenForoUserMapper.ensureInitialized().stringifyValue(
      this as XenForoUser,
    );
  }

  @override
  bool operator ==(Object other) {
    return XenForoUserMapper.ensureInitialized().equalsValue(
      this as XenForoUser,
      other,
    );
  }

  @override
  int get hashCode {
    return XenForoUserMapper.ensureInitialized().hashValue(this as XenForoUser);
  }
}

extension XenForoUserValueCopy<$R, $Out>
    on ObjectCopyWith<$R, XenForoUser, $Out> {
  XenForoUserCopyWith<$R, XenForoUser, $Out> get $asXenForoUser =>
      $base.as((v, t, t2) => _XenForoUserCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class XenForoUserCopyWith<$R, $In extends XenForoUser, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get alertOptout;
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>?
  get avatarUrls;
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>?
  get profileBannerUrls;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get customFields;
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get dob;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get pushOptout;
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>>? get secondaryGroupIds;
  $R call({
    int? userId,
    String? username,
    String? email,
    int? userGroupId,
    String? userTitle,
    String? customTitle,
    String? about,
    bool? activityVisible,
    int? age,
    List<String>? alertOptout,
    String? allowPostProfile,
    String? allowReceiveNewsFeed,
    String? allowSendPersonalConversation,
    String? allowViewIdentities,
    String? allowViewProfile,
    Map<String, String>? avatarUrls,
    Map<String, String>? profileBannerUrls,
    bool? canBan,
    bool? canConverse,
    bool? canEdit,
    bool? canFollow,
    bool? canIgnore,
    bool? canPostProfile,
    bool? canViewProfile,
    bool? canViewProfilePosts,
    bool? canWarn,
    bool? contentShowSignature,
    String? creationWatchState,
    Map<String, dynamic>? customFields,
    Map<String, dynamic>? dob,
    bool? emailOnConversation,
    String? gravatar,
    bool? interactionWatchState,
    bool? isAdmin,
    bool? isBanned,
    bool? isDiscouraged,
    bool? isFollowed,
    bool? isIgnored,
    bool? isModerator,
    bool? isSuperAdmin,
    int? lastActivity,
    String? location,
    bool? pushOnConversation,
    List<String>? pushOptout,
    bool? receiveAdminEmail,
    List<int>? secondaryGroupIds,
    bool? showDobDate,
    bool? showDobYear,
    String? signature,
    String? timezone,
    bool? useTfa,
    String? userState,
    bool? visible,
    int? warningPoints,
    String? website,
    String? viewUrl,
    int? messageCount,
    int? questionSolutionCount,
    int? registerDate,
    int? trophyPoints,
    bool? isStaff,
    int? reactionScore,
    int? voteScore,
  });
  XenForoUserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _XenForoUserCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, XenForoUser, $Out>
    implements XenForoUserCopyWith<$R, XenForoUser, $Out> {
  _XenForoUserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<XenForoUser> $mapper =
      XenForoUserMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get alertOptout => $value.alertOptout != null
      ? ListCopyWith(
          $value.alertOptout!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(alertOptout: v),
        )
      : null;
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>?
  get avatarUrls => $value.avatarUrls != null
      ? MapCopyWith(
          $value.avatarUrls!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(avatarUrls: v),
        )
      : null;
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>?
  get profileBannerUrls => $value.profileBannerUrls != null
      ? MapCopyWith(
          $value.profileBannerUrls!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(profileBannerUrls: v),
        )
      : null;
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get customFields => $value.customFields != null
      ? MapCopyWith(
          $value.customFields!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(customFields: v),
        )
      : null;
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>>?
  get dob => $value.dob != null
      ? MapCopyWith(
          $value.dob!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(dob: v),
        )
      : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get pushOptout => $value.pushOptout != null
      ? ListCopyWith(
          $value.pushOptout!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(pushOptout: v),
        )
      : null;
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>>? get secondaryGroupIds =>
      $value.secondaryGroupIds != null
      ? ListCopyWith(
          $value.secondaryGroupIds!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(secondaryGroupIds: v),
        )
      : null;
  @override
  $R call({
    int? userId,
    String? username,
    Object? email = $none,
    Object? userGroupId = $none,
    Object? userTitle = $none,
    Object? customTitle = $none,
    Object? about = $none,
    Object? activityVisible = $none,
    Object? age = $none,
    Object? alertOptout = $none,
    Object? allowPostProfile = $none,
    Object? allowReceiveNewsFeed = $none,
    Object? allowSendPersonalConversation = $none,
    Object? allowViewIdentities = $none,
    Object? allowViewProfile = $none,
    Object? avatarUrls = $none,
    Object? profileBannerUrls = $none,
    Object? canBan = $none,
    Object? canConverse = $none,
    Object? canEdit = $none,
    Object? canFollow = $none,
    Object? canIgnore = $none,
    Object? canPostProfile = $none,
    Object? canViewProfile = $none,
    Object? canViewProfilePosts = $none,
    Object? canWarn = $none,
    Object? contentShowSignature = $none,
    Object? creationWatchState = $none,
    Object? customFields = $none,
    Object? dob = $none,
    Object? emailOnConversation = $none,
    Object? gravatar = $none,
    Object? interactionWatchState = $none,
    Object? isAdmin = $none,
    Object? isBanned = $none,
    Object? isDiscouraged = $none,
    Object? isFollowed = $none,
    Object? isIgnored = $none,
    Object? isModerator = $none,
    Object? isSuperAdmin = $none,
    Object? lastActivity = $none,
    Object? location = $none,
    Object? pushOnConversation = $none,
    Object? pushOptout = $none,
    Object? receiveAdminEmail = $none,
    Object? secondaryGroupIds = $none,
    Object? showDobDate = $none,
    Object? showDobYear = $none,
    Object? signature = $none,
    Object? timezone = $none,
    Object? useTfa = $none,
    Object? userState = $none,
    Object? visible = $none,
    Object? warningPoints = $none,
    Object? website = $none,
    Object? viewUrl = $none,
    Object? messageCount = $none,
    Object? questionSolutionCount = $none,
    Object? registerDate = $none,
    Object? trophyPoints = $none,
    Object? isStaff = $none,
    Object? reactionScore = $none,
    Object? voteScore = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (username != null) #username: username,
      if (email != $none) #email: email,
      if (userGroupId != $none) #userGroupId: userGroupId,
      if (userTitle != $none) #userTitle: userTitle,
      if (customTitle != $none) #customTitle: customTitle,
      if (about != $none) #about: about,
      if (activityVisible != $none) #activityVisible: activityVisible,
      if (age != $none) #age: age,
      if (alertOptout != $none) #alertOptout: alertOptout,
      if (allowPostProfile != $none) #allowPostProfile: allowPostProfile,
      if (allowReceiveNewsFeed != $none)
        #allowReceiveNewsFeed: allowReceiveNewsFeed,
      if (allowSendPersonalConversation != $none)
        #allowSendPersonalConversation: allowSendPersonalConversation,
      if (allowViewIdentities != $none)
        #allowViewIdentities: allowViewIdentities,
      if (allowViewProfile != $none) #allowViewProfile: allowViewProfile,
      if (avatarUrls != $none) #avatarUrls: avatarUrls,
      if (profileBannerUrls != $none) #profileBannerUrls: profileBannerUrls,
      if (canBan != $none) #canBan: canBan,
      if (canConverse != $none) #canConverse: canConverse,
      if (canEdit != $none) #canEdit: canEdit,
      if (canFollow != $none) #canFollow: canFollow,
      if (canIgnore != $none) #canIgnore: canIgnore,
      if (canPostProfile != $none) #canPostProfile: canPostProfile,
      if (canViewProfile != $none) #canViewProfile: canViewProfile,
      if (canViewProfilePosts != $none)
        #canViewProfilePosts: canViewProfilePosts,
      if (canWarn != $none) #canWarn: canWarn,
      if (contentShowSignature != $none)
        #contentShowSignature: contentShowSignature,
      if (creationWatchState != $none) #creationWatchState: creationWatchState,
      if (customFields != $none) #customFields: customFields,
      if (dob != $none) #dob: dob,
      if (emailOnConversation != $none)
        #emailOnConversation: emailOnConversation,
      if (gravatar != $none) #gravatar: gravatar,
      if (interactionWatchState != $none)
        #interactionWatchState: interactionWatchState,
      if (isAdmin != $none) #isAdmin: isAdmin,
      if (isBanned != $none) #isBanned: isBanned,
      if (isDiscouraged != $none) #isDiscouraged: isDiscouraged,
      if (isFollowed != $none) #isFollowed: isFollowed,
      if (isIgnored != $none) #isIgnored: isIgnored,
      if (isModerator != $none) #isModerator: isModerator,
      if (isSuperAdmin != $none) #isSuperAdmin: isSuperAdmin,
      if (lastActivity != $none) #lastActivity: lastActivity,
      if (location != $none) #location: location,
      if (pushOnConversation != $none) #pushOnConversation: pushOnConversation,
      if (pushOptout != $none) #pushOptout: pushOptout,
      if (receiveAdminEmail != $none) #receiveAdminEmail: receiveAdminEmail,
      if (secondaryGroupIds != $none) #secondaryGroupIds: secondaryGroupIds,
      if (showDobDate != $none) #showDobDate: showDobDate,
      if (showDobYear != $none) #showDobYear: showDobYear,
      if (signature != $none) #signature: signature,
      if (timezone != $none) #timezone: timezone,
      if (useTfa != $none) #useTfa: useTfa,
      if (userState != $none) #userState: userState,
      if (visible != $none) #visible: visible,
      if (warningPoints != $none) #warningPoints: warningPoints,
      if (website != $none) #website: website,
      if (viewUrl != $none) #viewUrl: viewUrl,
      if (messageCount != $none) #messageCount: messageCount,
      if (questionSolutionCount != $none)
        #questionSolutionCount: questionSolutionCount,
      if (registerDate != $none) #registerDate: registerDate,
      if (trophyPoints != $none) #trophyPoints: trophyPoints,
      if (isStaff != $none) #isStaff: isStaff,
      if (reactionScore != $none) #reactionScore: reactionScore,
      if (voteScore != $none) #voteScore: voteScore,
    }),
  );
  @override
  XenForoUser $make(CopyWithData data) => XenForoUser(
    userId: data.get(#userId, or: $value.userId),
    username: data.get(#username, or: $value.username),
    email: data.get(#email, or: $value.email),
    userGroupId: data.get(#userGroupId, or: $value.userGroupId),
    userTitle: data.get(#userTitle, or: $value.userTitle),
    customTitle: data.get(#customTitle, or: $value.customTitle),
    about: data.get(#about, or: $value.about),
    activityVisible: data.get(#activityVisible, or: $value.activityVisible),
    age: data.get(#age, or: $value.age),
    alertOptout: data.get(#alertOptout, or: $value.alertOptout),
    allowPostProfile: data.get(#allowPostProfile, or: $value.allowPostProfile),
    allowReceiveNewsFeed: data.get(
      #allowReceiveNewsFeed,
      or: $value.allowReceiveNewsFeed,
    ),
    allowSendPersonalConversation: data.get(
      #allowSendPersonalConversation,
      or: $value.allowSendPersonalConversation,
    ),
    allowViewIdentities: data.get(
      #allowViewIdentities,
      or: $value.allowViewIdentities,
    ),
    allowViewProfile: data.get(#allowViewProfile, or: $value.allowViewProfile),
    avatarUrls: data.get(#avatarUrls, or: $value.avatarUrls),
    profileBannerUrls: data.get(
      #profileBannerUrls,
      or: $value.profileBannerUrls,
    ),
    canBan: data.get(#canBan, or: $value.canBan),
    canConverse: data.get(#canConverse, or: $value.canConverse),
    canEdit: data.get(#canEdit, or: $value.canEdit),
    canFollow: data.get(#canFollow, or: $value.canFollow),
    canIgnore: data.get(#canIgnore, or: $value.canIgnore),
    canPostProfile: data.get(#canPostProfile, or: $value.canPostProfile),
    canViewProfile: data.get(#canViewProfile, or: $value.canViewProfile),
    canViewProfilePosts: data.get(
      #canViewProfilePosts,
      or: $value.canViewProfilePosts,
    ),
    canWarn: data.get(#canWarn, or: $value.canWarn),
    contentShowSignature: data.get(
      #contentShowSignature,
      or: $value.contentShowSignature,
    ),
    creationWatchState: data.get(
      #creationWatchState,
      or: $value.creationWatchState,
    ),
    customFields: data.get(#customFields, or: $value.customFields),
    dob: data.get(#dob, or: $value.dob),
    emailOnConversation: data.get(
      #emailOnConversation,
      or: $value.emailOnConversation,
    ),
    gravatar: data.get(#gravatar, or: $value.gravatar),
    interactionWatchState: data.get(
      #interactionWatchState,
      or: $value.interactionWatchState,
    ),
    isAdmin: data.get(#isAdmin, or: $value.isAdmin),
    isBanned: data.get(#isBanned, or: $value.isBanned),
    isDiscouraged: data.get(#isDiscouraged, or: $value.isDiscouraged),
    isFollowed: data.get(#isFollowed, or: $value.isFollowed),
    isIgnored: data.get(#isIgnored, or: $value.isIgnored),
    isModerator: data.get(#isModerator, or: $value.isModerator),
    isSuperAdmin: data.get(#isSuperAdmin, or: $value.isSuperAdmin),
    lastActivity: data.get(#lastActivity, or: $value.lastActivity),
    location: data.get(#location, or: $value.location),
    pushOnConversation: data.get(
      #pushOnConversation,
      or: $value.pushOnConversation,
    ),
    pushOptout: data.get(#pushOptout, or: $value.pushOptout),
    receiveAdminEmail: data.get(
      #receiveAdminEmail,
      or: $value.receiveAdminEmail,
    ),
    secondaryGroupIds: data.get(
      #secondaryGroupIds,
      or: $value.secondaryGroupIds,
    ),
    showDobDate: data.get(#showDobDate, or: $value.showDobDate),
    showDobYear: data.get(#showDobYear, or: $value.showDobYear),
    signature: data.get(#signature, or: $value.signature),
    timezone: data.get(#timezone, or: $value.timezone),
    useTfa: data.get(#useTfa, or: $value.useTfa),
    userState: data.get(#userState, or: $value.userState),
    visible: data.get(#visible, or: $value.visible),
    warningPoints: data.get(#warningPoints, or: $value.warningPoints),
    website: data.get(#website, or: $value.website),
    viewUrl: data.get(#viewUrl, or: $value.viewUrl),
    messageCount: data.get(#messageCount, or: $value.messageCount),
    questionSolutionCount: data.get(
      #questionSolutionCount,
      or: $value.questionSolutionCount,
    ),
    registerDate: data.get(#registerDate, or: $value.registerDate),
    trophyPoints: data.get(#trophyPoints, or: $value.trophyPoints),
    isStaff: data.get(#isStaff, or: $value.isStaff),
    reactionScore: data.get(#reactionScore, or: $value.reactionScore),
    voteScore: data.get(#voteScore, or: $value.voteScore),
  );

  @override
  XenForoUserCopyWith<$R2, XenForoUser, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _XenForoUserCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

