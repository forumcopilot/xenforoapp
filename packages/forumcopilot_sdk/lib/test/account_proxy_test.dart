import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCAccountProxy interface
/// 
/// These tests verify that all methods return result: true
/// Note: Some tests require SSO token and code to be configured in TestConfig
void runAccountProxyTests(IFCAccountProxy accountProxy, TestConfig config) {
  final helper = ProxyTestHelper(config);
  helper.setProxyName('IFCAccountProxy');

  // Tests that require SSO credentials (token and code)
  if (config.hasSsoCredentials()) {
    test('signinRegister returns result: true', () async {
      final result = await accountProxy.signinRegister(
        config.token!,
        config.code!,
        config.email,
        config.username,
        config.password,
      );
      helper.assertResultTrue(result, 'signinRegister');
    });

    test('signinLoginWithEmail returns result: true', () async {
      final result = await accountProxy.signinLoginWithEmail(
        config.token!,
        config.code!,
        config.email,
        null,
      );
      helper.assertResultTrue(result, 'signinLoginWithEmail');
    });

    test('signinLoginWithUsername returns result: true', () async {
      final result = await accountProxy.signinLoginWithUsername(
        config.token!,
        config.code!,
        config.email,
        config.username,
        null,
      );
      helper.assertResultTrue(result, 'signinLoginWithUsername');
    });

    test('signinLogin returns result: true', () async {
      final result = await accountProxy.signinLogin(config.token!, config.code!, null);
      helper.assertResultTrue(result, 'signinLogin');
    });

    test('forgetPassword returns result: true', () async {
      final result = await accountProxy.forgetPassword(config.username, config.token!, config.code!);
      helper.assertResultTrue(result, 'forgetPassword');
    });
  }

    test('updatePassword returns result: true', () async {
      if (helper.skipIfNotAuthenticated('updatePassword')) {
        return;
      }
      final result = await accountProxy.updatePassword(config.password, 'newpassword123');
      helper.assertResultTrue(result, 'updatePassword');
    });

    test('updateProfile returns result: true', () async {
      if (helper.skipIfNotAuthenticated('updateProfile')) {
        return;
      }
      final result = await accountProxy.updateProfile(config.userId, {});
      helper.assertResultTrue(result, 'updateProfile');
    });

    // Tests that require SSO credentials (token and code)
    if (config.hasSsoCredentials()) {
      test('updatePasswordSSO returns result: true', () async {
        final result = await accountProxy.updatePasswordSSO('newpassword123', config.token!, config.code!);
        helper.assertResultTrue(result, 'updatePasswordSSO');
      });

      test('register returns result: true', () async {
        final result = await accountProxy.register(
          username: config.username,
          email: config.email,
          password: config.password,
        );
        helper.assertResultTrue(result, 'register');
      });
    }

    test('updateEmail returns result: true', () async {
      if (helper.skipIfNotAuthenticated('updateEmail')) {
        return;
      }
      final result = await accountProxy.updateEmail(config.password, 'newemail@example.com');
      helper.assertResultTrue(result, 'updateEmail');
    });

    test('prefetchAccount returns result: true or null', () async {
      final result = await accountProxy.prefetchAccount();
      helper.assertResultTrueOrNull(result, 'prefetchAccount');
    });
}

