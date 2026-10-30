import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';

/// The "3 months later" divider between posts far apart in time, so a thread
/// revived after a long silence doesn't read as one continuous conversation.
/// Adapted from forum_kit's lib/views/widgets/post_time_gap.dart (the
/// Discourse app), whose thresholds and wording follow Discourse's own:
///   * `< 30` days  → "N days later"
///   * `< 365` days → "N months later", days/30 rounded
///   * otherwise    → "N years later", days/365 rounded
class PostTimeGap extends StatelessWidget {
  const PostTimeGap({super.key, required this.daysSince});

  final int daysSince;

  /// More than this many days between two posts shows the divider:
  /// Discourse's default `show_time_gap_days` (XenForo has no setting).
  static const int thresholdDays = 7;

  /// Whole days between two posts, floored.
  static int daysBetween(DateTime earlier, DateTime later) => later.difference(earlier).inDays;

  /// The days to show between [above] and [below], or null for none.
  static int? between(DateTime? above, DateTime? below) {
    if (above == null || below == null) return null;
    final days = daysBetween(above, below);
    return days > thresholdDays ? days : null;
  }

  String _describe(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (daysSince < 30) return l10n.timeGapDaysLater(daysSince);
    if (daysSince < 365) return l10n.timeGapMonthsLater((daysSince / 30).round());
    return l10n.timeGapYearsLater((daysSince / 365).round());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The post above draws no rule of its own where this follows, so these
    // rules are the boundary between the two posts.
    final rule = theme.colorScheme.outlineVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingM),
      child: Row(
        children: [
          Expanded(child: Divider(color: rule)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingM),
            child: Text(
              _describe(context),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Expanded(child: Divider(color: rule)),
        ],
      ),
    );
  }
}
