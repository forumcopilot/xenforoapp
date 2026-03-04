import 'package:test/test.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCPostProxy interface
/// 
/// These tests verify that all methods return result: true
void runPostProxyTests(IFCPostProxy postProxy, IFCTopicProxy topicProxy, IFCForumProxy forumProxy, TestConfig config) {
  group('IFCPostProxy Tests', () {
    late ProxyTestHelper helper;

    setUp(() {
      helper = ProxyTestHelper(config);
    });

    test('reportPostAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await postProxy.reportPostAsync(postId, 'Test reason');
      helper.assertResultTrue(result, 'reportPostAsync');
    });

    test('replyPostAsync returns result: true', () async {
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
      helper.assertResultTrue(result, 'replyPostAsync');
    });

    test('getQuotePostAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await postProxy.getQuotePostAsync(postId);
      helper.assertResultTrue(result, 'getQuotePostAsync');
    });

    test('getRawPostAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await postProxy.getRawPostAsync(postId);
      helper.assertResultTrue(result, 'getRawPostAsync');
    });

    test('saveRawPostAsync returns result: true', () async {
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
      helper.assertResultTrue(result, 'saveRawPostAsync');
    });

    test('getThreadAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await postProxy.getThreadAsync(topicId, 0, 10, false);
      helper.assertResultTrue(result, 'getThreadAsync');
    });

    test('getThreadByUnreadAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await postProxy.getThreadByUnreadAsync(topicId, 10, false);
      helper.assertResultTrue(result, 'getThreadByUnreadAsync');
    });

    test('getThreadByPostAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await postProxy.getThreadByPostAsync(postId, 10, false);
      helper.assertResultTrue(result, 'getThreadByPostAsync');
    });
  });
}

