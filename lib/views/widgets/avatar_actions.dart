import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/views/user_profile_page.dart';
import 'package:forumcopilot_flutter/views/widgets/post_actions.dart';
import 'package:forumcopilot_flutter/views/login_page.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class AvatarActions {
  void handleAvatarTap(BuildContext context, SiteContext siteContext, String userId, String userName, {PostActionsHandler? postActionsHandler, VoidCallback? onRefresh}) {
    AppLogger.debug('Avatar tapped for user: $userId $userName');

    // Check if user is logged in
    if (!siteContext.isLoggedIn) {
      // Show login popup if not logged in
      if (postActionsHandler != null) {
        postActionsHandler.showPostLoginPrompt(context, onRefresh: onRefresh);
      } else {
        // Fallback to simple login prompt if no postActionsHandler provided
        _showSimpleLoginPrompt(context, siteContext);
      }
      return;
    }

    // Navigate to user profile if logged in
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(
          siteContext: siteContext,
          userId: userId,
          userName: userName,
        ),
      ),
    );
  }

  void _showSimpleLoginPrompt(BuildContext context, SiteContext siteContext) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).loginRequired,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          AppLocalizations.of(context).pleaseLoginToViewProfiles,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context).cancel,
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.to(() => LoginPage(siteContext: siteContext));
            },
            child: Text(
              AppLocalizations.of(context).loginTitle,
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
