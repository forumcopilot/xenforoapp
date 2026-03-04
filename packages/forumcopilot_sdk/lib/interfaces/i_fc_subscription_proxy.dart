import '../models/results/fc_subscription_result.dart';

/// Forum Copilot Subscription Proxy Interface
/// Defines the contract for subscription-related operations
abstract class IFCSubscriptionProxy {
  /// Return a list of subscribed forums
  Future<FCSubscribedForumResult> getSubscribedForumAsync();

  /// Add a forum into the user forum subscription list
  ///
  /// [forumId] Forum id of the forum to be subscribed. In api level 4: if forum id is 'ALL',
  /// update all subscribed forums to new subscribed mode in parameter 2
  ///
  /// [subscribeMode] Notification Type(sample for vb): 0 = no email notification(Or Through my control panel only)
  /// 2 = Daily updates by email 3 = Weekly updates by email
  Future<FCSubscribeForumResult> subscribeForumAsync(String forumId, int subscribeMode);

  /// Remove a forum from the user forum subscription list
  ///
  /// [forumId] Forum id of the forum to be unsubscribed. In api level 4: if forum id is 'ALL',
  /// unsubscribe all forums
  Future<FCUnsubscribeForumResult> unsubscribeForumAsync(String forumId);

  /// Return a list of subscribed topics
  ///
  /// [startNum] For pagination. If start_num = 0 & last_num = 9, it returns first 10 posts from the topic,
  /// sorted by date (last-in-first-out). If both are not presented, return first 20 posts.
  /// if start_num = 0 and last_num = 0, return the first post only, and so on (e.g. 1,1; 2,2).
  /// If start_num smaller than last_num returns null. If last_num - start_num > 50, returns only
  /// first 50 posts starting from start_num
  ///
  /// [lastNum] See startNum description
  Future<FCSubscribedTopicResult> getSubscribedTopicAsync(int startNum, int lastNum);

  /// Add a topic into the user forum subscription list
  ///
  /// [topicId] Topic id of the forum to be subscribed. In api level 4: if topic id is 'ALL',
  /// update all subscribed topics to new subscribed mode in parameter 2
  ///
  /// [subscribeMode] Notification Type(sample for vb): 0 = no email notification(Or Through my control panel only)
  /// 1 = Instant notification by email 2 = Daily updates by email 3 = Weekly updates by email
  Future<FCSubscribeTopicResult> subscribeTopicAsync(String topicId, int subscribeMode);

  /// Remove a topic from the user topic subscription list
  ///
  /// [topicId] Topic id of the topic to be unsubscribed. In api level 4: if topic id is 'ALL',
  /// unsubscribe all topics
  Future<FCUnsubscribeTopicResult> unsubscribeTopicAsync(String topicId);
}
