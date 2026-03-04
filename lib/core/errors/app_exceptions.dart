/// Custom exceptions for the Forum Copilot app
///
/// This file defines all custom exceptions used throughout the application
/// to provide better error handling and user experience.

/// Base exception class for all app-specific exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message';

  static UnknownException unknown(e, [StackTrace? stackTrace]) {
    return UnknownException(
      message: 'An unexpected error occurred. Please try again.',
      code: 'UNKNOWN_ERROR',
      originalError: e,
      stackTrace: stackTrace,
    );
  }
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  /// No internet connection
  static NetworkException noConnection() {
    return const NetworkException(
      message: 'No internet connection. Please check your network settings.',
      code: 'NO_CONNECTION',
    );
  }

  /// Request timeout
  static NetworkException timeout() {
    return const NetworkException(
      message: 'Request timed out. Please try again.',
      code: 'TIMEOUT',
    );
  }

  /// Server error
  static NetworkException serverError(int statusCode, String? message) {
    return NetworkException(
      message: message ?? 'Server error occurred. Please try again later.',
      code: 'SERVER_ERROR_$statusCode',
    );
  }
}

/// Authentication-related exceptions
class AuthenticationException extends AppException {
  const AuthenticationException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  /// Invalid credentials
  static AuthenticationException invalidCredentials() {
    return const AuthenticationException(
      message: 'Invalid username or password.',
      code: 'INVALID_CREDENTIALS',
    );
  }

  /// Session expired
  static AuthenticationException sessionExpired() {
    return const AuthenticationException(
      message: 'Your session has expired. Please log in again.',
      code: 'SESSION_EXPIRED',
    );
  }

  /// Account locked
  static AuthenticationException accountLocked() {
    return const AuthenticationException(
      message: 'Your account has been locked. Please contact support.',
      code: 'ACCOUNT_LOCKED',
    );
  }
}

/// Forum-specific exceptions
class ForumException extends AppException {
  const ForumException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  /// Forum not found
  static ForumException notFound() {
    return const ForumException(
      message: 'Forum not found.',
      code: 'FORUM_NOT_FOUND',
    );
  }

  /// Access denied
  static ForumException accessDenied() {
    return const ForumException(
      message: 'You do not have permission to access this forum.',
      code: 'ACCESS_DENIED',
    );
  }

  /// Forum unavailable
  static ForumException unavailable() {
    return const ForumException(
      message: 'Forum is currently unavailable. Please try again later.',
      code: 'FORUM_UNAVAILABLE',
    );
  }
}

/// Data-related exceptions
class DataException extends AppException {
  const DataException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  /// Data not found
  static DataException notFound() {
    return const DataException(
      message: 'Requested data not found.',
      code: 'DATA_NOT_FOUND',
    );
  }

  /// Data corruption
  static DataException corrupted() {
    return const DataException(
      message: 'Data appears to be corrupted. Please refresh the page.',
      code: 'DATA_CORRUPTED',
    );
  }

  /// Cache error
  static DataException cacheError() {
    return const DataException(
      message: 'Failed to load cached data. Please try again.',
      code: 'CACHE_ERROR',
    );
  }
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  /// Invalid input
  static ValidationException invalidInput(String field) {
    return ValidationException(
      message: 'Invalid $field provided.',
      code: 'INVALID_INPUT',
    );
  }

  /// Required field missing
  static ValidationException requiredField(String field) {
    return ValidationException(
      message: '$field is required.',
      code: 'REQUIRED_FIELD',
    );
  }
}

/// Permission-related exceptions
class PermissionException extends AppException {
  const PermissionException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  /// Permission denied
  static PermissionException denied(String action) {
    return PermissionException(
      message: 'You do not have permission to $action.',
      code: 'PERMISSION_DENIED',
    );
  }

  /// Feature not available
  static PermissionException featureNotAvailable(String feature) {
    return PermissionException(
      message: '$feature is not available on this forum.',
      code: 'FEATURE_NOT_AVAILABLE',
    );
  }
}

/// Storage-related exceptions
class StorageException extends AppException {
  const StorageException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  /// Storage full
  static StorageException full() {
    return const StorageException(
      message: 'Storage is full. Please free up some space.',
      code: 'STORAGE_FULL',
    );
  }

  /// Storage access denied
  static StorageException accessDenied() {
    return const StorageException(
      message: 'Storage access denied. Please check app permissions.',
      code: 'STORAGE_ACCESS_DENIED',
    );
  }
}

/// Unknown or unexpected exceptions
class UnknownException extends AppException {
  const UnknownException({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          code: code,
          originalError: originalError,
          stackTrace: stackTrace,
        );

  /// Create from any error
  static UnknownException fromError(dynamic error, [StackTrace? stackTrace]) {
    return UnknownException(
      message: 'An unexpected error occurred: ${error.toString()}',
      code: 'UNKNOWN_ERROR',
      originalError: error,
      stackTrace: stackTrace,
    );
  }
}
