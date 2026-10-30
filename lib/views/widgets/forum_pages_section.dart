import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';
import '../../utils/forum_links.dart';

/// The forum's own pages: its terms and rules, privacy policy, contact page
/// and help pages (XenForo add-on 1.11.0+; older add-ons send none, and
/// nothing shows). [compact] lists them as a row of links, under the
/// sign-in prompt; otherwise as a "This forum" section.
class ForumPagesSection extends StatelessWidget {
  const ForumPagesSection({super.key, required this.siteContext, this.compact = false});

  final SiteContext siteContext;
  final bool compact;

  /// The pages as (icon, title, url), in the website footer's order.
  static List<(IconData, String, String)> pagesOf(FCConfigResult? config, AppLocalizations l10n) => [
        if (config?.tosUrl != null) (Icons.gavel_outlined, l10n.forumTerms, config!.tosUrl!),
        if (config?.privacyPolicyUrl != null) (Icons.privacy_tip_outlined, l10n.privacyPolicy, config!.privacyPolicyUrl!),
        if (config?.contactUrl != null) (Icons.mail_outline, l10n.contactForum, config!.contactUrl!),
        for (final page in config?.helpPages ?? const <FCForumPage>[]) (Icons.help_outline, page.title, page.url),
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pages = pagesOf(siteContext.configDataOutput, l10n);
    if (pages.isEmpty) return const SizedBox.shrink();

    if (compact) {
      return Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingM),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            for (final (_, title, url) in pages)
              TextButton(
                onPressed: () => ForumLinks.open(context, url, siteContext),
                child: Text(title, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
              ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(DesignTokens.spacingL, DesignTokens.spacingS, DesignTokens.spacingL, DesignTokens.spacingXS),
          child: Semantics(
            header: true,
            child: Text(l10n.thisForum, style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
          ),
        ),
        for (final (icon, title, url) in pages)
          ListTile(
            leading: Icon(icon, color: colorScheme.onSurfaceVariant),
            title: Text(title, style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface)),
            trailing: Icon(Icons.open_in_new, size: DesignTokens.iconSizeS, color: colorScheme.onSurfaceVariant),
            onTap: () => ForumLinks.open(context, url, siteContext),
          ),
      ],
    );
  }
}
