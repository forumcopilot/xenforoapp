import 'dart:async';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';
import 'package:forumcopilot_flutter/core/errors/error_handling_mixins.dart';
import 'package:forumcopilot_flutter/core/errors/app_exceptions.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'package:forumcopilot_flutter/core/cache/lru_cache.dart';
import 'package:forumcopilot_flutter/core/cache/cache_manager.dart';

/// ForumManager manages forum structure caching and provides efficient access
/// to individual subforums by ID. Each BaseForumInfo gets its own manager instance.
class SiteManager with ErrorHandlingMixin {
  final SiteContext _siteContext;

  // LRU cache with size limits for memory management
  late final LRUCache<String, FCForum> _forumCache;

  // Complete forum structure as a tree
  List<FCForum>? _forumStructure;

  // Cache timestamp to track when data was last loaded
  DateTime? _lastLoadTime;

  // Cache expiration duration (default: 30 minutes)
  final Duration _cacheExpiration;

  // Loading state management
  bool _isLoading = false;
  Completer<void>? _loadingCompleter;

  SiteManager(
    this._siteContext, {
    Duration cacheExpiration = const Duration(minutes: 30),
    int maxCacheSize = 500,
  }) : _cacheExpiration = cacheExpiration {
    _forumCache = LRUCache<String, FCForum>(maxSize: maxCacheSize);

    // Register with cache manager for monitoring
    CacheManager().registerCache(
      'forum_cache_${_siteContext.siteKey}',
      _forumCache,
      maxSize: maxCacheSize,
      cleanupInterval: const Duration(minutes: 5),
    );
  }

  /// Gets a forum by ID. If the forum structure hasn't been loaded yet,
  /// it will load and cache it first.
  Future<FCForum?> getForumById(String forumId) async {
    // Check if we have a cached version that's still valid
    if (_isDataValid()) {
      final cachedForum = _forumCache.get(forumId);
      if (cachedForum != null) {
        return cachedForum;
      }
    }

    // Load forum structure if needed
    await _ensureForumStructureLoaded();

    // Return the requested forum
    return _forumCache.get(forumId);
  }

  /// Gets the complete forum structure. Loads and caches if not already available.
  Future<List<FCForum>> getForumStructure() async {
    if (_isDataValid() && _forumStructure != null) {
      return _forumStructure!;
    }

    await _ensureForumStructureLoaded();
    return _forumStructure ?? [];
  }

  /// Gets all child forums for a given parent forum ID
  Future<List<FCForum>> getChildForums(String parentForumId) async {
    final parentForum = await getForumById(parentForumId);
    return parentForum?.childForums ?? [];
  }

  /// Gets the parent forum for a given forum ID
  Future<FCForum?> getParentForum(String forumId) async {
    final forum = await getForumById(forumId);
    if (forum?.parentId == null) return null;

    return await getForumById(forum!.parentId!);
  }

  /// Gets the breadcrumb path for a forum (from root to the specified forum)
  Future<List<FCForum>> getBreadcrumbPath(String forumId) async {
    final forum = await getForumById(forumId);
    if (forum == null) return [];

    List<FCForum> breadcrumb = [forum];
    String? currentParentId = forum.parentId;

    while (currentParentId != null) {
      final parentForum = await getForumById(currentParentId);
      if (parentForum != null) {
        breadcrumb.insert(0, parentForum);
        currentParentId = parentForum.parentId;
      } else {
        break;
      }
    }

    return breadcrumb;
  }

  /// Forces a refresh of the forum structure from the server
  Future<void> refreshForumStructure() async {
    _clearCache();
    await _ensureForumStructureLoaded(forceRefresh: true);
  }

  /// Checks if a forum exists in the current structure
  Future<bool> forumExists(String forumId) async {
    final forum = await getForumById(forumId);
    return forum != null;
  }

  /// Searches for forums by name (case-insensitive partial match)
  Future<List<FCForum>> searchForumsByName(String searchTerm) async {
    await _ensureForumStructureLoaded();

    final searchTermLower = searchTerm.toLowerCase();
    return _forumCache.values.where((forum) => forum.name.toLowerCase().contains(searchTermLower)).toList();
  }

  /// Clears the in-memory cache
  void _clearCache() {
    _forumCache.clear();
    _forumStructure = null;
    _lastLoadTime = null;
  }

  /// Dispose resources and cleanup
  void dispose() {
    _forumCache.clear();
    _forumStructure = null;
    _lastLoadTime = null;
    _loadingCompleter?.complete();
    _loadingCompleter = null;

    // Unregister from cache manager
    CacheManager().clearCache('forum_cache_${_siteContext.siteKey}');
  }

  /// Checks if the cached data is still valid
  bool _isDataValid() {
    if (_lastLoadTime == null) return false;

    final now = DateTime.now();
    return now.difference(_lastLoadTime!) < _cacheExpiration;
  }

  /// Ensures the forum structure is loaded, handling concurrent requests
  Future<void> _ensureForumStructureLoaded({bool forceRefresh = false}) async {
    // If already loading, wait for the existing load to complete
    if (_isLoading) {
      await _loadingCompleter?.future;
      return;
    }

    // If data is valid and we're not forcing refresh, return early
    if (!forceRefresh && _isDataValid() && _forumStructure != null) {
      return;
    }

    // Start loading
    _isLoading = true;
    _loadingCompleter = Completer<void>();

    try {
      await _loadForumStructure(forceRefresh);
    } catch (e) {
      AppLogger.debug('ForumManager: Error loading forum structure: $e');
      rethrow;
    } finally {
      _isLoading = false;
      _loadingCompleter?.complete();
      _loadingCompleter = null;
    }
  }

  /// Loads the forum structure from the server and populates the cache
  Future<void> _loadForumStructure(bool forceRefresh) async {
    try {
      final forumProxy = SiteProxyFactory.getForumProxy();
      final forumResult = await forumProxy.getForumAsync(true, '', forceRefresh);

      if (forumResult.result) {
        _forumStructure = forumResult.forums;
        _populateForumCache(forumResult.forums);
        _lastLoadTime = DateTime.now();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Recursively populates the forum cache with all forums and their children
  void _populateForumCache(List<FCForum> forums) {
    for (final forum in forums) {
      _forumCache.put(forum.id, forum);

      // Recursively add child forums
      if (forum.childForums.isNotEmpty) {
        _populateForumCache(forum.childForums);
      }
    }
  }

  /// Gets cache statistics for debugging
  Map<String, dynamic> getCacheStats() {
    return {
      'totalForums': _forumCache.size,
      'isLoading': _isLoading,
      'lastLoadTime': _lastLoadTime?.toIso8601String(),
      'isDataValid': _isDataValid(),
      'cacheExpirationMinutes': _cacheExpiration.inMinutes,
      'lruStats': _forumCache.getStats(),
    };
  }
}

/// Global forum manager instance per BaseForumInfo
class SiteManagerRegistry {
  static final Map<String, SiteManager> _managers = {};

  /// Gets or creates a ForumManager for the given BaseForumInfo
  static SiteManager getManager(SiteContext siteContext) {
    final siteKey = siteContext.siteKey;

    if (!_managers.containsKey(siteKey)) {
      _managers[siteKey] = SiteManager(siteContext);
    }

    return _managers[siteKey]!;
  }

  /// Clears all managers (useful for testing or logout)
  static void clearAll() {
    // Dispose all managers before clearing
    for (final manager in _managers.values) {
      manager.dispose();
    }
    _managers.clear();
  }

  /// Removes a specific manager
  static void removeManager(String siteKey) {
    final manager = _managers.remove(siteKey);
    manager?.dispose();
  }
}
