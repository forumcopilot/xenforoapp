import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_private_message_result.mapper.dart';

/// Forum Copilot Report PM Result
/// Maps from ReportPMData_Output
@MappableClass()
class FCReportPMResult extends FCBaseResult with FCReportPMResultMappable {
  FCReportPMResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);

  // Compatibility properties for snake_case access
}

/// Forum Copilot Create Message Result
/// Maps from CreateMessageData_Output
@MappableClass()
class FCCreateMessageResult extends FCBaseResult with FCCreateMessageResultMappable {
  /// ID of the newly created message
  String msgId;

  FCCreateMessageResult({
    required bool result,
    String? resultText,
    required this.msgId,
  }) : super(result: result, resultText: resultText);

  // Compatibility properties for snake_case access
  String? get msg_id => msgId;
}

/// Forum Copilot Box Info Result
/// Maps from BoxInfoData_Output
@MappableClass()
class FCBoxInfoResult extends FCBaseResult with FCBoxInfoResultMappable {
  /// Remaining message quota
  int messageRoomCount;

  /// List of box information
  List<FCBoxInfo> list;

  // Compatibility properties for snake_case access
  int? get message_room_count => messageRoomCount;

  FCBoxInfoResult({
    required bool result,
    String? resultText,
    required this.messageRoomCount,
    required this.list,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Box Info
/// Maps from Info
@MappableClass()
class FCBoxInfo with FCBoxInfoMappable {
  /// Box ID
  String boxId;

  /// Box name
  String boxName;

  /// Box type (INBOX, SENT, etc.)
  String boxType;

  /// Number of messages in box
  int messageCount;

  /// Number of unread messages
  int unreadCount;

  FCBoxInfo({
    required this.boxId,
    required this.boxName,
    required this.boxType,
    required this.messageCount,
    required this.unreadCount,
  });

  // Compatibility properties for snake_case access
  String? get box_id => boxId;
  String? get box_name => boxName;
  String? get box_type => boxType;
  int? get message_count => messageCount;
  int? get unread_count => unreadCount;
}

/// Forum Copilot Box Result
/// Maps from BoxData_Output
@MappableClass()
class FCBoxResult extends FCBaseResult with FCBoxResultMappable {
  /// Total number of messages in box
  int totalMessageNum;

  /// List of messages
  List<FCPrivateMessage> list;

  // Compatibility properties for snake_case access
  int? get total_message_num => totalMessageNum;

  FCBoxResult({
    required bool result,
    String? resultText,
    required this.totalMessageNum,
    required this.list,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Private Message
/// Maps from Message
@MappableClass()
class FCPrivateMessage with FCPrivateMessageMappable {
  /// Message ID
  String msgId;

  /// Message subject
  String subject;

  /// Message subject (compatibility)
  String? msgSubject;

  /// Message from (compatibility)
  String? msgFrom;

  /// Message to (compatibility)
  List<String>? msgTo;

  /// Message author ID
  String authorId;

  /// Message author name
  String authorName;

  /// Message author avatar URL
  String? iconUrl;

  /// Message content
  String textBody;

  /// Message time
  String msgTime;

  /// Sent date (compatibility)
  String? sentDate;

  /// Timestamp (compatibility)
  String? timestamp;

  /// Message state (0 = read, 1 = unread)
  int msgState;

  /// Whether message is unread
  bool isUnread;

  /// Whether message is from current user
  bool? isFromCurrentUser;

  FCPrivateMessage({
    required this.msgId,
    required this.subject,
    this.msgSubject,
    this.msgFrom,
    this.msgTo,
    required this.authorId,
    required this.authorName,
    this.iconUrl,
    required this.textBody,
    required this.msgTime,
    this.sentDate,
    this.timestamp,
    required this.msgState,
    required this.isUnread,
    this.isFromCurrentUser,
  });

  // Compatibility properties for snake_case access
  String? get msg_id => msgId;
  String? get msg_subject => msgSubject ?? subject;
  String? get msg_from => msgFrom;
  List<String>? get msg_to => msgTo;
  String? get author_id => authorId;
  String? get author_name => authorName;
  String? get icon_url => iconUrl;
  String? get text_body => textBody;
  String? get msg_time => msgTime;
  String? get sent_date => sentDate;
  String? get timestamp_compat => timestamp;
  int? get msg_state => msgState;
  bool? get is_unread => isUnread;
  bool? get is_from_current_user => isFromCurrentUser;
}

/// Forum Copilot Message Result
/// Maps from MessageData_Output
@MappableClass()
class FCMessageResult extends FCBaseResult with FCMessageResultMappable {
  /// Message ID
  String msgId;

  /// Message subject
  String subject;

  /// Message author ID
  String authorId;

  /// Message author name
  String authorName;

  /// Message from (compatibility)
  String? msgFrom;

  /// Message to (compatibility)
  String? msgTo;

  /// Message author avatar URL
  String? iconUrl;

  /// Message content
  String textBody;

  /// Message time
  String msgTime;

  /// Whether message is unread
  bool isUnread;

  /// Whether user can reply
  bool? canReply;

  /// Whether user can forward
  bool? canForward;

  /// Whether user can report
  bool? canReport;

  FCMessageResult({
    required bool result,
    String? resultText,
    required this.msgId,
    required this.subject,
    required this.authorId,
    required this.authorName,
    this.msgFrom,
    this.msgTo,
    this.iconUrl,
    required this.textBody,
    required this.msgTime,
    required this.isUnread,
    this.canReply,
    this.canForward,
    this.canReport,
  }) : super(result: result, resultText: resultText);

  // Compatibility properties for snake_case access
  String? get msg_id => msgId;
  String? get author_id => authorId;
  String? get author_name => authorName;
  String? get msg_from => msgFrom;
  String? get msg_to => msgTo;
  String? get icon_url => iconUrl;
  String? get text_body => textBody;
  String? get msg_time => msgTime;
  bool? get is_unread => isUnread;
  bool? get can_reply => canReply;
  bool? get can_forward => canForward;
  bool? get can_report => canReport;
}

/// Forum Copilot Quote PM Result
/// Maps from QuotePMData_Output
@MappableClass()
class FCQuotePMResult extends FCBaseResult with FCQuotePMResultMappable {
  /// Quoted message content
  String? quoteText;

  /// Original message author
  String? authorName;

  FCQuotePMResult({
    required bool result,
    String? resultText,
    this.quoteText,
    this.authorName,
  }) : super(result: result, resultText: resultText);

  // Compatibility properties for snake_case access
  String? get quote_text => quoteText;
  String? get author_name => authorName;
}

/// Forum Copilot Delete Message Result
/// Maps from DeleteMessageData_Output
@MappableClass()
class FCDeleteMessageResult extends FCBaseResult with FCDeleteMessageResultMappable {
  FCDeleteMessageResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Mark PM Unread Result
/// Maps from MarkPMUnreadData_Output
@MappableClass()
class FCMarkPMUnreadResult extends FCBaseResult with FCMarkPMUnreadResultMappable {
  FCMarkPMUnreadResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Mark PM Read Result
/// Maps from MarkPMReadData_Output
@MappableClass()
class FCMarkPMReadResult extends FCBaseResult with FCMarkPMReadResultMappable {
  FCMarkPMReadResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}
