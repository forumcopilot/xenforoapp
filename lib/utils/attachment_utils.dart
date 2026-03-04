import 'package:forumcopilot_sdk/models/entities/fc_attachment.dart';
import 'package:image_picker/image_picker.dart';

/// Utility class for common attachment operations
class AttachmentUtils {
  /// Builds BBCode attribute string from FCAttachment fields
  /// This centralizes the logic currently in BBCodeProcessor.replaceInlineAttachmentUrlsAndFilter
  static String buildBBCodeAttributes(FCAttachment attachment) {
    final attrs = <String>[];

    if (attachment.thumbnailUrl != null && attachment.thumbnailUrl!.isNotEmpty) {
      attrs.add('thumbnailUrl="${attachment.thumbnailUrl}"');
    }
    if (attachment.url.isNotEmpty) {
      attrs.add('url="${attachment.url}"');
    }
    if (attachment.filename.isNotEmpty) {
      attrs.add('filename="${attachment.filename}"');
    }
    if (attachment.contentType != null && attachment.contentType!.isNotEmpty) {
      attrs.add('contentType="${attachment.contentType}"');
    }
    if (attachment.fileSize > 0) {
      attrs.add('fileSize="${attachment.fileSize}"');
    }
    if (attachment.id.isNotEmpty) {
      attrs.add('id="${attachment.id}"');
    }
    if (attachment.isImage) {
      attrs.add('isImage="true"');
    }
    if (attachment.forumId != null && attachment.forumId!.isNotEmpty) {
      attrs.add('forumId="${attachment.forumId}"');
    }
    if (attachment.postId != null && attachment.postId!.isNotEmpty) {
      attrs.add('postId="${attachment.postId}"');
    }
    // Handle both Attachment (can_view_url) and FCAttachment (canViewUrl) property names
    bool? canViewUrl;
    bool? canViewThumbnailUrl;

    try {
      // Try FCAttachment property names first (camelCase)
      canViewUrl = attachment.canViewUrl;
      canViewThumbnailUrl = attachment.canViewThumbnailUrl;
    } catch (e) {
      // Fall back to Attachment property names (snake_case)
      try {
        canViewUrl = attachment.canViewUrl;
        canViewThumbnailUrl = attachment.canViewThumbnailUrl;
      } catch (e2) {
        // If both fail, set to null
        canViewUrl = null;
        canViewThumbnailUrl = null;
      }
    }

    if (canViewUrl != null) {
      attrs.add('canViewUrl="$canViewUrl"');
    }
    if (canViewThumbnailUrl != null) {
      attrs.add('canViewThumbnailUrl="$canViewThumbnailUrl"');
    }

    return attrs.isNotEmpty ? ' ' + attrs.join(' ') : '';
  }

  /// Creates an inline attachment BBCode tag from an attachment
  static String createInlineAttachmentTag(FCAttachment attachment) {
    final attrString = buildBBCodeAttributes(attachment);
    return '[inlineattachment$attrString]${attachment.url}[/inlineattachment]';
  }

  /// Filters attachments by URLs that have been processed
  /// Returns the remaining attachments that haven't been used
  static List<FCAttachment> filterUsedAttachments(List<FCAttachment> attachments, Set<String> usedUrls) {
    return attachments.where((att) => !usedUrls.contains(att.url)).toList();
  }

  /// Checks if an attachment is an image based on content type or filename
  static bool isImageAttachment(FCAttachment attachment) {
    if (attachment is XFile) {
      return _isImageFile(attachment.filename);
    }

    // For FCAttachment or similar objects
    if (attachment.contentType?.startsWith('image/') == true) {
      return true;
    }

    if (attachment.isImage == true) {
      return true;
    }

    return _isImageFile(attachment.filename ?? '');
  }

  /// Gets the appropriate icon for an attachment based on content type
  static String getAttachmentIconName(FCAttachment attachment) {
    String? contentType;

    if (attachment is XFile) {
      contentType = _getContentTypeFromExtension(attachment.filename);
    } else {
      contentType = attachment.contentType;
    }

    if (contentType == null) return 'attach_file';

    if (contentType.startsWith('image/')) {
      return 'image';
    } else if (contentType.startsWith('video/')) {
      return 'video_file';
    } else if (contentType.startsWith('audio/')) {
      return 'audio_file';
    } else if (contentType.contains('pdf')) {
      return 'picture_as_pdf';
    } else if (contentType.contains('document') || contentType.contains('word')) {
      return 'description';
    } else if (contentType.contains('spreadsheet') || contentType.contains('excel')) {
      return 'table_chart';
    } else if (contentType.contains('presentation') || contentType.contains('powerpoint')) {
      return 'slideshow';
    } else if (contentType.contains('zip') || contentType.contains('rar') || contentType.contains('archive')) {
      return 'folder_zip';
    }

    return 'attach_file';
  }

  static bool _isImageFile(String filename) {
    final extension = filename.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'svg'].contains(extension);
  }

  static String? _getContentTypeFromExtension(String filename) {
    final extension = filename.split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      case 'svg':
        return 'image/svg+xml';
      case 'heic':
      case 'heif':
        return 'image/heic';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
      case 'docx':
        return 'application/msword';
      case 'xls':
      case 'xlsx':
        return 'application/vnd.ms-excel';
      case 'ppt':
      case 'pptx':
        return 'application/vnd.ms-powerpoint';
      case 'zip':
        return 'application/zip';
      case 'rar':
        return 'application/x-rar-compressed';
      case 'mp4':
        return 'video/mp4';
      case 'mp3':
        return 'audio/mpeg';
      default:
        return null;
    }
  }
}
