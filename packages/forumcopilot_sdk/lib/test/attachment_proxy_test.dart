import 'dart:typed_data';
import 'dart:io';
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
    });

    test('uploadAvatarAsync returns result: true', () async {
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
      helper.assertResultTrue(result, 'uploadAvatarAsync');
    });

    test('removeAttachmentAsync returns result: true', () async {
      final forumId = await helper.fetchValidForumId(forumProxy) ?? config.forumId;
      final topicId = await helper.fetchValidTopicId(topicProxy, forumId) ?? config.topicId;
      final postId = await helper.fetchValidPostId(postProxy, topicId) ?? config.postId;
      final result = await attachmentProxy.removeAttachmentAsync(
        config.attachmentId,
        forumId,
        config.groupId,
        postId,
      );
      helper.assertResultTrue(result, 'removeAttachmentAsync');
    });

    test('uploadTapatalkImageAsync returns result: true', () async {
      final attachmentBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final result = await attachmentProxy.uploadTapatalkImageAsync('test.jpg', attachmentBytes);
      helper.assertResultTrue(result, 'uploadTapatalkImageAsync');
    });
}

