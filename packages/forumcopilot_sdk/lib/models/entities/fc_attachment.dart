import 'package:dart_mappable/dart_mappable.dart';

part 'fc_attachment.mapper.dart';

/// FCAttachment (Forum Consolidated Attachment) represents a file attachment in a post
@MappableClass()
class FCAttachment with FCAttachmentMappable {
  /// Unique identifier for the attachment
  String id;

  /// Filename of the attachment
  @MappableField(key: 'fileName')
  String filename;

  /// Content type/MIME type of the attachment
  @MappableField(key: 'mimeType')
  String? contentType;

  /// File size in bytes
  @MappableField(key: 'fileSize')
  int fileSize;

  /// URL to download the attachment
  String url;

  /// URL to a thumbnail of the attachment (for images)
  String? thumbnailUrl;

  /// Indicates if this is an image attachment
  @MappableField(key: 'isImage')
  bool isImage;

  /// The forum ID where the attachment belongs
  String? forumId;

  /// The post ID where the attachment is attached
  String? postId;

  /// Whether the user can view the full attachment URL
  bool? canViewUrl;

  /// Whether the user can view the thumbnail URL
  bool? canViewThumbnailUrl;

  /// Group ID for attachment grouping
  String? groupId;

  /// Width of the attachment (for images)
  int? width;

  /// Height of the attachment (for images)
  int? height;

  /// Icon identifier for file type (e.g., "fa-file-image", "fa-file-pdf")
  String? icon;

  /// Human-readable icon name
  String? iconName;

  /// Whether the attachment is a video file
  @MappableField(key: 'isVideo')
  bool? isVideo;

  /// Whether the attachment is an audio file
  @MappableField(key: 'isAudio')
  bool? isAudio;

  /// Direct link URL to the attachment
  String? link;

  /// Type grouping (e.g., "image", "video", "audio", "file")
  String? typeGrouping;

  /// Human-readable file size (e.g., "240.00 KB", "1.00 MB")
  String? fileSizePrintable;

  /// Whether the attachment is embedded inline in the post content
  @MappableField(key: 'isInline')
  bool? isInline;

  FCAttachment({
    required this.id,
    required this.filename,
    this.contentType,
    required this.fileSize,
    required this.url,
    this.thumbnailUrl,
    this.isImage = false,
    this.forumId,
    this.postId,
    this.canViewUrl,
    this.canViewThumbnailUrl,
    this.groupId,
    this.width,
    this.height,
    this.icon,
    this.iconName,
    this.isVideo,
    this.isAudio,
    this.link,
    this.typeGrouping,
    this.fileSizePrintable,
    this.isInline,
  });
}
