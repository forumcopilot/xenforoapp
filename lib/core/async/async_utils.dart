import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

/// Utility class for handling async operations without blocking UI
class AsyncUtils {
  /// Run operation in background isolate for CPU-intensive tasks
  static Future<T> runInBackground<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    if (kIsWeb) {
      // Web doesn't support isolates, run on main thread
      return await operation();
    }

    try {
      AppLogger.debug('Starting background operation: ${operationName ?? 'unnamed'}');

      final result = await Isolate.run(() async {
        return await operation();
      });

      AppLogger.debug('Completed background operation: ${operationName ?? 'unnamed'}');
      return result;
    } catch (e) {
      AppLogger.error('Background operation failed: ${operationName ?? 'unnamed'}: $e');
      rethrow;
    }
  }

  /// Run operation with timeout
  static Future<T> withTimeout<T>(
    Future<T> Function() operation, {
    Duration timeout = const Duration(seconds: 30),
    String? operationName,
  }) async {
    try {
      AppLogger.debug('Starting operation with timeout: ${operationName ?? 'unnamed'} (${timeout.inSeconds}s)');

      final result = await operation().timeout(timeout);

      AppLogger.debug('Completed operation: ${operationName ?? 'unnamed'}');
      return result;
    } on TimeoutException {
      AppLogger.warning('Operation timed out: ${operationName ?? 'unnamed'}');
      rethrow;
    } catch (e) {
      AppLogger.error('Operation failed: ${operationName ?? 'unnamed'}: $e');
      rethrow;
    }
  }

  /// Debounce function calls
  static Timer? _debounceTimer;

  static void debounce(
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }

  /// Throttle function calls
  static DateTime? _lastThrottleCall;

  static bool throttle({
    Duration interval = const Duration(milliseconds: 100),
  }) {
    final now = DateTime.now();
    if (_lastThrottleCall == null || now.difference(_lastThrottleCall!) > interval) {
      _lastThrottleCall = now;
      return true;
    }
    return false;
  }

  /// Run operation with retry logic
  static Future<T> withRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
    String? operationName,
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        AppLogger.debug('Attempt ${attempts + 1}/$maxRetries: ${operationName ?? 'unnamed'}');
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          AppLogger.error('All retry attempts failed: ${operationName ?? 'unnamed'}: $e');
          rethrow;
        }

        AppLogger.warning('Attempt $attempts failed, retrying in ${retryDelay.inSeconds}s: $e');
        await Future.delayed(retryDelay);
      }
    }

    throw Exception('Retry logic failed unexpectedly');
  }

  /// Batch process items to avoid overwhelming the system
  static Future<List<R>> processBatch<T, R>(
    List<T> items,
    Future<R> Function(T) processor, {
    int batchSize = 10,
    Duration batchDelay = const Duration(milliseconds: 100),
    String? operationName,
  }) async {
    final results = <R>[];

    AppLogger.debug('Processing ${items.length} items in batches of $batchSize: ${operationName ?? 'unnamed'}');

    for (int i = 0; i < items.length; i += batchSize) {
      final batch = items.skip(i).take(batchSize).toList();

      AppLogger.debug('Processing batch ${(i ~/ batchSize) + 1}: ${batch.length} items');

      final batchResults = await Future.wait(
        batch.map((item) => processor(item)),
      );

      results.addAll(batchResults);

      // Add delay between batches to prevent overwhelming
      if (i + batchSize < items.length) {
        await Future.delayed(batchDelay);
      }
    }

    AppLogger.debug('Completed batch processing: ${results.length} results');
    return results;
  }

  /// Dispose resources
  static void dispose() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _lastThrottleCall = null;
  }
}
