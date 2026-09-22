import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCModerationProxy interface
/// 
/// These tests verify that all methods return result: true
/// Note: These tests require moderator credentials to be configured in TestConfig
void runModerationProxyTests(IFCModerationProxy moderationProxy, IFCForumProxy forumProxy, IFCTopicProxy topicProxy, IFCPostProxy postProxy, TestConfig config) {
  // Skip all moderation tests if moderator credentials are not configured
  if (!config.hasModeratorCredentials()) {
    return;
  }

  final helper = ProxyTestHelper(config);
  helper.setProxyName('IFCModerationProxy');

  test('doLoginModAsync returns result: true', () async {
      final result = await moderationProxy.doLoginModAsync(config.moderatorUsername!, config.moderatorPassword!);
      helper.assertResultTrue(result, 'doLoginModAsync');
    });

    test('stickTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await moderationProxy.stickTopicAsync(topicId);
      helper.assertResultTrue(result, 'stickTopicAsync');
    });

    test('unstickTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await moderationProxy.unstickTopicAsync(topicId);
      helper.assertResultTrue(result, 'unstickTopicAsync');
    });

    test('closeTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await moderationProxy.closeTopicAsync(topicId);
      helper.assertResultTrue(result, 'closeTopicAsync');
    });

    test('uncloseTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await moderationProxy.uncloseTopicAsync(topicId);
      helper.assertResultTrue(result, 'uncloseTopicAsync');
    });

    test('deleteTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await moderationProxy.deleteTopicAsync(topicId, 0, 'Test reason');
      helper.assertResultTrue(result, 'deleteTopicAsync');
    });

    test('deletePostAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await moderationProxy.deletePostAsync(postId, 0, 'Test reason');
      helper.assertResultTrue(result, 'deletePostAsync');
    });

    test('undeleteTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await moderationProxy.undeleteTopicAsync(topicId, 'Test reason');
      helper.assertResultTrue(result, 'undeleteTopicAsync');
    });

    test('undeletePostAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await moderationProxy.undeletePostAsync(postId, 'Test reason');
      helper.assertResultTrue(result, 'undeletePostAsync');
    });

    test('moveTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await moderationProxy.moveTopicAsync(topicId, forumId, false);
      helper.assertResultTrue(result, 'moveTopicAsync');
    });

    test('renameTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await moderationProxy.renameTopicAsync(topicId, 'Renamed Topic');
      helper.assertResultTrue(result, 'renameTopicAsync');
    });

    test('movePostAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await moderationProxy.movePostAsync(postId, topicId, 'New Topic', forumId);
      helper.assertResultTrue(result, 'movePostAsync');
    });

    test('mergeTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId1 = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final topicId2 = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await moderationProxy.mergeTopicAsync(topicId1, topicId2, false);
      helper.assertResultTrue(result, 'mergeTopicAsync');
    });

    test('getModerateTopicAsync returns result: true', () async {
      final result = await moderationProxy.getModerateTopicAsync(0, 10);
      helper.assertResultTrue(result, 'getModerateTopicAsync');
    });

    test('getModeratePostAsync returns result: true', () async {
      final result = await moderationProxy.getModeratePostAsync(0, 10);
      helper.assertResultTrue(result, 'getModeratePostAsync');
    });

    test('getDeletedTopicAsync returns result: true', () async {
      final result = await moderationProxy.getDeletedTopicAsync(0, 10);
      helper.assertResultTrue(result, 'getDeletedTopicAsync');
    });

    test('getDeletedPostAsync returns result: true', () async {
      final result = await moderationProxy.getDeletedPostAsync(0, 10);
      helper.assertResultTrue(result, 'getDeletedPostAsync');
    });

    test('getReportedPostAsync returns result: true', () async {
      final result = await moderationProxy.getReportedPostAsync(0, 10);
      helper.assertResultTrue(result, 'getReportedPostAsync');
    });

    test('approveTopicAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final result = await moderationProxy.approveTopicAsync(topicId);
      helper.assertResultTrue(result, 'approveTopicAsync');
    });

    test('approvePostAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await moderationProxy.approvePostAsync(postId);
      helper.assertResultTrue(result, 'approvePostAsync');
    });

    test('banUserAsync returns result: true', () async {
      // Banning the test account itself is refused by every platform.
      final target = helper.recipientUsername;
      if (target == null) {
        print('⚠️  Skipping banUserAsync - secondUsername not configured (a user cannot ban themselves)');
        helper.tracker.recordSkipped('banUserAsync returns result: true', methodName: 'banUserAsync', reason: 'secondUsername not configured');
        return;
      }
      final result = await moderationProxy.banUserAsync(target, 'Test reason', 0, 0, 0);
      helper.assertResultTrue(result, 'banUserAsync');
    });

    test('unbanUserAsync returns result: true', () async {
      final target = helper.recipientUsername;
      if (target == null) {
        print('⚠️  Skipping unbanUserAsync - secondUsername not configured');
        helper.tracker.recordSkipped('unbanUserAsync returns result: true', methodName: 'unbanUserAsync', reason: 'secondUsername not configured');
        return;
      }
      // The id parameter also accepts a username, so the user banned above is
      // the one unbanned here.
      final result = await moderationProxy.unbanUserAsync(target);
      helper.assertResultTrue(result, 'unbanUserAsync');
    });

    test('markAsSpamAsync returns result: true', () async {
      final result = await moderationProxy.markAsSpamAsync(config.userId);
      helper.assertResultTrue(result, 'markAsSpamAsync');
    });
}

