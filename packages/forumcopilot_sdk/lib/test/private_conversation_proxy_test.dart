import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCPrivateConversationProxy interface
///
/// These tests verify that all methods return result: true.
/// Note: these tests require user authentication and a second user
/// (`secondUsername`) to address the conversation to; `thirdUsername` is
/// needed for the invitation test. The suite creates its own conversation
/// and runs the remaining calls against it, falling back to
/// `config.conversationId` / `config.messageId` when creation is not
/// possible. Leaving the conversation is the last step, so the seeded
/// conversation from the config is never destroyed.
void runPrivateConversationProxyTests(IFCPrivateConversationProxy conversationProxy, TestConfig config) {
  final helper = ProxyTestHelper(config);
  helper.setProxyName('IFCPrivateConversationProxy');

  if (!config.isAuthenticated) {
    print('⚠️  WARNING: Skipping all IFCPrivateConversationProxy tests - user authentication required but login failed');
    return;
  }

  String? createdConversationId;
  String conversationId() => createdConversationId ?? config.conversationId;

  test('newConversationAsync returns result: true', () async {
    final recipient = helper.recipientUsername;
    if (recipient == null) {
      print('⚠️  Skipping newConversationAsync - secondUsername not configured (a conversation cannot be addressed to yourself)');
      helper.tracker.recordSkipped('newConversationAsync returns result: true',
          methodName: 'newConversationAsync', reason: 'secondUsername not configured');
      return;
    }
    final result = await conversationProxy.newConversationAsync(
      [recipient],
      'Test Conversation',
      'Test conversation body',
    );
    helper.assertResultTrue(result, 'newConversationAsync');
    if (result.result && result.convId.isNotEmpty) {
      createdConversationId = result.convId;
      print('✅ Created conversation ${result.convId} with $recipient');
    }
  });

  test('replyConversationAsync returns result: true', () async {
    final result = await conversationProxy.replyConversationAsync(
      conversationId(),
      'Test reply',
      null,
      null,
    );
    helper.assertResultTrue(result, 'replyConversationAsync');
  });

  test('inviteParticipantAsync returns result: true', () async {
    final third = config.thirdUsername;
    if (third == null || third.isEmpty) {
      print('⚠️  Skipping inviteParticipantAsync - thirdUsername not configured (the second user is already in the conversation)');
      helper.tracker.recordSkipped('inviteParticipantAsync returns result: true',
          methodName: 'inviteParticipantAsync', reason: 'thirdUsername not configured');
      return;
    }
    final result = await conversationProxy.inviteParticipantAsync(
      [third],
      conversationId(),
      'Test invitation',
    );
    helper.assertResultTrue(result, 'inviteParticipantAsync');
  });

  test('getInboxStatAsync returns result: true', () async {
    await helper.runSupported('getInboxStatAsync', () => conversationProxy.getInboxStatAsync());
  });

  test('getConversationsAsync returns result: true', () async {
    final result = await conversationProxy.getConversationsAsync(0, 10);
    helper.assertResultTrue(result, 'getConversationsAsync');
  });

  test('getConversationAsync returns result: true', () async {
    final result = await conversationProxy.getConversationAsync(
      conversationId(),
      0,
      10,
      false,
    );
    helper.assertResultTrue(result, 'getConversationAsync');
  });

  test('getQuoteConversationAsync returns result: true', () async {
    // Quotes need a known message id; the seeded conversation provides one.
    final result = await conversationProxy.getQuoteConversationAsync(
      config.conversationId,
      config.messageId,
    );
    helper.assertResultTrue(result, 'getQuoteConversationAsync');
  });

  test('markConversationUnreadAsync returns result: true', () async {
    final result = await conversationProxy.markConversationUnreadAsync(conversationId());
    helper.assertResultTrue(result, 'markConversationUnreadAsync');
  });

  test('markConversationReadAsync returns result: true', () async {
    final result = await conversationProxy.markConversationReadAsync(conversationId());
    helper.assertResultTrue(result, 'markConversationReadAsync');
  });

  test('leaveConversationAsync returns result: true', () async {
    if (createdConversationId == null) {
      print('⚠️  Skipping leaveConversationAsync - no conversation was created by this run (leaving the seeded one would break later runs)');
      helper.tracker.recordSkipped('leaveConversationAsync returns result: true',
          methodName: 'leaveConversationAsync', reason: 'no conversation created by this run');
      return;
    }
    final result = await conversationProxy.leaveConversationAsync(createdConversationId!, 0);
    helper.assertResultTrue(result, 'leaveConversationAsync');
  });
}
