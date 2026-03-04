import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';

/// Utility class for showing site initialization error dialogs
class SiteInitializationErrorDialog {
  /// Show an error dialog for site initialization failure
  static void show(
    BuildContext context,
    Site site,
    String error,
  ) {
    final isTimeoutError = error.toLowerCase().contains('timeout') || 
                          error.toLowerCase().contains('timed out');
    final title = isTimeoutError ? 'Connection Timeout' : 'Connection Failed';
    final message = isTimeoutError 
        ? 'The connection to ${site.name} timed out. Please check your internet connection and try again.'
        : 'Failed to connect to ${site.name}. Please check if the forum is available and the plugin is installed.';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        final textTheme = Theme.of(dialogContext).textTheme;

        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.error,
              fontWeight: DesignTokens.fontWeightSemiBold,
            ),
          ),
          content: Text(
            message,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'OK',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
