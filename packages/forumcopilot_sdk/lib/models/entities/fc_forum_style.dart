import 'package:dart_mappable/dart_mappable.dart';

part 'fc_forum_style.mapper.dart';

/// A forum's look as its own style defines it, so the app can draw the forum
/// in its colours: a light scheme and a dark one, either of which the forum
/// may not have.
@MappableClass()
class FCForumStyle with FCForumStyleMappable {
  const FCForumStyle({this.light, this.dark});

  final FCStyleScheme? light;
  final FCStyleScheme? dark;

  /// From a getConfig `style` object; null when there is none (an older
  /// add-on, or a style it could not read) or it has neither scheme.
  static FCForumStyle? fromJson(Object? json) {
    if (json is! Map) return null;
    final light = FCStyleScheme.fromJson(json['light']);
    final dark = FCStyleScheme.fromJson(json['dark']);
    if (light == null && dark == null) return null;
    return FCForumStyle(light: light, dark: dark);
  }
}

/// One scheme of a forum's style. Colours are `#rrggbb`; any may be missing.
@MappableClass()
class FCStyleScheme with FCStyleSchemeMappable {
  const FCStyleScheme({
    this.headerBackground,
    this.headerText,
    this.page,
    this.content,
    this.text,
    this.link,
    this.button,
    this.buttonText,
    this.accent,
    this.error,
    this.success,
    this.themeColor,
    this.logo,
    this.logoWidth,
    this.logoHeight,
  });

  /// The forum's header bar and the text on it.
  final String? headerBackground;
  final String? headerText;

  /// The page behind the content, the content's own background, and text.
  final String? page;
  final String? content;
  final String? text;
  final String? link;

  /// The primary button and the text on it.
  final String? button;
  final String? buttonText;

  /// The style's accent (XenForo's paletteAccent2).
  final String? accent;
  final String? error;
  final String? success;

  /// The browser's theme colour.
  final String? themeColor;

  /// The header logo, drawn for [headerBackground], and its size.
  final String? logo;
  final int? logoWidth;
  final int? logoHeight;

  static final RegExp _hex = RegExp(r'^#[0-9a-fA-F]{6}$');

  /// From one scheme of a getConfig `style`; null when it is not an object
  /// or has no colour. Values that are not `#rrggbb` are dropped.
  static FCStyleScheme? fromJson(Object? json) {
    if (json is! Map) return null;
    String? color(String key) {
      final v = json[key];
      return v is String && _hex.hasMatch(v.trim()) ? v.trim().toLowerCase() : null;
    }

    int? size(String key) {
      final v = json[key];
      final n = v is int ? v : (v is String ? int.tryParse(v) : null);
      return n != null && n > 0 ? n : null;
    }

    final logo = json['logo'];
    final scheme = FCStyleScheme(
      headerBackground: color('headerBackground'),
      headerText: color('headerText'),
      page: color('page'),
      content: color('content'),
      text: color('text'),
      link: color('link'),
      button: color('button'),
      buttonText: color('buttonText'),
      accent: color('accent'),
      error: color('error'),
      success: color('success'),
      themeColor: color('themeColor'),
      logo: logo is String && logo.trim().startsWith('http') ? logo.trim() : null,
      logoWidth: size('logoWidth'),
      logoHeight: size('logoHeight'),
    );
    final hasColour = [
      scheme.headerBackground, scheme.headerText, scheme.page, scheme.content, scheme.text, scheme.link,
      scheme.button, scheme.buttonText, scheme.accent, scheme.error, scheme.success, scheme.themeColor,
    ].any((c) => c != null);
    return hasColour ? scheme : null;
  }
}
