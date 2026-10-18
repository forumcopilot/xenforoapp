import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/entities/fc_like.dart';
import 'package:forumcopilot_sdk/models/entities/fc_reaction.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';
import 'reaction_picker.dart' show ReactionGlyph, reactionCountLabel;

/// One kind of reaction on a post or message, and who gave it.
class ReactionGroup {
  /// The reaction id; null for entries the server sent without one (add-ons
  /// before 1.8.0, where every entry is a Like).
  final int? id;

  /// What to draw: the forum's reaction when it is in the registry, else
  /// one built from the entry's own emoji / icon (or a heart without either).
  final FCReaction glyph;

  /// Everyone who reacted this way, in the order the server listed them.
  final List<FCLike> likes;

  const ReactionGroup({required this.id, required this.glyph, required this.likes});

  int get count => likes.length;

  /// The forum's default Like (or an entry without a reaction id).
  bool get isDefaultLike => isDefaultLikeId(id);

  /// A name for the reaction in a sentence ("Wow"), or its emoji.
  String get name => glyph.title.isNotEmpty ? glyph.title : (glyph.emoji ?? '');
}

/// Whether [id] is the forum's default Like (id 1 unless the forum's
/// reaction set says otherwise). Null counts as a Like: it is what add-ons
/// before 1.8.0 send.
bool isDefaultLikeId(int? id) =>
    id == null || id == (ReactionRegistry.instance.defaultReaction?.id ?? 1);

/// [likes] grouped by reaction, most used first; ties in the forum's
/// display order.
List<ReactionGroup> groupReactions(List<FCLike> likes) {
  final byId = <int?, List<FCLike>>{};
  for (final like in likes) {
    byId.putIfAbsent(like.reactionId, () => []).add(like);
  }
  final groups = [
    for (final entry in byId.entries)
      ReactionGroup(
        id: entry.key,
        glyph: reactionGlyphFor(entry.key, entry.value.first),
        likes: entry.value,
      ),
  ];
  groups.sort((a, b) {
    final byCount = b.count.compareTo(a.count);
    if (byCount != 0) return byCount;
    final byOrder = a.glyph.displayOrder.compareTo(b.glyph.displayOrder);
    if (byOrder != 0) return byOrder;
    return (a.id ?? 0).compareTo(b.id ?? 0);
  });
  return groups;
}

/// The reaction to draw for an entry: the forum's own (from getConfig) when
/// known, else the emoji or icon the entry carries. An entry with neither
/// draws as a heart ([ReactionGlyph]'s fallback).
FCReaction reactionGlyphFor(int? id, FCLike like) {
  final known = ReactionRegistry.instance.byId(id);
  if (known != null) return known;
  final emoji = like.reactionEmoji;
  return FCReaction(
    id: id ?? 0,
    title: like.reactionName ?? '',
    emoji: (emoji == null || emoji.isEmpty) ? null : emoji,
    imageUrl: like.reactionIconUrl ?? '',
    displayOrder: 1 << 30,
  );
}

/// How many reactions to show: the server's count, or the number of people
/// listed when that is higher. Add-ons before 1.8.11 count XenForo's
/// reaction score, which is 0 for a Wow, Sad or Angry.
int reactionTotal(List<FCLike> likes, int serverCount) =>
    likes.length > serverCount ? likes.length : serverCount;

/// The reactions on a post or message, beside its react button: up to
/// three emoji (most used first) and how many reacted, as the Discourse
/// app shows it. A tap (or long press) lists who.
///
/// When every reaction is a Like and the react button sits beside it, the
/// count stands alone, so "12 ♡" reads like any like count instead of
/// repeating the button's own glyph. Without the button (a guest, or the
/// reader's own post) the glyphs always show.
class ReactionSummary extends StatelessWidget {
  final List<FCLike> likes;

  /// The server's count (see [reactionTotal]).
  final int count;

  /// Whether the react button is drawn right after this summary.
  final bool besideReactButton;

  /// Opens the list of who reacted; null leaves the summary inert (e.g.
  /// when the server listed nobody).
  final VoidCallback? onTap;

  const ReactionSummary({
    super.key,
    required this.likes,
    required this.count,
    this.besideReactButton = false,
    this.onTap,
  });

  /// Like the Discourse app: enough to tell the mix apart, few enough that
  /// a heavily reacted post cannot push the row's buttons off screen.
  static const int maxGlyphs = 3;

  @override
  Widget build(BuildContext context) {
    final total = reactionTotal(likes, count);
    if (total <= 0) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final groups = groupReactions(likes);
    final onlyLikes = groups.every((g) => g.isDefaultLike);
    final List<FCReaction> glyphs;
    if (onlyLikes && besideReactButton) {
      glyphs = const [];
    } else if (groups.isEmpty) {
      // A count but nobody listed: a heart, so the number is not bare.
      glyphs = [reactionGlyphFor(null, FCLike(userId: '', username: '', avatarUrl: ''))];
    } else {
      glyphs = [for (final g in groups.take(maxGlyphs)) g.glyph];
    }

    return Semantics(
      label: reactionCountLabel(context, total),
      hint: onTap != null ? AppLocalizations.of(context).showWhoReacted : null,
      button: onTap != null,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        onLongPress: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: kMinInteractiveDimension,
            minWidth: kMinInteractiveDimension,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
                start: DesignTokens.spacingS, end: DesignTokens.spacingXS),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final glyph in glyphs) ...[
                  ReactionGlyph(reaction: glyph, size: DesignTokens.iconSizeM),
                  const SizedBox(width: 2),
                ],
                if (glyphs.isNotEmpty) const SizedBox(width: DesignTokens.spacingXS - 2),
                Text(
                  '$total',
                  style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
