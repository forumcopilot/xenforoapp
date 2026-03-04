import '../models/results/fc_private_message_result.dart';

/// Forum Copilot Private Message Proxy Interface
///
/// This interface defines the contract for private message operations including:
/// - Creating and managing private messages
/// - Getting message boxes and details
/// - Managing message status (read/unread/delete)
/// - Reporting problematic messages
abstract class IFCPrivateMessageProxy {
  /// Report a problematic private message to moderator
  ///
  /// [msgId] - Message ID
  /// [reason] - Optional reason to describe the problem
  Future<FCReportPMResult> reportPmAsync(String msgId, String? reason);

  /// Send a private message to one or more users
  ///
  /// [userName] - List of user names to send message to
  /// [subject] - Message subject
  /// [textBody] - Message body
  /// [action] - 1 = REPLY to a message; 2 = FORWARD to a message
  /// [pmId] - PM ID for reply/forward actions
  /// [attachmentIds] - List of attachment IDs
  /// [groupId] - Group ID for attachments
  Future<FCCreateMessageResult> createMessageAsync(List<String> userName, String subject, String textBody, int? action, String? pmId, List<String>? attachmentIds, String? groupId);

  /// Get information about message boxes
  Future<FCBoxInfoResult> getBoxInfoAsync();

  /// Get messages from a specific box
  ///
  /// [boxId] - Box ID to get messages from
  /// [startNum] - Start number for pagination
  /// [endNum] - End number for pagination
  Future<FCBoxResult> getBoxAsync(String boxId, int startNum, int endNum);

  /// Get details of a specific message
  ///
  /// [messageId] - Message ID to get
  /// [boxId] - Box ID containing the message
  /// [returnHtml] - Whether to return HTML content
  Future<FCMessageResult> getMessageAsync(String messageId, String boxId, bool returnHtml);

  /// Get quote for a private message
  ///
  /// [messageId] - Message ID to quote
  Future<FCQuotePMResult> getQuotePmAsync(String messageId);

  /// Delete a private message
  ///
  /// [messageId] - Message ID to delete
  /// [boxId] - Box ID containing the message
  Future<FCDeleteMessageResult> deleteMessageAsync(String messageId, String boxId);

  /// Mark a private message as unread
  ///
  /// [messageId] - Message ID to mark as unread
  Future<FCMarkPMUnreadResult> markPmUnreadAsync(String messageId);

  /// Mark private messages as read
  ///
  /// [messageIds] - List of message IDs to mark as read
  Future<FCMarkPMReadResult> markPmReadAsync(List<String> messageIds);
}
