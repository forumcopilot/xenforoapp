import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/mapping/hooks.dart';
import 'fc_poll.dart';

part 'fc_topic.mapper.dart';

/// FCTopic (Forum Consolidated Topic) is a unified topic model for UI consumption
/// that abstracts away the specific implementation details of different topic sources.
@MappableClass()
class FCTopic with FCTopicMappable {
  /// Unique identifier for the topic
  String id;

  /// Title of the topic
  String title;

  /// Forum ID where this topic belongs
  String forumId;

  /// Forum name where this topic belongs
  String forumName;

  /// Optional prefix for the topic (category/tag)
  String? prefix;

  /// Author ID of the topic creator
  String authorId;

  /// Author name of the topic creator
  String authorName;

  /// Author user type (e.g., admin, moderator, user)
  String? authorUserType;

  /// URL to the author's avatar/icon
  String? authorIconUrl;

  /// Datetime timestamp as a string
  @MappableField(hook: MillisOrIsoDateHook())
  DateTime timestamp;

  /// Number of replies in the topic
  int replyCount;

  /// Number of views the topic has received
  int viewCount;

  /// Indicates if the topic has new/unread posts
  bool hasNewPosts;

  /// Indicates if the topic is closed/locked
  bool isClosed;

  /// Indicates if the topic is subscribed by the current user
  bool isSubscribed;

  /// Indicates if the user can subscribe to this topic
  bool canSubscribe;

  /// External URL to the topic
  String? url;

  /// Short preview of the topic content
  String? shortContent;

  /// List of user IDs who participated in this topic
  List<String> participatedUserIds;

  /// Indicates if the topic is pinned/sticky
  @MappableField(hook: FlexibleBoolHook())
  bool isPinned;

  /// Indicates if the topic is an announcement
  bool isAnnouncement;

  /// Indicates if the topic is from sticky fetch
  bool isStickySource;

  /// Moderation capabilities
  bool canRename;
  bool canDelete;
  bool canClose;
  bool canApprove;
  bool canStick;
  bool canMove;
  bool canMerge;
  bool canBan;

  /// User interaction capabilities
  bool canReply;
  bool canReport;
  bool canUpload;

  /// Moderation statuses
  bool isBanned;
  bool isApproved;
  bool isDeleted;
  bool isMoved;
  bool isMerged;

  /// Original topic ID if moved or merged
  String? realTopicId;

  /// Like/thank capabilities and status
  bool canLike;
  bool isLiked;
  int likeCount;
  bool canThank;

  /// Whether the thread has a poll (topic list and thread responses).
  bool hasPoll;

  /// Full poll data when thread has a poll; null otherwise. Only present in thread responses.
  FCPoll? poll;

  FCTopic({
    required this.id,
    required this.title,
    required this.forumId,
    required this.forumName,
    required this.authorId,
    required this.authorName,
    required this.timestamp,
    this.authorUserType,
    this.prefix,
    this.authorIconUrl,
    this.replyCount = 0,
    this.viewCount = 0,
    this.hasNewPosts = false,
    this.isClosed = false,
    this.isSubscribed = false,
    this.canSubscribe = true,
    this.url,
    this.shortContent,
    this.participatedUserIds = const [],
    this.isPinned = false,
    this.isAnnouncement = false,
    this.isStickySource = false,
    // Moderation capabilities
    this.canRename = false,
    this.canDelete = false,
    this.canClose = false,
    this.canApprove = false,
    this.canStick = false,
    this.canMove = false,
    this.canMerge = false,
    this.canBan = false,
    // User interaction capabilities
    this.canReply = false,
    this.canReport = false,
    this.canUpload = false,
    // Moderation statuses
    this.isBanned = false,
    this.isApproved = true,
    this.isDeleted = false,
    this.isMoved = false,
    this.isMerged = false,
    this.realTopicId,
    // Like/thank
    this.canLike = false,
    this.isLiked = false,
    this.likeCount = 0,
    this.canThank = false,
    this.hasPoll = false,
    this.poll,
  });
}
