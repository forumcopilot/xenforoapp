import 'package:dart_mappable/dart_mappable.dart';
import '../user/user.dart';

part 'profile_post_comment.mapper.dart';

/// XenForo profile post comment data model based on official API documentation
@MappableClass()
class XenForoProfilePostComment with XenForoProfilePostCommentMappable {
  /// Username
  final String? username;

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

  /// View URL
  final String? viewUrl;

  /// Whether the viewing user has reacted to this content
  final bool? isReactedTo;

  /// If the viewer reacted, the ID of the reaction they used
  final int? visitorReactionId;

  /// Comment ID
  final int commentId;

  /// Profile post ID
  final int? profilePostId;

  /// User ID
  final int? userId;

  /// Comment date (Unix timestamp)
  final int? commentDate;

  /// Message content
  final String? message;

  /// Message state
  final String? messageState;

  /// Warning message
  final String? warningMessage;

  /// Reaction score
  final int? reactionScore;

  /// User who posted
  final XenForoUser? user;

  const XenForoProfilePostComment({
    this.username,
    this.messageParsed,
    this.canEdit,
    this.canSoftDelete,
    this.canHardDelete,
    this.canReact,
    this.viewUrl,
    this.isReactedTo,
    this.visitorReactionId,
    required this.commentId,
    this.profilePostId,
    this.userId,
    this.commentDate,
    this.message,
    this.messageState,
    this.warningMessage,
    this.reactionScore,
    this.user,
  });

  factory XenForoProfilePostComment.fromJson(Map<String, dynamic> json) {
    return XenForoProfilePostComment(
      username: json['username'],
      messageParsed: json['message_parsed'],
      canEdit: json['can_edit'],
      canSoftDelete: json['can_soft_delete'],
      canHardDelete: json['can_hard_delete'],
      canReact: json['can_react'],
      viewUrl: json['view_url'],
      isReactedTo: json['is_reacted_to'],
      visitorReactionId: json['visitor_reaction_id'],
      commentId: json['comment_id'] ?? 0,
      profilePostId: json['profile_post_id'],
      userId: json['user_id'],
      commentDate: json['comment_date'],
      message: json['message'],
      messageState: json['message_state'],
      warningMessage: json['warning_message'],
      reactionScore: json['reaction_score'],
      user: json['User'] != null ? XenForoUser.fromJson(json['User']) : null,
    );
  }

  // Convenience getters for backward compatibility
  String get id => commentId.toString();
  String get content => message ?? '';
  DateTime get commentDateTime => commentDate != null ? DateTime.fromMillisecondsSinceEpoch(commentDate! * 1000) : DateTime.now();
  String get authorId => userId?.toString() ?? '';
  String get authorName => username ?? '';
  String get authorUserType => user?.userTitle ?? '';
  String? get authorAvatarUrl => user?.avatarUrl;
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
  String get title => ''; // Not available in API
  String get topicId => ''; // Not available in API
  DateTime get createDate => commentDateTime;
  DateTime? get editDate => null; // Not available in API
  bool get isRead => true; // Assume read if accessible
}
