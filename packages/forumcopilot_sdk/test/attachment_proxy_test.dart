import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';
import 'config/test_config.dart';
import 'support/proxy_test_helper.dart';

/// Tests for IFCAttachmentProxy interface
///
/// These tests verify that all methods return result: true
void runAttachmentProxyTests(IFCAttachmentProxy attachmentProxy, IFCPostProxy postProxy, IFCTopicProxy topicProxy, IFCForumProxy forumProxy, TestConfig config) {
  group('IFCAttachmentProxy Tests', () {
    late ProxyTestHelper helper;

    setUp(() {
      helper = ProxyTestHelper(config);
    });

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
      final attachmentBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final result = await attachmentProxy.uploadAvatarAsync('jpg', attachmentBytes);
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
  });
}
