import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'error_handler.dart';
import 'app_exceptions.dart';
import '../logging/app_logger.dart';

/// Initialize the error handling system for the Forum Copilot app
class ErrorHandlingInit {
  static bool _initialized = false;

  /// Initialize the error handling system
  static Future<void> initialize({
    bool enableErrorDialogs = kDebugMode,
    bool enableDebugLogs = kDebugMode,
  }) async {
    if (_initialized) {
      AppLogger.warning('Error handling system already initialized');
      return;
    }

    try {
      AppLogger.info('Initializing error handling system...');

      // Initialize the logger first
      AppLogger.initialize(
        enableDebugLogs: enableDebugLogs,
        enableInfoLogs: true,
        enableWarningLogs: true,
        enableErrorLogs: true,
      );

      // Initialize the error handler
      await ErrorHandler.initialize(
        showErrorDialogs: enableErrorDialogs,
      );

      // Setup global error handlers
      await _setupGlobalErrorHandlers();

      _initialized = true;
      AppLogger.info('Error handling system initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.fatal(
        'Failed to initialize error handling system',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Setup global error handlers
  static Future<void> _setupGlobalErrorHandlers() async {
    try {
      // Add error listener for logging
      ErrorHandler.addListener(_ErrorLogger());

      AppLogger.info('Global error handlers setup completed');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to setup global error handlers',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Check if error handling is initialized
  static bool get isInitialized => _initialized;

  /// Reset initialization state (for testing)
  static void reset() {
    _initialized = false;
    ErrorHandler.clearListeners();
  }
}

/// Error logger that logs all errors
class _ErrorLogger implements ErrorListener {
  @override
  void onError(dynamic error, StackTrace? stackTrace, String? context) {
    if (error is AppException) {
      AppLogger.error(
        'App Exception: ${error.message}',
        tag: context ?? 'ErrorLogger',
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      AppLogger.error(
        'Unexpected Error: ${error.toString()}',
        tag: context ?? 'ErrorLogger',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

/// Utility class for error handling in different contexts
class ErrorHandlingUtils {
  /// Handle errors in async operations
  static Future<T?> handleAsync<T>(
    Future<T> Function() operation, {
    String? context,
    T? fallbackValue,
    bool showToUser = true,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      await ErrorHandler.handleError(
        e,
        stackTrace,
        context: context,
        showToUser: showToUser,
      );
      return fallbackValue;
    }
  }

  /// Handle errors in sync operations
  static T? handleSync<T>(
    T Function() operation, {
    String? context,
    T? fallbackValue,
    bool showToUser = true,
  }) {
    try {
      return operation();
    } catch (e, stackTrace) {
      ErrorHandler.handleError(
        e,
        stackTrace,
        context: context,
        showToUser: showToUser,
      );
      return fallbackValue;
    }
  }

  /// Handle errors in stream operations
  static Stream<T> handleStream<T>(
    Stream<T> stream, {
    String? context,
    T? fallbackValue,
    bool showToUser = true,
  }) {
    return stream.handleError((error, stackTrace) {
      ErrorHandler.handleError(
        error,
        stackTrace,
        context: context,
        showToUser: showToUser,
      );
    });
  }

  /// Handle errors in widget building
  static Widget handleWidget(
    Widget Function() builder, {
    String? context,
    Widget? fallbackWidget,
    bool showToUser = true,
  }) {
    try {
      return builder();
    } catch (e, stackTrace) {
      ErrorHandler.handleError(
        e,
        stackTrace,
        context: context,
        showToUser: showToUser,
      );
      return fallbackWidget ?? const SizedBox.shrink();
    }
  }
}

/// Mixin for error handling in controllers
mixin ErrorHandlingMixin {
  /// Handle errors in controller methods
  Future<void> handleError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
    bool showToUser = true,
  }) async {
    await ErrorHandler.handleError(
      error,
      stackTrace,
      context: context ?? runtimeType.toString(),
      showToUser: showToUser,
    );
  }

  /// Handle errors with retry
  Future<T?> handleErrorWithRetry<T>(
    Future<T> Function() operation, {
    String? context,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
    T? fallbackValue,
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e, stackTrace) {
        attempts++;

        if (attempts >= maxRetries) {
          await handleError(e, stackTrace, context: context);
          return fallbackValue;
        }

        AppLogger.warning(
          'Operation failed, retrying in ${retryDelay.inSeconds}s (attempt $attempts/$maxRetries)',
          tag: context ?? runtimeType.toString(),
        );

        await Future.delayed(retryDelay);
      }
    }

    return fallbackValue;
  }
}

/// Extension for easy error handling on Future
extension FutureErrorHandling<T> on Future<T> {
  /// Handle errors in Future operations
  Future<T?> handleError({
    String? context,
    T? fallbackValue,
    bool showToUser = true,
  }) async {
    try {
      return await this;
    } catch (e, stackTrace) {
      await ErrorHandler.handleError(
        e,
        stackTrace,
        context: context,
        showToUser: showToUser,
      );
      return fallbackValue;
    }
  }
}
