import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_subscription_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_subscription_result.dart';
import '../base_xenforo_proxy.dart';
import 'package:forumcopilot_sdk/models/entities/fc_notification_level.dart';
import 'package:forumcopilot_sdk/models/results/fc_notification_result.dart';

/// XenForo implementation of IFCSubscriptionProxy
/// Handles subscription operations for XenForo forums
class XenForoSubscriptionProxy extends BaseXenForoProxy implements IFCSubscriptionProxy {
  XenForoSubscriptionProxy(SiteContext context) : super(context);

  @override
  Future<FCSubscribedForumResult> getSubscribedForumAsync() async {
    print('✅ [XENFORO_SUBSCRIPTION] getSubscribedForumAsync called via plugin API');

    try {
      final response = await callPluginApi('getSubscribedForum', {});

      // Parse forum list - PHP returns array with forum data
      final List<FCSubscribedForum> forumList = [];
      if (response['forums'] != null && response['forums'] is List) {
        for (var forumData in response['forums'] as List) {
          if (forumData is Map<String, dynamic>) {
            // Map PHP response structure to FCSubscribedForum
            forumList.add(FCSubscribedForum(
              forumId: forumData['id']?.toString() ?? '',
              forumName: forumData['name']?.toString() ?? '',
              isProtected: false, // Not provided by PHP
              newPost: !(forumData['isRead'] ?? true),
              canPost: forumData['canPost'] ?? false,
              subscribeMode: forumData['subscribeMode'] ?? 0,
            ));
          }
        }
      }

      return FCSubscribedForumResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        totalForumsNum: response['totalForumsNum'] ?? response['totalForumNum'] ?? forumList.length,
        forums: forumList,
      );
    } catch (e) {
      print('❌ [XENFORO_SUBSCRIPTION] getSubscribedForumAsync error: $e');
      return FCSubscribedForumResult(
        result: false,
        resultText: 'Error getting subscribed forums: $e',
        forums: [],
      );
    }
  }

  @override
  Future<FCSubscribeForumResult> subscribeForumAsync(String forumId, int subscribeMode) async {
    print('✅ [XENFORO_SUBSCRIPTION] subscribeForumAsync called via plugin API');
    print('   📋 Parameters: forumId=$forumId, subscribeMode=$subscribeMode');

    try {
      final response = await callPluginApi('subscribeForum', {
        'forumId': forumId,
        'subscribeMode': subscribeMode,
      });

      return FCSubscribeForumResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_SUBSCRIPTION] subscribeForumAsync error: $e');
      return FCSubscribeForumResult(
        result: false,
        resultText: 'Error subscribing to forum: $e',
      );
    }
  }

  @override
  Future<FCUnsubscribeForumResult> unsubscribeForumAsync(String forumId) async {
    print('✅ [XENFORO_SUBSCRIPTION] unsubscribeForumAsync called via plugin API');
    print('   📋 Parameters: forumId=$forumId');

    try {
      final response = await callPluginApi('unsubscribeForum', {
        'forumId': forumId,
      });

      return FCUnsubscribeForumResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_SUBSCRIPTION] unsubscribeForumAsync error: $e');
      return FCUnsubscribeForumResult(
        result: false,
        resultText: 'Error unsubscribing from forum: $e',
      );
    }
  }

  @override
  Future<FCSubscribedTopicResult> getSubscribedTopicAsync(int startNum, int lastNum) async {
    print('✅ [XENFORO_SUBSCRIPTION] getSubscribedTopicAsync called via plugin API');
    print('   📋 Parameters: startNum=$startNum, lastNum=$lastNum');

    try {
      final response = await callPluginApi('getSubscribedTopic', {
        'startNum': startNum,
        'lastNum': lastNum,
      });

      // Parse topic list - PHP returns array with topic data
      final List<FCSubscribedTopic> topicList = [];
      if (response['topics'] != null && response['topics'] is List) {
        for (var topicData in response['topics'] as List) {
          if (topicData is Map<String, dynamic>) {
            // Map PHP response structure to FCSubscribedTopic
            // Only set required fields, optional fields use defaults
            final timestamp = int.tryParse(topicData['timestamp']?.toString() ?? '0') ?? 0;
            topicList.add(FCSubscribedTopic(
              forumId: topicData['forumId']?.toString() ?? '',
              forumName: topicData['forumName']?.toString() ?? '',
              topicId: topicData['id']?.toString() ?? '',
              topicTitle: topicData['title']?.toString() ?? '',
              postAuthorName: topicData['authorName']?.toString() ?? '',
              postAuthorId: topicData['authorId']?.toString() ?? '',
              postAuthorUserType: topicData['authorUserType']?.toString(),
              postTime: DateTime.fromMillisecondsSinceEpoch(timestamp),
              iconUrl: topicData['authorIconUrl']?.toString(),
              isClosed: topicData['isClosed'] ?? false,
              replyNumber: topicData['replyCount'] ?? 0,
              viewNumber: topicData['viewCount'] ?? 0,
              shortContent: topicData['shortContent']?.toString(),
              newPost: topicData['hasNewPosts'] ?? false,
              subscribeMode: topicData['subscribeMode'] ?? 0,
              isSticky: topicData['isPinned'] ?? false,
              isAnnouncement: topicData['isAnnouncement'] ?? false,
              isSubscribed: topicData['isSubscribed'] ?? true,
            ));
          }
        }
      }

      return FCSubscribedTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        totalTopicNum: response['totalTopicNum'] ?? 0,
        topics: topicList,
      );
    } catch (e) {
      print('❌ [XENFORO_SUBSCRIPTION] getSubscribedTopicAsync error: $e');
      return FCSubscribedTopicResult(
        result: false,
        resultText: 'Error getting subscribed topics: $e',
        totalTopicNum: 0,
        topics: [],
      );
    }
  }

  @override
  Future<FCSubscribeTopicResult> subscribeTopicAsync(String topicId, int subscribeMode) async {
    print('✅ [XENFORO_SUBSCRIPTION] subscribeTopicAsync called via plugin API');
    print('   📋 Parameters: topicId=$topicId, subscribeMode=$subscribeMode');

    try {
      final response = await callPluginApi('subscribeTopic', {
        'topicId': topicId,
        'subscribeMode': subscribeMode,
      });

      return FCSubscribeTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_SUBSCRIPTION] subscribeTopicAsync error: $e');
      return FCSubscribeTopicResult(
        result: false,
        resultText: 'Error subscribing to topic: $e',
      );
    }
  }

  @override
  Future<FCUnsubscribeTopicResult> unsubscribeTopicAsync(String topicId) async {
    print('✅ [XENFORO_SUBSCRIPTION] unsubscribeTopicAsync called via plugin API');
    print('   📋 Parameters: topicId=$topicId');

    try {
      final response = await callPluginApi('unsubscribeTopic', {
        'topicId': topicId,
      });

      return FCUnsubscribeTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_SUBSCRIPTION] unsubscribeTopicAsync error: $e');
      return FCUnsubscribeTopicResult(
        result: false,
        resultText: 'Error unsubscribing from topic: $e',
      );
    }
  }

  @override
  Future<FCNotificationLevelResult> setTopicNotificationLevelAsync(
          String topicId, FCNotificationLevel level) async =>
      FCNotificationLevelResult(
          result: false,
          resultText: 'Notification levels are not supported on XenForo');

  @override
  Future<FCNotificationLevelResult> getTopicNotificationLevelAsync(
          String topicId) async =>
      FCNotificationLevelResult(
          result: false,
          resultText: 'Notification levels are not supported on XenForo');

  @override
  Future<FCNotificationLevelResult> setCategoryNotificationLevelAsync(
          String categoryId, FCNotificationLevel level) async =>
      FCNotificationLevelResult(
          result: false,
          resultText: 'Notification levels are not supported on XenForo');

  @override
  Future<FCNotificationLevelResult> getCategoryNotificationLevelAsync(
          String categoryId) async =>
      FCNotificationLevelResult(
          result: false,
          resultText: 'Notification levels are not supported on XenForo');
}
