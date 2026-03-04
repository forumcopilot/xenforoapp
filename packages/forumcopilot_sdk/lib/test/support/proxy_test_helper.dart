import 'package:flutter_test/flutter_test.dart';
import '../config/test_config.dart';
import '../../interfaces/interfaces.dart';
import '../../factory/site_proxy_factory.dart';
import 'test_result_tracker.dart';

/// Helper class for running ForumCopilot SDK interface tests
class ProxyTestHelper {
  final TestConfig config;
  final TestResultTracker tracker = TestResultTracker();
  String? _currentProxyName;

  ProxyTestHelper(this.config);

  /// Set the current proxy name for all subsequent test calls
  void setProxyName(String proxyName) {
    _currentProxyName = proxyName;
  }

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
  void assertResultTrue(dynamic result, String methodName, {String? testName, String? proxyName, bool checkFcIsLogin = false}) {
    final currentTest = testName ?? methodName;
    final errorMessage = result.result == false ? '${result.resultText ?? 'Unknown error'}' : null;
    final isAuthError = errorMessage != null && 
        (errorMessage.toLowerCase().contains('authentication') || 
         errorMessage.toLowerCase().contains('log in') ||
         errorMessage.toLowerCase().contains('login'));

    try {
      expect(
        result.result,
        isTrue,
        reason: '$methodName should return result: true, but got result: ${result.result}${result.resultText != null ? ', message: ${result.resultText}' : ''}',
      );
      
      // Verify fc_is_login header if requested (for authenticated requests)
      if (checkFcIsLogin) {
        final siteContext = SiteProxyFactory.context;
        if (siteContext != null) {
          // Check fc_is_login from the last call response
          final fcIsLogin = siteContext.lastCallFcIsLogin;
          expect(
            fcIsLogin,
            isTrue,
            reason: '$methodName should have fc_is_login: true in response headers, but got: $fcIsLogin',
          );
        }
      }
      
      tracker.recordSuccess(currentTest, proxyName: proxyName, methodName: methodName);
    } catch (e) {
      // CRITICAL: If authentication error, verify fc_is_login is false
      if (isAuthError) {
        final siteContext = SiteProxyFactory.context;
        if (siteContext != null) {
          final fcIsLogin = siteContext.lastCallFcIsLogin;
          if (fcIsLogin) {
            fail('CRITICAL: $methodName returned authentication error but fc_is_login header is true (should be false). This indicates a serious authentication state mismatch.');
          }
        }
      }
      
      // Check if it's an UnimplementedError
      if (e is UnimplementedError || e.toString().contains('UnimplementedError')) {
        tracker.recordNotImplemented(currentTest, proxyName: proxyName, methodName: methodName);
      } else {
        tracker.recordFailure(currentTest, proxyName: proxyName, methodName: methodName, errorMessage: errorMessage ?? e.toString());
      }
      rethrow;
    }
  }

  String _getCurrentTestName() {
    // Try to get current test name from test framework
    // This is a fallback - actual test name should be passed
    return 'Unknown Test';
  }

  /// Assert that a nullable result either has result: true or is null
  void assertResultTrueOrNull(dynamic result, String methodName, {String? testName, String? proxyName}) {
    final effectiveProxyName = proxyName ?? _currentProxyName;
    if (result != null) {
      assertResultTrue(result, methodName, testName: testName, proxyName: effectiveProxyName);
    } else {
      final currentTest = testName ?? _getCurrentTestName();
      tracker.recordSuccess(currentTest, proxyName: effectiveProxyName, methodName: methodName);
    }
  }

  /// Skip test with warning if authentication is required but not available
  /// Returns true if test should be skipped, false if it should proceed
  bool skipIfNotAuthenticated(String testName, {String? proxyName, String? methodName}) {
    final effectiveProxyName = proxyName ?? _currentProxyName;
    if (!config.isAuthenticated) {
      print('⚠️  WARNING: Skipping $testName test - user authentication required but login failed');
      tracker.recordSkipped(testName, proxyName: effectiveProxyName, methodName: methodName, reason: 'Authentication required but login failed');
      return true;
    }
    return false;
  }

  /// Fail test if authentication is required but not available
  /// This is a CRITICAL error - tests must fail, not skip
  void failIfNotAuthenticated(String testName, {String? proxyName, String? methodName}) {
    final effectiveProxyName = proxyName ?? _currentProxyName;
    if (!config.isAuthenticated) {
      final errorMsg = 'CRITICAL: $testName test FAILED - user authentication required but login failed. This is a critical error and the test must fail.';
      print('❌ $errorMsg');
      tracker.recordFailure(testName, proxyName: effectiveProxyName, methodName: methodName, errorMessage: 'Authentication required but login failed');
      fail(errorMsg);
    }
  }

  /// Skip test if password-protected forum ID is not configured
  /// Returns true if test should be skipped, false if it should proceed
  bool skipIfPasswordProtectedForumNotConfigured(String testName, {String? proxyName, String? methodName}) {
    final effectiveProxyName = proxyName ?? _currentProxyName;
    if (config.passwordProtectedForumId.isEmpty) {
      print('⚠️  WARNING: Skipping $testName test - password-protected forum ID not configured (feature not supported)');
      tracker.recordSkipped(testName, proxyName: effectiveProxyName, methodName: methodName, reason: 'Password-protected forum ID not configured');
      return true;
    }
    return false;
  }

  /// Skip test if likePostId is not configured
  /// Returns true if test should be skipped, false if it should proceed
  bool skipIfLikePostIdNotConfigured(String testName, {String? proxyName, String? methodName}) {
    final effectiveProxyName = proxyName ?? _currentProxyName;
    if (config.likePostId.isEmpty) {
      print('⚠️  WARNING: Skipping $testName test - likePostId not configured (feature not supported)');
      tracker.recordSkipped(testName, proxyName: effectiveProxyName, methodName: methodName, reason: 'Like post ID not configured');
      return true;
    }
    return false;
  }

  /// Skip test if thankPostId is not configured
  /// Returns true if test should be skipped, false if it should proceed
  bool skipIfThankPostIdNotConfigured(String testName, {String? proxyName, String? methodName}) {
    final effectiveProxyName = proxyName ?? _currentProxyName;
    if (config.thankPostId.isEmpty) {
      print('⚠️  WARNING: Skipping $testName test - thankPostId not configured (feature not supported)');
      tracker.recordSkipped(testName, proxyName: effectiveProxyName, methodName: methodName, reason: 'Thank post ID not configured');
      return true;
    }
    return false;
  }

  /// Record a not implemented test
  void recordNotImplemented(String testName, {String? proxyName, String? methodName}) {
    final effectiveProxyName = proxyName ?? _currentProxyName;
    tracker.recordNotImplemented(testName, proxyName: effectiveProxyName, methodName: methodName);
  }
}
