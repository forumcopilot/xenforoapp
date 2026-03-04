import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/entities/fc_poll.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../theme/style_builders.dart';

/// Compact fixed header showing a mini version of the thread poll when the user
/// is not on the first page. Tapping jumps to the first post to show the full poll.
class ThreadPollMiniCard extends StatelessWidget {
  final FCPoll poll;
  final VoidCallback onTap;

  const ThreadPollMiniCard({
    super.key,
    required this.poll,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

    final voterCount = poll.voterCount;
    final optionCount = poll.responses.length;
    final subtitle = voterCount != null && voterCount > 0
        ? (l10n?.votesCount(voterCount) ?? '$voterCount votes')
        : (l10n?.pollOptionsCount(optionCount) ?? '$optionCount options');

    final viewFullPoll = l10n?.viewFullPoll ?? 'View full poll';

    return Tooltip(
      message: viewFullPoll,
      child: Semantics(
        label: viewFullPoll,
        hint: l10n?.goToTop ?? 'Go to top',
        button: true,
        child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
        child: Container(
          margin: EdgeInsets.fromLTRB(
            DesignTokens.spacingL,
            DesignTokens.spacingS,
            DesignTokens.spacingL,
            DesignTokens.spacingS,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingM,
            vertical: DesignTokens.spacingS,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: DesignTokens.borderWidthThin,
            ),
          ),
          child: SafeArea(
            top: false,
            bottom: false,
            child: Row(
              children: [
                Icon(
                  Icons.poll_outlined,
                  size: DesignTokens.iconSizeL,
                  color: colorScheme.primary,
                ),
                SizedBox(width: DesignTokens.spacingM),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poll.question,
                        style: StyleBuilders.bodyTextStyle(
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                          fontWeight: DesignTokens.fontWeightMedium,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: DesignTokens.spacingXS),
                      Text(
                        subtitle,
                        style: StyleBuilders.smallTextStyle(
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: DesignTokens.spacingS),
                Icon(
                  Icons.arrow_upward,
                  size: DesignTokens.iconSizeM,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    ),
    );
  }
}
