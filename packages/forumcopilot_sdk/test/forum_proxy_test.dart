import 'package:test/test.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCForumProxy interface
///
/// These tests verify that all methods return result: true
void runForumProxyTests(IFCForumProxy forumProxy, TestConfig config) {
  group('IFCForumProxy Tests', () {
    late ProxyTestHelper helper;

    setUp(() {
      helper = ProxyTestHelper(config);
    });

    test('getForumAsync returns result: true', () async {
      final result = await forumProxy.getForumAsync(true, '', false);
      helper.assertResultTrue(result, 'getForumAsync');
    });

    test('getForumAsync with forumId returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await forumProxy.getForumAsync(true, forumId, false);
      helper.assertResultTrue(result, 'getForumAsync with forumId');
    });

    test('getParticipatedForumAsync returns result: true', () async {
      final result = await forumProxy.getParticipatedForumAsync();
      helper.assertResultTrue(result, 'getParticipatedForumAsync');
    });

    test('markAllAsRead returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await forumProxy.markAllAsRead(forumId);
      helper.assertResultTrue(result, 'markAllAsRead');
    });

    test('loginForum returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await forumProxy.loginForum(forumId, config.forumPassword);
      helper.assertResultTrue(result, 'loginForum');
    });

    test('getIdByUrl returns result: true', () async {
      final result = await forumProxy.getIdByUrl(config.testUrl);
      helper.assertResultTrue(result, 'getIdByUrl');
    });

    test('getUrlById returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await forumProxy.getUrlById('forum', forumId);
      helper.assertResultTrue(result, 'getUrlById');
    });

    test('getBoardStatAsync returns result: true', () async {
      final result = await forumProxy.getBoardStatAsync();
      helper.assertResultTrue(result, 'getBoardStatAsync');
    });

    test('getForumStatusAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await forumProxy.getForumStatusAsync([forumId]);
      helper.assertResultTrue(result, 'getForumStatusAsync');
    });
  });
}
