import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_private_message_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_message_result.dart';
import '../base_xenforo_proxy.dart';

/// XenForo implementation of IFCPrivateMessageProxy
/// Handles private message operations for XenForo forums
class XenForoPrivateMessageProxy extends BaseXenForoProxy implements IFCPrivateMessageProxy {
  XenForoPrivateMessageProxy(SiteContext context) : super(context);

  @override
  Future<FCReportPMResult> reportPmAsync(String msgId, String? reason) async {
    print('⚠️ [XENFORO_PRIVATE_MESSAGE] reportPmAsync not fully implemented, returning stub result.');
    return FCReportPMResult(
      result: false,
      resultText: 'Report PM not implemented',
    );
  }

  @override
  Future<FCCreateMessageResult> createMessageAsync(List<String> userName, String subject, String textBody, int? action, String? pmId, List<String>? attachmentIds, String? groupId) async {
    print('⚠️ [XENFORO_PRIVATE_MESSAGE] createMessageAsync not fully implemented, returning stub result.');
    return FCCreateMessageResult(
      result: false,
      resultText: 'Create message not implemented',
      msgId: '',
    );
  }

  @override
  Future<FCBoxInfoResult> getBoxInfoAsync() async {
    print('⚠️ [XENFORO_PRIVATE_MESSAGE] getBoxInfoAsync not fully implemented, returning stub result.');
    return FCBoxInfoResult(
      result: false,
      resultText: 'Get box info not implemented',
      messageRoomCount: 0,
      list: [],
    );
  }

  @override
  Future<FCBoxResult> getBoxAsync(String boxId, int startNum, int endNum) async {
    print('⚠️ [XENFORO_PRIVATE_MESSAGE] getBoxAsync not fully implemented, returning stub result.');
    return FCBoxResult(
      result: false,
      resultText: 'Get box not implemented',
      totalMessageNum: 0,
      list: [],
    );
  }

  @override
  Future<FCMessageResult> getMessageAsync(String messageId, String boxId, bool returnHtml) async {
    print('⚠️ [XENFORO_PRIVATE_MESSAGE] getMessageAsync not fully implemented, returning stub result.');
    return FCMessageResult(
      result: false,
      resultText: 'Get message not implemented',
      msgId: '',
      subject: '',
      authorId: '',
      authorName: '',
      textBody: '',
      msgTime: '',
      isUnread: false,
    );
  }

  @override
  Future<FCQuotePMResult> getQuotePmAsync(String messageId) async {
    print('⚠️ [XENFORO_PRIVATE_MESSAGE] getQuotePmAsync not fully implemented, returning stub result.');
    return FCQuotePMResult(
      result: false,
      resultText: 'Get quote PM not implemented',
    );
  }

  @override
  Future<FCDeleteMessageResult> deleteMessageAsync(String messageId, String boxId) async {
    print('⚠️ [XENFORO_PRIVATE_MESSAGE] deleteMessageAsync not fully implemented, returning stub result.');
    return FCDeleteMessageResult(
      result: false,
      resultText: 'Delete message not implemented',
    );
  }

  @override
  Future<FCMarkPMUnreadResult> markPmUnreadAsync(String messageId) async {
    print('⚠️ [XENFORO_PRIVATE_MESSAGE] markPmUnreadAsync not fully implemented, returning stub result.');
    return FCMarkPMUnreadResult(
      result: false,
      resultText: 'Mark PM unread not implemented',
    );
  }

  @override
  Future<FCMarkPMReadResult> markPmReadAsync(List<String> messageIds) async {
    print('⚠️ [XENFORO_PRIVATE_MESSAGE] markPmReadAsync not fully implemented, returning stub result.');
    return FCMarkPMReadResult(
      result: false,
      resultText: 'Mark PM read not implemented',
    );
  }
}
