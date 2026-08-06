import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:forumcopilot_sdk/test/test_exports.dart' as fc_test;
import 'package:xenforo_core/xenforo_core.dart';
import 'support/test_env.dart';
import 'support/site_context_builder.dart';

void main() async {
  // Initialize before declaring groups
  final siteContext = buildXenForoSiteContext();
  SiteProxyFactory.initialize(siteContext);
  SiteProxyFactory.register('xenforo', XenForoProxyFactory());

  final testConfig = fc_test.TestConfig(
    forumId: TestEnv.forumId(),
    passwordProtectedForumId: TestEnv.passwordProtectedForumId(),
    topicId: TestEnv.topicId(),
    postId: TestEnv.postId(),
    userId: TestEnv.userId(),
    username: TestEnv.username(),
    password: TestEnv.password(),
    moderatorUsername: TestEnv.moderatorUsername(),
    moderatorPassword: TestEnv.moderatorPassword(),
    conversationId: TestEnv.conversationId(),
    messageId: TestEnv.messageId(),
    attachmentId: TestEnv.attachmentId(),
    groupId: TestEnv.groupId(),
    testUrl: TestEnv.testUrl(),
    forumPassword: TestEnv.forumPassword(),
    email: TestEnv.email(),
    token: TestEnv.token(),
    code: TestEnv.code(),
    privateMessagingType: TestEnv.privateMessagingType(),
  );

  // Attempt authentication before running tests
  final userProxy = SiteProxyFactory.getUserProxy();
  await fc_test.authenticateForTests(userProxy, testConfig);

  group('XenForo Core Interface Tests', () {
    // Print test summary at the end
    tearDownAll(() {
      fc_test.TestResultTracker().printSummary();
    });

    group('IFCConfigProxy', () {
      final configProxy = SiteProxyFactory.getConfigProxy();
      fc_test.runConfigProxyTests(configProxy, testConfig);
    });

    group('IFCForumProxy', () {
      final forumProxy = SiteProxyFactory.getForumProxy();
      fc_test.runForumProxyTests(forumProxy, testConfig);
    });

    group('IFCTopicProxy', () {
      final topicProxy = SiteProxyFactory.getTopicProxy();
      final forumProxy = SiteProxyFactory.getForumProxy();
      fc_test.runTopicProxyTests(topicProxy, forumProxy, testConfig);
    });

    group('IFCPostProxy', () {
      final postProxy = SiteProxyFactory.getPostProxy();
      final topicProxy = SiteProxyFactory.getTopicProxy();
      final forumProxy = SiteProxyFactory.getForumProxy();
      fc_test.runPostProxyTests(postProxy, topicProxy, forumProxy, testConfig);
    });

    group('IFCUserProxy', () {
      final userProxy = SiteProxyFactory.getUserProxy();
      fc_test.runUserProxyTests(userProxy, testConfig);
    });

    group('IFCSearchProxy', () {
      final searchProxy = SiteProxyFactory.getSearchProxy();
      final forumProxy = SiteProxyFactory.getForumProxy();
      fc_test.runSearchProxyTests(searchProxy, forumProxy, testConfig);
    });

    group('IFCSubscriptionProxy', () {
      final subscriptionProxy = SiteProxyFactory.getSubscriptionProxy();
      final forumProxy = SiteProxyFactory.getForumProxy();
      final topicProxy = SiteProxyFactory.getTopicProxy();
      fc_test.runSubscriptionProxyTests(subscriptionProxy, forumProxy, topicProxy, testConfig);
    });

    group('IFCSocialProxy', () {
      final socialProxy = SiteProxyFactory.getSocialProxy();
      final postProxy = SiteProxyFactory.getPostProxy();
      final topicProxy = SiteProxyFactory.getTopicProxy();
      final forumProxy = SiteProxyFactory.getForumProxy();
      fc_test.runSocialProxyTests(socialProxy, postProxy, topicProxy, forumProxy, testConfig);
    });

    group('IFCAccountProxy', () {
      final accountProxy = SiteProxyFactory.getAccountProxy();
      fc_test.runAccountProxyTests(accountProxy, testConfig);
    });

    group('IFCAttachmentProxy', () {
      final attachmentProxy = SiteProxyFactory.getAttachmentProxy();
      final postProxy = SiteProxyFactory.getPostProxy();
      final topicProxy = SiteProxyFactory.getTopicProxy();
      final forumProxy = SiteProxyFactory.getForumProxy();
      fc_test.runAttachmentProxyTests(attachmentProxy, postProxy, topicProxy, forumProxy, testConfig);
    });

    group('IFCModerationProxy', () {
      final moderationProxy = SiteProxyFactory.getModerationProxy();
      final forumProxy = SiteProxyFactory.getForumProxy();
      final topicProxy = SiteProxyFactory.getTopicProxy();
      final postProxy = SiteProxyFactory.getPostProxy();
      fc_test.runModerationProxyTests(moderationProxy, forumProxy, topicProxy, postProxy, testConfig);
    });

    // Run private messaging tests conditionally based on config
    // A forum cannot implement both conversations and private messages
    final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
    final messageProxy = SiteProxyFactory.getPrivateMessageProxy();
    fc_test.runPrivateMessagingTests(conversationProxy, messageProxy, testConfig);
  });
}
