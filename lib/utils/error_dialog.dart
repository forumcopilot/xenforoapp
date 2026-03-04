import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import '../controllers/global_loader_controller.dart';
import '../theme/design_tokens.dart';

/// Extracts a user-friendly error message from an exception
/// For FCApiException, returns the message property
/// For other exceptions, returns a formatted string
String extractErrorMessage(dynamic error) {
  if (error is FCApiException) {
    return error.message;
  }
  // For other exceptions, try to extract a meaningful message
  final errorString = error.toString();
  // Remove "Exception:" prefix if present
  if (errorString.contains(':')) {
    final parts = errorString.split(':');
    if (parts.length > 1) {
      return parts.sublist(1).join(':').trim();
    }
  }
  return errorString;
}

void showErrorDialog(String errorMessage) {
  // Show error dialog in both debug and production mode
  // Hide any active loader before showing error dialog
  try {
    if (Get.isRegistered<GlobalLoaderController>()) {
      GlobalLoaderController.to.hide();
    }
  } catch (e) {
    // Ignore if GlobalLoaderController is not available
  }

  // Hide any active loader before showing error dialog
  try {
    if (Get.isRegistered<GlobalLoaderController>()) {
      GlobalLoaderController.to.hide();
    }
  } catch (e) {
    // Ignore if GlobalLoaderController is not available
  }
  // Defer dialog presentation to avoid Navigator lock assertion during transitions
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (Get.isDialogOpen == true) {
      return; // Avoid stacking multiple error dialogs
    }
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context) : null;
    Get.dialog(
      AlertDialog(
        backgroundColor: Get.theme.colorScheme.surface,
        title: Text(
          l10n?.errorTitle ?? "Error",
          style: TextStyle(
            color: Get.theme.colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Padding(
          padding: DesignTokens.paddingS,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Get.theme.colorScheme.onSurface,
                ),
              ),
              if (kDebugMode) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.copy_rounded,
                    color: Get.theme.colorScheme.onPrimary,
                  ),
                  label: Text(
                    l10n?.copyToClipboard ?? "Copy to Clipboard",
                    style: TextStyle(
                      color: Get.theme.colorScheme.onPrimary,
                    ),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: errorMessage));
                    // Defer snackbar to next frame as well, for safety
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Get.snackbar(
                        l10n?.copied ?? "Copied",
                        l10n?.errorMessageCopiedToClipboard ?? "Error message copied to clipboard",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Get.theme.colorScheme.surfaceContainerHighest,
                        colorText: Get.theme.colorScheme.onSurface,
                        borderRadius: 8,
                        margin: const EdgeInsets.all(8),
                      );
                    });
                  },
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text(
              l10n?.okButton ?? "OK",
              style: TextStyle(
                color: Get.theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  });
}

/// Shows an error dialog with a user-friendly message extracted from the exception
void showErrorDialogFromException(dynamic error) {
  final errorMessage = extractErrorMessage(error);
  showErrorDialog(errorMessage);
}
