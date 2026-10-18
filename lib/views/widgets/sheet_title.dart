import 'package:flutter/material.dart';

import '../../theme/design_tokens.dart';

/// The heading of a bottom sheet, directly under the theme's drag handle.
///
/// Every sheet names itself the same way: `titleMedium`, 16dp in from the
/// sides, no space above (the handle's own 22dp margin is the space) and 8dp
/// below. Sheets used to draw this four different ways, at weights from
/// w500 to w700 and with 12–28dp above it.
class SheetTitle extends StatelessWidget {
  const SheetTitle(this.text, {super.key, this.trailing});

  final String text;

  /// Optional action on the heading's line (e.g. a Clear button).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final title = Text(
      text,
      style: Theme.of(context).textTheme.titleMedium,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DesignTokens.spacingL,
        0,
        DesignTokens.spacingL,
        DesignTokens.spacingS,
      ),
      child: trailing == null
          ? title
          : Row(children: [Expanded(child: title), trailing!]),
    );
  }
}
