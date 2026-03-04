import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_subscription_result.mapper.dart';

/// Forum Copilot Subscribed Forum Result
/// Maps from SubscribedForumData_Output
@MappableClass()
class FCSubscribedForumResult extends FCBaseResult with FCSubscribedForumResultMappable {
  /// Returns total number of subscribed forums
  int totalForumsNum;

  /// Returns an array of subscribed forums
  List<FCSubscribedForum> forums;

  // Compatibility properties for snake_case access
  int? get total_forums_num => totalForumsNum;

  FCSubscribedForumResult({
    required bool result,
    String? resultText,
    this.totalForumsNum = 0,
    this.forums = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Subscribed Forum
/// Maps from SubscribedForumData_Output_Forum
@MappableClass()
class FCSubscribedForum with FCSubscribedForumMappable {
  /// Forum ID
  String forumId;

  /// Forum name
  String forumName;

  /// An image URL to be displayed at the left hand side of the forum in the app
  String? iconUrl;

  /// Return true if this forum is a protected forum
  bool isProtected;

  /// Return true if there is new posts in this forum
  bool newPost;

  /// Return true if user can post in this forum
  bool? canPost;

  /// Return the notification mode of the subscribed topic
  int subscribeMode;

  /// Whether the forum is subscribed (always true for this class)
  bool isSubscribed;

  /// Whether the user can subscribe to the forum (always true for this class)
  bool canSubscribe;

  FCSubscribedForum({
    required this.forumId,
    required this.forumName,
    this.iconUrl,
    this.isProtected = false,
    this.newPost = false,
    this.canPost,
    this.subscribeMode = 0,
    this.isSubscribed = true,
    this.canSubscribe = true,
  });

  // Compatibility properties for snake_case access
  String? get forum_id => forumId;
  String? get forum_name => forumName;
  String? get icon_url => iconUrl;
  bool? get is_protected => isProtected;
  bool? get new_post => newPost;
  bool? get can_post => canPost;
  int? get subscribe_mode => subscribeMode;
  bool? get is_subscribed => isSubscribed;
  bool? get can_subscribe => canSubscribe;
}

/// Forum Copilot Subscribe Forum Result
/// Maps from SubscribeForumData_Output
@MappableClass()
class FCSubscribeForumResult extends FCBaseResult with FCSubscribeForumResultMappable {
  FCSubscribeForumResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Unsubscribe Forum Result
/// Maps from UnsubscribeForumData_Output
@MappableClass()
class FCUnsubscribeForumResult extends FCBaseResult with FCUnsubscribeForumResultMappable {
  FCUnsubscribeForumResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Subscribed Topic Result
/// Maps from SubscribedTopicData_Output
@MappableClass()
class FCSubscribedTopicResult extends FCBaseResult with FCSubscribedTopicResultMappable {
  /// Returns total number of subscribed topics
  int totalTopicNum;

  /// Returns an array of subscribed topics
  List<FCSubscribedTopic> topics;

  // Compatibility properties for snake_case access
  int? get total_topic_num => totalTopicNum;

  FCSubscribedTopicResult({
    required bool result,
    String? resultText,
    this.totalTopicNum = 0,
    this.topics = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Subscribed Topic
/// Maps from SubscribedTopic
@MappableClass()
class FCSubscribedTopic with FCSubscribedTopicMappable {
  /// Forum ID
  String forumId;

  /// Forum name
  String forumName;

  /// Topic ID
  String topicId;

  /// Topic title with all BBCode removed
  String topicTitle;

  /// Post author name
  String postAuthorName;

  /// Post author user type
  String? postAuthorUserType;

  /// Post author ID
  String postAuthorId;

  /// Whether the topic is closed
  bool isClosed;

  /// Topic author avatar URL
  String? iconUrl;

  /// Post time in ISO8601 format
  DateTime postTime;

  /// Unix timestamp format
  String? timestamp;

  /// Total number of replies in this topic
  int replyNumber;

  /// Whether this topic contains new posts since user last login
  bool newPost;

  /// Notification mode of the subscribed topic
  int subscribeMode;

  /// Total number of views for this topic
  int viewNumber;

  /// Short content with specific display rules
  String? shortContent;

  /// Whether the topic is sticky
  bool isSticky;

  /// Whether the topic is announcement
  bool isAnnouncement;

  /// Whether the topic is global announcement
  bool isGlobalAnnouncement;

  /// Whether the topic is locked
  bool isLocked;

  /// Whether the topic is moved
  bool isMoved;

  /// Whether the topic is poll
  bool isPoll;

  /// Whether the topic is voted
  bool isVoted;

  /// Whether the topic is hot
  bool isHot;

  /// Whether the topic is solved
  bool isSolved;

  /// Whether the topic is unsolved
  bool isUnsolved;

  /// Whether the topic is deleted
  bool isDeleted;

  /// Whether the topic is approved
  bool isApproved;

  /// Whether the topic is unapproved
  bool isUnapproved;

  /// Whether the topic is merged
  bool isMerged;

  /// Whether the topic is split
  bool isSplit;

  /// Whether the topic is moved to trash
  bool isMovedToTrash;

  /// Whether the topic is restored from trash
  bool isRestoredFromTrash;

  /// Whether the topic is pinned
  bool isPinned;

  /// Whether the topic is unpinned
  bool isUnpinned;

  /// Whether the topic is featured
  bool isFeatured;

  /// Whether the topic is unfeatured
  bool isUnfeatured;

  /// Whether the topic is highlighted
  bool isHighlighted;

  /// Whether the topic is unhighlighted
  bool isUnhighlighted;

  /// Whether the topic is bookmarked
  bool isBookmarked;

  /// Whether the topic is unbookmarked
  bool isUnbookmarked;

  /// Whether the topic is subscribed
  bool isSubscribed;

  /// Whether the topic is unsubscribed
  bool isUnsubscribed;

  /// Whether the topic is liked
  bool isLiked;

  /// Whether the topic is unliked
  bool isUnliked;

  /// Whether the topic is thanked
  bool isThanked;

  /// Whether the topic is unthanked
  bool isUnthanked;

  /// Whether the topic is reported
  bool isReported;

  /// Whether the topic is unreported
  bool isUnreported;

  /// Whether the topic is hidden
  bool isHidden;

  /// Whether the topic is unhidden
  bool isUnhidden;

  /// Whether the topic is archived
  bool isArchived;

  /// Whether the topic is unarchived
  bool isUnarchived;

  /// Whether the topic is locked for editing
  bool isLockedForEditing;

  /// Whether the topic is unlocked for editing
  bool isUnlockedForEditing;

  /// Whether the topic is locked for replies
  bool isLockedForReplies;

  /// Whether the topic is unlocked for replies
  bool isUnlockedForReplies;

  /// Whether the topic is locked for voting
  bool isLockedForVoting;

  /// Whether the topic is unlocked for voting
  bool isUnlockedForVoting;

  /// Whether the topic is locked for rating
  bool isLockedForRating;

  /// Whether the topic is unlocked for rating
  bool isUnlockedForRating;

  /// Whether the topic is locked for bookmarking
  bool isLockedForBookmarking;

  /// Whether the topic is unlocked for bookmarking
  bool isUnlockedForBookmarking;

  /// Whether the topic is locked for subscription
  bool isLockedForSubscription;

  /// Whether the topic is unlocked for subscription
  bool isUnlockedForSubscription;

  /// Whether the topic is locked for liking
  bool isLockedForLiking;

  /// Whether the topic is unlocked for liking
  bool isUnlockedForLiking;

  /// Whether the topic is locked for thanking
  bool isLockedForThanking;

  /// Whether the topic is unlocked for thanking
  bool isUnlockedForThanking;

  /// Whether the topic is locked for reporting
  bool isLockedForReporting;

  /// Whether the topic is unlocked for reporting
  bool isUnlockedForReporting;

  /// Whether the topic is locked for hiding
  bool isLockedForHiding;

  /// Whether the topic is unlocked for hiding
  bool isUnlockedForHiding;

  /// Whether the topic is locked for archiving
  bool isLockedForArchiving;

  /// Whether the topic is unlocked for archiving
  bool isUnlockedForArchiving;

  FCSubscribedTopic({
    required this.forumId,
    required this.forumName,
    required this.topicId,
    required this.topicTitle,
    required this.postAuthorName,
    this.postAuthorUserType,
    required this.postAuthorId,
    this.isClosed = false,
    this.iconUrl,
    required this.postTime,
    this.timestamp,
    this.replyNumber = 0,
    this.newPost = false,
    this.subscribeMode = 0,
    this.viewNumber = 0,
    this.shortContent,
    this.isSticky = false,
    this.isAnnouncement = false,
    this.isGlobalAnnouncement = false,
    this.isLocked = false,
    this.isMoved = false,
    this.isPoll = false,
    this.isVoted = false,
    this.isHot = false,
    this.isSolved = false,
    this.isUnsolved = false,
    this.isDeleted = false,
    this.isApproved = false,
    this.isUnapproved = false,
    this.isMerged = false,
    this.isSplit = false,
    this.isMovedToTrash = false,
    this.isRestoredFromTrash = false,
    this.isPinned = false,
    this.isUnpinned = false,
    this.isFeatured = false,
    this.isUnfeatured = false,
    this.isHighlighted = false,
    this.isUnhighlighted = false,
    this.isBookmarked = false,
    this.isUnbookmarked = false,
    this.isSubscribed = false,
    this.isUnsubscribed = false,
    this.isLiked = false,
    this.isUnliked = false,
    this.isThanked = false,
    this.isUnthanked = false,
    this.isReported = false,
    this.isUnreported = false,
    this.isHidden = false,
    this.isUnhidden = false,
    this.isArchived = false,
    this.isUnarchived = false,
    this.isLockedForEditing = false,
    this.isUnlockedForEditing = false,
    this.isLockedForReplies = false,
    this.isUnlockedForReplies = false,
    this.isLockedForVoting = false,
    this.isUnlockedForVoting = false,
    this.isLockedForRating = false,
    this.isUnlockedForRating = false,
    this.isLockedForBookmarking = false,
    this.isUnlockedForBookmarking = false,
    this.isLockedForSubscription = false,
    this.isUnlockedForSubscription = false,
    this.isLockedForLiking = false,
    this.isUnlockedForLiking = false,
    this.isLockedForThanking = false,
    this.isUnlockedForThanking = false,
    this.isLockedForReporting = false,
    this.isUnlockedForReporting = false,
    this.isLockedForHiding = false,
    this.isUnlockedForHiding = false,
    this.isLockedForArchiving = false,
    this.isUnlockedForArchiving = false,
  });

  // Compatibility properties for snake_case access
  String? get forum_id => forumId;
  String? get forum_name => forumName;
  String? get topic_id => topicId;
  String? get topic_title => topicTitle;
  String? get post_author_name => postAuthorName;
  String? get post_author_user_type => postAuthorUserType;
  String? get post_author_id => postAuthorId;
  bool? get is_closed => isClosed;
  String? get icon_url => iconUrl;
  DateTime? get post_time => postTime;
  int? get reply_number => replyNumber;
  bool? get new_post => newPost;
  int? get subscribe_mode => subscribeMode;
  int? get view_number => viewNumber;
  String? get short_content => shortContent;
  bool? get is_sticky => isSticky;
  bool? get is_announcement => isAnnouncement;
  bool? get is_global_announcement => isGlobalAnnouncement;
  bool? get is_locked => isLocked;
  bool? get is_moved => isMoved;
  bool? get is_poll => isPoll;
  bool? get is_voted => isVoted;
  bool? get is_hot => isHot;
  bool? get is_solved => isSolved;
  bool? get is_unsolved => isUnsolved;
  bool? get is_deleted => isDeleted;
  bool? get is_approved => isApproved;
  bool? get is_unapproved => isUnapproved;
  bool? get is_merged => isMerged;
  bool? get is_split => isSplit;
  bool? get is_moved_to_trash => isMovedToTrash;
  bool? get is_restored_from_trash => isRestoredFromTrash;
  bool? get is_pinned => isPinned;
  bool? get is_unpinned => isUnpinned;
  bool? get is_featured => isFeatured;
  bool? get is_unfeatured => isUnfeatured;
  bool? get is_highlighted => isHighlighted;
  bool? get is_unhighlighted => isUnhighlighted;
  bool? get is_bookmarked => isBookmarked;
  bool? get is_unbookmarked => isUnbookmarked;
  bool? get is_subscribed => isSubscribed;
  bool? get is_unsubscribed => isUnsubscribed;
  bool? get is_liked => isLiked;
  bool? get is_unliked => isUnliked;
  bool? get is_thanked => isThanked;
  bool? get is_unthanked => isUnthanked;
  bool? get is_reported => isReported;
  bool? get is_unreported => isUnreported;
  bool? get is_hidden => isHidden;
  bool? get is_unhidden => isUnhidden;
  bool? get is_archived => isArchived;
  bool? get is_unarchived => isUnarchived;
  bool? get is_locked_for_editing => isLockedForEditing;
  bool? get is_unlocked_for_editing => isUnlockedForEditing;
  bool? get is_locked_for_replies => isLockedForReplies;
  bool? get is_unlocked_for_replies => isUnlockedForReplies;
  bool? get is_locked_for_voting => isLockedForVoting;
  bool? get is_unlocked_for_voting => isUnlockedForVoting;
  bool? get is_locked_for_rating => isLockedForRating;
  bool? get is_unlocked_for_rating => isUnlockedForRating;
  bool? get is_locked_for_bookmarking => isLockedForBookmarking;
  bool? get is_unlocked_for_bookmarking => isUnlockedForBookmarking;
  bool? get is_locked_for_subscription => isLockedForSubscription;
  bool? get is_unlocked_for_subscription => isUnlockedForSubscription;
  bool? get is_locked_for_liking => isLockedForLiking;
  bool? get is_unlocked_for_liking => isUnlockedForLiking;
  bool? get is_locked_for_thanking => isLockedForThanking;
  bool? get is_unlocked_for_thanking => isUnlockedForThanking;
  bool? get is_locked_for_reporting => isLockedForReporting;
  bool? get is_unlocked_for_reporting => isUnlockedForReporting;
  bool? get is_locked_for_hiding => isLockedForHiding;
  bool? get is_unlocked_for_hiding => isUnlockedForHiding;
  bool? get is_locked_for_archiving => isLockedForArchiving;
  bool? get is_unlocked_for_archiving => isUnlockedForArchiving;
}

/// Forum Copilot Subscribe Topic Result
/// Maps from SubscribeTopicData_Output
@MappableClass()
class FCSubscribeTopicResult extends FCBaseResult with FCSubscribeTopicResultMappable {
  FCSubscribeTopicResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Unsubscribe Topic Result
/// Maps from UnsubscribeTopicData_Output
@MappableClass()
class FCUnsubscribeTopicResult extends FCBaseResult with FCUnsubscribeTopicResultMappable {
  FCUnsubscribeTopicResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}
