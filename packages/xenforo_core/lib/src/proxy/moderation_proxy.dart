import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_moderation_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_moderation_result.dart';
import '../base_xenforo_proxy.dart';

/// XenForo implementation of IFCModerationProxy
/// Handles moderation operations for XenForo forums
class XenForoModerationProxy extends BaseXenForoProxy implements IFCModerationProxy {
  XenForoModerationProxy(SiteContext context) : super(context);

  @override
  Future<FCLoginModResult> doLoginModAsync(String username, String password) async {
    print('⚠️ [XENFORO_MODERATION] doLoginModAsync not fully implemented, returning stub result.');
    return FCLoginModResult(
      result: false,
      resultText: 'Moderator login not implemented',
    );
  }

  @override
  Future<FCStickTopicResult> stickTopicAsync(String topicId) async {
    print('⚠️ [XENFORO_MODERATION] stickTopicAsync not fully implemented, returning stub result.');
    return FCStickTopicResult(
      result: false,
      resultText: 'Stick topic not implemented',
    );
  }

  @override
  Future<FCStickTopicResult> unstickTopicAsync(String topicId) async {
    print('⚠️ [XENFORO_MODERATION] unstickTopicAsync not fully implemented, returning stub result.');
    return FCStickTopicResult(
      result: false,
      resultText: 'Unstick topic not implemented',
    );
  }

  @override
  Future<FCCloseTopicResult> closeTopicAsync(String topicId) async {
    print('✅ [XENFORO_MODERATION] closeTopicAsync called - IMPLEMENTED');
    print('   📋 Parameters: topicId=$topicId');
    
    try {
      final params = <String, dynamic>{
        'topicId': topicId,
      };
      
      print('🔍 [XENFORO_MODERATION] Calling closeTopic API with params: $params');
      final response = await callPluginApi('closeTopic', params);
      
      return FCCloseTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      print('❌ [XENFORO_MODERATION] closeTopicAsync error: $e');
      return FCCloseTopicResult(
        result: false,
        resultText: 'Error closing topic: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCCloseTopicResult> uncloseTopicAsync(String topicId) async {
    print('✅ [XENFORO_MODERATION] uncloseTopicAsync called - IMPLEMENTED');
    print('   📋 Parameters: topicId=$topicId');
    
    try {
      final params = <String, dynamic>{
        'topicId': topicId,
      };
      
      print('🔍 [XENFORO_MODERATION] Calling uncloseTopic API with params: $params');
      final response = await callPluginApi('uncloseTopic', params);
      
      return FCCloseTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      print('❌ [XENFORO_MODERATION] uncloseTopicAsync error: $e');
      return FCCloseTopicResult(
        result: false,
        resultText: 'Error opening topic: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCDeleteTopicResult> deleteTopicAsync(String topicId, int mode, String reason) async {
    print('✅ [XENFORO_MODERATION] deleteTopicAsync called - IMPLEMENTED');
    print('   📋 Parameters: topicId=$topicId, mode=$mode, reason=$reason');
    
    // Map mode to hardDelete: mode 0 = soft delete (false), mode 1 = hard delete (true)
    // Note: This follows the API documentation where mode 0 = soft, mode 1 = hard
    final hardDelete = (mode == 1);
    
    try {
      final params = <String, dynamic>{
        'topicId': topicId,
        'hardDelete': hardDelete,
        'reason': reason,
        'starterAlert': false,
        'starterAlertReason': '',
      };
      
      print('🔍 [XENFORO_MODERATION] Calling deleteTopic API with params: $params');
      final response = await callPluginApi('deleteTopic', params);
      
      return FCDeleteTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      print('❌ [XENFORO_MODERATION] deleteTopicAsync error: $e');
      return FCDeleteTopicResult(
        result: false,
        resultText: 'Error deleting topic: $e',
        isLoginMod: true,
      );
    }
  }
  
  /// Extended delete topic method with full API parameter support
  /// 
  /// [topicId] - The ID of the topic to delete
  /// [hardDelete] - If true, permanently deletes the topic. If false, performs a soft delete (can be restored)
  /// [reason] - Optional reason for deletion (stored in moderator log)
  /// [starterAlert] - If true, sends an alert to the topic starter
  /// [starterAlertReason] - Custom reason message for the alert (only used if starterAlert is true)
  Future<FCDeleteTopicResult> deleteTopicExtendedAsync({
    required String topicId,
    required bool hardDelete,
    String? reason,
    bool starterAlert = false,
    String? starterAlertReason,
  }) async {
    print('✅ [XENFORO_MODERATION] deleteTopicExtendedAsync called - IMPLEMENTED');
    print('   📋 Parameters: topicId=$topicId, hardDelete=$hardDelete, reason=$reason, starterAlert=$starterAlert, starterAlertReason=$starterAlertReason');
    
    try {
      final params = <String, dynamic>{
        'topicId': topicId,
        'hardDelete': hardDelete,
        'reason': reason ?? '',
        'starterAlert': starterAlert,
        'starterAlertReason': starterAlertReason ?? '',
      };
      
      print('🔍 [XENFORO_MODERATION] Calling deleteTopic API with params: $params');
      final response = await callPluginApi('deleteTopic', params);
      
      return FCDeleteTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      print('❌ [XENFORO_MODERATION] deleteTopicExtendedAsync error: $e');
      return FCDeleteTopicResult(
        result: false,
        resultText: 'Error deleting topic: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCDeletePostResult> deletePostAsync(String postId, int mode, String reason) async {
    print('✅ [XENFORO_MODERATION] deletePostAsync called - IMPLEMENTED');
    print('   📋 Parameters: postId=$postId, mode=$mode, reason=$reason');
    
    // Map Tapatalk mode to XenForo hardDelete:
    // Tapatalk: mode 1 = soft delete, mode 2 = hard delete
    // XenForo: hardDelete false = soft delete, hardDelete true = hard delete
    final hardDelete = (mode == 2);
    
    try {
      final params = <String, dynamic>{
        'postId': postId,
        'hardDelete': hardDelete,
        'reason': reason,
      };
      
      print('🔍 [XENFORO_MODERATION] Calling deletePost API with params: $params');
      final response = await callPluginApi('deletePost', params);
      
      return FCDeletePostResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      print('❌ [XENFORO_MODERATION] deletePostAsync error: $e');
      return FCDeletePostResult(
        result: false,
        resultText: 'Error deleting post: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCUndeleteTopicResult> undeleteTopicAsync(String topicId, String reason) async {
    print('⚠️ [XENFORO_MODERATION] undeleteTopicAsync not fully implemented, returning stub result.');
    return FCUndeleteTopicResult(
      result: false,
      resultText: 'Undelete topic not implemented',
    );
  }

  @override
  Future<FCUndeletePostResult> undeletePostAsync(String postId, String reason) async {
    print('⚠️ [XENFORO_MODERATION] undeletePostAsync not fully implemented, returning stub result.');
    return FCUndeletePostResult(
      result: false,
      resultText: 'Undelete post not implemented',
    );
  }

  @override
  Future<FCMoveTopicResult> moveTopicAsync(String topicId, String forumId, bool redirect) async {
    print('⚠️ [XENFORO_MODERATION] moveTopicAsync not fully implemented, returning stub result.');
    return FCMoveTopicResult(
      result: false,
      resultText: 'Move topic not implemented',
    );
  }

  @override
  Future<FCRenameTopicResult> renameTopicAsync(String topicId, String title) async {
    print('⚠️ [XENFORO_MODERATION] renameTopicAsync not fully implemented, returning stub result.');
    return FCRenameTopicResult(
      result: false,
      resultText: 'Rename topic not implemented',
    );
  }

  @override
  Future<FCMovePostResult> movePostAsync(String postId, String? topicId, String? topicTitle, String? forumId) async {
    print('⚠️ [XENFORO_MODERATION] movePostAsync not fully implemented, returning stub result.');
    return FCMovePostResult(
      result: false,
      resultText: 'Move post not implemented',
    );
  }

  @override
  Future<FCMergeTopicResult> mergeTopicAsync(String topicId1, String topicId2, bool redirect) async {
    print('⚠️ [XENFORO_MODERATION] mergeTopicAsync not fully implemented, returning stub result.');
    return FCMergeTopicResult(
      result: false,
      resultText: 'Merge topic not implemented',
    );
  }

  @override
  Future<FCModerateTopicResult> getModerateTopicAsync(int startNum, int lastNum) async {
    print('⚠️ [XENFORO_MODERATION] getModerateTopicAsync not fully implemented, returning stub result.');
    return FCModerateTopicResult(
      result: false,
      resultText: 'Get moderate topics not implemented',
      total: 0,
      list: [],
    );
  }

  @override
  Future<FCModeratePostResult> getModeratePostAsync(int startNum, int lastNum) async {
    print('⚠️ [XENFORO_MODERATION] getModeratePostAsync not fully implemented, returning stub result.');
    return FCModeratePostResult(
      result: false,
      resultText: 'Get moderate posts not implemented',
      total: 0,
      list: [],
    );
  }

  @override
  Future<FCDeletedTopicResult> getDeletedTopicAsync(int startNum, int lastNum) async {
    print('⚠️ [XENFORO_MODERATION] getDeletedTopicAsync not fully implemented, returning stub result.');
    return FCDeletedTopicResult(
      result: false,
      resultText: 'Get deleted topics not implemented',
      total: 0,
      list: [],
    );
  }

  @override
  Future<FCDeletedPostResult> getDeletedPostAsync(int startNum, int lastNum) async {
    print('⚠️ [XENFORO_MODERATION] getDeletedPostAsync not fully implemented, returning stub result.');
    return FCDeletedPostResult(
      result: false,
      resultText: 'Get deleted posts not implemented',
      total: 0,
      list: [],
    );
  }

  @override
  Future<FCReportedPostResult> getReportedPostAsync(int startNum, int lastNum) async {
    print('⚠️ [XENFORO_MODERATION] getReportedPostAsync not fully implemented, returning stub result.');
    return FCReportedPostResult(
      result: false,
      resultText: 'Get reported posts not implemented',
      total: 0,
      list: [],
    );
  }

  @override
  Future<FCApproveTopicResult> approveTopicAsync(String topicId) async {
    print('⚠️ [XENFORO_MODERATION] approveTopicAsync not fully implemented, returning stub result.');
    return FCApproveTopicResult(
      result: false,
      resultText: 'Approve topic not implemented',
    );
  }

  @override
  Future<FCApprovePostResult> approvePostAsync(String postId) async {
    print('⚠️ [XENFORO_MODERATION] approvePostAsync not fully implemented, returning stub result.');
    return FCApprovePostResult(
      result: false,
      resultText: 'Approve post not implemented',
    );
  }

  @override
  Future<FCBanUserResult> banUserAsync(String userName, String reason, int banExpires, int deletePostMode, int deletePostValue) async {
    print('✅ [XENFORO_MODERATION] banUserAsync called - IMPLEMENTED');
    print('   📋 Parameters: userName=$userName, reason=$reason, banExpires=$banExpires, deletePostMode=$deletePostMode, deletePostValue=$deletePostValue');

    try {
      // Convert banExpires to banLength and endDate format expected by API
      String banLength;
      String? endDate;
      
      if (banExpires == 0) {
        // Permanent ban
        banLength = 'permanent';
        endDate = null;
      } else {
        // Temporary ban - banExpires is a timestamp (seconds since epoch)
        banLength = 'temporary';
        final endDateTime = DateTime.fromMillisecondsSinceEpoch(banExpires * 1000);
        // Format as "YYYY-MM-DD HH:MM:SS" for API
        endDate = '${endDateTime.year}-${endDateTime.month.toString().padLeft(2, '0')}-${endDateTime.day.toString().padLeft(2, '0')} ${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}:${endDateTime.second.toString().padLeft(2, '0')}';
      }

      final params = {
        'userName': userName,
        'reason': reason,
        'banLength': banLength,
      };
      
      if (endDate != null) {
        params['endDate'] = endDate;
      }

      print('🔍 [XENFORO_MODERATION] Calling banUser API with params: $params');
      final response = await callPluginApi('banUser', params);

      return FCBanUserResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      print('❌ [XENFORO_MODERATION] banUserAsync error: $e');
      return FCBanUserResult(
        result: false,
        resultText: 'Error banning user: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCUnbanUserResult> unbanUserAsync(String userId) async {
    print('✅ [XENFORO_MODERATION] unbanUserAsync called - IMPLEMENTED');
    print('   📋 Parameters: userId=$userId');

    try {
      final params = {
        'userId': userId,
      };

      print('🔍 [XENFORO_MODERATION] Calling unbanUser API with params: $params');
      final response = await callPluginApi('unbanUser', params);

      return FCUnbanUserResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      print('❌ [XENFORO_MODERATION] unbanUserAsync error: $e');
      return FCUnbanUserResult(
        result: false,
        resultText: 'Error unbanning user: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCMarkAsSpamResult> markAsSpamAsync(String userId) async {
    print('⚠️ [XENFORO_MODERATION] markAsSpamAsync not fully implemented, returning stub result.');
    return FCMarkAsSpamResult(
      result: false,
      resultText: 'Mark as spam not implemented',
    );
  }

  @override
  Future<FCSpamCleanUserResult> spamCleanUserAsync({
    String? userId,
    String? username,
    bool actionThreads = false,
    bool deleteMessages = false,
    bool deleteConversations = false,
    bool banUser = false,
  }) async {
    print('✅ [XENFORO_MODERATION] spamCleanUserAsync called - IMPLEMENTED');
    print('   📋 Parameters: userId=$userId, username=$username, actionThreads=$actionThreads, deleteMessages=$deleteMessages, deleteConversations=$deleteConversations, banUser=$banUser');

    // Validate that either userId OR username is provided
    if ((userId == null || userId.isEmpty) && (username == null || username.isEmpty)) {
      return FCSpamCleanUserResult(
        result: false,
        resultText: 'Either userId or username is required',
      );
    }

    try {
      final params = <String, dynamic>{};
      
      if (userId != null && userId.isNotEmpty) {
        params['userId'] = userId;
      }
      if (username != null && username.isNotEmpty) {
        params['username'] = username;
      }
      
      params['actionThreads'] = actionThreads;
      params['deleteMessages'] = deleteMessages;
      params['deleteConversations'] = deleteConversations;
      params['banUser'] = banUser;

      print('🔍 [XENFORO_MODERATION] Calling spamCleanUser API with params: $params');
      final response = await callPluginApi('spamCleanUser', params);

      // Parse actions from response if available
      Map<String, bool>? actions;
      if (response['actions'] != null && response['actions'] is Map) {
        final actionsMap = response['actions'] as Map;
        actions = {};
        actionsMap.forEach((key, value) {
          if (value is bool) {
            actions![key.toString()] = value;
          }
        });
      }

      return FCSpamCleanUserResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        userId: response['userId']?.toString(),
        username: response['username']?.toString(),
        actions: actions,
      );
    } catch (e) {
      print('❌ [XENFORO_MODERATION] spamCleanUserAsync error: $e');
      return FCSpamCleanUserResult(
        result: false,
        resultText: 'Error cleaning spam: $e',
      );
    }
  }
}
