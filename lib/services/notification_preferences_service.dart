import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_preferences.dart';
import 'package:forumcopilot_flutter/core/errors/error_handling_mixins.dart';
import 'package:forumcopilot_flutter/core/errors/app_exceptions.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'package:forumcopilot_flutter/core/cache/lru_cache.dart';
import 'package:forumcopilot_flutter/core/cache/cache_manager.dart';

/// Service for managing notification preferences per forum
class NotificationPreferencesService with ServiceErrorHandlingMixin {
  static const String _preferencesPrefix = 'notification_preferences_';
  static const String _defaultPreferencesKey = 'default_notification_preferences';

  static final NotificationPreferencesService _instance = NotificationPreferencesService._internal();
  factory NotificationPreferencesService() => _instance;
  NotificationPreferencesService._internal() {
    _preferencesCache = LRUCache<String, NotificationPreferences>(maxSize: 100);

    // Register with cache manager for monitoring
    CacheManager().registerCache(
      'notification_preferences_cache',
      _preferencesCache,
      maxSize: 100,
      cleanupInterval: const Duration(minutes: 10),
    );
  }

  // LRU cache with size limits for memory management
  late final LRUCache<String, NotificationPreferences> _preferencesCache;

  /// Get preferences for a specific forum
  Future<NotificationPreferences> getPreferences(String forumId) async {
    // Check cache first
    final cachedPreferences = _preferencesCache.get(forumId);
    if (cachedPreferences != null) {
      return cachedPreferences;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_preferencesPrefix$forumId';
      final preferencesJson = prefs.getString(key);

      NotificationPreferences preferences;

      if (preferencesJson != null) {
        // Load existing preferences
        final preferencesMap = jsonDecode(preferencesJson) as Map<String, dynamic>;
        preferences = NotificationPreferences.fromJson(preferencesMap);
        AppLogger.debug('Loaded preferences for forum $forumId: ${preferences.enabledTypes.length} types enabled');
      } else {
        // Use default preferences
        preferences = NotificationPreferences.defaultPreferences;
        AppLogger.debug('Using default preferences for forum $forumId');

        // Save default preferences
        await savePreferences(forumId, preferences);
      }

      // Cache the preferences
      _preferencesCache.put(forumId, preferences);
      return preferences;
    } catch (e) {
      AppLogger.debug('Error loading preferences for forum $forumId: $e');
      // Return default preferences as fallback
      final defaultPrefs = NotificationPreferences.defaultPreferences;
      _preferencesCache.put(forumId, defaultPrefs);
      return defaultPrefs;
    }
  }

  /// Save preferences for a specific forum
  Future<void> savePreferences(String forumId, NotificationPreferences preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_preferencesPrefix$forumId';
      final preferencesJson = jsonEncode(preferences.updateTimestamp().toJson());

      await prefs.setString(key, preferencesJson);

      // Update cache
      _preferencesCache.put(forumId, preferences);

      AppLogger.debug('Saved preferences for forum $forumId: ${preferences.enabledTypes.length} types enabled');
    } catch (e) {
      AppLogger.debug('Error saving preferences for forum $forumId: $e');
    }
  }

  /// Update a specific preference for a forum
  Future<void> updatePreference(
    String forumId,
    String preferenceType,
    bool value,
  ) async {
    try {
      final currentPreferences = await getPreferences(forumId);
      NotificationPreferences updatedPreferences;

      switch (preferenceType) {
        case 'isEnabled':
          updatedPreferences = currentPreferences.copyWith(isEnabled: value);
          break;
        case 'newPosts':
          updatedPreferences = currentPreferences.copyWith(newPosts: value);
          break;
        case 'replies':
          updatedPreferences = currentPreferences.copyWith(replies: value);
          break;
        case 'mentions':
          updatedPreferences = currentPreferences.copyWith(mentions: value);
          break;
        case 'quotes':
          updatedPreferences = currentPreferences.copyWith(quotes: value);
          break;
        case 'likes':
          updatedPreferences = currentPreferences.copyWith(likes: value);
          break;
        case 'subscriptions':
          updatedPreferences = currentPreferences.copyWith(subscriptions: value);
          break;
        case 'privateMessages':
          updatedPreferences = currentPreferences.copyWith(privateMessages: value);
          break;
        case 'systemNotifications':
          updatedPreferences = currentPreferences.copyWith(systemNotifications: value);
          break;
        default:
          AppLogger.debug('Unknown preference type: $preferenceType');
          return;
      }

      await savePreferences(forumId, updatedPreferences);
      AppLogger.debug('Updated preference $preferenceType to $value for forum $forumId');
    } catch (e) {
      AppLogger.debug('Error updating preference $preferenceType for forum $forumId: $e');
    }
  }

  /// Enable all notifications for a forum
  Future<void> enableAllNotifications(String forumId) async {
    try {
      final preferences = await getPreferences(forumId);
      final enabledPreferences = preferences.enableAll();
      await savePreferences(forumId, enabledPreferences);
      AppLogger.debug('Enabled all notifications for forum $forumId');
    } catch (e) {
      AppLogger.debug('Error enabling all notifications for forum $forumId: $e');
    }
  }

  /// Disable all notifications for a forum
  Future<void> disableAllNotifications(String forumId) async {
    try {
      final preferences = await getPreferences(forumId);
      final disabledPreferences = preferences.disableAll();
      await savePreferences(forumId, disabledPreferences);
      AppLogger.debug('Disabled all notifications for forum $forumId');
    } catch (e) {
      AppLogger.debug('Error disabling all notifications for forum $forumId: $e');
    }
  }

  /// Toggle global enable/disable for a forum
  Future<void> toggleGlobalNotifications(String forumId) async {
    try {
      final preferences = await getPreferences(forumId);
      final toggledPreferences = preferences.toggleGlobal();
      await savePreferences(forumId, toggledPreferences);
      AppLogger.debug('Toggled global notifications for forum $forumId: ${toggledPreferences.isEnabled}');
    } catch (e) {
      AppLogger.debug('Error toggling global notifications for forum $forumId: $e');
    }
  }

  /// Remove preferences for a forum
  Future<void> removePreferences(String forumId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_preferencesPrefix$forumId';
      await prefs.remove(key);

      // Remove from cache
      _preferencesCache.remove(forumId);

      AppLogger.debug('Removed preferences for forum $forumId');
    } catch (e) {
      AppLogger.debug('Error removing preferences for forum $forumId: $e');
    }
  }

  /// Get all forum IDs that have preferences
  Future<List<String>> getAllForumIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      final forumIds = keys.where((key) => key.startsWith(_preferencesPrefix)).map((key) => key.substring(_preferencesPrefix.length)).toList();

      return forumIds;
    } catch (e) {
      AppLogger.debug('Error getting all forum IDs: $e');
      return [];
    }
  }

  /// Get preferences for all forums
  Future<Map<String, NotificationPreferences>> getAllPreferences() async {
    try {
      final forumIds = await getAllForumIds();
      final allPreferences = <String, NotificationPreferences>{};

      for (final forumId in forumIds) {
        final preferences = await getPreferences(forumId);
        allPreferences[forumId] = preferences;
      }

      return allPreferences;
    } catch (e) {
      AppLogger.debug('Error getting all preferences: $e');
      return {};
    }
  }

  /// Set default preferences for new forums
  Future<void> setDefaultPreferences(NotificationPreferences preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final preferencesJson = jsonEncode(preferences.toJson());
      await prefs.setString(_defaultPreferencesKey, preferencesJson);

      AppLogger.debug('Set default preferences: ${preferences.enabledTypes.length} types enabled');
    } catch (e) {
      AppLogger.debug('Error setting default preferences: $e');
    }
  }

  /// Get default preferences
  Future<NotificationPreferences> getDefaultPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final preferencesJson = prefs.getString(_defaultPreferencesKey);

      if (preferencesJson != null) {
        final preferencesMap = jsonDecode(preferencesJson) as Map<String, dynamic>;
        return NotificationPreferences.fromJson(preferencesMap);
      }

      return NotificationPreferences.defaultPreferences;
    } catch (e) {
      AppLogger.debug('Error getting default preferences: $e');
      return NotificationPreferences.defaultPreferences;
    }
  }

  /// Clear all preferences (for testing or reset)
  Future<void> clearAllPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        if (key.startsWith(_preferencesPrefix) || key == _defaultPreferencesKey) {
          await prefs.remove(key);
        }
      }

      // Clear cache
      _preferencesCache.clear();

      AppLogger.debug('Cleared all notification preferences');
    } catch (e) {
      AppLogger.debug('Error clearing all preferences: $e');
    }
  }

  /// Check if preferences exist for a forum
  Future<bool> hasPreferences(String forumId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_preferencesPrefix$forumId';
      return prefs.containsKey(key);
    } catch (e) {
      AppLogger.debug('Error checking if preferences exist for forum $forumId: $e');
      return false;
    }
  }

  /// Get preferences summary for logging
  Future<String> getPreferencesSummary(String forumId) async {
    try {
      final preferences = await getPreferences(forumId);
      return 'Preferences(forum: $forumId, enabled: ${preferences.isEnabled}, types: ${preferences.enabledCount})';
    } catch (e) {
      return 'Preferences(forum: $forumId, error: $e)';
    }
  }

  /// Clear cache (useful for testing or memory management)
  void clearCache() {
    _preferencesCache.clear();
    AppLogger.debug('Cleared preferences cache');
  }

  /// Dispose resources and cleanup
  void dispose() {
    _preferencesCache.clear();
    CacheManager().clearCache('notification_preferences_cache');
  }
}
