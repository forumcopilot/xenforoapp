import 'dart:io';

/// Test configuration for ForumCopilot SDK interface tests
///
/// This class provides configuration values needed for running tests.
/// Values can be loaded from environment variables or use defaults.
class TestConfig {
  /// Forum ID to use for tests
  String forumId;

  /// Password-protected forum ID to use for loginForum tests
  String passwordProtectedForumId;

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

  /// Second username for dual-user conversation tests (optional)
  String? secondUsername;

  /// Second password for dual-user conversation tests (optional)
  String? secondPassword;

  /// Moderator username for moderation tests (optional)
  String? moderatorUsername;

  /// Moderator password for moderation tests (optional)
  String? moderatorPassword;

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

  /// Token for SSO/registration tests (optional)
  String? token;

  /// Code for SSO/registration tests (optional)
  String? code;

  /// Private messaging type: "conversations" or "private_messages"
  /// Determines which private messaging tests to run
  /// A forum cannot implement both systems - it must be one or the other
  String privateMessagingType;

  /// Whether user authentication was successful (set after login attempt)
  bool isAuthenticated;

  /// Post ID that can receive "like" (empty if not supported)
  String likePostId;

  /// Post ID that can receive "thank" (empty if not supported)
  String thankPostId;

  TestConfig({
    required this.forumId,
    required this.passwordProtectedForumId,
    required this.topicId,
    required this.postId,
    required this.userId,
    required this.username,
    required this.password,
    this.secondUsername,
    this.secondPassword,
    this.moderatorUsername,
    this.moderatorPassword,
    required this.conversationId,
    required this.messageId,
    required this.attachmentId,
    required this.groupId,
    required this.testUrl,
    required this.forumPassword,
    required this.email,
    this.token,
    this.code,
    this.privateMessagingType = 'conversations',
    this.isAuthenticated = false,
    this.likePostId = '',
    this.thankPostId = '',
  });

  /// Create TestConfig from environment variables with defaults
  factory TestConfig.fromEnvironment() {
    return TestConfig(
      forumId: Platform.environment['TEST_FORUM_ID'] ?? '1',
      passwordProtectedForumId: Platform.environment['TEST_PASSWORD_PROTECTED_FORUM_ID'] ?? '7',
      topicId: Platform.environment['TEST_TOPIC_ID'] ?? '1',
      postId: Platform.environment['TEST_POST_ID'] ?? '1',
      userId: Platform.environment['TEST_USER_ID'] ?? '1',
      username: Platform.environment['TEST_USERNAME'] ?? 'testuser',
      password: Platform.environment['TEST_PASSWORD'] ?? 'testpass',
      secondUsername: Platform.environment['TEST_SECOND_USERNAME'],
      secondPassword: Platform.environment['TEST_SECOND_PASSWORD'],
      moderatorUsername: Platform.environment['TEST_MODERATOR_USERNAME'],
      moderatorPassword: Platform.environment['TEST_MODERATOR_PASSWORD'],
      conversationId: Platform.environment['TEST_CONVERSATION_ID'] ?? '1',
      messageId: Platform.environment['TEST_MESSAGE_ID'] ?? '1',
      attachmentId: Platform.environment['TEST_ATTACHMENT_ID'] ?? '1',
      groupId: Platform.environment['TEST_GROUP_ID'] ?? '1',
      testUrl: Platform.environment['TEST_URL'] ?? 'https://example.com/forum/topic/1',
      forumPassword: Platform.environment['TEST_FORUM_PASSWORD'] ?? 'forumpass',
      email: Platform.environment['TEST_EMAIL'] ?? 'test@example.com',
      token: Platform.environment['TEST_TOKEN'],
      code: Platform.environment['TEST_CODE'],
      privateMessagingType: Platform.environment['TEST_PRIVATE_MESSAGING_TYPE'] ?? 'conversations',
    );
  }

  /// Check if forum uses conversations for private messaging
  bool usesConversations() {
    return privateMessagingType.toLowerCase() == 'conversations';
  }

  /// Check if forum uses private messages for private messaging
  bool usesPrivateMessages() {
    return privateMessagingType.toLowerCase() == 'private_messages';
  }

  /// Check if second user credentials are configured
  bool hasSecondUserCredentials() {
    return secondUsername != null && 
           secondUsername!.isNotEmpty &&
           secondPassword != null && 
           secondPassword!.isNotEmpty;
  }

  /// Check if moderator credentials are configured
  bool hasModeratorCredentials() {
    return moderatorUsername != null && 
           moderatorUsername!.isNotEmpty &&
           moderatorPassword != null && 
           moderatorPassword!.isNotEmpty;
  }

  /// Check if SSO token and code are configured
  bool hasSsoCredentials() {
    return token != null && 
           token!.isNotEmpty &&
           code != null && 
           code!.isNotEmpty;
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

