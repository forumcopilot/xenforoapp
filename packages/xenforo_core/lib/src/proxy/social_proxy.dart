import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_social_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_social_result.dart';
import '../base_xenforo_proxy.dart';

/// XenForo implementation of IFCSocialProxy
/// Handles social operations for XenForo forums
class XenForoSocialProxy extends BaseXenForoProxy implements IFCSocialProxy {
  XenForoSocialProxy(SiteContext context) : super(context);

  @override
  Future<FCThankPostResult> thankPostAsync(String postId) async {
    print('✅ [XENFORO_SOCIAL] thankPostAsync called via plugin API');
    print('   📋 Parameters: postId=$postId');

    try {
      final response = await callPluginApi('thankPost', {
        'postId': postId,
      });

      return FCThankPostResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_SOCIAL] thankPostAsync error: $e');
      return FCThankPostResult(
        result: false,
        resultText: 'Error thanking post: $e',
      );
    }
  }

  @override
  Future<FCFollowResult> followAsync(String userId) async {
    print('✅ [XENFORO_SOCIAL] followAsync called via plugin API');
    print('   📋 Parameters: userId=$userId');

    try {
      final response = await callPluginApi('follow', {
        'userId': userId,
      });

      return FCFollowResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_SOCIAL] followAsync error: $e');
      return FCFollowResult(
        result: false,
        resultText: 'Error following user: $e',
      );
    }
  }

  @override
  Future<FCUnfollowResult> unfollowAsync(String userId) async {
    print('✅ [XENFORO_SOCIAL] unfollowAsync called via plugin API');
    print('   📋 Parameters: userId=$userId');

    try {
      final response = await callPluginApi('unfollow', {
        'userId': userId,
      });

      return FCUnfollowResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_SOCIAL] unfollowAsync error: $e');
      return FCUnfollowResult(
        result: false,
        resultText: 'Error unfollowing user: $e',
      );
    }
  }

  @override
  Future<FCLikePostResult> likePostAsync(String postId, {int reactionId = 1}) async {
    print('✅ [XENFORO_SOCIAL] likePostAsync called via plugin API');
    print('   📋 Parameters: postId=$postId, reactionId=$reactionId');

    try {
      final response = await callPluginApi('likePost', {
        'postId': postId,
        'reactionId': reactionId,
      });

      // Note: the server also returns visitorReactionId, but the app already
      // knows which reaction it sent and uses `isLiked` to tell add (true) from
      // toggle-off (false), so we don't need it on the mapped result model
      // (avoids a dart_mappable regen).
      return FCLikePostResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        isLiked: response['isLiked'] ?? true,
        likeCount: response['likeCount'] != null ? int.tryParse(response['likeCount'].toString()) ?? 0 : 0,
      );
    } catch (e) {
      print('❌ [XENFORO_SOCIAL] likePostAsync error: $e');
      return FCLikePostResult(
        result: false,
        resultText: 'Error liking post: $e',
      );
    }
  }

  @override
  Future<FCUnlikePostResult> unlikePostAsync(String postId) async {
    print('✅ [XENFORO_SOCIAL] unlikePostAsync called via plugin API');
    print('   📋 Parameters: postId=$postId');

    try {
      final response = await callPluginApi('unlikePost', {
        'postId': postId,
      });

      return FCUnlikePostResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        isLiked: response['isLiked'] ?? false,
        likeCount: response['likeCount'] != null ? int.tryParse(response['likeCount'].toString()) ?? 0 : 0,
      );
    } catch (e) {
      print('❌ [XENFORO_SOCIAL] unlikePostAsync error: $e');
      return FCUnlikePostResult(
        result: false,
        resultText: 'Error unliking post: $e',
      );
    }
  }

  @override
  Future<FCLikePostResult> likeConversationMessageAsync(String messageId, {int reactionId = 1}) async {
    print('✅ [XENFORO_SOCIAL] likeConversationMessageAsync called via plugin API');
    print('   📋 Parameters: messageId=$messageId, reactionId=$reactionId');

    try {
      final response = await callPluginApi('likeConversationMessage', {
        'messageId': messageId,
        'reactionId': reactionId,
      });

      return FCLikePostResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        isLiked: response['isLiked'] ?? true,
        likeCount: response['likeCount'] != null ? int.tryParse(response['likeCount'].toString()) ?? 0 : 0,
      );
    } catch (e) {
      print('❌ [XENFORO_SOCIAL] likeConversationMessageAsync error: $e');
      return FCLikePostResult(
        result: false,
        resultText: 'Error liking conversation message: $e',
      );
    }
  }

  @override
  Future<FCUnlikePostResult> unlikeConversationMessageAsync(String messageId) async {
    print('✅ [XENFORO_SOCIAL] unlikeConversationMessageAsync called via plugin API');
    print('   📋 Parameters: messageId=$messageId');

    try {
      final response = await callPluginApi('unlikeConversationMessage', {
        'messageId': messageId,
      });

      return FCUnlikePostResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        isLiked: response['isLiked'] ?? false,
        likeCount: response['likeCount'] != null ? int.tryParse(response['likeCount'].toString()) ?? 0 : 0,
      );
    } catch (e) {
      print('❌ [XENFORO_SOCIAL] unlikeConversationMessageAsync error: $e');
      return FCUnlikePostResult(
        result: false,
        resultText: 'Error unliking conversation message: $e',
      );
    }
  }

  @override
  Future<FCAlertResult> getAlertAsync(int page, int perpage, bool forceRefresh) async {
    print('✅ [XENFORO_SOCIAL] getAlertAsync called via plugin API');
    print('   📋 Parameters: page=$page, perpage=$perpage, forceRefresh=$forceRefresh');

    try {
      final response = await callPluginApi('getAlert', {
        'page': page,
        'perpage': perpage,
        'forceRefresh': forceRefresh,
      });

      // Parse alert list - PHP returns 'items' array with alert data
      final List<FCAlert> alertList = [];
      if (response['items'] != null && response['items'] is List) {
        for (var alertData in response['items'] as List) {
          if (alertData is Map<String, dynamic>) {
            // Get alert type
            final alertType = alertData['type']?.toString() ?? '';
            
            // Use API-provided contentId
            final contentId = alertData['contentId']?.toString() ?? '';
            
            // Handle timestamp - can be number (milliseconds) or string
            String timestampStr;
            if (alertData['timestamp'] != null) {
              if (alertData['timestamp'] is num) {
                // Convert number (milliseconds) to string
                timestampStr = alertData['timestamp'].toString();
              } else {
                timestampStr = alertData['timestamp'].toString();
              }
            } else {
              timestampStr = DateTime.now().millisecondsSinceEpoch.toString();
            }
            
            // Map PHP response structure to FCAlert
            alertList.add(FCAlert(
              userId: alertData['fromUserId']?.toString() ?? '',
              username: alertData['fromUsername']?.toString() ?? '',
              iconUrl: alertData['fromUserIconUrl']?.toString() ?? '',
              message: alertData['message']?.toString() ?? '',
              timestamp: timestampStr,
              contentType: alertType,
              contentId: contentId,
              topicId: alertData['topicId']?.toString(),
              postId: alertData['postId']?.toString(),
              conversationId: alertData['conversationId']?.toString(),
              actionUrl: alertData['actionUrl']?.toString(),
              fromUsername: alertData['fromUsername']?.toString(),
              action: alertData['action']?.toString(),
            ));
          }
        }
      }

      return FCAlertResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        total: response['total'] ?? 0,
        items: alertList,
      );
    } catch (e) {
      print('❌ [XENFORO_SOCIAL] getAlertAsync error: $e');
      return FCAlertResult(
        result: false,
        resultText: 'Error getting alerts: $e',
        total: 0,
        items: [],
      );
    }
  }

  @override
  Future<FCActivityResult> getActivityAsync(int page, int perpage) async {
    print('⚠️ [XENFORO_SOCIAL] getActivityAsync not fully implemented, returning stub result.');
    return FCActivityResult(
      result: false,
      resultText: 'Get activity not implemented',
      total: 0,
      items: [],
    );
  }

  @override
  Future<FCMarkAlertsReadResult> markAllAlertsReadAsync() async =>
      FCMarkAlertsReadResult(
          result: false,
          resultText: 'Bulk mark-read is not supported on XenForo');
}
