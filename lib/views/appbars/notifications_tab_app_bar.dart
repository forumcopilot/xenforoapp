import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';
import '../../l10n/generated/app_localizations.dart';

class NotificationsTabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final SiteContext siteContext;

  /// "Mark all read" shows while this is true (XenForo add-on 1.11.0+).
  final ValueListenable<bool>? hasUnreadAlerts;
  final VoidCallback? onMarkAllRead;

  const NotificationsTabAppBar({
    required this.siteContext,
    this.isLoggedIn = false,
    this.hasUnreadAlerts,
    this.onMarkAllRead,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 3,
      shadowColor: colorScheme.shadow.withValues(alpha: DesignTokens.opacityLow),
      surfaceTintColor: colorScheme.surfaceTint,
      automaticallyImplyLeading: false,
      title: Text(
        // As its tab, and as XenForo calls them: Alerts.
        AppLocalizations.of(context).notificationsTab,
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: DesignTokens.fontSizeL,
        ),
      ),
      centerTitle: false,
      actions: [
        if (isLoggedIn && hasUnreadAlerts != null && onMarkAllRead != null)
          ValueListenableBuilder<bool>(
            valueListenable: hasUnreadAlerts!,
            builder: (context, unread, _) => unread
                ? IconButton(
                    icon: const Icon(Icons.done_all_rounded),
                    tooltip: AppLocalizations.of(context).markAllAlertsRead,
                    onPressed: onMarkAllRead,
                  )
                : const SizedBox.shrink(),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
