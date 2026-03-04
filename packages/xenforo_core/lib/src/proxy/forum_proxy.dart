import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_forum_proxy.dart';
import 'package:forumcopilot_sdk/models/results/fc_forum_result.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';
import '../base_xenforo_proxy.dart';

/// XenForo implementation of IFCForumProxy
/// Handles forum structure and navigation for XenForo forums
class XenForoForumProxy extends BaseXenForoProxy implements IFCForumProxy {
  XenForoForumProxy(SiteContext context) : super(context);

  @override
  Future<FCForumDataResult> getForumAsync(bool returnDescription, String forumId, bool forceRefresh) async {
    print('✅ [XENFORO_FORUM] getForum called via plugin API');
    print('   📋 Parameters: returnDescription=$returnDescription, forumId=$forumId, forceRefresh=$forceRefresh');

    try {
      // Call plugin API with getForum method
      final response = await callPluginApi('getForum', {
        'returnDescription': returnDescription,
        'forumId': forumId,
        'forceRefresh': forceRefresh,
      });

      print('✅ [XENFORO_FORUM] getForum response received');
      print('   📋 Response keys: ${response.keys.toList()}');
      print('   📋 result: ${response['result']}');
      print('   📋 resultText: ${response['resultText']}');
      print('   📋 forums type: ${response['forums'].runtimeType}');

      // Convert dynamic list to FCForum objects recursively
      final forumsList = response['forums'] as List<dynamic>? ?? [];
      print('   📋 forumsList length: ${forumsList.length}');

      final forums = forumsList.map((forumData) {
        return _convertForumData(forumData);
      }).toList();

      print('✅ [XENFORO_FORUM] getForum completed: ${forums.length} forums converted');
      if (forums.isEmpty && (response['result'] == true)) {
        print('⚠️ [XENFORO_FORUM] Warning: result is true but forums list is empty');
      }

      return FCForumDataResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        forums: forums,
      );
    } catch (e, stackTrace) {
      print('❌ [XENFORO_FORUM] getForum error: $e');
      print('❌ [XENFORO_FORUM] Stack trace: $stackTrace');
      return FCForumDataResult(
        result: false,
        resultText: 'Error getting forum: $e',
        forums: [],
      );
    }
  }

  @override
  Future<FCParticipatedForumResult> getParticipatedForumAsync() async {
    // TODO: Implement participated forums
    return FCParticipatedForumResult(
      result: false,
      resultText: 'Participated forums not implemented',
    );
  }

  @override
  Future<FCMarkAllAsReadResult> markAllAsRead(String forumId) async {
    print('✅ [XENFORO_FORUM] markAllAsRead called via plugin API');
    print('   📋 Parameters: forumId=$forumId');

    try {
      // Call plugin API with markAllAsRead method
      final response = await callPluginApi('markAllAsRead', {
        'forumId': forumId,
      });

      return FCMarkAllAsReadResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
      );
    } catch (e) {
      print('❌ [XENFORO_FORUM] markAllAsRead error: $e');
      return FCMarkAllAsReadResult(
        result: false,
        resultText: 'Error marking forum as read: $e',
      );
    }
  }

  @override
  Future<FCLoginForumResult> loginForum(String forumId, String password) async {
    print('✅ [XENFORO_FORUM] loginForum called via plugin API');
    print('   📋 Parameters: forumId=$forumId');

    try {
      final response = await callPluginApi('loginForum', {
        'forumId': forumId,
        'password': password,
      });

      return FCLoginForumResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        cookies: null, // Cookies handled by session
      );
    } catch (e) {
      print('❌ [XENFORO_FORUM] loginForum error: $e');
      return FCLoginForumResult(
        result: false,
        resultText: 'Error logging into forum: $e',
      );
    }
  }

  @override
  Future<FCIdByUrlResult> getIdByUrl(String url) async {
    // TODO: Implement ID by URL
    return FCIdByUrlResult(
      result: false,
      resultText: 'ID by URL not implemented',
      forumId: '',
      postId: '',
      topicId: '',
    );
  }

  @override
  Future<FCUrlByIdResult> getUrlById(String mode, String id) async {
    // TODO: Implement URL by ID
    return FCUrlByIdResult(
      result: false,
      resultText: 'URL by ID not implemented',
      url: '',
    );
  }

  @override
  Future<FCBoardStatResult> getBoardStatAsync() async {
    print('✅ [XENFORO_FORUM] getBoardStatAsync called via plugin API');

    try {
      final response = await callPluginApi('getBoardStat', {});

      return FCBoardStatResult(
        result: response['result'] ?? false,
        resultText: response['resultText']?.toString() ?? '',
        totalThreads: response['totalThreads'] ?? 0,
        totalPosts: response['totalPosts'] ?? 0,
        totalMembers: response['totalMembers'] ?? 0,
        activeMembers: response['activeMembers'] ?? 0,
        totalOnline: response['totalOnline'] ?? 0,
        guestOnline: response['guestOnline'] ?? 0,
      );
    } catch (e) {
      print('❌ [XENFORO_FORUM] getBoardStatAsync error: $e');
      return FCBoardStatResult(
        result: false,
        resultText: 'Error getting board stats: $e',
      );
    }
  }

  @override
  Future<FCForumStatusResult> getForumStatusAsync(List<String> forumIds) async {
    // TODO: Implement forum status
    return FCForumStatusResult(
      result: false,
      resultText: 'Forum status not implemented',
    );
  }

  /// Recursively convert forum data to FCForum objects
  FCForum _convertForumData(Map<String, dynamic> forumData) {
    // Convert subForums to childForums recursively
    final subForums = forumData['subForums'] as List<dynamic>? ?? [];
    final childForums = subForums.map((childData) => _convertForumData(childData as Map<String, dynamic>)).toList();

    // Determine if this is a sub-forum container
    // A category or forum with children but no threads/posts is a container
    final threadCount = forumData['threadCount'] as int? ?? 0;
    final isSubForumContainer = childForums.isNotEmpty && threadCount == 0;

    return FCForum(
      id: forumData['id']?.toString() ?? '',
      name: forumData['name']?.toString() ?? '',
      description: forumData['description']?.toString(),
      parentId: forumData['parentId']?.toString(),
      hasNewPosts: forumData['isRead'] == false,
      isProtected: false, // Not provided in API response
      isSubscribed: false, // Not provided in API response
      canSubscribe: true, // Not provided in API response
      canPost: forumData['canPost'] == true,
      canViewContent: forumData['canViewContent'] != false, // Defaults to true if not provided
      externalUrl: forumData['url']?.toString(),
      isLinkForum: forumData['isLinkForum'] == true,
      isSubForumContainer: isSubForumContainer,
      childForums: childForums,
    );
  }
}
