import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCPostProxy interface
/// 
/// These tests verify that all methods return result: true
void runPostProxyTests(IFCPostProxy postProxy, IFCTopicProxy topicProxy, IFCForumProxy forumProxy, TestConfig config) {
  final helper = ProxyTestHelper(config);
  helper.setProxyName('IFCPostProxy');

  test('reportPostAsync returns result: true', () async {
      final testName = 'reportPostAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await postProxy.reportPostAsync(postId, 'Test reason');
      helper.assertResultTrue(result, 'reportPostAsync', testName: testName);
    });

    test('replyPostAsync returns result: true', () async {
      final testName = 'replyPostAsync returns result: true';
      if (helper.skipIfNotAuthenticated(testName)) {
        return;
      }
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await postProxy.replyPostAsync(
        forumId,
        topicId,
        'Test Reply',
        'Test reply body content',
        null,
        null,
        false,
      );
      helper.assertResultTrue(result, 'replyPostAsync', testName: testName);
    });

    test('getQuotePostAsync returns result: true', () async {
      final testName = 'getQuotePostAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await postProxy.getQuotePostAsync(postId);
      helper.assertResultTrue(result, 'getQuotePostAsync', testName: testName);
    });

    test('getRawPostAsync returns result: true', () async {
      final testName = 'getRawPostAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await postProxy.getRawPostAsync(postId);
      helper.assertResultTrue(result, 'getRawPostAsync', testName: testName);
    });

    test('saveRawPostAsync returns result: true', () async {
      final testName = 'saveRawPostAsync returns result: true';
      if (helper.skipIfNotAuthenticated(testName)) {
        return;
      }
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await postProxy.saveRawPostAsync(
        postId,
        'Updated Title',
        'Updated content',
        false,
        null,
        null,
        null,
        null, // prefix
      );
      helper.assertResultTrue(result, 'saveRawPostAsync', testName: testName);
    });

    test('getThreadAsync returns result: true', () async {
      final testName = 'getThreadAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await postProxy.getThreadAsync(topicId, 0, 10, false);
      helper.assertResultTrue(result, 'getThreadAsync', testName: testName);
    });

    test('getThreadByUnreadAsync returns result: true', () async {
      final testName = 'getThreadByUnreadAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await postProxy.getThreadByUnreadAsync(topicId, 10, false);
      helper.assertResultTrue(result, 'getThreadByUnreadAsync', testName: testName);
    });

    test('getThreadByPostAsync returns result: true', () async {
      final testName = 'getThreadByPostAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await postProxy.getThreadByPostAsync(postId, 10, false);
      helper.assertResultTrue(result, 'getThreadByPostAsync', testName: testName);
    });
}

