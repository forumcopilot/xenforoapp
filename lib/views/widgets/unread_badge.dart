import 'package:flutter/material.dart';

/// The one unread marker for list rows — topics, messages, chat channels,
/// notifications: Material 3's badge at the end of the row, in the primary
/// colour, as a count when the number is known and a dot when it isn't.
///
/// Each list had its own: a tinted row with a leading dot (notifications),
/// a hand-drawn count pill with its own radius and weight (messages, topics),
/// bold text plus a differently padded pill (chat).
class UnreadBadge extends StatelessWidget {
  const UnreadBadge({super.key, this.count = 0, this.semanticLabel});

  /// Unread items; zero or less draws the dot.
  final int count;

  /// What a screen reader says for the badge ("New topic", "3 unread
  /// replies"). A bare dot says nothing and a bare "3" says only the
  /// number, so rows whose badge carries meaning should name it.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Widget badge = count <= 0
        ? Badge(smallSize: 8, backgroundColor: colorScheme.primary)
        : Badge(
            label: Text(count > 99 ? '99+' : '$count'),
            backgroundColor: colorScheme.primary,
            textColor: colorScheme.onPrimary,
          );
    final label = semanticLabel;
    if (label == null) return badge;
    return Semantics(label: label, child: ExcludeSemantics(child: badge));
  }
}
