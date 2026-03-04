/// Test utilities and functions for ForumCopilot SDK
///
/// This file exports all test functions and utilities that can be used
/// by connector implementations (e.g. xenforo_core) to run interface tests.

export 'config/test_config.dart';
export 'support/proxy_test_helper.dart';
export 'support/test_result_tracker.dart';
export 'config_proxy_test.dart';
export 'forum_proxy_test.dart';
export 'topic_proxy_test.dart';
export 'post_proxy_test.dart';
export 'user_proxy_test.dart';
export 'search_proxy_test.dart';
export 'subscription_proxy_test.dart';
export 'social_proxy_test.dart';
export 'account_proxy_test.dart';
export 'attachment_proxy_test.dart';
export 'moderation_proxy_test.dart';
export 'private_conversation_proxy_test.dart';
export 'private_message_proxy_test.dart';
export 'basic_proxy_test.dart';

import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import '../factory/site_proxy_factory.dart';
import 'config/test_config.dart';
import 'private_conversation_proxy_test.dart';
import 'private_message_proxy_test.dart';

/// Attempt to authenticate user before running tests
///
/// This function tries to login with the configured username and password.
/// If successful, sets config.isAuthenticated = true.
/// If failed, shows a warning and sets config.isAuthenticated = false.
///
/// Usage:
/// ```dart
/// await authenticateForTests(userProxy, testConfig);
/// ```
Future<void> authenticateForTests(IFCUserProxy userProxy, TestConfig config) async {
  try {
    final loginResult = await userProxy.loginAsync(config.username, config.password, false, null);
    if (loginResult.result) {
      config.isAuthenticated = true;
      print('✅ Authentication successful for user: ${config.username}');

      // Note: fc_is_login header in the login response will be false because it indicates
      // the authentication state DURING the call, not after. The user is logged in during
      // the login call processing, but the header reflects the state at the start/beginning
      // of the call. Only subsequent calls after login will have fc_is_login: true.
      final siteContext = SiteProxyFactory.context;
      if (siteContext != null) {
        final fcIsLogin = siteContext.lastCallFcIsLogin;
        print('ℹ️  fc_is_login header in login response: $fcIsLogin (expected: false, as login call happens before authentication is complete)');
        // Don't verify fc_is_login here - it's expected to be false in the login call itself
      }
    } else {
      // AUTHENTICATION FAILURE IS A CRITICAL ERROR - TESTS MUST FAIL
      config.isAuthenticated = false;
      final errorMsg = 'CRITICAL: Authentication failed for user: ${config.username}. Reason: ${loginResult.resultText ?? "Unknown error"}';
      print('❌ $errorMsg');

      // Verify fc_is_login header is false when authentication fails
      final siteContext = SiteProxyFactory.context;
      if (siteContext != null) {
        final fcIsLogin = siteContext.lastCallFcIsLogin;
        if (fcIsLogin) {
          throw Exception('CRITICAL: fc_is_login header should be false when authentication fails, but got: $fcIsLogin');
        }
        print('✅ fc_is_login header verified: false (as expected for failed authentication)');
      }

      throw Exception(errorMsg);
    }
  } catch (e) {
    config.isAuthenticated = false;
    final errorMsg = 'CRITICAL: Authentication error for user: ${config.username}. Error: $e';
    print('❌ $errorMsg');
    throw Exception(errorMsg);
  }
}

/// Run private messaging tests conditionally based on TestConfig
///
/// A forum cannot implement both conversations and private messages.
/// This function will only run the tests for the messaging type specified in config.
///
/// Usage:
/// ```dart
/// runPrivateMessagingTests(conversationProxy, messageProxy, testConfig);
/// ```
void runPrivateMessagingTests(
  IFCPrivateConversationProxy conversationProxy,
  IFCPrivateMessageProxy messageProxy,
  TestConfig config,
) {
  if (config.usesConversations()) {
    group('IFCPrivateConversationProxy', () {
      runPrivateConversationProxyTests(conversationProxy, config);
    });
  } else if (config.usesPrivateMessages()) {
    group('IFCPrivateMessageProxy', () {
      runPrivateMessageProxyTests(messageProxy, config);
    });
  }
  // If neither is specified or invalid value, skip both
}
