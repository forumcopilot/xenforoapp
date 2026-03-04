import 'dart:io';

/// Test configuration for ForumCopilot SDK interface tests
///
/// This class provides configuration values needed for running tests.
/// Values can be loaded from environment variables or use defaults.
class TestConfig {
  /// Forum ID to use for tests
  String forumId;

  /// Topic ID to use for tests
  String topicId;

  /// Post ID to use for tests
  String postId;

  /// User ID to use for tests
  String userId;

  /// Username for authentication tests
  String username;

  /// Password for authentication tests
  String password;

  /// Moderator username for moderation tests
  String moderatorUsername;

  /// Moderator password for moderation tests
  String moderatorPassword;

  /// Conversation ID for private conversation tests
  String conversationId;

  /// Message ID for private message tests
  String messageId;

  /// Attachment ID for attachment tests
  String attachmentId;

  /// Group ID for attachment tests
  String groupId;

  /// URL for URL conversion tests
  String testUrl;

  /// Forum password for password-protected forum tests
  String forumPassword;

  /// Email address for account tests
  String email;

  /// Token for SSO/registration tests
  String token;

  /// Code for SSO/registration tests
  String code;

  TestConfig({
    required this.forumId,
    required this.topicId,
    required this.postId,
    required this.userId,
    required this.username,
    required this.password,
    required this.moderatorUsername,
    required this.moderatorPassword,
    required this.conversationId,
    required this.messageId,
    required this.attachmentId,
    required this.groupId,
    required this.testUrl,
    required this.forumPassword,
    required this.email,
    required this.token,
    required this.code,
  });

  /// Create TestConfig from environment variables with defaults
  factory TestConfig.fromEnvironment() {
    return TestConfig(
      forumId: Platform.environment['TEST_FORUM_ID'] ?? '1',
      topicId: Platform.environment['TEST_TOPIC_ID'] ?? '1',
      postId: Platform.environment['TEST_POST_ID'] ?? '1',
      userId: Platform.environment['TEST_USER_ID'] ?? '1',
      username: Platform.environment['TEST_USERNAME'] ?? 'testuser',
      password: Platform.environment['TEST_PASSWORD'] ?? 'testpass',
      moderatorUsername: Platform.environment['TEST_MODERATOR_USERNAME'] ?? 'moderator',
      moderatorPassword: Platform.environment['TEST_MODERATOR_PASSWORD'] ?? 'modpass',
      conversationId: Platform.environment['TEST_CONVERSATION_ID'] ?? '1',
      messageId: Platform.environment['TEST_MESSAGE_ID'] ?? '1',
      attachmentId: Platform.environment['TEST_ATTACHMENT_ID'] ?? '1',
      groupId: Platform.environment['TEST_GROUP_ID'] ?? '1',
      testUrl: Platform.environment['TEST_URL'] ?? 'https://example.com/forum/topic/1',
      forumPassword: Platform.environment['TEST_FORUM_PASSWORD'] ?? 'forumpass',
      email: Platform.environment['TEST_EMAIL'] ?? 'test@example.com',
      token: Platform.environment['TEST_TOKEN'] ?? 'testtoken',
      code: Platform.environment['TEST_CODE'] ?? 'testcode',
    );
  }

  /// Validate that required configuration values are set
  bool validate() {
    if (forumId.isEmpty) {
      print('Warning: TEST_FORUM_ID not set, using default');
    }
    if (topicId.isEmpty) {
      print('Warning: TEST_TOPIC_ID not set, using default');
    }
    if (postId.isEmpty) {
      print('Warning: TEST_POST_ID not set, using default');
    }
    if (username.isEmpty) {
      print('Warning: TEST_USERNAME not set, using default');
    }
    if (password.isEmpty) {
      print('Warning: TEST_PASSWORD not set, using default');
    }
    return true;
  }
}
