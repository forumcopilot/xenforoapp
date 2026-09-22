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

  /// Display name of whoever posted most recently in the topic.
  ///
  /// Distinct from [authorName], which is whoever *started* it. Forum web
  /// UIs lead their topic rows with "X replied 2 hours ago", because on a
  /// busy list the last voice is the reason to open a topic and the
  /// original author usually is not.
  ///
  /// Null when the platform does not report it, or when nobody has replied
  /// yet — a topic whose only post is the opening one has no last *poster*
  /// distinct from its author, and callers should fall back to [timestamp].
  String? lastPosterName;

  /// Avatar for [lastPosterName], ready to load. Null when unavailable.
  String? lastPosterIconUrl;

  /// When the most recent post landed, for the "replied 2 hours ago" half
  /// of the line. Null when unreported; [timestamp] (topic creation) is the
  /// fallback, but the two mean different things — do not conflate them.
  @MappableField(hook: MillisOrIsoDateHook())
  DateTime? lastPostedAt;

  /// Whether the platform flags this topic as currently hot / trending
  /// (Discourse: `is_hot`, its own popularity heuristic — not a count the
  /// client can derive). False when unreported.
  bool isHot;

  /// How many distinct people have posted in the topic, as the server
  /// counts them (Discourse: `participant_count`).
  ///
  /// Not the same as `participatedUserIds.length`: that list is a capped
  /// *summary* of posters, so on a busy topic it under-reports. Prefer this
  /// when showing a number; use the id list when you need the identities.
  int participantCount;

  /// How many outbound links the topic contains (Discourse:
  /// `details.links`). 0 when unreported.
  int linkCount;

  /// How many people have voted for this topic, where the platform has a
  /// voting concept (Discourse: the `discourse-topic-voting` plugin's
  /// `vote_count`). 0 when voting is off or unreported.
  int voteCount;

  /// Whether the current viewer may cast a vote here (`can_vote`). False
  /// for guests, for forums without voting, and in categories where it is
  /// not enabled — the server's answer, not a guess from vote_count.
  bool canVote;

  /// Whether the viewer has already voted (`user_voted`).
  bool userVoted;

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

  /// Avatar URLs for [participatedUserIds], in the same order and ready to
  /// load.
  ///
  /// Forum web UIs show a cluster of participant faces on each topic row —
  /// on a busy list that is the fastest signal of who is in a conversation.
  /// Kept parallel to the id list rather than folded into it because the
  /// ids are useful on their own, and a platform may know who took part
  /// without being able to picture them.
  List<String> participantIconUrls;

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

  /// How many unread posts the topic has for the current user
  /// (Discourse: `unread_posts`). 0 when fully read, unknown, or the
  /// viewer is a guest; [hasNewPosts] stays the boolean signal.
  int unreadCount;

  /// Topic tags. First-class on Discourse (`tags:[...]`); backends
  /// without tags leave this empty. UI surfaces these as chips.
  List<String> tags;

  /// Whether any post in this topic has been marked as the accepted
  /// answer (Discourse: `has_accepted_answer:true`, requires the
  /// discourse-solved plugin).
  bool isSolved;

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
    this.unreadCount = 0,
    this.tags = const [],
    this.isSolved = false,
    // Optional with no default beyond null: a platform that cannot report
    // the last poster leaves these unset, and the UI falls back to the
    // topic's own author/timestamp rather than rendering a wrong name.
    this.lastPosterName,
    this.lastPosterIconUrl,
    this.lastPostedAt,
    this.isHot = false,
    this.participantCount = 0,
    this.linkCount = 0,
    this.participantIconUrls = const [],
    this.voteCount = 0,
    this.canVote = false,
    this.userVoted = false,
  });
}
