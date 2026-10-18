import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum_style.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

/// The parts of a forum's look that Material's [ColorScheme] has no slot
/// for: its header bar (the colour, the text on it, its logo) and the accent
/// line under it. Read with [ForumColors.of]; null outside a forum that sends
/// its colours, where the header uses the page's colours.
@immutable
class ForumColors extends ThemeExtension<ForumColors> {
  const ForumColors({
    required this.headerBackground,
    required this.headerForeground,
    required this.line,
    this.logo,
    this.logoAspectRatio,
  });

  final Color headerBackground;

  /// Text and icons on the header, legible on it.
  final Color headerForeground;

  /// The accent line under the header.
  final Color line;

  /// The forum's header logo, drawn for [headerBackground]; null when this
  /// mode's header is not the one it was drawn for.
  final String? logo;

  /// Width over height, when the forum gives the logo's size.
  final double? logoAspectRatio;

  static ForumColors? of(BuildContext context) => Theme.of(context).extension<ForumColors>();

  @override
  ForumColors copyWith({
    Color? headerBackground,
    Color? headerForeground,
    Color? line,
    String? logo,
    double? logoAspectRatio,
  }) =>
      ForumColors(
        headerBackground: headerBackground ?? this.headerBackground,
        headerForeground: headerForeground ?? this.headerForeground,
        line: line ?? this.line,
        logo: logo ?? this.logo,
        logoAspectRatio: logoAspectRatio ?? this.logoAspectRatio,
      );

  @override
  ForumColors lerp(ForumColors? other, double t) {
    if (other == null) return this;
    return ForumColors(
      headerBackground: Color.lerp(headerBackground, other.headerBackground, t)!,
      headerForeground: Color.lerp(headerForeground, other.headerForeground, t)!,
      line: Color.lerp(line, other.line, t)!,
      logo: t < 0.5 ? logo : other.logo,
      logoAspectRatio: t < 0.5 ? logoAspectRatio : other.logoAspectRatio,
    );
  }
}

/// A forum's colours worked out for one mode: the accent the app's colour
/// scheme is built from, and the header's colours.
class ForumPalette {
  const ForumPalette._(this.accent, this.colors);

  /// The forum's accent (its link colour), as the forum has it.
  final Color accent;
  final ForumColors colors;

  /// [style] in [brightness]: its own scheme for that mode, or, where it has
  /// none (XenForo 2.2, or a style without a dark variation), its other
  /// scheme's accent, with its header kept only when that header suits the
  /// mode (a dark brand bar reads in dark mode too). Null when [style] gives
  /// no accent at all.
  static ForumPalette? resolve(FCForumStyle style, Brightness brightness, {required Color surface, required Color onSurface}) {
    final dark = brightness == Brightness.dark;
    final own = dark ? style.dark : style.light;
    final scheme = own ?? (dark ? style.light : style.dark);
    if (scheme == null) return null;
    final accent = parseHex(scheme.link) ?? parseHex(scheme.button) ?? parseHex(scheme.themeColor);
    if (accent == null) return null;

    var header = parseHex(scheme.headerBackground);
    var headerText = parseHex(scheme.headerText);
    var logo = scheme.logo;
    if (header != null && own == null && _isDark(header) != dark) {
      // Its header was drawn for the other mode: the page's colours here.
      header = null;
      headerText = null;
      logo = null;
    }
    final background = header ?? surface;
    var foreground = headerText ?? onSurface;
    if (contrastRatio(foreground, background) < 4.5) {
      foreground = contrastRatio(Colors.white, background) >= contrastRatio(Colors.black, background)
          ? Colors.white
          : Colors.black;
    }
    final line = parseHex(scheme.button) ?? accent;
    final w = scheme.logoWidth, h = scheme.logoHeight;
    return ForumPalette._(
      accent,
      ForumColors(
        headerBackground: background,
        headerForeground: foreground,
        line: line,
        logo: header != null ? logo : null,
        logoAspectRatio: w != null && h != null && h > 0 ? w / h : null,
      ),
    );
  }

  static bool _isDark(Color c) => c.computeLuminance() < 0.18;
}

/// `#rrggbb` as a colour, or null.
Color? parseHex(String? hex) {
  if (hex == null || hex.length != 7 || !hex.startsWith('#')) return null;
  final v = int.tryParse(hex.substring(1), radix: 16);
  return v == null ? null : Color(0xFF000000 | v);
}

/// WCAG contrast ratio of two opaque colours, 1 to 21.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// [color], darkened (on a light [page]) or lightened (on a dark one) in
/// tone, keeping its hue and chroma, until it reaches [ratio] against
/// [page]. Unchanged when it already does.
Color legibleOn(Color color, Color page, {double ratio = 4.5}) {
  if (contrastRatio(color, page) >= ratio) return color;
  final hct = Hct.fromInt(color.toARGB32());
  final towardsDark = page.computeLuminance() > 0.18;
  var tone = hct.tone;
  for (var i = 0; i < 100; i++) {
    tone += towardsDark ? -1 : 1;
    if (tone < 0 || tone > 100) break;
    final candidate = Color(Hct.from(hct.hue, hct.chroma, tone).toInt());
    if (contrastRatio(candidate, page) >= ratio) return candidate;
  }
  return towardsDark ? Colors.black : Colors.white;
}
