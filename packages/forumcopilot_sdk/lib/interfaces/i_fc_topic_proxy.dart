import '../models/results/fc_topic_result.dart';

/// Interface for topic management operations
/// This interface handles topic creation, retrieval, status tracking, and management
abstract class IFCTopicProxy {
  /// Mark unread topics as read
  ///
  /// [topicIds] Array of topic IDs to mark as read
  Future<FCMarkTopicReadResult> markTopicReadAsync(List<String> topicIds);

  /// Given an array of topic IDs, returns their status including unread status,
  /// number of reply, number of view and so on. A light-weight approach to retrieve
  /// certain information without pulling a list of unwanted data.
  ///
  /// [topicIds] Array of topic IDs to get status for
  Future<FCTopicStatusResult> getTopicStatusAsync(List<String> topicIds);

  /// Post new topic to a particular forum
  ///
  /// [forumId] Forum ID where the topic will be created
  /// [subject] Subject/title of the topic
  /// [textBody] Content/body of the topic
  /// [prefixId] Optional prefix ID for the topic
  /// [attachmentIds] Optional list of attachment IDs
  /// [groupId] Optional group ID for attachments
  Future<FCNewTopicResult> newTopic(String forumId, String subject, String textBody, {String? prefixId, List<String>? attachmentIds, String? groupId});

  /// Returns a list of topics under a specific forum. It can also return sticky topics
  /// and announcement, given the "mode" parameter is provided.
  ///
  /// [forumId] Forum ID to get topics from
  /// [startNum] Starting position for pagination
  /// [lastNum] Ending position for pagination
  /// [mode] Mode for topic retrieval (TOP, ANN, TOPIC)
  Future<FCTopicDataResult> getTopTopicAsync(String forumId, int startNum, int lastNum);

  /// Returns a list of topics under a specific forum. It can also return sticky topics
  /// and announcement, given the "mode" parameter is provided.
  ///
  /// [forumId] Forum ID to get topics from
  /// [startNum] Starting position for pagination
  /// [lastNum] Ending position for pagination
  /// [mode] Mode for topic retrieval (TOP, ANN, TOPIC)
  Future<FCTopicDataResult> getAnnTopicAsync(String forumId, int startNum, int lastNum);

  /// Returns a list of topics under a specific forum. It can also return sticky topics
  /// and announcement, given the "mode" parameter is provided.
  ///
  /// [forumId] Forum ID to get topics from
  /// [startNum] Starting position for pagination
  /// [lastNum] Ending position for pagination
  /// [mode] Mode for topic retrieval (TOP, ANN, TOPIC)
  Future<FCTopicDataResult> getTopicAsync(String forumId, int startNum, int lastNum);

  /// Returns a list of unread topics ordered by date
  ///
  /// [startNum] Starting position for pagination
  /// [lastNum] Ending position for pagination
  /// [searchId] Optional search ID for filtering
  /// [filters] Optional list of filters to apply
  Future<FCUnreadTopicResult> getUnreadTopicAsync(int startNum, int lastNum, {String? searchId, List<String>? filters});

  /// Returns a list of topics that either the user has previously replied to,
  /// or is the original topic creator, ordered by date.
  ///
  /// [username] Username to get participated topics for
  /// [startNum] Starting position for pagination
  /// [lastNum] Ending position for pagination
  /// [searchId] Optional search ID for filtering
  /// [userId] Optional user ID for filtering
  Future<FCParticipatedTopicResult> getParticipatedTopicAsync(String username, int startNum, int lastNum, {String? searchId, String? userId});

  /// Returns a list of latest topics ordered by date. This is the replacement
  /// function of get_new_topic in API Level 3.
  ///
  /// [startNum] Starting position for pagination
  /// [lastNum] Ending position for pagination
  /// [searchId] Optional search ID for filtering
  /// [filters] Optional list of filters to apply
  Future<FCLatestTopicResult> getLatestTopicAsync(int startNum, int lastNum, {String? searchId, List<String>? filters});

  /// Returns a list of latest topics ordered by date. This is the replacement
  /// function of get_new_topic in API Level 3.
  ///
  /// [startNum] Starting position for pagination
  /// [lastNum] Ending position for pagination
  /// [searchId] Optional search ID for filtering
  /// [filters] Optional list of filters to apply
  Future<FCLatestTopicResult> getNewTopicAsync(int startNum, int lastNum, {String? searchId, List<String>? filters});

  /// Returns topics by their IDs
  ///
  /// [topicIds] List of topic IDs to retrieve
  Future<FCTopicByIdsResult> getTopicByIds(List<String> topicIds);
}
