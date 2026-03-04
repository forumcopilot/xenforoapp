import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/appbars/base_forum_app_bar.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import '../../../../theme/design_tokens.dart';

class TraditionalPMAppBar extends BaseForumAppBar {
  final SiteContext siteContext;

  const TraditionalPMAppBar({
    required String title,
    required this.siteContext,
    this.onDelete,
    this.onMarkUnread,
    this.onReply,
    this.onReplyAll,
    this.onForward,
    this.onReport,
    super.key,
  }) : super(title: title);

  final VoidCallback? onDelete;
  final VoidCallback? onMarkUnread;
  final VoidCallback? onReply;
  final VoidCallback? onReplyAll;
  final VoidCallback? onForward;
  final VoidCallback? onReport;

  // Helper method to check if user can send PMs
  bool get _canSendPM {
    return siteContext.isLoggedIn && (siteContext.loginDataOutput?.user?.canSendPM ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 3,
      shadowColor: colorScheme.shadow.withOpacity(0.3),
      surfaceTintColor: colorScheme.surfaceTint,
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      ),
      actions: buildActions(context),
      centerTitle: true,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final canSendPM = _canSendPM;

    return [
      // Mark as unread - only if logged in
      if (siteContext.isLoggedIn && onMarkUnread != null)
        IconButton(
          icon: Icon(
            Icons.mark_email_unread_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: onMarkUnread,
          tooltip: AppLocalizations.of(context)?.markAsUnread ?? 'Mark as unread',
        ),

      // Reply buttons - only show if user can send PMs
      if (canSendPM) ...[
        IconButton(
          icon: Icon(
            Icons.reply,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: onReply,
          tooltip: AppLocalizations.of(context)?.reply ?? 'Reply',
        ),
        IconButton(
          icon: Icon(
            Icons.reply_all,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: onReplyAll,
          tooltip: AppLocalizations.of(context)?.replyAll ?? 'Reply All',
        ),
        IconButton(
          icon: Icon(
            Icons.forward,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: onForward,
          tooltip: AppLocalizations.of(context)?.forward ?? 'Forward',
        ),
      ],

      // More options menu
      PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: colorScheme.onSurfaceVariant,
        ),
        tooltip: AppLocalizations.of(context)?.moreOptions ?? 'More options',
        onSelected: (value) {
          switch (value) {
            case 'delete':
              if (onDelete != null) onDelete!();
              break;
            case 'report':
              if (onReport != null) onReport!();
              break;
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline,
                  color: colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: DesignTokens.spacingM),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'report',
            child: Row(
              children: [
                Icon(
                  Icons.flag_outlined,
                  color: colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: DesignTokens.spacingM),
                Text(
                  'Report User',
                  style: TextStyle(
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }
}
