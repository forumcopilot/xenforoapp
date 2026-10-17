import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:get/get.dart';
import '../../utils/snackbar_helper.dart';
import '../../views/widgets/empty_state_view.dart';

/// Reusable error widgets for consistent error display throughout the app
class ErrorWidgets {
  /// Show a full-screen error page
  static Widget fullScreenError({
    required BuildContext context,
    required String title,
    required String message,
    String? retryText,
    VoidCallback? onRetry,
    String? helpText,
    VoidCallback? onHelp,
  }) {
    // The shared EmptyStateView's error form; Get help, when offered, is
    // its second action.
    return Scaffold(
      body: SafeArea(
        child: onHelp == null
            ? EmptyStateView.error(message: title, hint: message, onRetry: onRetry)
            : EmptyStateView(
                icon: Icons.error_outline,
                message: title,
                hint: message,
                actions: [
                  if (onRetry != null)
                    OutlinedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: Text(retryText ?? (AppLocalizations.of(context)?.tryAgain ?? 'Try again')),
                    ),
                  TextButton(
                    onPressed: onHelp,
                    child: Text(helpText ?? (AppLocalizations.of(context)?.getHelp ?? 'Get Help')),
                  ),
                ],
              ),
      ),
    );
  }

  /// Show a compact error widget for lists and cards
  static Widget compactError({
    required String message,
    VoidCallback? onRetry,
    bool showIcon = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Get.theme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          if (showIcon) ...[
            Icon(
              Icons.error_outline,
              color: Get.theme.colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                color: Get.theme.colorScheme.error,
              ),
            ),
          ),
          if (onRetry != null)
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              iconSize: 20,
              color: Get.theme.colorScheme.error,
            ),
        ],
      ),
    );
  }

  /// Show an inline error message
  static Widget inlineError({
    required String message,
    VoidCallback? onRetry,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: Get.theme.colorScheme.error,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: Get.theme.textTheme.bodySmall?.copyWith(
                color: Get.theme.colorScheme.error,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRetry,
              child: Icon(
                Icons.refresh,
                size: 16,
                color: Get.theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Show a loading error state
  static Widget loadingError({
    required BuildContext context,
    required String message,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off,
            size: 48,
            color: Get.theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Get.theme.textTheme.bodyLarge?.copyWith(
              color: Get.theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)?.retryButton ?? 'Retry'),
            ),
          ],
        ],
      ),
    );
  }

  /// Show a network error state
  static Widget networkError({
    required BuildContext context,
    VoidCallback? onRetry,
  }) {
    final l10n = AppLocalizations.of(context);
    return fullScreenError(
      context: context,
      title: l10n?.noInternetConnection ?? 'No Internet Connection',
      message: l10n?.checkInternetConnection ?? 'Please check your internet connection and try again.',
      retryText: l10n?.retryButton ?? 'Retry',
      onRetry: onRetry,
    );
  }

  /// Show an authentication error state
  static Widget authError({
    required BuildContext context,
    VoidCallback? onRetry,
    VoidCallback? onLogin,
  }) {
    final l10n = AppLocalizations.of(context);
    return fullScreenError(
      context: context,
      title: l10n?.authenticationRequired ?? 'Authentication Required',
      message: l10n?.pleaseLoginToContinue ?? 'Please log in to continue.',
      retryText: l10n?.logIn ?? 'Log In',
      onRetry: onLogin,
    );
  }

  /// Show a forum error state
  static Widget forumError({
    required BuildContext context,
    required String message,
    VoidCallback? onRetry,
  }) {
    final l10n = AppLocalizations.of(context);
    return fullScreenError(
      context: context,
      title: l10n?.forumError ?? 'Forum Error',
      message: message,
      retryText: l10n?.tryAgain ?? 'Try Again',
      onRetry: onRetry,
    );
  }
}

/// Error widget that can be used in place of other widgets
class ErrorOrChild extends StatelessWidget {
  final bool hasError;
  final String? errorMessage;
  final Widget child;
  final VoidCallback? onRetry;
  final Widget Function(String message, VoidCallback? onRetry)? customErrorBuilder;

  const ErrorOrChild({
    super.key,
    required this.hasError,
    this.errorMessage,
    required this.child,
    this.onRetry,
    this.customErrorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasError) {
      return child;
    }

    final l10n = AppLocalizations.of(context);
    if (customErrorBuilder != null) {
      return customErrorBuilder!(errorMessage ?? (l10n?.anErrorOccurred ?? 'An error occurred'), onRetry);
    }

    return ErrorWidgets.compactError(
      message: errorMessage ?? (l10n?.anErrorOccurred ?? 'An error occurred'),
      onRetry: onRetry,
    );
  }
}

/// Error state widget for GetX controllers
class ObxErrorWidget extends StatelessWidget {
  final RxBool hasError;
  final RxString errorMessage;
  final Widget child;
  final VoidCallback? onRetry;
  final Widget Function(String message, VoidCallback? onRetry)? customErrorBuilder;

  const ObxErrorWidget({
    super.key,
    required this.hasError,
    required this.errorMessage,
    required this.child,
    this.onRetry,
    this.customErrorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => ErrorOrChild(
          hasError: hasError.value,
          errorMessage: errorMessage.value,
          child: child,
          onRetry: onRetry,
          customErrorBuilder: customErrorBuilder,
        ));
  }
}

/// Error boundary widget for catching errors in widget tree
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(dynamic error, StackTrace? stackTrace)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  dynamic _error;
  StackTrace? _stackTrace;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(_error, _stackTrace);
      }

      final l10n = AppLocalizations.of(context);
      return ErrorWidgets.fullScreenError(
        context: context,
        title: l10n?.somethingWentWrong ?? 'Something went wrong',
        message: l10n?.unexpectedErrorOccurred ?? 'An unexpected error occurred. Please try again.',
        onRetry: () {
          setState(() {
            _error = null;
            _stackTrace = null;
          });
        },
      );
    }

    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    // Set up error boundary
    FlutterError.onError = (FlutterErrorDetails details) {
      if (mounted) {
        setState(() {
          _error = details.exception;
          _stackTrace = details.stack;
        });
      }
    };
  }
}

/// Error snackbar utility
class ErrorSnackbar {
  /// Show error snackbar
  static void show({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackPosition position = SnackPosition.BOTTOM,
    VoidCallback? onTap,
  }) {
    if (Get.context case final ctx?) SnackbarHelper.showError(ctx, message);
  }

  /// Show success snackbar
  static void showSuccess({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    if (Get.context case final ctx?) SnackbarHelper.showSuccess(ctx, message);
  }

  /// Show warning snackbar
  static void showWarning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    if (Get.context case final ctx?) SnackbarHelper.showInfo(ctx, message);
  }
}
