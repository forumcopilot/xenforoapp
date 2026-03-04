import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Create a SharedPreferences instance
late SharedPreferencesWithCache prefs;

class FCCache {
  static bool cacheEnabled = false;
  static bool _initialized = false;
  // Initialize SharedPreferences when the app starts
  static Future<void> initialize() async {
    if (!_initialized) {
      prefs = await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions());
      _initialized = true;
    }
  }

  static Future<T> executeCache<T>(
    String siteKey,
    String key,
    Duration cacheExpiration,
    Future<T> Function() function, {
    bool forceRefresh = false,
  }) async {
    if (cacheEnabled) {
      final isExpired = await _isCacheExpired(key, cacheExpiration);
      if (!isExpired && !forceRefresh) {
        final cachedValue = prefs.getString('CACHE_${siteKey}_$key');
        if (cachedValue != null) {
          return json.decode(cachedValue) as T;
        }
      }
    }

    final result = await function();
    await setCache(siteKey, key, result as Object);
    return result;
  }

  static Future<T?> getCache<T>(String siteKey, String key) async {
    if (cacheEnabled) {
      final value = prefs.getString('CACHE_${siteKey}_$key');
      return value != null ? json.decode(value) as T : null;
    }
    return null;
  }

  static Future<void> setCache(String siteKey, String key, Object value) async {
    if (cacheEnabled) {
      String jsonString = json.encode(value);
      await prefs.setString('CACHE_${siteKey}_$key', jsonString);
    }
  }

  static Future<bool> hasCache(String siteKey, String key) async {
    if (cacheEnabled) {
      return prefs.containsKey('CACHE_${siteKey}_$key');
    }
    return false;
  }

  static Future<void> removeCache(String siteKey, String key) async {
    if (cacheEnabled) {
      await prefs.remove('CACHE_${siteKey}_$key');
    }
  }

  /// Clears all cached data from the shared preferences storage
  static Future<void> clearSiteCache(String siteKey) async {
    if (!cacheEnabled) return;

    // Get all keys from SharedPreferences
    final standardPrefs = await SharedPreferences.getInstance();
    final allKeys = standardPrefs.getKeys();

    // Filter only cache-related keys
    final cacheKeys = allKeys.where((key) => key.startsWith('CACHE_${siteKey}_') || key.startsWith('CACHE_EXPIRATION_${siteKey}_'));

    // Remove each cache key
    for (final key in cacheKeys) {
      await prefs.remove(key);
    }
  }

  /// Clears all cached data from the shared preferences storage
  static Future<void> clearAllCache() async {
    if (!cacheEnabled) return;

    // Get all keys from SharedPreferences
    final standardPrefs = await SharedPreferences.getInstance();
    final allKeys = standardPrefs.getKeys();

    // Filter only cache-related keys
    final cacheKeys = allKeys.where((key) => key.startsWith('CACHE_') || key.startsWith('CACHE_EXPIRATION_'));

    // Remove each cache key
    for (final key in cacheKeys) {
      await prefs.remove(key);
    }
  }

  static Future<bool> _isCacheExpired(String key, Duration cacheExpiration) async {
    if (!cacheEnabled) return true;

    final expirationTime = DateTime.now().toUtc().subtract(cacheExpiration);
    final cachedTime = prefs.getInt('CACHE_EXPIRATION_${key}') ?? 0;
    final lastCached = DateTime.fromMillisecondsSinceEpoch(cachedTime, isUtc: true);

    return lastCached.isBefore(expirationTime);
  }
}
