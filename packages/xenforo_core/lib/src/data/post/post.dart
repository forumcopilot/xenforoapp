import 'package:dart_mappable/dart_mappable.dart';
import '../user/user.dart';
import '../attachment/attachment.dart';
import '../thread/thread.dart';

part 'post.mapper.dart';

/// XenForo post model based on official API documentation
@MappableClass()
class XenForoPost with XenForoPostMappable {
  /// Username
  final String? username;

  /// Whether this is the first post
  final bool? isFirstPost;

  /// Whether this is the last post
  final bool? isLastPost;

  /// Whether this post is unread
  final bool? isUnread;

  /// HTML parsed version of the message contents
  final String? messageParsed;

  /// Whether user can edit
  final bool? canEdit;

  /// Whether user can soft delete
  final bool? canSoftDelete;

  /// Whether user can hard delete
  final bool? canHardDelete;

  /// Whether user can react
  final bool? canReact;

  /// Whether user can view attachments
  final bool? canViewAttachments;

  /// View URL
  final String? viewUrl;

  /// Thread this post is part of
  final XenForoThread? thread;

  /// Attachments to this post
  final List<XenForoAttachment>? attachments;

  /// Whether the viewing user has reacted to this content
  final bool? isReactedTo;

  /// If the viewer reacted, the ID of the reaction they used
  final int? visitorReactionId;

  /// The content's vote score
  final int? voteScore;

  /// Whether the viewing user can vote on this content
  final bool? canContentVote;

  /// List of content vote types allowed on this content
  final List<String>? allowedContentVoteTypes;

  /// Whether the viewing user has voted on this content
  final bool? isContentVoted;

  /// If the viewer voted, the vote they cast (up/down)
  final String? visitorContentVote;

  /// Post ID
  final int postId;

  /// Thread ID
  final int? threadId;

  /// User ID
  final int? userId;

  /// Post date (Unix timestamp)
  final int? postDate;

  /// Message content
  final String? message;

  /// Message state
  final String? messageState;

  /// Attachment count
  final int? attachCount;

  /// Warning message
  final String? warningMessage;

  /// Position in thread
  final int? position;

  /// Last edit date (Unix timestamp)
  final int? lastEditDate;

  /// Reaction score
  final int? reactionScore;

  /// User who posted
  final XenForoUser? user;

  const XenForoPost({
    this.username,
    this.isFirstPost,
    this.isLastPost,
    this.isUnread,
    this.messageParsed,
    this.canEdit,
    this.canSoftDelete,
    this.canHardDelete,
    this.canReact,
    this.canViewAttachments,
    this.viewUrl,
    this.thread,
    this.attachments,
    this.isReactedTo,
    this.visitorReactionId,
    this.voteScore,
    this.canContentVote,
    this.allowedContentVoteTypes,
    this.isContentVoted,
    this.visitorContentVote,
    required this.postId,
    this.threadId,
    this.userId,
    this.postDate,
    this.message,
    this.messageState,
    this.attachCount,
    this.warningMessage,
    this.position,
    this.lastEditDate,
    this.reactionScore,
    this.user,
  });

  /// Create from JSON response
  factory XenForoPost.fromJson(Map<String, dynamic> json) {
    return XenForoPost(
      username: json['username'],
      isFirstPost: json['is_first_post'],
      isLastPost: json['is_last_post'],
      isUnread: json['is_unread'],
      messageParsed: json['message_parsed'],
      canEdit: json['can_edit'],
      canSoftDelete: json['can_soft_delete'],
      canHardDelete: json['can_hard_delete'],
      canReact: json['can_react'],
      canViewAttachments: json['can_view_attachments'],
      viewUrl: json['view_url'],
      thread: json['Thread'] != null ? XenForoThread.fromJson(json['Thread']) : null,
      attachments: json['Attachments'] != null ? (json['Attachments'] as List).map((attachment) => XenForoAttachment.fromJson(attachment)).toList() : null,
      isReactedTo: json['is_reacted_to'],
      visitorReactionId: json['visitor_reaction_id'],
      voteScore: json['vote_score'],
      canContentVote: json['can_content_vote'],
      allowedContentVoteTypes: json['allowed_content_vote_types'] != null ? List<String>.from(json['allowed_content_vote_types']) : null,
      isContentVoted: json['is_content_voted'],
      visitorContentVote: json['visitor_content_vote'],
      postId: json['post_id'] ?? 0,
      threadId: json['thread_id'],
      userId: json['user_id'],
      postDate: json['post_date'],
      message: json['message'],
      messageState: json['message_state'],
      attachCount: json['attach_count'],
      warningMessage: json['warning_message'],
      position: json['position'],
      lastEditDate: json['last_edit_date'],
      reactionScore: json['reaction_score'],
      user: json['User'] != null ? XenForoUser.fromJson(json['User']) : null,
    );
  }

  // Convenience getters for backward compatibility
  String get id => postId.toString();
  String get content => message ?? '';
  DateTime get postDateTime => postDate != null ? DateTime.fromMillisecondsSinceEpoch(postDate! * 1000) : DateTime.now();
  String get authorId => userId?.toString() ?? '';
  String get authorName => username ?? '';
  String get authorUserType => ''; // Not available in API
  String? get authorAvatarUrl => user?.avatarUrl;
  String get threadIdString => threadId?.toString() ?? '';
  String get threadTitle => thread?.title ?? '';
  String get forumId => thread?.nodeId?.toString() ?? '';
  String get forumTitle => thread?.forumTitle ?? '';
  int get postNumber => position ?? 0;
  bool get canDelete => canSoftDelete ?? false;
  bool get canLike => canReact ?? false;
  bool get canReport => false; // Not available in API
  bool get canQuote => false; // Not available in API
  String? get url => viewUrl;
  int get likeCount => reactionScore ?? 0;
  bool get isLiked => isReactedTo ?? false;
  Map<String, dynamic>? get customFields => null; // Not available in API
  bool get isDeleted => messageState == 'deleted';
  bool get isApproved => messageState == 'visible';
  bool get isReported => false; // Not available in API
  String get title => threadTitle;
  String get topicId => threadIdString;
  DateTime get createDate => postDateTime;
  DateTime? get editDate => lastEditDate != null ? DateTime.fromMillisecondsSinceEpoch(lastEditDate! * 1000) : null;
  bool get isRead => !(isUnread ?? false);
}
