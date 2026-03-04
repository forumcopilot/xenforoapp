import 'package:dart_mappable/dart_mappable.dart';

part 'user.mapper.dart';

/// XenForo user model based on official API documentation
@MappableClass()
class XenForoUser with XenForoUserMappable {
  /// User ID
  final int userId;

  /// Username
  final String username;

  /// Email address
  final String? email;

  /// User group ID
  final int? userGroupId;

  /// User title
  final String? userTitle;

  /// Custom title
  final String? customTitle;

  /// About
  final String? about;

  /// Activity visible
  final bool? activityVisible;

  /// Age
  final int? age;

  /// Alert optout
  final List<String>? alertOptout;

  /// Allow post profile
  final String? allowPostProfile;

  /// Allow receive news feed
  final String? allowReceiveNewsFeed;

  /// Allow send personal conversation
  final String? allowSendPersonalConversation;

  /// Allow view identities
  final String? allowViewIdentities;

  /// Allow view profile
  final String? allowViewProfile;

  /// Avatar URLs
  final Map<String, String>? avatarUrls;

  /// Profile banner URLs
  final Map<String, String>? profileBannerUrls;

  /// Can ban
  final bool? canBan;

  /// Can converse
  final bool? canConverse;

  /// Can edit
  final bool? canEdit;

  /// Can follow
  final bool? canFollow;

  /// Can ignore
  final bool? canIgnore;

  /// Can post profile
  final bool? canPostProfile;

  /// Can view profile
  final bool? canViewProfile;

  /// Can view profile posts
  final bool? canViewProfilePosts;

  /// Can warn
  final bool? canWarn;

  /// Content show signature
  final bool? contentShowSignature;

  /// Creation watch state
  final String? creationWatchState;

  /// Custom fields
  final Map<String, dynamic>? customFields;

  /// Date of birth
  final Map<String, dynamic>? dob;

  /// Email on conversation
  final bool? emailOnConversation;

  /// Gravatar
  final String? gravatar;

  /// Interaction watch state
  final bool? interactionWatchState;

  /// Is admin
  final bool? isAdmin;

  /// Is banned
  final bool? isBanned;

  /// Is discouraged
  final bool? isDiscouraged;

  /// Is followed
  final bool? isFollowed;

  /// Is ignored
  final bool? isIgnored;

  /// Is moderator
  final bool? isModerator;

  /// Is super admin
  final bool? isSuperAdmin;

  /// Last activity (Unix timestamp)
  final int? lastActivity;

  /// Location
  final String? location;

  /// Push on conversation
  final bool? pushOnConversation;

  /// Push optout
  final List<String>? pushOptout;

  /// Receive admin email
  final bool? receiveAdminEmail;

  /// Secondary group IDs
  final List<int>? secondaryGroupIds;

  /// Show DOB date
  final bool? showDobDate;

  /// Show DOB year
  final bool? showDobYear;

  /// Signature
  final String? signature;

  /// Timezone
  final String? timezone;

  /// Use TFA
  final bool? useTfa;

  /// User state
  final String? userState;

  /// Visible
  final bool? visible;

  /// Warning points
  final int? warningPoints;

  /// Website
  final String? website;

  /// View URL
  final String? viewUrl;

  /// Message count
  final int? messageCount;

  /// Question solution count
  final int? questionSolutionCount;

  /// Register date (Unix timestamp)
  final int? registerDate;

  /// Trophy points
  final int? trophyPoints;

  /// Is staff
  final bool? isStaff;

  /// Reaction score
  final int? reactionScore;

  /// Vote score
  final int? voteScore;

  const XenForoUser({
    required this.userId,
    required this.username,
    this.email,
    this.userGroupId,
    this.userTitle,
    this.customTitle,
    this.about,
    this.activityVisible,
    this.age,
    this.alertOptout,
    this.allowPostProfile,
    this.allowReceiveNewsFeed,
    this.allowSendPersonalConversation,
    this.allowViewIdentities,
    this.allowViewProfile,
    this.avatarUrls,
    this.profileBannerUrls,
    this.canBan,
    this.canConverse,
    this.canEdit,
    this.canFollow,
    this.canIgnore,
    this.canPostProfile,
    this.canViewProfile,
    this.canViewProfilePosts,
    this.canWarn,
    this.contentShowSignature,
    this.creationWatchState,
    this.customFields,
    this.dob,
    this.emailOnConversation,
    this.gravatar,
    this.interactionWatchState,
    this.isAdmin,
    this.isBanned,
    this.isDiscouraged,
    this.isFollowed,
    this.isIgnored,
    this.isModerator,
    this.isSuperAdmin,
    this.lastActivity,
    this.location,
    this.pushOnConversation,
    this.pushOptout,
    this.receiveAdminEmail,
    this.secondaryGroupIds,
    this.showDobDate,
    this.showDobYear,
    this.signature,
    this.timezone,
    this.useTfa,
    this.userState,
    this.visible,
    this.warningPoints,
    this.website,
    this.viewUrl,
    this.messageCount,
    this.questionSolutionCount,
    this.registerDate,
    this.trophyPoints,
    this.isStaff,
    this.reactionScore,
    this.voteScore,
  });

  /// Create from JSON response
  factory XenForoUser.fromJson(Map<String, dynamic> json) {
    return XenForoUser(
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'],
      userGroupId: json['user_group_id'],
      userTitle: json['user_title'],
      customTitle: json['custom_title'],
      about: json['about'],
      activityVisible: json['activity_visible'],
      age: json['age'],
      alertOptout: json['alert_optout'] != null ? List<String>.from(json['alert_optout']) : null,
      allowPostProfile: json['allow_post_profile'],
      allowReceiveNewsFeed: json['allow_receive_news_feed'],
      allowSendPersonalConversation: json['allow_send_personal_conversation'],
      allowViewIdentities: json['allow_view_identities'],
      allowViewProfile: json['allow_view_profile'],
      avatarUrls: json['avatar_urls'] != null ? Map<String, String>.from(json['avatar_urls'].map((key, value) => MapEntry(key, value?.toString() ?? ''))) : null,
      profileBannerUrls: json['profile_banner_urls'] != null ? Map<String, String>.from(json['profile_banner_urls'].map((key, value) => MapEntry(key, value?.toString() ?? ''))) : null,
      canBan: json['can_ban'],
      canConverse: json['can_converse'],
      canEdit: json['can_edit'],
      canFollow: json['can_follow'],
      canIgnore: json['can_ignore'],
      canPostProfile: json['can_post_profile'],
      canViewProfile: json['can_view_profile'],
      canViewProfilePosts: json['can_view_profile_posts'],
      canWarn: json['can_warn'],
      contentShowSignature: json['content_show_signature'],
      creationWatchState: json['creation_watch_state'],
      customFields: json['custom_fields'] as Map<String, dynamic>?,
      dob: json['dob'] as Map<String, dynamic>?,
      emailOnConversation: json['email_on_conversation'],
      gravatar: json['gravatar'],
      interactionWatchState: json['interaction_watch_state'],
      isAdmin: json['is_admin'],
      isBanned: json['is_banned'],
      isDiscouraged: json['is_discouraged'],
      isFollowed: json['is_followed'],
      isIgnored: json['is_ignored'],
      isModerator: json['is_moderator'],
      isSuperAdmin: json['is_super_admin'],
      lastActivity: json['last_activity'],
      location: json['location'],
      pushOnConversation: json['push_on_conversation'],
      pushOptout: json['push_optout'] != null ? List<String>.from(json['push_optout']) : null,
      receiveAdminEmail: json['receive_admin_email'],
      secondaryGroupIds: json['secondary_group_ids'] != null ? List<int>.from(json['secondary_group_ids']) : null,
      showDobDate: json['show_dob_date'],
      showDobYear: json['show_dob_year'],
      signature: json['signature'],
      timezone: json['timezone'],
      useTfa: json['use_tfa'],
      userState: json['user_state'],
      visible: json['visible'],
      warningPoints: json['warning_points'],
      website: json['website'],
      viewUrl: json['view_url'],
      messageCount: json['message_count'],
      questionSolutionCount: json['question_solution_count'],
      registerDate: json['register_date'],
      trophyPoints: json['trophy_points'],
      isStaff: json['is_staff'],
      reactionScore: json['reaction_score'],
      voteScore: json['vote_score'],
    );
  }

  // Convenience getters for backward compatibility
  String get id => userId.toString();
  String get displayName => username;
  String? get avatarUrl => avatarUrls?['o'] ?? avatarUrls?['m'] ?? avatarUrls?['s'];
  DateTime? get registrationDate => registerDate != null ? DateTime.fromMillisecondsSinceEpoch(registerDate! * 1000) : null;
  DateTime? get lastActivityDate => lastActivity != null ? DateTime.fromMillisecondsSinceEpoch(lastActivity! * 1000) : null;
  bool get isOnline => lastActivity != null && (DateTime.now().millisecondsSinceEpoch / 1000 - lastActivity!) < 300; // 5 minutes
  int get postCount => messageCount ?? 0;
  int get reputation => trophyPoints ?? 0;
  bool get isVerified => !(isBanned ?? false);
}
