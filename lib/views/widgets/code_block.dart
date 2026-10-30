import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:highlight/highlight.dart' show highlight, Node;

import '../../l10n/generated/app_localizations.dart';
import '../../theme/design_tokens.dart';
import '../../theme/forum_colors.dart';

/// A code block as the website shows it: coloured by its language (XenForo's
/// `[CODE=php]`, sent as `data-lang`), scrolling sideways instead of
/// wrapping, with a copy button in the corner. Adapted from forum_kit's
/// CodeBlock (Flapp, the Discourse app).
///
/// Colours are the a11y palettes (light/dark), every token then held to
/// 4.5:1 against the block's own background. Unknown languages, and code
/// sent without one, stay plain.
class CodeBlock extends StatelessWidget {
  const CodeBlock({super.key, required this.code, required this.textStyle, this.language, this.background});

  final String code;
  final TextStyle textStyle;

  /// The block's fill; surfaceContainerHighest by default. A block inside a
  /// quote takes another, or it would vanish into the quote's own fill.
  final Color? background;

  /// XenForo's language name (`php`, `html`, `javascript`, ...), or null.
  final String? language;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fill = background ?? colorScheme.surfaceContainerHighest;
    final spans = highlightSpans(code, language, readableTheme(dark ? a11yDarkTheme : a11yLightTheme, fill));

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        // Clipped: the copy button's 48dp is taller than a one-line block.
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              // Room on the right so the first lines' ends aren't under the
              // copy button.
              padding: const EdgeInsets.fromLTRB(
                DesignTokens.spacingM,
                DesignTokens.spacingM,
                DesignTokens.spacingXXXL,
                DesignTokens.spacingM,
              ),
              // Plain text: SelectableText would take the sideways drag for
              // selecting. The copy button covers that.
              child: Text.rich(
                TextSpan(style: textStyle.copyWith(color: textStyle.color ?? colorScheme.onSurface), children: spans),
                softWrap: false,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              // Filled in the block's colour over its whole 48dp target: a
              // long line scrolls under it (the button's own fill is a 40dp
              // circle, which let the code show round its edges).
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(DesignTokens.radiusM),
                    bottomLeft: Radius.circular(DesignTokens.radiusM),
                  ),
                ),
                child: IconButton(
                  tooltip: l10n.copyToClipboard,
                  icon: Icon(Icons.copy_rounded, size: 18, color: colorScheme.onSurfaceVariant),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    if (!context.mounted) return;
                    ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
                      content: Text(l10n.copied),
                      duration: const Duration(seconds: 2),
                    ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// [code] as coloured spans; plain when the language is none or unknown.
  static List<InlineSpan> highlightSpans(String code, String? language, Map<String, TextStyle> theme) {
    final lang = language?.trim().toLowerCase();
    if (lang == null || lang.isEmpty || lang == 'plaintext' || lang == 'text' || lang == 'rich') {
      return [TextSpan(text: code)];
    }
    List<Node>? nodes;
    try {
      nodes = highlight.parse(code, language: _aliases[lang] ?? lang).nodes;
    } catch (_) {
      nodes = null;
    }
    if (nodes == null) return [TextSpan(text: code)];

    final out = <InlineSpan>[];
    void walk(Node node, List<InlineSpan> into) {
      final style = node.className == null ? null : theme[node.className!];
      if (node.value != null) {
        into.add(TextSpan(text: node.value, style: _noBackground(style)));
      } else if (node.children != null) {
        final children = <InlineSpan>[];
        for (final c in node.children!) {
          walk(c, children);
        }
        into.add(TextSpan(style: _noBackground(style), children: children));
      }
    }

    for (final n in nodes) {
      walk(n, out);
    }
    return out;
  }

  static final Map<(Map<String, TextStyle>, int), Map<String, TextStyle>> _readable = {};

  /// [theme] with every token colour adjusted, hue kept, to at least 4.5:1
  /// against [background]. Computed once per theme and background.
  static Map<String, TextStyle> readableTheme(Map<String, TextStyle> theme, Color background) =>
      _readable.putIfAbsent((theme, background.toARGB32()), () => {
            for (final e in theme.entries)
              e.key: e.value.color == null ? e.value : e.value.copyWith(color: legibleOn(e.value.color!, background)),
          });

  /// Names XenForo's code BBCode accepts that the grammar set spells
  /// differently.
  static const Map<String, String> _aliases = {
    'html': 'xml',
    'js': 'javascript',
    'sh': 'bash',
    'shell': 'bash',
    'py': 'python',
    'rb': 'ruby',
    'yml': 'yaml',
  };

  // Token backgrounds fight the block's own.
  static TextStyle? _noBackground(TextStyle? s) => s?.copyWith(backgroundColor: Colors.transparent);
}
