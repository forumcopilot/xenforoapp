import 'package:flutter/material.dart';

/// Utility class for generating consistent avatar colors for users
class AvatarColorUtils {
  /// Material Design 3 compatible colors for user avatars
  /// These colors provide good contrast and work well in both light and dark themes
  static const List<MaterialColor> _avatarColors = [
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

  /// Generates a consistent background color for a user avatar based on their username
  ///
  /// This ensures the same user always gets the same color, providing visual consistency
  /// while making the UI more colorful and easier to distinguish between users.
  ///
  /// [username] The username to generate a color for
  /// [isLightTheme] Whether the current theme is light (defaults to true)
  ///
  /// Returns a Material Design 3 compatible color with appropriate lightness
  static Color getUserAvatarColor(String username, {bool isLightTheme = true}) {
    if (username.isEmpty) {
      return Colors.grey.shade300;
    }

    // Generate a consistent index based on the username hash
    int index = username.hashCode % _avatarColors.length;
    MaterialColor baseColor = _avatarColors[index.abs()];

    // Adjust the color based on the theme
    if (isLightTheme) {
      // For light theme, use lighter shades (100-200 range)
      return baseColor.shade100;
    } else {
      // For dark theme, use darker shades (700-800 range)
      return baseColor.shade700;
    }
  }

  /// Generates a text color that provides good contrast against the avatar background
  ///
  /// [backgroundColor] The background color of the avatar
  ///
  /// Returns either black or white text color for optimal contrast
  static Color getTextColorForBackground(Color backgroundColor) {
    // Calculate the relative luminance of the background color
    final luminance = backgroundColor.computeLuminance();

    // If the background is light (luminance > 0.5), use dark text
    // If the background is dark (luminance <= 0.5), use light text
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  /// Generates a complete color scheme for a user avatar
  ///
  /// [username] The username to generate colors for
  /// [isLightTheme] Whether the current theme is light
  ///
  /// Returns a map with 'background' and 'text' colors
  static Map<String, Color> getUserAvatarColorScheme(String username, {bool isLightTheme = true}) {
    final backgroundColor = getUserAvatarColor(username, isLightTheme: isLightTheme);
    final textColor = getTextColorForBackground(backgroundColor);

    return {
      'background': backgroundColor,
      'text': textColor,
    };
  }

  /// Generates gradient colors optimized for light and dark modes
  /// Uses the same color selection logic to ensure consistency
  ///
  /// [username] The username to generate gradient colors for
  /// [isLightTheme] Whether the current theme is light
  ///
  /// Returns a list of two colors for a gradient (from lighter to darker or vice versa)
  static List<Color> getGradientColors(String username, {bool isLightTheme = true}) {
    if (username.isEmpty) {
      // Return grey gradient for empty username
      if (isLightTheme) {
        return [Colors.grey.shade100, Colors.grey.shade300];
      } else {
        return [Colors.grey.shade700, Colors.grey.shade500];
      }
    }

    // Generate a consistent index based on the username hash
    int index = username.hashCode % _avatarColors.length;
    MaterialColor baseMaterialColor = _avatarColors[index.abs()];

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
