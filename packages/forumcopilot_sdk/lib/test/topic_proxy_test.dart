import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCTopicProxy interface
/// 
/// These tests verify that all methods return result: true
void runTopicProxyTests(IFCTopicProxy topicProxy, IFCForumProxy forumProxy, TestConfig config) {
  final helper = ProxyTestHelper(config);
  helper.setProxyName('IFCTopicProxy');

  test('markTopicReadAsync returns result: true', () async {
      final testName = 'markTopicReadAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await topicProxy.markTopicReadAsync([topicId]);
      helper.assertResultTrue(result, 'markTopicReadAsync', testName: testName, proxyName: 'IFCTopicProxy');
    });

    test('getTopicStatusAsync returns result: true', () async {
      final testName = 'getTopicStatusAsync returns result: true';
      try {
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
        final result = await topicProxy.getTopicStatusAsync([topicId]);
        helper.assertResultTrue(result, 'getTopicStatusAsync', testName: testName, proxyName: 'IFCTopicProxy');
      } on UnimplementedError {
        helper.tracker.recordNotImplemented(testName, proxyName: 'IFCTopicProxy', methodName: 'getTopicStatusAsync');
        rethrow;
      }
    });

    test('newTopic returns result: true', () async {
      final testName = 'newTopic returns result: true';
      if (helper.skipIfNotAuthenticated(testName, proxyName: 'IFCTopicProxy', methodName: 'newTopic')) {
        return;
      }
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await topicProxy.newTopic(
        forumId,
        'Test Topic',
        'Test topic body content',
      );
      helper.assertResultTrue(result, 'newTopic', testName: testName, proxyName: 'IFCTopicProxy');
    });

    test('getTopTopicAsync returns result: true', () async {
      final testName = 'getTopTopicAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await topicProxy.getTopTopicAsync(forumId, 0, 10);
      helper.assertResultTrue(result, 'getTopTopicAsync', testName: testName, proxyName: 'IFCTopicProxy');
    });

    test('getAnnTopicAsync returns result: true', () async {
      final testName = 'getAnnTopicAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await topicProxy.getAnnTopicAsync(forumId, 0, 10);
      helper.assertResultTrue(result, 'getAnnTopicAsync', testName: testName, proxyName: 'IFCTopicProxy');
    });

    test('getTopicAsync returns result: true', () async {
      final testName = 'getTopicAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await topicProxy.getTopicAsync(forumId, 0, 10);
      helper.assertResultTrue(result, 'getTopicAsync', testName: testName, proxyName: 'IFCTopicProxy');
    });

    test('getUnreadTopicAsync returns result: true', () async {
      final testName = 'getUnreadTopicAsync returns result: true';
      final result = await topicProxy.getUnreadTopicAsync(0, 10);
      helper.assertResultTrue(result, 'getUnreadTopicAsync', testName: testName, proxyName: 'IFCTopicProxy');
    });

    test('getParticipatedTopicAsync returns result: true', () async {
      final testName = 'getParticipatedTopicAsync returns result: true';
      try {
        final result = await topicProxy.getParticipatedTopicAsync(config.username, 0, 10);
        helper.assertResultTrue(result, 'getParticipatedTopicAsync', testName: testName, proxyName: 'IFCTopicProxy');
      } on UnimplementedError {
        helper.tracker.recordNotImplemented(testName, proxyName: 'IFCTopicProxy', methodName: 'getParticipatedTopicAsync');
        rethrow;
      }
    });

    test('getLatestTopicAsync returns result: true', () async {
      final testName = 'getLatestTopicAsync returns result: true';
      final result = await topicProxy.getLatestTopicAsync(0, 10);
      helper.assertResultTrue(result, 'getLatestTopicAsync', testName: testName, proxyName: 'IFCTopicProxy');
    });

    test('getNewTopicAsync returns result: true', () async {
      final testName = 'getNewTopicAsync returns result: true';
      try {
        final result = await topicProxy.getNewTopicAsync(0, 10);
        helper.assertResultTrue(result, 'getNewTopicAsync', testName: testName, proxyName: 'IFCTopicProxy');
      } on UnimplementedError {
        helper.tracker.recordNotImplemented(testName, proxyName: 'IFCTopicProxy', methodName: 'getNewTopicAsync');
        rethrow;
      }
    });

    test('getTopicByIds returns result: true', () async {
      final testName = 'getTopicByIds returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await topicProxy.getTopicByIds([topicId]);
      helper.assertResultTrue(result, 'getTopicByIds', testName: testName, proxyName: 'IFCTopicProxy');
    });
}

