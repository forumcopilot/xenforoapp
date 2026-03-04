import 'package:test/test.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCSubscriptionProxy interface
/// 
/// These tests verify that all methods return result: true
void runSubscriptionProxyTests(IFCSubscriptionProxy subscriptionProxy, IFCForumProxy forumProxy, IFCTopicProxy topicProxy, TestConfig config) {
  group('IFCSubscriptionProxy Tests', () {
    late ProxyTestHelper helper;

    setUp(() {
      helper = ProxyTestHelper(config);
    });

    test('getSubscribedForumAsync returns result: true', () async {
      final result = await subscriptionProxy.getSubscribedForumAsync();
      helper.assertResultTrue(result, 'getSubscribedForumAsync');
    });

    test('subscribeForumAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await subscriptionProxy.subscribeForumAsync(forumId, 0);
      helper.assertResultTrue(result, 'subscribeForumAsync');
    });

    test('unsubscribeForumAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await subscriptionProxy.unsubscribeForumAsync(forumId);
      helper.assertResultTrue(result, 'unsubscribeForumAsync');
    });

    test('getSubscribedTopicAsync returns result: true', () async {
      final result = await subscriptionProxy.getSubscribedTopicAsync(0, 10);
      helper.assertResultTrue(result, 'getSubscribedTopicAsync');
    });

    test('subscribeTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await subscriptionProxy.subscribeTopicAsync(topicId, 0);
      helper.assertResultTrue(result, 'subscribeTopicAsync');
    });

    test('unsubscribeTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await subscriptionProxy.unsubscribeTopicAsync(topicId);
      helper.assertResultTrue(result, 'unsubscribeTopicAsync');
    });
  });
}

