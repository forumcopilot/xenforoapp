import 'package:test/test.dart';
import '../config/test_config.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';

/// Helper class for running ForumCopilot SDK interface tests
class ProxyTestHelper {
  final TestConfig config;

  ProxyTestHelper(this.config);

  /// Helper to fetch a valid forum ID from the forum proxy
  Future<String?> fetchValidForumId(IFCForumProxy forumProxy) async {
    try {
      final result = await forumProxy.getForumAsync(true, '', false);
      if (result.result && result.forums.isNotEmpty) {
        return result.forums.first.id;
      }
    } catch (e) {
      print('Error fetching forum ID: $e');
    }
    return config.forumId;
  }

  /// Helper to fetch a valid topic ID from the topic proxy
  Future<String?> fetchValidTopicId(IFCTopicProxy topicProxy, String forumId) async {
    try {
      final result = await topicProxy.getTopicAsync(forumId, 0, 1);
      if (result.result && result.topics.isNotEmpty) {
        return result.topics.first.id;
      }
    } catch (e) {
      print('Error fetching topic ID: $e');
    }
    return config.topicId;
  }

  /// Helper to fetch a valid post ID from the post proxy
  Future<String?> fetchValidPostId(IFCPostProxy postProxy, String topicId) async {
    try {
      final result = await postProxy.getThreadAsync(topicId, 0, 1, false);
      if (result.result && result.posts.isNotEmpty) {
        return result.posts.first.id;
      }
    } catch (e) {
      print('Error fetching post ID: $e');
    }
    return config.postId;
  }

  /// Assert that a result has result: true
  void assertResultTrue(dynamic result, String methodName) {
    expect(
      result.result,
      isTrue,
      reason: '$methodName should return result: true, but got result: ${result.result}${result.resultText != null ? ', message: ${result.resultText}' : ''}',
    );
  }

  /// Assert that a nullable result either has result: true or is null
  void assertResultTrueOrNull(dynamic result, String methodName) {
    if (result != null) {
      assertResultTrue(result, methodName);
    }
  }
}
