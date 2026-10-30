import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/entities/fc_topic.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_topic_result.mapper.dart';

/// Forum Copilot Topic Data Result
/// Maps from TopicData_Output
@MappableClass()
class FCTopicDataResult extends FCBaseResult with FCTopicDataResultMappable {
  /// Total number of topics in this forum
  int totalTopicNum;

  /// Forum ID
  String forumId;

  /// Forum name
  String forumName;

  /// Return false if user cannot create new topic in this forum
  bool canPost;

  /// Return false if user cannot upload files in this forum
  bool canUpload;

  /// Count of unread sticky topics
  int unreadStickyCount;

  /// Count of unread announcement topics
  int unreadAnnounceCount;

  /// Return true if current user can subscribe to this forum
  bool canSubscribe;

  /// Return true if this forum was subscribed by current user
  bool isSubscribed;

  /// Whether prefix selection is mandatory
  bool requirePrefix;

  /// List of available prefixes for this forum
  List<FCPrefix> prefixes;

  /// List of topics in this forum
  List<FCTopic> topics;

  /// How the list can be sorted (key, and the forum's own title for it);
  /// null from older add-ons (XenForo add-on 1.11.0+, as are the fields
  /// below), which can't sort or filter.
  List<FCSortOption>? sortOptions;

  /// The forum's own order (a sort option key) and direction.
  String? defaultOrder;
  String? defaultDirection;

  /// The "Last updated" choices, in days (-1: any time).
  List<int>? dateLimitOptions;

  /// The date limit in effect, in days; 0 for none.
  int? dateLimitDays;

  /// The filters the forum applied, by getTopic param name (it leaves out
  /// those that don't apply, as the website does).
  Map<String, dynamic>? appliedFilters;

  // Compatibility properties for snake_case access
  int get total_topic_num => totalTopicNum;

  FCTopicDataResult({
    required bool result,
    required String resultText,
    required this.totalTopicNum,
    this.forumId = "",
    this.forumName = "",
    this.canPost = false,
    this.canUpload = false,
    this.unreadStickyCount = 0,
    this.unreadAnnounceCount = 0,
    this.canSubscribe = false,
    this.isSubscribed = false,
    this.requirePrefix = false,
    this.prefixes = const [],
    this.topics = const [],
    this.sortOptions,
    this.defaultOrder,
    this.defaultDirection,
    this.dateLimitOptions,
    this.dateLimitDays,
    this.appliedFilters,
  }) : super(result: result, resultText: resultText);
}

/// One way a thread list can be sorted.
@MappableClass()
class FCSortOption with FCSortOptionMappable {
  /// What getTopic takes as `order`.
  final String key;

  /// The forum's own name for it.
  final String title;

  const FCSortOption({required this.key, required this.title});
}

/// Forum Copilot Prefix
/// Maps from Prefix
@MappableClass()
class FCPrefix with FCPrefixMappable {
  /// Prefix ID
  String prefixId;

  /// Display name for the prefix
  String prefixDisplayName;

  /// The prefix's group, as the website lists them (add-on 1.11.0+).
  String? group;

  FCPrefix({
    required this.prefixId,
    required this.prefixDisplayName,
    this.group,
  });
}

/// Forum Copilot New Topic Result
/// Maps from NewTopicData_Output
@MappableClass()
class FCNewTopicResult extends FCBaseResult with FCNewTopicResultMappable {
  /// The newly generated topic ID for this new topic
  String topicId;

  /// 1 = post is success but need moderation. Otherwise no need to return this key
  int state;

  FCNewTopicResult({
    required bool result,
    String? resultText,
    required this.topicId,
    this.state = 0,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Mark Topic Read Result
/// Maps from MarkTopicReadData_Output
@MappableClass()
class FCMarkTopicReadResult extends FCBaseResult with FCMarkTopicReadResultMappable {
  FCMarkTopicReadResult({
    required bool result,
    String? resultText,
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Topic Status Result
/// Maps from TopicStatusData_Output
@MappableClass()
class FCTopicStatusResult extends FCBaseResult with FCTopicStatusResultMappable {
  /// List of topic statuses
  List<FCTopicStatus> topics;

  FCTopicStatusResult({
    required bool result,
    String? resultText,
    this.topics = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Topic Status
/// Maps from TopicStatus
@MappableClass()
class FCTopicStatus with FCTopicStatusMappable {
  /// Topic ID
  String topicId;

  /// Whether the topic has new posts
  bool newPost;

  /// Number of replies
  int replyNumber;

  /// Number of views
  int viewNumber;

  /// Whether the topic is closed
  bool isClosed;

  /// Whether the topic is subscribed
  bool isSubscribed;

  /// Whether the topic can be subscribed
  bool canSubscribe;

  /// Last reply time
  DateTime? lastReplyTime;

  /// Unix timestamp
  String? timestamp;

  FCTopicStatus({
    required this.topicId,
    required this.newPost,
    required this.replyNumber,
    required this.viewNumber,
    required this.isClosed,
    required this.isSubscribed,
    required this.canSubscribe,
    this.lastReplyTime,
    this.timestamp,
  });
}

/// Forum Copilot Unread Topic Result
/// Maps from UnreadTopicData_Output
@MappableClass()
class FCUnreadTopicResult extends FCBaseResult with FCUnreadTopicResultMappable {
  /// Total number of unread topics
  int totalUnreadNum;

  /// List of unread topics
  List<FCTopic> topics;

  // Compatibility properties for snake_case access
  int get total_topic_num => totalUnreadNum;

  FCUnreadTopicResult({
    required bool result,
    String? resultText,
    required this.totalUnreadNum,
    this.topics = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Participated Topic Result
/// Maps from ParticipatedTopicData_Output
@MappableClass()
class FCParticipatedTopicResult extends FCBaseResult with FCParticipatedTopicResultMappable {
  /// Total number of participated topics
  int totalParticipatedNum;

  /// List of participated topics
  List<FCTopic> topics;

  // Compatibility properties for snake_case access
  int get total_topic_num => totalParticipatedNum;

  FCParticipatedTopicResult({
    required bool result,
    String? resultText,
    required this.totalParticipatedNum,
    this.topics = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Latest Topic Result
/// Maps from LatestTopicData_Output
@MappableClass()
class FCLatestTopicResult extends FCBaseResult with FCLatestTopicResultMappable {
  /// Total number of latest topics
  int totalLatestNum;

  /// List of latest topics
  List<FCTopic> topics;

  // Compatibility properties for snake_case access
  int get total_topic_num => totalLatestNum;

  FCLatestTopicResult({
    required bool result,
    String? resultText,
    required this.totalLatestNum,
    this.topics = const [],
  }) : super(result: result, resultText: resultText);
}

/// Forum Copilot Topic By IDs Result
/// Maps from TopicByIdsData_Output
@MappableClass()
class FCTopicByIdsResult extends FCBaseResult with FCTopicByIdsResultMappable {
  /// List of topics by IDs
  List<FCTopic> topics;

  FCTopicByIdsResult({
    required bool result,
    String? resultText,
    this.topics = const [],
  }) : super(result: result, resultText: resultText);
}
