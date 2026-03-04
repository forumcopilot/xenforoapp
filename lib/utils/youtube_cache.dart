import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Container for YouTube video preview metadata
class YouTubePreviewData {
  final String url;
  final String? videoId;
  final String? videoTitle;
  final String? authorName;
  final String? authorAvatar;
  final String? previewImageUrl;
  final DateTime cachedAt;

  YouTubePreviewData({
    required this.url,
    this.videoId,
    this.videoTitle,
    this.authorName,
    this.authorAvatar,
    this.previewImageUrl,
    DateTime? cachedAt,
  }) : cachedAt = cachedAt ?? DateTime.now();

  /// Convert to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'videoId': videoId,
      'videoTitle': videoTitle,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'previewImageUrl': previewImageUrl,
      'cachedAt': cachedAt.millisecondsSinceEpoch,
    };
  }

  /// Create from JSON cache data
  factory YouTubePreviewData.fromJson(Map<String, dynamic> json) {
    return YouTubePreviewData(
      url: json['url'] as String,
      videoId: json['videoId'] as String?,
      videoTitle: json['videoTitle'] as String?,
      authorName: json['authorName'] as String?,
      authorAvatar: json['authorAvatar'] as String?,
      previewImageUrl: json['previewImageUrl'] as String?,
      cachedAt: DateTime.fromMillisecondsSinceEpoch(json['cachedAt'] as int),
    );
  }

  /// Check if the cached data is still valid
  bool isValid({Duration maxAge = const Duration(hours: 24)}) {
    final now = DateTime.now();
    return now.difference(cachedAt) < maxAge;
  }
}

/// Manages caching of YouTube video preview metadata
/// Similar to TwitterCache but for YouTube content
class YouTubeCache {
  static const String _cacheKeyPrefix = 'youtube_preview_';
  static final DefaultCacheManager _cacheManager = DefaultCacheManager();

  /// Fetches YouTube preview data from cache or API
  /// Think of it like checking your YouTube watch history before making a new API call
  static Future<YouTubePreviewData?> fetchYouTubePreview(String url, {Duration maxAge = const Duration(hours: 24)}) async {
    try {
      // Clean the URL by removing any quotes or extra whitespace
      var cleanUrl = url.trim().replaceAll('"', '');

      // Check if the input is just a video ID (11 characters matching video ID pattern)
      final videoIdOnlyRegex = RegExp(r'^[a-zA-Z0-9_-]{11}$');
      if (videoIdOnlyRegex.hasMatch(cleanUrl)) {
        // Convert video ID to full YouTube URL format
        debugPrint('YouTubeCache: Detected bare video ID, converting to URL: $cleanUrl');
        cleanUrl = 'https://www.youtube.com/watch?v=$cleanUrl';
      }

      // Validate that this is a YouTube URL and extract video ID
      final youtubeRegex = RegExp(r'^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:watch\?v=|embed\/)|youtu\.be\/)([a-zA-Z0-9_-]{11})(?:\S+)?$', caseSensitive: false);
      final match = youtubeRegex.firstMatch(cleanUrl);
      if (match == null) {
        debugPrint('YouTubeCache: Invalid YouTube URL format: $cleanUrl');
        return null;
      }

      final videoId = match.group(1);
      if (videoId == null) {
        debugPrint('YouTubeCache: Could not extract video ID from URL: $cleanUrl');
        return null;
      }

      final cacheKey = _cacheKeyPrefix + _generateCacheKey(videoId);

      debugPrint('YouTubeCache: Fetching preview for video ID: $videoId');

      // First check if we have cached metadata that's still valid
      final cachedData = await _getCachedData(cacheKey);
      if (cachedData != null && cachedData.isValid(maxAge: maxAge)) {
        debugPrint('YouTubeCache: Using cached data for video $videoId');
        return cachedData;
      }

      // No valid cache found, fetch from ForumCopilot API
      debugPrint('YouTubeCache: Fetching fresh data for video $videoId');
      final freshData = await _fetchFromApi(cleanUrl, videoId);

      if (freshData != null) {
        // Cache the fresh data
        await _cacheData(cacheKey, freshData);
        debugPrint('YouTubeCache: Cached fresh data for video $videoId');
        return freshData;
      }

      // If we couldn't fetch fresh data but have expired cache, return that
      if (cachedData != null) {
        debugPrint('YouTubeCache: Using expired cache as fallback for video $videoId');
        return cachedData;
      }

      return null;
    } catch (e) {
      debugPrint('YouTubeCache: Error fetching preview for $url: $e');
      return null;
    }
  }

  /// Fetches YouTube data from the ForumCopilot API
  static Future<YouTubePreviewData?> _fetchFromApi(String url, String videoId) async {
    debugPrint(
      'YouTubeCache: Remote metadata disabled in standalone mode for video $videoId',
    );
    return null;
  }

  /// Gets cached data from local storage
  static Future<YouTubePreviewData?> _getCachedData(String cacheKey) async {
    try {
      final fileInfo = await _cacheManager.getFileFromCache(cacheKey);
      if (fileInfo != null) {
        final jsonString = await fileInfo.file.readAsString();
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return YouTubePreviewData.fromJson(json);
      }
      return null;
    } catch (e) {
      debugPrint('YouTubeCache: Error reading cached data: $e');
      return null;
    }
  }

  /// Caches data to local storage
  static Future<void> _cacheData(String cacheKey, YouTubePreviewData data) async {
    try {
      final jsonString = jsonEncode(data.toJson());
      final bytes = utf8.encode(jsonString);
      await _cacheManager.putFile(cacheKey, bytes);
    } catch (e) {
      debugPrint('YouTubeCache: Error caching data: $e');
    }
  }

  /// Generates a cache key from video ID
  static String _generateCacheKey(String videoId) {
    // Use the video ID directly as it's already unique
    return videoId;
  }

  /// Clears all cached YouTube preview data
  static Future<void> clearCache() async {
    try {
      await _cacheManager.emptyCache();
      debugPrint('YouTubeCache: Cache cleared');
    } catch (e) {
      debugPrint('YouTubeCache: Error clearing cache: $e');
    }
  }

  /// Removes specific video from cache
  static Future<void> removeCachedVideo(String url) async {
    try {
      final cleanUrl = url.trim().replaceAll('"', '');
      final youtubeRegex = RegExp(r'^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:watch\?v=|embed\/)|youtu\.be\/)([a-zA-Z0-9_-]{11})(?:\S+)?$', caseSensitive: false);
      final match = youtubeRegex.firstMatch(cleanUrl);

      if (match != null) {
        final videoId = match.group(1);
        if (videoId != null) {
          final cacheKey = _cacheKeyPrefix + _generateCacheKey(videoId);
          await _cacheManager.removeFile(cacheKey);
          debugPrint('YouTubeCache: Removed cached data for video $videoId');
        }
      }
    } catch (e) {
      debugPrint('YouTubeCache: Error removing cached video: $e');
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
