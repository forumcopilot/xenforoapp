import 'package:forumcopilot_sdk/models/entities/fc_attachment.dart';
import '../data/attachment/attachment.dart';

/// Converter for XenForo attachment data to FCAttachment
class XenForoAttachmentConverter {
  /// Convert XenForo attachment to FCAttachment
  static FCAttachment toFCAttachment(XenForoAttachment xenForoAttachment) {
    return FCAttachment(
      id: xenForoAttachment.id,
      filename: xenForoAttachment.filename,
      contentType: xenForoAttachment.mimeType,
      fileSize: xenForoAttachment.fileSize,
      url: xenForoAttachment.url,
      thumbnailUrl: xenForoAttachment.thumbnailUrl,
      isImage: xenForoAttachment.isImage,
      forumId: '', // Not available in attachment data
      postId: xenForoAttachment.contentId?.toString() ?? '',
      canViewUrl: xenForoAttachment.directUrl != null,
      canViewThumbnailUrl: xenForoAttachment.thumbnailUrl != null,
    );
  }

  /// Convert list of XenForo attachments to list of FCAttachments
  static List<FCAttachment> toFCAttachmentList(List<XenForoAttachment> xenForoAttachments) {
    return xenForoAttachments.map((attachment) => toFCAttachment(attachment)).toList();
  }
}
