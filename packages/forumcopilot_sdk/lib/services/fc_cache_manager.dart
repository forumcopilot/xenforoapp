import 'dart:io';
import 'package:dio/dio.dart';
import 'fc_http_client.dart';

/// Simple file cache manager that uses cookie-aware HTTP client
/// This ensures that image requests and other cached content include authentication cookies
class FCCacheManager {
  static FCCacheManager? _instance;
  final Map<String, File> _cache = {};
  // Track ongoing downloads to prevent duplicate requests for the same file
  final Map<String, Future<File>> _pendingDownloads = {};

  factory FCCacheManager() {
    _instance ??= FCCacheManager._();
    return _instance!;
  }

  FCCacheManager._();

  /// Get a file from cache or download it with cookies
  Future<File> getSingleFile(String url, {String? key, Map<String, String>? headers}) async {
    final effectiveKey = key ?? url;

    // Check if file is already cached
    if (_cache.containsKey(effectiveKey)) {
      final cachedFile = _cache[effectiveKey]!;
      if (await cachedFile.exists()) {
        return cachedFile;
      } else {
        _cache.remove(effectiveKey);
      }
    }

    // Check if a download is already in progress for this file
    if (_pendingDownloads.containsKey(effectiveKey)) {
      // Return the existing download future instead of starting a new one
      return _pendingDownloads[effectiveKey]!;
    }

    // Start a new download and track it
    final downloadFuture = _downloadFile(url, effectiveKey, headers);
    _pendingDownloads[effectiveKey] = downloadFuture;

    try {
      final file = await downloadFuture;
      return file;
    } finally {
      // Remove from pending downloads once complete (success or failure)
      _pendingDownloads.remove(effectiveKey);
    }
  }

  /// Internal method to perform the actual download
  Future<File> _downloadFile(String url, String effectiveKey, Map<String, String>? headers) async {
    // Use our cookie-aware HTTP client for the request
    final uri = Uri.parse(url);
    final response = await FCHttpClient.get<List<int>>(uri, headers: headers, responseType: ResponseType.bytes);

    if ((response.statusCode ?? 0) == 200) {
      // Create temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${_sanitizeKey(effectiveKey)}');

      // Write response body to file
      await file.writeAsBytes(response.data ?? <int>[]);

      // Cache the file
      _cache[effectiveKey] = file;

      return file;
    } else {
      throw HttpException('Failed to load file: ${response.statusCode}');
    }
  }

  /// Get file from cache if it exists
  Future<File?> getFileFromCache(String key) async {
    if (_cache.containsKey(key)) {
      final file = _cache[key]!;
      if (await file.exists()) {
        return file;
      } else {
        _cache.remove(key);
      }
    }
    return null;
  }

  /// Store file in cache
  Future<void> putFile(String key, List<int> bytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${_sanitizeKey(key)}');
      await file.writeAsBytes(bytes);
      _cache[key] = file;
    } catch (e) {
      print('Error caching file: $e');
    }
  }

  /// Remove file from cache
  Future<void> removeFile(String key) async {
    if (_cache.containsKey(key)) {
      final file = _cache[key]!;
      try {
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        print('Error removing cached file: $e');
      }
      _cache.remove(key);
    }
  }

  /// Clear all cached files
  Future<void> emptyCache() async {
    for (final file in _cache.values) {
      try {
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore errors when deleting files
      }
    }
    _cache.clear();
  }

  /// Sanitize key for use as filename
  String _sanitizeKey(String key) {
    return key.replaceAll(RegExp(r'[^\w\-_\.]'), '_');
  }

  /// Get temporary directory
  Future<Directory> getTemporaryDirectory() async {
    return Directory.systemTemp;
  }
}
