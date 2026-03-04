import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Processes signature text by removing all BBCode except URL tags
/// and converting URL BBCode tags to clickable links
class SignatureProcessor {
  /// Processes signature text and returns TextSpans for RichText display
  /// Removes all BBCode tags except [url] and [url=...] tags
  /// Converts URL tags to clickable links
  static List<TextSpan> processSignature(String text, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final List<TextSpan> spans = [];

    if (text.isEmpty) {
      return spans;
    }

    // Regex for [url]...[/url] tags
    final urlTagRegex = RegExp(r'\[url\](.*?)\[/url\]', caseSensitive: false, dotAll: true);
    // Regex for [url=...]...[/url] tags
    final urlWithParamRegex = RegExp(r'\[url=(.*?)\](.*?)\[/url\]', caseSensitive: false, dotAll: true);

    int lastIndex = 0;

    // First, find all URL tags and their positions
    final List<_UrlMatch> urlMatches = [];

    // Find [url=...]...[/url] tags first (they should be processed before [url]...[/url] to avoid conflicts)
    urlWithParamRegex.allMatches(text).forEach((match) {
      urlMatches.add(_UrlMatch(
        start: match.start,
        end: match.end,
        url: match.group(1)?.trim() ?? '',
        linkText: match.group(2)?.trim() ?? match.group(1)?.trim() ?? '',
        hasParam: true,
      ));
    });

    // Find [url]...[/url] tags (only if not already matched by [url=...])
    urlTagRegex.allMatches(text).forEach((match) {
      final start = match.start;
      final end = match.end;
      // Check if this match overlaps with any [url=...] match
      final overlaps = urlMatches.any((m) => (start >= m.start && start < m.end) || (end > m.start && end <= m.end) || (start <= m.start && end >= m.end));
      if (!overlaps) {
        urlMatches.add(_UrlMatch(
          start: start,
          end: end,
          url: match.group(1)?.trim() ?? '',
          linkText: match.group(1)?.trim() ?? '',
          hasParam: false,
        ));
      }
    });

    // Sort matches by position
    urlMatches.sort((a, b) => a.start.compareTo(b.start));

    // Process text, replacing URL tags with clickable links and removing all other BBCode
    for (final urlMatch in urlMatches) {
      // Add text before this URL tag (with all BBCode removed except URL tags)
      if (urlMatch.start > lastIndex) {
        final beforeText = _stripNonUrlBBCode(text.substring(lastIndex, urlMatch.start));
        if (beforeText.isNotEmpty) {
          spans.add(TextSpan(
            text: beforeText,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          ));
        }
      }

      // Add clickable URL span
      final url = urlMatch.url;
      final linkText = urlMatch.linkText.isNotEmpty ? urlMatch.linkText : url;

      spans.add(TextSpan(
        text: linkText,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.primary,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            final uri = Uri.parse(url.startsWith('http://') || url.startsWith('https://') ? url : 'https://$url');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
      ));

      lastIndex = urlMatch.end;
    }

    // Add remaining text after last URL tag
    if (lastIndex < text.length) {
      final remainingText = _stripNonUrlBBCode(text.substring(lastIndex));
      if (remainingText.isNotEmpty) {
        spans.add(TextSpan(
          text: remainingText,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
        ));
      }
    }

    // If no spans were created (no URLs), just return the stripped text
    if (spans.isEmpty) {
      final strippedText = _stripNonUrlBBCode(text);
      if (strippedText.isNotEmpty) {
        spans.add(TextSpan(
          text: strippedText,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
        ));
      }
    }

    return spans;
  }

  /// Strips all BBCode tags except [url] and [url=...] tags
  /// This function is called on text segments between URL tags, so it should
  /// only encounter non-URL BBCode tags
  static String _stripNonUrlBBCode(String text) {
    String result = text;

    // Remove all BBCode tags - use a pattern that matches any [tag] or [/tag]
    // Pattern explanation:
    //   \[       - literal opening bracket
    //   /?       - optional forward slash (for closing tags)
    //   [^\]]+   - one or more characters that are not closing bracket
    //   \]       - literal closing bracket
    // We apply this multiple times to handle nested/adjacent tags
    final bbcodeTagPattern = RegExp(r'\[/?[^\]]+\]', caseSensitive: false);

    // Keep removing tags until no more are found (handles nested tags)
    String previousResult;
    do {
      previousResult = result;
      result = result.replaceAll(bbcodeTagPattern, '');
    } while (result != previousResult);

    return result;
  }
}

/// Internal class to represent a URL match in BBCode
class _UrlMatch {
  final int start;
  final int end;
  final String url;
  final String linkText;
  final bool hasParam;

  _UrlMatch({
    required this.start,
    required this.end,
    required this.url,
    required this.linkText,
    required this.hasParam,
  });
}
