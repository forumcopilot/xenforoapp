import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCSocialProxy interface
/// 
/// These tests verify that all methods return result: true
/// Note: These tests require user authentication
void runSocialProxyTests(IFCSocialProxy socialProxy, IFCPostProxy postProxy, IFCTopicProxy topicProxy, IFCForumProxy forumProxy, TestConfig config) {
  final helper = ProxyTestHelper(config);
  helper.setProxyName('IFCSocialProxy');

  if (!config.isAuthenticated) {
    print('⚠️  WARNING: Skipping all IFCSocialProxy tests - user authentication required but login failed');
    return;
  }

  test('thankPostAsync returns result: true', () async {
      final testName = 'thankPostAsync returns result: true';
      if (helper.skipIfThankPostIdNotConfigured(testName)) {
        return;
      }
      final result = await socialProxy.thankPostAsync(config.thankPostId);
      helper.assertResultTrue(result, 'thankPostAsync', testName: testName);
    });

    test('followAsync returns result: true', () async {
      final testName = 'followAsync returns result: true';
      final result = await socialProxy.followAsync(config.userId);
      helper.assertResultTrue(result, 'followAsync', testName: testName);
    });

    test('unfollowAsync returns result: true', () async {
      final testName = 'unfollowAsync returns result: true';
      final result = await socialProxy.unfollowAsync(config.userId);
      helper.assertResultTrue(result, 'unfollowAsync', testName: testName);
    });

    test('likePostAsync returns result: true', () async {
      final testName = 'likePostAsync returns result: true';
      if (helper.skipIfLikePostIdNotConfigured(testName)) {
        return;
      }
      final result = await socialProxy.likePostAsync(config.likePostId);
      helper.assertResultTrue(result, 'likePostAsync', testName: testName);
    });

    test('unlikePostAsync returns result: true', () async {
      final testName = 'unlikePostAsync returns result: true';
      if (helper.skipIfLikePostIdNotConfigured(testName)) {
        return;
      }
      final result = await socialProxy.unlikePostAsync(config.likePostId);
      helper.assertResultTrue(result, 'unlikePostAsync', testName: testName);
    });

    test('getAlertAsync returns result: true', () async {
      final testName = 'getAlertAsync returns result: true';
      final result = await socialProxy.getAlertAsync(1, 20, false);
      helper.assertResultTrue(result, 'getAlertAsync', testName: testName);
    });

    test('getActivityAsync returns result: true', () async {
      final testName = 'getActivityAsync returns result: true';
      final result = await socialProxy.getActivityAsync(1, 20);
      helper.assertResultTrue(result, 'getActivityAsync', testName: testName);
    });
}

