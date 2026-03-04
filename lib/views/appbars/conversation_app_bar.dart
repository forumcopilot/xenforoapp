import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_conversation_result.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:forumcopilot_flutter/views/user_profile_page.dart';
import 'package:forumcopilot_flutter/utils/avatar_cache_utils.dart';
import 'package:forumcopilot_flutter/views/user_search_page.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_flutter/utils/avatar_color_utils.dart';
import 'package:forumcopilot_flutter/theme/style_builders.dart';
import 'dart:math' as math;

class ConversationAppBar extends StatelessWidget implements PreferredSizeWidget {
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
    super.key,
  }) : _title = title;

  final String _title;
  final VoidCallback? onLeave;
  final VoidCallback? onMarkUnread;
  final VoidCallback? onReport;
  final int participantCount;
  final bool canEdit;
  final bool canClose;
  final bool isClosed;
  final List<FCParticipant>? participants;
  final bool canInvite;
  final String? conversationId;
  final VoidCallback? onInviteSuccess;

  @override
  Size get preferredSize => const Size.fromHeight(180); // Taller header to accommodate avatars

  /// Gets the primary color for the background based on conversation title
  Color _getBackgroundThemeColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (_title.isEmpty) {
      return colorScheme.primary;
    }
    
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    
    // Get gradient colors to extract the base color family
    final gradientColors = AvatarColorUtils.getGradientColors(
      _title,
      isLightTheme: isLightTheme,
    );
    
    if (gradientColors.isEmpty) {
      return colorScheme.primary;
    }
    
    // Use the more saturated color from the gradient for background tinting
    return gradientColors.length >= 2 ? gradientColors[1] : gradientColors[0];
  }

  /// Darkens a color by blending it with black
  Color _darkenColor(Color color, double amount) {
    assert(amount >= 0.0 && amount <= 1.0);
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness * (1 - amount)).clamp(0.0, 1.0)).toColor();
  }

  /// Gets a darker version of the color for dark mode pattern
  Color _getDarkModePatternColor(Color baseColor) {
    return _darkenColor(baseColor, 0.65);
  }

  /// Builds overlapping avatars widget
  Widget _buildOverlappingAvatars(BuildContext context, List<FCParticipant> participants, ColorScheme colorScheme) {
    if (participants.isEmpty) {
      return const SizedBox.shrink();
    }

    final avatarRadius = 20.0; // Larger avatars for header
    final avatarSize = avatarRadius * 2;
    final overlapOffset = avatarSize * 0.5; // 50% overlap
    
    // Limit to first 5 participants for better visual appearance
    final avatarsToShow = math.min(5, participants.length);
    final totalWidth = avatarSize + (avatarsToShow - 1) * overlapOffset;

    return SizedBox(
      width: totalWidth,
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Show avatars
          ...List.generate(avatarsToShow, (index) {
            final participant = participants[index];
            return Positioned(
              left: index * overlapOffset,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: UserAvatar(
                  username: participant.username,
                  iconUrl: participant.iconUrl,
                  radius: avatarRadius,
                  cacheKey: participant.iconUrl != null && participant.iconUrl!.isNotEmpty
                      ? AvatarCacheUtils.generateAvatarCacheKey(
                          userId: participant.userId,
                          username: participant.username,
                          avatarUrl: participant.iconUrl!,
                        )
                      : null,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) => Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            color: colorScheme.onSurface,
          ),
        ),
      ),
      actions: buildActions(context),
      flexibleSpace: ClipRect(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityMediumLow),
                width: DesignTokens.borderWidthThin,
              ),
            ),
          ),
          child: Stack(
            children: [
              // Background Image - covers full height, clipped to container bounds
              Positioned.fill(
                child: ClipRect(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Default background with theme color applied
                      Stack(
                        fit: StackFit.expand,
                        children: [
                          // Base background color
                          Container(
                            color: colorScheme.surfaceVariant,
                          ),
                          // Pattern image with theme color tint
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              (isDarkMode 
                                ? _getDarkModePatternColor(_getBackgroundThemeColor(context))
                                : _getBackgroundThemeColor(context)
                              ).withOpacity(
                                isDarkMode ? DesignTokens.opacityHigh : DesignTokens.opacityMediumLow,
                              ),
                              isDarkMode 
                                ? BlendMode.multiply
                                : BlendMode.color,
                            ),
                            child: Image.asset(
                              'assets/forum_header_bg.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          // Text readability overlay
                          Container(
                            color: isDarkMode 
                              ? Colors.black.withOpacity(DesignTokens.opacityMediumLow)
                              : Colors.white.withOpacity(DesignTokens.opacityMedium),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Content - Centered avatars, title, and participant count
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: DesignTokens.spacingL,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Overlapping avatars
                      if (participants != null && participants!.isNotEmpty)
                        _buildOverlappingAvatars(context, participants!, colorScheme),
                      // Title
                      if (_title.isNotEmpty) ...[
                        const SizedBox(height: DesignTokens.spacingM),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
                          child: Text(
                            _title,
                            style: StyleBuilders.titleTextStyle(
                              colorScheme: colorScheme,
                              textTheme: textTheme,
                              fontSize: DesignTokens.fontSizeL,
                              fontWeight: DesignTokens.fontWeightSemiBold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      // Participant count
                      if (participantCount > 0) ...[
                        const SizedBox(height: DesignTokens.spacingS),
                        Text(
                          '$participantCount ${participantCount == 1 ? 'participant' : 'participants'}',
                          style: StyleBuilders.titleTextStyle(
                            colorScheme: colorScheme,
                            textTheme: textTheme,
                            fontSize: DesignTokens.fontSizeM,
                            fontWeight: DesignTokens.fontWeightMedium,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return [
      // Participants button
      if (participants != null && participants!.isNotEmpty)
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
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
        ),
      // Mark as unread button
      if (onMarkUnread != null)
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.mark_email_unread_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            tooltip: AppLocalizations.of(context)?.markAsUnread ?? 'Mark as unread',
            onPressed: onMarkUnread,
          ),
        ),
      // More options menu
      Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: colorScheme.onSurfaceVariant,
          ),
          tooltip: AppLocalizations.of(context)!.moreOptions,
          onSelected: (value) {
            switch (value) {
              case 'leave':
                if (onLeave != null) onLeave!();
                break;
              case 'report':
                if (onReport != null) onReport!();
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
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
                      AppLocalizations.of(context)!.leaveConversation,
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
                      AppLocalizations.of(context)!.reportConversation,
                      style: TextStyle(
                        color: colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
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
                      Text(AppLocalizations.of(context)!.participants(participants.length), style: Theme.of(context).textTheme.titleMedium),
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
              content: Text(AppLocalizations.of(context)!.usernameHasBeenInvited(username)),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );

          // Refresh conversation data
          onInviteSuccess?.call();
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(inviteResult.resultText ?? 'Failed to invite user'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } catch (e) {
        if (!context.mounted) return;
        Navigator.pop(context); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorInvitingUser(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
