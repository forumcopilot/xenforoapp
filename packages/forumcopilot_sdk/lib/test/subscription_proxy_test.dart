import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCSubscriptionProxy interface
/// 
/// These tests verify that all methods return result: true
/// Note: These tests require user authentication
void runSubscriptionProxyTests(IFCSubscriptionProxy subscriptionProxy, IFCForumProxy forumProxy, IFCTopicProxy topicProxy, TestConfig config) {
  final helper = ProxyTestHelper(config);
  helper.setProxyName('IFCSubscriptionProxy');

  if (!config.isAuthenticated) {
    print('⚠️  WARNING: Skipping all IFCSubscriptionProxy tests - user authentication required but login failed');
    return;
  }

  test('getSubscribedForumAsync returns result: true', () async {
      final testName = 'getSubscribedForumAsync returns result: true';
      final result = await subscriptionProxy.getSubscribedForumAsync();
      helper.assertResultTrue(result, 'getSubscribedForumAsync', testName: testName);
    });

    test('subscribeForumAsync returns result: true', () async {
      final testName = 'subscribeForumAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await subscriptionProxy.subscribeForumAsync(forumId, 0);
      helper.assertResultTrue(result, 'subscribeForumAsync', testName: testName);
    });

    test('unsubscribeForumAsync returns result: true', () async {
      final testName = 'unsubscribeForumAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await subscriptionProxy.unsubscribeForumAsync(forumId);
      helper.assertResultTrue(result, 'unsubscribeForumAsync', testName: testName);
    });

    test('getSubscribedTopicAsync returns result: true', () async {
      final testName = 'getSubscribedTopicAsync returns result: true';
      final result = await subscriptionProxy.getSubscribedTopicAsync(0, 10);
      helper.assertResultTrue(result, 'getSubscribedTopicAsync', testName: testName);
    });

    test('subscribeTopicAsync returns result: true', () async {
      final testName = 'subscribeTopicAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await subscriptionProxy.subscribeTopicAsync(topicId, 0);
      helper.assertResultTrue(result, 'subscribeTopicAsync', testName: testName);
    });

    test('unsubscribeTopicAsync returns result: true', () async {
      final testName = 'unsubscribeTopicAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await subscriptionProxy.unsubscribeTopicAsync(topicId);
      helper.assertResultTrue(result, 'unsubscribeTopicAsync', testName: testName);
    });
}

