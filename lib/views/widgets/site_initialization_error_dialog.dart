import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';
import '../../l10n/generated/app_localizations.dart';

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
    final title = isTimeoutError ? AppLocalizations.of(context).connectionTimeoutTitle : AppLocalizations.of(context).connectionFailed;
    final message = isTimeoutError 
        ? AppLocalizations.of(context).connectionTimedOutTo(site.name)
        : AppLocalizations.of(context).failedToConnectCheckPlugin(site.name);

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
                AppLocalizations.of(context).okButton,
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
