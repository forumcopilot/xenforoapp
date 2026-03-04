import 'package:test/test.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCUserProxy interface
/// 
/// These tests verify that all methods return result: true
void runUserProxyTests(IFCUserProxy userProxy, TestConfig config) {
  group('IFCUserProxy Tests', () {
    late ProxyTestHelper helper;

    setUp(() {
      helper = ProxyTestHelper(config);
    });

    test('getAvatarAsync returns valid avatar URL', () async {
      final avatarUrl = await userProxy.getAvatarAsync(config.userId, config.username);
      expect(avatarUrl, isNotEmpty, reason: 'getAvatarAsync should return a valid URL');
    });

    test('loginAsync returns result: true', () async {
      final result = await userProxy.loginAsync(config.username, config.password, false, null);
      helper.assertResultTrue(result, 'loginAsync');
    });

    test('loginTwoStepAsync returns result: true', () async {
      final result = await userProxy.loginTwoStepAsync('123456', true);
      helper.assertResultTrue(result, 'loginTwoStepAsync');
    });

    test('getInboxStatAsync returns result: true', () async {
      final result = await userProxy.getInboxStatAsync(
        DateTime.now().subtract(const Duration(days: 7)),
        DateTime.now().subtract(const Duration(days: 7)),
      );
      helper.assertResultTrue(result, 'getInboxStatAsync');
    });

    test('logoutUserAsync completes without error', () async {
      await expectLater(
        userProxy.logoutUserAsync(),
        completes,
        reason: 'logoutUserAsync should complete without error',
      );
    });

    test('getOnlineUsersAsync returns result: true', () async {
      final result = await userProxy.getOnlineUsersAsync(1, 20, null, null);
      helper.assertResultTrue(result, 'getOnlineUsersAsync');
    });

    test('getUserInfoAsync returns result: true', () async {
      final result = await userProxy.getUserInfoAsync(config.username, config.userId);
      helper.assertResultTrue(result, 'getUserInfoAsync');
    });

    test('getUserTopicAsync returns result: true', () async {
      final result = await userProxy.getUserTopicAsync(config.username, config.userId);
      helper.assertResultTrue(result, 'getUserTopicAsync');
    });

    test('getUserReplyPostAsync returns result: true', () async {
      final result = await userProxy.getUserReplyPostAsync(0, 10, null, config.username, config.userId);
      helper.assertResultTrue(result, 'getUserReplyPostAsync');
    });

    test('getRecommendedUsersAsync returns result: true', () async {
      final result = await userProxy.getRecommendedUsersAsync(1, 20, 0);
      helper.assertResultTrue(result, 'getRecommendedUsersAsync');
    });

    test('searchUserAsync returns result: true', () async {
      final result = await userProxy.searchUserAsync(config.username, 1, 20);
      helper.assertResultTrue(result, 'searchUserAsync');
    });

    test('ignoreUserAsync returns result: true', () async {
      final result = await userProxy.ignoreUserAsync(config.userId, 1);
      helper.assertResultTrue(result, 'ignoreUserAsync');
    });

    test('getIgnoredUsersAsync returns result: true', () async {
      final result = await userProxy.getIgnoredUsersAsync(1, 20);
      helper.assertResultTrue(result, 'getIgnoredUsersAsync');
    });
  });
}

