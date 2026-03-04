import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_actions.dart';
import 'package:forumcopilot_flutter/views/widgets/forum_icon_widget.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';

class ForumListItem extends StatelessWidget {
  final FCForum forum;
  final SiteContext siteContext;
  final VoidCallback? onTap;
  final Function(bool)? onSubscriptionChanged;

  const ForumListItem({
    Key? key,
    required this.siteContext,
    required this.forum,
    this.onTap,
    this.onSubscriptionChanged,
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
      color: colorScheme.outlineVariant.withOpacity(0.3),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasDescription = forum.description != null && forum.description!.isNotEmpty;

    return Material(
      color: colorScheme.surface,
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: hasDescription ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  ForumListItemIconWidget(
                    logoUrl: forum.logoUrl,
                    fallbackIcon: Icons.forum_rounded,
                    forumName: forum.name,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
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
                          const SizedBox(height: 8),
                          Text(
                            forum.description!,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
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
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: DesignTokens.spacingS,
                                    vertical: DesignTokens.spacingXS,
                                  ),
                                  decoration: StyleBuilders.badgeDecoration(
                                    colorScheme: colorScheme,
                                    backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
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
                              ],
                              if (forum.isProtected)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: DesignTokens.spacingS,
                                    vertical: DesignTokens.spacingXS,
                                  ),
                                  decoration: StyleBuilders.badgeDecoration(
                                    colorScheme: colorScheme,
                                    backgroundColor: colorScheme.errorContainer.withOpacity(0.5),
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
                                        'Protected',
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
