import 'dart:io';
import 'dart:convert';

/// Centralized test configuration for XenForo integration tests
/// Loads configuration from test/config.json file
class TestEnv {
  static Map<String, dynamic>? _config;

  /// Load configuration from config.json file
  static Map<String, dynamic> _loadConfig() {
    if (_config != null) {
      return _config!;
    }

    try {
      // Try relative path from package root (when running tests from package directory)
      var configFile = File('test/config.json');

      // If not found, try relative to current directory
      if (!configFile.existsSync()) {
        final currentDir = Directory.current.path;
        configFile = File('$currentDir/test/config.json');
      }

      // If still not found, try from project root (packages/xenforo_core/test/config.json)
      if (!configFile.existsSync()) {
        final currentDir = Directory.current.path;
        configFile = File('$currentDir/packages/xenforo_core/test/config.json');
      }

      // If still not found, try one level up (if running from test directory)
      if (!configFile.existsSync()) {
        configFile = File('config.json');
      }

      if (!configFile.existsSync()) {
        throw Exception('Configuration file not found: test/config.json\n'
            'Please create test/config.json based on test/config.json.example\n'
            'Current directory: ${Directory.current.path}');
      }

      final content = configFile.readAsStringSync();
      _config = jsonDecode(content) as Map<String, dynamic>;
      return _config!;
    } catch (e) {
      throw Exception('Failed to load test configuration: $e');
    }
  }

  /// Get a configuration value with optional default
  static String _getValue(String key, [String? defaultValue]) {
    final config = _loadConfig();
    return config[key]?.toString() ?? defaultValue ?? '';
  }

  /// Base URL of the forum
  static String baseUrl() {
    return _getValue('baseUrl', 'https://example.com');
  }

  /// Plugin URL (defaults to baseUrl if not provided)
  static String pluginUrl() {
    final pluginUrl = _getValue('pluginUrl');
    if (pluginUrl.isNotEmpty) {
      return pluginUrl;
    }
    return baseUrl();
  }

  /// Test username for authentication tests
  static String username() {
    return _getValue('username', 'test');
  }

  /// Test password for authentication tests
  static String password() {
    return _getValue('password', '');
  }

  /// Second test username for dual-user conversation tests (optional, returns null if not configured)
  static String? secondUsername() {
    final value = _getValue('secondUsername');
    return value.isEmpty ? null : value;
  }

  /// Second test password for dual-user conversation tests (optional, returns null if not configured)
  static String? secondPassword() {
    final value = _getValue('secondPassword');
    return value.isEmpty ? null : value;
  }

  /// Moderator username for moderation tests (optional, returns null if not configured)
  static String? moderatorUsername() {
    final value = _getValue('moderatorUsername');
    return value.isEmpty ? null : value;
  }

  /// Moderator password for moderation tests (optional, returns null if not configured)
  static String? moderatorPassword() {
    final value = _getValue('moderatorPassword');
    return value.isEmpty ? null : value;
  }

  /// Forum ID to use for tests
  static String forumId() {
    return _getValue('forumId', '1');
  }

  /// Password-protected forum ID to use for loginForum tests
  static String passwordProtectedForumId() {
    return _getValue('passwordProtectedForumId', '7');
  }

  /// Topic ID to use for tests
  static String topicId() {
    return _getValue('topicId', '1');
  }

  /// Post ID to use for tests
  static String postId() {
    return _getValue('postId', '1');
  }

  /// User ID to use for tests
  static String userId() {
    return _getValue('userId', '1');
  }

  /// Conversation ID for private conversation tests
  static String conversationId() {
    return _getValue('conversationId', '1');
  }

  /// Message ID for private message tests
  static String messageId() {
    return _getValue('messageId', '0');
  }

  /// Attachment ID for attachment tests
  static String attachmentId() {
    return _getValue('attachmentId', '1');
  }

  /// Group ID for attachment tests
  static String groupId() {
    return _getValue('groupId', '1');
  }

  /// Test URL for URL conversion tests
  static String testUrl() {
    final testUrl = _getValue('testUrl');
    if (testUrl.isNotEmpty) {
      return testUrl;
    }
    return '${baseUrl()}/forum/topic/1';
  }

  /// Forum password for password-protected forum tests
  static String forumPassword() {
    return _getValue('forumPassword', '');
  }

  /// Email address for account tests
  static String email() {
    return _getValue('email', 'test@example.com');
  }

  /// Token for SSO/registration tests (optional, returns null if not configured)
  static String? token() {
    final value = _getValue('token');
    return value.isEmpty ? null : value;
  }

  /// Code for SSO/registration tests (optional, returns null if not configured)
  static String? code() {
    final value = _getValue('code');
    return value.isEmpty ? null : value;
  }

  /// Private messaging type: "conversations" or "private_messages"
  /// Determines which private messaging tests to run
  static String privateMessagingType() {
    return _getValue('privateMessagingType', 'conversations');
  }

  /// Post ID that can receive "like" (empty if not supported)
  static String likePostId() {
    return _getValue('likePostId', '');
  }

  /// Post ID that can receive "thank" (empty if not supported)
  static String thankPostId() {
    return _getValue('thankPostId', '');
  }
}
