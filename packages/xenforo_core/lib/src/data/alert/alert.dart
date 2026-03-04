import 'package:dart_mappable/dart_mappable.dart';

part 'alert.mapper.dart';

/// XenForo alert data model
@MappableClass()
class XenForoAlert with XenForoAlertMappable {
  final String id;
  final String alertType;
  final String contentType;
  final String contentId;
  final String userId;
  final String userName;
  final String action;
  final String message;
  final DateTime alertDate;
  final bool isRead;
  final bool isDismissed;
  final Map<String, dynamic> extraData;

  const XenForoAlert({
    required this.id,
    required this.alertType,
    required this.contentType,
    required this.contentId,
    required this.userId,
    required this.userName,
    required this.action,
    required this.message,
    required this.alertDate,
    required this.isRead,
    required this.isDismissed,
    required this.extraData,
  });

  factory XenForoAlert.fromJson(Map<String, dynamic> json) {
    return XenForoAlert(
      id: json['alert_id']?.toString() ?? '',
      alertType: json['alert_type']?.toString() ?? '',
      contentType: json['content_type']?.toString() ?? '',
      contentId: json['content_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      alertDate: DateTime.tryParse(json['alert_date']?.toString() ?? '') ?? DateTime.now(),
      isRead: json['is_read'] == true,
      isDismissed: json['is_dismissed'] == true,
      extraData: json['extra_data'] as Map<String, dynamic>? ?? {},
    );
  }
}
