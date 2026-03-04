import 'package:dart_mappable/dart_mappable.dart';

part 'fc_private_message.mapper.dart';

/// FCPrivateMessage (Forum Consolidated Private Message) is a unified private message model
/// for UI consumption that abstracts away the specific implementation details of different PM sources.
@MappableClass()
class FCPrivateMessage with FCPrivateMessageMappable {
  /// Unique identifier for the message
  String id;

  /// Subject of the message
  String subject;

  /// Content of the message
  String content;

  /// Sender user ID
  String senderId;

  /// Sender username
  String senderName;

  /// Sender user type
  String? senderUserType;

  /// Sender avatar URL
  String? senderIconUrl;

  /// Recipient user ID
  String recipientId;

  /// Recipient username
  String recipientName;

  /// Message creation time
  DateTime timestamp;

  /// Whether the message has been read
  bool isRead;

  /// Whether the message has been replied to
  bool isReplied;

  /// Whether the message is from the current user
  bool isFromCurrentUser;

  /// Whether the message can be deleted
  bool canDelete;

  /// Whether the message can be reported
  bool canReport;

  /// Whether the message can be forwarded
  bool canForward;

  /// Whether the message can be replied to
  bool canReply;

  /// List of attachments in this message
  List<FCMessageAttachment> attachments;

  FCPrivateMessage({
    required this.id,
    required this.subject,
    required this.content,
    required this.senderId,
    required this.senderName,
    this.senderUserType,
    this.senderIconUrl,
    required this.recipientId,
    required this.recipientName,
    required this.timestamp,
    this.isRead = false,
    this.isReplied = false,
    this.isFromCurrentUser = false,
    this.canDelete = false,
    this.canReport = false,
    this.canForward = false,
    this.canReply = false,
    this.attachments = const [],
  });
}

/// Attachment for private messages
@MappableClass()
class FCMessageAttachment with FCMessageAttachmentMappable {
  /// Attachment ID
  String id;

  /// Original filename
  String filename;

  /// File size in bytes
  int fileSize;

  /// MIME type
  String contentType;

  /// URL to download the attachment
  String url;

  /// Thumbnail URL (for images)
  String? thumbnailUrl;

  /// Whether this is an image
  bool isImage;

  FCMessageAttachment({
    required this.id,
    required this.filename,
    required this.fileSize,
    required this.contentType,
    required this.url,
    this.thumbnailUrl,
    this.isImage = false,
  });
}
