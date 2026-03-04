import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'design_tokens.dart';
import 'style_builders.dart';

/// Central theme configuration for the app.
/// Supports customizable seed color for future admin customization.
class AppTheme {
  static final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  // Customizable seed color (defaults to blue, can be changed by admin)
  static Color _customSeedColor = Colors.blue;

  /// Sets the seed color for theme generation.
  /// This will be used by forum admins to customize the app's color scheme.
  static void setSeedColor(Color color) {
    _customSeedColor = color;
  }

  /// Gets the current seed color.
  static Color get seedColor => _customSeedColor;

  static ThemeData get lightTheme {
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: _customSeedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: DesignTokens.elevationNone,
      ),
      cardTheme: StyleBuilders.cardTheme(
        colorScheme: lightColorScheme,
        elevation: DesignTokens.elevationMedium,
        borderRadius: DesignTokens.radiusM,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: StyleBuilders.elevatedButtonStyle(
          colorScheme: lightColorScheme,
          elevation: DesignTokens.elevationNone,
          borderRadius: DesignTokens.radiusS,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: StyleBuilders.textButtonStyle(
          colorScheme: lightColorScheme,
          borderRadius: DesignTokens.radiusS,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        ),
        contentPadding: DesignTokens.paddingInput,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        ),
        titleTextStyle: TextStyle(
          fontSize: DesignTokens.fontSizeL,
          fontWeight: DesignTokens.fontWeightBold,
          color: lightColorScheme.onSurface,
        ),
        contentTextStyle: TextStyle(
          fontSize: DesignTokens.fontSizeM,
          color: lightColorScheme.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radiusM),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: _customSeedColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: DesignTokens.elevationNone,
      ),
      cardTheme: StyleBuilders.cardTheme(
        colorScheme: darkColorScheme,
        elevation: DesignTokens.elevationMedium,
        borderRadius: DesignTokens.radiusM,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: StyleBuilders.elevatedButtonStyle(
          colorScheme: darkColorScheme,
          elevation: DesignTokens.elevationNone,
          borderRadius: DesignTokens.radiusS,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: StyleBuilders.textButtonStyle(
          colorScheme: darkColorScheme,
          borderRadius: DesignTokens.radiusS,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        ),
        contentPadding: DesignTokens.paddingInput,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        ),
        titleTextStyle: TextStyle(
          fontSize: DesignTokens.fontSizeL,
          fontWeight: DesignTokens.fontWeightBold,
          color: darkColorScheme.onSurface,
        ),
        contentTextStyle: TextStyle(
          fontSize: DesignTokens.fontSizeM,
          color: darkColorScheme.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radiusM),
          ),
        ),
      ),
    );
  }
}
