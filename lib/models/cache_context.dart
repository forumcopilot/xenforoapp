import 'package:shared_preferences/shared_preferences.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class CacheContext {
  static CacheContext? _instance;
  static CacheContext get instance => _instance ??= CacheContext._();

  CacheContext._();

  static const String _searchHistoryKey = 'search_history';
  List<String> _searchHistoryList = [];
  bool _loaded = false;

  Future<void> loadFromDevice() async {
    if (_loaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_searchHistoryKey);
      if (list != null) {
        _searchHistoryList = List<String>.from(list);
      }
      _loaded = true;
    } catch (e) {
      AppLogger.debug('Error loading search history: $e');
    }
  }

  List<String> getSearchHistory() {
    return List<String>.from(_searchHistoryList);
  }

  Future<void> addSearchQuery(String query) async {
    await loadFromDevice();
    _searchHistoryList.remove(query);
    _searchHistoryList.insert(0, query);
    await _saveSearchHistoryToDevice();
  }

  Future<void> clearSearchHistory() async {
    _searchHistoryList = [];
    await _saveSearchHistoryToDevice();
  }

  Future<void> _saveSearchHistoryToDevice() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_searchHistoryKey, _searchHistoryList);
    } catch (e) {
      AppLogger.debug('Error saving search history: $e');
    }
  }

  // For future extensibility: add more cache types here
} 