import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';

/// Content by a member the viewer ignores (XenForo add-on 1.11.0+), shown
/// collapsed to one line until the viewer taps "Show", as XenForo does.
class IgnoredContentGate extends StatefulWidget {
  final bool isIgnored;
  final String authorName;
  final Widget child;

  const IgnoredContentGate({
    super.key,
    required this.isIgnored,
    required this.authorName,
    required this.child,
  });

  @override
  State<IgnoredContentGate> createState() => _IgnoredContentGateState();
}

class _IgnoredContentGateState extends State<IgnoredContentGate> {
  bool _shown = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.isIgnored || _shown) return widget.child;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    return Material(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingS),
        child: Row(
          children: [
            Icon(Icons.visibility_off_outlined, size: DesignTokens.iconSizeM, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: DesignTokens.spacingM),
            Expanded(
              child: Text(
                l10n.youAreIgnoringMember(widget.authorName),
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _shown = true),
              child: Text(l10n.showIgnoredContent),
            ),
          ],
        ),
      ),
    );
  }
}
