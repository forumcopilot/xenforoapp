import 'dart:typed_data';
import '../models/results/fc_attachment_result.dart';

/// Interface for attachment management operations
/// This interface allows for uploading and managing attachments associated with posts
abstract class IFCAttachmentProxy {
  /// Upload an attachment to the forum
  ///
  /// [type] Type of attachment (e.g., "forum" or "post")
  /// [id] ID of the forum or post
  /// [groupId] Group ID for the attachment
  /// [attachmentName] Name of the attachment file
  /// [attachmentBytes] Binary data of the attachment
  Future<FCAttachmentUploadResult> uploadAttachmentAsync(String type, String id, String groupId, String attachmentName, Uint8List attachmentBytes);

  /// Upload an avatar image
  ///
  /// [imageExtension] File extension of the image (e.g., "jpg", "png")
  /// [attachmentBytes] Binary data of the avatar image
  Future<FCAttachmentUploadResult> uploadAvatarAsync(String imageExtension, Uint8List attachmentBytes);

  /// This function instructs the forum system to remove the attachment from the post.
  ///
  /// [attachmentId] ID of the attachment to remove
  /// [forumId] Forum ID where the attachment is used
  /// [groupId] Group ID of the attachment
  /// [postId] Post ID for editing existing posts with attachments
  Future<FCAttachmentRemoveResult> removeAttachmentAsync(String attachmentId, String forumId, String groupId, String postId);

  /// Upload an image to Tapatalk's servers
  ///
  /// [attachmentName] Name of the image file
  /// [attachmentBytes] Binary data of the image
  Future<FCTapatalkImageUploadResult> uploadTapatalkImageAsync(String attachmentName, Uint8List attachmentBytes);
}
