import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import '../search_page.dart';
import '../widgets/forum_actions.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';

class ForumsTabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final SiteContext siteContext;
  const ForumsTabAppBar({
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
        AppLocalizations.of(context)?.forums ?? 'Forums',
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: DesignTokens.fontSizeL,
        ),
      ),
      centerTitle: false,
      actions: [
        if (isLoggedIn) _buildSearchButton(context, colorScheme),
        if (isLoggedIn) _buildMarkReadButton(context, colorScheme),
      ],
    );
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

  Widget _buildMarkReadButton(BuildContext context, ColorScheme colorScheme) {
    return IconButton(
      icon: const Icon(Icons.done_all_rounded),
      tooltip: AppLocalizations.of(context)?.markForumRead ?? 'Mark Forum Read',
      onPressed: () => _showMarkReadConfirmation(context),
    );
  }

  void _showMarkReadConfirmation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)?.markAllForumsAsRead ?? 'Mark All Forums as Read?',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)?.markAllForumsAsReadMessage ?? 'This will mark all forums and topics as read. This action cannot be undone.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)?.cancel ?? 'Cancel',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ForumActions().markAllAsRead(context, '0');
            },
            child: Text(
              AppLocalizations.of(context)?.markAsRead ?? 'Mark as Read',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
