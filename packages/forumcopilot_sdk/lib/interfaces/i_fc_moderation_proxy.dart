import '../models/results/fc_moderation_result.dart';

/// Forum Copilot Moderation Proxy Interface
///
/// This interface defines the contract for moderation operations including:
/// - Topic moderation (stick/unstick, close/unclose, delete/undelete, move, rename, merge)
/// - Post moderation (delete/undelete, move, approve)
/// - User moderation (ban/unban, mark as spam)
/// - Moderation queue management (get moderate topics/posts, deleted topics/posts, reported posts)
/// - Moderator authentication
abstract class IFCModerationProxy {
  /// Authenticate as a moderator
  Future<FCLoginModResult> doLoginModAsync(String username, String password);

  /// Stick a topic
  Future<FCStickTopicResult> stickTopicAsync(String topicId);

  /// Unstick a topic
  Future<FCStickTopicResult> unstickTopicAsync(String topicId);

  /// Close a topic
  Future<FCCloseTopicResult> closeTopicAsync(String topicId);

  /// Unclose a topic
  Future<FCCloseTopicResult> uncloseTopicAsync(String topicId);

  /// Delete a topic
  Future<FCDeleteTopicResult> deleteTopicAsync(String topicId, int mode, String reason);

  /// Delete a post
  Future<FCDeletePostResult> deletePostAsync(String postId, int mode, String reason);

  /// Undelete a topic
  Future<FCUndeleteTopicResult> undeleteTopicAsync(String topicId, String reason);

  /// Undelete a post
  Future<FCUndeletePostResult> undeletePostAsync(String postId, String reason);

  /// Move a topic
  Future<FCMoveTopicResult> moveTopicAsync(String topicId, String forumId, bool redirect);

  /// Rename a topic
  Future<FCRenameTopicResult> renameTopicAsync(String topicId, String title);

  /// Move a post
  Future<FCMovePostResult> movePostAsync(String postId, String? topicId, String? topicTitle, String? forumId);

  /// Merge topics
  Future<FCMergeTopicResult> mergeTopicAsync(String topicId1, String topicId2, bool redirect);

  /// Get moderate topics
  Future<FCModerateTopicResult> getModerateTopicAsync(int startNum, int lastNum);

  /// Get moderate posts
  Future<FCModeratePostResult> getModeratePostAsync(int startNum, int lastNum);

  /// Get deleted topics
  Future<FCDeletedTopicResult> getDeletedTopicAsync(int startNum, int lastNum);

  /// Get deleted posts
  Future<FCDeletedPostResult> getDeletedPostAsync(int startNum, int lastNum);

  /// Get reported posts
  Future<FCReportedPostResult> getReportedPostAsync(int startNum, int lastNum);

  /// Approve a topic
  Future<FCApproveTopicResult> approveTopicAsync(String topicId);

  /// Approve a post
  Future<FCApprovePostResult> approvePostAsync(String postId);

  /// Ban a user
  Future<FCBanUserResult> banUserAsync(String userName, String reason, int banExpires, int deletePostMode, int deletePostValue);

  /// Unban a user
  Future<FCUnbanUserResult> unbanUserAsync(String userId);

  /// Mark user as spam
  Future<FCMarkAsSpamResult> markAsSpamAsync(String userId);

  /// Clean spam content from a user account
  Future<FCSpamCleanUserResult> spamCleanUserAsync({
    String? userId,
    String? username,
    bool actionThreads = false,
    bool deleteMessages = false,
    bool deleteConversations = false,
    bool banUser = false,
  });

  /// Toggle a topic's archived state (Discourse-specific:
  /// `PUT /t/{id}/status.json` with `status=archived`).
  /// Stub-fails on backends without an archive concept.
  Future<FCDeleteTopicResult> archiveTopicAsync(
    String topicId, {
    required bool archived,
  });

  /// Toggle a topic's listed/unlisted state (Discourse-specific:
  /// `PUT /t/{id}/status.json` with `status=visible`).
  Future<FCDeleteTopicResult> setTopicVisibilityAsync(
    String topicId, {
    required bool visible,
  });

  /// Extended topic deletion with full parameter support.
  ///
  /// [hardDelete] true deletes permanently (Discourse:
  /// `delete_for_real=true`; XenForo: hard delete), false soft-deletes.
  /// [reason] optional moderator-log reason.
  /// [starterAlert]/[starterAlertReason] notify the topic starter -
  /// XF-flavored; backends without the concept ignore them.
  Future<FCDeleteTopicResult> deleteTopicExtendedAsync(
    String topicId, {
    bool hardDelete = false,
    String? reason,
    bool starterAlert = false,
    String? starterAlertReason,
  });
}
