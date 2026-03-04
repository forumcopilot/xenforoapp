import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';
import 'package:forumcopilot_sdk/models/entities/fc_attachment.dart';
import 'package:forumcopilot_sdk/models/entities/fc_like.dart';

part 'fc_private_conversation_result.mapper.dart';

/// Forum Copilot New Conversation Result
/// Maps from NewConversationData_Output
@MappableClass()
class FCNewConversationResult extends FCBaseResult with FCNewConversationResultMappable {
  /// ID of new conversation just created
  String convId;

  // Compatibility properties for snake_case access
  String? get conv_id => convId;

  FCNewConversationResult({
    required bool result,
    String? resultText,
    required this.convId,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Reply Conversation Result
/// Maps from ReplyConversationData_Output
@MappableClass()
class FCReplyConversationResult extends FCBaseResult with FCReplyConversationResultMappable {
  /// ID of the reply message
  String? messageId;

  // Compatibility properties for snake_case access
  String? get message_id => messageId;

  FCReplyConversationResult({
    required bool result,
    String? resultText,
    this.messageId,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Invite Participant Result
/// Maps from InviteParticipantData_Output
@MappableClass()
class FCInviteParticipantResult extends FCBaseResult with FCInviteParticipantResultMappable {
  FCInviteParticipantResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Inbox Stat Result
/// Maps from InboxStatData_Output
@MappableClass()
class FCConversationInboxStatResult extends FCBaseResult with FCConversationInboxStatResultMappable {
  /// Total number of conversations
  int totalConversations;

  /// Number of unread conversations
  int unreadConversations;

  /// Number of unread messages
  int unreadMessages;

  // Compatibility properties for snake_case access
  int? get total_conversations => totalConversations;
  int? get unread_conversations => unreadConversations;
  int? get unread_messages => unreadMessages;

  FCConversationInboxStatResult({
    required bool result,
    String? resultText,
    required this.totalConversations,
    required this.unreadConversations,
    required this.unreadMessages,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Inbox Stat Result (alias for compatibility)
/// Maps from InboxStatData_Output
@MappableClass()
class FCInboxStatResult extends FCBaseResult with FCInboxStatResultMappable {
  /// Total number of conversations
  int totalConversations;

  /// Number of unread conversations
  int unreadConversations;

  /// Number of unread messages
  int unreadMessages;

  // Compatibility properties for snake_case access
  int get total_conversations => totalConversations;
  int get unread_conversations => unreadConversations;
  int get unread_messages => unreadMessages;

  FCInboxStatResult({
    required bool result,
    String? resultText,
    required this.totalConversations,
    required this.unreadConversations,
    required this.unreadMessages,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Conversations Result
/// Maps from ConversationsData_Output
@MappableClass()
class FCConversationsResult extends FCBaseResult with FCConversationsResultMappable {
  /// Total number of conversations
  int conversationCount;

  /// Number of unread conversations
  int unreadCount;

  /// Whether user can upload attachments
  bool canUpload;

  /// List of conversations
  List<FCConversationSummary> list;

  // Compatibility properties for snake_case access
  int? get conversation_count => conversationCount;
  int? get unread_count => unreadCount;
  bool? get can_upload => canUpload;

  FCConversationsResult({
    required bool result,
    String? resultText,
    required this.conversationCount,
    required this.unreadCount,
    required this.canUpload,
    required this.list,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Conversation Summary
/// Maps from ConversationSummary
@MappableClass()
class FCConversationSummary with FCConversationSummaryMappable {
  /// Conversation ID
  String convId;

  /// Total number of replies
  String replyCount;

  /// Total number of participants
  int participantCount;

  /// ID of user who started conversation
  String? startUserId;

  /// Start time of conversation
  String? startTime;

  /// Subject of conversation
  String? subject;

  /// Subject of conversation (compatibility)
  String? convSubject;

  /// ID of last user who replied
  String? lastUserId;

  /// Last reply time
  String? lastReplyTime;

  /// Last conversation time (compatibility)
  String? lastConvTime;

  /// Whether conversation has new posts (primary field - standardize on this)
  bool? newPost;

  /// List of participants
  List<FCParticipant>? participants;

  /// Whether user can edit this conversation
  bool? canEdit;

  /// Whether user can close this conversation
  bool? canClose;

  /// Whether conversation is closed
  bool? isClosed;

  /// Message ID to navigate to (first unread message ID if unread, otherwise latest message ID)
  String? messageId;

  /// Number of unread messages in the conversation
  int? unreadMessageCount;

  FCConversationSummary({
    required this.convId,
    required this.replyCount,
    required this.participantCount,
    this.startUserId,
    this.startTime,
    this.subject,
    this.convSubject,
    this.lastUserId,
    this.lastReplyTime,
    this.lastConvTime,
    this.newPost,
    this.participants,
    this.canEdit,
    this.canClose,
    this.isClosed,
    this.messageId,
    this.unreadMessageCount,
  });

  // Compatibility properties for snake_case access
  String? get conv_id => convId;
  String? get reply_count => replyCount;
  int? get participant_count => participantCount;
  String? get start_user_id => startUserId;
  String? get start_time => startTime;
  String? get conv_subject => convSubject ?? subject;
  String? get last_user_id => lastUserId;
  String? get last_reply_time => lastReplyTime;
  String? get last_conv_time => lastConvTime ?? lastReplyTime;

  /// Whether conversation has unread messages (computed from newPost)
  bool? get hasUnread => newPost;
  bool? get has_unread => newPost;
  bool? get new_post => newPost;
  String? get message_id => messageId;
  int? get unread_message_count => unreadMessageCount;
}

/// Forum Copilot Participant
/// Maps from Participant
@MappableClass()
class FCParticipant with FCParticipantMappable {
  /// User ID
  String userId;

  /// Username
  String username;

  /// Avatar URL
  String? iconUrl;

  /// Whether user is online
  bool? isOnline;

  FCParticipant({
    required this.userId,
    required this.username,
    this.iconUrl,
    this.isOnline,
  });

  // Compatibility properties for snake_case access
  String? get user_id => userId;
  String? get icon_url => iconUrl;
  bool? get is_online => isOnline;
}

/// Forum Copilot Conversation Result
/// Maps from ConversationData_Output
@MappableClass()
class FCConversationResult extends FCBaseResult with FCConversationResultMappable {
  /// Conversation ID
  String convId;

  /// Subject of conversation
  String? subject;

  /// Subject of conversation (compatibility)
  String? convTitle;

  /// List of messages
  List<FCConversationMessage> messages;

  /// List (compatibility alias for messages)
  List<FCConversationMessage> get list => messages;

  /// List of participants
  List<FCParticipant> participants;

  /// Participant count (compatibility)
  int? participantCount;

  /// Whether user can reply
  bool? canReply;

  /// Whether user can invite
  bool? canInvite;

  /// Whether user can edit (compatibility)
  bool? canEdit;

  /// Whether user can close (compatibility)
  bool? canClose;

  /// Whether conversation is closed (compatibility)
  bool? isClosed;

  /// Total number of messages in this conversation
  int? totalMessageNum;

  /// Timestamp when conversation was last read by the current user (milliseconds)
  int? lastRead;

  /// Whether user can upload attachments
  bool? canUpload;

  /// Position of the target message (1-based) when conversation is loaded by message ID
  int? position;

  FCConversationResult({
    required bool result,
    String? resultText,
    required this.convId,
    this.subject,
    this.convTitle,
    required this.messages,
    required this.participants,
    this.participantCount,
    this.canReply,
    this.canInvite,
    this.canEdit,
    this.canClose,
    this.isClosed,
    this.totalMessageNum,
    this.lastRead,
    this.canUpload,
    this.position,
  }) : super(result: result, resultText: resultText);

  // Compatibility properties for snake_case access
  String? get conv_id => convId;
  String? get conv_title => convTitle ?? subject;
  int? get participant_count => participantCount ?? participants.length;
  bool? get can_reply => canReply;
  bool? get can_invite => canInvite;
  bool? get can_edit => canEdit;
  bool? get can_close => canClose;
  bool? get is_closed => isClosed;
  bool? get can_upload => canUpload;
}

/// Forum Copilot Conversation Message
/// Maps from ConversationMessage
@MappableClass()
class FCConversationMessage with FCConversationMessageMappable {
  /// Message ID
  String messageId;

  /// User ID of sender
  String userId;

  /// Username of sender
  String username;

  /// Avatar URL of sender
  String? iconUrl;

  /// Message content
  String textBody;

  /// Message time
  String messageTime;

  /// Whether message is from current user
  bool? isFromCurrentUser;

  /// Whether user can like this message
  bool canLike;

  /// Whether current user has liked this message
  bool isLiked;

  /// Total number of likes
  int likeCount;

  /// List of users who liked this message
  List<FCLike> likesInfo;

  /// List of attachments in this message
  List<FCAttachment> attachments;

  /// Whether this message is unread
  bool? isUnread;

  /// Whether this is the first message in the conversation
  bool? isFirstMessage;

  /// Whether the current user can report this message
  bool? canReport;

  /// Whether the message author is ignored by the current user
  bool? isIgnored;

  /// Whether the current user can edit this message
  bool? canEdit;

  /// Message number in the conversation (1-based position)
  int? messageNumber;

  FCConversationMessage({
    required this.messageId,
    required this.userId,
    required this.username,
    this.iconUrl,
    required this.textBody,
    required this.messageTime,
    this.isFromCurrentUser,
    this.canLike = false,
    this.isLiked = false,
    this.likeCount = 0,
    this.likesInfo = const [],
    this.attachments = const [],
    this.isUnread,
    this.isFirstMessage,
    this.canReport,
    this.isIgnored,
    this.canEdit,
    this.messageNumber,
  });

  // Compatibility properties for snake_case access
  String? get message_id => messageId;
  String? get user_id => userId;
  String? get icon_url => iconUrl;
  String? get text_body => textBody;
  String? get message_time => messageTime;
  bool? get is_from_current_user => isFromCurrentUser;
  bool? get can_edit => canEdit;
}

/// Forum Copilot Quote Conversation Result
/// Maps from QuoteConversationData_Output
@MappableClass()
class FCQuoteConversationResult extends FCBaseResult with FCQuoteConversationResultMappable {
  /// Quoted message content
  String? quoteText;

  /// Original message author
  String? authorName;

  // Compatibility properties for snake_case access
  String? get quote_text => quoteText;
  String? get author_name => authorName;

  FCQuoteConversationResult({
    required bool result,
    String? resultText,
    this.quoteText,
    this.authorName,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Leave Conversation Result
/// Maps from LeaveConversationData_Output
@MappableClass()
class FCLeaveConversationResult extends FCBaseResult with FCLeaveConversationResultMappable {
  FCLeaveConversationResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Mark Conversation Unread Result
/// Maps from MarkConversationUnreadData_Output
@MappableClass()
class FCMarkConversationUnreadResult extends FCBaseResult with FCMarkConversationUnreadResultMappable {
  FCMarkConversationUnreadResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Mark Conversation Read Result
/// Maps from MarkConversationReadData_Output
@MappableClass()
class FCMarkConversationReadResult extends FCBaseResult with FCMarkConversationReadResultMappable {
  FCMarkConversationReadResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Close Conversation Result
/// Maps from CloseConversationData_Output
@MappableClass()
class FCCloseConversationResult extends FCBaseResult with FCCloseConversationResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCCloseConversationResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Raw Conversation Result
/// Maps from RawConversationData_Output
@MappableClass()
class FCRawConversationResult extends FCBaseResult with FCRawConversationResultMappable {
  /// Current title of the conversation
  String? conversationTitle;

  /// Whether anyone in conversation can invite others
  bool? openInvite;

  /// Whether conversation is open for replies (true = open, false = closed)
  bool? conversationOpen;

  /// Whether current user can edit this conversation
  bool? canEdit;

  // Compatibility properties for snake_case access
  String? get conversation_title => conversationTitle;
  bool? get open_invite => openInvite;
  bool? get conversation_open => conversationOpen;
  bool? get can_edit => canEdit;

  FCRawConversationResult({
    required bool result,
    String? resultText,
    this.conversationTitle,
    this.openInvite,
    this.conversationOpen,
    this.canEdit,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Save Raw Conversation Result
/// Maps from SaveRawConversationData_Output
@MappableClass()
class FCSaveRawConversationResult extends FCBaseResult with FCSaveRawConversationResultMappable {
  /// The updated conversation title
  String? conversationTitle;

  // Compatibility properties for snake_case access
  String? get conversation_title => conversationTitle;

  FCSaveRawConversationResult({
    required bool result,
    String? resultText,
    this.conversationTitle,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Raw Message Result
/// Maps from RawMessageData_Output
@MappableClass()
class FCRawMessageResult extends FCBaseResult with FCRawMessageResultMappable {
  /// Raw message content in BBCode format
  String? messageContent;

  /// Array of attachment objects
  List<FCAttachment>? attachments;

  // Compatibility properties for snake_case access
  String? get message_content => messageContent;

  FCRawMessageResult({
    required bool result,
    String? resultText,
    this.messageContent,
    this.attachments,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Save Raw Message Result
/// Maps from SaveRawMessageData_Output
@MappableClass()
class FCSaveRawMessageResult extends FCBaseResult with FCSaveRawMessageResultMappable {
  /// The updated message content after save
  String? messageContent;

  // Compatibility properties for snake_case access
  String? get message_content => messageContent;

  FCSaveRawMessageResult({
    required bool result,
    String? resultText,
    this.messageContent,
  }) : super(result: result, resultText: resultText);
}
