import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'error_handler.dart';
import 'app_exceptions.dart';
import '../logging/app_logger.dart';

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

  /// Handle network errors specifically
  Future<void> handleNetworkError(
    dynamic error, {
    String? context,
    bool showToUser = true,
  }) async {
    await ErrorHandler.handleNetworkError(
      error,
      context: context ?? runtimeType.toString(),
      showToUser: showToUser,
    );
  }

  /// Handle authentication errors specifically
  Future<void> handleAuthError(
    dynamic error, {
    String? context,
    bool showToUser = true,
  }) async {
    await ErrorHandler.handleAuthError(
      error,
      context: context ?? runtimeType.toString(),
      showToUser: showToUser,
    );
  }

  /// Handle forum errors specifically
  Future<void> handleForumError(
    dynamic error, {
    String? context,
    bool showToUser = true,
  }) async {
    await ErrorHandler.handleForumError(
      error,
      context: context ?? runtimeType.toString(),
      showToUser: showToUser,
    );
  }

  /// Handle app exceptions specifically
  Future<void> handleAppException(
    AppException exception, {
    String? context,
    bool showToUser = true,
  }) async {
    await ErrorHandler.handleAppException(
      exception,
      context: context ?? runtimeType.toString(),
      showToUser: showToUser,
    );
  }
}

/// Mixin for error handling in services
mixin ServiceErrorHandlingMixin {
  /// Handle errors in service methods
  Future<void> handleServiceError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
  }) async {
    await ErrorHandler.handleError(
      error,
      stackTrace,
      context: context ?? runtimeType.toString(),
      showToUser: false, // Services typically don't show errors to users
    );
  }

  /// Handle service errors with retry
  Future<T?> handleServiceErrorWithRetry<T>(
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
          await handleServiceError(e, stackTrace, context: context);
          return fallbackValue;
        }

        AppLogger.warning(
          'Service operation failed, retrying in ${retryDelay.inSeconds}s (attempt $attempts/$maxRetries)',
          tag: context ?? runtimeType.toString(),
        );

        await Future.delayed(retryDelay);
      }
    }

    return fallbackValue;
  }
}

/// Mixin for error handling in widgets
mixin WidgetErrorHandlingMixin {
  /// Handle errors in widget methods
  Future<void> handleWidgetError(
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

  /// Handle widget errors with retry
  Future<T?> handleWidgetErrorWithRetry<T>(
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
          await handleWidgetError(e, stackTrace, context: context);
          return fallbackValue;
        }

        AppLogger.warning(
          'Widget operation failed, retrying in ${retryDelay.inSeconds}s (attempt $attempts/$maxRetries)',
          tag: context ?? runtimeType.toString(),
        );

        await Future.delayed(retryDelay);
      }
    }

    return fallbackValue;
  }
}

/// Mixin for error handling in repositories
mixin RepositoryErrorHandlingMixin {
  /// Handle errors in repository methods
  Future<void> handleRepositoryError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
  }) async {
    await ErrorHandler.handleError(
      error,
      stackTrace,
      context: context ?? runtimeType.toString(),
      showToUser: false, // Repositories typically don't show errors to users
    );
  }

  /// Handle repository errors with retry
  Future<T?> handleRepositoryErrorWithRetry<T>(
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
          await handleRepositoryError(e, stackTrace, context: context);
          return fallbackValue;
        }

        AppLogger.warning(
          'Repository operation failed, retrying in ${retryDelay.inSeconds}s (attempt $attempts/$maxRetries)',
          tag: context ?? runtimeType.toString(),
        );

        await Future.delayed(retryDelay);
      }
    }

    return fallbackValue;
  }
}

/// Mixin for error handling in API clients
mixin ApiErrorHandlingMixin {
  /// Handle errors in API methods
  Future<void> handleApiError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
  }) async {
    await ErrorHandler.handleError(
      error,
      stackTrace,
      context: context ?? runtimeType.toString(),
      showToUser: false, // API clients typically don't show errors to users
    );
  }

  /// Handle API errors with retry
  Future<T?> handleApiErrorWithRetry<T>(
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
          await handleApiError(e, stackTrace, context: context);
          return fallbackValue;
        }

        AppLogger.warning(
          'API operation failed, retrying in ${retryDelay.inSeconds}s (attempt $attempts/$maxRetries)',
          tag: context ?? runtimeType.toString(),
        );

        await Future.delayed(retryDelay);
      }
    }

    return fallbackValue;
  }
}

/// Mixin for error handling in data sources
mixin DataSourceErrorHandlingMixin {
  /// Handle errors in data source methods
  Future<void> handleDataSourceError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
  }) async {
    await ErrorHandler.handleError(
      error,
      stackTrace,
      context: context ?? runtimeType.toString(),
      showToUser: false, // Data sources typically don't show errors to users
    );
  }

  /// Handle data source errors with retry
  Future<T?> handleDataSourceErrorWithRetry<T>(
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
          await handleDataSourceError(e, stackTrace, context: context);
          return fallbackValue;
        }

        AppLogger.warning(
          'Data source operation failed, retrying in ${retryDelay.inSeconds}s (attempt $attempts/$maxRetries)',
          tag: context ?? runtimeType.toString(),
        );

        await Future.delayed(retryDelay);
      }
    }

    return fallbackValue;
  }
}

/// Mixin for error handling in utilities
mixin UtilityErrorHandlingMixin {
  /// Handle errors in utility methods
  Future<void> handleUtilityError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
  }) async {
    await ErrorHandler.handleError(
      error,
      stackTrace,
      context: context ?? runtimeType.toString(),
      showToUser: false, // Utilities typically don't show errors to users
    );
  }

  /// Handle utility errors with retry
  Future<T?> handleUtilityErrorWithRetry<T>(
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
          await handleUtilityError(e, stackTrace, context: context);
          return fallbackValue;
        }

        AppLogger.warning(
          'Utility operation failed, retrying in ${retryDelay.inSeconds}s (attempt $attempts/$maxRetries)',
          tag: context ?? runtimeType.toString(),
        );

        await Future.delayed(retryDelay);
      }
    }

    return fallbackValue;
  }
}

/// Mixin for error handling in models
mixin ModelErrorHandlingMixin {
  /// Handle errors in model methods
  Future<void> handleModelError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
  }) async {
    await ErrorHandler.handleError(
      error,
      stackTrace,
      context: context ?? runtimeType.toString(),
      showToUser: false, // Models typically don't show errors to users
    );
  }

  /// Handle model errors with retry
  Future<T?> handleModelErrorWithRetry<T>(
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
          await handleModelError(e, stackTrace, context: context);
          return fallbackValue;
        }

        AppLogger.warning(
          'Model operation failed, retrying in ${retryDelay.inSeconds}s (attempt $attempts/$maxRetries)',
          tag: context ?? runtimeType.toString(),
        );

        await Future.delayed(retryDelay);
      }
    }

    return fallbackValue;
  }
}

/// Mixin for error handling in network clients
mixin NetworkErrorHandlingMixin {
  /// Handle errors in network methods
  Future<void> handleNetworkError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
  }) async {
    await ErrorHandler.handleNetworkError(
      error,
      context: context ?? runtimeType.toString(),
    );
  }

  /// Handle network errors with retry
  Future<T?> handleNetworkErrorWithRetry<T>(
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
          await handleNetworkError(e, stackTrace, context: context);
          return fallbackValue;
        }

        AppLogger.warning(
          'Network operation failed, retrying in ${retryDelay.inSeconds}s (attempt $attempts/$maxRetries)',
          tag: context ?? runtimeType.toString(),
        );

        await Future.delayed(retryDelay);
      }
    }

    return fallbackValue;
  }
}

/// Mixin for error handling in authentication
mixin AuthErrorHandlingMixin {
  /// Handle errors in authentication methods
  Future<void> handleAuthError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
  }) async {
    await ErrorHandler.handleAuthError(
      error,
      context: context ?? runtimeType.toString(),
    );
  }

  /// Handle authentication errors with retry
  Future<T?> handleAuthErrorWithRetry<T>(
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
          await handleAuthError(e, stackTrace, context: context);
          return fallbackValue;
        }

        AppLogger.warning(
          'Authentication operation failed, retrying in ${retryDelay.inSeconds}s (attempt $attempts/$maxRetries)',
          tag: context ?? runtimeType.toString(),
        );

        await Future.delayed(retryDelay);
      }
    }

    return fallbackValue;
  }
}

/// Mixin for error handling in forum operations
mixin ForumErrorHandlingMixin {
  /// Handle errors in forum methods
  Future<void> handleForumError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
  }) async {
    await ErrorHandler.handleForumError(
      error,
      context: context ?? runtimeType.toString(),
    );
  }

  /// Handle forum errors with retry
  Future<T?> handleForumErrorWithRetry<T>(
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
          await handleForumError(e, stackTrace, context: context);
          return fallbackValue;
        }

        AppLogger.warning(
          'Forum operation failed, retrying in ${retryDelay.inSeconds}s (attempt $attempts/$maxRetries)',
          tag: context ?? runtimeType.toString(),
        );

        await Future.delayed(retryDelay);
      }
    }

    return fallbackValue;
  }
}
