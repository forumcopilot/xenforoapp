import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_forum_result.mapper.dart';

/// Forum Copilot Forum Data Result
/// Maps from ForumData_Output
@MappableClass()
class FCForumDataResult extends FCBaseResult with FCForumDataResultMappable {
  /// If this forum is not a "leaf" forum, returns a list of child forum in an array of hash. This "child" key should return an array of hash. This entire structure can be nested. Client assume this is a leaf forum if this key is missing from the response
  List<FCForum> forums;

  FCForumDataResult({
    required bool result,
    required String resultText,
    this.forums = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Board Statistics Result
/// Maps from BoardStatData_Output
@MappableClass()
class FCBoardStatResult extends FCBaseResult with FCBoardStatResultMappable {
  /// Total number of threads
  int totalThreads;

  /// Total number of posts
  int totalPosts;

  /// Total number of members
  int totalMembers;

  /// Number of active members
  int activeMembers;

  /// Total number of online users
  int totalOnline;

  /// Number of guests online
  int guestOnline;

  FCBoardStatResult({
    required bool result,
    required String resultText,
    this.totalThreads = 0,
    this.totalPosts = 0,
    this.totalMembers = 0,
    this.activeMembers = 0,
    this.totalOnline = 0,
    this.guestOnline = 0,
  }) : super(result: result, resultText: resultText);

  // Compatibility properties for snake_case access
  int? get total_posts => totalPosts;
  int? get total_members => totalMembers;
}

/// Forum Copilot Participated Forum Result
/// Maps from ParticipatedForumData_Output
@MappableClass()
class FCParticipatedForumResult extends FCBaseResult with FCParticipatedForumResultMappable {
  /// List of participated forums
  List<FCForum> forums;

  FCParticipatedForumResult({
    required bool result,
    required String resultText,
    this.forums = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Mark All As Read Result
/// Maps from MarkAllAsReadData_Output
@MappableClass()
class FCMarkAllAsReadResult extends FCBaseResult with FCMarkAllAsReadResultMappable {
  FCMarkAllAsReadResult({
    required bool result,
    required String resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Login Forum Result
/// Maps from LoginForumData_Output
@MappableClass()
class FCLoginForumResult extends FCBaseResult with FCLoginForumResultMappable {
  /// Updated cookies for access
  String? cookies;

  FCLoginForumResult({
    required bool result,
    required String resultText,
    this.cookies,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot ID By URL Result
/// Maps from IdByUrlData_Output
@MappableClass()
class FCIdByUrlResult extends FCBaseResult with FCIdByUrlResultMappable {
  /// Extracted topic ID
  String? topicId;

  /// Extracted post ID
  String? postId;

  /// Extracted forum ID
  String? forumId;

  FCIdByUrlResult({
    required bool result,
    required String resultText,
    this.topicId,
    this.postId,
    this.forumId,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot URL By ID Result
/// Maps from UrlByIdData_Output
@MappableClass()
class FCUrlByIdResult extends FCBaseResult with FCUrlByIdResultMappable {
  /// Generated URL
  String? url;

  FCUrlByIdResult({
    required bool result,
    required String resultText,
    this.url,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Forum Status Result
/// Maps from ForumStatusData_Output
@MappableClass()
class FCForumStatusResult extends FCBaseResult with FCForumStatusResultMappable {
  /// List of forum statuses
  List<FCForum> forums;

  FCForumStatusResult({
    required bool result,
    required String resultText,
    this.forums = const [],
  }) : super(result: result, resultText: resultText);
}
