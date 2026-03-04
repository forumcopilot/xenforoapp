import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';
import '../../utils/safe_image.dart';
import '../../utils/avatar_color_utils.dart';
import '../../l10n/generated/app_localizations.dart';
import 'forum_icon_widget.dart';

/// Widget that displays subforum icon, name, and description
/// Used in the subforum view page below the breadcrumb
class SubforumHeaderWidget extends StatelessWidget {
  final FCForum forum;
  final SiteContext? siteContext;
  final VoidCallback? onNewTopic;

  const SubforumHeaderWidget({
    super.key,
    required this.forum,
    this.siteContext,
    this.onNewTopic,
  });

  /// Gets the primary color for the background based on whether a logo is present
  /// If no logo, uses the avatar's base color to match the default logo
  Color _getBackgroundThemeColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // If logo URL exists and is not empty, use theme primary color
    if (forum.logoUrl != null && forum.logoUrl!.isNotEmpty) {
      return colorScheme.primary;
    }
    
    // If no logo, extract a vibrant primary color from the avatar's color scheme
    // This ensures the background matches the default avatar logo color
    if (forum.name.isEmpty) {
      return colorScheme.primary;
    }
    
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    
    // Get gradient colors to extract the base color family
    final gradientColors = AvatarColorUtils.getGradientColors(
      forum.name,
      isLightTheme: isLightTheme,
    );
    
    if (gradientColors.isEmpty) {
      return colorScheme.primary;
    }
    
    // Use the more saturated color from the gradient for background tinting
    // For light mode: gradient goes shade100 -> shade300, use shade300 (more visible)
    // For dark mode: gradient goes shade700 -> shade500, use shade500 (more vibrant)
    // This will create a cohesive look with the default avatar logo
    return gradientColors.length >= 2 ? gradientColors[1] : gradientColors[0];
  }

  /// Darkens a color by blending it with black
  /// [color] The color to darken
  /// [amount] Amount to darken (0.0 to 1.0), where 1.0 is completely black
  Color _darkenColor(Color color, double amount) {
    assert(amount >= 0.0 && amount <= 1.0);
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness * (1 - amount)).clamp(0.0, 1.0)).toColor();
  }

  /// Gets a darker version of the color for dark mode pattern
  Color _getDarkModePatternColor(Color baseColor) {
    // Darken the color significantly for dark mode (about 60-70% darker)
    return _darkenColor(baseColor, 0.65);
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
                        // Matches default logo color when no logo is present
                        ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            (isDarkMode 
                              ? _getDarkModePatternColor(_getBackgroundThemeColor(context))
                              : _getBackgroundThemeColor(context)
                            ).withOpacity(
                              isDarkMode ? DesignTokens.opacityHigh : DesignTokens.opacityMediumLow,  // Much higher opacity in dark mode for darker effect
                            ),
                            isDarkMode 
                              ? BlendMode.multiply  // Darker blend for dark mode - makes pattern more visible
                              : BlendMode.color,   // Stronger color application for light mode
                          ),
                          child: Image.asset(
                            'assets/forum_header_bg.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        // Text readability overlay - darker in dark mode to make pattern more subtle
                        Container(
                          color: isDarkMode 
                            ? Colors.black.withOpacity(DesignTokens.opacityMediumLow)
                            : Colors.white.withOpacity(DesignTokens.opacityMedium),
                        ),
                      ],
                    ),
                    // Network background (only shown if URL exists and loads successfully)
                    Builder(
                      builder: (context) {
                        final backgroundUrl = forum.backgroundUrl;
                        if (backgroundUrl != null && backgroundUrl.isNotEmpty) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              // Network background image
                              SafeImageNetwork.networkSafe(
                                backgroundUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  // Return empty container when network image fails - default background will show
                                  return Container();
                                },
                              ),
                              // Color overlay for better text readability
                              Container(
                                color: isDarkMode 
                                  ? Colors.black.withOpacity(DesignTokens.opacityMediumLow)
                                  : Colors.white.withOpacity(DesignTokens.opacityHigh),
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Content - Centered icon, name, and description
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingL,
                vertical: DesignTokens.spacingXL,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Centered icon
                  ForumListItemIconWidget(
                    logoUrl: forum.logoUrl,
                    fallbackIcon: Icons.forum_rounded,
                    forumName: forum.name,
                  ),
                  // Spacing between icon and name
                  const SizedBox(height: DesignTokens.spacingL),
                  // Subforum name
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      forum.name,
                      style: StyleBuilders.titleTextStyle(
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                        fontSize: DesignTokens.fontSizeXL,
                        fontWeight: DesignTokens.fontWeightSemiBold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Description (if available)
                  if (forum.description != null && forum.description!.isNotEmpty) ...[
                    const SizedBox(height: DesignTokens.spacingM),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL),
                      child: Text(
                        forum.description!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: DesignTokens.lineHeightRelaxed,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  // New Topic button (if user is logged in and can post)
                  if (siteContext != null && 
                      siteContext!.isLoggedIn && 
                      forum.canPost && 
                      onNewTopic != null) ...[
                    const SizedBox(height: DesignTokens.spacingL),
                    FilledButton.icon(
                      onPressed: onNewTopic,
                      icon: const Icon(Icons.post_add_rounded),
                      label: Text(AppLocalizations.of(context)?.newTopic ?? 'New Topic'),
                      style: StyleBuilders.extendedFilledButtonStyle(
                        colorScheme: colorScheme,
                      ),
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

