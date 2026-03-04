import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_conversation_result.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import '../../../../utils/time_utils.dart';
import '../../../../theme/design_tokens.dart';
import '../../../../theme/style_builders.dart';

class ConversationListItem extends StatelessWidget {
  final FCConversationSummary conversation;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ConversationListItem({
    Key? key,
    required this.conversation,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

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

    // Get the last reply person's profile picture and username
    String displayUsername = 'Unknown';
    String? displayAvatar;

    // Use the last user who posted in the conversation
    if (conversation.participants != null && conversation.participants!.isNotEmpty) {
      if (conversation.last_user_id != null) {
        try {
          final lastParticipant = conversation.participants!.firstWhere(
            (p) => p.userId == conversation.last_user_id,
          );
          displayUsername = lastParticipant.username;
          displayAvatar = lastParticipant.iconUrl;
        } catch (e) {
          // If last_user_id not found in participants, use first participant
          final firstParticipant = conversation.participants!.first;
          displayUsername = firstParticipant.username;
          displayAvatar = firstParticipant.iconUrl;
        }
      } else {
        // No last_user_id, use first participant
        final firstParticipant = conversation.participants!.first;
        displayUsername = firstParticipant.username;
        displayAvatar = firstParticipant.iconUrl;
      }
    }

    final hasNewPosts = conversation.new_post ?? false;
    final replyCount = int.parse(conversation.reply_count ?? '0');
    final totalMessages = replyCount + 1; // replies + first message
    final lastTime = DateTime.tryParse(
          conversation.last_conv_time ?? conversation.lastReplyTime ?? '',
        ) ??
        DateTime.now();

    return Material(
      color: colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with avatar, username, timestamp, and unread indicator
            Padding(
              padding: EdgeInsets.all(DesignTokens.spacingL),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  UserAvatar(
                    username: displayUsername,
                    iconUrl: displayAvatar,
                    radius: 20,
                  ),
                  SizedBox(width: DesignTokens.spacingL),
                  // Author info and title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                displayUsername.isNotEmpty ? displayUsername : "Unknown",
                                style: textTheme.titleMedium?.copyWith(
                                  color: hasNewPosts ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                                  fontWeight: hasNewPosts ? DesignTokens.fontWeightSemiBold : DesignTokens.fontWeightMedium,
                                  letterSpacing: DesignTokens.letterSpacingMedium,
                                ),
                              ),
                            ),
                            // Unread indicator on the right side
                            if (hasNewPosts) ...[
                              SizedBox(width: DesignTokens.spacingS),
                              // Show unread count badge if available and > 0, otherwise show dot indicator
                              (conversation.unreadMessageCount != null && conversation.unreadMessageCount! > 0)
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: conversation.unreadMessageCount! > 99 
                                            ? DesignTokens.spacingXS 
                                            : DesignTokens.spacingS,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        conversation.unreadMessageCount! > 99 
                                            ? '99+'
                                            : '${conversation.unreadMessageCount}',
                                        style: textTheme.labelSmall?.copyWith(
                                          color: colorScheme.onPrimary,
                                          fontWeight: DesignTokens.fontWeightBold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 8,
                                      height: 8,
                                      margin: EdgeInsets.only(top: 6),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                            ],
                          ],
                        ),
                        SizedBox(height: DesignTokens.spacingXS),
                        Text(
                          formatSmartDateTime(lastTime, context),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: DesignTokens.letterSpacingWide,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Title row
            Padding(
              padding: EdgeInsets.fromLTRB(
                DesignTokens.spacingL,
                0.0,
                DesignTokens.spacingL,
                DesignTokens.spacingS,
              ),
              child: Text(
                conversation.conv_subject ?? 'No subject',
                style: StyleBuilders.titleTextStyle(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  fontSize: DesignTokens.fontSizeTopicTitle,
                  fontWeight: hasNewPosts ? DesignTokens.fontWeightBold : DesignTokens.fontWeightMedium,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Metadata row
            Padding(
              padding: EdgeInsets.fromLTRB(
                DesignTokens.spacingL,
                0.0,
                DesignTokens.spacingL,
                DesignTokens.spacingL,
              ),
              child: Wrap(
                spacing: DesignTokens.spacingL,
                runSpacing: DesignTokens.spacingXS,
                children: [
                  if ((conversation.participant_count ?? 0) > 0) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.people_rounded,
                          size: textTheme.bodySmall?.fontSize ?? 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: DesignTokens.spacingXS),
                        Text(
                          '${conversation.participant_count}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: DesignTokens.letterSpacingWide,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (totalMessages > 0) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.message_outlined,
                          size: textTheme.bodySmall?.fontSize ?? 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: DesignTokens.spacingXS),
                        Text(
                          '$totalMessages',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: DesignTokens.letterSpacingWide,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (conversation.isClosed == true) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_outlined,
                          size: textTheme.bodySmall?.fontSize ?? 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
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
