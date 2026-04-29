// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fc_config_result.dart';

class FCConfigResultMapper extends ClassMapperBase<FCConfigResult> {
  FCConfigResultMapper._();

  static FCConfigResultMapper? _instance;
  static FCConfigResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FCConfigResultMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FCConfigResult';

  static bool _$jsonSupport(FCConfigResult v) => v.jsonSupport;
  static const Field<FCConfigResult, bool> _f$jsonSupport = Field(
    'jsonSupport',
    _$jsonSupport,
    opt: true,
    def: false,
  );
  static String _$systemVersion(FCConfigResult v) => v.systemVersion;
  static const Field<FCConfigResult, String> _f$systemVersion = Field(
    'systemVersion',
    _$systemVersion,
    opt: true,
    def: "",
  );
  static String _$version(FCConfigResult v) => v.version;
  static const Field<FCConfigResult, String> _f$version = Field(
    'version',
    _$version,
    opt: true,
    def: "",
  );
  static String _$hookVersion(FCConfigResult v) => v.hookVersion;
  static const Field<FCConfigResult, String> _f$hookVersion = Field(
    'hookVersion',
    _$hookVersion,
    opt: true,
    def: "",
  );
  static String _$apiLevel(FCConfigResult v) => v.apiLevel;
  static const Field<FCConfigResult, String> _f$apiLevel = Field(
    'apiLevel',
    _$apiLevel,
    opt: true,
    def: "",
  );
  static String _$releaseTimestamp(FCConfigResult v) => v.releaseTimestamp;
  static const Field<FCConfigResult, String> _f$releaseTimestamp = Field(
    'releaseTimestamp',
    _$releaseTimestamp,
    opt: true,
    def: "",
  );
  static String _$pushSlug(FCConfigResult v) => v.pushSlug;
  static const Field<FCConfigResult, String> _f$pushSlug = Field(
    'pushSlug',
    _$pushSlug,
    opt: true,
    def: "",
  );
  static String _$smartBannerInfo(FCConfigResult v) => v.smartBannerInfo;
  static const Field<FCConfigResult, String> _f$smartBannerInfo = Field(
    'smartBannerInfo',
    _$smartBannerInfo,
    opt: true,
    def: "",
  );
  static bool _$setForumInfo(FCConfigResult v) => v.setForumInfo;
  static const Field<FCConfigResult, bool> _f$setForumInfo = Field(
    'setForumInfo',
    _$setForumInfo,
    opt: true,
    def: false,
  );
  static bool _$isOpen(FCConfigResult v) => v.isOpen;
  static const Field<FCConfigResult, bool> _f$isOpen = Field(
    'isOpen',
    _$isOpen,
    opt: true,
    def: false,
  );
  static bool _$guestOkay(FCConfigResult v) => v.guestOkay;
  static const Field<FCConfigResult, bool> _f$guestOkay = Field(
    'guestOkay',
    _$guestOkay,
    opt: true,
    def: false,
  );
  static bool _$reportPost(FCConfigResult v) => v.reportPost;
  static const Field<FCConfigResult, bool> _f$reportPost = Field(
    'reportPost',
    _$reportPost,
    opt: true,
    def: false,
  );
  static bool _$reportPm(FCConfigResult v) => v.reportPm;
  static const Field<FCConfigResult, bool> _f$reportPm = Field(
    'reportPm',
    _$reportPm,
    opt: true,
    def: false,
  );
  static bool _$gotoPost(FCConfigResult v) => v.gotoPost;
  static const Field<FCConfigResult, bool> _f$gotoPost = Field(
    'gotoPost',
    _$gotoPost,
    opt: true,
    def: false,
  );
  static bool _$gotoUnread(FCConfigResult v) => v.gotoUnread;
  static const Field<FCConfigResult, bool> _f$gotoUnread = Field(
    'gotoUnread',
    _$gotoUnread,
    opt: true,
    def: false,
  );
  static bool _$getTopicByIds(FCConfigResult v) => v.getTopicByIds;
  static const Field<FCConfigResult, bool> _f$getTopicByIds = Field(
    'getTopicByIds',
    _$getTopicByIds,
    opt: true,
    def: false,
  );
  static bool _$markRead(FCConfigResult v) => v.markRead;
  static const Field<FCConfigResult, bool> _f$markRead = Field(
    'markRead',
    _$markRead,
    opt: true,
    def: true,
  );
  static bool _$markForum(FCConfigResult v) => v.markForum;
  static const Field<FCConfigResult, bool> _f$markForum = Field(
    'markForum',
    _$markForum,
    opt: true,
    def: false,
  );
  static bool _$subscribeForum(FCConfigResult v) => v.subscribeForum;
  static const Field<FCConfigResult, bool> _f$subscribeForum = Field(
    'subscribeForum',
    _$subscribeForum,
    opt: true,
    def: true,
  );
  static bool _$disableSubscribeForum(FCConfigResult v) =>
      v.disableSubscribeForum;
  static const Field<FCConfigResult, bool> _f$disableSubscribeForum = Field(
    'disableSubscribeForum',
    _$disableSubscribeForum,
    opt: true,
    def: false,
  );
  static bool _$disableSearch(FCConfigResult v) => v.disableSearch;
  static const Field<FCConfigResult, bool> _f$disableSearch = Field(
    'disableSearch',
    _$disableSearch,
    opt: true,
    def: false,
  );
  static bool _$getLatestTopic(FCConfigResult v) => v.getLatestTopic;
  static const Field<FCConfigResult, bool> _f$getLatestTopic = Field(
    'getLatestTopic',
    _$getLatestTopic,
    opt: true,
    def: false,
  );
  static bool _$getNewTopic(FCConfigResult v) => v.getNewTopic;
  static const Field<FCConfigResult, bool> _f$getNewTopic = Field(
    'getNewTopic',
    _$getNewTopic,
    opt: true,
    def: false,
  );
  static bool _$getIdByUrl(FCConfigResult v) => v.getIdByUrl;
  static const Field<FCConfigResult, bool> _f$getIdByUrl = Field(
    'getIdByUrl',
    _$getIdByUrl,
    opt: true,
    def: false,
  );
  static bool _$getUrlById(FCConfigResult v) => v.getUrlById;
  static const Field<FCConfigResult, bool> _f$getUrlById = Field(
    'getUrlById',
    _$getUrlById,
    opt: true,
    def: false,
  );
  static bool _$deleteReason(FCConfigResult v) => v.deleteReason;
  static const Field<FCConfigResult, bool> _f$deleteReason = Field(
    'deleteReason',
    _$deleteReason,
    opt: true,
    def: false,
  );
  static bool _$modApprove(FCConfigResult v) => v.modApprove;
  static const Field<FCConfigResult, bool> _f$modApprove = Field(
    'modApprove',
    _$modApprove,
    opt: true,
    def: false,
  );
  static bool _$modDelete(FCConfigResult v) => v.modDelete;
  static const Field<FCConfigResult, bool> _f$modDelete = Field(
    'modDelete',
    _$modDelete,
    opt: true,
    def: false,
  );
  static bool _$modReport(FCConfigResult v) => v.modReport;
  static const Field<FCConfigResult, bool> _f$modReport = Field(
    'modReport',
    _$modReport,
    opt: true,
    def: false,
  );
  static bool _$guestSearch(FCConfigResult v) => v.guestSearch;
  static const Field<FCConfigResult, bool> _f$guestSearch = Field(
    'guestSearch',
    _$guestSearch,
    opt: true,
    def: false,
  );
  static bool _$anonymous(FCConfigResult v) => v.anonymous;
  static const Field<FCConfigResult, bool> _f$anonymous = Field(
    'anonymous',
    _$anonymous,
    opt: true,
    def: false,
  );
  static bool _$guestWhosOnline(FCConfigResult v) => v.guestWhosOnline;
  static const Field<FCConfigResult, bool> _f$guestWhosOnline = Field(
    'guestWhosOnline',
    _$guestWhosOnline,
    opt: true,
    def: false,
  );
  static bool _$searchId(FCConfigResult v) => v.searchId;
  static const Field<FCConfigResult, bool> _f$searchId = Field(
    'searchId',
    _$searchId,
    opt: true,
    def: false,
  );
  static bool _$avatar(FCConfigResult v) => v.avatar;
  static const Field<FCConfigResult, bool> _f$avatar = Field(
    'avatar',
    _$avatar,
    opt: true,
    def: false,
  );
  static bool _$pmLoad(FCConfigResult v) => v.pmLoad;
  static const Field<FCConfigResult, bool> _f$pmLoad = Field(
    'pmLoad',
    _$pmLoad,
    opt: true,
    def: false,
  );
  static bool _$subscribeLoad(FCConfigResult v) => v.subscribeLoad;
  static const Field<FCConfigResult, bool> _f$subscribeLoad = Field(
    'subscribeLoad',
    _$subscribeLoad,
    opt: true,
    def: false,
  );
  static String _$subscribeTopicMode(FCConfigResult v) => v.subscribeTopicMode;
  static const Field<FCConfigResult, String> _f$subscribeTopicMode = Field(
    'subscribeTopicMode',
    _$subscribeTopicMode,
    opt: true,
    def: "",
  );
  static String _$subscribeForumMode(FCConfigResult v) => v.subscribeForumMode;
  static const Field<FCConfigResult, String> _f$subscribeForumMode = Field(
    'subscribeForumMode',
    _$subscribeForumMode,
    opt: true,
    def: "",
  );
  static int _$minSearchLength(FCConfigResult v) => v.minSearchLength;
  static const Field<FCConfigResult, int> _f$minSearchLength = Field(
    'minSearchLength',
    _$minSearchLength,
    opt: true,
    def: 0,
  );
  static bool _$inboxStat(FCConfigResult v) => v.inboxStat;
  static const Field<FCConfigResult, bool> _f$inboxStat = Field(
    'inboxStat',
    _$inboxStat,
    opt: true,
    def: false,
  );
  static bool _$multiQuote(FCConfigResult v) => v.multiQuote;
  static const Field<FCConfigResult, bool> _f$multiQuote = Field(
    'multiQuote',
    _$multiQuote,
    opt: true,
    def: false,
  );
  static bool _$defaultSmilies(FCConfigResult v) => v.defaultSmilies;
  static const Field<FCConfigResult, bool> _f$defaultSmilies = Field(
    'defaultSmilies',
    _$defaultSmilies,
    opt: true,
    def: true,
  );
  static bool _$canUnread(FCConfigResult v) => v.canUnread;
  static const Field<FCConfigResult, bool> _f$canUnread = Field(
    'canUnread',
    _$canUnread,
    opt: true,
    def: true,
  );
  static bool _$announcement(FCConfigResult v) => v.announcement;
  static const Field<FCConfigResult, bool> _f$announcement = Field(
    'announcement',
    _$announcement,
    opt: true,
    def: true,
  );
  static bool _$emoji(FCConfigResult v) => v.emoji;
  static const Field<FCConfigResult, bool> _f$emoji = Field(
    'emoji',
    _$emoji,
    opt: true,
    def: false,
  );
  static bool _$supportMd5(FCConfigResult v) => v.supportMd5;
  static const Field<FCConfigResult, bool> _f$supportMd5 = Field(
    'supportMd5',
    _$supportMd5,
    opt: true,
    def: false,
  );
  static bool _$supportSha1(FCConfigResult v) => v.supportSha1;
  static const Field<FCConfigResult, bool> _f$supportSha1 = Field(
    'supportSha1',
    _$supportSha1,
    opt: true,
    def: false,
  );
  static String _$passwordType(FCConfigResult v) => v.passwordType;
  static const Field<FCConfigResult, String> _f$passwordType = Field(
    'passwordType',
    _$passwordType,
    opt: true,
    def: "",
  );
  static bool _$conversation(FCConfigResult v) => v.conversation;
  static const Field<FCConfigResult, bool> _f$conversation = Field(
    'conversation',
    _$conversation,
    opt: true,
    def: false,
  );
  static bool _$getForum(FCConfigResult v) => v.getForum;
  static const Field<FCConfigResult, bool> _f$getForum = Field(
    'getForum',
    _$getForum,
    opt: true,
    def: false,
  );
  static bool _$getTopicStatus(FCConfigResult v) => v.getTopicStatus;
  static const Field<FCConfigResult, bool> _f$getTopicStatus = Field(
    'getTopicStatus',
    _$getTopicStatus,
    opt: true,
    def: false,
  );
  static bool _$getParticipatedForum(FCConfigResult v) =>
      v.getParticipatedForum;
  static const Field<FCConfigResult, bool> _f$getParticipatedForum = Field(
    'getParticipatedForum',
    _$getParticipatedForum,
    opt: true,
    def: false,
  );
  static bool _$getForumStatus(FCConfigResult v) => v.getForumStatus;
  static const Field<FCConfigResult, bool> _f$getForumStatus = Field(
    'getForumStatus',
    _$getForumStatus,
    opt: true,
    def: false,
  );
  static bool? _$getSmilies(FCConfigResult v) => v.getSmilies;
  static const Field<FCConfigResult, bool> _f$getSmilies = Field(
    'getSmilies',
    _$getSmilies,
    opt: true,
  );
  static bool? _$advancedHtml(FCConfigResult v) => v.advancedHtml;
  static const Field<FCConfigResult, bool> _f$advancedHtml = Field(
    'advancedHtml',
    _$advancedHtml,
    opt: true,
  );
  static bool? _$idToUrlRedirect(FCConfigResult v) => v.idToUrlRedirect;
  static const Field<FCConfigResult, bool> _f$idToUrlRedirect = Field(
    'idToUrlRedirect',
    _$idToUrlRedirect,
    opt: true,
  );
  static bool? _$updateProfile(FCConfigResult v) => v.updateProfile;
  static const Field<FCConfigResult, bool> _f$updateProfile = Field(
    'updateProfile',
    _$updateProfile,
    opt: true,
  );
  static bool? _$getMemberList(FCConfigResult v) => v.getMemberList;
  static const Field<FCConfigResult, bool> _f$getMemberList = Field(
    'getMemberList',
    _$getMemberList,
    opt: true,
  );
  static bool? _$mGetInactiveUsers(FCConfigResult v) => v.mGetInactiveUsers;
  static const Field<FCConfigResult, bool> _f$mGetInactiveUsers = Field(
    'mGetInactiveUsers',
    _$mGetInactiveUsers,
    opt: true,
  );
  static bool? _$mApproveUser(FCConfigResult v) => v.mApproveUser;
  static const Field<FCConfigResult, bool> _f$mApproveUser = Field(
    'mApproveUser',
    _$mApproveUser,
    opt: true,
  );
  static bool? _$pollOptionsMaxCount(FCConfigResult v) => v.pollOptionsMaxCount;
  static const Field<FCConfigResult, bool> _f$pollOptionsMaxCount = Field(
    'pollOptionsMaxCount',
    _$pollOptionsMaxCount,
    opt: true,
  );
  static bool _$advancedOnlineUsers(FCConfigResult v) => v.advancedOnlineUsers;
  static const Field<FCConfigResult, bool> _f$advancedOnlineUsers = Field(
    'advancedOnlineUsers',
    _$advancedOnlineUsers,
    opt: true,
    def: false,
  );
  static bool _$markPmUnread(FCConfigResult v) => v.markPmUnread;
  static const Field<FCConfigResult, bool> _f$markPmUnread = Field(
    'markPmUnread',
    _$markPmUnread,
    opt: true,
    def: false,
  );
  static bool _$markPmRead(FCConfigResult v) => v.markPmRead;
  static const Field<FCConfigResult, bool> _f$markPmRead = Field(
    'markPmRead',
    _$markPmRead,
    opt: true,
    def: false,
  );
  static bool _$advancedSearch(FCConfigResult v) => v.advancedSearch;
  static const Field<FCConfigResult, bool> _f$advancedSearch = Field(
    'advancedSearch',
    _$advancedSearch,
    opt: true,
    def: false,
  );
  static bool _$massSubscribe(FCConfigResult v) => v.massSubscribe;
  static const Field<FCConfigResult, bool> _f$massSubscribe = Field(
    'massSubscribe',
    _$massSubscribe,
    opt: true,
    def: false,
  );
  static String _$userId(FCConfigResult v) => v.userId;
  static const Field<FCConfigResult, String> _f$userId = Field(
    'userId',
    _$userId,
    opt: true,
    def: "",
  );
  static String _$regUrl(FCConfigResult v) => v.regUrl;
  static const Field<FCConfigResult, String> _f$regUrl = Field(
    'regUrl',
    _$regUrl,
    opt: true,
    def: "",
  );
  static String _$guestGroupId(FCConfigResult v) => v.guestGroupId;
  static const Field<FCConfigResult, String> _f$guestGroupId = Field(
    'guestGroupId',
    _$guestGroupId,
    opt: true,
    def: "",
  );
  static String _$phpVersion(FCConfigResult v) => v.phpVersion;
  static const Field<FCConfigResult, String> _f$phpVersion = Field(
    'phpVersion',
    _$phpVersion,
    opt: true,
    def: "",
  );
  static String _$adsDisabledGroup(FCConfigResult v) => v.adsDisabledGroup;
  static const Field<FCConfigResult, String> _f$adsDisabledGroup = Field(
    'adsDisabledGroup',
    _$adsDisabledGroup,
    opt: true,
    def: "",
  );
  static bool _$markTopicRead(FCConfigResult v) => v.markTopicRead;
  static const Field<FCConfigResult, bool> _f$markTopicRead = Field(
    'markTopicRead',
    _$markTopicRead,
    opt: true,
    def: false,
  );
  static bool _$advancedDelete(FCConfigResult v) => v.advancedDelete;
  static const Field<FCConfigResult, bool> _f$advancedDelete = Field(
    'advancedDelete',
    _$advancedDelete,
    opt: true,
    def: false,
  );
  static bool _$firstUnread(FCConfigResult v) => v.firstUnread;
  static const Field<FCConfigResult, bool> _f$firstUnread = Field(
    'firstUnread',
    _$firstUnread,
    opt: true,
    def: true,
  );
  static bool _$alert(FCConfigResult v) => v.alert;
  static const Field<FCConfigResult, bool> _f$alert = Field(
    'alert',
    _$alert,
    opt: true,
    def: false,
  );
  static bool _$getActivity(FCConfigResult v) => v.getActivity;
  static const Field<FCConfigResult, bool> _f$getActivity = Field(
    'getActivity',
    _$getActivity,
    opt: true,
    def: false,
  );
  static bool _$searchUser(FCConfigResult v) => v.searchUser;
  static const Field<FCConfigResult, bool> _f$searchUser = Field(
    'searchUser',
    _$searchUser,
    opt: true,
    def: false,
  );
  static bool _$userRecommended(FCConfigResult v) => v.userRecommended;
  static const Field<FCConfigResult, bool> _f$userRecommended = Field(
    'userRecommended',
    _$userRecommended,
    opt: true,
    def: false,
  );
  static bool _$ignoreUser(FCConfigResult v) => v.ignoreUser;
  static const Field<FCConfigResult, bool> _f$ignoreUser = Field(
    'ignoreUser',
    _$ignoreUser,
    opt: true,
    def: false,
  );
  static bool _$getIgnoredUsers(FCConfigResult v) => v.getIgnoredUsers;
  static const Field<FCConfigResult, bool> _f$getIgnoredUsers = Field(
    'getIgnoredUsers',
    _$getIgnoredUsers,
    opt: true,
    def: false,
  );
  static bool _$unban(FCConfigResult v) => v.unban;
  static const Field<FCConfigResult, bool> _f$unban = Field(
    'unban',
    _$unban,
    opt: true,
    def: false,
  );
  static bool _$banExpires(FCConfigResult v) => v.banExpires;
  static const Field<FCConfigResult, bool> _f$banExpires = Field(
    'banExpires',
    _$banExpires,
    opt: true,
    def: false,
  );
  static bool _$advancedMerge(FCConfigResult v) => v.advancedMerge;
  static const Field<FCConfigResult, bool> _f$advancedMerge = Field(
    'advancedMerge',
    _$advancedMerge,
    opt: true,
    def: false,
  );
  static bool _$advancedMove(FCConfigResult v) => v.advancedMove;
  static const Field<FCConfigResult, bool> _f$advancedMove = Field(
    'advancedMove',
    _$advancedMove,
    opt: true,
    def: false,
  );
  static bool _$advancedEdit(FCConfigResult v) => v.advancedEdit;
  static const Field<FCConfigResult, bool> _f$advancedEdit = Field(
    'advancedEdit',
    _$advancedEdit,
    opt: true,
    def: false,
  );
  static bool _$twoStep(FCConfigResult v) => v.twoStep;
  static const Field<FCConfigResult, bool> _f$twoStep = Field(
    'twoStep',
    _$twoStep,
    opt: true,
    def: false,
  );
  static bool _$searchStartedBy(FCConfigResult v) => v.searchStartedBy;
  static const Field<FCConfigResult, bool> _f$searchStartedBy = Field(
    'searchStartedBy',
    _$searchStartedBy,
    opt: true,
    def: false,
  );
  static bool? _$bannerControl(FCConfigResult v) => v.bannerControl;
  static const Field<FCConfigResult, bool> _f$bannerControl = Field(
    'bannerControl',
    _$bannerControl,
    opt: true,
  );
  static bool? _$allowTrending(FCConfigResult v) => v.allowTrending;
  static const Field<FCConfigResult, bool> _f$allowTrending = Field(
    'allowTrending',
    _$allowTrending,
    opt: true,
  );
  static String _$pushType(FCConfigResult v) => v.pushType;
  static const Field<FCConfigResult, String> _f$pushType = Field(
    'pushType',
    _$pushType,
    opt: true,
    def: "",
  );
  static String _$push(FCConfigResult v) => v.push;
  static const Field<FCConfigResult, String> _f$push = Field(
    'push',
    _$push,
    opt: true,
    def: "",
  );
  static bool _$disableHtml(FCConfigResult v) => v.disableHtml;
  static const Field<FCConfigResult, bool> _f$disableHtml = Field(
    'disableHtml',
    _$disableHtml,
    opt: true,
    def: false,
  );
  static String _$contentEncoding(FCConfigResult v) => v.contentEncoding;
  static const Field<FCConfigResult, String> _f$contentEncoding = Field(
    'contentEncoding',
    _$contentEncoding,
    opt: true,
    def: "gzip",
  );
  static String _$contentType(FCConfigResult v) => v.contentType;
  static const Field<FCConfigResult, String> _f$contentType = Field(
    'contentType',
    _$contentType,
    opt: true,
    def: "",
  );
  static bool _$signIn(FCConfigResult v) => v.signIn;
  static const Field<FCConfigResult, bool> _f$signIn = Field(
    'signIn',
    _$signIn,
    opt: true,
    def: false,
  );
  static bool _$setApiKey(FCConfigResult v) => v.setApiKey;
  static const Field<FCConfigResult, bool> _f$setApiKey = Field(
    'setApiKey',
    _$setApiKey,
    opt: true,
    def: false,
  );
  static bool? _$loginWithEmail(FCConfigResult v) => v.loginWithEmail;
  static const Field<FCConfigResult, bool> _f$loginWithEmail = Field(
    'loginWithEmail',
    _$loginWithEmail,
    opt: true,
  );
  static bool? _$syncUser(FCConfigResult v) => v.syncUser;
  static const Field<FCConfigResult, bool> _f$syncUser = Field(
    'syncUser',
    _$syncUser,
    opt: true,
  );
  static bool? _$getContact(FCConfigResult v) => v.getContact;
  static const Field<FCConfigResult, bool> _f$getContact = Field(
    'getContact',
    _$getContact,
    opt: true,
  );
  static bool _$userSubscription(FCConfigResult v) => v.userSubscription;
  static const Field<FCConfigResult, bool> _f$userSubscription = Field(
    'userSubscription',
    _$userSubscription,
    opt: true,
    def: false,
  );
  static bool _$pushContentCheck(FCConfigResult v) => v.pushContentCheck;
  static const Field<FCConfigResult, bool> _f$pushContentCheck = Field(
    'pushContentCheck',
    _$pushContentCheck,
    opt: true,
    def: false,
  );
  static String _$apiKey(FCConfigResult v) => v.apiKey;
  static const Field<FCConfigResult, String> _f$apiKey = Field(
    'apiKey',
    _$apiKey,
    opt: true,
    def: "",
  );
  static String _$mbqFrameVersion(FCConfigResult v) => v.mbqFrameVersion;
  static const Field<FCConfigResult, String> _f$mbqFrameVersion = Field(
    'mbqFrameVersion',
    _$mbqFrameVersion,
    opt: true,
    def: "",
  );
  static String _$forumType(FCConfigResult v) => v.forumType;
  static const Field<FCConfigResult, String> _f$forumType = Field(
    'forumType',
    _$forumType,
    opt: true,
    def: "",
  );

  @override
  final MappableFields<FCConfigResult> fields = const {
    #jsonSupport: _f$jsonSupport,
    #systemVersion: _f$systemVersion,
    #version: _f$version,
    #hookVersion: _f$hookVersion,
    #apiLevel: _f$apiLevel,
    #releaseTimestamp: _f$releaseTimestamp,
    #pushSlug: _f$pushSlug,
    #smartBannerInfo: _f$smartBannerInfo,
    #setForumInfo: _f$setForumInfo,
    #isOpen: _f$isOpen,
    #guestOkay: _f$guestOkay,
    #reportPost: _f$reportPost,
    #reportPm: _f$reportPm,
    #gotoPost: _f$gotoPost,
    #gotoUnread: _f$gotoUnread,
    #getTopicByIds: _f$getTopicByIds,
    #markRead: _f$markRead,
    #markForum: _f$markForum,
    #subscribeForum: _f$subscribeForum,
    #disableSubscribeForum: _f$disableSubscribeForum,
    #disableSearch: _f$disableSearch,
    #getLatestTopic: _f$getLatestTopic,
    #getNewTopic: _f$getNewTopic,
    #getIdByUrl: _f$getIdByUrl,
    #getUrlById: _f$getUrlById,
    #deleteReason: _f$deleteReason,
    #modApprove: _f$modApprove,
    #modDelete: _f$modDelete,
    #modReport: _f$modReport,
    #guestSearch: _f$guestSearch,
    #anonymous: _f$anonymous,
    #guestWhosOnline: _f$guestWhosOnline,
    #searchId: _f$searchId,
    #avatar: _f$avatar,
    #pmLoad: _f$pmLoad,
    #subscribeLoad: _f$subscribeLoad,
    #subscribeTopicMode: _f$subscribeTopicMode,
    #subscribeForumMode: _f$subscribeForumMode,
    #minSearchLength: _f$minSearchLength,
    #inboxStat: _f$inboxStat,
    #multiQuote: _f$multiQuote,
    #defaultSmilies: _f$defaultSmilies,
    #canUnread: _f$canUnread,
    #announcement: _f$announcement,
    #emoji: _f$emoji,
    #supportMd5: _f$supportMd5,
    #supportSha1: _f$supportSha1,
    #passwordType: _f$passwordType,
    #conversation: _f$conversation,
    #getForum: _f$getForum,
    #getTopicStatus: _f$getTopicStatus,
    #getParticipatedForum: _f$getParticipatedForum,
    #getForumStatus: _f$getForumStatus,
    #getSmilies: _f$getSmilies,
    #advancedHtml: _f$advancedHtml,
    #idToUrlRedirect: _f$idToUrlRedirect,
    #updateProfile: _f$updateProfile,
    #getMemberList: _f$getMemberList,
    #mGetInactiveUsers: _f$mGetInactiveUsers,
    #mApproveUser: _f$mApproveUser,
    #pollOptionsMaxCount: _f$pollOptionsMaxCount,
    #advancedOnlineUsers: _f$advancedOnlineUsers,
    #markPmUnread: _f$markPmUnread,
    #markPmRead: _f$markPmRead,
    #advancedSearch: _f$advancedSearch,
    #massSubscribe: _f$massSubscribe,
    #userId: _f$userId,
    #regUrl: _f$regUrl,
    #guestGroupId: _f$guestGroupId,
    #phpVersion: _f$phpVersion,
    #adsDisabledGroup: _f$adsDisabledGroup,
    #markTopicRead: _f$markTopicRead,
    #advancedDelete: _f$advancedDelete,
    #firstUnread: _f$firstUnread,
    #alert: _f$alert,
    #getActivity: _f$getActivity,
    #searchUser: _f$searchUser,
    #userRecommended: _f$userRecommended,
    #ignoreUser: _f$ignoreUser,
    #getIgnoredUsers: _f$getIgnoredUsers,
    #unban: _f$unban,
    #banExpires: _f$banExpires,
    #advancedMerge: _f$advancedMerge,
    #advancedMove: _f$advancedMove,
    #advancedEdit: _f$advancedEdit,
    #twoStep: _f$twoStep,
    #searchStartedBy: _f$searchStartedBy,
    #bannerControl: _f$bannerControl,
    #allowTrending: _f$allowTrending,
    #pushType: _f$pushType,
    #push: _f$push,
    #disableHtml: _f$disableHtml,
    #contentEncoding: _f$contentEncoding,
    #contentType: _f$contentType,
    #signIn: _f$signIn,
    #setApiKey: _f$setApiKey,
    #loginWithEmail: _f$loginWithEmail,
    #syncUser: _f$syncUser,
    #getContact: _f$getContact,
    #userSubscription: _f$userSubscription,
    #pushContentCheck: _f$pushContentCheck,
    #apiKey: _f$apiKey,
    #mbqFrameVersion: _f$mbqFrameVersion,
    #forumType: _f$forumType,
  };

  static FCConfigResult _instantiate(DecodingData data) {
    return FCConfigResult(
      jsonSupport: data.dec(_f$jsonSupport),
      systemVersion: data.dec(_f$systemVersion),
      version: data.dec(_f$version),
      hookVersion: data.dec(_f$hookVersion),
      apiLevel: data.dec(_f$apiLevel),
      releaseTimestamp: data.dec(_f$releaseTimestamp),
      pushSlug: data.dec(_f$pushSlug),
      smartBannerInfo: data.dec(_f$smartBannerInfo),
      setForumInfo: data.dec(_f$setForumInfo),
      isOpen: data.dec(_f$isOpen),
      guestOkay: data.dec(_f$guestOkay),
      reportPost: data.dec(_f$reportPost),
      reportPm: data.dec(_f$reportPm),
      gotoPost: data.dec(_f$gotoPost),
      gotoUnread: data.dec(_f$gotoUnread),
      getTopicByIds: data.dec(_f$getTopicByIds),
      markRead: data.dec(_f$markRead),
      markForum: data.dec(_f$markForum),
      subscribeForum: data.dec(_f$subscribeForum),
      disableSubscribeForum: data.dec(_f$disableSubscribeForum),
      disableSearch: data.dec(_f$disableSearch),
      getLatestTopic: data.dec(_f$getLatestTopic),
      getNewTopic: data.dec(_f$getNewTopic),
      getIdByUrl: data.dec(_f$getIdByUrl),
      getUrlById: data.dec(_f$getUrlById),
      deleteReason: data.dec(_f$deleteReason),
      modApprove: data.dec(_f$modApprove),
      modDelete: data.dec(_f$modDelete),
      modReport: data.dec(_f$modReport),
      guestSearch: data.dec(_f$guestSearch),
      anonymous: data.dec(_f$anonymous),
      guestWhosOnline: data.dec(_f$guestWhosOnline),
      searchId: data.dec(_f$searchId),
      avatar: data.dec(_f$avatar),
      pmLoad: data.dec(_f$pmLoad),
      subscribeLoad: data.dec(_f$subscribeLoad),
      subscribeTopicMode: data.dec(_f$subscribeTopicMode),
      subscribeForumMode: data.dec(_f$subscribeForumMode),
      minSearchLength: data.dec(_f$minSearchLength),
      inboxStat: data.dec(_f$inboxStat),
      multiQuote: data.dec(_f$multiQuote),
      defaultSmilies: data.dec(_f$defaultSmilies),
      canUnread: data.dec(_f$canUnread),
      announcement: data.dec(_f$announcement),
      emoji: data.dec(_f$emoji),
      supportMd5: data.dec(_f$supportMd5),
      supportSha1: data.dec(_f$supportSha1),
      passwordType: data.dec(_f$passwordType),
      conversation: data.dec(_f$conversation),
      getForum: data.dec(_f$getForum),
      getTopicStatus: data.dec(_f$getTopicStatus),
      getParticipatedForum: data.dec(_f$getParticipatedForum),
      getForumStatus: data.dec(_f$getForumStatus),
      getSmilies: data.dec(_f$getSmilies),
      advancedHtml: data.dec(_f$advancedHtml),
      idToUrlRedirect: data.dec(_f$idToUrlRedirect),
      updateProfile: data.dec(_f$updateProfile),
      getMemberList: data.dec(_f$getMemberList),
      mGetInactiveUsers: data.dec(_f$mGetInactiveUsers),
      mApproveUser: data.dec(_f$mApproveUser),
      pollOptionsMaxCount: data.dec(_f$pollOptionsMaxCount),
      advancedOnlineUsers: data.dec(_f$advancedOnlineUsers),
      markPmUnread: data.dec(_f$markPmUnread),
      markPmRead: data.dec(_f$markPmRead),
      advancedSearch: data.dec(_f$advancedSearch),
      massSubscribe: data.dec(_f$massSubscribe),
      userId: data.dec(_f$userId),
      regUrl: data.dec(_f$regUrl),
      guestGroupId: data.dec(_f$guestGroupId),
      phpVersion: data.dec(_f$phpVersion),
      adsDisabledGroup: data.dec(_f$adsDisabledGroup),
      markTopicRead: data.dec(_f$markTopicRead),
      advancedDelete: data.dec(_f$advancedDelete),
      firstUnread: data.dec(_f$firstUnread),
      alert: data.dec(_f$alert),
      getActivity: data.dec(_f$getActivity),
      searchUser: data.dec(_f$searchUser),
      userRecommended: data.dec(_f$userRecommended),
      ignoreUser: data.dec(_f$ignoreUser),
      getIgnoredUsers: data.dec(_f$getIgnoredUsers),
      unban: data.dec(_f$unban),
      banExpires: data.dec(_f$banExpires),
      advancedMerge: data.dec(_f$advancedMerge),
      advancedMove: data.dec(_f$advancedMove),
      advancedEdit: data.dec(_f$advancedEdit),
      twoStep: data.dec(_f$twoStep),
      searchStartedBy: data.dec(_f$searchStartedBy),
      bannerControl: data.dec(_f$bannerControl),
      allowTrending: data.dec(_f$allowTrending),
      pushType: data.dec(_f$pushType),
      push: data.dec(_f$push),
      disableHtml: data.dec(_f$disableHtml),
      contentEncoding: data.dec(_f$contentEncoding),
      contentType: data.dec(_f$contentType),
      signIn: data.dec(_f$signIn),
      setApiKey: data.dec(_f$setApiKey),
      loginWithEmail: data.dec(_f$loginWithEmail),
      syncUser: data.dec(_f$syncUser),
      getContact: data.dec(_f$getContact),
      userSubscription: data.dec(_f$userSubscription),
      pushContentCheck: data.dec(_f$pushContentCheck),
      apiKey: data.dec(_f$apiKey),
      mbqFrameVersion: data.dec(_f$mbqFrameVersion),
      forumType: data.dec(_f$forumType),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FCConfigResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FCConfigResult>(map);
  }

  static FCConfigResult fromJson(String json) {
    return ensureInitialized().decodeJson<FCConfigResult>(json);
  }
}

mixin FCConfigResultMappable {
  String toJson() {
    return FCConfigResultMapper.ensureInitialized().encodeJson<FCConfigResult>(
      this as FCConfigResult,
    );
  }

  Map<String, dynamic> toMap() {
    return FCConfigResultMapper.ensureInitialized().encodeMap<FCConfigResult>(
      this as FCConfigResult,
    );
  }

  FCConfigResultCopyWith<FCConfigResult, FCConfigResult, FCConfigResult>
  get copyWith => _FCConfigResultCopyWithImpl<FCConfigResult, FCConfigResult>(
    this as FCConfigResult,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FCConfigResultMapper.ensureInitialized().stringifyValue(
      this as FCConfigResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return FCConfigResultMapper.ensureInitialized().equalsValue(
      this as FCConfigResult,
      other,
    );
  }

  @override
  int get hashCode {
    return FCConfigResultMapper.ensureInitialized().hashValue(
      this as FCConfigResult,
    );
  }
}

extension FCConfigResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FCConfigResult, $Out> {
  FCConfigResultCopyWith<$R, FCConfigResult, $Out> get $asFCConfigResult =>
      $base.as((v, t, t2) => _FCConfigResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FCConfigResultCopyWith<$R, $In extends FCConfigResult, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    bool? jsonSupport,
    String? systemVersion,
    String? version,
    String? hookVersion,
    String? apiLevel,
    String? releaseTimestamp,
    String? pushSlug,
    String? smartBannerInfo,
    bool? setForumInfo,
    bool? isOpen,
    bool? guestOkay,
    bool? reportPost,
    bool? reportPm,
    bool? gotoPost,
    bool? gotoUnread,
    bool? getTopicByIds,
    bool? markRead,
    bool? markForum,
    bool? subscribeForum,
    bool? disableSubscribeForum,
    bool? disableSearch,
    bool? getLatestTopic,
    bool? getNewTopic,
    bool? getIdByUrl,
    bool? getUrlById,
    bool? deleteReason,
    bool? modApprove,
    bool? modDelete,
    bool? modReport,
    bool? guestSearch,
    bool? anonymous,
    bool? guestWhosOnline,
    bool? searchId,
    bool? avatar,
    bool? pmLoad,
    bool? subscribeLoad,
    String? subscribeTopicMode,
    String? subscribeForumMode,
    int? minSearchLength,
    bool? inboxStat,
    bool? multiQuote,
    bool? defaultSmilies,
    bool? canUnread,
    bool? announcement,
    bool? emoji,
    bool? supportMd5,
    bool? supportSha1,
    String? passwordType,
    bool? conversation,
    bool? getForum,
    bool? getTopicStatus,
    bool? getParticipatedForum,
    bool? getForumStatus,
    bool? getSmilies,
    bool? advancedHtml,
    bool? idToUrlRedirect,
    bool? updateProfile,
    bool? getMemberList,
    bool? mGetInactiveUsers,
    bool? mApproveUser,
    bool? pollOptionsMaxCount,
    bool? advancedOnlineUsers,
    bool? markPmUnread,
    bool? markPmRead,
    bool? advancedSearch,
    bool? massSubscribe,
    String? userId,
    String? regUrl,
    String? guestGroupId,
    String? phpVersion,
    String? adsDisabledGroup,
    bool? markTopicRead,
    bool? advancedDelete,
    bool? firstUnread,
    bool? alert,
    bool? getActivity,
    bool? searchUser,
    bool? userRecommended,
    bool? ignoreUser,
    bool? getIgnoredUsers,
    bool? unban,
    bool? banExpires,
    bool? advancedMerge,
    bool? advancedMove,
    bool? advancedEdit,
    bool? twoStep,
    bool? searchStartedBy,
    bool? bannerControl,
    bool? allowTrending,
    String? pushType,
    String? push,
    bool? disableHtml,
    String? contentEncoding,
    String? contentType,
    bool? signIn,
    bool? setApiKey,
    bool? loginWithEmail,
    bool? syncUser,
    bool? getContact,
    bool? userSubscription,
    bool? pushContentCheck,
    String? apiKey,
    String? mbqFrameVersion,
    String? forumType,
  });
  FCConfigResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FCConfigResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FCConfigResult, $Out>
    implements FCConfigResultCopyWith<$R, FCConfigResult, $Out> {
  _FCConfigResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FCConfigResult> $mapper =
      FCConfigResultMapper.ensureInitialized();
  @override
  $R call({
    bool? jsonSupport,
    String? systemVersion,
    String? version,
    String? hookVersion,
    String? apiLevel,
    String? releaseTimestamp,
    String? pushSlug,
    String? smartBannerInfo,
    bool? setForumInfo,
    bool? isOpen,
    bool? guestOkay,
    bool? reportPost,
    bool? reportPm,
    bool? gotoPost,
    bool? gotoUnread,
    bool? getTopicByIds,
    bool? markRead,
    bool? markForum,
    bool? subscribeForum,
    bool? disableSubscribeForum,
    bool? disableSearch,
    bool? getLatestTopic,
    bool? getNewTopic,
    bool? getIdByUrl,
    bool? getUrlById,
    bool? deleteReason,
    bool? modApprove,
    bool? modDelete,
    bool? modReport,
    bool? guestSearch,
    bool? anonymous,
    bool? guestWhosOnline,
    bool? searchId,
    bool? avatar,
    bool? pmLoad,
    bool? subscribeLoad,
    String? subscribeTopicMode,
    String? subscribeForumMode,
    int? minSearchLength,
    bool? inboxStat,
    bool? multiQuote,
    bool? defaultSmilies,
    bool? canUnread,
    bool? announcement,
    bool? emoji,
    bool? supportMd5,
    bool? supportSha1,
    String? passwordType,
    bool? conversation,
    bool? getForum,
    bool? getTopicStatus,
    bool? getParticipatedForum,
    bool? getForumStatus,
    Object? getSmilies = $none,
    Object? advancedHtml = $none,
    Object? idToUrlRedirect = $none,
    Object? updateProfile = $none,
    Object? getMemberList = $none,
    Object? mGetInactiveUsers = $none,
    Object? mApproveUser = $none,
    Object? pollOptionsMaxCount = $none,
    bool? advancedOnlineUsers,
    bool? markPmUnread,
    bool? markPmRead,
    bool? advancedSearch,
    bool? massSubscribe,
    String? userId,
    String? regUrl,
    String? guestGroupId,
    String? phpVersion,
    String? adsDisabledGroup,
    bool? markTopicRead,
    bool? advancedDelete,
    bool? firstUnread,
    bool? alert,
    bool? getActivity,
    bool? searchUser,
    bool? userRecommended,
    bool? ignoreUser,
    bool? getIgnoredUsers,
    bool? unban,
    bool? banExpires,
    bool? advancedMerge,
    bool? advancedMove,
    bool? advancedEdit,
    bool? twoStep,
    bool? searchStartedBy,
    Object? bannerControl = $none,
    Object? allowTrending = $none,
    String? pushType,
    String? push,
    bool? disableHtml,
    String? contentEncoding,
    String? contentType,
    bool? signIn,
    bool? setApiKey,
    Object? loginWithEmail = $none,
    Object? syncUser = $none,
    Object? getContact = $none,
    bool? userSubscription,
    bool? pushContentCheck,
    String? apiKey,
    String? mbqFrameVersion,
    String? forumType,
  }) => $apply(
    FieldCopyWithData({
      if (jsonSupport != null) #jsonSupport: jsonSupport,
      if (systemVersion != null) #systemVersion: systemVersion,
      if (version != null) #version: version,
      if (hookVersion != null) #hookVersion: hookVersion,
      if (apiLevel != null) #apiLevel: apiLevel,
      if (releaseTimestamp != null) #releaseTimestamp: releaseTimestamp,
      if (pushSlug != null) #pushSlug: pushSlug,
      if (smartBannerInfo != null) #smartBannerInfo: smartBannerInfo,
      if (setForumInfo != null) #setForumInfo: setForumInfo,
      if (isOpen != null) #isOpen: isOpen,
      if (guestOkay != null) #guestOkay: guestOkay,
      if (reportPost != null) #reportPost: reportPost,
      if (reportPm != null) #reportPm: reportPm,
      if (gotoPost != null) #gotoPost: gotoPost,
      if (gotoUnread != null) #gotoUnread: gotoUnread,
      if (getTopicByIds != null) #getTopicByIds: getTopicByIds,
      if (markRead != null) #markRead: markRead,
      if (markForum != null) #markForum: markForum,
      if (subscribeForum != null) #subscribeForum: subscribeForum,
      if (disableSubscribeForum != null)
        #disableSubscribeForum: disableSubscribeForum,
      if (disableSearch != null) #disableSearch: disableSearch,
      if (getLatestTopic != null) #getLatestTopic: getLatestTopic,
      if (getNewTopic != null) #getNewTopic: getNewTopic,
      if (getIdByUrl != null) #getIdByUrl: getIdByUrl,
      if (getUrlById != null) #getUrlById: getUrlById,
      if (deleteReason != null) #deleteReason: deleteReason,
      if (modApprove != null) #modApprove: modApprove,
      if (modDelete != null) #modDelete: modDelete,
      if (modReport != null) #modReport: modReport,
      if (guestSearch != null) #guestSearch: guestSearch,
      if (anonymous != null) #anonymous: anonymous,
      if (guestWhosOnline != null) #guestWhosOnline: guestWhosOnline,
      if (searchId != null) #searchId: searchId,
      if (avatar != null) #avatar: avatar,
      if (pmLoad != null) #pmLoad: pmLoad,
      if (subscribeLoad != null) #subscribeLoad: subscribeLoad,
      if (subscribeTopicMode != null) #subscribeTopicMode: subscribeTopicMode,
      if (subscribeForumMode != null) #subscribeForumMode: subscribeForumMode,
      if (minSearchLength != null) #minSearchLength: minSearchLength,
      if (inboxStat != null) #inboxStat: inboxStat,
      if (multiQuote != null) #multiQuote: multiQuote,
      if (defaultSmilies != null) #defaultSmilies: defaultSmilies,
      if (canUnread != null) #canUnread: canUnread,
      if (announcement != null) #announcement: announcement,
      if (emoji != null) #emoji: emoji,
      if (supportMd5 != null) #supportMd5: supportMd5,
      if (supportSha1 != null) #supportSha1: supportSha1,
      if (passwordType != null) #passwordType: passwordType,
      if (conversation != null) #conversation: conversation,
      if (getForum != null) #getForum: getForum,
      if (getTopicStatus != null) #getTopicStatus: getTopicStatus,
      if (getParticipatedForum != null)
        #getParticipatedForum: getParticipatedForum,
      if (getForumStatus != null) #getForumStatus: getForumStatus,
      if (getSmilies != $none) #getSmilies: getSmilies,
      if (advancedHtml != $none) #advancedHtml: advancedHtml,
      if (idToUrlRedirect != $none) #idToUrlRedirect: idToUrlRedirect,
      if (updateProfile != $none) #updateProfile: updateProfile,
      if (getMemberList != $none) #getMemberList: getMemberList,
      if (mGetInactiveUsers != $none) #mGetInactiveUsers: mGetInactiveUsers,
      if (mApproveUser != $none) #mApproveUser: mApproveUser,
      if (pollOptionsMaxCount != $none)
        #pollOptionsMaxCount: pollOptionsMaxCount,
      if (advancedOnlineUsers != null)
        #advancedOnlineUsers: advancedOnlineUsers,
      if (markPmUnread != null) #markPmUnread: markPmUnread,
      if (markPmRead != null) #markPmRead: markPmRead,
      if (advancedSearch != null) #advancedSearch: advancedSearch,
      if (massSubscribe != null) #massSubscribe: massSubscribe,
      if (userId != null) #userId: userId,
      if (regUrl != null) #regUrl: regUrl,
      if (guestGroupId != null) #guestGroupId: guestGroupId,
      if (phpVersion != null) #phpVersion: phpVersion,
      if (adsDisabledGroup != null) #adsDisabledGroup: adsDisabledGroup,
      if (markTopicRead != null) #markTopicRead: markTopicRead,
      if (advancedDelete != null) #advancedDelete: advancedDelete,
      if (firstUnread != null) #firstUnread: firstUnread,
      if (alert != null) #alert: alert,
      if (getActivity != null) #getActivity: getActivity,
      if (searchUser != null) #searchUser: searchUser,
      if (userRecommended != null) #userRecommended: userRecommended,
      if (ignoreUser != null) #ignoreUser: ignoreUser,
      if (getIgnoredUsers != null) #getIgnoredUsers: getIgnoredUsers,
      if (unban != null) #unban: unban,
      if (banExpires != null) #banExpires: banExpires,
      if (advancedMerge != null) #advancedMerge: advancedMerge,
      if (advancedMove != null) #advancedMove: advancedMove,
      if (advancedEdit != null) #advancedEdit: advancedEdit,
      if (twoStep != null) #twoStep: twoStep,
      if (searchStartedBy != null) #searchStartedBy: searchStartedBy,
      if (bannerControl != $none) #bannerControl: bannerControl,
      if (allowTrending != $none) #allowTrending: allowTrending,
      if (pushType != null) #pushType: pushType,
      if (push != null) #push: push,
      if (disableHtml != null) #disableHtml: disableHtml,
      if (contentEncoding != null) #contentEncoding: contentEncoding,
      if (contentType != null) #contentType: contentType,
      if (signIn != null) #signIn: signIn,
      if (setApiKey != null) #setApiKey: setApiKey,
      if (loginWithEmail != $none) #loginWithEmail: loginWithEmail,
      if (syncUser != $none) #syncUser: syncUser,
      if (getContact != $none) #getContact: getContact,
      if (userSubscription != null) #userSubscription: userSubscription,
      if (pushContentCheck != null) #pushContentCheck: pushContentCheck,
      if (apiKey != null) #apiKey: apiKey,
      if (mbqFrameVersion != null) #mbqFrameVersion: mbqFrameVersion,
      if (forumType != null) #forumType: forumType,
    }),
  );
  @override
  FCConfigResult $make(CopyWithData data) => FCConfigResult(
    jsonSupport: data.get(#jsonSupport, or: $value.jsonSupport),
    systemVersion: data.get(#systemVersion, or: $value.systemVersion),
    version: data.get(#version, or: $value.version),
    hookVersion: data.get(#hookVersion, or: $value.hookVersion),
    apiLevel: data.get(#apiLevel, or: $value.apiLevel),
    releaseTimestamp: data.get(#releaseTimestamp, or: $value.releaseTimestamp),
    pushSlug: data.get(#pushSlug, or: $value.pushSlug),
    smartBannerInfo: data.get(#smartBannerInfo, or: $value.smartBannerInfo),
    setForumInfo: data.get(#setForumInfo, or: $value.setForumInfo),
    isOpen: data.get(#isOpen, or: $value.isOpen),
    guestOkay: data.get(#guestOkay, or: $value.guestOkay),
    reportPost: data.get(#reportPost, or: $value.reportPost),
    reportPm: data.get(#reportPm, or: $value.reportPm),
    gotoPost: data.get(#gotoPost, or: $value.gotoPost),
    gotoUnread: data.get(#gotoUnread, or: $value.gotoUnread),
    getTopicByIds: data.get(#getTopicByIds, or: $value.getTopicByIds),
    markRead: data.get(#markRead, or: $value.markRead),
    markForum: data.get(#markForum, or: $value.markForum),
    subscribeForum: data.get(#subscribeForum, or: $value.subscribeForum),
    disableSubscribeForum: data.get(
      #disableSubscribeForum,
      or: $value.disableSubscribeForum,
    ),
    disableSearch: data.get(#disableSearch, or: $value.disableSearch),
    getLatestTopic: data.get(#getLatestTopic, or: $value.getLatestTopic),
    getNewTopic: data.get(#getNewTopic, or: $value.getNewTopic),
    getIdByUrl: data.get(#getIdByUrl, or: $value.getIdByUrl),
    getUrlById: data.get(#getUrlById, or: $value.getUrlById),
    deleteReason: data.get(#deleteReason, or: $value.deleteReason),
    modApprove: data.get(#modApprove, or: $value.modApprove),
    modDelete: data.get(#modDelete, or: $value.modDelete),
    modReport: data.get(#modReport, or: $value.modReport),
    guestSearch: data.get(#guestSearch, or: $value.guestSearch),
    anonymous: data.get(#anonymous, or: $value.anonymous),
    guestWhosOnline: data.get(#guestWhosOnline, or: $value.guestWhosOnline),
    searchId: data.get(#searchId, or: $value.searchId),
    avatar: data.get(#avatar, or: $value.avatar),
    pmLoad: data.get(#pmLoad, or: $value.pmLoad),
    subscribeLoad: data.get(#subscribeLoad, or: $value.subscribeLoad),
    subscribeTopicMode: data.get(
      #subscribeTopicMode,
      or: $value.subscribeTopicMode,
    ),
    subscribeForumMode: data.get(
      #subscribeForumMode,
      or: $value.subscribeForumMode,
    ),
    minSearchLength: data.get(#minSearchLength, or: $value.minSearchLength),
    inboxStat: data.get(#inboxStat, or: $value.inboxStat),
    multiQuote: data.get(#multiQuote, or: $value.multiQuote),
    defaultSmilies: data.get(#defaultSmilies, or: $value.defaultSmilies),
    canUnread: data.get(#canUnread, or: $value.canUnread),
    announcement: data.get(#announcement, or: $value.announcement),
    emoji: data.get(#emoji, or: $value.emoji),
    supportMd5: data.get(#supportMd5, or: $value.supportMd5),
    supportSha1: data.get(#supportSha1, or: $value.supportSha1),
    passwordType: data.get(#passwordType, or: $value.passwordType),
    conversation: data.get(#conversation, or: $value.conversation),
    getForum: data.get(#getForum, or: $value.getForum),
    getTopicStatus: data.get(#getTopicStatus, or: $value.getTopicStatus),
    getParticipatedForum: data.get(
      #getParticipatedForum,
      or: $value.getParticipatedForum,
    ),
    getForumStatus: data.get(#getForumStatus, or: $value.getForumStatus),
    getSmilies: data.get(#getSmilies, or: $value.getSmilies),
    advancedHtml: data.get(#advancedHtml, or: $value.advancedHtml),
    idToUrlRedirect: data.get(#idToUrlRedirect, or: $value.idToUrlRedirect),
    updateProfile: data.get(#updateProfile, or: $value.updateProfile),
    getMemberList: data.get(#getMemberList, or: $value.getMemberList),
    mGetInactiveUsers: data.get(
      #mGetInactiveUsers,
      or: $value.mGetInactiveUsers,
    ),
    mApproveUser: data.get(#mApproveUser, or: $value.mApproveUser),
    pollOptionsMaxCount: data.get(
      #pollOptionsMaxCount,
      or: $value.pollOptionsMaxCount,
    ),
    advancedOnlineUsers: data.get(
      #advancedOnlineUsers,
      or: $value.advancedOnlineUsers,
    ),
    markPmUnread: data.get(#markPmUnread, or: $value.markPmUnread),
    markPmRead: data.get(#markPmRead, or: $value.markPmRead),
    advancedSearch: data.get(#advancedSearch, or: $value.advancedSearch),
    massSubscribe: data.get(#massSubscribe, or: $value.massSubscribe),
    userId: data.get(#userId, or: $value.userId),
    regUrl: data.get(#regUrl, or: $value.regUrl),
    guestGroupId: data.get(#guestGroupId, or: $value.guestGroupId),
    phpVersion: data.get(#phpVersion, or: $value.phpVersion),
    adsDisabledGroup: data.get(#adsDisabledGroup, or: $value.adsDisabledGroup),
    markTopicRead: data.get(#markTopicRead, or: $value.markTopicRead),
    advancedDelete: data.get(#advancedDelete, or: $value.advancedDelete),
    firstUnread: data.get(#firstUnread, or: $value.firstUnread),
    alert: data.get(#alert, or: $value.alert),
    getActivity: data.get(#getActivity, or: $value.getActivity),
    searchUser: data.get(#searchUser, or: $value.searchUser),
    userRecommended: data.get(#userRecommended, or: $value.userRecommended),
    ignoreUser: data.get(#ignoreUser, or: $value.ignoreUser),
    getIgnoredUsers: data.get(#getIgnoredUsers, or: $value.getIgnoredUsers),
    unban: data.get(#unban, or: $value.unban),
    banExpires: data.get(#banExpires, or: $value.banExpires),
    advancedMerge: data.get(#advancedMerge, or: $value.advancedMerge),
    advancedMove: data.get(#advancedMove, or: $value.advancedMove),
    advancedEdit: data.get(#advancedEdit, or: $value.advancedEdit),
    twoStep: data.get(#twoStep, or: $value.twoStep),
    searchStartedBy: data.get(#searchStartedBy, or: $value.searchStartedBy),
    bannerControl: data.get(#bannerControl, or: $value.bannerControl),
    allowTrending: data.get(#allowTrending, or: $value.allowTrending),
    pushType: data.get(#pushType, or: $value.pushType),
    push: data.get(#push, or: $value.push),
    disableHtml: data.get(#disableHtml, or: $value.disableHtml),
    contentEncoding: data.get(#contentEncoding, or: $value.contentEncoding),
    contentType: data.get(#contentType, or: $value.contentType),
    signIn: data.get(#signIn, or: $value.signIn),
    setApiKey: data.get(#setApiKey, or: $value.setApiKey),
    loginWithEmail: data.get(#loginWithEmail, or: $value.loginWithEmail),
    syncUser: data.get(#syncUser, or: $value.syncUser),
    getContact: data.get(#getContact, or: $value.getContact),
    userSubscription: data.get(#userSubscription, or: $value.userSubscription),
    pushContentCheck: data.get(#pushContentCheck, or: $value.pushContentCheck),
    apiKey: data.get(#apiKey, or: $value.apiKey),
    mbqFrameVersion: data.get(#mbqFrameVersion, or: $value.mbqFrameVersion),
    forumType: data.get(#forumType, or: $value.forumType),
  );

  @override
  FCConfigResultCopyWith<$R2, FCConfigResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FCConfigResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

