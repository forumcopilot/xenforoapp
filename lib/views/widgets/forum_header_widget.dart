import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_flutter/controllers/site_controller.dart';
import 'package:forumcopilot_flutter/utils/number_utils.dart';
import 'package:forumcopilot_flutter/l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart' as forumcopilot_sdk;
import 'package:forumcopilot_flutter/utils/safe_image.dart';
import 'package:forumcopilot_flutter/utils/avatar_color_utils.dart';
import '../../theme/design_tokens.dart';

class ForumHeaderWidget extends StatelessWidget {
  final forumcopilot_sdk.FCBoardStatResult? boardStats;
  final bool extendUnderAppBar;

  const ForumHeaderWidget({
    Key? key,
    this.boardStats,
    this.extendUnderAppBar = false,
  }) : super(key: key);

  String? _getDomain(String? url) {
    if (url == null || url.isEmpty) return null;
    try {
      final uri = Uri.parse(url);
      return uri.host.isNotEmpty ? uri.host : null;
    } catch (e) {
      return null;
    }
  }

  Widget _buildLogoContent(BuildContext context, String? logoUrl, String siteName) {
    // If we have a logo URL, try to load it
    if (logoUrl != null && logoUrl.isNotEmpty) {
      return SafeImageNetwork.networkSafe(
        logoUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        // If logo fails to load, fall back to first character avatar
        errorBuilder: (context, error, stackTrace) {
          return _buildInitialAvatar(context, siteName);
        },
      );
    }

    // If no logo, show the first character with gradient
    return _buildInitialAvatar(context, siteName);
  }

  Widget _buildInitialAvatar(BuildContext context, String siteName) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    
    // Get color scheme for the site name
    final avatarColors = AvatarColorUtils.getUserAvatarColorScheme(
      siteName,
      isLightTheme: isLightTheme,
    );
    
    // Generate gradient colors from the base color
    final gradientColors = AvatarColorUtils.getGradientColors(
      siteName,
      isLightTheme: isLightTheme,
    );
    
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Center(
        child: Text(
          siteName.isNotEmpty ? siteName[0].toUpperCase() : 'F',
          style: TextStyle(
            color: avatarColors['text']!,
            fontWeight: DesignTokens.fontWeightSemiBold,
            fontSize: 30, // 60 * 0.5
          ),
        ),
      ),
    );
  }

  /// Gets the primary color for the background based on whether a logo is present
  /// If no logo, uses the avatar's base color to match the default logo
  Color _getBackgroundThemeColor(BuildContext context, String? logoUrl, String siteName) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // If logo URL exists and is not empty, use theme primary color
    if (logoUrl != null && logoUrl.isNotEmpty) {
      return colorScheme.primary;
    }
    
    // If no logo, extract a vibrant primary color from the avatar's color scheme
    // This ensures the background matches the default avatar logo color
    if (siteName.isEmpty) {
      return colorScheme.primary;
    }
    
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    
    // Get gradient colors to extract the base color family
    final gradientColors = AvatarColorUtils.getGradientColors(
      siteName,
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final siteController = Get.put(SiteController());

    return Obx(() {
      final site = siteController.currentSite.value;
      final logoUrl = site?.logoUrl;
      final siteName = site?.name ?? (AppLocalizations.of(context)?.forum ?? 'Forum');
      final domain = _getDomain(site?.url);

      // Calculate padding based on whether it should extend under app bar
      final topPadding = extendUnderAppBar ? DesignTokens.spacingXL : DesignTokens.spacingL;
      final bottomPadding = DesignTokens.spacingL;

      // Wrap in IntrinsicHeight to make height dynamic based on content
      return IntrinsicHeight(
        child: ClipRect(
          child: Container(
            width: double.infinity,
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
                              ? _getDarkModePatternColor(_getBackgroundThemeColor(context, logoUrl, siteName))
                              : _getBackgroundThemeColor(context, logoUrl, siteName)
                            ).withOpacity(
                              isDarkMode ? 0.75 : 0.5,  // Much higher opacity in dark mode for darker effect
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
                            ? Colors.black.withOpacity(0.5)
                            : Colors.white.withOpacity(0.6),
                        ),
                      ],
                    ),
                    // Network background (only shown if URL exists and loads successfully)
                    Builder(
                      builder: (context) {
                        final backgroundUrl = site?.backgroundUrl;
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
                                  ? Colors.black.withOpacity(0.5)
                                  : Colors.white.withOpacity(0.7),
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
                // Forum Logo and Name - Left aligned
                Padding(
                padding: EdgeInsets.only(
                  left: DesignTokens.paddingScreenHorizontal.left,
                  right: DesignTokens.paddingScreenHorizontal.right,
                  top: topPadding,
                  bottom: bottomPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row with Logo and Name/Domain
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Forum Logo - always show
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                            color: colorScheme.surface,
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.shadow.withOpacity(DesignTokens.opacityLow),
                                blurRadius: 6,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                            child: _buildLogoContent(context, logoUrl, siteName),
                          ),
                        ),
                        SizedBox(width: DesignTokens.spacingM),
                        // Forum Name and Domain
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Forum Name
                              Text(
                                site?.name ?? 'Forum',
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontWeight: DesignTokens.fontWeightBold,
                                  fontSize: DesignTokens.fontSizeL,
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Domain Name
                              if (domain != null) ...[
                                SizedBox(height: DesignTokens.spacingXS / 2),
                                Text(
                                  domain,
                                  style: TextStyle(
                                    color: colorScheme.onSurface.withOpacity(DesignTokens.opacityMedium),
                                    fontSize: DesignTokens.fontSizeS,
                                    fontWeight: DesignTokens.fontWeightNormal,
                                  ),
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: DesignTokens.spacingS),
                    // Forum Description
                    Text(
                      site?.description ?? 'No description available.',
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(DesignTokens.opacityHigh),
                        fontSize: DesignTokens.fontSizeS,
                        fontWeight: DesignTokens.fontWeightMedium,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: DesignTokens.spacingS),
                    // Forum Statistics - Separate lines
                    if (boardStats != null && ((boardStats?.total_posts ?? 0) > 0 || (boardStats?.total_members ?? 0) > 0)) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((boardStats?.total_posts ?? 0) > 0)
                            Text(
                              '${formatNumber(context, boardStats?.total_posts ?? 0)} Posts',
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(DesignTokens.opacityHigh),
                                fontWeight: DesignTokens.fontWeightMedium,
                                fontSize: DesignTokens.fontSizeXS,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          if ((boardStats?.total_posts ?? 0) > 0 && (boardStats?.total_members ?? 0) > 0)
                            SizedBox(height: DesignTokens.spacingXS / 2),
                          if ((boardStats?.total_members ?? 0) > 0)
                            Text(
                              AppLocalizations.of(context)?.membersCount(boardStats?.total_members ?? 0) ?? '${formatNumber(context, boardStats?.total_members ?? 0)} Members',
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(DesignTokens.opacityHigh),
                                fontWeight: DesignTokens.fontWeightMedium,
                                fontSize: DesignTokens.fontSizeXS,
                              ),
                              textAlign: TextAlign.left,
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
        ),
      );
    });
  }
}
