import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/entities/fc_topic.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_search_result.mapper.dart';

/// Forum Copilot Search Topic Result
/// Maps from SearchTopicData_Output
@MappableClass()
class FCSearchTopicResult extends FCBaseResult with FCSearchTopicResultMappable {
  /// Total number of topics found
  int totalTopicNum;

  /// Search ID for pagination support
  String? searchId;

  /// List of topics
  List<FCTopic> topics;

  // Compatibility properties for snake_case access
  int? get total_topic_num => totalTopicNum;
  String? get search_id => searchId;

  FCSearchTopicResult({
    required bool result,
    String? resultText,
    required this.totalTopicNum,
    this.searchId,
    required this.topics,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Search Post Result
/// Maps from SearchPostData_Output
@MappableClass()
class FCSearchPostResult extends FCBaseResult with FCSearchPostResultMappable {
  /// Total number of posts found
  int totalPostNum;

  /// Search ID for pagination support
  String? searchId;

  /// List of posts
  List<FCPost> posts;

  // Compatibility properties for snake_case access
  int? get total_post_num => totalPostNum;
  String? get search_id => searchId;

  FCSearchPostResult({
    required bool result,
    String? resultText,
    required this.totalPostNum,
    this.searchId,
    required this.posts,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Search Data Result Post
/// Maps from SearchData_OutputPost
@MappableClass()
class FCSearchDataResultPost extends FCBaseResult with FCSearchDataResultPostMappable {
  /// Total number of posts found
  int totalPostNum;

  /// Search ID for pagination support
  String? searchId;

  /// List of posts
  List<FCPost> posts;

  // Compatibility properties for snake_case access
  int? get total_post_num => totalPostNum;
  String? get search_id => searchId;

  FCSearchDataResultPost({
    required bool result,
    String? resultText,
    required this.totalPostNum,
    this.searchId,
    required this.posts,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Search Data Result Topic
/// Maps from SearchData_OutputTopic
@MappableClass()
class FCSearchDataResultTopic extends FCBaseResult with FCSearchDataResultTopicMappable {
  /// Total number of topics found
  int totalTopicNum;

  /// Search ID for pagination support
  String? searchId;

  /// List of topics
  List<FCTopic> topics;

  // Compatibility properties for snake_case access
  int? get total_topic_num => totalTopicNum;
  String? get search_id => searchId;

  FCSearchDataResultTopic({
    required bool result,
    String? resultText,
    required this.totalTopicNum,
    this.searchId,
    required this.topics,
  }) : super(result: result, resultText: resultText);
}
