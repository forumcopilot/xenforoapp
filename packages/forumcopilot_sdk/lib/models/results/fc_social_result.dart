import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_social_result.mapper.dart';

/// Forum Copilot Thank Post Result
/// Maps from ThankPostData_Output
@MappableClass()
class FCThankPostResult extends FCBaseResult with FCThankPostResultMappable {
  FCThankPostResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Follow Result
/// Maps from FollowData_Output
@MappableClass()
class FCFollowResult extends FCBaseResult with FCFollowResultMappable {
  FCFollowResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Unfollow Result
/// Maps from UnfollowData_Output
@MappableClass()
class FCUnfollowResult extends FCBaseResult with FCUnfollowResultMappable {
  FCUnfollowResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Like Post Result
/// Maps from LikePostData_Output
@MappableClass()
class FCLikePostResult extends FCBaseResult with FCLikePostResultMappable {
  /// Whether the message/post is now liked by the current user
  bool isLiked;
  
  /// Updated total like count
  int likeCount;

  FCLikePostResult({
    required bool result,
    String? resultText,
    this.isLiked = false,
    this.likeCount = 0,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Unlike Post Result
/// Maps from UnlikePostData_Output
@MappableClass()
class FCUnlikePostResult extends FCBaseResult with FCUnlikePostResultMappable {
  /// Whether the message/post is now liked by the current user (should be false after unlike)
  bool isLiked;
  
  /// Updated total like count
  int likeCount;

  FCUnlikePostResult({
    required bool result,
    String? resultText,
    this.isLiked = false,
    this.likeCount = 0,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Alert Result
/// Maps from AlertData_Output
@MappableClass()
class FCAlertResult extends FCBaseResult with FCAlertResultMappable {
  /// Total number of alerts
  int total;

  /// List of alerts
  List<FCAlert> items;

  FCAlertResult({
    required bool result,
    String? resultText,
    required this.total,
    required this.items,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Alert
/// Maps from Alert
@MappableClass()
class FCAlert with FCAlertMappable {
  /// Id of user who triggered this alert
  String userId;

  /// Name of user who triggered this alert
  String username;

  /// Avatar url of user who triggered this alert
  String iconUrl;

  /// Alert message
  String message;

  /// Timestamp of alert trigger time
  String timestamp;

  /// Alert type
  String contentType;

  /// Id of the alert content
  String contentId;

  /// Topic/thread id related to this alert
  String? topicId;

  /// For conversation only, indicate the position of the new message in conversation
  int? position;

  /// Post ID for post type notifications
  String? postId;

  /// Conversation ID for conversation_message type notifications
  String? conversationId;

  /// Action URL for opening in webview
  String? actionUrl;

  /// From username (for user type notifications)
  String? fromUsername;

  /// Action type (e.g., "insert", "mention", "reaction", "quote")
  String? action;

  FCAlert({
    required this.userId,
    required this.username,
    required this.iconUrl,
    required this.message,
    required this.timestamp,
    required this.contentType,
    required this.contentId,
    this.topicId,
    this.position,
    this.postId,
    this.conversationId,
    this.actionUrl,
    this.fromUsername,
    this.action,
  });

  // Compatibility properties for snake_case access
  String? get user_id => userId;
  String? get icon_url => iconUrl;
  String? get content_type => contentType;
  String? get content_id => contentId;
  String? get topic_id => topicId;
}

/// Forum Copilot Activity Result
/// Maps from ActivityData_Output
@MappableClass()
class FCActivityResult extends FCBaseResult with FCActivityResultMappable {
  /// Total number of activities
  int total;

  /// List of activities
  List<FCActivity> items;

  FCActivityResult({
    required bool result,
    String? resultText,
    required this.total,
    required this.items,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Activity
/// Maps from Activity
@MappableClass()
class FCActivity with FCActivityMappable {
  /// Id of user who triggered this activity
  String userId;

  /// Name of user who triggered this activity
  String username;

  /// Avatar url of user who triggered this activity
  String iconUrl;

  /// Activity message
  String message;

  /// Timestamp of activity trigger time
  String timestamp;

  /// Activity type
  String contentType;

  /// Id of the activity content
  String contentId;

  /// Topic/thread id related to this activity
  String? topicId;

  FCActivity({
    required this.userId,
    required this.username,
    required this.iconUrl,
    required this.message,
    required this.timestamp,
    required this.contentType,
    required this.contentId,
    this.topicId,
  });

  // Compatibility properties for snake_case access
  String? get user_id => userId;
  String? get icon_url => iconUrl;
  String? get content_type => contentType;
  String? get content_id => contentId;
  String? get topic_id => topicId;
}
