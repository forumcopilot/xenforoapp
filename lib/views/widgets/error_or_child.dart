import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/design_tokens.dart';
import '../../l10n/generated/app_localizations.dart';

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
        
        // Default error handling
        return Center(
          child: Padding(
            padding: DesignTokens.paddingXL,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  errorMessage.value,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: DesignTokens.fontSizeM,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
                  onPressed: onRetry,
                ),
              ],
            ),
          ),
        );
      }
      return builder(context);
    });
  }
}
