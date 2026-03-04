import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_moderation_result.mapper.dart';

/// Forum Copilot Login Mod Result
/// Maps from LoginModData_Output
@MappableClass()
class FCLoginModResult extends FCBaseResult with FCLoginModResultMappable {
  FCLoginModResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Stick Topic Result
/// Maps from StickTopicData_Output
@MappableClass()
class FCStickTopicResult extends FCBaseResult with FCStickTopicResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCStickTopicResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Close Topic Result
/// Maps from CloseTopicData_Output
@MappableClass()
class FCCloseTopicResult extends FCBaseResult with FCCloseTopicResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCCloseTopicResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Delete Topic Result
/// Maps from DeleteTopicData_Output
@MappableClass()
class FCDeleteTopicResult extends FCBaseResult with FCDeleteTopicResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCDeleteTopicResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Delete Post Result
/// Maps from DeletePostData_Output
@MappableClass()
class FCDeletePostResult extends FCBaseResult with FCDeletePostResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCDeletePostResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Undelete Topic Result
/// Maps from UndeleteTopicData_Output
@MappableClass()
class FCUndeleteTopicResult extends FCBaseResult with FCUndeleteTopicResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCUndeleteTopicResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Undelete Post Result
/// Maps from UndeletePostData_Output
@MappableClass()
class FCUndeletePostResult extends FCBaseResult with FCUndeletePostResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCUndeletePostResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Move Topic Result
/// Maps from MoveTopicData_Output
@MappableClass()
class FCMoveTopicResult extends FCBaseResult with FCMoveTopicResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCMoveTopicResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Rename Topic Result
/// Maps from RenameTopicData_Output
@MappableClass()
class FCRenameTopicResult extends FCBaseResult with FCRenameTopicResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCRenameTopicResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Move Post Result
/// Maps from MovePostData_Output
@MappableClass()
class FCMovePostResult extends FCBaseResult with FCMovePostResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCMovePostResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Merge Topic Result
/// Maps from MergeTopicData_Output
@MappableClass()
class FCMergeTopicResult extends FCBaseResult with FCMergeTopicResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCMergeTopicResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Moderate Topic Result
/// Maps from ModerateTopicData_Output
@MappableClass()
class FCModerateTopicResult extends FCBaseResult with FCModerateTopicResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  /// Total number of topics
  int total;

  /// List of topics
  List<FCModerateTopic> list;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCModerateTopicResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
    required this.total,
    required this.list,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Moderate Topic
/// Maps from ModerateTopicData_Output_Topic
@MappableClass()
class FCModerateTopic with FCModerateTopicMappable {
  /// Topic ID
  String topicId;

  /// Topic title
  String topicTitle;

  /// Forum ID
  String forumId;

  /// Forum name
  String forumName;

  /// Author ID
  String authorId;

  /// Author name
  String authorName;

  /// Post time
  DateTime postTime;

  /// Reply count
  int replyCount;

  /// View count
  int viewCount;

  /// Short content
  String? shortContent;

  FCModerateTopic({
    required this.topicId,
    required this.topicTitle,
    required this.forumId,
    required this.forumName,
    required this.authorId,
    required this.authorName,
    required this.postTime,
    required this.replyCount,
    required this.viewCount,
    this.shortContent,
  });

  // Compatibility properties for snake_case access
  String? get topic_id => topicId;
  String? get topic_title => topicTitle;
  String? get forum_id => forumId;
  String? get forum_name => forumName;
  String? get author_id => authorId;
  String? get author_name => authorName;
  DateTime? get post_time => postTime;
  int? get reply_count => replyCount;
  int? get view_count => viewCount;
  String? get short_content => shortContent;
}

/// Forum Copilot Moderate Post Result
/// Maps from ModeratePostData_Output
@MappableClass()
class FCModeratePostResult extends FCBaseResult with FCModeratePostResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  /// Total number of posts
  int total;

  /// List of posts
  List<FCModeratePost> list;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCModeratePostResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
    required this.total,
    required this.list,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Moderate Post
/// Maps from ModeratePostData_Output_Post
@MappableClass()
class FCModeratePost with FCModeratePostMappable {
  /// Post ID
  String postId;

  /// Post title
  String? postTitle;

  /// Topic ID
  String topicId;

  /// Topic title
  String topicTitle;

  /// Forum ID
  String forumId;

  /// Forum name
  String forumName;

  /// Author ID
  String authorId;

  /// Author name
  String authorName;

  /// Post time
  DateTime postTime;

  /// Post content
  String? postContent;

  FCModeratePost({
    required this.postId,
    this.postTitle,
    required this.topicId,
    required this.topicTitle,
    required this.forumId,
    required this.forumName,
    required this.authorId,
    required this.authorName,
    required this.postTime,
    this.postContent,
  });

  // Compatibility properties for snake_case access
  String? get post_id => postId;
  String? get post_title => postTitle;
  String? get topic_id => topicId;
  String? get topic_title => topicTitle;
  String? get forum_id => forumId;
  String? get forum_name => forumName;
  String? get author_id => authorId;
  String? get author_name => authorName;
  DateTime? get post_time => postTime;
  String? get post_content => postContent;
}

/// Forum Copilot Deleted Topic Result
/// Maps from DeletedTopicData_Output
@MappableClass()
class FCDeletedTopicResult extends FCBaseResult with FCDeletedTopicResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  /// Total number of topics
  int total;

  /// List of topics
  List<FCDeletedTopic> list;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCDeletedTopicResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
    required this.total,
    required this.list,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Deleted Topic
/// Maps from DeletedTopicData_Output_Topic
@MappableClass()
class FCDeletedTopic with FCDeletedTopicMappable {
  /// Topic ID
  String topicId;

  /// Topic title
  String topicTitle;

  /// Forum ID
  String forumId;

  /// Forum name
  String forumName;

  /// Author ID
  String authorId;

  /// Author name
  String authorName;

  /// Post time
  DateTime postTime;

  /// Reply count
  int replyCount;

  /// View count
  int viewCount;

  /// Short content
  String? shortContent;

  FCDeletedTopic({
    required this.topicId,
    required this.topicTitle,
    required this.forumId,
    required this.forumName,
    required this.authorId,
    required this.authorName,
    required this.postTime,
    required this.replyCount,
    required this.viewCount,
    this.shortContent,
  });

  // Compatibility properties for snake_case access
  String? get topic_id => topicId;
  String? get topic_title => topicTitle;
  String? get forum_id => forumId;
  String? get forum_name => forumName;
  String? get author_id => authorId;
  String? get author_name => authorName;
  DateTime? get post_time => postTime;
  int? get reply_count => replyCount;
  int? get view_count => viewCount;
  String? get short_content => shortContent;
}

/// Forum Copilot Deleted Post Result
/// Maps from DeletedPostData_Output
@MappableClass()
class FCDeletedPostResult extends FCBaseResult with FCDeletedPostResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  /// Total number of posts
  int total;

  /// List of posts
  List<FCDeletedPost> list;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCDeletedPostResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
    required this.total,
    required this.list,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Deleted Post
/// Maps from DeletedPostData_Output_Post
@MappableClass()
class FCDeletedPost with FCDeletedPostMappable {
  /// Post ID
  String postId;

  /// Post title
  String? postTitle;

  /// Topic ID
  String topicId;

  /// Topic title
  String topicTitle;

  /// Forum ID
  String forumId;

  /// Forum name
  String forumName;

  /// Author ID
  String authorId;

  /// Author name
  String authorName;

  /// Post time
  DateTime postTime;

  /// Post content
  String? postContent;

  FCDeletedPost({
    required this.postId,
    this.postTitle,
    required this.topicId,
    required this.topicTitle,
    required this.forumId,
    required this.forumName,
    required this.authorId,
    required this.authorName,
    required this.postTime,
    this.postContent,
  });

  // Compatibility properties for snake_case access
  String? get post_id => postId;
  String? get post_title => postTitle;
  String? get topic_id => topicId;
  String? get topic_title => topicTitle;
  String? get forum_id => forumId;
  String? get forum_name => forumName;
  String? get author_id => authorId;
  String? get author_name => authorName;
  DateTime? get post_time => postTime;
  String? get post_content => postContent;
}

/// Forum Copilot Reported Post Result
/// Maps from ReportedPostData_Output
@MappableClass()
class FCReportedPostResult extends FCBaseResult with FCReportedPostResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  /// Total number of posts
  int total;

  /// List of posts
  List<FCReportedPost> list;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCReportedPostResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
    required this.total,
    required this.list,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Reported Post
/// Maps from ReportedPostData_Output_Post
@MappableClass()
class FCReportedPost with FCReportedPostMappable {
  /// Post ID
  String postId;

  /// Post title
  String? postTitle;

  /// Topic ID
  String topicId;

  /// Topic title
  String topicTitle;

  /// Forum ID
  String forumId;

  /// Forum name
  String forumName;

  /// Author ID
  String authorId;

  /// Author name
  String authorName;

  /// Post time
  DateTime postTime;

  /// Post content
  String? postContent;

  /// Report reason
  String? reportReason;

  /// Reporter ID
  String? reporterId;

  /// Reporter name
  String? reporterName;

  /// Report time
  DateTime? reportTime;

  FCReportedPost({
    required this.postId,
    this.postTitle,
    required this.topicId,
    required this.topicTitle,
    required this.forumId,
    required this.forumName,
    required this.authorId,
    required this.authorName,
    required this.postTime,
    this.postContent,
    this.reportReason,
    this.reporterId,
    this.reporterName,
    this.reportTime,
  });

  // Compatibility properties for snake_case access
  String? get post_id => postId;
  String? get post_title => postTitle;
  String? get topic_id => topicId;
  String? get topic_title => topicTitle;
  String? get forum_id => forumId;
  String? get forum_name => forumName;
  String? get author_id => authorId;
  String? get author_name => authorName;
  DateTime? get post_time => postTime;
  String? get post_content => postContent;
  String? get report_reason => reportReason;
  String? get reporter_id => reporterId;
  String? get reporter_name => reporterName;
  DateTime? get report_time => reportTime;
}

/// Forum Copilot Approve Topic Result
/// Maps from ApproveTopicData_Output
@MappableClass()
class FCApproveTopicResult extends FCBaseResult with FCApproveTopicResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCApproveTopicResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Approve Post Result
/// Maps from ApprovePostData_Output
@MappableClass()
class FCApprovePostResult extends FCBaseResult with FCApprovePostResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCApprovePostResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Ban User Result
/// Maps from BanUserData_Output
@MappableClass()
class FCBanUserResult extends FCBaseResult with FCBanUserResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCBanUserResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Unban User Result
/// Maps from UnbanUserData_Output
@MappableClass()
class FCUnbanUserResult extends FCBaseResult with FCUnbanUserResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCUnbanUserResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Mark As Spam Result
/// Maps from MarkAsSpamData_Output
@MappableClass()
class FCMarkAsSpamResult extends FCBaseResult with FCMarkAsSpamResultMappable {
  /// Whether login as moderator is required
  bool isLoginMod;

  // Compatibility properties for snake_case access
  bool get is_login_mod => isLoginMod;

  FCMarkAsSpamResult({
    required bool result,
    String? resultText,
    this.isLoginMod = true,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Spam Clean User Result
/// Maps from SpamCleanUserData_Output
@MappableClass()
class FCSpamCleanUserResult extends FCBaseResult with FCSpamCleanUserResultMappable {
  /// User ID that was cleaned
  String? userId;

  /// Username that was cleaned
  String? username;

  /// Actions that were performed
  Map<String, bool>? actions;

  FCSpamCleanUserResult({
    required bool result,
    String? resultText,
    this.userId,
    this.username,
    this.actions,
  }) : super(result: result, resultText: resultText);
}