import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_search_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_search_result.dart';
import 'package:forumcopilot_sdk/models/entities/fc_topic.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import '../base_xenforo_proxy.dart';

/// XenForo implementation of IFCSearchProxy
/// Handles search operations for XenForo forums
class XenForoSearchProxy extends BaseXenForoProxy implements IFCSearchProxy {
  XenForoSearchProxy(SiteContext context) : super(context);

  @override
  Future<FCSearchTopicResult> searchTopicAsync(String searchString, int startNum, int lastNum, String? searchId) async {
    print('✅ [XENFORO_SEARCH] searchTopic called - IMPLEMENTED');
    print('   📋 Parameters: searchString=$searchString, startNum=$startNum, lastNum=$lastNum, searchId=$searchId');

    try {
      return await callPluginApiTyped<FCSearchTopicResult>('searchTopic', {
        'searchString': searchString,
        'startNum': startNum,
        'lastNum': lastNum,
        'searchId': searchId,
      }, (response) {
        final List<FCTopic> fcTopics = ((response['topics'] as List?) ?? []).whereType<Map>().map((t) => FCTopicMapper.fromMap(t.cast<String, dynamic>())).toList();

        return FCSearchTopicResult(
          result: response['result'] ?? false,
          resultText: response['resultText']?.toString() ?? '',
          totalTopicNum: response['totalTopicNum'] ?? fcTopics.length,
          topics: fcTopics,
        );
      });
    } catch (e) {
      print('❌ [XENFORO_SEARCH] searchTopic error: $e');
      return FCSearchTopicResult(
        result: false,
        resultText: 'Error searching topics: $e',
        totalTopicNum: 0,
        topics: [],
      );
    }
  }

  @override
  Future<FCSearchPostResult> searchPostAsync(String searchString, int startNum, int lastNum, String? searchId) async {
    print('✅ [XENFORO_SEARCH] searchPost called - IMPLEMENTED');
    print('   📋 Parameters: searchString=$searchString, startNum=$startNum, lastNum=$lastNum, searchId=$searchId');

    try {
      return await callPluginApiTyped<FCSearchPostResult>('searchPost', {
        'searchString': searchString,
        'startNum': startNum,
        'lastNum': lastNum,
        'searchId': searchId,
      }, (response) {
        // Map posts
        final List<FCPost> fcPosts = ((response['posts'] as List?) ?? []).whereType<Map>().map((p) => FCPostMapper.fromMap(p.cast<String, dynamic>())).toList();

        return FCSearchPostResult(
          result: response['result'] ?? false,
          resultText: response['resultText']?.toString() ?? '',
          totalPostNum: response['totalPostNum'] ?? fcPosts.length,
          posts: fcPosts,
        );
      });
    } catch (e) {
      print('❌ [XENFORO_SEARCH] searchPost error: $e');
      return FCSearchPostResult(
        result: false,
        resultText: 'Error searching posts: $e',
        totalPostNum: 0,
        posts: [],
      );
    }
  }

  @override
  Future<FCSearchDataResultPost> advanceSearchPostAsync(
    String keywords,
    int page,
    int perpage,
    String? searchId,
    bool titleOnly,
    String? userId,
    String? searchUser,
    String? forumId,
    String? topicId,
    List<String>? onlyIn,
    List<String>? notIn,
    bool startedBy,
  ) async {
    print('✅ [XENFORO_SEARCH] advanceSearchPostAsync called via plugin API');
    print('   📋 Parameters: keywords=$keywords, page=$page, perpage=$perpage');

    try {
      final params = <String, dynamic>{
        'keywords': keywords,
        'page': page,
        'perpage': perpage,
      };
      if (searchId != null && searchId.isNotEmpty) {
        params['searchId'] = searchId;
      }
      if (titleOnly) {
        params['titleOnly'] = true;
      }
      if (userId != null && userId.isNotEmpty) {
        params['userId'] = userId;
      }
      if (searchUser != null && searchUser.isNotEmpty) {
        params['searchUser'] = searchUser;
      }
      if (forumId != null && forumId.isNotEmpty) {
        params['forumId'] = forumId;
      }
      if (topicId != null && topicId.isNotEmpty) {
        params['topicId'] = topicId;
      }
      if (onlyIn != null && onlyIn.isNotEmpty) {
        params['onlyIn'] = onlyIn;
      }
      if (notIn != null && notIn.isNotEmpty) {
        params['notIn'] = notIn;
      }
      if (startedBy) {
        params['startedBy'] = true;
      }

      final response = await callPluginApi('advanceSearchPost', params);

      // Parse post list
      final List<FCPost> postList = [];
      if (response['posts'] != null && response['posts'] is List) {
        for (var postData in response['posts'] as List) {
          if (postData is Map<String, dynamic>) {
            postList.add(FCPostMapper.fromMap(postData));
          }
        }
      }

      return FCSearchDataResultPost(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        totalPostNum: response['totalPostNum'] ?? 0,
        searchId: response['searchId']?.toString(),
        posts: postList,
      );
    } catch (e) {
      print('❌ [XENFORO_SEARCH] advanceSearchPostAsync error: $e');
      return FCSearchDataResultPost(
        result: false,
        resultText: 'Error in advanced search: $e',
        totalPostNum: 0,
        posts: [],
      );
    }
  }

  @override
  Future<FCSearchDataResultTopic> advanceSearchTopicAsync(
    String keywords,
    int page,
    int perpage,
    String? searchId,
    bool titleOnly,
    String? userId,
    String? searchUser,
    String? forumId,
    String? topicId,
    List<String>? onlyIn,
    List<String>? notIn,
    bool startedBy,
    int? searchTime,
  ) async {
    print('✅ [XENFORO_SEARCH] advanceSearchTopicAsync called via plugin API');
    print('   📋 Parameters: keywords=$keywords, page=$page, perpage=$perpage');

    try {
      final params = <String, dynamic>{
        'keywords': keywords,
        'page': page,
        'perpage': perpage,
      };
      if (searchId != null && searchId.isNotEmpty) {
        params['searchId'] = searchId;
      }
      if (titleOnly) {
        params['titleOnly'] = true;
      }
      if (userId != null && userId.isNotEmpty) {
        params['userId'] = userId;
      }
      if (searchUser != null && searchUser.isNotEmpty) {
        params['searchUser'] = searchUser;
      }
      if (forumId != null && forumId.isNotEmpty) {
        params['forumId'] = forumId;
      }
      if (topicId != null && topicId.isNotEmpty) {
        params['topicId'] = topicId;
      }
      if (onlyIn != null && onlyIn.isNotEmpty) {
        params['onlyIn'] = onlyIn;
      }
      if (notIn != null && notIn.isNotEmpty) {
        params['notIn'] = notIn;
      }
      if (startedBy) {
        params['startedBy'] = true;
      }
      if (searchTime != null && searchTime > 0) {
        params['searchTime'] = searchTime;
      }

      final response = await callPluginApi('advanceSearchTopic', params);

      // Parse topic list
      final List<FCTopic> topicList = [];
      if (response['topics'] != null && response['topics'] is List) {
        for (var topicData in response['topics'] as List) {
          if (topicData is Map<String, dynamic>) {
            topicList.add(FCTopicMapper.fromMap(topicData));
          }
        }
      }

      return FCSearchDataResultTopic(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        totalTopicNum: response['totalTopicNum'] ?? 0,
        searchId: response['searchId']?.toString(),
        topics: topicList,
      );
    } catch (e) {
      print('❌ [XENFORO_SEARCH] advanceSearchTopicAsync error: $e');
      return FCSearchDataResultTopic(
        result: false,
        resultText: 'Error in advanced search: $e',
        totalTopicNum: 0,
        topics: [],
      );
    }
  }
}
