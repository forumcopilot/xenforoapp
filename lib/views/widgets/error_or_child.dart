import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'empty_state_view.dart';

class ErrorOrChild extends StatelessWidget {
  final RxBool isError;
  final RxString errorMessage;
  final Widget Function(BuildContext context) builder;
  final VoidCallback? onRetry;
  final Widget? Function(BuildContext context, String errorMessage, VoidCallback? onRetry)? errorBuilder;

  const ErrorOrChild({
    Key? key,
    required this.isError,
    required this.errorMessage,
    required this.builder,
    this.onRetry,
    this.errorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isError.value) {
        // Use custom error builder if provided, otherwise fallback to default
        if (errorBuilder != null) {
          final customErrorWidget = errorBuilder!(context, errorMessage.value, onRetry);
          if (customErrorWidget != null) {
            return customErrorWidget;
          }
        }
        
        // Default: the shared error view with Try again.
        return EmptyStateView.error(message: errorMessage.value, onRetry: onRetry);
      }
      return builder(context);
    });
  }
}
