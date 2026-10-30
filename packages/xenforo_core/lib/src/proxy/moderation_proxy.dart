import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_moderation_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_moderation_result.dart';
import '../base_xenforo_proxy.dart';
import '../xf_debug.dart';
import '../network/xenforo_client.dart';

/// XenForo implementation of IFCModerationProxy
/// Handles moderation operations for XenForo forums
class XenForoModerationProxy extends BaseXenForoProxy implements IFCModerationProxy {
  XenForoModerationProxy(SiteContext context, {XenForoClient? client}) : super(context, client: client);

  @override
  Future<FCLoginModResult> doLoginModAsync(String username, String password) async {
    xfDebug('⚠️ [XENFORO_MODERATION] doLoginModAsync not fully implemented, returning stub result.');
    return FCLoginModResult(
      result: false,
      resultText: 'Moderator login not implemented',
    );
  }

  @override
  Future<FCStickTopicResult> stickTopicAsync(String topicId) async {
    xfDebug('✅ [XENFORO_MODERATION] stickTopicAsync called');
    try {
      final response = await callPluginApi('stickTopic', <String, dynamic>{
        'topicId': topicId,
      });
      return FCStickTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] stickTopicAsync error: $e');
      return FCStickTopicResult(
        result: false,
        resultText: 'Error: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCStickTopicResult> unstickTopicAsync(String topicId) async {
    xfDebug('✅ [XENFORO_MODERATION] unstickTopicAsync called');
    try {
      final response = await callPluginApi('unstickTopic', <String, dynamic>{
        'topicId': topicId,
      });
      return FCStickTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] unstickTopicAsync error: $e');
      return FCStickTopicResult(
        result: false,
        resultText: 'Error: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCCloseTopicResult> closeTopicAsync(String topicId) async {
    xfDebug('✅ [XENFORO_MODERATION] closeTopicAsync called - IMPLEMENTED');
    xfDebug('   📋 Parameters: topicId=$topicId');
    
    try {
      final params = <String, dynamic>{
        'topicId': topicId,
      };
      
      xfDebug('🔍 [XENFORO_MODERATION] Calling closeTopic API with params: $params');
      final response = await callPluginApi('closeTopic', params);
      
      return FCCloseTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] closeTopicAsync error: $e');
      return FCCloseTopicResult(
        result: false,
        resultText: 'Error closing topic: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCCloseTopicResult> uncloseTopicAsync(String topicId) async {
    xfDebug('✅ [XENFORO_MODERATION] uncloseTopicAsync called - IMPLEMENTED');
    xfDebug('   📋 Parameters: topicId=$topicId');
    
    try {
      final params = <String, dynamic>{
        'topicId': topicId,
      };
      
      xfDebug('🔍 [XENFORO_MODERATION] Calling uncloseTopic API with params: $params');
      final response = await callPluginApi('uncloseTopic', params);
      
      return FCCloseTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] uncloseTopicAsync error: $e');
      return FCCloseTopicResult(
        result: false,
        resultText: 'Error opening topic: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCDeleteTopicResult> deleteTopicAsync(String topicId, int mode, String reason) async {
    xfDebug('✅ [XENFORO_MODERATION] deleteTopicAsync called - IMPLEMENTED');
    xfDebug('   📋 Parameters: topicId=$topicId, mode=$mode, reason=$reason');
    
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
      
      xfDebug('🔍 [XENFORO_MODERATION] Calling deleteTopic API with params: $params');
      final response = await callPluginApi('deleteTopic', params);
      
      return FCDeleteTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] deleteTopicAsync error: $e');
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
  @override
  Future<FCDeleteTopicResult> deleteTopicExtendedAsync(
    String topicId, {
    bool hardDelete = false,
    String? reason,
    bool starterAlert = false,
    String? starterAlertReason,
  }) async {
    xfDebug('✅ [XENFORO_MODERATION] deleteTopicExtendedAsync called - IMPLEMENTED');
    xfDebug('   📋 Parameters: topicId=$topicId, hardDelete=$hardDelete, reason=$reason, starterAlert=$starterAlert, starterAlertReason=$starterAlertReason');
    
    try {
      final params = <String, dynamic>{
        'topicId': topicId,
        'hardDelete': hardDelete,
        'reason': reason ?? '',
        'starterAlert': starterAlert,
        'starterAlertReason': starterAlertReason ?? '',
      };
      
      xfDebug('🔍 [XENFORO_MODERATION] Calling deleteTopic API with params: $params');
      final response = await callPluginApi('deleteTopic', params);
      
      return FCDeleteTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] deleteTopicExtendedAsync error: $e');
      return FCDeleteTopicResult(
        result: false,
        resultText: 'Error deleting topic: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCDeletePostResult> deletePostAsync(String postId, int mode, String reason) async {
    xfDebug('✅ [XENFORO_MODERATION] deletePostAsync called - IMPLEMENTED');
    xfDebug('   📋 Parameters: postId=$postId, mode=$mode, reason=$reason');
    
    // Map FC delete mode to XenForo hardDelete:
    // FC: mode 1 = soft delete, mode 2 = hard delete
    // XenForo: hardDelete false = soft delete, hardDelete true = hard delete
    final hardDelete = (mode == 2);
    
    try {
      final params = <String, dynamic>{
        'postId': postId,
        'hardDelete': hardDelete,
        'reason': reason,
      };
      
      xfDebug('🔍 [XENFORO_MODERATION] Calling deletePost API with params: $params');
      final response = await callPluginApi('deletePost', params);
      
      return FCDeletePostResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] deletePostAsync error: $e');
      return FCDeletePostResult(
        result: false,
        resultText: 'Error deleting post: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCUndeleteTopicResult> undeleteTopicAsync(String topicId, String reason) async {
    xfDebug('✅ [XENFORO_MODERATION] undeleteTopicAsync called');
    try {
      final response = await callPluginApi('undeleteTopic', <String, dynamic>{
        'topicId': topicId,
        'reason': reason,
      });
      return FCUndeleteTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] undeleteTopicAsync error: $e');
      return FCUndeleteTopicResult(
        result: false,
        resultText: 'Error: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCUndeletePostResult> undeletePostAsync(String postId, String reason) async {
    xfDebug('✅ [XENFORO_MODERATION] undeletePostAsync called');
    try {
      final response = await callPluginApi('undeletePost', <String, dynamic>{
        'postId': postId,
        'reason': reason,
      });
      return FCUndeletePostResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] undeletePostAsync error: $e');
      return FCUndeletePostResult(
        result: false,
        resultText: 'Error: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCMoveTopicResult> moveTopicAsync(String topicId, String forumId, bool redirect) async {
    xfDebug('✅ [XENFORO_MODERATION] moveTopicAsync called');
    try {
      final response = await callPluginApi('moveTopic', <String, dynamic>{
        'topicId': topicId,
        'forumId': forumId,
        'redirect': redirect,
      });
      return FCMoveTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] moveTopicAsync error: $e');
      return FCMoveTopicResult(
        result: false,
        resultText: 'Error: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCRenameTopicResult> renameTopicAsync(String topicId, String title) async {
    xfDebug('✅ [XENFORO_MODERATION] renameTopicAsync called');
    try {
      final response = await callPluginApi('renameTopic', <String, dynamic>{
        'topicId': topicId,
        'title': title,
      });
      return FCRenameTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] renameTopicAsync error: $e');
      return FCRenameTopicResult(
        result: false,
        resultText: 'Error: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCMovePostResult> movePostAsync(String postId, String? topicId, String? topicTitle, String? forumId) async {
    xfDebug('⚠️ [XENFORO_MODERATION] movePostAsync not fully implemented, returning stub result.');
    return FCMovePostResult(
      result: false,
      resultText: 'Move post not implemented',
    );
  }

  @override
  Future<FCMergeTopicResult> mergeTopicAsync(String topicId1, String topicId2, bool redirect) async {
    xfDebug('⚠️ [XENFORO_MODERATION] mergeTopicAsync not fully implemented, returning stub result.');
    return FCMergeTopicResult(
      result: false,
      resultText: 'Merge topic not implemented',
    );
  }

  @override
  Future<FCModerateTopicResult> getModerateTopicAsync(int startNum, int lastNum) async {
    xfDebug('⚠️ [XENFORO_MODERATION] getModerateTopicAsync not fully implemented, returning stub result.');
    return FCModerateTopicResult(
      result: false,
      resultText: 'Get moderate topics not implemented',
      total: 0,
      list: [],
    );
  }

  @override
  Future<FCModeratePostResult> getModeratePostAsync(int startNum, int lastNum) async {
    xfDebug('⚠️ [XENFORO_MODERATION] getModeratePostAsync not fully implemented, returning stub result.');
    return FCModeratePostResult(
      result: false,
      resultText: 'Get moderate posts not implemented',
      total: 0,
      list: [],
    );
  }

  @override
  Future<FCDeletedTopicResult> getDeletedTopicAsync(int startNum, int lastNum) async {
    xfDebug('⚠️ [XENFORO_MODERATION] getDeletedTopicAsync not fully implemented, returning stub result.');
    return FCDeletedTopicResult(
      result: false,
      resultText: 'Get deleted topics not implemented',
      total: 0,
      list: [],
    );
  }

  @override
  Future<FCDeletedPostResult> getDeletedPostAsync(int startNum, int lastNum) async {
    xfDebug('⚠️ [XENFORO_MODERATION] getDeletedPostAsync not fully implemented, returning stub result.');
    return FCDeletedPostResult(
      result: false,
      resultText: 'Get deleted posts not implemented',
      total: 0,
      list: [],
    );
  }

  @override
  Future<FCReportedPostResult> getReportedPostAsync(int startNum, int lastNum) async {
    xfDebug('⚠️ [XENFORO_MODERATION] getReportedPostAsync not fully implemented, returning stub result.');
    return FCReportedPostResult(
      result: false,
      resultText: 'Get reported posts not implemented',
      total: 0,
      list: [],
    );
  }

  @override
  Future<FCApproveTopicResult> approveTopicAsync(String topicId) async {
    xfDebug('✅ [XENFORO_MODERATION] approveTopicAsync called');
    try {
      final response = await callPluginApi('approveTopic', <String, dynamic>{
        'topicId': topicId,
      });
      return FCApproveTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] approveTopicAsync error: $e');
      return FCApproveTopicResult(
        result: false,
        resultText: 'Error: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCApprovePostResult> approvePostAsync(String postId) async {
    xfDebug('✅ [XENFORO_MODERATION] approvePostAsync called');
    try {
      final response = await callPluginApi('approvePost', <String, dynamic>{
        'postId': postId,
      });
      return FCApprovePostResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] approvePostAsync error: $e');
      return FCApprovePostResult(
        result: false,
        resultText: 'Error: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCBanUserResult> banUserAsync(String userName, String reason, int banExpires, int deletePostMode, int deletePostValue) async {
    xfDebug('✅ [XENFORO_MODERATION] banUserAsync called - IMPLEMENTED');
    xfDebug('   📋 Parameters: userName=$userName, reason=$reason, banExpires=$banExpires, deletePostMode=$deletePostMode, deletePostValue=$deletePostValue');

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
        // Add-on 1.11.0+ reads the exact end (Unix seconds); older ones read
        // endDate, which they take in the moderator's (or the server's) time zone
        params['endTime'] = banExpires.toString();
      }

      xfDebug('🔍 [XENFORO_MODERATION] Calling banUser API with params: $params');
      final response = await callPluginApi('banUser', params);

      return FCBanUserResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] banUserAsync error: $e');
      return FCBanUserResult(
        result: false,
        resultText: 'Error banning user: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCUnbanUserResult> unbanUserAsync(String userId) async {
    xfDebug('✅ [XENFORO_MODERATION] unbanUserAsync called - IMPLEMENTED');
    xfDebug('   📋 Parameters: userId=$userId');

    try {
      final params = {
        'userId': userId,
      };

      xfDebug('🔍 [XENFORO_MODERATION] Calling unbanUser API with params: $params');
      final response = await callPluginApi('unbanUser', params);

      return FCUnbanUserResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString(),
        isLoginMod: response['isLoginMod'] ?? true,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_MODERATION] unbanUserAsync error: $e');
      return FCUnbanUserResult(
        result: false,
        resultText: 'Error unbanning user: $e',
        isLoginMod: true,
      );
    }
  }

  @override
  Future<FCMarkAsSpamResult> markAsSpamAsync(String userId) async {
    xfDebug('⚠️ [XENFORO_MODERATION] markAsSpamAsync not fully implemented, returning stub result.');
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
    xfDebug('✅ [XENFORO_MODERATION] spamCleanUserAsync called - IMPLEMENTED');
    xfDebug('   📋 Parameters: userId=$userId, username=$username, actionThreads=$actionThreads, deleteMessages=$deleteMessages, deleteConversations=$deleteConversations, banUser=$banUser');

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

      xfDebug('🔍 [XENFORO_MODERATION] Calling spamCleanUser API with params: $params');
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
      xfDebug('❌ [XENFORO_MODERATION] spamCleanUserAsync error: $e');
      return FCSpamCleanUserResult(
        result: false,
        resultText: 'Error cleaning spam: $e',
      );
    }
  }

  @override
  Future<FCDeleteTopicResult> archiveTopicAsync(String topicId,
          {required bool archived}) async =>
      FCDeleteTopicResult(
          result: false,
          resultText: 'Topic archiving is not supported on XenForo');

  @override
  Future<FCDeleteTopicResult> setTopicVisibilityAsync(String topicId,
          {required bool visible}) async =>
      FCDeleteTopicResult(
          result: false,
          resultText: 'Topic visibility toggling is not supported on XenForo');
}
