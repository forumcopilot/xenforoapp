import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Container for Twitter preview metadata
class TwitterPreviewData {
  final String url;
  final String? tweetId;
  final String? authorName;
  final String? authorHandle;
  final String? tweetText;
  final DateTime cachedAt;

  TwitterPreviewData({
    required this.url,
    this.tweetId,
    this.authorName,
    this.authorHandle,
    this.tweetText,
    DateTime? cachedAt,
  }) : cachedAt = cachedAt ?? DateTime.now();

  /// Convert to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'tweetId': tweetId,
      'authorName': authorName,
      'authorHandle': authorHandle,
      'tweetText': tweetText,
      'cachedAt': cachedAt.millisecondsSinceEpoch,
    };
  }

  /// Create from JSON cache data
  factory TwitterPreviewData.fromJson(Map<String, dynamic> json) {
    return TwitterPreviewData(
      url: json['url'] as String,
      tweetId: json['tweetId'] as String?,
      authorName: json['authorName'] as String?,
      authorHandle: json['authorHandle'] as String?,
      tweetText: json['tweetText'] as String?,
      cachedAt: DateTime.fromMillisecondsSinceEpoch(json['cachedAt'] as int),
    );
  }

  /// Check if the cached data is still valid
  bool isValid({Duration maxAge = const Duration(hours: 24)}) {
    final now = DateTime.now();
    return now.difference(cachedAt) < maxAge;
  }
}

/// Manages caching of Twitter preview metadata
/// Similar to LinkPreviewCache but for Twitter/X content
class TwitterCache {
  static const String _cacheKeyPrefix = 'twitter_preview_';
  static final DefaultCacheManager _cacheManager = DefaultCacheManager();

  /// Fetches Twitter preview data from cache or API
  /// Think of it like checking your Twitter bookmarks before making a new API call
  static Future<TwitterPreviewData?> fetchTwitterPreview(String url, {Duration maxAge = const Duration(hours: 24)}) async {
    try {
      // Clean the URL by removing any quotes or extra whitespace
      final cleanUrl = url.trim().replaceAll('"', '');

      // Validate that this is a Twitter/X URL
      final urlPattern = RegExp(r'^https?://(www\.)?(twitter|x)\.com/([\w_]+)/status/(\d+)', caseSensitive: false);
      final match = urlPattern.firstMatch(cleanUrl);
      if (match == null) {
        debugPrint('TwitterCache: Invalid Twitter URL format: $cleanUrl');
        return null;
      }

      final tweetId = match.group(4);
      if (tweetId == null) {
        debugPrint('TwitterCache: Could not extract tweet ID from URL: $cleanUrl');
        return null;
      }

      final cacheKey = _cacheKeyPrefix + _generateCacheKey(tweetId);

      debugPrint('TwitterCache: Fetching preview for tweet ID: $tweetId');

      // First check if we have cached metadata that's still valid
      final cachedData = await _getCachedData(cacheKey);
      if (cachedData != null && cachedData.isValid(maxAge: maxAge)) {
        debugPrint('TwitterCache: Using cached data for tweet $tweetId');
        return cachedData;
      }

      // No valid cache found, fetch from ForumCopilot API
      debugPrint('TwitterCache: Fetching fresh data for tweet $tweetId');
      final freshData = await _fetchFromApi(cleanUrl, tweetId);

      if (freshData != null) {
        // Cache the fresh data
        await _cacheData(cacheKey, freshData);
        debugPrint('TwitterCache: Cached fresh data for tweet $tweetId');
        return freshData;
      }

      // If we couldn't fetch fresh data but have expired cache, return that
      if (cachedData != null) {
        debugPrint('TwitterCache: Using expired cache as fallback for tweet $tweetId');
        return cachedData;
      }

      return null;
    } catch (e) {
      debugPrint('TwitterCache: Error fetching preview for $url: $e');
      return null;
    }
  }

  /// Fetches Twitter data from the ForumCopilot API
  static Future<TwitterPreviewData?> _fetchFromApi(String url, String tweetId) async {
    debugPrint(
      'TwitterCache: Remote metadata disabled in standalone mode for tweet $tweetId',
    );
    return null;
  }

  /// Extracts Twitter handle from tweet content
  static String? _extractHandleFromContent(String? content) {
    if (content == null) return null;

    // Extract handle from content like "— Crypto Briefing (@Crypto_Briefing) July 7, 2025"
    final handleRegex = RegExp(r'@([a-zA-Z0-9_]+)');
    final match = handleRegex.firstMatch(content);
    return match?.group(1);
  }

  /// Cleans the tweet content by removing attribution and decoding HTML entities
  static String _cleanTweetContent(String? content) {
    if (content == null) return '';

    // Remove the author attribution part at the end
    // Pattern: "— Author Name (@handle) Date"
    final attributionRegex = RegExp(r'\s*—\s*[^@]+\(@[^)]+\)\s+\w+\s+\d+,\s+\d+$');
    String cleaned = content.replaceAll(attributionRegex, '');

    // Decode HTML entities
    cleaned = cleaned.replaceAll('&mdash;', '—');
    cleaned = cleaned.replaceAll('&amp;', '&');
    cleaned = cleaned.replaceAll('&lt;', '<');
    cleaned = cleaned.replaceAll('&gt;', '>');
    cleaned = cleaned.replaceAll('&quot;', '"');
    cleaned = cleaned.replaceAll('&#39;', "'");

    return cleaned.trim();
  }

  /// Gets cached data from local storage
  static Future<TwitterPreviewData?> _getCachedData(String cacheKey) async {
    try {
      final fileInfo = await _cacheManager.getFileFromCache(cacheKey);
      if (fileInfo != null) {
        final jsonString = await fileInfo.file.readAsString();
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return TwitterPreviewData.fromJson(json);
      }
      return null;
    } catch (e) {
      debugPrint('TwitterCache: Error reading cached data: $e');
      return null;
    }
  }

  /// Caches data to local storage
  static Future<void> _cacheData(String cacheKey, TwitterPreviewData data) async {
    try {
      final jsonString = jsonEncode(data.toJson());
      final bytes = utf8.encode(jsonString);
      await _cacheManager.putFile(cacheKey, bytes);
    } catch (e) {
      debugPrint('TwitterCache: Error caching data: $e');
    }
  }

  /// Generates a cache key from tweet ID
  static String _generateCacheKey(String tweetId) {
    // Use the tweet ID directly as it's already unique
    return tweetId;
  }

  /// Clears all cached Twitter preview data
  static Future<void> clearCache() async {
    try {
      await _cacheManager.emptyCache();
      debugPrint('TwitterCache: Cache cleared');
    } catch (e) {
      debugPrint('TwitterCache: Error clearing cache: $e');
    }
  }

  /// Removes specific tweet from cache
  static Future<void> removeCachedTweet(String url) async {
    try {
      final cleanUrl = url.trim().replaceAll('"', '');
      final urlPattern = RegExp(r'^https?://(www\.)?(twitter|x)\.com/([\w_]+)/status/(\d+)', caseSensitive: false);
      final match = urlPattern.firstMatch(cleanUrl);

      if (match != null) {
        final tweetId = match.group(4);
        if (tweetId != null) {
          final cacheKey = _cacheKeyPrefix + _generateCacheKey(tweetId);
          await _cacheManager.removeFile(cacheKey);
          debugPrint('TwitterCache: Removed cached data for tweet $tweetId');
        }
      }
    } catch (e) {
      debugPrint('TwitterCache: Error removing cached tweet: $e');
    }
  }

  /// Gets cache statistics for debugging
  static Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final cacheInfo = await _cacheManager.getFileFromCache('dummy');
      // This is a simple way to check cache status
      return {
        'cacheAvailable': true,
        'maxAge': '24 hours',
      };
    } catch (e) {
      return {
        'cacheAvailable': false,
        'error': e.toString(),
      };
    }
  }
}
