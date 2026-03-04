import 'dart:collection';

/// LRU (Least Recently Used) cache implementation with size limits
class LRUCache<K, V> {
  final int maxSize;
  final LinkedHashMap<K, V> _cache = LinkedHashMap<K, V>();
  final Map<K, DateTime> _accessTimes = {};

  LRUCache({required this.maxSize}) : assert(maxSize > 0);

  /// Get value from cache
  V? get(K key) {
    if (_cache.containsKey(key)) {
      // Update access time and move to end (most recently used)
      _accessTimes[key] = DateTime.now();
      final value = _cache.remove(key);
      _cache[key] = value!;
      return value;
    }
    return null;
  }

  /// Put value in cache
  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      // Update existing entry
      _cache.remove(key);
    } else if (_cache.length >= maxSize) {
      // Remove least recently used item
      _evictLRU();
    }

    _cache[key] = value;
    _accessTimes[key] = DateTime.now();
  }

  /// Remove specific key
  void remove(K key) {
    _cache.remove(key);
    _accessTimes.remove(key);
  }

  /// Clear all entries
  void clear() {
    _cache.clear();
    _accessTimes.clear();
  }

  /// Get cache size
  int get size => _cache.length;

  /// Check if cache contains key
  bool containsKey(K key) => _cache.containsKey(key);

  /// Get all keys
  Iterable<K> get keys => _cache.keys;

  /// Get all values
  Iterable<V> get values => _cache.values;

  /// Evict least recently used item
  void _evictLRU() {
    if (_cache.isNotEmpty) {
      final lruKey = _cache.keys.first;
      _cache.remove(lruKey);
      _accessTimes.remove(lruKey);
    }
  }

  /// Get cache statistics
  Map<String, dynamic> getStats() {
    return {
      'size': _cache.length,
      'maxSize': maxSize,
      'utilization': (_cache.length / maxSize * 100).toStringAsFixed(1) + '%',
    };
  }
}
