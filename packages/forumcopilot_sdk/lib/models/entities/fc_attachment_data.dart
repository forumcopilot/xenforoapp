import 'package:dart_mappable/dart_mappable.dart';

part 'fc_attachment_data.mapper.dart';

/// Attachment editor metadata for managing attachments during edit
@MappableClass()
class FCAttachmentData with FCAttachmentDataMappable {
  /// Content type (always "post" for posts)
  String type;

  /// Temporary hash for new attachment uploads
  String hash;

  /// Attachment context information
  FCAttachmentContext? context;

  /// Upload constraints for this forum
  FCAttachmentConstraints? constraints;

  FCAttachmentData({
    required this.type,
    required this.hash,
    this.context,
    this.constraints,
  });
}

/// Attachment context information
@MappableClass()
class FCAttachmentContext with FCAttachmentContextMappable {
  /// Forum/node ID where attachments can be uploaded
  @MappableField(key: 'node_id')
  int? nodeId;

  FCAttachmentContext({
    this.nodeId,
  });
}

/// Upload constraints for attachments
@MappableClass()
class FCAttachmentConstraints with FCAttachmentConstraintsMappable {
  /// Allowed file extensions
  List<String>? extensions;

  /// Maximum file size in bytes
  int? size;

  /// Maximum image width (if specified)
  int? width;

  /// Maximum image height (if specified)
  int? height;

  /// Maximum number of attachments per post (if specified)
  int? count;

  FCAttachmentConstraints({
    this.extensions,
    this.size,
    this.width,
    this.height,
    this.count,
  });
}

