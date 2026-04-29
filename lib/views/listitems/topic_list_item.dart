import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_topic.dart';
import 'package:forumcopilot_flutter/utils/time_utils.dart';
import 'package:forumcopilot_flutter/utils/number_utils.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';

/// Widget para representar un ítem de la lista de foros
class TopicListItem extends StatelessWidget {
  final SiteContext siteContext;
  final FCTopic topic;
  final VoidCallback? onTap;
  final IconData? topicIcon;
  final Function(String topicId)? onMarkAsRead;

  const TopicListItem({
    super.key,
    required this.siteContext,
    required this.topic,
    required this.onTap,
    this.topicIcon,
    this.onMarkAsRead,
  });

  void _handleTap() {
    // Mark as read immediately when tapped if the topic has new posts
    if (topic.hasNewPosts && onMarkAsRead != null) {
      onMarkAsRead!(topic.id);
    }
    // Call the original onTap callback
    onTap?.call();
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

    return Material(
      color: colorScheme.surface,
      child: InkWell(
        onTap: _handleTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with avatar, username, and timestamp
            Padding(
              padding: EdgeInsets.all(DesignTokens.spacingL),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  UserAvatar(
                    username: topic.authorName,
                    iconUrl: topic.authorIconUrl,
                    radius: 20,
                  ),
                  SizedBox(width: DesignTokens.spacingL),
                  // Author info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.authorName.isNotEmpty ? topic.authorName : "Unknown",
                          style: textTheme.titleMedium?.copyWith(
                            color: topic.hasNewPosts ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                            fontWeight: topic.hasNewPosts ? DesignTokens.fontWeightSemiBold : DesignTokens.fontWeightMedium,
                            letterSpacing: DesignTokens.letterSpacingMedium,
                          ),
                        ),
                        if (topic.timestamp != DateTime.fromMillisecondsSinceEpoch(0)) ...[
                          SizedBox(height: DesignTokens.spacingXS),
                          Text(
                            formatSmartDateTime(topic.timestamp, context),
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              letterSpacing: DesignTokens.letterSpacingWide,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Title row with badges (on its own line)
            Padding(
              padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, 0.0, DesignTokens.spacingL, DesignTokens.spacingS),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (topic.hasNewPosts) ...[
                    Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.only(
                        top: DesignTokens.spacingM - DesignTokens.spacingXS,
                        right: DesignTokens.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                  if (topic.isDeleted) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingM - DesignTokens.spacingXS,
                        vertical: DesignTokens.spacingXS / 2,
                      ),
                      decoration: StyleBuilders.badgeDecoration(
                        colorScheme: colorScheme,
                        backgroundColor: colorScheme.outline.withOpacity(DesignTokens.opacityLow),
                        borderRadius: DesignTokens.radiusS,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: DesignTokens.fontSizeXS,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: DesignTokens.spacingXS),
                          Text(
                            'DELETED',
                            style: StyleBuilders.smallTextStyle(
                              colorScheme: colorScheme,
                              textTheme: textTheme,
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: DesignTokens.fontWeightBold,
                            ).copyWith(fontSize: DesignTokens.fontSizeXS - 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: DesignTokens.spacingS),
                  ],
                  Expanded(
                    child: Text(
                      topic.title,
                      style: StyleBuilders.titleTextStyle(
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                        fontSize: DesignTokens.fontSizeTopicTitle,
                        fontWeight: topic.hasNewPosts ? DesignTokens.fontWeightBold : DesignTokens.fontWeightMedium,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Short content if available
            if (topic.shortContent!.isNotEmpty && !topic.isAnnouncement) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, 0.0, DesignTokens.spacingL, DesignTokens.spacingS),
                child: Text(
                  topic.shortContent!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            // Metadata row
            Builder(
              builder: (context) {
                // Count status icons to determine if we should show labels
                final statusIconCount = [
                  if (topicIcon != null) 1,
                  if (topic.isPinned) 1,
                  if (topic.isSubscribed) 1,
                  if (topic.isClosed) 1,
                  if (topic.hasPoll) 1,
                ].length;
                final showLabels = statusIconCount == 1;
                final metaColor = colorScheme.onSurfaceVariant.withOpacity(0.72);
                
                return Padding(
                  padding: EdgeInsets.fromLTRB(DesignTokens.spacingL, 0.0, DesignTokens.spacingL, DesignTokens.spacingL),
                  child: Wrap(
                    spacing: DesignTokens.spacingL,
                    runSpacing: DesignTokens.spacingXS,
                    children: [
                      if (topic.prefix != null && topic.prefix!.isNotEmpty) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.tag,
                              size: textTheme.bodySmall?.fontSize ?? 12,
                              color: metaColor,
                            ),
                            SizedBox(width: DesignTokens.spacingXS),
                            Text(
                              topic.prefix!,
                              style: textTheme.bodySmall?.copyWith(
                                color: metaColor,
                                letterSpacing: DesignTokens.letterSpacingWide,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (topic.replyCount > 0) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              size: textTheme.bodySmall?.fontSize ?? 12,
                              color: metaColor,
                            ),
                            SizedBox(width: DesignTokens.spacingXS),
                            Text(
                              formatNumber(context, topic.replyCount),
                              style: textTheme.bodySmall?.copyWith(
                                color: metaColor,
                                letterSpacing: DesignTokens.letterSpacingWide,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (topic.viewCount > 0) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              size: textTheme.bodySmall?.fontSize ?? 12,
                              color: metaColor,
                            ),
                            SizedBox(width: DesignTokens.spacingXS),
                            Text(
                              formatNumber(context, topic.viewCount),
                              style: textTheme.bodySmall?.copyWith(
                                color: metaColor,
                                letterSpacing: DesignTokens.letterSpacingWide,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (topicIcon != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              topicIcon,
                              size: textTheme.bodySmall?.fontSize ?? 12,
                              color: metaColor,
                            ),
                            if (showLabels) ...[
                              SizedBox(width: DesignTokens.spacingXS),
                              Text(
                                'Announcement',
                                style: textTheme.bodySmall?.copyWith(
                                  color: metaColor,
                                  letterSpacing: DesignTokens.letterSpacingWide,
                                ),
                              ),
                            ],
                          ],
                        ),
                      if (topic.isPinned)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.push_pin_outlined,
                              size: textTheme.bodySmall?.fontSize ?? 12,
                              color: metaColor,
                            ),
                            if (showLabels) ...[
                              SizedBox(width: DesignTokens.spacingXS),
                              Text(
                                'Pinned',
                                style: textTheme.bodySmall?.copyWith(
                                  color: metaColor,
                                  letterSpacing: DesignTokens.letterSpacingWide,
                                ),
                              ),
                            ],
                          ],
                        ),
                      if (topic.isSubscribed)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.watch_outlined,
                              size: textTheme.bodySmall?.fontSize ?? 12,
                              color: metaColor,
                            ),
                            if (showLabels) ...[
                              SizedBox(width: DesignTokens.spacingXS),
                              Text(
                                'Subscribed',
                                style: textTheme.bodySmall?.copyWith(
                                  color: metaColor,
                                  letterSpacing: DesignTokens.letterSpacingWide,
                                ),
                              ),
                            ],
                          ],
                        ),
                      if (topic.isClosed)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_outlined,
                              size: textTheme.bodySmall?.fontSize ?? 12,
                              color: metaColor,
                            ),
                            if (showLabels) ...[
                              SizedBox(width: DesignTokens.spacingXS),
                              Text(
                                'Locked',
                                style: textTheme.bodySmall?.copyWith(
                                  color: metaColor,
                                  letterSpacing: DesignTokens.letterSpacingWide,
                                ),
                              ),
                            ],
                          ],
                        ),
                      // Show poll icon in topic list so users can identify threads with polls.
                      if (topic.hasPoll)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.poll_outlined,
                              size: textTheme.bodySmall?.fontSize ?? 12,
                              color: metaColor,
                            ),
                            if (showLabels) ...[
                              SizedBox(width: DesignTokens.spacingXS),
                              Text(
                                'Poll',
                                style: textTheme.bodySmall?.copyWith(
                                  color: metaColor,
                                  letterSpacing: DesignTokens.letterSpacingWide,
                                ),
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
            // Bottom divider
            _buildBottomDivider(colorScheme),
          ],
        ),
      ),
    );
  }
}
