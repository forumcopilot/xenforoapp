import 'package:flutter/material.dart';
import 'package:flutter_bbcode/flutter_bbcode.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'custom_bb_stylesheet.dart';

class RichTextContent extends StatelessWidget {
  final SiteContext siteContext;
  final String content;
  final BBCodeCallbacks? callbacks;

  const RichTextContent({
    super.key,
    required this.siteContext,
    required this.content,
    this.callbacks,
  });

  String _preprocessContent(String text) {
    // Replace HTML line breaks with newlines
    String processed = text.replaceAll(RegExp(r'<br\s*\/?>', multiLine: true), '\n');

    // Handle other HTML entities if needed
    processed = processed.replaceAll('&nbsp;', ' ').replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&amp;', '&').replaceAll('&quot;', '"').replaceAll('&apos;', "'");

    // Remove any excessive newlines (more than 2 consecutive)
    processed = processed.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return processed;
  }

  @override
  Widget build(BuildContext context) {
    final processedContent = _preprocessContent(content);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    try {
      return BBCodeText(
        data: processedContent,
        stylesheet: CustomBBStylesheet(
          siteContext: siteContext,
          callbacks: callbacks,
          context: context,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('BBCode parsing error: \n$error\nStackTrace: $stackTrace');
      debugPrint('Original content that caused error:\n$content');
      // If BBCode parsing fails, display as plain text instead of rich text
      return Text(
        processedContent,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          height: 1.2,
        ),
      );
    }
  }
}
