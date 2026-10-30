import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_topic_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_topic_result.dart';
import 'package:forumcopilot_sdk/models/entities/fc_topic.dart';
import 'package:forumcopilot_sdk/models/entities/fc_topic_filters.dart';
import 'package:forumcopilot_sdk/models/entities/fc_thread_posting.dart';
import '../base_xenforo_proxy.dart';
import '../xf_debug.dart';
import '../network/xenforo_client.dart';

/// XenForo implementation of IFCTopicProxy
/// Handles thread/topic operations for XenForo forums
class XenForoTopicProxy extends BaseXenForoProxy implements IFCTopicProxy {
  XenForoTopicProxy(SiteContext context, {XenForoClient? client}) : super(context, client: client);

  @override
  Future<FCTopicDataResult> getAnnTopicAsync(String forumId, int startNum, int lastNum) async {
    xfDebug('✅ [XENFORO_TOPIC] getAnnTopic called - IMPLEMENTED');
    xfDebug('   📋 Parameters: forumId=$forumId, startNum=$startNum, lastNum=$lastNum');

    try {
      return await callPluginApiTyped<FCTopicDataResult>('getAnnTopic', {
        'forumId': forumId,
        'startNum': startNum,
        'lastNum': lastNum,
      }, (response) {
        final List<FCTopic> fcTopics = ((response['topics'] as List?) ?? []).whereType<Map>().map((t) => FCTopicMapper.fromMap(t.cast<String, dynamic>())).toList();

        return FCTopicDataResult(
          result: response['result'] ?? false,
          resultText: response['resultText'] ?? '',
          totalTopicNum: response['totalTopicNum'] ?? fcTopics.length,
          forumId: response['forumId'] ?? '',
          forumName: response['forumName'] ?? '',
          canPost: response['canPost'] ?? false,
          canUpload: response['canUpload'] ?? false,
          unreadStickyCount: response['unreadStickyCount'] ?? 0,
          unreadAnnounceCount: response['unreadAnnounceCount'] ?? 0,
          canSubscribe: response['canSubscribe'] ?? false,
          isSubscribed: response['isSubscribed'] ?? false,
          requirePrefix: response['requirePrefix'] ?? false,
          prefixes: (response['prefixes'] as List?)?.map((p) {
                final map = p.cast<String, dynamic>();
                // Prefix API now returns { id, title }
                final prefixId = map['id'] ?? '';
                final prefixDisplayName = map['title'] ?? '';
                xfDebug('🔍 [XENFORO_TOPIC] Prefix mapping: id=$prefixId, displayName=$prefixDisplayName, rawMap=$map');
                return FCPrefix(
                  prefixId: prefixId,
                  prefixDisplayName: prefixDisplayName,
                );
              }).toList() ??
              const [],
          topics: fcTopics,
        );
      });
    } catch (e) {
      xfDebug('❌ [XENFORO_TOPIC] getAnnTopic error: $e');
      return FCTopicDataResult(
        result: false,
        resultText: 'Error getting announcement topics: $e',
        topics: [],
        totalTopicNum: 0,
      );
    }
  }

  @override
  Future<FCLatestTopicResult> getLatestTopicAsync(int startNum, int lastNum, {String? searchId, List<String>? filters}) async {
    xfDebug('✅ [XENFORO_TOPIC] getLatestTopic called - IMPLEMENTED');
    xfDebug('   📋 Parameters: startNum=$startNum, lastNum=$lastNum, searchId=$searchId, filters=$filters');

    try {
      return await callPluginApiTyped<FCLatestTopicResult>('getLatestTopic', {
        'startNum': startNum,
        'lastNum': lastNum,
        'searchId': searchId,
        'filters': filters,
      }, (response) {
        final List<FCTopic> fcTopics = ((response['topics'] as List?) ?? []).whereType<Map>().map((t) => FCTopicMapper.fromMap(t.cast<String, dynamic>())).toList();

        return FCLatestTopicResult(
          result: response['result'] ?? false,
          resultText: response['resultText']?.toString() ?? '',
          topics: fcTopics,
          totalLatestNum: response['totalLatestNum'] ?? fcTopics.length,
        );
      });
    } catch (e) {
      xfDebug('❌ [XENFORO_TOPIC] getLatestTopic error: $e');
      return FCLatestTopicResult(
        result: false,
        resultText: 'Error getting latest topics: $e',
        topics: [],
        totalLatestNum: 0,
      );
    }
  }

  @override
  Future<FCLatestTopicResult> getNewTopicAsync(int startNum, int lastNum, {String? searchId, List<String>? filters}) {
    // TODO: implement getNewTopicAsync
    throw UnimplementedError();
  }

  @override
  Future<FCParticipatedTopicResult> getParticipatedTopicAsync(String username, int startNum, int lastNum, {String? searchId, String? userId}) async {
    xfDebug('✅ [XENFORO_TOPIC] getParticipatedTopic called - IMPLEMENTED');
    xfDebug('   📋 Parameters: username=$username, startNum=$startNum, lastNum=$lastNum, searchId=$searchId, userId=$userId');

    try {
      return await callPluginApiTyped<FCParticipatedTopicResult>('getParticipatedTopic', {
        'username': username,
        'startNum': startNum,
        'lastNum': lastNum,
        if (searchId != null) 'searchId': searchId,
        if (userId != null) 'userId': userId,
      }, (response) {
        // Map topics
        final List<FCTopic> fcTopics = ((response['topics'] as List?) ?? []).whereType<Map>().map((t) => FCTopicMapper.fromMap(t.cast<String, dynamic>())).toList();

        return FCParticipatedTopicResult(
          result: response['result'] ?? false,
          resultText: response['resultText']?.toString(),
          totalParticipatedNum: response['totalParticipatedNum'] ?? fcTopics.length,
          topics: fcTopics,
        );
      });
    } catch (e) {
      xfDebug('❌ [XENFORO_TOPIC] getParticipatedTopic error: $e');
      return FCParticipatedTopicResult(
        result: false,
        resultText: 'Error getting participated topics: $e',
        totalParticipatedNum: 0,
        topics: [],
      );
    }
  }

  @override
  Future<FCTopicDataResult> getTopTopicAsync(String forumId, int startNum, int lastNum) async {
    xfDebug('✅ [XENFORO_TOPIC] getTopTopic called - IMPLEMENTED');
    xfDebug('   📋 Parameters: forumId=$forumId, startNum=$startNum, lastNum=$lastNum');

    try {
      return await callPluginApiTyped<FCTopicDataResult>('getTopTopic', {
        'forumId': forumId,
        'startNum': startNum,
        'lastNum': lastNum,
      }, (response) {
        final List<FCTopic> fcTopics = ((response['topics'] as List?) ?? []).whereType<Map>().map((t) => FCTopicMapper.fromMap(t.cast<String, dynamic>())).toList();

        return FCTopicDataResult(
          result: response['result'] ?? false,
          resultText: response['resultText'] ?? '',
          totalTopicNum: response['totalTopicNum'] ?? fcTopics.length,
          forumId: response['forumId'] ?? '',
          forumName: response['forumName'] ?? '',
          canPost: response['canPost'] ?? false,
          canUpload: response['canUpload'] ?? false,
          unreadStickyCount: response['unreadStickyCount'] ?? 0,
          unreadAnnounceCount: response['unreadAnnounceCount'] ?? 0,
          canSubscribe: response['canSubscribe'] ?? false,
          isSubscribed: response['isSubscribed'] ?? false,
          requirePrefix: response['requirePrefix'] ?? false,
          prefixes: (response['prefixes'] as List?)?.map((p) {
                final map = p.cast<String, dynamic>();
                // Prefix API now returns { id, title }
                final prefixId = map['id'] ?? '';
                final prefixDisplayName = map['title'] ?? '';
                xfDebug('🔍 [XENFORO_TOPIC] Prefix mapping: id=$prefixId, displayName=$prefixDisplayName, rawMap=$map');
                return FCPrefix(
                  prefixId: prefixId,
                  prefixDisplayName: prefixDisplayName,
                );
              }).toList() ??
              const [],
          topics: fcTopics,
        );
      });
    } catch (e) {
      xfDebug('❌ [XENFORO_TOPIC] getTopTopic error: $e');
      return FCTopicDataResult(
        result: false,
        resultText: 'Error getting top topics: $e',
        topics: [],
        totalTopicNum: 0,
      );
    }
  }

  @override
  Future<FCTopicDataResult> getTopicAsync(String forumId, int startNum, int lastNum, {FCTopicFilters? filters}) async {
    xfDebug('✅ [XENFORO_TOPIC] getTopic called - IMPLEMENTED');
    xfDebug('   📋 Parameters: forumId=$forumId, startNum=$startNum, lastNum=$lastNum, filters=${filters?.toParams()}');

    try {
      return await callPluginApiTyped<FCTopicDataResult>('getTopic', {
        'forumId': forumId,
        'startNum': startNum,
        'lastNum': lastNum,
        // Add-on 1.11.0+
        ...?filters?.toParams(),
      }, (response) {
        final List<FCTopic> fcTopics = ((response['topics'] as List?) ?? []).whereType<Map>().map((t) => FCTopicMapper.fromMap(t.cast<String, dynamic>())).toList();

        return FCTopicDataResult(
          result: response['result'] ?? false,
          resultText: response['resultText'] ?? '',
          totalTopicNum: response['totalTopicNum'] ?? fcTopics.length,
          forumId: response['forumId'] ?? '',
          forumName: response['forumName'] ?? '',
          canPost: response['canPost'] ?? false,
          canUpload: response['canUpload'] ?? false,
          unreadStickyCount: response['unreadStickyCount'] ?? 0,
          unreadAnnounceCount: response['unreadAnnounceCount'] ?? 0,
          canSubscribe: response['canSubscribe'] ?? false,
          isSubscribed: response['isSubscribed'] ?? false,
          requirePrefix: response['requirePrefix'] ?? false,
          prefixes: (response['prefixes'] as List?)?.map((p) {
                final map = p.cast<String, dynamic>();
                // Prefix API now returns { id, title }
                final prefixId = map['id'] ?? '';
                final prefixDisplayName = map['title'] ?? '';
                xfDebug('🔍 [XENFORO_TOPIC] Prefix mapping: id=$prefixId, displayName=$prefixDisplayName, rawMap=$map');
                return FCPrefix(
                  prefixId: prefixId,
                  prefixDisplayName: prefixDisplayName,
                  group: map['group']?.toString(),
                );
              }).toList() ??
              const [],
          topics: fcTopics,
          // Add-on 1.11.0+
          sortOptions: response['sortOptions'] is List
              ? [
                  for (final o in response['sortOptions'] as List)
                    if (o is Map && o['key'] != null) FCSortOption(key: '${o['key']}', title: '${o['title'] ?? o['key']}'),
                ]
              : null,
          defaultOrder: response['defaultOrder']?.toString(),
          defaultDirection: response['defaultDirection']?.toString(),
          dateLimitOptions: response['dateLimitOptions'] is List
              ? [for (final d in response['dateLimitOptions'] as List) if (int.tryParse('$d') != null) int.parse('$d')]
              : null,
          dateLimitDays: int.tryParse('${response['dateLimitDays'] ?? ''}'),
          appliedFilters: response['appliedFilters'] is Map ? (response['appliedFilters'] as Map).cast<String, dynamic>() : null,
        );
      });
    } catch (e) {
      xfDebug('❌ [XENFORO_TOPIC] getTopic error: $e');
      return FCTopicDataResult(
        result: false,
        resultText: 'Error getting topics: $e',
        topics: [],
        totalTopicNum: 0,
      );
    }
  }

  @override
  Future<FCTopicByIdsResult> getTopicByIds(List<String> topicIds) async {
    xfDebug('✅ [XENFORO_TOPIC] getTopicByIds called - IMPLEMENTED');
    xfDebug('   📋 Parameters: topicIds=$topicIds');

    try {
      return await callPluginApiTyped<FCTopicByIdsResult>('getTopicByIds', {
        'topicIds': topicIds,
      }, (response) {
        final List<FCTopic> fcTopics = ((response['topics'] as List?) ?? []).whereType<Map>().map((t) => FCTopicMapper.fromMap(t.cast<String, dynamic>())).toList();

        return FCTopicByIdsResult(
          result: response['result'] ?? false,
          resultText: response['resultText']?.toString() ?? '',
          topics: fcTopics,
        );
      });
    } catch (e) {
      xfDebug('❌ [XENFORO_TOPIC] getTopicByIds error: $e');
      return FCTopicByIdsResult(
        result: false,
        resultText: 'Error getting topics by IDs: $e',
        topics: [],
      );
    }
  }

  @override
  Future<FCTopicStatusResult> getTopicStatusAsync(List<String> topicIds) {
    // TODO: implement getTopicStatusAsync
    throw UnimplementedError();
  }

  @override
  Future<FCUnreadTopicResult> getUnreadTopicAsync(int startNum, int lastNum, {String? searchId, List<String>? filters}) async {
    xfDebug('✅ [XENFORO_TOPIC] getUnreadTopic called - IMPLEMENTED');
    xfDebug('   📋 Parameters: startNum=$startNum, lastNum=$lastNum, searchId=$searchId, filters=$filters');

    try {
      return await callPluginApiTyped<FCUnreadTopicResult>('getUnreadTopic', {
        'startNum': startNum,
        'lastNum': lastNum,
        'searchId': searchId,
        'filters': filters,
      }, (response) {
        final List<FCTopic> fcTopics = ((response['topics'] as List?) ?? []).whereType<Map>().map((t) => FCTopicMapper.fromMap(t.cast<String, dynamic>())).toList();

        return FCUnreadTopicResult(
          result: response['result'] ?? false,
          resultText: response['resultText']?.toString() ?? '',
          topics: fcTopics,
          totalUnreadNum: response['totalUnreadNum'] ?? fcTopics.length,
        );
      });
    } catch (e) {
      xfDebug('❌ [XENFORO_TOPIC] getUnreadTopic error: $e');
      return FCUnreadTopicResult(
        result: false,
        resultText: 'Error getting unread topics: $e',
        topics: [],
        totalUnreadNum: 0,
      );
    }
  }

  @override
  Future<FCMarkTopicReadResult> markTopicReadAsync(List<String> topicIds) async {
    xfDebug('✅ [XENFORO_TOPIC] markTopicRead called - IMPLEMENTED');
    xfDebug('   📋 Parameters: topicIds=$topicIds');

    try {
      final response = await callPluginApi('markTopicRead', {
        'topicIds': topicIds,
      });

      return FCMarkTopicReadResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_TOPIC] markTopicRead error: $e');
      return FCMarkTopicReadResult(
        result: false,
        resultText: 'Error marking topics as read: $e',
      );
    }
  }

  @override
  Future<FCNewTopicResult> newTopic(String forumId, String subject, String textBody,
      {String? prefixId,
      List<String>? attachmentIds,
      String? groupId,
      List<String>? tags,
      Map<String, dynamic>? customFields,
      String? threadType,
      FCNewPoll? poll}) async {
    xfDebug('✅ [XENFORO_TOPIC] newTopic called - IMPLEMENTED');
    xfDebug('   📋 Parameters: forumId=$forumId, subject=$subject, textBody=${textBody.length} chars, prefixId=$prefixId, attachmentIds=$attachmentIds, groupId=$groupId');

    try {
      final response = await callPluginApi('newTopic', {
        'forumId': forumId,
        'subject': subject,
        'textBody': textBody,
        'prefixId': prefixId,
        'attachmentIds': attachmentIds,
        'groupId': groupId,
        // Add-on 1.11.0+ (tags were taken here before but never sent)
        if (tags != null && tags.isNotEmpty) 'tags': tags,
        if (customFields != null && customFields.isNotEmpty) 'customFields': customFields,
        if (threadType != null) 'threadType': threadType,
        ...?poll?.toParams(),
      });

      return FCNewTopicResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        topicId: response['topicId'] ?? '',
        // 1 = held for moderator approval (add-on 1.8.12 reports it).
        state: response['state'] is int ? response['state'] as int : 0,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_TOPIC] newTopic error: $e');
      return FCNewTopicResult(
        result: false,
        resultText: 'Error creating new topic: $e',
        topicId: '',
      );
    }
  }

  @override
  Future<FCMarkTopicReadResult> markPostsReadAsync({
    required String topicId,
    required List<int> postNumbers,
    int msPerPost = 2000,
  }) async =>
      // XenForo advances read state server-side when threads are fetched,
      // so explicit timing calls are a successful no-op here.
      FCMarkTopicReadResult(result: true);
}
