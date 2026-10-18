import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum_style.dart';
import 'package:get/get.dart';
import 'design_tokens.dart';
import 'forum_colors.dart';
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

  /// The open forum's colours (its style, from getConfig), or null for the
  /// app's own. The app shell rebuilds its theme when this changes.
  static final Rxn<FCForumStyle> forumStyle = Rxn<FCForumStyle>();
  static String? _forumStyleOwner;
  static final Map<String, FCForumStyle?> _styleOf = {};
  static final Map<String, int> _openHomes = {};

  /// Draws the app in the colours of the forum at [owner] (its plugin URL)
  /// from now on; [style] null for a forum that does not send them.
  static void showForumStyle(String owner, FCForumStyle? style) {
    _styleOf[owner] = style;
    _forumStyleOwner = owner;
    if (forumStyle.value != style) forumStyle.value = style;
  }

  /// A Home of the forum at [owner] is open: its colours (known from its
  /// config) are shown again if another forum's were since.
  static void forumHomeOpened(String owner) {
    _openHomes[owner] = (_openHomes[owner] ?? 0) + 1;
    if (_forumStyleOwner != owner && _styleOf.containsKey(owner)) {
      showForumStyle(owner, _styleOf[owner]);
    }
  }

  /// A Home of the forum at [owner] closed: back to the app's own colours
  /// once none is open and no other forum took over. After the frame: the
  /// page is going away mid-frame, and a replacing Home (signing in
  /// replaces it) opens in the same frame.
  static void forumHomeClosed(String owner) {
    final open = (_openHomes[owner] ?? 1) - 1;
    if (open > 0) {
      _openHomes[owner] = open;
    } else {
      _openHomes.remove(owner);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_forumStyleOwner != owner || (_openHomes[owner] ?? 0) > 0) return;
      _forumStyleOwner = null;
      forumStyle.value = null;
    });
  }

  static ThemeData get lightTheme => themeFor(Brightness.light, forumStyle.value);

  static ThemeData get darkTheme => themeFor(Brightness.dark, forumStyle.value);

  // Built once per brightness, seed and forum style: the app shell rebuilds
  // on every locale or mode change, and ColorScheme.fromSeed is not free.
  static final Map<(Brightness, Color, FCForumStyle?), ThemeData> _themes = {};

  /// The theme for [brightness]: in [style]'s colours when given and usable,
  /// otherwise in the app's seed colour.
  ///
  /// The scheme is seeded from the forum's accent (its link colour), and the
  /// accent itself is the primary colour, darkened or lightened in tone only
  /// as far as it takes to read on the page (4.5:1). Pages stay Material's
  /// near-neutral surfaces; the forum's header colours go to [ForumColors],
  /// for the forum's own header.
  static ThemeData themeFor(Brightness brightness, [FCForumStyle? style]) =>
      _themes.putIfAbsent((brightness, _customSeedColor, style), () {
        final base = ColorScheme.fromSeed(seedColor: _customSeedColor, brightness: brightness);
        if (style == null) return _build(base);
        final accent = ForumPalette.resolve(style, brightness, surface: base.surface, onSurface: base.onSurface)?.accent;
        if (accent == null) return _build(base);
        var colorScheme = ColorScheme.fromSeed(seedColor: accent, brightness: brightness);
        final primary = legibleOn(accent, colorScheme.surface);
        colorScheme = colorScheme.copyWith(
          primary: primary,
          onPrimary: contrastRatio(Colors.white, primary) >= contrastRatio(Colors.black, primary) ? Colors.white : Colors.black,
        );
        final palette = ForumPalette.resolve(style, brightness, surface: colorScheme.surface, onSurface: colorScheme.onSurface)!;
        return _build(colorScheme, extensions: [palette.colors]);
      });

  static ThemeData _build(ColorScheme colorScheme, {List<ThemeExtension<dynamic>> extensions = const []}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: extensions,
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
