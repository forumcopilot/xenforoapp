import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/entities/fc_like.dart';
import 'package:forumcopilot_sdk/models/entities/fc_reaction.dart';

import '../../theme/design_tokens.dart';
import '../../utils/accessibility_helpers.dart';
import 'reaction_picker.dart' show ReactionGlyph, reactionIconSize, reactionLoveColor;
import 'reaction_summary.dart' show isDefaultLikeId, reactionGlyphFor;

/// The react button on a post or a direct message, drawn the same in both,
/// after the Discourse app:
/// - not reacted: an outline heart;
/// - a Like (the forum's default reaction, XenForo's 👍, or an entry
///   without a reaction id): the heart filled in the love colour, so a tap
///   on the heart fills the heart;
/// - any other reaction: that reaction on a tinted chip, so it reads as
///   "your reaction" beside the summary that also counts it, not as the
///   same emoji drawn twice.
///
/// A tap likes, or takes your reaction back; a long press opens the
/// reaction picker ([onLongPress] is null on a forum with only Like).
class ReactButton extends StatelessWidget {
  final bool isReacted;

  /// What the reader reacted with, when [isReacted]; null for a Like
  /// without a reaction id.
  final FCReaction? reaction;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String label;
  final String? hint;

  const ReactButton({
    super.key,
    required this.isReacted,
    required this.reaction,
    required this.onTap,
    required this.label,
    this.onLongPress,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = reactionIconSize(context, DesignTokens.iconSizeMedium);
    final mine = isReacted ? reaction : null;

    final Widget icon;
    if (!isReacted) {
      icon = Icon(Icons.favorite_border, color: colorScheme.onSurfaceVariant, size: size);
    } else if (mine == null || isDefaultLikeId(mine.id)) {
      icon = Icon(Icons.favorite, color: reactionLoveColor(context), size: size);
    } else {
      // A fixed circle: sized by its padding alone, the chip took the
      // emoji's line height and drew as a tall oval.
      icon = SizedBox.square(
        dimension: size + 12,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: colorScheme.primaryContainer,
            shape: CircleBorder(side: BorderSide(color: colorScheme.primary, width: 1.5)),
          ),
          child: Center(
            // [size] already follows the reader's text size (up to 1.3x);
            // the emoji would scale again on top of it.
            child: MediaQuery.withNoTextScaling(
              child: ReactionGlyph(reaction: mine, size: size - 4),
            ),
          ),
        ),
      );
    }

    return AccessibilityHelpers.accessibleIconButton(
      icon: icon,
      onTap: onTap,
      onLongPress: onLongPress,
      label: label,
      hint: hint,
      isSelected: isReacted,
      context: context,
    );
  }
}

/// The reader's reaction among [likes], for [ReactButton]: the forum's
/// reaction when known, else the emoji or icon the entry carries. Null when
/// the reader hasn't reacted, or for an entry without a reaction id (a
/// Like from add-ons before 1.8.0).
FCReaction? viewerReaction(List<FCLike> likes, String? username) {
  if (username == null) return null;
  final me = username.toLowerCase();
  for (final like in likes) {
    if (like.username.toLowerCase() == me) {
      return like.reactionId == null ? null : reactionGlyphFor(like.reactionId, like);
    }
  }
  return null;
}
