import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:get/get.dart';
import 'app_exceptions.dart';
import '../../controllers/global_loader_controller.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import '../../utils/snackbar_helper.dart';

/// Centralized error handling system for the Forum Copilot app
///
/// This class provides a unified way to handle errors throughout the application,
/// including logging, user notifications, and crash reporting.
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  /// Whether to show error dialogs to users
  static bool _showErrorDialogs = kDebugMode;

  /// List of error listeners
  static final List<ErrorListener> _listeners = [];

  /// Initialize the error handler
  static Future<void> initialize({
    bool showErrorDialogs = kDebugMode,
  }) async {
    _showErrorDialogs = showErrorDialogs;

    // Setup global error handlers
    FlutterError.onError = (FlutterErrorDetails details) {
      handleError(details.exception, details.stack);
    };

    // Setup platform error handler
    PlatformDispatcher.instance.onError = (error, stack) {
      handleError(error, stack);
      return true;
    };
  }

  /// Handle any error that occurs in the application
  static Future<void> handleError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
    bool showToUser = true,
  }) async {
    try {
      // Log the error
      await _logError(error, stackTrace, context);

      // Notify listeners
      _notifyListeners(error, stackTrace, context);

      // Show user-friendly error if requested
      if (showToUser && _showErrorDialogs) {
        await _showUserFriendlyError(error, context);
      }
    } catch (e) {
      // Fallback error handling to prevent infinite loops
      developer.log('Error in error handler: $e', name: 'ErrorHandler');
    }
  }

  /// Handle specific app exceptions
  static Future<void> handleAppException(
    AppException exception, {
    String? context,
    bool showToUser = true,
  }) async {
    await handleError(exception, exception.stackTrace, context: context, showToUser: showToUser);
  }

  /// Handle network errors
  static Future<void> handleNetworkError(
    dynamic error, {
    String? context,
    bool showToUser = true,
  }  ) async {
    AppException appException;

    // Existing error handling logic
    if (error is NetworkException) {
      appException = error;
    } else {
      // Convert generic network errors to our exception types
      final message = error.toString().toLowerCase();

      if (message.contains('timeout') || message.contains('timed out')) {
        appException = NetworkException.timeout();
      } else if (message.contains('connection') || message.contains('network') || message.contains('socket') || message.contains('failed host lookup')) {
        appException = NetworkException.noConnection();
      } else {
        appException = NetworkException(
          message: 'Network error occurred. Please try again.',
          code: 'NETWORK_ERROR',
          originalError: error,
        );
      }
    }

    await handleAppException(appException, context: context, showToUser: showToUser);
  }

  /// Handle authentication errors
  static Future<void> handleAuthError(
    dynamic error, {
    String? context,
    bool showToUser = true,
  }) async {
    AppException appException;

    if (error is AuthenticationException) {
      appException = error;
    } else {
      final message = error.toString().toLowerCase();

      if (message.contains('invalid') || message.contains('incorrect')) {
        appException = AuthenticationException.invalidCredentials();
      } else if (message.contains('expired') || message.contains('session')) {
        appException = AuthenticationException.sessionExpired();
      } else if (message.contains('locked') || message.contains('banned')) {
        appException = AuthenticationException.accountLocked();
      } else {
        appException = AuthenticationException(
          message: 'Authentication failed. Please try again.',
          code: 'AUTH_ERROR',
          originalError: error,
        );
      }
    }

    await handleAppException(appException, context: context, showToUser: showToUser);
  }

  /// Handle forum-specific errors
  static Future<void> handleForumError(
    dynamic error, {
    String? context,
    bool showToUser = true,
  }) async {
    AppException appException;

    if (error is ForumException) {
      appException = error;
    } else {
      final message = error.toString().toLowerCase();

      if (message.contains('not found') || message.contains('404')) {
        appException = ForumException.notFound();
      } else if (message.contains('permission') || message.contains('access')) {
        appException = ForumException.accessDenied();
      } else if (message.contains('unavailable') || message.contains('maintenance')) {
        appException = ForumException.unavailable();
      } else {
        appException = ForumException(
          message: 'Forum error occurred. Please try again.',
          code: 'FORUM_ERROR',
          originalError: error,
        );
      }
    }

    await handleAppException(appException, context: context, showToUser: showToUser);
  }

  /// Log error to console and debug output
  static Future<void> _logError(
    dynamic error,
    StackTrace? stackTrace,
    String? context,
  ) async {
    final timestamp = DateTime.now().toIso8601String();
    final contextStr = context != null ? ' [$context]' : '';

    developer.log(
      'Error$contextStr: $error',
      name: 'ErrorHandler',
      error: error,
      stackTrace: stackTrace,
    );

    if (kDebugMode) {
      AppLogger.debug('🐛 [$timestamp]$contextStr Error: $error');
      if (stackTrace != null) {
        AppLogger.debug('🐛 Stack trace: $stackTrace');
      }
    }
  }

  /// Notify error listeners
  static void _notifyListeners(
    dynamic error,
    StackTrace? stackTrace,
    String? context,
  ) {
    for (final listener in _listeners) {
      try {
        listener.onError(error, stackTrace, context);
      } catch (e) {
        developer.log('Error in error listener: $e', name: 'ErrorHandler');
      }
    }
  }

  /// Show user-friendly error message
  static Future<void> _showUserFriendlyError(
    dynamic error,
    String? context,
  ) async {
    // `context` above is the place the error came from, not a BuildContext.
    final buildContext = Get.context;
    final l10n = buildContext != null ? AppLocalizations.of(buildContext) : null;
    String message = l10n?.unexpectedErrorOccurred ?? 'An unexpected error occurred. Please try again.';
    String title = l10n?.errorTitle ?? 'Error';
    bool showRetry = true;

    if (error is AppException) {
      message = l10n != null ? _localizedMessage(error, l10n) : error.message;

      // Customize title and retry option based on error type
      if (error is NetworkException) {
        title = l10n?.connectionErrorTitle ?? 'Connection Error';
        showRetry = true;
      } else if (error is AuthenticationException) {
        title = l10n?.authenticationErrorTitle ?? 'Authentication Error';
        showRetry = error.code != 'ACCOUNT_LOCKED';
      } else if (error is ForumException) {
        title = l10n?.forumError ?? 'Forum Error';
        showRetry = error.code != 'ACCESS_DENIED';
      } else if (error is PermissionException) {
        title = l10n?.permissionErrorTitle ?? 'Permission Error';
        showRetry = false;
      }
    }

    // Show error dialog
    await _showErrorDialog(title, message, showRetry: showRetry);
  }

  /// [error]'s message in the reader's language. Exceptions carry English for
  /// the logs; a message the server wrote passes through as it is.
  static String _localizedMessage(AppException error, AppLocalizations l10n) {
    final code = error.code ?? '';
    if (code.startsWith('SERVER_ERROR_')) {
      return error.message == NetworkException.defaultServerErrorMessage ? l10n.errorServer : error.message;
    }
    switch (code) {
      case 'UNKNOWN_ERROR':
        return l10n.unexpectedErrorOccurred;
      case 'NO_CONNECTION':
        return l10n.errorNoConnection;
      case 'TIMEOUT':
        return l10n.errorTimeout;
      case 'NETWORK_ERROR':
        return l10n.errorNetwork;
      case 'INVALID_CREDENTIALS':
        return l10n.errorInvalidCredentials;
      case 'SESSION_EXPIRED':
        return l10n.errorSessionExpired;
      case 'ACCOUNT_LOCKED':
        return l10n.errorAccountLocked;
      case 'AUTH_ERROR':
        return l10n.errorAuthFailed;
      case 'FORUM_NOT_FOUND':
        return l10n.errorForumNotFound;
      case 'ACCESS_DENIED':
        return l10n.errorForumAccessDenied;
      case 'FORUM_UNAVAILABLE':
        return l10n.errorForumUnavailable;
      case 'FORUM_ERROR':
        return l10n.errorForumGeneric;
      case 'DATA_NOT_FOUND':
        return l10n.errorDataNotFound;
      case 'DATA_CORRUPTED':
        return l10n.errorDataCorrupted;
      case 'CACHE_ERROR':
        return l10n.errorCache;
      case 'INVALID_INPUT':
        return l10n.errorInvalidInput;
      case 'REQUIRED_FIELD':
        return l10n.errorRequiredField;
      case 'PERMISSION_DENIED':
        return l10n.errorPermissionDenied;
      case 'FEATURE_NOT_AVAILABLE':
        final feature = error is PermissionException ? error.feature : null;
        return feature != null ? l10n.errorFeatureNotAvailable(feature) : error.message;
      case 'STORAGE_FULL':
        return l10n.errorStorageFull;
      case 'STORAGE_ACCESS_DENIED':
        return l10n.errorStorageAccessDenied;
      default:
        return error.message;
    }
  }

  /// Show error dialog to user
  static Future<void> _showErrorDialog(
    String title,
    String message, {
    bool showRetry = true,
  }) async {
    try {
      // Hide any active loader before showing error dialog
      try {
        if (Get.isRegistered<GlobalLoaderController>()) {
          GlobalLoaderController.to.hide();
        }
      } catch (e) {
        // Ignore if GlobalLoaderController is not available
      }

      await Get.dialog(
        AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            if (showRetry)
              TextButton(
                onPressed: () {
                  Get.back();
                  // Could trigger a retry mechanism here
                },
                child: Text(AppLocalizations.of(Get.context!).retryButton),
              ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(AppLocalizations.of(Get.context!).okButton),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      // Fallback to snackbar if dialog fails
      if (Get.context case final ctx?) SnackbarHelper.showError(ctx, message);
    }
  }

  /// Add error listener
  static void addListener(ErrorListener listener) {
    _listeners.add(listener);
  }

  /// Remove error listener
  static void removeListener(ErrorListener listener) {
    _listeners.remove(listener);
  }

  /// Clear all listeners
  static void clearListeners() {
    _listeners.clear();
  }

  /// Enable/disable error dialogs
  static void setShowErrorDialogs(bool show) {
    _showErrorDialogs = show;
  }
}

/// Interface for error listeners
abstract class ErrorListener {
  void onError(dynamic error, StackTrace? stackTrace, String? context);
}

/// Utility class for error handling in controllers
class ControllerErrorHandler {
  /// Handle errors in controllers with proper state management
  static Future<void> handleControllerError(
    dynamic error,
    StackTrace? stackTrace, {
    required String controllerName,
    String? operation,
    VoidCallback? onRetry,
  }) async {
    final context = '$controllerName${operation != null ? ' ($operation)' : ''}';

    await ErrorHandler.handleError(
      error,
      stackTrace,
      context: context,
    );

    // If there's a retry callback, make it available
    if (onRetry != null && error is NetworkException) {
      // Could store retry callback for later use
    }
  }
}

/// Utility class for error handling in services
class ServiceErrorHandler {
  /// Handle errors in services with proper logging
  static Future<void> handleServiceError(
    dynamic error,
    StackTrace? stackTrace, {
    required String serviceName,
    String? operation,
  }) async {
    final context = '$serviceName${operation != null ? ' ($operation)' : ''}';

    await ErrorHandler.handleError(
      error,
      stackTrace,
      context: context,
      showToUser: false, // Services typically don't show errors to users directly
    );
  }
}
