import '../models/results/fc_forum_result.dart';

/// Interface for forum management operations
/// This interface handles forum structure, statistics, and access control
abstract class IFCForumProxy {
  /// Return full forum in a nested tree structure. In API Level 3 no parameter required
  /// for this function and the sub-forum description. For Level 4, forum description is
  /// omitted unless "return_description" is set to true
  ///
  /// [returnDescription] request to return sub-forum description.
  /// [forumId] if this parameter is presented, return only the immediate child of this forum.
  /// [forceRefresh] force refresh the cache
  Future<FCForumDataResult> getForumAsync(bool returnDescription, String forumId, bool forceRefresh);

  /// Return a list of sub-forum that user has previously participated in,
  /// order by the latest date of participation.
  Future<FCParticipatedForumResult> getParticipatedForumAsync();

  /// Mark all the unread topics as read
  ///
  /// [forumId] Specify the actual sub-forum to be marked as read, instead of marking
  /// the entire board as read. This parameters is only used when "mark_forum=1" returns
  /// in get_config, to indicate the plugin supports marking sub-forum read.
  Future<FCMarkAllAsReadResult> markAllAsRead(String forumId);

  /// Allows mobile client to access password protected sub-forum. It currently support
  /// only sub-forum at leaf level. If the password is valid, also return the updated
  /// cookies so the client will have access to the subsequent get_topic calls
  ///
  /// [forumId] Forum ID to login to
  /// [password] Password for the forum
  Future<FCLoginForumResult> loginForum(String forumId, String password);

  /// This new function is used to extract topic / post ID from a URL so an internal link
  /// can be open in app. Especially in SEO environment it is impossible for the app to
  /// detect the IDs from URL and hence requires server-side assistance. This function is
  /// used in conjunction with get_config that returns get_id_by_url = 1.
  ///
  /// [url] URL to be processed.
  Future<FCIdByUrlResult> getIdByUrl(String url);

  /// This new function is used to extract topic / post ID from a URL so an internal link
  /// can be open in app. Especially in SEO environment it is impossible for the app to
  /// detect the IDs from URL and hence requires server-side assistance. This function is
  /// used in conjunction with get_config that returns get_id_by_url = 1.
  ///
  /// [mode] Type of ID (forum, topic, post)
  /// [id] ID to get URL for
  Future<FCUrlByIdResult> getUrlById(String mode, String id);

  /// Return board basic statistics data
  Future<FCBoardStatResult> getBoardStatAsync();

  /// Return a list of sub-forum that user has previously participated in,
  /// order by the latest date of participation.
  Future<FCForumStatusResult> getForumStatusAsync(List<String> forumIds);
}
