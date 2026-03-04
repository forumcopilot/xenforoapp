import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/services/site_initialization_service.dart';
import 'package:forumcopilot_flutter/views/widgets/progress_dialog.dart';
import 'package:forumcopilot_flutter/views/widgets/site_initialization_error_dialog.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';

/// Helper class for site initialization with progress dialog and error handling
class SiteInitializationHelper {
  /// Initialize a site with progress dialog and error handling
  /// Returns the initialized SiteContext if successful, null otherwise
  static Future<SiteContext?> initializeWithProgress(
    BuildContext context,
    Site site,
  ) async {
    // Get domain name for progress message
    final domainName = Uri.tryParse(site.url)?.host ?? site.url;
    
    // Show progress dialog with initial message
    final progress = ProgressDialog.showWithUpdater(
      context,
      AppLocalizations.of(context)?.connectingTo(domainName) ?? 'Connecting to $domainName...',
    );

    try {
      // Initialize site using the centralized service
      final result = await SiteInitializationService.initializeSite(
        site,
        onProgress: (message) {
          progress.messageNotifier.value = message;
        },
        localize: (key, [fallback]) {
          final l10n = AppLocalizations.of(context);
          switch (key) {
            case 'loggingIn':
              return l10n?.loggingIn ?? fallback ?? '';
            default:
              return fallback ?? '';
          }
        },
      );

      // Close progress dialog
      await progress.close();

      if (result.success && result.siteContext != null) {
        return result.siteContext;
      } else {
        // Show error dialog
        if (context.mounted) {
          SiteInitializationErrorDialog.show(
            context,
            site,
            result.errorMessage ?? 'Unknown error occurred',
          );
        }
        return null;
      }
    } catch (e) {
      // Close progress dialog
      await progress.close();

      // Show error dialog
      if (context.mounted) {
        SiteInitializationErrorDialog.show(
          context,
          site,
          e.toString(),
        );
      }
      return null;
    }
  }
}
