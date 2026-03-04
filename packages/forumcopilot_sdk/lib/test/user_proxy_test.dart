import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCUserProxy interface
/// 
/// These tests verify that all methods return result: true
void runUserProxyTests(IFCUserProxy userProxy, TestConfig config) {
  final helper = ProxyTestHelper(config);
  helper.setProxyName('IFCUserProxy');

  test('getAvatarAsync returns valid avatar URL', () async {
      final testName = 'getAvatarAsync returns valid avatar URL';
      try {
        final avatarUrl = await userProxy.getAvatarAsync(config.userId, config.username);
        expect(avatarUrl, isNotEmpty, reason: 'getAvatarAsync should return a valid URL');
        helper.tracker.recordSuccess(testName, proxyName: 'IFCUserProxy', methodName: 'getAvatarAsync');
      } on UnimplementedError {
        helper.tracker.recordNotImplemented(testName, proxyName: 'IFCUserProxy', methodName: 'getAvatarAsync');
        rethrow;
      } catch (e) {
        helper.tracker.recordFailure(testName, proxyName: 'IFCUserProxy', methodName: 'getAvatarAsync', errorMessage: e.toString());
        rethrow;
      }
    });

    test('loginAsync returns result: true', () async {
      final testName = 'loginAsync returns result: true';
      final result = await userProxy.loginAsync(config.username, config.password, false, null);
      helper.assertResultTrue(result, 'loginAsync', testName: testName, proxyName: 'IFCUserProxy');
    });

    test('loginTwoStepAsync returns result: true', () async {
      final testName = 'loginTwoStepAsync returns result: true';
      try {
        final result = await userProxy.loginTwoStepAsync('123456', true);
        helper.assertResultTrue(result, 'loginTwoStepAsync', testName: testName, proxyName: 'IFCUserProxy');
      } on UnimplementedError {
        helper.tracker.recordNotImplemented(testName, proxyName: 'IFCUserProxy', methodName: 'loginTwoStepAsync');
        rethrow;
      }
    });

    test('getInboxStatAsync returns result: true', () async {
      final testName = 'getInboxStatAsync returns result: true';
      if (helper.skipIfNotAuthenticated(testName, proxyName: 'IFCUserProxy', methodName: 'getInboxStatAsync')) {
        return;
      }
      try {
        final result = await userProxy.getInboxStatAsync(
          DateTime.now().subtract(const Duration(days: 7)),
          DateTime.now().subtract(const Duration(days: 7)),
        );
        helper.assertResultTrue(result, 'getInboxStatAsync', testName: testName, proxyName: 'IFCUserProxy');
      } on UnimplementedError {
        helper.tracker.recordNotImplemented(testName, proxyName: 'IFCUserProxy', methodName: 'getInboxStatAsync');
        rethrow;
      }
    });

    test('logoutUserAsync completes without error', () async {
      await expectLater(
        userProxy.logoutUserAsync(),
        completes,
        reason: 'logoutUserAsync should complete without error',
      );
    });

    test('getOnlineUsersAsync returns result: true', () async {
      final testName = 'getOnlineUsersAsync returns result: true';
      try {
        final result = await userProxy.getOnlineUsersAsync(1, 20, null, null);
        helper.assertResultTrue(result, 'getOnlineUsersAsync', testName: testName);
      } on UnimplementedError {
        helper.tracker.recordNotImplemented(testName, proxyName: 'IFCUserProxy', methodName: 'getOnlineUsersAsync');
        rethrow;
      }
    });

    test('getUserInfoAsync returns result: true', () async {
      final testName = 'getUserInfoAsync returns result: true';
      final result = await userProxy.getUserInfoAsync(config.username, config.userId);
      helper.assertResultTrue(result, 'getUserInfoAsync', testName: testName);
    });

    test('getUserTopicAsync returns result: true', () async {
      final testName = 'getUserTopicAsync returns result: true';
      try {
        final result = await userProxy.getUserTopicAsync(config.username, config.userId);
        helper.assertResultTrue(result, 'getUserTopicAsync', testName: testName);
      } on UnimplementedError {
        helper.tracker.recordNotImplemented(testName, proxyName: 'IFCUserProxy', methodName: 'getUserTopicAsync');
        rethrow;
      }
    });

    test('getUserReplyPostAsync returns result: true', () async {
      final testName = 'getUserReplyPostAsync returns result: true';
      try {
        final result = await userProxy.getUserReplyPostAsync(0, 10, null, config.username, config.userId);
        helper.assertResultTrue(result, 'getUserReplyPostAsync', testName: testName);
      } on UnimplementedError {
        helper.tracker.recordNotImplemented(testName, proxyName: 'IFCUserProxy', methodName: 'getUserReplyPostAsync');
        rethrow;
      }
    });

    test('getRecommendedUsersAsync returns result: true', () async {
      final testName = 'getRecommendedUsersAsync returns result: true';
      try {
        final result = await userProxy.getRecommendedUsersAsync(1, 20, 0);
        helper.assertResultTrue(result, 'getRecommendedUsersAsync', testName: testName);
      } on UnimplementedError {
        helper.tracker.recordNotImplemented(testName, proxyName: 'IFCUserProxy', methodName: 'getRecommendedUsersAsync');
        rethrow;
      }
    });

    test('searchUserAsync returns result: true', () async {
      final testName = 'searchUserAsync returns result: true';
      final result = await userProxy.searchUserAsync(config.username, 1, 20);
      helper.assertResultTrue(result, 'searchUserAsync', testName: testName);
    });

    test('ignoreUserAsync returns result: true', () async {
      if (helper.skipIfNotAuthenticated('ignoreUserAsync')) {
        return;
      }
      final result = await userProxy.ignoreUserAsync(config.userId, 1);
      helper.assertResultTrue(result, 'ignoreUserAsync');
    });

    test('getIgnoredUsersAsync returns result: true', () async {
      if (helper.skipIfNotAuthenticated('getIgnoredUsersAsync')) {
        return;
      }
      final result = await userProxy.getIgnoredUsersAsync(1, 20);
      helper.assertResultTrue(result, 'getIgnoredUsersAsync');
    });
}

