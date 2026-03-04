import '../models/results/fc_passkey_result.dart';
import '../models/results/fc_user_result.dart';
import '../models/results/fc_private_conversation_result.dart';

/// Forum Copilot User Proxy Interface
/// Defines the contract for user-related operations
abstract class IFCUserProxy {
  /// This script allows the app to pass the user id or based64 encoded username
  /// and it returns the user's avatar as an image. Return a 1x1 image if this user has no avatar.
  Future<String> getAvatarAsync(String userId, String username);

  /// Server returns cookies in HTTP header. Client should store the cookies and pass it back
  /// to server for all subsequence calls to maintain user session.
  ///
  /// If TFA is required, first call returns tfaRequired: true with providers list.
  /// Second call should include tfaCode, tfaProvider, and trustDevice: true.
  Future<FCLoginResult> loginAsync(
    String loginname,
    String password,
    bool anonymous,
    String? trustCode, {
    bool remember = true,
    String? tfaCode,
    String? tfaProvider,
    String? webauthnChallenge,
    Map<String, String>? webauthnPayload,
    bool trustDevice = false,
  });

  /// Get passkey challenge for passkey-only authentication
  Future<FCPasskeyChallengeResult> getPasskeyChallengeAsync();

  /// Passkey-only login
  Future<FCLoginResult> loginWithPasskeyAsync({
    required String webauthnChallenge,
    required Map<String, String> webauthnPayload,
  });

  /// Two-step authentication login
  Future<FCLoginTwoStepResult> loginTwoStepAsync(String codeTwoStep, bool trust);

  /// Returns inbox related statistic for the user. In API Level 3 there is no input
  /// parameter need to pass into this function.
  Future<FCInboxStatResult> getInboxStatAsync(DateTime pmLastCheckedTime, DateTime subscribedTopicLastCheckedTime);

  /// Logout user, no input and output required.
  Future<void> logoutUserAsync();

  /// Returns a list of user who are currently online. You can specify forum and thread
  /// to limit the users you need.
  Future<FCOnlineUserResult> getOnlineUsersAsync(int page, int perpage, String? id, String? area);

  /// Returns user related information
  Future<FCUserInfoResult> getUserInfoAsync(String? username, String? userId);

  /// Returns a list of topics (max 50) the user has previously created. Sorted by last reply time
  Future<FCUserTopicResult> getUserTopicAsync(String? username, String? userId);

  /// Returns a list of posts (max. 50) that's a particular user has replied to.
  Future<FCUserReplyResult> getUserReplyPostAsync(int startNum, int lastNum, String? searchId, String? username, String? userId);

  /// Return a list of recommended users for conversation or pm. Flag 'user_recommended'
  /// returned in get_config will indicate the plugin support this function.
  Future<FCRecommendedUserResult> getRecommendedUsersAsync(int page, int perpage, int mode);

  /// Return a list of users by giving key word. Flag 'search_user' returned in get_config
  /// will indicate the plugin support this function.
  Future<FCSearchUserResult> searchUserAsync(String keywords, int page, int perpage);

  /// Add/remove user in your ignored user list. Ignored user's post will be hidden as default
  Future<FCIgnoreUserResult> ignoreUserAsync(String userId, int mode);

  /// Return a list of ignored users
  Future<FCIgnoredUserResult> getIgnoredUsersAsync(int page, int perpage);

  /// Report a user for inappropriate behavior
  /// This function is used to report a problematic user to moderators
  Future<FCReportUserResult> reportUserAsync(String userId, String reason);
}
