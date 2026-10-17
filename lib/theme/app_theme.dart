import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'design_tokens.dart';
import 'style_builders.dart';

/// Central theme configuration for the app.
///
/// Material 3's defaults wherever the spec has one, as the Discourse app
/// does (forum_kit's AppTheme): screens take their look from here instead
/// of restyling each component. The theme used to force 8dp button
/// corners (Material 3 buttons are fully rounded), centred app-bar titles,
/// 12dp dialogs with a 20sp bold title and shorter text fields, and the
/// screens then restyled them again.
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

  static ThemeData get lightTheme => themeFor(Brightness.light);

  static ThemeData get darkTheme => themeFor(Brightness.dark);

  // Built once per brightness and seed: the app shell rebuilds on every
  // locale or mode change, and ColorScheme.fromSeed is not free.
  static final Map<(Brightness, Color), ThemeData> _themes = {};

  /// The theme for [brightness] in the app's seed colour.
  static ThemeData themeFor(Brightness brightness) =>
      _themes.putIfAbsent((brightness, _customSeedColor), () {
        return _build(ColorScheme.fromSeed(
          seedColor: _customSeedColor,
          brightness: brightness,
        ));
      });

  static ThemeData _build(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      // Small top app bar: titleLarge, aligned to the start, flat until
      // content scrolls under it.
      appBarTheme: const AppBarTheme(centerTitle: false),
      // Floating buttons (New Topic, New Message) in the accent, as the
      // forum's own buttons are, not Material's tonal container.
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      cardTheme: StyleBuilders.cardTheme(
        colorScheme: colorScheme,
        elevation: DesignTokens.elevationMedium,
        borderRadius: DesignTokens.radiusM,
      ),
      // Outlined text field: 4dp corners and 56dp high (see paddingInput).
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: DesignTokens.paddingInput,
      ),
      // Sheets keep Material 3's 28dp top corners and get its drag handle.
      bottomSheetTheme: const BottomSheetThemeData(showDragHandle: true),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
