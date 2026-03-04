import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCForumProxy interface
///
/// These tests verify that all methods return result: true
void runForumProxyTests(IFCForumProxy forumProxy, TestConfig config) {
  final helper = ProxyTestHelper(config);
  helper.setProxyName('IFCForumProxy');

  test('getForumAsync returns result: true', () async {
      final testName = 'getForumAsync returns result: true';
      final result = await forumProxy.getForumAsync(true, '', false);
      helper.assertResultTrue(result, 'getForumAsync', testName: testName, proxyName: 'IFCForumProxy');
    });

    test('getForumAsync with forumId returns result: true', () async {
      final testName = 'getForumAsync with forumId returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await forumProxy.getForumAsync(true, forumId, false);
      helper.assertResultTrue(result, 'getForumAsync with forumId', testName: testName, proxyName: 'IFCForumProxy');
    });

    test('getParticipatedForumAsync returns result: true', () async {
      final testName = 'getParticipatedForumAsync returns result: true';
      if (helper.skipIfNotAuthenticated(testName, proxyName: 'IFCForumProxy', methodName: 'getParticipatedForumAsync')) {
        return;
      }
      final result = await forumProxy.getParticipatedForumAsync();
      helper.assertResultTrue(result, 'getParticipatedForumAsync', testName: testName, proxyName: 'IFCForumProxy');
    });

    test('markAllAsRead returns result: true', () async {
      final testName = 'markAllAsRead returns result: true';
      if (helper.skipIfNotAuthenticated(testName, proxyName: 'IFCForumProxy', methodName: 'markAllAsRead')) {
        return;
      }
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await forumProxy.markAllAsRead(forumId);
      helper.assertResultTrue(result, 'markAllAsRead', testName: testName, proxyName: 'IFCForumProxy');
    });

    test('loginForum returns result: true', () async {
      final testName = 'loginForum returns result: true';
      if (helper.skipIfPasswordProtectedForumNotConfigured(testName, proxyName: 'IFCForumProxy', methodName: 'loginForum')) {
        return;
      }
      final forumId = config.passwordProtectedForumId;
      final result = await forumProxy.loginForum(forumId, config.forumPassword);
      helper.assertResultTrue(result, 'loginForum', testName: testName, proxyName: 'IFCForumProxy');
    });

    test('getIdByUrl returns result: true', () async {
      final testName = 'getIdByUrl returns result: true';
      final result = await forumProxy.getIdByUrl(config.testUrl);
      helper.assertResultTrue(result, 'getIdByUrl', testName: testName, proxyName: 'IFCForumProxy');
    });

    test('getUrlById returns result: true', () async {
      final testName = 'getUrlById returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await forumProxy.getUrlById('forum', forumId);
      helper.assertResultTrue(result, 'getUrlById', testName: testName, proxyName: 'IFCForumProxy');
    });

    test('getBoardStatAsync returns result: true', () async {
      final testName = 'getBoardStatAsync returns result: true';
      final result = await forumProxy.getBoardStatAsync();
      helper.assertResultTrue(result, 'getBoardStatAsync', testName: testName, proxyName: 'IFCForumProxy');
    });

    test('getForumStatusAsync returns result: true', () async {
      final testName = 'getForumStatusAsync returns result: true';
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final result = await forumProxy.getForumStatusAsync([forumId]);
      helper.assertResultTrue(result, 'getForumStatusAsync', testName: testName, proxyName: 'IFCForumProxy');
    });
}

