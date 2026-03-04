import 'package:dart_mappable/dart_mappable.dart';

part 'fc_config_result.mapper.dart';

/// Forum Copilot Configuration Result
///
/// This class represents the configuration data returned by forum systems.
/// It contains all the necessary configuration flags and settings that
/// determine the capabilities and behavior of the forum.
@MappableClass()
class FCConfigResult with FCConfigResultMappable {
  /// Whether the forum supports JSON responses
  bool jsonSupport;

  /// Forum system version without forum type (e.g., "3.0.9", "4.1.4")
  String systemVersion;

  /// Forum plugin version
  String version;

  /// Hook version for the forum plugin
  String hookVersion;

  /// API Level of the forum plugin (e.g., "3", "4")
  String apiLevel;

  /// Release timestamp
  String releaseTimestamp;

  /// Push notification slug
  String pushSlug;

  /// Smart banner information
  String smartBannerInfo;

  /// Whether to set forum info
  bool setForumInfo;

  /// Whether the forum service is available
  bool isOpen;

  /// Whether guest access is allowed
  bool guestOkay;

  /// Whether the plugin supports report_post function
  bool reportPost;

  /// Whether the plugin supports report_pm function
  bool reportPm;

  /// Whether the plugin supports goto_post functionality
  bool gotoPost;

  /// Whether the plugin supports goto_unread functionality
  bool gotoUnread;

  /// Whether the plugin supports get_topic_by_ids
  bool getTopicByIds;

  /// Whether the forum system supports mark_all_as_read
  bool markRead;

  /// Whether mark_all_as_read can accept forum id parameter
  bool markForum;

  /// Whether the forum system supports sub-forum subscription
  bool subscribeForum;

  /// Whether sub-forum subscription is disabled
  bool disableSubscribeForum;

  /// Whether search functionality is disabled
  bool disableSearch;

  /// Whether the plugin supports get_latest_topic
  bool getLatestTopic;

  /// Whether the plugin supports get_new_topic
  bool getNewTopic;

  /// Whether the plugin supports get_id_by_url
  bool getIdByUrl;

  /// Whether the plugin supports get_url_by_id
  bool getUrlById;

  /// Whether the plugin supports delete reason parameter
  bool deleteReason;

  /// Whether the forum supports moderation approval
  bool modApprove;

  /// Whether the forum supports moderation delete
  bool modDelete;

  /// Whether the forum supports moderation report
  bool modReport;

  /// Whether guest users can search
  bool guestSearch;

  /// Whether the plugin supports anonymous login
  bool anonymous;

  /// Whether guest users can see who's online
  bool guestWhosOnline;

  /// Whether search functions support searchid pagination
  bool searchId;

  /// Whether the plugin supports avatar functionality
  bool avatar;

  /// Whether get_box supports pagination
  bool pmLoad;

  /// Whether get_subscribed_topic supports pagination
  bool subscribeLoad;

  /// Subscription topic notification modes
  String subscribeTopicMode;

  /// Subscription forum notification modes
  String subscribeForumMode;

  /// Minimum string length for search
  int minSearchLength;

  /// Whether the plugin supports inbox statistics
  bool inboxStat;

  /// Whether the plugin supports multi-quote
  bool multiQuote;

  /// Whether the forum supports default smilies
  bool defaultSmilies;

  /// Whether the forum supports unread functionality
  bool canUnread;

  /// Whether the forum supports announcements
  bool announcement;

  /// Whether the plugin contains emoji package
  bool emoji;

  /// Whether the plugin supports MD5 password
  bool supportMd5;

  /// Whether the plugin supports SHA1 password
  bool supportSha1;

  /// Password type used by the forum
  String passwordType;

  /// Whether the plugin supports conversation PM
  bool conversation;

  /// Whether the plugin supports get_forum with parameters
  bool getForum;

  /// Whether the plugin supports get_topic_status
  bool getTopicStatus;

  /// Whether the plugin supports get_participated_forum
  bool getParticipatedForum;

  /// Whether the plugin supports get_forum_status
  bool getForumStatus;

  /// Whether the plugin supports get_smilies
  bool? getSmilies;

  /// Whether the plugin supports advanced_html parameter
  bool? advancedHtml;

  /// Whether the plugin supports id_to_url_redirect parameter
  bool? idToUrlRedirect;

  /// Whether the plugin supports update_profile parameter
  bool? updateProfile;

  /// Whether the plugin supports get_member_list parameter
  bool? getMemberList;

  /// Whether the plugin supports m_get_inactive_users parameter
  bool? mGetInactiveUsers;

  /// Whether the plugin supports m_approve_user parameter
  bool? mApproveUser;

  /// Whether the plugin supports poll_options_max_count parameter
  bool? pollOptionsMaxCount;

  /// Whether the plugin supports advanced online users functionality
  bool advancedOnlineUsers;

  /// Whether the plugin supports mark_pm_unread function
  bool markPmUnread;

  /// Whether the plugin supports mark_pm_read function
  bool markPmRead;

  /// Whether the plugin supports advanced search
  bool advancedSearch;

  /// Whether the plugin supports mass subscription
  bool massSubscribe;

  /// User ID support indicator
  String userId;

  /// Registration URL
  String regUrl;

  /// Guest group ID
  String guestGroupId;

  /// PHP version
  String phpVersion;

  /// Ads disabled group
  String adsDisabledGroup;

  /// Whether the plugin supports mark_topic_read function
  bool markTopicRead;

  /// Whether the plugin supports advanced delete (soft and hard)
  bool advancedDelete;

  /// Whether the forum supports first unread feature
  bool firstUnread;

  /// Whether the plugin supports get_alert function
  bool alert;

  /// Whether the plugin supports get_activity function
  bool getActivity;

  /// Whether the plugin supports search_user function
  bool searchUser;

  /// Whether the plugin supports get_recommended_user function
  bool userRecommended;

  /// Whether the plugin supports ignore_user function
  bool ignoreUser;

  /// Whether the plugin supports get_ignored_users function
  bool getIgnoredUsers;

  /// Whether the plugin supports unban function
  bool unban;

  /// Whether the plugin supports ban_expires parameter
  bool banExpires;

  /// Whether the plugin supports advanced merge
  bool advancedMerge;

  /// Whether the plugin supports advanced move
  bool advancedMove;

  /// Whether the plugin supports advanced edit
  bool advancedEdit;

  /// Whether the plugin supports 2FA authentication
  bool twoStep;

  /// Whether the plugin supports search_started_by parameter
  bool searchStartedBy;

  /// Banner control flag
  bool? bannerControl;

  /// Allow trending flag
  bool? allowTrending;

  /// Push type
  String pushType;

  /// Push support
  String push;

  /// Whether HTML is disabled
  bool disableHtml;

  /// Content encoding
  String contentEncoding;

  /// Content type
  String contentType;

  /// Whether the plugin supports sign_in function
  bool signIn;

  /// Whether the plugin supports set_api_key function
  bool setApiKey;

  /// Whether the plugin supports login_with_email
  bool? loginWithEmail;

  /// Whether the plugin supports sync_user function
  bool? syncUser;

  /// Whether the plugin supports get_contact function
  bool? getContact;

  /// Whether the plugin supports user_subscription function
  bool userSubscription;

  /// Whether the plugin supports push_content_check function
  bool pushContentCheck;

  /// API key
  String apiKey;

  /// MBQ frame version
  String mbqFrameVersion;

  String forumType;

  /// Constructor with default values
  FCConfigResult({
    this.jsonSupport = false,
    this.systemVersion = "",
    this.version = "",
    this.hookVersion = "",
    this.apiLevel = "",
    this.releaseTimestamp = "",
    this.pushSlug = "",
    this.smartBannerInfo = "",
    this.setForumInfo = false,
    this.isOpen = false,
    this.guestOkay = false,
    this.reportPost = false,
    this.reportPm = false,
    this.gotoPost = false,
    this.gotoUnread = false,
    this.getTopicByIds = false,
    this.markRead = true,
    this.markForum = false,
    this.subscribeForum = true,
    this.disableSubscribeForum = false,
    this.disableSearch = false,
    this.getLatestTopic = false,
    this.getNewTopic = false,
    this.getIdByUrl = false,
    this.getUrlById = false,
    this.deleteReason = false,
    this.modApprove = false,
    this.modDelete = false,
    this.modReport = false,
    this.guestSearch = false,
    this.anonymous = false,
    this.guestWhosOnline = false,
    this.searchId = false,
    this.avatar = false,
    this.pmLoad = false,
    this.subscribeLoad = false,
    this.subscribeTopicMode = "",
    this.subscribeForumMode = "",
    this.minSearchLength = 0,
    this.inboxStat = false,
    this.multiQuote = false,
    this.defaultSmilies = true,
    this.canUnread = true,
    this.announcement = true,
    this.emoji = false,
    this.supportMd5 = false,
    this.supportSha1 = false,
    this.passwordType = "",
    this.conversation = false,
    this.getForum = false,
    this.getTopicStatus = false,
    this.getParticipatedForum = false,
    this.getForumStatus = false,
    this.getSmilies,
    this.advancedHtml,
    this.idToUrlRedirect,
    this.updateProfile,
    this.getMemberList,
    this.mGetInactiveUsers,
    this.mApproveUser,
    this.pollOptionsMaxCount,
    this.advancedOnlineUsers = false,
    this.markPmUnread = false,
    this.markPmRead = false,
    this.advancedSearch = false,
    this.massSubscribe = false,
    this.userId = "",
    this.regUrl = "",
    this.guestGroupId = "",
    this.phpVersion = "",
    this.adsDisabledGroup = "",
    this.markTopicRead = false,
    this.advancedDelete = false,
    this.firstUnread = true,
    this.alert = false,
    this.getActivity = false,
    this.searchUser = false,
    this.userRecommended = false,
    this.ignoreUser = false,
    this.getIgnoredUsers = false,
    this.unban = false,
    this.banExpires = false,
    this.advancedMerge = false,
    this.advancedMove = false,
    this.advancedEdit = false,
    this.twoStep = false,
    this.searchStartedBy = false,
    this.bannerControl,
    this.allowTrending,
    this.pushType = "",
    this.push = "",
    this.disableHtml = false,
    this.contentEncoding = "gzip",
    this.contentType = "",
    this.signIn = false,
    this.setApiKey = false,
    this.loginWithEmail,
    this.syncUser,
    this.getContact,
    this.userSubscription = false,
    this.pushContentCheck = false,
    this.apiKey = "",
    this.mbqFrameVersion = "",
    this.forumType = "",
  });

  /// Helper getters for forum type detection
  bool get isGzipSupported => contentEncoding.toLowerCase().trim() == 'gzip';
  bool get isProboards => version.toLowerCase() == 'proboards';
  bool get isVb => version.toLowerCase().startsWith('vb');
  bool get isWBB => version.toLowerCase().startsWith('wbb');
  bool get isVb3 => version.toLowerCase().startsWith('vb3');
  bool get isVb4 => version.toLowerCase().startsWith('vb4');
  bool get isVb5 => version.toLowerCase().startsWith('vb5');
  bool get isMB => version.toLowerCase().startsWith('mb');
  bool get isPB => version.toLowerCase().startsWith('pb');
  bool get isBB => version.toLowerCase().startsWith('bb');
  bool get isBB11 => version.toLowerCase().startsWith('bb11');
  bool get isIP => version.toLowerCase().startsWith('ip');
  bool get isIP3 => version.toLowerCase().startsWith('ip3');
  bool get isIP4 => version.toLowerCase().startsWith('ip4');
  bool get isVN => version.toLowerCase().startsWith('vn');
  bool get isXF => version.toLowerCase().startsWith('xf');
  bool get isKN1 => version.toLowerCase().startsWith('kn1');
  bool get isKN2 => version.toLowerCase().startsWith('kn2');
  bool get isKN3 => version.toLowerCase().startsWith('kn30');
  bool get isKN4 => version.toLowerCase().startsWith('kn40');
  bool get isKN5 => version.toLowerCase().startsWith('kn50');
  bool get isKN => version.toLowerCase().startsWith('kn');
  bool get isSMF => version.toLowerCase().startsWith('sm');
  bool get isSMF1 => version.toLowerCase().startsWith('sm20');
  bool get isSMF2 => version.toLowerCase().startsWith('sm-2');
}
