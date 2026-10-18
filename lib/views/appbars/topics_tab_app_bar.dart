import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import '../search_page.dart';
import '../widgets/forum_actions.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';
import '../../utils/app_navigation.dart';

/// The Home tab's bar. Search is offered to guests where the forum lets
/// them search; New Topic is the floating button.
class TopicsTabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final SiteContext siteContext;
  const TopicsTabAppBar({
    required this.siteContext,
    this.isLoggedIn = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 3,
      shadowColor: colorScheme.shadow.withValues(alpha: DesignTokens.opacityLow),
      surfaceTintColor: colorScheme.surfaceTint,
      automaticallyImplyLeading: false,
      title: Text(
        l10n.home,
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: DesignTokens.fontSizeL,
        ),
      ),
      centerTitle: false,
      actions: [
        if (ForumActions.canSearch(siteContext))
          IconButton(
            icon: const Icon(Icons.manage_search_rounded),
            tooltip: l10n.search,
            onPressed: () => AppNavigation.push(context, SearchPage(siteContext: siteContext)),
          ),
        if (isLoggedIn)
          IconButton(
            icon: const Icon(Icons.done_all_rounded),
            tooltip: l10n.markForumRead,
            onPressed: () => ForumActions.confirmMarkAllRead(context),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
