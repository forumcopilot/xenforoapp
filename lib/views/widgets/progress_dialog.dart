import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';

/// A simple progress dialog that shows a loading indicator and a message
class ProgressDialog extends StatelessWidget {
  final ValueNotifier<String> messageNotifier;

  const ProgressDialog({
    super.key,
    required this.messageNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      contentPadding: const EdgeInsets.all(24),
      content: ValueListenableBuilder<String>(
        valueListenable: messageNotifier,
        builder: (context, message, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: colorScheme.primary,
              ),
              const SizedBox(height: DesignTokens.spacingL),
              Text(
                message,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }

  /// Show the progress dialog with an updatable message
  /// Returns both the ValueNotifier for updating messages and a close function
  static ({ValueNotifier<String> messageNotifier, Future<void> Function() close}) showWithUpdater(
    BuildContext context,
    String initialMessage,
  ) {
    final messageNotifier = ValueNotifier<String>(initialMessage);
    BuildContext? dialogContext;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        dialogContext = context;
        return ProgressDialog(messageNotifier: messageNotifier);
      },
    );

    // Return both the notifier and a close function
    return (
      messageNotifier: messageNotifier,
      close: () async {
        if (dialogContext != null && Navigator.canPop(dialogContext!)) {
          Navigator.of(dialogContext!).pop();
        }
      },
    );
  }
}
