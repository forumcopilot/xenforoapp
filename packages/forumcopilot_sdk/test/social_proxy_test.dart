import 'package:test/test.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCSocialProxy interface
/// 
/// These tests verify that all methods return result: true
void runSocialProxyTests(IFCSocialProxy socialProxy, IFCPostProxy postProxy, IFCTopicProxy topicProxy, IFCForumProxy forumProxy, TestConfig config) {
  group('IFCSocialProxy Tests', () {
    late ProxyTestHelper helper;

    setUp(() {
      helper = ProxyTestHelper(config);
    });

    test('thankPostAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await socialProxy.thankPostAsync(postId);
      helper.assertResultTrue(result, 'thankPostAsync');
    });

    test('followAsync returns result: true', () async {
      final result = await socialProxy.followAsync(config.userId);
      helper.assertResultTrue(result, 'followAsync');
    });

    test('unfollowAsync returns result: true', () async {
      final result = await socialProxy.unfollowAsync(config.userId);
      helper.assertResultTrue(result, 'unfollowAsync');
    });

    test('likePostAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await socialProxy.likePostAsync(postId);
      helper.assertResultTrue(result, 'likePostAsync');
    });

    test('unlikePostAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await socialProxy.unlikePostAsync(postId);
      helper.assertResultTrue(result, 'unlikePostAsync');
    });

    test('getAlertAsync returns result: true', () async {
      final result = await socialProxy.getAlertAsync(1, 20, false);
      helper.assertResultTrue(result, 'getAlertAsync');
    });

    test('getActivityAsync returns result: true', () async {
      final result = await socialProxy.getActivityAsync(1, 20);
      helper.assertResultTrue(result, 'getActivityAsync');
    });
  });
}

