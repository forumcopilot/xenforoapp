import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';

/// How a forum presents itself at the top of its home: its name, a line
/// about it, its square logo, and the colours its header is drawn in.
@immutable
class ForumIdentity {
  const ForumIdentity({
    required this.name,
    required this.background,
    required this.foreground,
    required this.accent,
    this.description,
    this.icon,
    this.banner,
  });

  /// [site] in the current theme: the header in the page's colours, with the
  /// theme's accent along its bottom.
  factory ForumIdentity.of(BuildContext context, Site site) {
    final colorScheme = Theme.of(context).colorScheme;
    final description = site.description.trim();
    final icon = site.logoUrl?.trim();
    final banner = site.backgroundUrl?.trim();
    return ForumIdentity(
      name: site.displayName,
      description: description.isEmpty ? null : description,
      icon: icon == null || icon.isEmpty ? null : icon,
      banner: banner == null || banner.isEmpty ? null : banner,
      background: colorScheme.surface,
      foreground: colorScheme.onSurface,
      accent: colorScheme.primary,
    );
  }

  final String name;
  final String? description;

  /// The forum's square logo, or null for its initial.
  final String? icon;

  /// The forum's banner picture, shown behind its open header.
  final String? banner;
  final Color background;
  final Color foreground;

  /// The line under the header.
  final Color accent;

  bool get hasDarkBackground => ThemeData.estimateBrightnessForColor(background) == Brightness.dark;
}
