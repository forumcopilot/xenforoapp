import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Centralized logging system for the Forum Copilot app
///
/// This class provides a unified way to log messages throughout the application,
/// with different log levels and proper formatting.
class AppLogger {
  static const String _tag = 'ForumCopilot';

  /// Log levels
  static const int _levelDebug = 0;
  static const int _levelInfo = 1;
  static const int _levelWarning = 2;
  static const int _levelError = 3;
  static const int _levelFatal = 4;

  static int _currentLevel = kDebugMode ? _levelDebug : _levelInfo;

  /// Initialize the logger
  static void initialize({
    bool enableDebugLogs = kDebugMode,
    bool enableInfoLogs = true,
    bool enableWarningLogs = true,
    bool enableErrorLogs = true,
  }) {
    _currentLevel = enableDebugLogs ? _levelDebug : _levelInfo;

    if (!enableInfoLogs) _currentLevel = _levelWarning;
    if (!enableWarningLogs) _currentLevel = _levelError;
    if (!enableErrorLogs) _currentLevel = _levelFatal;
  }

  /// Set log level
  static void setLogLevel(int level) {
    _currentLevel = level;
  }

  /// Debug level logging
  static void debug(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (_currentLevel <= _levelDebug) {
      _log('🐛', message, tag: tag, error: error, stackTrace: stackTrace);
    }
  }

  /// Info level logging
  static void info(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (_currentLevel <= _levelInfo) {
      _log('ℹ️', message, tag: tag, error: error, stackTrace: stackTrace);
    }
  }

  /// Warning level logging
  static void warning(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (_currentLevel <= _levelWarning) {
      _log('⚠️', message, tag: tag, error: error, stackTrace: stackTrace);
    }
  }

  /// Error level logging
  static void error(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (_currentLevel <= _levelError) {
      _log('❌', message, tag: tag, error: error, stackTrace: stackTrace);
    }
  }

  /// Fatal level logging
  static void fatal(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (_currentLevel <= _levelFatal) {
      _log('💀', message, tag: tag, error: error, stackTrace: stackTrace);
    }
  }

  /// Network logging
  static void network(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (_currentLevel <= _levelDebug) {
      _log('🌐', message, tag: tag ?? 'Network', error: error, stackTrace: stackTrace);
    }
  }

  /// Authentication logging
  static void auth(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (_currentLevel <= _levelInfo) {
      _log('🔐', message, tag: tag ?? 'Auth', error: error, stackTrace: stackTrace);
    }
  }

  /// Database logging
  static void database(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (_currentLevel <= _levelDebug) {
      _log('💾', message, tag: tag ?? 'Database', error: error, stackTrace: stackTrace);
    }
  }

  /// Cache logging
  static void cache(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (_currentLevel <= _levelDebug) {
      _log('🗄️', message, tag: tag ?? 'Cache', error: error, stackTrace: stackTrace);
    }
  }

  /// UI logging
  static void ui(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (_currentLevel <= _levelDebug) {
      _log('🎨', message, tag: tag ?? 'UI', error: error, stackTrace: stackTrace);
    }
  }

  /// Performance logging
  static void performance(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    if (_currentLevel <= _levelInfo) {
      _log('⚡', message, tag: tag ?? 'Performance', error: error, stackTrace: stackTrace);
    }
  }

  /// Internal logging method
  static void _log(
    String emoji,
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? ' [$tag]' : '';
    final logMessage = '$emoji [$timestamp]$tagStr $message';

    // Log to console
    developer.log(
      logMessage,
      name: _tag,
      error: error,
      stackTrace: stackTrace,
    );

    // Print to console in debug mode
    if (kDebugMode) {
      debugPrint(logMessage);
      if (error != null) {
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }
  }

  /// Log method execution time
  static Future<T> logExecutionTime<T>(
    String methodName,
    Future<T> Function() method, {
    String? tag,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      AppLogger.debug('Starting $methodName', tag: tag);
      final result = await method();
      stopwatch.stop();
      AppLogger.performance(
        'Completed $methodName in ${stopwatch.elapsedMilliseconds}ms',
        tag: tag,
      );
      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      AppLogger.error(
        'Failed $methodName after ${stopwatch.elapsedMilliseconds}ms',
        tag: tag,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Log method execution time (synchronous)
  static T logExecutionTimeSync<T>(
    String methodName,
    T Function() method, {
    String? tag,
  }) {
    final stopwatch = Stopwatch()..start();

    try {
      AppLogger.debug('Starting $methodName', tag: tag);
      final result = method();
      stopwatch.stop();
      AppLogger.performance(
        'Completed $methodName in ${stopwatch.elapsedMilliseconds}ms',
        tag: tag,
      );
      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      AppLogger.error(
        'Failed $methodName after ${stopwatch.elapsedMilliseconds}ms',
        tag: tag,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Log API calls
  static void logApiCall(
    String method,
    String url, {
    Map<String, String>? headers,
    dynamic body,
    int? statusCode,
    String? response,
    Duration? duration,
    String? tag,
  }) {
    final durationStr = duration != null ? ' (${duration.inMilliseconds}ms)' : '';
    final statusStr = statusCode != null ? ' [$statusCode]' : '';

    AppLogger.network(
      '$method $url$statusStr$durationStr',
      tag: tag ?? 'API',
    );

    if (kDebugMode) {
      if (headers != null) {
        AppLogger.debug('Headers: $headers', tag: tag ?? 'API');
      }
      if (body != null) {
        AppLogger.debug('Body: $body', tag: tag ?? 'API');
      }
      if (response != null) {
        AppLogger.debug('Response: $response', tag: tag ?? 'API');
      }
    }
  }

  /// Log user actions
  static void logUserAction(
    String action, {
    Map<String, dynamic>? parameters,
    String? tag,
  }) {
    final paramsStr = parameters != null ? ' with params: $parameters' : '';
    AppLogger.info('User action: $action$paramsStr', tag: tag ?? 'User');
  }

  /// Log app lifecycle events
  static void logLifecycle(String event, {String? tag}) {
    AppLogger.info('App lifecycle: $event', tag: tag ?? 'Lifecycle');
  }

  /// Log memory usage
  static void logMemoryUsage({String? tag}) {
    // This is a placeholder - in a real app you might want to use
    // a memory monitoring library
    AppLogger.performance('Memory usage logged', tag: tag ?? 'Memory');
  }

  /// Log network connectivity
  static void logConnectivity(String status, {String? tag}) {
    AppLogger.network('Connectivity: $status', tag: tag ?? 'Connectivity');
  }

  /// Log database operations
  static void logDatabaseOperation(
    String operation,
    String table, {
    int? recordCount,
    Duration? duration,
    String? tag,
  }) {
    final countStr = recordCount != null ? ' ($recordCount records)' : '';
    final durationStr = duration != null ? ' (${duration.inMilliseconds}ms)' : '';

    AppLogger.database(
      '$operation on $table$countStr$durationStr',
      tag: tag ?? 'Database',
    );
  }

  /// Log cache operations
  static void logCacheOperation(
    String operation,
    String key, {
    int? size,
    Duration? duration,
    String? tag,
  }) {
    final sizeStr = size != null ? ' (${size} bytes)' : '';
    final durationStr = duration != null ? ' (${duration.inMilliseconds}ms)' : '';

    AppLogger.cache(
      '$operation cache key "$key"$sizeStr$durationStr',
      tag: tag ?? 'Cache',
    );
  }
}

/// Extension for easy logging on objects
extension ObjectLogger on Object {
  void logDebug(String message, {String? tag}) {
    AppLogger.debug(message, tag: tag ?? runtimeType.toString());
  }

  void logInfo(String message, {String? tag}) {
    AppLogger.info(message, tag: tag ?? runtimeType.toString());
  }

  void logWarning(String message, {String? tag}) {
    AppLogger.warning(message, tag: tag ?? runtimeType.toString());
  }

  void logError(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    AppLogger.error(message, tag: tag ?? runtimeType.toString(), error: error, stackTrace: stackTrace);
  }
}
