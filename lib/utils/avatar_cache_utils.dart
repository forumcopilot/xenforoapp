import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Utility class for generating consistent cache keys for avatars
/// This ensures the same avatar URL uses the same cache key across different components
class AvatarCacheUtils {
  /// Generates a consistent cache key for an avatar
  /// Uses a combination of user ID and URL hash to ensure uniqueness and consistency
  static String generateAvatarCacheKey({
    String? userId,
    String? username,
    required String avatarUrl,
  }) {
    // Create a consistent identifier from available data
    String identifier = '';

    if (userId != null && userId.isNotEmpty) {
      identifier = 'user_$userId';
    } else if (username != null && username.isNotEmpty) {
      identifier = 'username_$username';
    } else {
      // Fallback to URL hash if no user info available
      identifier = 'url_${_hashUrl(avatarUrl)}';
    }

    // Add URL hash to ensure different URLs get different cache keys
    final urlHash = _hashUrl(avatarUrl);

    return 'avatar_${identifier}_$urlHash';
  }

  /// Generates a cache key based on avatar URL only (for cases without user context)
  static String generateUrlBasedCacheKey(String avatarUrl) {
    final urlHash = _hashUrl(avatarUrl);
    return 'avatar_url_$urlHash';
  }

  /// Creates a hash of the URL for consistent cache key generation
  static String _hashUrl(String url) {
    final bytes = utf8.encode(url);
    final digest = md5.convert(bytes);
    return digest.toString().substring(0, 8); // Use first 8 characters for brevity
  }
}
