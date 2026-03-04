import 'package:test/test.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCPrivateMessageProxy interface
/// 
/// These tests verify that all methods return result: true
void runPrivateMessageProxyTests(IFCPrivateMessageProxy messageProxy, TestConfig config) {
  group('IFCPrivateMessageProxy Tests', () {
    late ProxyTestHelper helper;

    setUp(() {
      helper = ProxyTestHelper(config);
    });

    test('reportPmAsync returns result: true', () async {
      final result = await messageProxy.reportPmAsync(config.messageId, 'Test reason');
      helper.assertResultTrue(result, 'reportPmAsync');
    });

    test('createMessageAsync returns result: true', () async {
      final result = await messageProxy.createMessageAsync(
        [config.username],
        'Test Message',
        'Test message body',
        null,
        null,
        null,
        null,
      );
      helper.assertResultTrue(result, 'createMessageAsync');
    });

    test('getBoxInfoAsync returns result: true', () async {
      final result = await messageProxy.getBoxInfoAsync();
      helper.assertResultTrue(result, 'getBoxInfoAsync');
    });

    test('getBoxAsync returns result: true', () async {
      final result = await messageProxy.getBoxAsync('inbox', 0, 10);
      helper.assertResultTrue(result, 'getBoxAsync');
    });

    test('getMessageAsync returns result: true', () async {
      final result = await messageProxy.getMessageAsync(config.messageId, 'inbox', false);
      helper.assertResultTrue(result, 'getMessageAsync');
    });

    test('getQuotePmAsync returns result: true', () async {
      final result = await messageProxy.getQuotePmAsync(config.messageId);
      helper.assertResultTrue(result, 'getQuotePmAsync');
    });

    test('deleteMessageAsync returns result: true', () async {
      final result = await messageProxy.deleteMessageAsync(config.messageId, 'inbox');
      helper.assertResultTrue(result, 'deleteMessageAsync');
    });

    test('markPmUnreadAsync returns result: true', () async {
      final result = await messageProxy.markPmUnreadAsync(config.messageId);
      helper.assertResultTrue(result, 'markPmUnreadAsync');
    });

    test('markPmReadAsync returns result: true', () async {
      final result = await messageProxy.markPmReadAsync([config.messageId]);
      helper.assertResultTrue(result, 'markPmReadAsync');
    });
  });
}

