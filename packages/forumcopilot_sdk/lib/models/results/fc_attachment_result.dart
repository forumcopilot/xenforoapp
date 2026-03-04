import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_attachment_result.mapper.dart';

/// Forum Copilot Attachment Upload Result
/// Maps from UploadData_Output
@MappableClass()
class FCAttachmentUploadResult extends FCBaseResult with FCAttachmentUploadResultMappable {
  /// This ID is needed by the app to pass into the new_topic or reply_post functions
  /// to finalize the attachments linkage with the post.
  String? attachmentId;

  /// File name of the uploaded attachment
  String? fileName;

  /// This ID is needed by the forum system to associate attachments with a specific post.
  /// Do not return this field if a forum system does not require group_id for attachment association.
  /// This group_id can also be dynamic depends on the forum system.
  String? groupId;

  /// Return the file size of the uploaded file after processed by the forum system.
  int? fileSize;

  FCAttachmentUploadResult({
    required bool result,
    String? resultText,
    this.attachmentId,
    this.fileName,
    this.groupId,
    this.fileSize,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Attachment Remove Result
/// Maps from RemoveAttachmentData_Output
@MappableClass()
class FCAttachmentRemoveResult extends FCBaseResult with FCAttachmentRemoveResultMappable {
  /// Depends on different forum system, the group ID can be dynamic.
  /// If this key is returned, the app will change the group_id for the current message attachment session.
  String? groupId;

  FCAttachmentRemoveResult({
    required bool result,
    String? resultText,
    this.groupId,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Tapatalk Image Upload Result
/// Maps from UploadTapatalkImageData_Output
@MappableClass()
class FCTapatalkImageUploadResult extends FCBaseResult with FCTapatalkImageUploadResultMappable {
  /// URL of the uploaded image
  String? imageUrl;

  /// ID of the uploaded image
  String? imageId;

  /// Thumbnail URL of the uploaded image
  String? thumbnailUrl;

  FCTapatalkImageUploadResult({
    required bool result,
    String? resultText,
    this.imageUrl,
    this.imageId,
    this.thumbnailUrl,
  }) : super(result: result, resultText: resultText);
}
