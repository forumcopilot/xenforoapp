import '../models/results/fc_private_conversation_result.dart';

/// Forum Copilot Private Conversation Proxy Interface
///
/// This interface defines the contract for private conversation operations including:
/// - Creating new conversations
/// - Replying to conversations
/// - Managing participants
/// - Getting conversation lists and details
/// - Managing conversation status (read/unread/delete)
abstract class IFCPrivateConversationProxy {
  /// Create a new conversation between this user and other users
  ///
  /// [userName] - List of user names to create conversation with
  /// [subject] - Subject of the conversation
  /// [textBody] - Body text of the conversation
  /// [attachmentIds] - List of attachment IDs
  /// [groupId] - Group ID for attachments
  /// [openInvite] - If true, any participant can invite others (XenForo only)
  /// [conversationLocked] - If true, conversation is created as closed (XenForo only)
  Future<FCNewConversationResult> newConversationAsync(
    List<String> userName,
    String subject,
    String textBody, {
    List<String>? attachmentIds,
    String? groupId,
    bool? openInvite,
    bool? conversationLocked,
  });

  /// Reply to an existing conversation
  ///
  /// [conversationId] - Conversation ID to reply to
  /// [textBody] - Reply message text
  /// [attachmentIds] - List of attachment IDs
  /// [groupId] - Group ID for attachments
  Future<FCReplyConversationResult> replyConversationAsync(String conversationId, String textBody, List<String>? attachmentIds, String? groupId);

  /// Invite additional participants to an existing conversation
  ///
  /// [userName] - List of user names to invite
  /// [conversationId] - Conversation ID to invite to
  /// [reason] - Reason for invitation
  Future<FCInviteParticipantResult> inviteParticipantAsync(List<String> userName, String conversationId, String? reason);

  /// Get inbox statistics
  Future<FCInboxStatResult> getInboxStatAsync();

  /// Get list of conversations
  ///
  /// [startNum] - Start number for pagination
  /// [lastNum] - Last number for pagination
  Future<FCConversationsResult> getConversationsAsync(int startNum, int lastNum);

  /// Get conversation details
  ///
  /// [conversationId] - Conversation ID to get
  /// [startNum] - Start number for pagination
  /// [lastNum] - Last number for pagination
  /// [returnHtml] - Whether to return HTML content
  Future<FCConversationResult> getConversationAsync(String conversationId, int startNum, int lastNum, bool returnHtml);

  /// Get conversation by message ID
  ///
  /// Returns the conversation containing the specified message, with messages centered around the target message.
  /// Similar to getThreadByPost, this allows navigating to a specific message in a conversation.
  ///
  /// [messageId] - Message ID to navigate to
  /// [messagesPerRequest] - Number of messages to load per request (default: 20)
  /// Returns conversation with [position] field indicating the 1-based position of the target message
  Future<FCConversationResult> getConversationByMessageAsync(String messageId, {int messagesPerRequest = 20});

  /// Get quote for a conversation message
  ///
  /// [conversationId] - Conversation ID
  /// [messageId] - Message ID to quote
  Future<FCQuoteConversationResult> getQuoteConversationAsync(String conversationId, String messageId);

  /// Leave a conversation
  ///
  /// [conversationId] - Conversation ID to leave
  /// [mode] - Leave mode (1: soft-leave, 2: hard-leave)
  Future<FCLeaveConversationResult> leaveConversationAsync(String conversationId, int mode);

  /// Mark conversation as unread
  ///
  /// [conversationId] - Conversation ID to mark as unread
  Future<FCMarkConversationUnreadResult> markConversationUnreadAsync(String conversationId);

  /// Mark conversation as read
  ///
  /// [conversationId] - Conversation ID to mark as read
  Future<FCMarkConversationReadResult> markConversationReadAsync(String conversationId);

  /// Close a conversation
  ///
  /// [conversationId] - Conversation ID to close
  Future<FCCloseConversationResult> closeConversationAsync(String conversationId);

  /// Unclose (reopen) a conversation
  ///
  /// [conversationId] - Conversation ID to unclose
  Future<FCCloseConversationResult> uncloseConversationAsync(String conversationId);

  /// Get raw conversation data for editing
  ///
  /// [conversationId] - Conversation ID to get
  /// Returns conversation metadata (title, openInvite, conversationOpen, canEdit)
  Future<FCRawConversationResult> getRawConversationAsync(String conversationId);

  /// Save edited conversation metadata
  ///
  /// [conversationId] - Conversation ID to update
  /// [conversationTitle] - New title (optional)
  /// [openInvite] - New open invite setting (optional)
  /// [conversationOpen] - New open/closed status (optional, true = open, false = closed)
  Future<FCSaveRawConversationResult> saveRawConversationAsync(
    String conversationId, {
    String? conversationTitle,
    bool? openInvite,
    bool? conversationOpen,
  });

  /// Get raw message data for editing
  ///
  /// [messageId] - Message ID to get
  /// Returns message content and attachments
  Future<FCRawMessageResult> getRawMessageAsync(String messageId);

  /// Save edited message content
  ///
  /// [messageId] - Message ID to update
  /// [messageContent] - Updated message content in BBCode
  /// [attachmentIds] - List of attachment IDs to attach (optional)
  /// [groupId] - Attachment group hash (optional, alternative to attachmentIds)
  Future<FCSaveRawMessageResult> saveRawMessageAsync(
    String messageId,
    String messageContent, {
    List<String>? attachmentIds,
    String? groupId,
  });
}
