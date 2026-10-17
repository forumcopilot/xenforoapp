import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/entities/fc_topic.dart';
import 'package:forumcopilot_flutter/utils/time_utils.dart';
import 'package:forumcopilot_flutter/utils/number_utils.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/unread_badge.dart';

class NotificationListItem extends StatelessWidget {
  final FCTopic topic;
  final VoidCallback? onTap;
  final IconData? topicIcon;
  final String? contentType;

  /// Unread alerts get a heavier headline and an unread dot, as on the
  /// website's alert list.
  final bool isUnread;

  const NotificationListItem({
    Key? key,
    required this.topic,
    required this.onTap,
    this.topicIcon,
    this.contentType,
    this.isUnread = false,
  }) : super(key: key);

  Widget _buildBottomDivider(ColorScheme colorScheme) {
    return Divider(
      height: 1,
      thickness: 1,
      color: colorScheme.outlineVariant.withValues(alpha: DesignTokens.opacityLow),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(DesignTokens.spacingL),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Larger avatar on the left (without badge)
                  UserAvatar(
                    username: topic.authorName,
                    iconUrl: topic.authorIconUrl,
                    radius: DesignTokens.spacingXL + DesignTokens.spacingXS,
                  ),
                  SizedBox(width: DesignTokens.spacingL),
                  // Message and metadata on the right
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Message text (flexible wrapping)
                        Text(
                          topic.title,
                          style: StyleBuilders.titleTextStyle(
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                            fontSize: DesignTokens.fontSizeS,
                            fontWeight: isUnread
                                ? FontWeight.w600
                                : DesignTokens.fontWeightMedium,
                          ),
                          // No maxLines restriction for flexible wrapping
                        ),
                        // Metadata row at the bottom
                        SizedBox(height: DesignTokens.spacingS),
                        Wrap(
                          spacing: DesignTokens.spacingM,
                          runSpacing: DesignTokens.spacingXS,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (topic.replyCount > 0) ...[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.comment_outlined,
                                    size: DesignTokens.iconSizeS,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  SizedBox(width: DesignTokens.spacingXS),
                                  Text(
                                    formatNumber(context, topic.replyCount),
                                    style: StyleBuilders.smallTextStyle(
                                      colorScheme: colorScheme,
                                      textTheme: textTheme,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (topic.timestamp != DateTime.fromMillisecondsSinceEpoch(0)) ...[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    size: DesignTokens.iconSizeS,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  SizedBox(width: DesignTokens.spacingXS),
                                  Text(
                                    formatSmartDateTime(topic.timestamp, context),
                                    style: StyleBuilders.smallTextStyle(
                                      colorScheme: colorScheme,
                                      textTheme: textTheme,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (topicIcon != null) ...[
                              Icon(
                                topicIcon!,
                                size: DesignTokens.iconSizeS,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ],
                            if (topic.isPinned) ...[
                              Icon(
                                Icons.push_pin_outlined,
                                size: DesignTokens.iconSizeS,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ],
                            if (topic.isSubscribed) ...[
                              Icon(
                                Icons.watch_outlined,
                                size: DesignTokens.iconSizeS,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isUnread) ...[
                    SizedBox(width: DesignTokens.spacingS),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: UnreadBadge(semanticLabel: AppLocalizations.of(context)?.unread ?? 'Unread'),
                    ),
                  ],
                ],
              ),
            ),
            // Bottom divider
            _buildBottomDivider(colorScheme),
          ],
        ),
      ),
    );
  }
}
