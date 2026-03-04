import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:forumcopilot_sdk/test/test_exports.dart' as fc_test;
import 'package:xenforo_core/xenforo_core.dart';
import 'support/test_env.dart';
import 'support/site_context_builder.dart';

/// Basic tests for XenForo Core
/// 
/// This test suite only includes methods that are actually used in the Flutter application.
/// If all these tests pass, the core application functionality should work correctly.
/// 
/// To run only these tests:
/// ```bash
/// flutter test test/xenforo_basic_tests.dart --no-pub
/// ```
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
    secondUsername: TestEnv.secondUsername(),
    secondPassword: TestEnv.secondPassword(),
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
    likePostId: TestEnv.likePostId(),
    thankPostId: TestEnv.thankPostId(),
  );

  // Attempt authentication before running tests
  final userProxy = SiteProxyFactory.getUserProxy();
  await fc_test.authenticateForTests(userProxy, testConfig);

  group('XenForo Core Basic Tests (App-Used Methods Only)', () {
    // Print test summary at the end
    tearDownAll(() {
      fc_test.TestResultTracker().printSummary();
    });

    // Run basic tests - only methods actually used in the app
    fc_test.runBasicProxyTests(
      configProxy: SiteProxyFactory.getConfigProxy(),
      forumProxy: SiteProxyFactory.getForumProxy(),
      topicProxy: SiteProxyFactory.getTopicProxy(),
      postProxy: SiteProxyFactory.getPostProxy(),
      userProxy: SiteProxyFactory.getUserProxy(),
      searchProxy: SiteProxyFactory.getSearchProxy(),
      subscriptionProxy: SiteProxyFactory.getSubscriptionProxy(),
      socialProxy: SiteProxyFactory.getSocialProxy(),
      attachmentProxy: SiteProxyFactory.getAttachmentProxy(),
      conversationProxy: SiteProxyFactory.getPrivateConversationProxy(),
      messageProxy: SiteProxyFactory.getPrivateMessageProxy(),
      config: testConfig,
    );
  });
}


