import 'package:dart_mappable/dart_mappable.dart';
import '../user/user.dart';
import '../node/node.dart';

part 'thread.mapper.dart';

/// XenForo thread model based on official API documentation
@MappableClass()
class XenForoThread with XenForoThreadMappable {
  /// Username
  final String? username;

  /// Whether the user is watching this thread
  final bool? isWatching;

  /// Number of posts the user has made in this thread
  final int? visitorPostCount;

  /// Whether this thread is unread
  final bool? isUnread;

  /// Custom field values for this thread
  final Map<String, dynamic>? customFields;

  /// Thread tags
  final List<String>? tags;

  /// Thread prefix (printable name)
  final String? prefix;

  /// Whether user can edit
  final bool? canEdit;

  /// Whether user can edit tags
  final bool? canEditTags;

  /// Whether user can reply
  final bool? canReply;

  /// Whether user can soft delete
  final bool? canSoftDelete;

  /// Whether user can hard delete
  final bool? canHardDelete;

  /// Whether user can view attachments
  final bool? canViewAttachments;

  /// View URL
  final String? viewUrl;

  /// Whether first post is pinned
  final bool? isFirstPostPinned;

  /// Highlighted post IDs
  final List<int>? highlightedPostIds;

  /// Whether thread is search engine indexable
  final bool? isSearchEngineIndexable;

  /// Index state
  final String? indexState;

  /// Forum this thread was posted in
  final XenForoNode? forum;

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

  /// Thread ID
  final int threadId;

  /// Node ID
  final int? nodeId;

  /// Title
  final String? title;

  /// Reply count
  final int? replyCount;

  /// View count
  final int? viewCount;

  /// User ID
  final int? userId;

  /// Post date (Unix timestamp)
  final int? postDate;

  /// Whether thread is sticky
  final bool? sticky;

  /// Discussion state
  final String? discussionState;

  /// Whether discussion is open
  final bool? discussionOpen;

  /// Discussion type
  final String? discussionType;

  /// First post ID
  final int? firstPostId;

  /// Last post date (Unix timestamp)
  final int? lastPostDate;

  /// Last post ID
  final int? lastPostId;

  /// Last post user ID
  final int? lastPostUserId;

  /// Last post username
  final String? lastPostUsername;

  /// First post reaction score
  final int? firstPostReactionScore;

  /// Prefix ID
  final int? prefixId;

  /// User who posted
  final XenForoUser? user;

  const XenForoThread({
    this.username,
    this.isWatching,
    this.visitorPostCount,
    this.isUnread,
    this.customFields,
    this.tags,
    this.prefix,
    this.canEdit,
    this.canEditTags,
    this.canReply,
    this.canSoftDelete,
    this.canHardDelete,
    this.canViewAttachments,
    this.viewUrl,
    this.isFirstPostPinned,
    this.highlightedPostIds,
    this.isSearchEngineIndexable,
    this.indexState,
    this.forum,
    this.voteScore,
    this.canContentVote,
    this.allowedContentVoteTypes,
    this.isContentVoted,
    this.visitorContentVote,
    required this.threadId,
    this.nodeId,
    this.title,
    this.replyCount,
    this.viewCount,
    this.userId,
    this.postDate,
    this.sticky,
    this.discussionState,
    this.discussionOpen,
    this.discussionType,
    this.firstPostId,
    this.lastPostDate,
    this.lastPostId,
    this.lastPostUserId,
    this.lastPostUsername,
    this.firstPostReactionScore,
    this.prefixId,
    this.user,
  });

  /// Create from JSON response
  factory XenForoThread.fromJson(Map<String, dynamic> json) {
    return XenForoThread(
      username: json['username'],
      isWatching: json['is_watching'],
      visitorPostCount: json['visitor_post_count'],
      isUnread: json['is_unread'],
      customFields: json['custom_fields'] as Map<String, dynamic>?,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      prefix: json['prefix'],
      canEdit: json['can_edit'],
      canEditTags: json['can_edit_tags'],
      canReply: json['can_reply'],
      canSoftDelete: json['can_soft_delete'],
      canHardDelete: json['can_hard_delete'],
      canViewAttachments: json['can_view_attachments'],
      viewUrl: json['view_url'],
      isFirstPostPinned: json['is_first_post_pinned'],
      highlightedPostIds: json['highlighted_post_ids'] != null ? List<int>.from(json['highlighted_post_ids']) : null,
      isSearchEngineIndexable: json['is_search_engine_indexable'],
      indexState: json['index_state'],
      forum: json['Forum'] != null ? XenForoNode.fromJson(json['Forum']) : null,
      voteScore: json['vote_score'],
      canContentVote: json['can_content_vote'],
      allowedContentVoteTypes: json['allowed_content_vote_types'] != null ? List<String>.from(json['allowed_content_vote_types']) : null,
      isContentVoted: json['is_content_voted'],
      visitorContentVote: json['visitor_content_vote'],
      threadId: json['thread_id'] ?? 0,
      nodeId: json['node_id'],
      title: json['title'],
      replyCount: json['reply_count'],
      viewCount: json['view_count'],
      userId: json['user_id'],
      postDate: json['post_date'],
      sticky: json['sticky'],
      discussionState: json['discussion_state'],
      discussionOpen: json['discussion_open'],
      discussionType: json['discussion_type'],
      firstPostId: json['first_post_id'],
      lastPostDate: json['last_post_date'],
      lastPostId: json['last_post_id'],
      lastPostUserId: json['last_post_user_id'],
      lastPostUsername: json['last_post_username'],
      firstPostReactionScore: json['first_post_reaction_score'],
      prefixId: json['prefix_id'],
      user: json['User'] != null ? XenForoUser.fromJson(json['User']) : null,
    );
  }

  // Convenience getters for backward compatibility
  String get id => threadId.toString();
  String get forumId => nodeId?.toString() ?? '';
  String get forumTitle => forum?.title ?? '';
  String get authorId => userId?.toString() ?? '';
  String get authorName => username ?? '';
  String get authorUserType => user?.userTitle ?? '';
  String? get authorAvatarUrl => user?.avatarUrl;
  DateTime get creationDate => postDate != null ? DateTime.fromMillisecondsSinceEpoch(postDate! * 1000) : DateTime.now();
  DateTime? get lastPostDateTime => lastPostDate != null ? DateTime.fromMillisecondsSinceEpoch(lastPostDate! * 1000) : null;
  String get lastPostUserIdString => lastPostUserId?.toString() ?? '';
  String get lastPostUsernameString => lastPostUsername ?? '';
  bool get isSticky => sticky ?? false;
  bool get isLocked => discussionState == 'closed';
  bool get isRead => !(isUnread ?? false);
  bool get isSubscribed => isWatching ?? false;
  bool get canDelete => canSoftDelete ?? false;
  bool get canLock => false; // Not available in API
  bool get canStick => false; // Not available in API
  String? get url => viewUrl;
  String? get prefixString => prefix;
  List<String>? get tagsList => tags;
  Map<String, dynamic>? get customFieldsMap => customFields;
  String get firstPostContent => ''; // Not available in API
  String get lastPostContent => ''; // Not available in API
  String get forumName => forumTitle;
  String get content => firstPostContent;
  DateTime get createDate => creationDate;
  int get postCount => (replyCount ?? 0) + 1; // +1 for the first post
}
