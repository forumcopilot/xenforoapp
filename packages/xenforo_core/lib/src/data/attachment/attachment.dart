import 'package:dart_mappable/dart_mappable.dart';

part 'attachment.mapper.dart';

/// XenForo attachment model based on official API documentation
@MappableClass()
class XenForoAttachment with XenForoAttachmentMappable {
  /// Attachment ID
  final int attachmentId;

  /// Filename
  final String filename;

  /// File size in bytes
  final int fileSize;

  /// Height in pixels
  final int? height;

  /// Width in pixels
  final int? width;

  /// Thumbnail URL
  final String? thumbnailUrl;

  /// Direct URL
  final String? directUrl;

  /// Whether attachment is video
  final bool? isVideo;

  /// Whether attachment is audio
  final bool? isAudio;

  /// Content type
  final String? contentType;

  /// Content ID
  final int? contentId;

  /// Attach date (Unix timestamp)
  final int? attachDate;

  /// View count
  final int? viewCount;

  const XenForoAttachment({
    required this.attachmentId,
    required this.filename,
    required this.fileSize,
    this.height,
    this.width,
    this.thumbnailUrl,
    this.directUrl,
    this.isVideo,
    this.isAudio,
    this.contentType,
    this.contentId,
    this.attachDate,
    this.viewCount,
  });

  /// Create from JSON response
  factory XenForoAttachment.fromJson(Map<String, dynamic> json) {
    return XenForoAttachment(
      attachmentId: json['attachment_id'] ?? 0,
      filename: json['filename'] ?? '',
      fileSize: json['file_size'] ?? 0,
      height: json['height'],
      width: json['width'],
      thumbnailUrl: json['thumbnail_url'],
      directUrl: json['direct_url'],
      isVideo: json['is_video'],
      isAudio: json['is_audio'],
      contentType: json['content_type'],
      contentId: json['content_id'],
      attachDate: json['attach_date'],
      viewCount: json['view_count'],
    );
  }

  // Convenience getters for backward compatibility
  String get id => attachmentId.toString();
  String get url => directUrl ?? '';
  String get mimeType => contentType ?? '';
  bool get isImage => !(isVideo ?? false) && !(isAudio ?? false);
  int get imageWidth => width ?? 0;
  int get imageHeight => height ?? 0;
  int get downloadCount => viewCount ?? 0;
  DateTime? get uploadDate => attachDate != null ? DateTime.fromMillisecondsSinceEpoch(attachDate! * 1000) : null;
  bool get isApproved => true; // Assume approved if accessible
  bool get isDeleted => false; // Assume not deleted if accessible
  String get description => filename;
}
