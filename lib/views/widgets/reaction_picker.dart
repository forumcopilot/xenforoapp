import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';

/// Presents the forum's configured reactions as a tap-to-choose sheet.
///
/// Returns the [FCReaction] the user picked, or null if they dismissed it.
/// Renders native emoji when the server supplied one, falling back to the
/// reaction image for anything custom.
Future<FCReaction?> showReactionPicker(
  BuildContext context, {
  int? currentReactionId,
}) {
  final reactions = ReactionRegistry.instance.reactions;
  if (reactions.isEmpty) return Future.value(null);

  return showModalBottomSheet<FCReaction>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    // Scroll-controlled so the sheet can grow past the default half-screen
    // when there are many reactions; capped below so it never fills the whole
    // screen. Content wraps to multiple rows AND scrolls if it still overflows.
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      final colorScheme = Theme.of(ctx).colorScheme;
      // Cap the sheet at 70% of screen height; the reaction grid scrolls
      // within that if the wrapped rows are taller.
      final maxSheetHeight = MediaQuery.of(ctx).size.height * 0.7;
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxSheetHeight),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // drag handle
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Flexible + scroll view: the grid wraps to multiple rows and,
                // if those rows exceed the capped height, scrolls vertically.
                Flexible(
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 4,
                      runSpacing: 8,
                      children: [
                        for (final r in reactions)
                          _ReactionChoice(
                            reaction: r,
                            selected: currentReactionId != null &&
                                r.id == currentReactionId,
                            onTap: () => Navigator.of(ctx).pop(r),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _ReactionChoice extends StatelessWidget {
  final FCReaction reaction;
  final bool selected;
  final VoidCallback onTap;

  const _ReactionChoice({
    required this.reaction,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(color: colorScheme.primary.withOpacity(0.5))
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReactionGlyph(reaction: reaction, size: 30),
            const SizedBox(height: 6),
            Text(
              reaction.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders a reaction as native emoji when available, else its image.
class ReactionGlyph extends StatelessWidget {
  final FCReaction reaction;
  final double size;

  const ReactionGlyph({super.key, required this.reaction, this.size = 20});

  @override
  Widget build(BuildContext context) {
    if (reaction.hasEmoji) {
      return Text(
        reaction.emoji!,
        style: TextStyle(fontSize: size),
      );
    }
    if (reaction.imageUrl.isNotEmpty) {
      return Image.network(
        reaction.imageUrl,
        width: size,
        height: size,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.favorite, size: size, color: Colors.redAccent),
      );
    }
    return Icon(Icons.favorite, size: size, color: Colors.redAccent);
  }
}
