import '../models/results/fc_social_result.dart';

/// Forum Copilot Social Proxy Interface
///
/// This interface defines the contract for social operations including:
/// - Like/unlike posts
/// - Thank posts
/// - Follow/unfollow users
/// - Get alerts and activities
abstract class IFCSocialProxy {
  /// Send Thank You to a specific post
  ///
  /// [postId] - Post ID to thank
  Future<FCThankPostResult> thankPostAsync(String postId);

  /// Allows user to follow a specific person
  ///
  /// [userId] - User ID to follow
  Future<FCFollowResult> followAsync(String userId);

  /// Allows user to unfollow a specific person
  ///
  /// [userId] - User ID to unfollow
  Future<FCUnfollowResult> unfollowAsync(String userId);

  /// Send Like to a specific post
  ///
  /// [postId] - Post ID to like
  Future<FCLikePostResult> likePostAsync(String postId);

  /// Remove Like from a specific post
  ///
  /// [postId] - Post ID to unlike
  Future<FCUnlikePostResult> unlikePostAsync(String postId);

  /// Send Like to a specific conversation message
  ///
  /// [messageId] - Conversation message ID to like
  Future<FCLikePostResult> likeConversationMessageAsync(String messageId);

  /// Remove Like from a specific conversation message
  ///
  /// [messageId] - Conversation message ID to unlike
  Future<FCUnlikePostResult> unlikeConversationMessageAsync(String messageId);

  /// Get user alerts
  ///
  /// [page] - Page number for pagination
  /// [perpage] - Number of items per page
  /// [forceRefresh] - Whether to force refresh the data
  Future<FCAlertResult> getAlertAsync(int page, int perpage, bool forceRefresh);

  /// Get user activities
  ///
  /// [page] - Page number for pagination
  /// [perpage] - Number of items per page
  Future<FCActivityResult> getActivityAsync(int page, int perpage);
}
