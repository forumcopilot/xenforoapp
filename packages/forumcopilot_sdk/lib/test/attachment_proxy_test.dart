import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import '../interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCAttachmentProxy interface
/// 
/// These tests verify that all methods return result: true
void runAttachmentProxyTests(IFCAttachmentProxy attachmentProxy, IFCPostProxy postProxy, IFCTopicProxy topicProxy, IFCForumProxy forumProxy, TestConfig config) {
  final helper = ProxyTestHelper(config);
  helper.setProxyName('IFCAttachmentProxy');

  // Set by the upload test; the remove test prefers it over config.attachmentId
  // so the suite cleans up after itself instead of deleting seeded content.
  String? uploadedAttachmentId;

  test('uploadAttachmentAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final attachmentBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final result = await attachmentProxy.uploadAttachmentAsync(
        'forum',
        forumId,
        config.groupId,
        'test.txt',
        attachmentBytes,
      );
      helper.assertResultTrue(result, 'uploadAttachmentAsync');
      if (result.result && (result.attachmentId ?? '').isNotEmpty) {
        uploadedAttachmentId = result.attachmentId;
      }
    });

    test('uploadAvatarAsync returns result: true', () async {
      final attachmentBytes = ProxyTestHelper.testImageBytes();
      final result = await attachmentProxy.uploadAvatarAsync('png', attachmentBytes);
      helper.assertResultTrue(result, 'uploadAvatarAsync');
    });

    test('removeAttachmentAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await attachmentProxy.removeAttachmentAsync(
        uploadedAttachmentId ?? config.attachmentId,
        forumId,
        config.groupId,
        postId,
      );
      helper.assertResultTrue(result, 'removeAttachmentAsync');
    });
}

