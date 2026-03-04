import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_message_result.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import '../../../../utils/time_utils.dart';
import '../../../../theme/design_tokens.dart';
import '../../../../theme/style_builders.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class TraditionalPMListItem extends StatefulWidget {
  final FCPrivateMessage message;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final int msgState;
  final bool isInbox;

  const TraditionalPMListItem({
    Key? key,
    required this.message,
    this.onTap,
    this.onDelete,
    required this.msgState,
    required this.isInbox,
  }) : super(key: key);

  @override
  State<TraditionalPMListItem> createState() => _TraditionalPMListItemState();
}

class _TraditionalPMListItemState extends State<TraditionalPMListItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    AppLogger.debug('\n[TraditionalPMListItem] Message details:');
    AppLogger.debug('  Message ID: ${widget.message.msg_id}');
    AppLogger.debug('  From: ${widget.message.msg_from}');
    AppLogger.debug('  To: ${widget.message.msg_to?.join(", ") ?? 'Unknown'}');
    AppLogger.debug('  Avatar URL: ${widget.message.icon_url}');
    AppLogger.debug('  Is Inbox: ${widget.isInbox}');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildMessageStateIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (widget.msgState) {
      case 3: // Replied
        return Icon(
          Icons.reply_rounded,
          size: DesignTokens.fontSizeS,
          color: colorScheme.onSurfaceVariant,
        );
      case 4: // Forwarded
        return Icon(
          Icons.forward_rounded,
          size: DesignTokens.fontSizeS,
          color: colorScheme.onSurfaceVariant,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final displayUsername = widget.isInbox ? (widget.message.msg_from ?? widget.message.authorName) : (widget.message.msg_to?.first ?? widget.message.authorName);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      elevation: 2,
      shadowColor: colorScheme.shadow.withOpacity(0.1),
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityLow),
          width: DesignTokens.borderWidthThin,
        ),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
            child: Padding(
              padding: DesignTokens.paddingM,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserAvatar(
                    username: displayUsername,
                    iconUrl: widget.message.icon_url,
                    radius: DesignTokens.spacingXL,
                    showOnlineIndicator: true,
                  ),
                  const SizedBox(width: DesignTokens.spacingL),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                displayUsername,
                                style: StyleBuilders.titleTextStyle(
                                  colorScheme: colorScheme,
                                  textTheme: textTheme,
                                  fontWeight: widget.message.msg_state == 1 ? DesignTokens.fontWeightBold : DesignTokens.fontWeightMedium,
                                  color: widget.message.msg_state == 1 ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: DesignTokens.spacingXS),
                        Row(
                          children: [
                            if (widget.message.msg_state == 1) ...[
                              Container(
                                width: DesignTokens.spacingM - DesignTokens.spacingXS,
                                height: DesignTokens.spacingM - DesignTokens.spacingXS,
                                margin: const EdgeInsets.only(right: DesignTokens.spacingS),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                            Expanded(
                              child: Text(
                                widget.message.msg_subject ?? widget.message.subject,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: widget.message.msg_state == 1 ? FontWeight.bold : FontWeight.w500,
                                  color: colorScheme.onSurface,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              (widget.message.timestamp != null && widget.message.timestamp!.isNotEmpty) ? _formatTimestamp(widget.message.timestamp!, context) : 'Unknown date',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildMessageStateIcon(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp, BuildContext context) {
    try {
      final intTimestamp = int.tryParse(timestamp);
      if (intTimestamp != null) {
        return formatSmartTimestamp(intTimestamp, context);
      }

      final dateTime = DateTime.parse(timestamp);
      return formatSmartDateTime(dateTime, context);
    } catch (e) {
      return 'Unknown date';
    }
  }
}









