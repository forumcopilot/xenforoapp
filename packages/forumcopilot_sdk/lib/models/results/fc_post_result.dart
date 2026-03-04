import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/entities/fc_attachment.dart';
import 'package:forumcopilot_sdk/models/entities/fc_attachment_data.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import 'package:forumcopilot_sdk/models/entities/fc_poll.dart';
import 'package:forumcopilot_sdk/models/entities/fc_topic.dart';
import 'package:forumcopilot_sdk/models/mapping/hooks.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';
import 'package:forumcopilot_sdk/models/results/fc_topic_result.dart';

part 'fc_post_result.mapper.dart';

/// Forum Copilot Thread Result
/// Maps from ThreadData_Output
@MappableClass()
class FCThreadResult extends FCTopic with FCThreadResultMappable {
  /// Whether the operation was successful
  bool result;

  /// Result message or error text (only present when result = false)
  String? resultText;

  /// Total number of posts in this topic
  int totalPostNum;

  /// An array contains a list of posts
  List<FCPost> posts;

  FCThreadResult({
    required this.result,
    this.resultText,
    required this.totalPostNum,
    this.posts = const [],
    // FCTopic required fields
    required String id,
    required String title,
    required String forumId,
    required String forumName,
    required String authorId,
    required String authorName,
    required String authorUserType,
    required DateTime timestamp,
    // FCTopic optional fields
    String? prefix,
    String? authorIconUrl,
    int replyCount = 0,
    int viewCount = 0,
    bool hasNewPosts = false,
    bool isClosed = false,
    bool isSubscribed = false,
    bool canSubscribe = true,
    String? url,
    String? shortContent,
    List<String> participatedUserIds = const [],
    bool isPinned = false,
    bool isAnnouncement = false,
    bool isStickySource = false,
    // Moderation capabilities
    bool canRename = false,
    bool canDelete = false,
    bool canClose = false,
    bool canApprove = false,
    bool canStick = false,
    bool canMove = false,
    bool canMerge = false,
    bool canBan = false,
    // User interaction capabilities
    bool canReply = false,
    bool canReport = false,
    bool canUpload = false,
    // Moderation statuses
    bool isBanned = false,
    bool isApproved = true,
    bool isDeleted = false,
    bool isMoved = false,
    bool isMerged = false,
    String? realTopicId,
    // Like/thank
    bool canLike = false,
    bool isLiked = false,
    int likeCount = 0,
    bool canThank = false,
    bool hasPoll = false,
    FCPoll? poll,
  }) : super(
          id: id,
          title: title,
          forumId: forumId,
          forumName: forumName,
          authorId: authorId,
          authorName: authorName,
          authorUserType: authorUserType,
          timestamp: timestamp,
          prefix: prefix,
          authorIconUrl: authorIconUrl,
          replyCount: replyCount,
          viewCount: viewCount,
          hasNewPosts: hasNewPosts,
          isClosed: isClosed,
          isSubscribed: isSubscribed,
          canSubscribe: canSubscribe,
          url: url,
          shortContent: shortContent,
          participatedUserIds: participatedUserIds,
          isPinned: isPinned,
          isAnnouncement: isAnnouncement,
          isStickySource: isStickySource,
          canRename: canRename,
          canDelete: canDelete,
          canClose: canClose,
          canApprove: canApprove,
          canStick: canStick,
          canMove: canMove,
          canMerge: canMerge,
          canBan: canBan,
          isBanned: isBanned,
          isApproved: isApproved,
          isDeleted: isDeleted,
          isMoved: isMoved,
          isMerged: isMerged,
          realTopicId: realTopicId,
          canLike: canLike,
          isLiked: isLiked,
          likeCount: likeCount,
          canThank: canThank,
          hasPoll: hasPoll,
          poll: poll,
          canReply: canReply,
          canReport: canReport,
          canUpload: canUpload,
        );
}

/// Forum Copilot Thread By Unread Result
/// Maps from ThreadByUnreadData_Output
@MappableClass()
class FCThreadByUnreadResult extends FCTopic with FCThreadByUnreadResultMappable {
  /// Whether the operation was successful
  bool result;

  /// Result message or error text (only present when result = false)
  String? resultText;

  /// Total number of posts in this topic
  int totalPostNum;

  /// Return false if user cannot reply to this thread
  bool canReply;

  /// Return true if if user can report post in this thread
  bool canReport;

  /// Return false if user cannot attach files to this thread
  bool canUpload;

  /// An array contains a list of posts
  List<FCPost> posts;

  /// This value is to indicate the current first unread post position relative to the entire thread,
  /// starting from "1" to indicate first post, thereafter.
  int position;

  FCThreadByUnreadResult({
    required this.result,
    this.resultText,
    required this.totalPostNum,
    this.canReply = false,
    this.canReport = false,
    this.canUpload = false,
    this.posts = const [],
    required this.position,
    // FCTopic required fields
    required String id,
    required String title,
    required String forumId,
    required String forumName,
    required String authorId,
    required String authorName,
    required String authorUserType,
    required DateTime timestamp,
    // FCTopic optional fields
    String? prefix,
    String? authorIconUrl,
    int replyCount = 0,
    int viewCount = 0,
    bool hasNewPosts = false,
    bool isClosed = false,
    bool isSubscribed = false,
    bool canSubscribe = true,
    String? url,
    String? shortContent,
    List<String> participatedUserIds = const [],
    bool isPinned = false,
    bool isAnnouncement = false,
    bool isStickySource = false,
    // Moderation capabilities
    bool canRename = false,
    bool canDelete = false,
    bool canClose = false,
    bool canApprove = false,
    bool canStick = false,
    bool canMove = false,
    bool canMerge = false,
    bool canBan = false,
    // Moderation statuses
    bool isBanned = false,
    bool isApproved = true,
    bool isDeleted = false,
    bool isMoved = false,
    bool isMerged = false,
    String? realTopicId,
    // Like/thank
    bool canLike = false,
    bool isLiked = false,
    int likeCount = 0,
    bool canThank = false,
    bool hasPoll = false,
    FCPoll? poll,
  }) : super(
          id: id,
          title: title,
          forumId: forumId,
          forumName: forumName,
          authorId: authorId,
          authorName: authorName,
          authorUserType: authorUserType,
          timestamp: timestamp,
          prefix: prefix,
          authorIconUrl: authorIconUrl,
          replyCount: replyCount,
          viewCount: viewCount,
          hasNewPosts: hasNewPosts,
          isClosed: isClosed,
          isSubscribed: isSubscribed,
          canSubscribe: canSubscribe,
          url: url,
          shortContent: shortContent,
          participatedUserIds: participatedUserIds,
          isPinned: isPinned,
          isAnnouncement: isAnnouncement,
          isStickySource: isStickySource,
          canRename: canRename,
          canDelete: canDelete,
          canClose: canClose,
          canApprove: canApprove,
          canStick: canStick,
          canMove: canMove,
          canMerge: canMerge,
          canBan: canBan,
          isBanned: isBanned,
          isApproved: isApproved,
          isDeleted: isDeleted,
          isMoved: isMoved,
          isMerged: isMerged,
          realTopicId: realTopicId,
          canLike: canLike,
          isLiked: isLiked,
          likeCount: likeCount,
          canThank: canThank,
          hasPoll: hasPoll,
          poll: poll,
          canReply: canReply,
          canReport: canReport,
          canUpload: canUpload,
        );
}

/// Forum Copilot Thread By Post Result
/// Maps from ThreadByPostData_Output
@MappableClass()
class FCThreadByPostResult extends FCTopic with FCThreadByPostResultMappable {
  /// Whether the operation was successful
  bool result;

  /// Result message or error text (only present when result = false)
  String? resultText;

  /// Total number of posts in this topic
  int totalPostNum;

  /// Return false if user cannot reply to this thread
  bool canReply;

  /// Return true if if user can report post in this thread
  bool canReport;

  /// Return false if user cannot attach files to this thread
  bool canUpload;

  /// An array contains a list of posts
  List<FCPost> posts;

  /// This value is to indicate the current anchor post position relative to the entire thread,
  /// starting from "1" to indicate first post, thereafter.
  int position;

  FCThreadByPostResult({
    required this.result,
    this.resultText,
    required this.totalPostNum,
    this.canReply = false,
    this.canReport = false,
    this.canUpload = false,
    this.posts = const [],
    required this.position,
    // FCTopic required fields
    required String id,
    required String title,
    required String forumId,
    required String forumName,
    required String authorId,
    required String authorName,
    required String authorUserType,
    required DateTime timestamp,
    // FCTopic optional fields
    String? prefix,
    String? authorIconUrl,
    int replyCount = 0,
    int viewCount = 0,
    bool hasNewPosts = false,
    bool isClosed = false,
    bool isSubscribed = false,
    bool canSubscribe = true,
    String? url,
    String? shortContent,
    List<String> participatedUserIds = const [],
    bool isPinned = false,
    bool isAnnouncement = false,
    bool isStickySource = false,
    // Moderation capabilities
    bool canRename = false,
    bool canDelete = false,
    bool canClose = false,
    bool canApprove = false,
    bool canStick = false,
    bool canMove = false,
    bool canMerge = false,
    bool canBan = false,
    // Moderation statuses
    bool isBanned = false,
    bool isApproved = true,
    bool isDeleted = false,
    bool isMoved = false,
    bool isMerged = false,
    String? realTopicId,
    // Like/thank
    bool canLike = false,
    bool isLiked = false,
    int likeCount = 0,
    bool canThank = false,
    bool hasPoll = false,
    FCPoll? poll,
  }) : super(
          id: id,
          title: title,
          forumId: forumId,
          forumName: forumName,
          authorId: authorId,
          authorName: authorName,
          authorUserType: authorUserType,
          timestamp: timestamp,
          prefix: prefix,
          authorIconUrl: authorIconUrl,
          replyCount: replyCount,
          viewCount: viewCount,
          hasNewPosts: hasNewPosts,
          isClosed: isClosed,
          isSubscribed: isSubscribed,
          canSubscribe: canSubscribe,
          url: url,
          shortContent: shortContent,
          participatedUserIds: participatedUserIds,
          isPinned: isPinned,
          isAnnouncement: isAnnouncement,
          isStickySource: isStickySource,
          canRename: canRename,
          canDelete: canDelete,
          canClose: canClose,
          canApprove: canApprove,
          canStick: canStick,
          canMove: canMove,
          canMerge: canMerge,
          canBan: canBan,
          isBanned: isBanned,
          isApproved: isApproved,
          isDeleted: isDeleted,
          isMoved: isMoved,
          isMerged: isMerged,
          realTopicId: realTopicId,
          canLike: canLike,
          isLiked: isLiked,
          likeCount: likeCount,
          canThank: canThank,
          hasPoll: hasPoll,
          poll: poll,
          canReply: canReply,
          canReport: canReport,
          canUpload: canUpload,
        );
}

/// Forum Copilot Reply Post Result
/// Maps from ReplyPostData_Output
@MappableClass()
class FCReplyPostResult extends FCBaseResult with FCReplyPostResultMappable {
  /// The newly generated post ID for this new post
  String? postId;

  /// 1 = post is success but need moderation. Otherwise no need to return this key
  int state;

  /// Return the newly replied post content
  String? postContent;

  /// Return true if user can edit this post
  bool canEdit;

  /// Return true if user can delete this post
  bool canDelete;

  /// Return true if user can report this post
  bool canReport;

  FCReplyPostResult({
    required bool result,
    String? resultText,
    this.postId,
    this.state = 0,
    this.postContent,
    this.canEdit = false,
    this.canDelete = false,
    this.canReport = false,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Report Post Result
/// Maps from ReportPostData_Output
@MappableClass()
class FCReportPostResult extends FCBaseResult with FCReportPostResultMappable {
  FCReportPostResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Quote Post Result
/// Maps from QuotePostData_Output
@MappableClass()
class FCQuotePostResult extends FCBaseResult with FCQuotePostResultMappable {
  /// Quoted post content
  String? quoteContent;

  FCQuotePostResult({
    required bool result,
    String? resultText,
    this.quoteContent,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Raw Post Result
/// Maps from RawPostData_Output
@MappableClass()
class FCRawPostResult extends FCBaseResult with FCRawPostResultMappable {
  /// Raw post content
  String? postContent;

  /// Post title (only for first post)
  String? postTitle;

  /// Whether the user can edit the title
  @MappableField(key: 'canEditTitle')
  bool? canEditTitle;

  /// Forum ID where the post belongs (always present for uploads)
  @MappableField(key: 'forumId')
  String? forumId;

  /// List of existing attachments
  List<FCAttachment>? attachments;

  /// Attachment editor metadata for managing attachments during edit
  @MappableField(key: 'attachmentData')
  FCAttachmentData? attachmentData;

  /// Current prefix ID of the thread (null if no prefix is set)
  /// Only present when editing the first post
  @MappableField(key: 'prefixId')
  String? prefixId;

  /// Whether a prefix is required for this thread
  /// Only true when editing the first post
  @MappableField(key: 'requirePrefix')
  bool requirePrefix;

  /// List of available prefixes for this forum
  /// Empty array for non-first posts or when no prefixes are available
  List<FCPrefix> prefixes;

  FCRawPostResult({
    required bool result,
    String? resultText,
    this.postContent,
    this.postTitle,
    this.canEditTitle,
    this.forumId,
    this.attachments,
    this.attachmentData,
    this.prefixId,
    this.requirePrefix = false,
    this.prefixes = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Save Raw Post Result
/// Maps from SaveRawPostData_Output
@MappableClass()
class FCSaveRawPostResult extends FCBaseResult with FCSaveRawPostResultMappable {
  /// Updated post content
  String? postContent;

  FCSaveRawPostResult({
    required bool result,
    String? resultText,
    this.postContent,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Announcement Result
/// Maps from AnnouncementData_Output
@MappableClass()
class FCAnnouncementResult extends FCTopic with FCAnnouncementResultMappable {
  /// Whether the operation was successful
  bool result;

  /// Result message or error text (only present when result = false)
  String? resultText;

  /// Total number of posts in this topic
  int totalPostNum;

  /// Announcement content
  String? announcementContent;

  /// Announcement title
  String? announcementTitle;

  /// List of posts in this thread
  List<FCPost> posts;

  FCAnnouncementResult({
    required this.result,
    this.resultText,
    required this.totalPostNum,
    this.announcementContent,
    this.announcementTitle,
    this.posts = const [],
    // FCTopic required fields
    required String id,
    required String title,
    required String forumId,
    required String forumName,
    required String authorId,
    required String authorName,
    required String authorUserType,
    required DateTime timestamp,
    // FCTopic optional fields
    String? prefix,
    String? authorIconUrl,
    int replyCount = 0,
    int viewCount = 0,
    bool hasNewPosts = false,
    bool isClosed = false,
    bool isSubscribed = false,
    bool canSubscribe = true,
    String? url,
    String? shortContent,
    List<String> participatedUserIds = const [],
    bool isPinned = false,
    bool isAnnouncement = false,
    bool isStickySource = false,
    // Moderation capabilities
    bool canRename = false,
    bool canDelete = false,
    bool canClose = false,
    bool canApprove = false,
    bool canStick = false,
    bool canMove = false,
    bool canMerge = false,
    bool canBan = false,
    // User interaction capabilities
    bool canReply = false,
    bool canReport = false,
    bool canUpload = false,
    // Moderation statuses
    bool isBanned = false,
    bool isApproved = true,
    bool isDeleted = false,
    bool isMoved = false,
    bool isMerged = false,
    String? realTopicId,
    // Like/thank
    bool canLike = false,
    bool isLiked = false,
    int likeCount = 0,
    bool canThank = false,
    bool hasPoll = false,
    FCPoll? poll,
  }) : super(
          id: id,
          title: title,
          forumId: forumId,
          forumName: forumName,
          authorId: authorId,
          authorName: authorName,
          authorUserType: authorUserType,
          timestamp: timestamp,
          prefix: prefix,
          authorIconUrl: authorIconUrl,
          replyCount: replyCount,
          viewCount: viewCount,
          hasNewPosts: hasNewPosts,
          isClosed: isClosed,
          isSubscribed: isSubscribed,
          canSubscribe: canSubscribe,
          url: url,
          shortContent: shortContent,
          participatedUserIds: participatedUserIds,
          isPinned: isPinned,
          isAnnouncement: isAnnouncement,
          isStickySource: isStickySource,
          canRename: canRename,
          canDelete: canDelete,
          canClose: canClose,
          canApprove: canApprove,
          canStick: canStick,
          canMove: canMove,
          canMerge: canMerge,
          canBan: canBan,
          isBanned: isBanned,
          isApproved: isApproved,
          isDeleted: isDeleted,
          isMoved: isMoved,
          isMerged: isMerged,
          realTopicId: realTopicId,
          canLike: canLike,
          isLiked: isLiked,
          likeCount: likeCount,
          canThank: canThank,
          hasPoll: hasPoll,
          poll: poll,
          canReply: canReply,
          canReport: canReport,
          canUpload: canUpload,
        );
}
