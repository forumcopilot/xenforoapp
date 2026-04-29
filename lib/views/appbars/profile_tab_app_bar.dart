import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:get/get.dart';
import '../members_page.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';

class ProfileTabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final SiteContext siteContext;
  const ProfileTabAppBar({
    required this.siteContext,
    this.isLoggedIn = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 3,
      shadowColor: colorScheme.shadow.withOpacity(DesignTokens.opacityLow),
      surfaceTintColor: colorScheme.surfaceTint,
      automaticallyImplyLeading: false,
      title: Text(
        AppLocalizations.of(context)?.profile ?? 'Profile',
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: DesignTokens.fontSizeL,
        ),
      ),
      centerTitle: false,
      actions: [
        if (isLoggedIn) _buildMembersButton(context, colorScheme),
        if (isLoggedIn) _buildLogoutButton(context, colorScheme),
      ],
    );
  }

  Widget _buildMembersButton(BuildContext context, ColorScheme colorScheme) {
    return IconButton(
      icon: const Icon(Icons.people_alt_rounded),
      tooltip: AppLocalizations.of(context)?.members ?? 'Members',
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MembersPage(siteContext: siteContext)),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, ColorScheme colorScheme) {
    return IconButton(
      icon: const Icon(Icons.logout_rounded),
      tooltip: AppLocalizations.of(context)?.logout ?? 'Logout',
      onPressed: () => _showLogoutConfirmation(context, colorScheme),
    );
  }

  void _showLogoutConfirmation(BuildContext context, ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(
            AppLocalizations.of(context)?.logout ?? 'Logout',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)?.areYouSureYouWantToLogout ?? 'Are you sure you want to logout?',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppLocalizations.of(context)?.cancel ?? 'Cancel',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final loginController = Get.isRegistered<LoginController>() ? Get.find<LoginController>() : Get.put(LoginController());
                await loginController.handleLogout(siteContext);
              },
              child: Text(
                AppLocalizations.of(context)?.logout ?? 'Logout',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
