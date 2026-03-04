import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'bbcode_processor.dart';

/// Container for link preview metadata
class LinkPreviewData {
  final String url;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? domain;
  final DateTime cachedAt;

  LinkPreviewData({
    required this.url,
    this.title,
    this.description,
    this.imageUrl,
    this.domain,
    DateTime? cachedAt,
  }) : cachedAt = cachedAt ?? DateTime.now();

  /// Convert to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'domain': domain,
      'cachedAt': cachedAt.millisecondsSinceEpoch,
    };
  }

  /// Create from JSON cache data
  factory LinkPreviewData.fromJson(Map<String, dynamic> json) {
    return LinkPreviewData(
      url: json['url'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      domain: json['domain'] as String?,
      cachedAt: DateTime.fromMillisecondsSinceEpoch(json['cachedAt'] as int),
    );
  }

  /// Check if the cached data is still valid
  bool isValid({Duration maxAge = const Duration(hours: 24)}) {
    final now = DateTime.now();
    return now.difference(cachedAt) < maxAge;
  }
}

/// Manages caching of link preview metadata
/// Similar to ImageLoader but for web page metadata
class LinkPreviewCache {
  static const String _cacheKeyPrefix = 'link_preview_';
  static final FCCacheManager _cacheManager = FCCacheManager();

  /// Fetches link preview data from cache or web
  /// Think of it like checking your address book before looking up contact info again
  static Future<LinkPreviewData?> fetchLinkPreview(String url, {Duration maxAge = const Duration(hours: 24)}) async {
    try {
      // Clean the URL by removing any quotes or extra whitespace
      final cleanUrl = url.trim().replaceAll('"', '');

      // Exclude Twitter URLs from link preview processing
      if (BBCodeProcessor.isTwitterUrl(cleanUrl)) {
        debugPrint('LinkPreviewCache: Excluding Twitter URL from link preview: $cleanUrl');
        return null;
      }

      // Exclude YouTube URLs from link preview processing
      if (BBCodeProcessor.isYoutubeUrl(cleanUrl)) {
        debugPrint('LinkPreviewCache: Excluding YouTube URL from link preview: $cleanUrl');
        return null;
      }

      final cacheKey = _cacheKeyPrefix + _generateCacheKey(cleanUrl);

      debugPrint('LinkPreviewCache: Fetching preview for URL: $cleanUrl');

      // First check if we have cached metadata that's still valid
      final cachedData = await _getCachedData(cacheKey);
      if (cachedData != null && cachedData.isValid(maxAge: maxAge)) {
        debugPrint('LinkPreviewCache: Using cached data for $cleanUrl');
        return cachedData;
      }

      // No valid cache found, fetch from web
      debugPrint('LinkPreviewCache: Fetching fresh data for $cleanUrl');
      final freshData = await _fetchFromWeb(cleanUrl);

      if (freshData != null) {
        // Cache the fresh data
        await _cacheData(cacheKey, freshData);
        debugPrint('LinkPreviewCache: Cached fresh data for $cleanUrl');
        return freshData;
      }

      // If we couldn't fetch fresh data but have expired cache, return that
      if (cachedData != null) {
        debugPrint('LinkPreviewCache: Using expired cache as fallback for $cleanUrl');
        return cachedData;
      }

      return null;
    } catch (e) {
      debugPrint('LinkPreviewCache: Error fetching preview for $url: $e');
      return null;
    }
  }

  /// Fetches metadata from the web
  static Future<LinkPreviewData?> _fetchFromWeb(String url) async {
    try {
      final response = await FCHttpClient.get<String>(
        Uri.parse(url),
        responseType: ResponseType.plain,
      );

      if ((response.statusCode ?? 0) == 200) {
        final document = parser.parse(response.data ?? '');

        // Extract metadata
        final title = _extractMetaContent(document, 'og:title') ?? _extractMetaContent(document, 'twitter:title') ?? document.querySelector('title')?.text;

        // If no title is found, don't cache this
        if (title == null || title.trim().isEmpty) {
          return null;
        }

        final description = _extractMetaContent(document, 'og:description') ?? _extractMetaContent(document, 'twitter:description') ?? _extractMetaContent(document, 'description');

        final imageUrl = _extractMetaContent(document, 'og:image') ?? _extractMetaContent(document, 'twitter:image');

        final domain = Uri.parse(url).host;

        return LinkPreviewData(
          url: url,
          title: title.trim(),
          description: description?.trim(),
          imageUrl: imageUrl?.trim(),
          domain: domain,
        );
      }

      return null;
    } catch (e) {
      debugPrint('LinkPreviewCache: Error fetching from web for $url: $e');
      return null;
    }
  }

  /// Extracts meta content from HTML document
  static String? _extractMetaContent(dom.Document document, String property) {
    return document.querySelector('meta[property="$property"]')?.attributes['content'] ?? document.querySelector('meta[name="$property"]')?.attributes['content'];
  }

  /// Gets cached data from local storage
  static Future<LinkPreviewData?> _getCachedData(String cacheKey) async {
    try {
      final file = await _cacheManager.getFileFromCache(cacheKey);
      if (file != null) {
        final jsonString = await file.readAsString();
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return LinkPreviewData.fromJson(json);
      }
      return null;
    } catch (e) {
      debugPrint('LinkPreviewCache: Error reading cached data: $e');
      return null;
    }
  }

  /// Caches data to local storage
  static Future<void> _cacheData(String cacheKey, LinkPreviewData data) async {
    try {
      final jsonString = jsonEncode(data.toJson());
      final bytes = utf8.encode(jsonString);
      await _cacheManager.putFile(cacheKey, bytes);
    } catch (e) {
      debugPrint('LinkPreviewCache: Error caching data: $e');
    }
  }

  /// Generates a cache key from URL
  static String _generateCacheKey(String url) {
    // Use a simple hash of the URL for the cache key
    return url.hashCode.abs().toString();
  }

  /// Clears all cached link preview data
  static Future<void> clearCache() async {
    try {
      await _cacheManager.emptyCache();
      debugPrint('LinkPreviewCache: Cache cleared');
    } catch (e) {
      debugPrint('LinkPreviewCache: Error clearing cache: $e');
    }
  }

  /// Removes specific URL from cache
  static Future<void> removeCachedUrl(String url) async {
    try {
      final cleanUrl = url.trim().replaceAll('"', '');
      final cacheKey = _cacheKeyPrefix + _generateCacheKey(cleanUrl);
      await _cacheManager.removeFile(cacheKey);
      debugPrint('LinkPreviewCache: Removed cached data for $cleanUrl');
    } catch (e) {
      debugPrint('LinkPreviewCache: Error removing cached URL: $e');
    }
  }

  /// Gets cache statistics for debugging
  static Future<Map<String, dynamic>> getCacheStats() async {
    try {
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
