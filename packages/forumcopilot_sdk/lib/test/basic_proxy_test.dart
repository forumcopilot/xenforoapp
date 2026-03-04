import 'dart:typed_data';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import '../context/site_context.dart';
import '../factory/site_proxy_factory.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Basic tests for ForumCopilot SDK
/// 
/// This test suite only includes methods that are actually used in the Flutter application.
/// If all these tests pass, the core application functionality should work correctly.
/// 
/// This is a minimal test suite focused on essential functionality.
void runBasicProxyTests({
  required IFCConfigProxy configProxy,
  required IFCForumProxy forumProxy,
  required IFCTopicProxy topicProxy,
  required IFCPostProxy postProxy,
  required IFCUserProxy userProxy,
  required IFCSearchProxy searchProxy,
  required IFCSubscriptionProxy subscriptionProxy,
  required IFCSocialProxy socialProxy,
  required IFCAttachmentProxy attachmentProxy,
  IFCPrivateConversationProxy? conversationProxy,
  IFCPrivateMessageProxy? messageProxy,
  required TestConfig config,
}) {
  final helper = ProxyTestHelper(config);

  group('Basic Proxy Tests (App-Used Methods Only)', () {
    // ============================================================================
    // IFCConfigProxy - Essential
    // ============================================================================
    group('IFCConfigProxy', () {
      helper.setProxyName('IFCConfigProxy');
      
      test('getConfig returns valid configuration', () async {
        final testName = 'getConfig returns valid configuration';
        try {
          final result = await configProxy.getConfig(config.testUrl, forceRefresh: false);
          expect(result, isNotNull, reason: 'getConfig should return a non-null result');
          expect(result.version, isNotEmpty, reason: 'getConfig should return a valid version');
          helper.tracker.recordSuccess(testName, proxyName: 'IFCConfigProxy', methodName: 'getConfig');
        } catch (e) {
          helper.tracker.recordFailure(testName, proxyName: 'IFCConfigProxy', methodName: 'getConfig', errorMessage: e.toString());
          rethrow;
        }
      });
    });

    // ============================================================================
    // IFCForumProxy - Essential
    // ============================================================================
    group('IFCForumProxy', () {
      helper.setProxyName('IFCForumProxy');
      
      test('getForumAsync returns result: true', () async {
        final testName = 'getForumAsync returns result: true';
        final result = await forumProxy.getForumAsync(true, '', false);
        helper.assertResultTrue(result, 'getForumAsync', testName: testName, proxyName: 'IFCForumProxy');
      });

      test('markAllAsRead returns result: true', () async {
        final testName = 'markAllAsRead returns result: true';
        helper.failIfNotAuthenticated(testName, proxyName: 'IFCForumProxy', methodName: 'markAllAsRead');
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

      test('getBoardStatAsync returns result: true', () async {
        final testName = 'getBoardStatAsync returns result: true';
        final result = await forumProxy.getBoardStatAsync();
        helper.assertResultTrue(result, 'getBoardStatAsync', testName: testName, proxyName: 'IFCForumProxy');
      });
    });

    // ============================================================================
    // IFCTopicProxy - Essential
    // ============================================================================
    group('IFCTopicProxy', () {
      helper.setProxyName('IFCTopicProxy');
      
      // Store topicId created in newTopic for use in subsequent tests
      String? createdTopicId;
      
      test('newTopic returns result: true', () async {
        final testName = 'newTopic returns result: true';
        helper.failIfNotAuthenticated(testName, proxyName: 'IFCTopicProxy', methodName: 'newTopic');
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final result = await topicProxy.newTopic(
          forumId,
          'Test Topic ${DateTime.now().millisecondsSinceEpoch}',
          'Test topic body content',
        );
        helper.assertResultTrue(result, 'newTopic', testName: testName, proxyName: 'IFCTopicProxy');
        // Save topicId for use in subsequent tests
        if (result.result && result.topicId.isNotEmpty) {
          createdTopicId = result.topicId;
          print('✅ Created topic ID: $createdTopicId');
        }
      });

      test('getTopTopicAsync returns result: true', () async {
        final testName = 'getTopTopicAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final result = await topicProxy.getTopTopicAsync(forumId, 0, 10);
        helper.assertResultTrue(result, 'getTopTopicAsync', testName: testName, proxyName: 'IFCTopicProxy');
      });

      test('getAnnTopicAsync returns result: true', () async {
        final testName = 'getAnnTopicAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final result = await topicProxy.getAnnTopicAsync(forumId, 0, 10);
        helper.assertResultTrue(result, 'getAnnTopicAsync', testName: testName, proxyName: 'IFCTopicProxy');
      });

      test('getTopicAsync returns result: true', () async {
        final testName = 'getTopicAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final result = await topicProxy.getTopicAsync(forumId, 0, 10);
        helper.assertResultTrue(result, 'getTopicAsync', testName: testName, proxyName: 'IFCTopicProxy');
      });

      test('getUnreadTopicAsync returns result: true', () async {
        final testName = 'getUnreadTopicAsync returns result: true';
        helper.failIfNotAuthenticated(testName, proxyName: 'IFCTopicProxy', methodName: 'getUnreadTopicAsync');
        final result = await topicProxy.getUnreadTopicAsync(0, 10);
        helper.assertResultTrue(result, 'getUnreadTopicAsync', testName: testName, proxyName: 'IFCTopicProxy');
      });

      test('getParticipatedTopicAsync returns result: true', () async {
        final testName = 'getParticipatedTopicAsync returns result: true';
        helper.failIfNotAuthenticated(testName, proxyName: 'IFCTopicProxy', methodName: 'getParticipatedTopicAsync');
        try {
          final result = await topicProxy.getParticipatedTopicAsync(config.username, 0, 10);
          helper.assertResultTrue(result, 'getParticipatedTopicAsync', testName: testName, proxyName: 'IFCTopicProxy');
        } on UnimplementedError {
          helper.tracker.recordNotImplemented(testName, proxyName: 'IFCTopicProxy', methodName: 'getParticipatedTopicAsync');
          rethrow;
        }
      });

      test('getLatestTopicAsync returns result: true', () async {
        final testName = 'getLatestTopicAsync returns result: true';
        final result = await topicProxy.getLatestTopicAsync(0, 10);
        helper.assertResultTrue(result, 'getLatestTopicAsync', testName: testName, proxyName: 'IFCTopicProxy');
      });
    });

    // ============================================================================
    // IFCPostProxy - Essential
    // ============================================================================
    group('IFCPostProxy', () {
      helper.setProxyName('IFCPostProxy');
      
      // Store postId created in replyPostAsync for use in subsequent tests
      String? createdPostId;
      
      test('reportPostAsync returns result: true', () async {
        final testName = 'reportPostAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
        final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
        final result = await postProxy.reportPostAsync(postId, 'Test reason');
        helper.assertResultTrue(result, 'reportPostAsync', testName: testName);
      });

      test('replyPostAsync returns result: true', () async {
        final testName = 'replyPostAsync returns result: true';
        helper.failIfNotAuthenticated(testName);
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        // Get a valid topic ID (will use most recent topic, which might be the one created in newTopic test)
        final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
        
        // If second user is configured, use it for this test (second user replies to first user's topic)
        if (config.hasSecondUserCredentials()) {
          // Create a second SiteContext for the second user
          final currentContext = SiteProxyFactory.context!;
          final secondSiteContext = SiteContext(
            siteType: currentContext.siteType,
            site: currentContext.site,
          );
          secondSiteContext.username = config.secondUsername;
          secondSiteContext.password = config.secondPassword;
          
          // Temporarily switch context to second user, create proxies, then restore
          final originalContext = SiteProxyFactory.context;
          try {
            SiteProxyFactory.initialize(secondSiteContext);
            
            // Login as second user
            final secondUserProxy = SiteProxyFactory.getUserProxy();
            final loginResult = await secondUserProxy.loginAsync(
              config.secondUsername!,
              config.secondPassword!,
              false,
              null,
            );
            
            if (loginResult.result) {
              // Create post proxy for second user
              final secondPostProxy = SiteProxyFactory.getPostProxy();
              final result = await secondPostProxy.replyPostAsync(
                forumId,
                topicId,
                'Test Reply from Second User',
                'Test reply body content from second user',
                null,
                null,
                false,
              );
              helper.assertResultTrue(result, 'replyPostAsync', testName: testName);
              // Save postId for use in subsequent tests
              if (result.result && result.postId != null && result.postId!.isNotEmpty) {
                createdPostId = result.postId;
                print('✅ Created post ID: $createdPostId (by second user)');
              }
            } else {
              print('⚠️  WARNING: Second user login failed, using first user for replyPostAsync');
              // Fallback to first user
              final result = await postProxy.replyPostAsync(
                forumId,
                topicId,
                'Test Reply',
                'Test reply body content',
                null,
                null,
                false,
              );
              helper.assertResultTrue(result, 'replyPostAsync', testName: testName);
              if (result.result && result.postId != null && result.postId!.isNotEmpty) {
                createdPostId = result.postId;
                print('✅ Created post ID: $createdPostId');
              }
            }
          } finally {
            // Restore original context
            if (originalContext != null) {
              SiteProxyFactory.initialize(originalContext);
            }
          }
        } else {
          // Fallback to first user if second user not configured
          final result = await postProxy.replyPostAsync(
            forumId,
            topicId,
            'Test Reply',
            'Test reply body content',
            null,
            null,
            false,
          );
          helper.assertResultTrue(result, 'replyPostAsync', testName: testName);
          if (result.result && result.postId != null && result.postId!.isNotEmpty) {
            createdPostId = result.postId;
            print('✅ Created post ID: $createdPostId');
          }
        }
      });

      test('getQuotePostAsync returns result: true', () async {
        final testName = 'getQuotePostAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
        // Use createdPostId if available (from second user's reply), otherwise fetch or use config
        final postId = createdPostId ?? await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
        final result = await postProxy.getQuotePostAsync(postId);
        helper.assertResultTrue(result, 'getQuotePostAsync', testName: testName);
      });

      test('getRawPostAsync returns result: true', () async {
        final testName = 'getRawPostAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
        final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
        final result = await postProxy.getRawPostAsync(postId);
        helper.assertResultTrue(result, 'getRawPostAsync', testName: testName);
      });

      test('saveRawPostAsync returns result: true', () async {
        final testName = 'saveRawPostAsync returns result: true';
        helper.failIfNotAuthenticated(testName);
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
        final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
        final result = await postProxy.saveRawPostAsync(
          postId,
          'Updated Title',
          'Updated content',
          false,
          null,
          null,
          null,
          null, // prefix
        );
        helper.assertResultTrue(result, 'saveRawPostAsync', testName: testName);
      });

      test('getThreadAsync returns result: true', () async {
        final testName = 'getThreadAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
        final result = await postProxy.getThreadAsync(topicId, 0, 10, false);
        helper.assertResultTrue(result, 'getThreadAsync', testName: testName);
      });

      test('getThreadByUnreadAsync returns result: true', () async {
        final testName = 'getThreadByUnreadAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
        final result = await postProxy.getThreadByUnreadAsync(topicId, 10, false);
        helper.assertResultTrue(result, 'getThreadByUnreadAsync', testName: testName);
      });

      test('getThreadByPostAsync returns result: true', () async {
        final testName = 'getThreadByPostAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
        final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
        final result = await postProxy.getThreadByPostAsync(postId, 10, false);
        helper.assertResultTrue(result, 'getThreadByPostAsync', testName: testName);
      });
    });

    // ============================================================================
    // IFCUserProxy - Essential
    // ============================================================================
    group('IFCUserProxy', () {
      helper.setProxyName('IFCUserProxy');
      
      test('loginAsync returns result: true', () async {
        final testName = 'loginAsync returns result: true';
        final result = await userProxy.loginAsync(config.username, config.password, false, null);
        // Verify fc_is_login header is true after login
        helper.assertResultTrue(result, 'loginAsync', testName: testName, proxyName: 'IFCUserProxy', checkFcIsLogin: true);
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

      test('searchUserAsync returns result: true', () async {
        final testName = 'searchUserAsync returns result: true';
        final result = await userProxy.searchUserAsync(config.username, 1, 20);
        helper.assertResultTrue(result, 'searchUserAsync', testName: testName);
      });
    });

    // ============================================================================
    // IFCSearchProxy - Essential
    // ============================================================================
    group('IFCSearchProxy', () {
      helper.setProxyName('IFCSearchProxy');
      
      test('searchTopicAsync returns result: true', () async {
        final testName = 'searchTopicAsync returns result: true';
        final result = await searchProxy.searchTopicAsync('test', 0, 10, null);
        helper.assertResultTrue(result, 'searchTopicAsync', testName: testName);
      });

      test('searchPostAsync returns result: true', () async {
        final testName = 'searchPostAsync returns result: true';
        final result = await searchProxy.searchPostAsync('test', 0, 10, null);
        helper.assertResultTrue(result, 'searchPostAsync', testName: testName);
      });

      test('advanceSearchPostAsync returns result: true', () async {
        final testName = 'advanceSearchPostAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final result = await searchProxy.advanceSearchPostAsync(
          'test',
          1,
          20,
          null,
          false,
          null,
          null,
          forumId,
          null,
          null,
          null,
          false,
        );
        helper.assertResultTrue(result, 'advanceSearchPostAsync', testName: testName);
      });

      test('advanceSearchTopicAsync returns result: true', () async {
        final testName = 'advanceSearchTopicAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final result = await searchProxy.advanceSearchTopicAsync(
          'test',
          1,
          20,
          null,
          false,
          null,
          null,
          forumId,
          null,
          null,
          null,
          false,
          null,
        );
        helper.assertResultTrue(result, 'advanceSearchTopicAsync', testName: testName);
      });
    });

    // ============================================================================
    // IFCSubscriptionProxy - Essential
    // ============================================================================
    group('IFCSubscriptionProxy', () {
      helper.setProxyName('IFCSubscriptionProxy');
      
      if (!config.isAuthenticated) {
        print('⚠️  WARNING: Skipping IFCSubscriptionProxy tests - user authentication required but login failed');
        return;
      }

      test('getSubscribedForumAsync returns result: true', () async {
        final testName = 'getSubscribedForumAsync returns result: true';
        final result = await subscriptionProxy.getSubscribedForumAsync();
        // Verify fc_is_login header is true for authenticated requests
        helper.assertResultTrue(result, 'getSubscribedForumAsync', testName: testName, checkFcIsLogin: true);
      });

      test('subscribeForumAsync returns result: true', () async {
        final testName = 'subscribeForumAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final result = await subscriptionProxy.subscribeForumAsync(forumId, 0);
        // Verify fc_is_login header is true for authenticated requests
        helper.assertResultTrue(result, 'subscribeForumAsync', testName: testName, checkFcIsLogin: true);
      });

      test('unsubscribeForumAsync returns result: true', () async {
        final testName = 'unsubscribeForumAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final result = await subscriptionProxy.unsubscribeForumAsync(forumId);
        // Verify fc_is_login header is true for authenticated requests
        helper.assertResultTrue(result, 'unsubscribeForumAsync', testName: testName, checkFcIsLogin: true);
      });

      test('getSubscribedTopicAsync returns result: true', () async {
        final testName = 'getSubscribedTopicAsync returns result: true';
        final result = await subscriptionProxy.getSubscribedTopicAsync(0, 10);
        // Verify fc_is_login header is true for authenticated requests
        helper.assertResultTrue(result, 'getSubscribedTopicAsync', testName: testName, checkFcIsLogin: true);
      });

      test('subscribeTopicAsync returns result: true', () async {
        final testName = 'subscribeTopicAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
        final result = await subscriptionProxy.subscribeTopicAsync(topicId, 0);
        // Verify fc_is_login header is true for authenticated requests
        helper.assertResultTrue(result, 'subscribeTopicAsync', testName: testName, checkFcIsLogin: true);
      });

      test('unsubscribeTopicAsync returns result: true', () async {
        final testName = 'unsubscribeTopicAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
        final result = await subscriptionProxy.unsubscribeTopicAsync(topicId);
        // Verify fc_is_login header is true for authenticated requests
        helper.assertResultTrue(result, 'unsubscribeTopicAsync', testName: testName, checkFcIsLogin: true);
      });
    });

    // ============================================================================
    // IFCSocialProxy - Essential
    // ============================================================================
    group('IFCSocialProxy', () {
      helper.setProxyName('IFCSocialProxy');
      
      if (!config.isAuthenticated) {
        print('⚠️  WARNING: Skipping IFCSocialProxy tests - user authentication required but login failed');
        return;
      }

      test('thankPostAsync returns result: true', () async {
        final testName = 'thankPostAsync returns result: true';
        if (helper.skipIfThankPostIdNotConfigured(testName)) {
          return;
        }
        final result = await socialProxy.thankPostAsync(config.thankPostId);
        helper.assertResultTrue(result, 'thankPostAsync', testName: testName);
      });

      test('likePostAsync returns result: true', () async {
        final testName = 'likePostAsync returns result: true';
        if (helper.skipIfLikePostIdNotConfigured(testName)) {
          return;
        }
        final result = await socialProxy.likePostAsync(config.likePostId);
        helper.assertResultTrue(result, 'likePostAsync', testName: testName);
      });

      test('unlikePostAsync returns result: true', () async {
        final testName = 'unlikePostAsync returns result: true';
        if (helper.skipIfLikePostIdNotConfigured(testName)) {
          return;
        }
        final result = await socialProxy.unlikePostAsync(config.likePostId);
        helper.assertResultTrue(result, 'unlikePostAsync', testName: testName);
      });

      test('getAlertAsync returns result: true', () async {
        final testName = 'getAlertAsync returns result: true';
        final result = await socialProxy.getAlertAsync(1, 20, false);
        helper.assertResultTrue(result, 'getAlertAsync', testName: testName);
      });
    });

    // ============================================================================
    // IFCAttachmentProxy - Essential
    // ============================================================================
    group('IFCAttachmentProxy', () {
      helper.setProxyName('IFCAttachmentProxy');
      
      test('uploadAttachmentAsync returns result: true', () async {
        final testName = 'uploadAttachmentAsync returns result: true';
        final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
        final attachmentBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        // Generate unique groupId for each test to avoid hitting 10-file limit
        // Use timestamp to ensure uniqueness
        final uniqueGroupId = DateTime.now().millisecondsSinceEpoch.toString();
        final result = await attachmentProxy.uploadAttachmentAsync(
          'forum',
          forumId,
          uniqueGroupId,
          'test.txt',
          attachmentBytes,
        );
        helper.assertResultTrue(result, 'uploadAttachmentAsync', testName: testName);
        // Note: Attachments are not cleaned up manually - XenForo automatically cleans up orphaned temporary attachments
      });

      test('uploadAvatarAsync returns result: true', () async {
        final testName = 'uploadAvatarAsync returns result: true';
        // Load real PNG image for testing (Flutter logo from Wikimedia Commons)
        final imageFile = File('packages/forumcopilot_sdk/lib/test/assets/flutter_logo.png');
        Uint8List attachmentBytes;
        if (await imageFile.exists()) {
          attachmentBytes = await imageFile.readAsBytes();
        } else {
          // Fallback to minimal valid PNG if file not found
          attachmentBytes = Uint8List.fromList([
            0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
            0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, // IHDR chunk
            0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, // 1x1 pixel
            0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53, // bit depth, color type, etc.
            0xDE, 0x00, 0x00, 0x00, 0x0C, 0x49, 0x44, 0x41, // IDAT chunk
            0x54, 0x08, 0x99, 0x01, 0x01, 0x00, 0x00, 0x00, // compressed data
            0x00, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x02, 0x00, // more data
            0x01, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, // IEND chunk
            0x44, 0xAE, 0x42, 0x60, 0x82
          ]);
        }
        final result = await attachmentProxy.uploadAvatarAsync('png', attachmentBytes);
        helper.assertResultTrue(result, 'uploadAvatarAsync', testName: testName);
      });
    });

    // ============================================================================
    // IFCPrivateConversationProxy - Essential (if conversations are used)
    // ============================================================================
    if (config.usesConversations() && conversationProxy != null) {
      group('IFCPrivateConversationProxy', () {
        helper.setProxyName('IFCPrivateConversationProxy');
        
        if (!config.isAuthenticated) {
          print('⚠️  WARNING: Skipping IFCPrivateConversationProxy tests - user authentication required but login failed');
          return;
        }

        // Store conversationId created in newConversationAsync for use in subsequent tests
        String? createdConversationId;

        test('newConversationAsync returns result: true', () async {
          final testName = 'newConversationAsync returns result: true';
          // Use secondUsername if available, otherwise use username (self-conversation for testing)
          final recipientUsername = config.hasSecondUserCredentials() 
              ? config.secondUsername! 
              : config.username;
          final result = await conversationProxy.newConversationAsync(
            [recipientUsername],
            'Test Conversation ${DateTime.now().millisecondsSinceEpoch}',
            'Test conversation body',
          );
          helper.assertResultTrue(result, 'newConversationAsync', testName: testName);
          // Save conversationId for use in subsequent tests
          if (result.result && result.convId.isNotEmpty) {
            createdConversationId = result.convId;
            print('✅ Created conversation ID: $createdConversationId');
          }
        });

        test('replyConversationAsync returns result: true', () async {
          final testName = 'replyConversationAsync returns result: true';
          final conversationId = createdConversationId ?? config.conversationId;
          final result = await conversationProxy.replyConversationAsync(
            conversationId,
            'Test reply',
            null,
            null,
          );
          helper.assertResultTrue(result, 'replyConversationAsync', testName: testName);
        });

        test('inviteParticipantAsync returns result: true', () async {
          final testName = 'inviteParticipantAsync returns result: true';
          final conversationId = createdConversationId ?? config.conversationId;
          final result = await conversationProxy.inviteParticipantAsync(
            [config.username],
            conversationId,
            'Test invitation',
          );
          helper.assertResultTrue(result, 'inviteParticipantAsync', testName: testName);
        });

        test('getConversationsAsync returns result: true', () async {
          final testName = 'getConversationsAsync returns result: true';
          final result = await conversationProxy.getConversationsAsync(0, 10);
          helper.assertResultTrue(result, 'getConversationsAsync', testName: testName);
        });

        test('getConversationAsync returns result: true', () async {
          final testName = 'getConversationAsync returns result: true';
          final conversationId = createdConversationId ?? config.conversationId;
          final result = await conversationProxy.getConversationAsync(
            conversationId,
            0,
            10,
            false,
          );
          helper.assertResultTrue(result, 'getConversationAsync', testName: testName);
        });

        test('getQuoteConversationAsync returns result: true', () async {
          final testName = 'getQuoteConversationAsync returns result: true';
          final conversationId = createdConversationId ?? config.conversationId;
          final result = await conversationProxy.getQuoteConversationAsync(
            conversationId,
            config.messageId,
          );
          helper.assertResultTrue(result, 'getQuoteConversationAsync', testName: testName);
        });

        test('markConversationUnreadAsync returns result: true', () async {
          final testName = 'markConversationUnreadAsync returns result: true';
          final conversationId = createdConversationId ?? config.conversationId;
          
          // If second user is configured, use it for this test (since first user already read the conversation)
          if (config.hasSecondUserCredentials()) {
            // Create a second SiteContext for the second user
            final currentContext = SiteProxyFactory.context!;
            final secondSiteContext = SiteContext(
              siteType: currentContext.siteType,
              site: currentContext.site,
            );
            secondSiteContext.username = config.secondUsername;
            secondSiteContext.password = config.secondPassword;
            
            // Temporarily switch context to second user, create proxies, then restore
            final originalContext = SiteProxyFactory.context;
            try {
              SiteProxyFactory.initialize(secondSiteContext);
              
              // Login as second user
              final secondUserProxy = SiteProxyFactory.getUserProxy();
              final loginResult = await secondUserProxy.loginAsync(
                config.secondUsername!,
                config.secondPassword!,
                false,
                null,
              );
              
              if (loginResult.result) {
                // Create conversation proxy for second user
                final secondConversationProxy = SiteProxyFactory.getPrivateConversationProxy();
                final result = await secondConversationProxy.markConversationUnreadAsync(conversationId);
                helper.assertResultTrue(result, 'markConversationUnreadAsync', testName: testName);
              } else {
                print('⚠️  WARNING: Second user login failed, skipping markConversationUnreadAsync test');
              }
            } finally {
              // Restore original context
              if (originalContext != null) {
                SiteProxyFactory.initialize(originalContext);
              }
            }
          } else {
            // Fallback to first user if second user not configured
            final result = await conversationProxy.markConversationUnreadAsync(conversationId);
            helper.assertResultTrue(result, 'markConversationUnreadAsync', testName: testName);
          }
        });

        test('leaveConversationAsync returns result: true', () async {
          final testName = 'leaveConversationAsync returns result: true';
          final conversationId = createdConversationId ?? config.conversationId;
          final result = await conversationProxy.leaveConversationAsync(conversationId, 0);
          helper.assertResultTrue(result, 'leaveConversationAsync', testName: testName);
        });
      });
    }

    // ============================================================================
    // IFCPrivateMessageProxy - Essential (if private messages are used)
    // ============================================================================
    if (config.usesPrivateMessages() && messageProxy != null) {
      group('IFCPrivateMessageProxy', () {
        helper.setProxyName('IFCPrivateMessageProxy');
        
        if (!config.isAuthenticated) {
          print('⚠️  WARNING: Skipping IFCPrivateMessageProxy tests - user authentication required but login failed');
          return;
        }

        test('getQuotePmAsync returns result: true', () async {
          final testName = 'getQuotePmAsync returns result: true';
          final result = await messageProxy.getQuotePmAsync(config.messageId);
          helper.assertResultTrue(result, 'getQuotePmAsync', testName: testName);
        });

        test('markPmUnreadAsync returns result: true', () async {
          final testName = 'markPmUnreadAsync returns result: true';
          final result = await messageProxy.markPmUnreadAsync(config.messageId);
          helper.assertResultTrue(result, 'markPmUnreadAsync', testName: testName);
        });
      });
    }
  });
}

