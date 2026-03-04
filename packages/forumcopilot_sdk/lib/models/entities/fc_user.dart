import 'package:dart_mappable/dart_mappable.dart';

part 'fc_user.mapper.dart';

/// FCUser (Forum Consolidated User) is a unified user model for UI consumption
/// that abstracts away the specific implementation details of different user sources.
@MappableClass()
class FCUser with FCUserMappable {
  /// Unique identifier for the user
  String id;

  /// Username/display name of the user
  String username;

  /// Login name (may differ from display name)
  String? loginName;

  /// User's email address
  String? email;

  /// User type (e.g., admin, moderator, regular)
  String? userType;

  /// URL to the user's avatar/icon
  String? iconUrl;

  /// Total number of posts by this user
  int postCount;

  /// User registration time
  DateTime? registrationTime;

  /// Last activity time
  DateTime? lastActivityTime;

  /// Indicates if the user is currently online
  bool isOnline;

  /// Current activity or action the user is performing
  String? currentActivity;

  /// Topic ID related to current activity (if applicable)
  String? currentTopicId;

  /// Indicates if the user can receive private messages
  bool acceptsPM;

  /// Indicates if the current user can send PM to this user
  bool canSendPM;

  /// Indicates if the current user can PM at all
  bool canPM;

  /// Indicates if the current user is following this user
  bool isFollowing;

  /// Indicates if this user is following the current user
  bool isFollowingMe;

  /// Indicates if this user accepts followers
  bool acceptsFollowers;

  /// Number of users this user is following
  int followingCount;

  /// Number of users following this user
  int followerCount;

  /// Additional display text for the user profile
  String? displayText;

  /// List of custom fields for the user profile
  List<FCUserCustomField> customFields;

  /// Moderation capabilities
  bool canBan;

  /// Moderation statuses
  bool isBanned;
  bool isIgnored;

  /// Indicates if the user can be spam cleaned
  bool canSpamClean;

  /// Indicates if the user can be reported
  bool canBeReported;

  /// User groups this user belongs to
  List<String> userGroups;

  /// Capabilities and permissions
  bool canModerate;
  bool canSearch;

  /// User account state (valid, moderated, email_confirm, email_confirm_edit, email_bounce, rejected, disabled)
  String? userState;

  FCUser({
    required this.id,
    required this.username,
    this.loginName,
    this.email,
    this.userType,
    this.iconUrl,
    this.postCount = 0,
    this.registrationTime,
    this.lastActivityTime,
    this.isOnline = false,
    this.currentActivity,
    this.currentTopicId,
    this.acceptsPM = false,
    this.canSendPM = false,
    this.canPM = false,
    this.isFollowing = false,
    this.isFollowingMe = false,
    this.acceptsFollowers = false,
    this.followingCount = 0,
    this.followerCount = 0,
    this.displayText,
    this.customFields = const [],
    this.canBan = false,
    this.isBanned = false,
    this.isIgnored = false,
    this.canSpamClean = false,
    this.canBeReported = false,
    this.userGroups = const [],
    this.canModerate = false,
    this.canSearch = false,
    this.userState = 'valid',
  });
}

/// Custom field for user profiles
@MappableClass()
class FCUserCustomField with FCUserCustomFieldMappable {
  /// Field name
  String name;

  /// Field value
  String value;

  FCUserCustomField({
    required this.name,
    required this.value,
  });
}
