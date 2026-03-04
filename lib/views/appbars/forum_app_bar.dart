import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/controllers/site_controller.dart';
import 'package:forumcopilot_flutter/controllers/login_controller.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:get/get.dart';
import '../search_page.dart';
import '../members_page.dart';
import '../login_page.dart';
import '../register_page.dart';
import '../widgets/forum_actions.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';

class ForumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final SiteContext siteContext;
  const ForumAppBar({
    required this.siteContext,
    this.isLoggedIn = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final siteController = Get.isRegistered<SiteController>() ? Get.find<SiteController>() : Get.put(SiteController());

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 3,
      shadowColor: colorScheme.shadow.withOpacity(DesignTokens.opacityLow),
      surfaceTintColor: colorScheme.surfaceTint,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Obx(() {
        final site = siteController.currentSite.value;
        final forumName = site?.name ?? (AppLocalizations.of(context)?.forum ?? "Forum");
        final domain = _extractDomain(site?.url);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              forumName,
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: DesignTokens.fontSizeL,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (domain != null && domain.isNotEmpty)
              Text(
                domain,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: DesignTokens.fontSizeXS,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        );
      }),
      centerTitle: false,
      actions: [
        if (isLoggedIn) _buildSearchButton(context, colorScheme),
        if (isLoggedIn) _buildMembersButton(context, colorScheme),
        _buildMenuButton(context, colorScheme, textTheme),
      ],
    );
  }

  String? _extractDomain(String? url) {
    if (url == null || url.isEmpty) return null;
    try {
      return Uri.parse(url).host;
    } catch (e) {
      return url;
    }
  }

  Widget _buildSearchButton(BuildContext context, ColorScheme colorScheme) {
    return IconButton(
      icon: const Icon(Icons.manage_search_rounded),
      tooltip: AppLocalizations.of(context)?.search ?? 'Search',
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SearchPage(siteContext: siteContext)),
      ),
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

  Widget _buildMenuButton(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded),
      tooltip: AppLocalizations.of(context)?.moreOptions ?? 'More options',
      onSelected: (value) => _handleMenuAction(context, value),
      itemBuilder: (context) {
        if (isLoggedIn) {
          // Show logged-in menu items
          return [
            _buildMenuItem('mark_read', Icons.visibility_off_rounded, AppLocalizations.of(context)?.markForumRead ?? 'Mark Forum Read', colorScheme, textTheme),
            _buildMenuItem('notification_test', Icons.notifications_active_rounded, AppLocalizations.of(context)?.notificationTest ?? 'Notification Test', colorScheme, textTheme),
            _buildMenuItem('logout', Icons.logout_rounded, AppLocalizations.of(context)?.logout ?? 'Logout', colorScheme, textTheme, isDestructive: true),
          ];
        } else {
          // Show sign-in/register menu items when not logged in
          return [
            _buildMenuItem('sign_in', Icons.login_rounded, AppLocalizations.of(context)?.signIn ?? 'Sign In', colorScheme, textTheme),
            _buildMenuItem('register', Icons.person_add_rounded, AppLocalizations.of(context)?.register ?? 'Register', colorScheme, textTheme),
          ];
        }
      },
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    IconData icon,
    String label,
    ColorScheme colorScheme,
    TextTheme textTheme, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? colorScheme.error : colorScheme.onSurfaceVariant;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(label, style: textTheme.bodyLarge?.copyWith(color: isDestructive ? colorScheme.error : null)),
        ],
      ),
    );
  }

  Future<void> _handleMenuAction(BuildContext context, String value) async {
    switch (value) {
      case 'sign_in':
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage(siteContext: siteContext)));
        break;
      case 'register':
        Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage(siteContext: siteContext)));
        break;
      case 'mark_read':
        ForumActions().markAllAsRead(context, '0');
        break;
      case 'logout':
        final loginController = Get.isRegistered<LoginController>() ? Get.find<LoginController>() : Get.put(LoginController());
        await loginController.handleLogout(siteContext);
        break;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
