import 'package:dart_mappable/dart_mappable.dart';
import '../user/user.dart';

part 'conversation.mapper.dart';

/// XenForo conversation data model based on official API documentation
@MappableClass()
class XenForoConversation with XenForoConversationMappable {
  /// Username of the user that started the conversation
  final String? username;

  /// Recipients object with user IDs and names
  final Map<String, String>? recipients;

  /// Whether the viewing user starred the conversation
  final bool? isStarred;

  /// Whether this conversation is unread
  final bool? isUnread;

  /// Whether user can edit
  final bool? canEdit;

  /// Whether user can reply
  final bool? canReply;

  /// Whether user can invite
  final bool? canInvite;

  /// Whether user can upload attachment
  final bool? canUploadAttachment;

  /// View URL
  final String? viewUrl;

  /// Conversation ID
  final int conversationId;

  /// Title
  final String? title;

  /// User ID
  final int? userId;

  /// Start date (Unix timestamp)
  final int? startDate;

  /// Whether conversation is open invite
  final bool? openInvite;

  /// Whether conversation is open
  final bool? conversationOpen;

  /// Reply count
  final int? replyCount;

  /// Recipient count
  final int? recipientCount;

  /// First message ID
  final int? firstMessageId;

  /// Last message date (Unix timestamp)
  final int? lastMessageDate;

  /// Last message ID
  final int? lastMessageId;

  /// Last message user ID
  final int? lastMessageUserId;

  /// Starter user
  final XenForoUser? starter;

  const XenForoConversation({
    this.username,
    this.recipients,
    this.isStarred,
    this.isUnread,
    this.canEdit,
    this.canReply,
    this.canInvite,
    this.canUploadAttachment,
    this.viewUrl,
    required this.conversationId,
    this.title,
    this.userId,
    this.startDate,
    this.openInvite,
    this.conversationOpen,
    this.replyCount,
    this.recipientCount,
    this.firstMessageId,
    this.lastMessageDate,
    this.lastMessageId,
    this.lastMessageUserId,
    this.starter,
  });

  factory XenForoConversation.fromJson(Map<String, dynamic> json) {
    return XenForoConversation(
      username: json['username'],
      recipients: json['recipients'] != null ? Map<String, String>.from(json['recipients']) : null,
      isStarred: json['is_starred'],
      isUnread: json['is_unread'],
      canEdit: json['can_edit'],
      canReply: json['can_reply'],
      canInvite: json['can_invite'],
      canUploadAttachment: json['can_upload_attachment'],
      viewUrl: json['view_url'],
      conversationId: json['conversation_id'] ?? 0,
      title: json['title'],
      userId: json['user_id'],
      startDate: json['start_date'],
      openInvite: json['open_invite'],
      conversationOpen: json['conversation_open'],
      replyCount: json['reply_count'],
      recipientCount: json['recipient_count'],
      firstMessageId: json['first_message_id'],
      lastMessageDate: json['last_message_date'],
      lastMessageId: json['last_message_id'],
      starter: json['Starter'] != null ? XenForoUser.fromJson(json['Starter']) : null,
    );
  }

  // Convenience getters for backward compatibility
  String get id => conversationId.toString();
  String get starterId => userId?.toString() ?? '';
  String get starterName => username ?? '';
  DateTime get startDateTime => startDate != null ? DateTime.fromMillisecondsSinceEpoch(startDate! * 1000) : DateTime.now();
  DateTime get lastMessageDateTime => lastMessageDate != null ? DateTime.fromMillisecondsSinceEpoch(lastMessageDate! * 1000) : DateTime.now();
  String get lastMessageIdString => lastMessageId?.toString() ?? '';
  String get lastMessageUserIdString => lastMessageUserId?.toString() ?? '';
  String get lastMessageUserName => ''; // Not available in API
  int get messageCount => replyCount ?? 0;
  List<String> get recipientIds => recipients?.keys.toList() ?? [];
  List<String> get recipientNames => recipients?.values.toList() ?? [];
  Map<String, dynamic> get customFields => {}; // Not available in API
}
