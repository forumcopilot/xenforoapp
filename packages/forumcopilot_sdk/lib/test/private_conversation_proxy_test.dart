import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCPrivateConversationProxy interface
/// 
/// These tests verify that all methods return result: true
/// Note: These tests require user authentication
void runPrivateConversationProxyTests(IFCPrivateConversationProxy conversationProxy, TestConfig config) {
  final helper = ProxyTestHelper(config);
  helper.setProxyName('IFCPrivateConversationProxy');

  if (!config.isAuthenticated) {
    print('⚠️  WARNING: Skipping all IFCPrivateConversationProxy tests - user authentication required but login failed');
    return;
  }

  test('newConversationAsync returns result: true', () async {
      final result = await conversationProxy.newConversationAsync(
        [config.username],
        'Test Conversation',
        'Test conversation body',
      );
      helper.assertResultTrue(result, 'newConversationAsync');
    });

    test('replyConversationAsync returns result: true', () async {
      final result = await conversationProxy.replyConversationAsync(
        config.conversationId,
        'Test reply',
        null,
        null,
      );
      helper.assertResultTrue(result, 'replyConversationAsync');
    });

    test('inviteParticipantAsync returns result: true', () async {
      final result = await conversationProxy.inviteParticipantAsync(
        [config.username],
        config.conversationId,
        'Test invitation',
      );
      helper.assertResultTrue(result, 'inviteParticipantAsync');
    });

    test('getInboxStatAsync returns result: true', () async {
      final result = await conversationProxy.getInboxStatAsync();
      helper.assertResultTrue(result, 'getInboxStatAsync');
    });

    test('getConversationsAsync returns result: true', () async {
      final result = await conversationProxy.getConversationsAsync(0, 10);
      helper.assertResultTrue(result, 'getConversationsAsync');
    });

    test('getConversationAsync returns result: true', () async {
      final result = await conversationProxy.getConversationAsync(
        config.conversationId,
        0,
        10,
        false,
      );
      helper.assertResultTrue(result, 'getConversationAsync');
    });

    test('getQuoteConversationAsync returns result: true', () async {
      final result = await conversationProxy.getQuoteConversationAsync(
        config.conversationId,
        config.messageId,
      );
      helper.assertResultTrue(result, 'getQuoteConversationAsync');
    });

    test('leaveConversationAsync returns result: true', () async {
      final result = await conversationProxy.leaveConversationAsync(config.conversationId, 0);
      helper.assertResultTrue(result, 'leaveConversationAsync');
    });

    test('markConversationUnreadAsync returns result: true', () async {
      final result = await conversationProxy.markConversationUnreadAsync(config.conversationId);
      helper.assertResultTrue(result, 'markConversationUnreadAsync');
    });

    test('markConversationReadAsync returns result: true', () async {
      final result = await conversationProxy.markConversationReadAsync(config.conversationId);
      helper.assertResultTrue(result, 'markConversationReadAsync');
    });
}

