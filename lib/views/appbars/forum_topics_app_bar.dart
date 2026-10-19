import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/appbars/base_forum_app_bar.dart';

class ForumTopicsAppBar extends BaseForumAppBar {
  const ForumTopicsAppBar({
    required String title,
    required this.forumId,
    this.onShare,
    this.onSubscribe,
    this.onMarkRead,
    this.isSubscribed = false,
    this.showMarkRead = false,
    this.isLoggedIn = false,
    this.canSubscribe = false,
    super.key,
  }) : super(title: title);

  final String forumId;
  final VoidCallback? onShare;
  final VoidCallback? onSubscribe;
  final VoidCallback? onMarkRead;
  final bool isSubscribed;
  final bool showMarkRead;
  final bool isLoggedIn;
  final bool canSubscribe;

  @override
  List<Widget> buildActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final actions = <Widget>[];

    // Check if we have any menu items to show (only if logged in)
    final hasSubscribe = isLoggedIn && onSubscribe != null && canSubscribe;
    final hasMarkRead = isLoggedIn && showMarkRead && onMarkRead != null;
    // New Topic is the page's floating button, not a menu item.
    final hasMenuItems = hasSubscribe || hasMarkRead;

    // Only add menu button if there are items to show
    if (hasMenuItems) {
      actions.add(
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded),
          tooltip: AppLocalizations.of(context).moreOptions,
          onSelected: (value) {
            switch (value) {
              case 'subscribe':
                onSubscribe?.call();
                break;
              case 'mark_read':
                onMarkRead?.call();
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            if (hasSubscribe)
              PopupMenuItem<String>(
                value: 'subscribe',
                child: Row(
                  children: [
                    Icon(
                      isSubscribed ? Icons.watch_rounded : Icons.watch_outlined,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isSubscribed ? AppLocalizations.of(context).unsubscribe : AppLocalizations.of(context).subscribe,
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            if (hasMarkRead)
              PopupMenuItem<String>(
                value: 'mark_read',
                child: Row(
                  children: [
                    Icon(Icons.visibility_off_rounded, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context).markRead, style: textTheme.bodyLarge),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    return actions;
  }
}
