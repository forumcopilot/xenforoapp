import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import '../members_page.dart';
import '../../theme/design_tokens.dart';

class MessagesTabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SiteContext siteContext;
  final bool isLoggedIn;
  const MessagesTabAppBar({
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
        AppLocalizations.of(context)?.messages ?? 'Messages',
        style: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: DesignTokens.fontSizeL,
        ),
      ),
      centerTitle: false,
      actions: [
        if (isLoggedIn) _buildMembersButton(context, colorScheme),
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
