import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../utils/safe_image.dart';
import '../../utils/avatar_color_utils.dart';

class ForumIconWidget extends StatelessWidget {
  final String? logoUrl;
  final IconData? fallbackIcon;
  final double size;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? iconColor;
  final String context; // 'header', 'subforum', or 'default'
  final String? siteName; // Site name for generating avatar when no logo

  const ForumIconWidget({
    super.key,
    this.logoUrl,
    this.fallbackIcon,
    this.size = 48,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor,
    this.iconColor,
    this.context = 'default',
    this.siteName,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surfaceVariant;
    final effectiveIconColor = iconColor ?? colorScheme.onSurfaceVariant;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(size * 0.2);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        color: effectiveBackgroundColor,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: _buildIconContent(context, effectiveIconColor),
      ),
    );
  }

  Widget _buildIconContent(BuildContext context, Color iconColor) {
    // If we have a logo URL, try to load it
    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return SafeImageNetwork.networkSafe(
        logoUrl!,
        width: size,
        height: size,
        fit: fit,
        // If logo fails to load and we have a site name, fall back to initial avatar
        errorBuilder: (context, error, stackTrace) {
          // If we have a site name, show the first character with gradient as fallback
          if (siteName != null && siteName!.isNotEmpty) {
            return _buildInitialAvatar(context);
          }
          // Otherwise show the fallback icon
          return Icon(
            fallbackIcon ?? Icons.forum_rounded,
            size: size * 0.6,
            color: iconColor,
          );
        },
        fallbackIcon: fallbackIcon ?? Icons.forum_rounded,
      );
    }

    // If we have a site name but no logo, show the first character with gradient
    if (siteName != null && siteName!.isNotEmpty) {
      return _buildInitialAvatar(context);
    }

    // Otherwise use the context-appropriate default icon
    return Image.asset(
      AppIcons.getDefaultIcon(this.context),
      width: size,
      height: size,
      fit: fit,
    );
  }

  Widget _buildInitialAvatar(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isLightTheme = Theme.of(context).brightness == Brightness.light;
    
    // Get color scheme for the site name
    final avatarColors = AvatarColorUtils.getUserAvatarColorScheme(
      siteName!,
      isLightTheme: isLightTheme,
    );
    
    // Generate gradient colors from the base color
    final baseColor = avatarColors['background']!;
    final gradientColors = _getGradientColors(siteName!, baseColor, isLightTheme);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Center(
        child: Text(
          siteName![0].toUpperCase(),
          style: textTheme.titleLarge?.copyWith(
            color: avatarColors['text']!,
            fontWeight: FontWeight.w600,
            fontSize: size * 0.5,
          ),
        ),
      ),
    );
  }

  /// Generates gradient colors optimized for light and dark modes
  /// Uses the same color selection logic as AvatarColorUtils to ensure consistency
  List<Color> _getGradientColors(String siteName, Color baseColor, bool isLightTheme) {
    // Import the same color list used in AvatarColorUtils
    const List<MaterialColor> avatarColors = [
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      Colors.amber,
      Colors.lime,
      Colors.indigo,
      Colors.brown,
      Colors.cyan,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.lightBlue,
      Colors.lightGreen,
    ];
    
    // Get the same base MaterialColor used for this site name
    int index = siteName.hashCode % avatarColors.length;
    MaterialColor baseMaterialColor = avatarColors[index.abs()];
    
    if (isLightTheme) {
      // For light mode: gradient from shade100 (lighter) to shade300 (darker)
      return [
        baseMaterialColor.shade100,
        baseMaterialColor.shade300,
      ];
    } else {
      // For dark mode: gradient from shade700 (darker) to shade500 (lighter)
      return [
        baseMaterialColor.shade700,
        baseMaterialColor.shade500,
      ];
    }
  }

}

// Specialized widget for forum headers with larger size
class ForumHeaderIconWidget extends StatelessWidget {
  final String? logoUrl;
  final IconData? fallbackIcon;

  const ForumHeaderIconWidget({
    super.key,
    this.logoUrl,
    this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ForumIconWidget(
      logoUrl: logoUrl,
      fallbackIcon: fallbackIcon,
      size: 80,
      borderRadius: BorderRadius.circular(16),
      context: 'header',
    );
  }
}

// Specialized widget for forum list items
class ForumListItemIconWidget extends StatelessWidget {
  final String? logoUrl;
  final IconData? fallbackIcon;
  final String? forumName;

  const ForumListItemIconWidget({
    super.key,
    this.logoUrl,
    this.fallbackIcon,
    this.forumName,
  });

  @override
  Widget build(BuildContext context) {
    return ForumIconWidget(
      logoUrl: logoUrl,
      fallbackIcon: fallbackIcon,
      size: 56,
      borderRadius: BorderRadius.circular(12),
      context: 'subforum',
      siteName: forumName,
    );
  }
}

// Specialized widget for app bar icons
class AppBarIconWidget extends StatelessWidget {
  final String? logoUrl;
  final IconData? fallbackIcon;
  final String? siteName;

  const AppBarIconWidget({
    super.key,
    this.logoUrl,
    this.fallbackIcon,
    this.siteName,
  });

  @override
  Widget build(BuildContext context) {
    return ForumIconWidget(
      logoUrl: logoUrl,
      fallbackIcon: fallbackIcon,
      size: 32,
      borderRadius: BorderRadius.circular(8),
      context: 'header',
      siteName: siteName,
    );
  }
}

// Specialized widget for bottom sheet icons
class BottomSheetIconWidget extends StatelessWidget {
  final String? logoUrl;
  final IconData? fallbackIcon;

  const BottomSheetIconWidget({
    super.key,
    this.logoUrl,
    this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ForumIconWidget(
      logoUrl: logoUrl,
      fallbackIcon: fallbackIcon,
      size: 48,
      borderRadius: BorderRadius.circular(10),
      context: 'subforum',
    );
  }
}
