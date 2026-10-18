import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/utils/error_dialog.dart';
import 'package:forumcopilot_flutter/views/forum_topics_page.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_password_dialog.dart';
import 'package:forumcopilot_flutter/controllers/global_loader_controller.dart';
import 'package:forumcopilot_flutter/controllers/topic_controller.dart';
import '../../utils/snackbar_helper.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../utils/app_navigation.dart';

class ForumActions {
  /// Whether the visitor can search [siteContext]'s forum: members, and
  /// guests where the forum lets guests search.
  static bool canSearch(SiteContext siteContext) =>
      siteContext.isLoggedIn || (siteContext.configDataOutput?.guestSearch ?? false);

  /// Asks, then marks every forum read (the Home and Forums tabs' action).
  static Future<void> confirmMarkAllRead(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(
            l10n.markAllForumsAsRead,
            style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
          ),
          content: Text(
            l10n.markAllForumsAsReadMessage,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel, style: TextStyle(color: colorScheme.onSurfaceVariant)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.markAsRead, style: TextStyle(color: colorScheme.primary)),
            ),
          ],
        );
      },
    );
    if (confirmed == true && context.mounted) {
      await ForumActions().markAllAsRead(context, '0');
    }
  }

  // Track if markAllAsRead is currently in progress to prevent concurrent calls
  // Static to prevent concurrent calls across all instances
  static bool _isMarkingAsRead = false;

  Future<void> markAllAsRead(BuildContext context, String forumId) async {
    // Prevent concurrent calls
    if (_isMarkingAsRead) {
      return;
    }

    _isMarkingAsRead = true;
    try {
      final forumProxy = SiteProxyFactory.getForumProxy();
      final result = await forumProxy.markAllAsRead(forumId);

      // Check if context is still valid before using it
      if (!context.mounted) {
        return;
      }

      if (result.result) {
        // Mark all as read was successful - reset the Unread page topic list
        if (Get.isRegistered<UnreadTopicController>()) {
          final unreadController = Get.find<UnreadTopicController>();
          await unreadController.resetAndReload();
        }

        // Double-check context is still valid before showing snackbar
        if (context.mounted) {
          try {
            SnackbarHelper.showInfo(context, AppLocalizations.of(context).allForumTopicsMarkedRead);
          } catch (e) {
            // Context became invalid between mounted check and usage
            // Silently ignore - the operation succeeded, just can't show UI feedback
          }
        }
      } else {
        showErrorDialog('Failed to mark all as read: ${result.resultText}');
      }
    } catch (e) {
      showErrorDialog('Failed to mark all as read: ' + e.toString());
    } finally {
      _isMarkingAsRead = false;
    }
  }

  /// Handles entrance to a protected forum by showing password dialog and handling login
  Future<void> enterProtectedForum(BuildContext context, SiteContext siteContext, FCForum forum, {VoidCallback? onSuccess}) async {
    showDialog(
      context: context,
      builder: (context) => ForumPasswordDialog(
        forumName: forum.name,
        onPasswordSubmitted: (password) async {
          await _loginToProtectedForum(context, siteContext, forum, password, onSuccess: onSuccess);
        },
      ),
    );
  }

  /// Performs the actual login to a protected forum
  Future<void> _loginToProtectedForum(BuildContext context, SiteContext siteContext, FCForum forum, String password, {VoidCallback? onSuccess}) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final forumProxy = SiteProxyFactory.getForumProxy();

      final loginResult = await forumProxy.loginForum(forum.id, password);

      // Close loading dialog
      Get.back();

      if (loginResult.result) {
        // Login successful
        if (onSuccess != null) {
          onSuccess();
        } else {
          // Default behavior: navigate to forum topics page
          AppNavigation.pushGlobal(ForumTopicsPage(forum: forum, siteContext: siteContext), name: '/ForumTopicsPage');
        }
      } else {
        // Login failed, show error message
        _showErrorDialog(context, 'Invalid password. Please try again.');
      }
    } catch (e) {
      // Close loading dialog if it's still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show error message
      _showErrorDialog(context, 'Failed to login to forum: ${e.toString()}');
    }
  }

  /// Shows an error dialog with the given message
  void _showErrorDialog(BuildContext context, String message) {
    // Hide any active loader before showing error dialog
    try {
      if (Get.isRegistered<GlobalLoaderController>()) {
        GlobalLoaderController.to.hide();
      }
    } catch (e) {
      // Ignore if GlobalLoaderController is not available
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).loginFailed,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          message,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              AppLocalizations.of(context).okButton,
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
