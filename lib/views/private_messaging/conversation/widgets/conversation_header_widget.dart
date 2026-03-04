import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_conversation_result.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import '../../../../theme/design_tokens.dart';
import '../../../../theme/style_builders.dart';
import 'package:forumcopilot_flutter/utils/avatar_color_utils.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:forumcopilot_flutter/utils/avatar_cache_utils.dart';
import '../appbars/conversation_app_bar.dart';
import 'dart:math' as math;

/// Widget that displays conversation header with overlapping avatars, title, and participant count
/// Similar to subforum header style
class ConversationHeaderWidget extends StatelessWidget {
  final String title;
  final List<FCParticipant>? participants;
  final int participantCount;
  final SiteContext? siteContext;
  final bool canInvite;
  final String? conversationId;
  final VoidCallback? onInviteSuccess;

  const ConversationHeaderWidget({
    super.key,
    required this.title,
    this.participants,
    this.participantCount = 0,
    this.siteContext,
    this.canInvite = false,
    this.conversationId,
    this.onInviteSuccess,
  });

  /// Gets the primary color for the background based on conversation title
  Color _getBackgroundThemeColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (title.isEmpty) {
      return colorScheme.primary;
    }
    
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    
    // Get gradient colors to extract the base color family
    final gradientColors = AvatarColorUtils.getGradientColors(
      title,
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

    return ClipRect(
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
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingL,
                vertical: DesignTokens.spacingXL,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Overlapping avatars
                  if (participants != null && participants!.isNotEmpty)
                    _buildOverlappingAvatars(context, participants!, colorScheme),
                  // Title
                  if (title.isNotEmpty) ...[
                    const SizedBox(height: DesignTokens.spacingM),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        title,
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
                  // Participant count (clickable)
                  if (participantCount > 0) ...[
                    const SizedBox(height: DesignTokens.spacingS),
                    participants != null && participants!.isNotEmpty && siteContext != null
                        ? InkWell(
                            onTap: () {
                              ConversationAppBar.showParticipantsBottomSheet(
                                context,
                                participants!,
                                siteContext!,
                                canInvite: canInvite,
                                conversationId: conversationId,
                                onInviteSuccess: onInviteSuccess,
                              );
                            },
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Text(
                                '$participantCount ${participantCount == 1 ? 'participant' : 'participants'}',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontSize: DesignTokens.fontSizeS,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Text(
                            '$participantCount ${participantCount == 1 ? 'participant' : 'participants'}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontSize: DesignTokens.fontSizeS,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

