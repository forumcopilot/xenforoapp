import 'package:test/test.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCTopicProxy interface
/// 
/// These tests verify that all methods return result: true
void runTopicProxyTests(IFCTopicProxy topicProxy, IFCForumProxy forumProxy, TestConfig config) {
  group('IFCTopicProxy Tests', () {
    late ProxyTestHelper helper;

    setUp(() {
      helper = ProxyTestHelper(config);
    });

    test('markTopicReadAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await topicProxy.markTopicReadAsync([topicId]);
      helper.assertResultTrue(result, 'markTopicReadAsync');
    });

    test('getTopicStatusAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await topicProxy.getTopicStatusAsync([topicId]);
      helper.assertResultTrue(result, 'getTopicStatusAsync');
    });

    test('newTopic returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await topicProxy.newTopic(
        forumId,
        'Test Topic',
        'Test topic body content',
      );
      helper.assertResultTrue(result, 'newTopic');
    });

    test('getTopTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await topicProxy.getTopTopicAsync(forumId, 0, 10);
      helper.assertResultTrue(result, 'getTopTopicAsync');
    });

    test('getAnnTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await topicProxy.getAnnTopicAsync(forumId, 0, 10);
      helper.assertResultTrue(result, 'getAnnTopicAsync');
    });

    test('getTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await topicProxy.getTopicAsync(forumId, 0, 10);
      helper.assertResultTrue(result, 'getTopicAsync');
    });

    test('getUnreadTopicAsync returns result: true', () async {
      final result = await topicProxy.getUnreadTopicAsync(0, 10);
      helper.assertResultTrue(result, 'getUnreadTopicAsync');
    });

    test('getParticipatedTopicAsync returns result: true', () async {
      final result = await topicProxy.getParticipatedTopicAsync(config.username, 0, 10);
      helper.assertResultTrue(result, 'getParticipatedTopicAsync');
    });

    test('getLatestTopicAsync returns result: true', () async {
      final result = await topicProxy.getLatestTopicAsync(0, 10);
      helper.assertResultTrue(result, 'getLatestTopicAsync');
    });

    test('getNewTopicAsync returns result: true', () async {
      final result = await topicProxy.getNewTopicAsync(0, 10);
      helper.assertResultTrue(result, 'getNewTopicAsync');
    });

    test('getTopicByIds returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await topicProxy.getTopicByIds([topicId]);
      helper.assertResultTrue(result, 'getTopicByIds');
    });
  });
}

