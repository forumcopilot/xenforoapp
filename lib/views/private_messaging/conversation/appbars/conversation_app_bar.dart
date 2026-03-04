import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/views/appbars/base_forum_app_bar.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_conversation_result.dart';
import '../../../../theme/design_tokens.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:forumcopilot_flutter/views/user_profile_page.dart';
import 'package:forumcopilot_flutter/utils/avatar_cache_utils.dart';
import 'package:forumcopilot_flutter/views/user_search_page.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ConversationAppBar extends BaseForumAppBar {
  final SiteContext siteContext;

  const ConversationAppBar({
    required String title,
    required this.siteContext,
    this.onLeave,
    this.onMarkUnread,
    this.onReport,
    this.participantCount = 0,
    this.canEdit = false,
    this.canClose = false,
    this.isClosed = false,
    this.participants,
    this.canInvite = false,
    this.conversationId,
    this.onInviteSuccess,
    this.onClose,
    this.onUnclose,
    this.onEdit,
    super.key,
  }) : super(title: title);

  final VoidCallback? onLeave;
  final VoidCallback? onMarkUnread;
  final VoidCallback? onReport;
  final VoidCallback? onClose;
  final VoidCallback? onUnclose;
  final VoidCallback? onEdit;
  final int participantCount;
  final bool canEdit;
  final bool canClose;
  final bool isClosed;
  final List<FCParticipant>? participants;
  final bool canInvite;
  final String? conversationId;
  final VoidCallback? onInviteSuccess;

  @override
  List<Widget> buildActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return [
      // Participants button
      if (participants != null && participants!.isNotEmpty)
        IconButton(
          icon: Icon(
            Icons.people_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
          tooltip: AppLocalizations.of(context)?.participants(participantCount) ?? 'Participants ($participantCount)',
          onPressed: () {
            showParticipantsBottomSheet(
              context,
              participants!,
              siteContext,
              canInvite: canInvite,
              conversationId: conversationId,
              onInviteSuccess: onInviteSuccess,
            );
          },
        ),
      // Mark as unread button
      if (onMarkUnread != null)
        IconButton(
          icon: Icon(
            Icons.mark_email_unread_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
          tooltip: AppLocalizations.of(context)?.markAsUnread ?? 'Mark as unread',
          onPressed: onMarkUnread,
        ),
      // More options menu (Delete and Report)
      PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: colorScheme.onSurfaceVariant,
        ),
        tooltip: AppLocalizations.of(context)?.moreOptions ?? 'More options',
        onSelected: (value) {
          switch (value) {
            case 'edit':
              if (onEdit != null) onEdit!();
              break;
            case 'close':
              if (onClose != null) onClose!();
              break;
            case 'unclose':
              if (onUnclose != null) onUnclose!();
              break;
            case 'leave':
              if (onLeave != null) onLeave!();
              break;
            case 'report':
              if (onReport != null) onReport!();
              break;
          }
        },
        itemBuilder: (BuildContext context) => [
          // Edit conversation (only for XenForo and if canEdit is true)
          if (canEdit && siteContext.siteType == 'xenforo' && onEdit != null)
            PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: colorScheme.onSurface,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Edit conversation',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          // Close/Unclose conversation
          if (canClose && !isClosed && onClose != null)
            PopupMenuItem<String>(
              value: 'close',
              child: Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    color: colorScheme.onSurface,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Close conversation',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          if (canClose && isClosed && onUnclose != null)
            PopupMenuItem<String>(
              value: 'unclose',
              child: Row(
                children: [
                  Icon(
                    Icons.lock_open_outlined,
                    color: colorScheme.onSurface,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Open conversation',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          // Divider between close/unclose and other actions
          if (canClose && (onLeave != null || onReport != null)) const PopupMenuDivider(),
          // Leave conversation
          if (onLeave != null)
            PopupMenuItem<String>(
              value: 'leave',
              child: Row(
                children: [
                  Icon(
                    Icons.exit_to_app_rounded,
                    color: colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Leave conversation',
                    style: TextStyle(
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          // Report (if available)
          if (onReport != null)
            PopupMenuItem<String>(
              value: 'report',
              child: Row(
                children: [
                  Icon(
                    Icons.flag_outlined,
                    color: colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Report conversation',
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

  static void showParticipantsBottomSheet(
    BuildContext context,
    List<FCParticipant> participants,
    SiteContext siteContext, {
    bool canInvite = false,
    String? conversationId,
    VoidCallback? onInviteSuccess,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(DesignTokens.radiusL)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingL, horizontal: DesignTokens.spacingL),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people_rounded, color: Theme.of(context).colorScheme.primary),
                      SizedBox(width: DesignTokens.spacingS),
                      Text(AppLocalizations.of(context)?.participantsLabel ?? 'Participants', style: Theme.of(context).textTheme.titleMedium),
                      const Spacer(),
                      if (canInvite && conversationId != null)
                        IconButton(
                          icon: Icon(Icons.person_add_rounded, color: Theme.of(context).colorScheme.primary),
                          tooltip: AppLocalizations.of(context)?.invite ?? 'Invite',
                          onPressed: () => _handleInvite(context, participants, siteContext, conversationId, onInviteSuccess),
                        ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: DesignTokens.spacingL),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: participants.length,
                      itemBuilder: (context, index) {
                        final participant = participants[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingS),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // Close bottom sheet
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfilePage(
                                    siteContext: siteContext,
                                    userId: participant.userId,
                                    userName: participant.username,
                                    profilePictureUrl: participant.iconUrl,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                UserAvatar(
                                  username: participant.username,
                                  iconUrl: participant.iconUrl,
                                  radius: DesignTokens.avatarRadiusM,
                                  cacheKey: participant.iconUrl != null && participant.iconUrl!.isNotEmpty
                                      ? AvatarCacheUtils.generateAvatarCacheKey(
                                          userId: participant.userId,
                                          username: participant.username,
                                          avatarUrl: participant.iconUrl!,
                                        )
                                      : null,
                                ),
                                SizedBox(width: DesignTokens.spacingM),
                                Text(participant.username, style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Future<void> _handleInvite(
    BuildContext context,
    List<FCParticipant> participants,
    SiteContext siteContext,
    String conversationId,
    VoidCallback? onInviteSuccess,
  ) async {
    // Get list of existing participant usernames to filter out
    final existingUsernames = participants.map((p) => p.username).toList();

    // Navigate to user search page
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => UserSearchPage(
          siteContext: siteContext,
          selectedUsers: existingUsernames,
          onUserSelected: (username, iconUrl) {
            // This callback is not used, we handle the result via Navigator.pop
          },
        ),
      ),
    );

    if (result != null && result['username'] != null) {
      final username = result['username'] as String;

      // Show loading indicator
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
        final inviteResult = await conversationProxy.inviteParticipantAsync(
          [username],
          conversationId,
          null, // No reason for now
        );

        if (!context.mounted) return;
        Navigator.pop(context); // Close loading dialog

        if (inviteResult.result) {
          // Close participants popup
          Navigator.pop(context);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$username has been invited to the conversation'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );

          // Refresh conversation data
          onInviteSuccess?.call();
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(inviteResult.resultText ?? AppLocalizations.of(context)?.errorInvitingUser('') ?? 'Failed to invite user'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } catch (e) {
        if (!context.mounted) return;
        Navigator.pop(context); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.errorInvitingUser(e.toString()) ?? 'Error inviting user: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
