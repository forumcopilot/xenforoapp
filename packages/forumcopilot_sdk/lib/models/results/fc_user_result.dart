import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/entities/fc_user.dart';
import 'package:forumcopilot_sdk/models/entities/fc_tfa_provider.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_user_result.mapper.dart';

/// Forum Copilot Login Result
/// Maps from LoginData_Output
@MappableClass()
class FCLoginResult extends FCBaseResult with FCLoginResultMappable {
  /// User information
  FCUser? user;

  /// Return false if this user does not have permission to see current list of online user
  bool canWhosonline;

  /// Return false if this user does not have permission to user profile page
  bool canProfile;

  /// Return true if this user can modify his avatar
  bool canUploadAvatar;

  /// Return the maximum allowed attachments the user can upload in a single post
  int maxAttachment;

  /// Return the maximum allowed PNG file size that the user can upload (in bytes)
  int maxPngSize;

  /// Return the maximum allowed JPEG file size that the user can upload (in bytes)
  int maxJpgSize;

  /// A list of ignored user ids, separated with comma
  String? ignoredUids;

  /// Allowed file extensions for attachments
  String? allowedExtensions;

  /// Whether user can upload attachments to forum posts
  bool canUploadAttachment;

  /// Whether user can upload attachments to conversation messages
  bool canUploadConversationAttachment;

  /// Maximum file size in bytes (applies to all file types)
  int maxAttachmentSize;

  /// Allowed file extensions as array
  List<String>? allowedFileExtensions;

  /// Maximum image width in pixels (0 = no limit)
  int maxImageWidth;

  /// Maximum image height in pixels (0 = no limit)
  int maxImageHeight;

  /// Post countdown time in seconds
  int postCountdown;

  /// Trust code for authentication
  String? trustCode;

  /// Whether two-step authentication is required (deprecated, use tfaRequired)
  bool twoStepRequired;

  /// Whether two-factor authentication is required
  bool tfaRequired;

  /// List of available TFA providers
  List<FCTFAProvider>? providers;

  /// Default/recommended provider ID
  String? providerId;

  /// Whether passkey TFA is available
  bool passkeyAvailable;

  /// Whether code-based TFA is available
  bool codeAvailable;

  /// Passkey challenge for TFA
  String? passkeyChallenge;

  /// Passkey relying party ID
  String? passkeyRpId;

  /// Passkey timeout (ms)
  int? passkeyTimeout;

  /// User password (for internal use)
  String? userpassword;

  /// Whether the URL is problematic
  bool isProblematicUrl;

  FCLoginResult({
    required bool result,
    required String resultText,
    this.user,
    this.canWhosonline = false,
    this.canProfile = false,
    this.canUploadAvatar = false,
    this.maxAttachment = 0,
    this.maxPngSize = 0,
    this.maxJpgSize = 0,
    this.ignoredUids,
    this.allowedExtensions,
    this.canUploadAttachment = false,
    this.canUploadConversationAttachment = false,
    this.maxAttachmentSize = 0,
    this.allowedFileExtensions,
    this.maxImageWidth = 0,
    this.maxImageHeight = 0,
    this.postCountdown = 0,
    this.trustCode,
    this.twoStepRequired = false,
    this.tfaRequired = false,
    this.providers,
    this.providerId,
    this.passkeyAvailable = false,
    this.codeAvailable = false,
    this.passkeyChallenge,
    this.passkeyRpId,
    this.passkeyTimeout,
    this.userpassword,
    this.isProblematicUrl = false,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Login Two Step Result
/// Maps from LoginTwoStepData_Output
@MappableClass()
class FCLoginTwoStepResult extends FCUser with FCLoginTwoStepResultMappable {
  /// Whether the operation was successful
  bool result;

  /// Result message or error text (only present when result = false)
  String? resultText;

  /// Can see who's online
  bool canWhosonline;

  /// Can access profile
  bool canProfile;

  /// Can upload avatar
  bool canUploadAvatar;

  /// Max attachment
  int maxAttachment;

  /// Max PNG size
  int maxPngSize;

  /// Max JPG size
  int maxJpgSize;

  /// Ignored user IDs
  String? ignoredUids;

  /// Allowed extensions
  String? allowedExtensions;

  /// Post countdown
  int postCountdown;

  /// Trust code
  String? trustCode;

  /// Two step required
  bool twoStepRequired;

  /// User password
  String? userpassword;

  /// Is problematic URL
  bool isProblematicUrl;

  FCLoginTwoStepResult({
    required this.result,
    this.resultText,
    // FCUser required fields
    required String id,
    required String username,
    // FCUser optional fields
    String? loginName,
    String? email,
    String? userType,
    String? iconUrl,
    int postCount = 0,
    DateTime? registrationTime,
    DateTime? lastActivityTime,
    bool isOnline = false,
    String? currentActivity,
    String? currentTopicId,
    bool acceptsPM = false,
    bool canSendPM = false,
    bool canPM = false,
    bool isFollowing = false,
    bool isFollowingMe = false,
    bool acceptsFollowers = false,
    int followingCount = 0,
    int followerCount = 0,
    String? displayText,
    List<FCUserCustomField> customFields = const [],
    bool canBan = false,
    bool isBanned = false,
    bool isIgnored = false,
    bool canSpamClean = false,
    bool canBeReported = false,
    List<String> userGroups = const [],
    bool canModerate = false,
    bool canSearch = false,
    String? userState = 'valid',
    // FCLoginTwoStepResult specific fields
    this.canWhosonline = false,
    this.canProfile = false,
    this.canUploadAvatar = false,
    this.maxAttachment = 0,
    this.maxPngSize = 0,
    this.maxJpgSize = 0,
    this.ignoredUids,
    this.allowedExtensions,
    this.postCountdown = 0,
    this.trustCode,
    this.twoStepRequired = false,
    this.userpassword,
    this.isProblematicUrl = false,
  }) : super(
          id: id,
          username: username,
          loginName: loginName,
          email: email,
          userType: userType,
          iconUrl: iconUrl,
          postCount: postCount,
          registrationTime: registrationTime,
          lastActivityTime: lastActivityTime,
          isOnline: isOnline,
          currentActivity: currentActivity,
          currentTopicId: currentTopicId,
          acceptsPM: acceptsPM,
          canSendPM: canSendPM,
          canPM: canPM,
          isFollowing: isFollowing,
          isFollowingMe: isFollowingMe,
          acceptsFollowers: acceptsFollowers,
          followingCount: followingCount,
          followerCount: followerCount,
          displayText: displayText,
          customFields: customFields,
          canBan: canBan,
          isBanned: isBanned,
          isIgnored: isIgnored,
          canSpamClean: canSpamClean,
          canBeReported: canBeReported,
          userGroups: userGroups,
          canModerate: canModerate,
          canSearch: canSearch,
          userState: userState,
        );
}

/// Forum Copilot Online User Result
/// Maps from OnlineUserData_Output
@MappableClass()
class FCOnlineUserResult extends FCBaseResult with FCOnlineUserResultMappable {
  /// Total number of online users
  int total;

  /// List of online users
  List<FCOnlineUser> list;

  FCOnlineUserResult({
    required bool result,
    String? resultText,
    this.total = 0,
    this.list = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Online User
/// Maps from OnlineUser
@MappableClass()
class FCOnlineUser extends FCUser with FCOnlineUserMappable {
  /// Current location/activity
  String? location;

  FCOnlineUser({
    // FCUser required fields
    required String id,
    required String username,
    // FCUser optional fields
    String? loginName,
    String? email,
    String? userType,
    String? iconUrl,
    int postCount = 0,
    DateTime? registrationTime,
    DateTime? lastActivityTime,
    bool isOnline = false,
    String? currentActivity,
    String? currentTopicId,
    bool acceptsPM = false,
    bool canSendPM = false,
    bool canPM = false,
    bool isFollowing = false,
    bool isFollowingMe = false,
    bool acceptsFollowers = false,
    int followingCount = 0,
    int followerCount = 0,
    String? displayText,
    List<FCUserCustomField> customFields = const [],
    bool canBan = false,
    bool isBanned = false,
    bool isIgnored = false,
    bool canSpamClean = false,
    bool canBeReported = false,
    List<String> userGroups = const [],
    bool canModerate = false,
    bool canSearch = false,
    String? userState = 'valid',
    // FCOnlineUser specific fields
    this.location,
  }) : super(
          id: id,
          username: username,
          loginName: loginName,
          email: email,
          userType: userType,
          iconUrl: iconUrl,
          postCount: postCount,
          registrationTime: registrationTime,
          lastActivityTime: lastActivityTime,
          isOnline: isOnline,
          currentActivity: currentActivity,
          currentTopicId: currentTopicId,
          acceptsPM: acceptsPM,
          canSendPM: canSendPM,
          canPM: canPM,
          isFollowing: isFollowing,
          isFollowingMe: isFollowingMe,
          acceptsFollowers: acceptsFollowers,
          followingCount: followingCount,
          followerCount: followerCount,
          displayText: displayText,
          customFields: customFields,
          canBan: canBan,
          isBanned: isBanned,
          isIgnored: isIgnored,
          canSpamClean: canSpamClean,
          canBeReported: canBeReported,
          userGroups: userGroups,
          canModerate: canModerate,
          canSearch: canSearch,
        );
}

/// Forum Copilot User Info Result
/// Maps from UserInfoData_Output
@MappableClass()
class FCUserInfoResult extends FCUser with FCUserInfoResultMappable {
  /// Whether the operation was successful
  bool result;

  /// Result message or error text (only present when result = false)
  String? resultText;

  /// User status
  String? status;

  /// User signature
  String? signature;

  /// User location
  String? location;

  /// User website
  String? website;

  /// User interests
  String? interests;

  /// User occupation
  String? occupation;

  /// User bio
  String? bio;

  /// Registration time (compatibility)
  DateTime? regTime;

  /// Is online (compatibility)
  bool? infoIsOnline;

  /// Accept PM (compatibility)
  bool? acceptPm;

  /// Can PM (compatibility)
  bool? canPm;

  /// Can send PM (compatibility)
  bool? canSendPm;

  /// I follow you (compatibility)
  bool? iFollowU;

  /// You follow me (compatibility)
  bool? uFollowMe;

  /// Accept follow (compatibility)
  bool? acceptFollow;

  /// Following count (compatibility)
  int? infoFollowingCount;

  /// Follower (compatibility)
  String? follower;

  /// Current activity (compatibility)
  String? infoCurrentActivity;

  /// Current action (compatibility)
  String? currentAction;

  /// Topic ID (compatibility)
  String? topicId;

  /// Custom fields list (compatibility)
  List<dynamic>? customFieldsList;

  /// Can ban (compatibility)
  bool? infoCanBan;

  /// Is ban (compatibility)
  bool? isBan;

  /// Can mark spam (compatibility)
  bool? canMarkSpam;

  /// Is ignored (compatibility)
  bool? infoIsIgnored;

  FCUserInfoResult({
    required this.result,
    this.resultText,
    // FCUser required fields
    required String id,
    required String username,
    // FCUser optional fields
    String? loginName,
    String? email,
    String? userType,
    String? iconUrl,
    int postCount = 0,
    DateTime? registrationTime,
    DateTime? lastActivityTime,
    bool isOnline = false,
    String? currentActivity,
    String? currentTopicId,
    bool acceptsPM = false,
    bool canSendPM = false,
    bool canPM = false,
    bool isFollowing = false,
    bool isFollowingMe = false,
    bool acceptsFollowers = false,
    int followingCount = 0,
    int followerCount = 0,
    String? displayText,
    List<FCUserCustomField> customFields = const [],
    bool canBan = false,
    bool isBanned = false,
    bool isIgnored = false,
    bool canSpamClean = false,
    bool canBeReported = false,
    List<String> userGroups = const [],
    bool canModerate = false,
    bool canSearch = false,
    String? userState = 'valid',
    // FCUserInfoResult specific fields
    this.status,
    this.signature,
    this.location,
    this.website,
    this.interests,
    this.occupation,
    this.bio,
    this.regTime,
    this.infoIsOnline,
    this.acceptPm,
    this.canPm,
    this.canSendPm,
    this.iFollowU,
    this.uFollowMe,
    this.acceptFollow,
    this.infoFollowingCount,
    this.follower,
    this.infoCurrentActivity,
    this.currentAction,
    this.topicId,
    this.customFieldsList,
    this.infoCanBan,
    this.isBan,
    this.canMarkSpam,
    this.infoIsIgnored,
  }) : super(
          id: id,
          username: username,
          loginName: loginName,
          email: email,
          userType: userType,
          iconUrl: iconUrl,
          postCount: postCount,
          registrationTime: registrationTime,
          lastActivityTime: lastActivityTime,
          isOnline: isOnline,
          currentActivity: currentActivity,
          currentTopicId: currentTopicId,
          acceptsPM: acceptsPM,
          canSendPM: canSendPM,
          canPM: canPM,
          isFollowing: isFollowing,
          isFollowingMe: isFollowingMe,
          acceptsFollowers: acceptsFollowers,
          followingCount: followingCount,
          followerCount: followerCount,
          displayText: displayText,
          customFields: customFields,
          canBan: canBan,
          isBanned: isBanned,
          isIgnored: isIgnored,
          canSpamClean: canSpamClean,
          canBeReported: canBeReported,
          userGroups: userGroups,
          canModerate: canModerate,
          canSearch: canSearch,
          userState: userState,
        );
}

/// Forum Copilot User Topic Result
/// Maps from UserTopicData_Output
@MappableClass()
class FCUserTopicResult extends FCBaseResult with FCUserTopicResultMappable {
  /// Total number of topics
  int total;

  /// List of topics
  List<FCUserTopic> list;

  FCUserTopicResult({
    required bool result,
    String? resultText,
    this.total = 0,
    this.list = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot User Topic
/// Maps from UserTopic
@MappableClass()
class FCUserTopic with FCUserTopicMappable {
  /// Topic ID
  String topicId;

  /// Topic title
  String topicTitle;

  /// Forum ID
  String forumId;

  /// Forum name
  String forumName;

  /// Author ID
  String authorId;

  /// Author name
  String authorName;

  /// Post time
  DateTime postTime;

  /// Reply count
  int replyCount;

  /// View count
  int viewCount;

  /// Whether the topic is closed
  bool isClosed;

  /// Whether the topic is sticky
  bool isSticky;

  /// Whether the topic is announcement
  bool isAnnouncement;

  /// Short content
  String? shortContent;

  FCUserTopic({
    required this.topicId,
    required this.topicTitle,
    required this.forumId,
    required this.forumName,
    required this.authorId,
    required this.authorName,
    required this.postTime,
    this.replyCount = 0,
    this.viewCount = 0,
    this.isClosed = false,
    this.isSticky = false,
    this.isAnnouncement = false,
    this.shortContent,
  });
}

/// Forum Copilot User Reply Result
/// Maps from UserReplyData_Output
@MappableClass()
class FCUserReplyResult extends FCBaseResult with FCUserReplyResultMappable {
  /// Total number of replies
  int total;

  /// List of replies
  List<FCUserReply> list;

  /// Posts (compatibility alias for list)
  List<FCUserReply> get posts => list;

  FCUserReplyResult({
    required bool result,
    String? resultText,
    this.total = 0,
    this.list = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot User Reply
/// Maps from UserReply
@MappableClass()
class FCUserReply with FCUserReplyMappable {
  /// Post ID
  String postId;

  /// Topic ID
  String topicId;

  /// Topic title
  String topicTitle;

  /// Forum ID
  String forumId;

  /// Forum name
  String forumName;

  /// Reply number
  int replyNumber;

  /// Author ID
  String authorId;

  /// Author name
  String authorName;

  /// Author icon URL
  String? authorIconUrl;

  /// Post time
  DateTime postTime;

  /// Post content
  String? postContent;

  /// Short content
  String? shortContent;

  FCUserReply({
    required this.postId,
    required this.topicId,
    required this.topicTitle,
    required this.forumId,
    required this.forumName,
    required this.authorId,
    required this.authorName,
    required this.authorIconUrl,
    required this.postTime,
    this.replyNumber = 0,
    this.postContent,
    this.shortContent,
  });
}

/// Forum Copilot Recommended User Result
/// Maps from RecomendedUserData_Output
@MappableClass()
class FCRecommendedUserResult extends FCBaseResult with FCRecommendedUserResultMappable {
  /// Total number of recommended users
  int total;

  /// List of recommended users
  List<FCRecommendedUser> list;

  FCRecommendedUserResult({
    required bool result,
    String? resultText,
    this.total = 0,
    this.list = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Recommended User
/// Maps from RecomendedUser
@MappableClass()
class FCRecommendedUser extends FCUser with FCRecommendedUserMappable {
  /// User status
  String? status;

  FCRecommendedUser({
    // FCUser required fields
    required String id,
    required String username,
    // FCUser optional fields
    String? loginName,
    String? email,
    String? userType,
    String? iconUrl,
    int postCount = 0,
    DateTime? registrationTime,
    DateTime? lastActivityTime,
    bool isOnline = false,
    String? currentActivity,
    String? currentTopicId,
    bool acceptsPM = false,
    bool canSendPM = false,
    bool canPM = false,
    bool isFollowing = false,
    bool isFollowingMe = false,
    bool acceptsFollowers = false,
    int followingCount = 0,
    int followerCount = 0,
    String? displayText,
    List<FCUserCustomField> customFields = const [],
    bool canBan = false,
    bool isBanned = false,
    bool isIgnored = false,
    bool canSpamClean = false,
    bool canBeReported = false,
    List<String> userGroups = const [],
    bool canModerate = false,
    bool canSearch = false,
    String? userState = 'valid',
    // FCRecommendedUser specific fields
    this.status,
  }) : super(
          id: id,
          username: username,
          loginName: loginName,
          email: email,
          userType: userType,
          iconUrl: iconUrl,
          postCount: postCount,
          registrationTime: registrationTime,
          lastActivityTime: lastActivityTime,
          isOnline: isOnline,
          currentActivity: currentActivity,
          currentTopicId: currentTopicId,
          acceptsPM: acceptsPM,
          canSendPM: canSendPM,
          canPM: canPM,
          isFollowing: isFollowing,
          isFollowingMe: isFollowingMe,
          acceptsFollowers: acceptsFollowers,
          followingCount: followingCount,
          followerCount: followerCount,
          displayText: displayText,
          customFields: customFields,
          canBan: canBan,
          isBanned: isBanned,
          isIgnored: isIgnored,
          canSpamClean: canSpamClean,
          canBeReported: canBeReported,
          userGroups: userGroups,
          canModerate: canModerate,
          canSearch: canSearch,
          userState: userState,
        );
}

/// Forum Copilot Search User Result
/// Maps from SearchUserData_Output
@MappableClass()
class FCSearchUserResult extends FCBaseResult with FCSearchUserResultMappable {
  /// Total number of users found
  int total;

  /// List of users
  List<FCSearchUser> list;

  FCSearchUserResult({
    required bool result,
    String? resultText,
    this.total = 0,
    this.list = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Search User
/// Maps from SearchUser
@MappableClass()
class FCSearchUser extends FCUser with FCSearchUserMappable {
  /// User status
  String? status;

  FCSearchUser({
    // FCUser required fields
    required String id,
    required String username,
    // FCUser optional fields
    String? loginName,
    String? email,
    String? userType,
    String? iconUrl,
    int postCount = 0,
    DateTime? registrationTime,
    DateTime? lastActivityTime,
    bool isOnline = false,
    String? currentActivity,
    String? currentTopicId,
    bool acceptsPM = false,
    bool canSendPM = false,
    bool canPM = false,
    bool isFollowing = false,
    bool isFollowingMe = false,
    bool acceptsFollowers = false,
    int followingCount = 0,
    int followerCount = 0,
    String? displayText,
    List<FCUserCustomField> customFields = const [],
    bool canBan = false,
    bool isBanned = false,
    bool isIgnored = false,
    bool canSpamClean = false,
    bool canBeReported = false,
    List<String> userGroups = const [],
    bool canModerate = false,
    bool canSearch = false,
    String? userState = 'valid',
    // FCSearchUser specific fields
    this.status,
  }) : super(
          id: id,
          username: username,
          loginName: loginName,
          email: email,
          userType: userType,
          iconUrl: iconUrl,
          postCount: postCount,
          registrationTime: registrationTime,
          lastActivityTime: lastActivityTime,
          isOnline: isOnline,
          currentActivity: currentActivity,
          currentTopicId: currentTopicId,
          acceptsPM: acceptsPM,
          canSendPM: canSendPM,
          canPM: canPM,
          isFollowing: isFollowing,
          isFollowingMe: isFollowingMe,
          acceptsFollowers: acceptsFollowers,
          followingCount: followingCount,
          followerCount: followerCount,
          displayText: displayText,
          customFields: customFields,
          canBan: canBan,
          isBanned: isBanned,
          isIgnored: isIgnored,
          canSpamClean: canSpamClean,
          canBeReported: canBeReported,
          userGroups: userGroups,
          canModerate: canModerate,
          canSearch: canSearch,
        );
}

/// Forum Copilot Report User Result
/// Maps from ReportUserData_Output
@MappableClass()
class FCReportUserResult extends FCBaseResult with FCReportUserResultMappable {
  FCReportUserResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Ignore User Result
/// Maps from IgnoreUserData_Output
@MappableClass()
class FCIgnoreUserResult extends FCBaseResult with FCIgnoreUserResultMappable {
  FCIgnoreUserResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Ignored User Result
/// Maps from IgnoredUserData_Output
@MappableClass()
class FCIgnoredUserResult extends FCBaseResult with FCIgnoredUserResultMappable {
  /// Total number of ignored users
  int total;

  /// List of ignored users
  List<FCIgnoredUser> list;

  FCIgnoredUserResult({
    required bool result,
    String? resultText,
    this.total = 0,
    this.list = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Ignored User
/// Maps from IgnoredUser
@MappableClass()
class FCIgnoredUser extends FCUser with FCIgnoredUserMappable {
  /// User status
  String? status;

  FCIgnoredUser({
    // FCUser required fields
    required String id,
    required String username,
    // FCUser optional fields
    String? loginName,
    String? email,
    String? userType,
    String? iconUrl,
    int postCount = 0,
    DateTime? registrationTime,
    DateTime? lastActivityTime,
    bool isOnline = false,
    String? currentActivity,
    String? currentTopicId,
    bool acceptsPM = false,
    bool canSendPM = false,
    bool canPM = false,
    bool isFollowing = false,
    bool isFollowingMe = false,
    bool acceptsFollowers = false,
    int followingCount = 0,
    int followerCount = 0,
    String? displayText,
    List<FCUserCustomField> customFields = const [],
    bool canBan = false,
    bool isBanned = false,
    bool isIgnored = false,
    bool canSpamClean = false,
    bool canBeReported = false,
    List<String> userGroups = const [],
    bool canModerate = false,
    bool canSearch = false,
    String? userState = 'valid',
    // FCIgnoredUser specific fields
    this.status,
  }) : super(
          id: id,
          username: username,
          loginName: loginName,
          email: email,
          userType: userType,
          iconUrl: iconUrl,
          postCount: postCount,
          registrationTime: registrationTime,
          lastActivityTime: lastActivityTime,
          isOnline: isOnline,
          currentActivity: currentActivity,
          currentTopicId: currentTopicId,
          acceptsPM: acceptsPM,
          canSendPM: canSendPM,
          canPM: canPM,
          isFollowing: isFollowing,
          isFollowingMe: isFollowingMe,
          acceptsFollowers: acceptsFollowers,
          followingCount: followingCount,
          followerCount: followerCount,
          displayText: displayText,
          customFields: customFields,
          canBan: canBan,
          isBanned: isBanned,
          isIgnored: isIgnored,
          canSpamClean: canSpamClean,
          canBeReported: canBeReported,
          userGroups: userGroups,
          canModerate: canModerate,
          canSearch: canSearch,
        );
}
