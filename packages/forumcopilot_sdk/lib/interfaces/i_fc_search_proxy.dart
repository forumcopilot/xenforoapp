import '../models/results/fc_search_result.dart';

/// Forum Copilot Search Proxy Interface
///
/// This interface defines the contract for search operations including:
/// - Simple topic search
/// - Simple post search
/// - Advanced topic search
/// - Advanced post search
abstract class IFCSearchProxy {
  /// Simple search for topics
  ///
  /// [searchString] - query string. At least 3 characters to start the search. If search_id is provide, this parameter will be ignored.
  /// [startNum] - For pagination. If start_num = 0 & last_num = 9, it returns first 10 posts from the topic, sorted by date. If both are not presented, return first 20 posts
  /// [lastNum] - Last number for pagination
  /// [searchId] - for caching and for pagination support. If the previous response contains "search_id" key, you can pass it for subsequent pagination call
  Future<FCSearchTopicResult> searchTopicAsync(String searchString, int startNum, int lastNum, String? searchId);

  /// Simple search for posts
  ///
  /// [searchString] - query string. At least 3 characters to start the search. If search_id is provide, this parameter will be ignored.
  /// [startNum] - For pagination. If start_num = 0 & last_num = 9, returns first 10 posts, sorted by date. If both are not presented, return first 20 posts
  /// [lastNum] - Last number for pagination
  /// [searchId] - for caching and for pagination support
  Future<FCSearchPostResult> searchPostAsync(String searchString, int startNum, int lastNum, String? searchId);

  /// Advanced search for posts
  ///
  /// [keywords] - The key words we want to search.
  /// [page] - The page number of search result you need. Default will return page 1
  /// [perpage] - Topic/Posts perpage. Default is 20.
  /// [searchId] - For pagenation feature. If this key was specified, all below keys will be ignored, except 'page' and 'perpage'
  /// [titleOnly] - seach title only?
  /// [userId] - search content posted by user with user id
  /// [searchUser] - earch content posted by user with user name
  /// [forumId] - search only in forum with forumid
  /// [topicId] - search only in thread with threadid
  /// [onlyIn] - Array of forum id, the search result must be in these forums
  /// [notIn] - Array of forum id, the search result must not be in these forums
  /// [startedBy] - seach started_by only?
  Future<FCSearchDataResultPost> advanceSearchPostAsync(
    String keywords,
    int page,
    int perpage,
    String? searchId,
    bool titleOnly,
    String? userId,
    String? searchUser,
    String? forumId,
    String? topicId,
    List<String>? onlyIn,
    List<String>? notIn,
    bool startedBy,
  );

  /// Advanced search for topics
  ///
  /// [keywords] - The key words we want to search.
  /// [page] - The page number of search result you need. Default will return page 1
  /// [perpage] - Topic/Posts perpage. Default is 20.
  /// [searchId] - For pagenation feature. If this key was specified, all below keys will be ignored, except 'page' and 'perpage'
  /// [titleOnly] - seach title only?
  /// [userId] - search content posted by user with user id
  /// [searchUser] - earch content posted by user with user name
  /// [forumId] - search only in forum with forumid
  /// [topicId] - search only in thread with threadid
  /// [onlyIn] - Array of forum id, the search result must be in these forums
  /// [notIn] - Array of forum id, the search result must not be in these forums
  /// [startedBy] - seach started_by only?
  /// [searchTime] - Search topic/post replied or posted in [searchtime] seconds
  Future<FCSearchDataResultTopic> advanceSearchTopicAsync(
    String keywords,
    int page,
    int perpage,
    String? searchId,
    bool titleOnly,
    String? userId,
    String? searchUser,
    String? forumId,
    String? topicId,
    List<String>? onlyIn,
    List<String>? notIn,
    bool startedBy,
    int? searchTime,
  );
}
