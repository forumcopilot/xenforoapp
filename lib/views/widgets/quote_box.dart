import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';
import 'user_avatar.dart';

/// A quote in a post or message: "Name said:" with the quoted member's
/// avatar over the quoted text, in a filled block with the accent bar at its
/// start. The text keeps the post's own size and colour. Adapted from
/// discourse_ui's quote style and QuoteExtension (rounded by clipping, as a
/// one-sided border can't take a radius). A quote of a post opens that post
/// from its header, as the website's ↑ does.
class QuoteBox extends StatelessWidget {
  const QuoteBox({super.key, required this.name, required this.child, this.onOpen});

  /// The quoted member; empty for a quote without a name (then no header).
  final String name;

  final Widget child;

  /// Opens the quoted post; null when the quote names none.
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          border: BorderDirectional(start: BorderSide(color: colorScheme.primary, width: 3)),
        ),
        padding: const EdgeInsets.all(DesignTokens.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (name.isNotEmpty) _header(context),
            child,
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final said = AppLocalizations.of(context).quoteSaid(name);
    final row = Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.spacingS),
      child: Row(
        children: [
          UserAvatar(username: name, radius: 10),
          const SizedBox(width: DesignTokens.spacingS),
          Flexible(
            child: Text(
              said,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              // labelLarge, 14/20 medium, as the Discourse app's quote title.
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
          if (onOpen != null) ...[
            const SizedBox(width: DesignTokens.spacingXS),
            Icon(Icons.arrow_upward_rounded, size: DesignTokens.iconSizeS, color: colorScheme.onSurfaceVariant),
          ],
        ],
      ),
    );
    if (onOpen == null) return row;
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        child: row,
      ),
    );
  }
}
