import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_actions.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_icon_widget.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/forum_stats.dart';
import '../widgets/unread_badge.dart';

class ForumListItem extends StatelessWidget {
  final FCForum forum;
  final SiteContext siteContext;
  final VoidCallback? onTap;
  final Function(bool)? onSubscriptionChanged;

  /// A forum's sub-forums above its topics: a smaller icon, one line of
  /// description and less padding, so its topics start higher.
  final bool compact;

  const ForumListItem({
    Key? key,
    required this.siteContext,
    required this.forum,
    this.onTap,
    this.onSubscriptionChanged,
    this.compact = false,
  }) : super(key: key);

  void _handleTap(BuildContext context) {
    if (forum.isProtected) {
      final forumActions = ForumActions();
      forumActions.enterProtectedForum(context, siteContext, forum);
    } else {
      onTap?.call();
    }
  }

  Widget _buildBottomDivider(ColorScheme colorScheme) {
    return Divider(
      height: 1,
      thickness: 1,
      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasDescription = forum.description != null && forum.description!.isNotEmpty;
    final stats = forumStatsLine(context, forum);

    return Material(
      color: colorScheme.surface,
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: compact ? 12 : 16),
              child: Row(
                crossAxisAlignment: hasDescription || stats != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  ForumListItemIconWidget(
                    logoUrl: forum.logoUrl,
                    fallbackIcon: Icons.forum_rounded,
                    forumName: forum.name,
                    size: compact ? 40 : 56,
                  ),
                  SizedBox(width: compact ? 12 : 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // New posts since the reader's last visit, marked
                            // as on a topic's row.
                            if (forum.hasNewPosts) ...[
                              UnreadBadge(semanticLabel: AppLocalizations.of(context).unread),
                              const SizedBox(width: DesignTokens.spacingS),
                            ],
                            Expanded(
                              child: Text(
                                forum.name,
                                style: StyleBuilders.titleTextStyle(
                                  colorScheme: colorScheme,
                                  textTheme: textTheme,
                                  fontSize: DesignTokens.fontSizeTopicTitle,
                                  fontWeight: DesignTokens.fontWeightSemiBold,
                                ),
                              ),
                            ),
                            if (forum.isLinkForum)
                              Icon(
                                Icons.open_in_new,
                                size: DesignTokens.iconSizeS,
                                color: colorScheme.onSurfaceVariant,
                              ),
                          ],
                        ),
                        if (forum.description != null && forum.description!.isNotEmpty) ...[
                          SizedBox(height: compact ? 4 : 8),
                          Text(
                            forum.description!,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: compact ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        // How big it is, as the forum's own header says it.
                        if (stats != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            stats,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if ((forum.childForums.length) != 0 || forum.isProtected) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: DesignTokens.spacingS,
                            runSpacing: DesignTokens.spacingXS,
                            children: [
                              if ((forum.childForums.length) != 0) ...[
                                // "3 sub-forums" to a screen reader, not a bare 3.
                                Semantics(
                                  label: AppLocalizations.of(context).subForumCountLabel(forum.childForums.length),
                                  excludeSemantics: true,
                                  child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: DesignTokens.spacingS,
                                    vertical: DesignTokens.spacingXS,
                                  ),
                                  decoration: StyleBuilders.badgeDecoration(
                                    colorScheme: colorScheme,
                                    backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                    borderRadius: DesignTokens.radiusM,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.folder_outlined,
                                        size: DesignTokens.iconSizeS,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: DesignTokens.spacingXS),
                                      Text(
                                        (forum.childForums.length).toString(),
                                        style: StyleBuilders.smallTextStyle(
                                          colorScheme: colorScheme,
                                          textTheme: textTheme,
                                          color: colorScheme.onSurfaceVariant,
                                          fontWeight: DesignTokens.fontWeightMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ),
                                ),
                              ],
                              if (forum.isProtected)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: DesignTokens.spacingS,
                                    vertical: DesignTokens.spacingXS,
                                  ),
                                  decoration: StyleBuilders.badgeDecoration(
                                    colorScheme: colorScheme,
                                    backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.5),
                                    borderRadius: DesignTokens.radiusM,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.lock_outline,
                                        size: DesignTokens.iconSizeS,
                                        color: colorScheme.onErrorContainer,
                                      ),
                                      const SizedBox(width: DesignTokens.spacingXS),
                                      Text(
                                        AppLocalizations.of(context).protectedBadge,
                                        style: StyleBuilders.smallTextStyle(
                                          colorScheme: colorScheme,
                                          textTheme: textTheme,
                                          color: colorScheme.onErrorContainer,
                                          fontWeight: DesignTokens.fontWeightMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildBottomDivider(colorScheme),
          ],
        ),
      ),
    );
  }
}
