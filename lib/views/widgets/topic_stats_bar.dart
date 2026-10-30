import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';
import '../../utils/number_utils.dart';
import 'user_avatar.dart';

/// The thread's summary under its first post: views and replies, each number
/// over its label, with a few of the members taking part at the end. Adapted
/// from forum_kit's lib/views/widgets/topic_stats_bar.dart (the Discourse
/// app, after Discourse's topic map). XenForo sends no participant list, so
/// the faces are the authors of the posts loaded so far, in order.
class TopicStatsBar extends StatelessWidget {
  const TopicStatsBar({
    super.key,
    required this.viewCount,
    required this.replyCount,
    this.participants = const [],
  });

  final int viewCount;
  final int replyCount;

  /// Name and avatar address of each member taking part, first poster first.
  final List<(String, String?)> participants;

  /// Faces once two members have taken part, at most five.
  static const int _minAvatars = 2;
  static const int _maxAvatars = 5;
  static const double _avatarRadius = 13;

  /// How much each face tucks under the one before it.
  static const double _avatarOverlap = 8;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final stats = <Widget>[
      if (viewCount > 0) _stat(context, viewCount, l10n.topicMapViews(viewCount)),
      if (replyCount > 0) _stat(context, replyCount, l10n.topicMapReplies(replyCount)),
    ];
    final faces = participants.length >= _minAvatars ? participants.take(_maxAvatars).toList() : const <(String, String?)>[];
    // A thread with nothing to report leaves no empty rule behind.
    if (stats.isEmpty && faces.isEmpty) return const SizedBox.shrink();

    final row = LayoutBuilder(
      builder: (context, box) => Row(
        children: [
          // The numbers get their natural width first, and scale down rather
          // than overflow at a large text size.
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: box.maxWidth),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < stats.length; i++) ...[
                    if (i > 0) const SizedBox(width: DesignTokens.spacingXL),
                    stats[i],
                  ],
                ],
              ),
            ),
          ),
          // The faces take what is left: as many as fit.
          Expanded(child: _faces(colorScheme, faces)),
        ],
      ),
    );

    // A rule above, none below: the replies follow after the band.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
      child: DecoratedBox(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: colorScheme.outlineVariant))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingM),
          child: row,
        ),
      ),
    );
  }

  Widget _stat(BuildContext context, int value, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final number = formatNumber(context, value);
    return Semantics(
      label: '$number $label',
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            number,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: DesignTokens.fontWeightMedium,
              height: 1.2,
            ),
          ),
          Text(label, style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.2)),
        ],
      ),
    );
  }

  Widget _faces(ColorScheme colorScheme, List<(String, String?)> people) {
    if (people.isEmpty) return const SizedBox.shrink();
    const diameter = _avatarRadius * 2;
    // A ring in the page colour marks where one face tucks under the next.
    const ring = 2.0;
    const outer = diameter + ring * 2;
    const step = outer - _avatarOverlap;
    return ExcludeSemantics(
      child: LayoutBuilder(
        builder: (context, box) {
          const gap = DesignTokens.spacingM;
          final room = box.maxWidth - gap;
          final fit = room < outer ? 0 : ((room - outer) ~/ step) + 1;
          final shown = people.take(fit).toList();
          if (shown.isEmpty) return const SizedBox.shrink();
          return Align(
            alignment: AlignmentDirectional.centerEnd,
            child: SizedBox(
              width: outer + step * (shown.length - 1),
              height: outer,
              child: Stack(
                children: [
                  for (var i = 0; i < shown.length; i++)
                    PositionedDirectional(
                      start: step * i,
                      child: Container(
                        padding: const EdgeInsets.all(ring),
                        decoration: BoxDecoration(color: colorScheme.surface, shape: BoxShape.circle),
                        child: UserAvatar(username: shown[i].$1, iconUrl: shown[i].$2, radius: _avatarRadius),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
