import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_attachment.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:html_unescape/html_unescape.dart';
import 'package:forumcopilot_flutter/utils/attachment_utils.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class InlineAttachmentReplacementResult {
  final String text;
  final List<FCAttachment> remainingInlineAttachments;
  InlineAttachmentReplacementResult(this.text, this.remainingInlineAttachments);
}

/// Result class for URL analysis
class ForumUrlAnalysisResult {
  final bool isSameForum;
  final String? topicId;
  final String? postId;
  final String? forumId;

  ForumUrlAnalysisResult({
    required this.isSameForum,
    this.topicId,
    this.postId,
    this.forumId,
  });
}

class BBCodeProcessor {
  // Video-related regular expressions
  static final _videoHostRegex = RegExp(
    r'(?:youtube\.com|youtu\.be|vimeo\.com|tiktok\.com|dailymotion\.com)',
    caseSensitive: false,
  );

  static final _youtubeRegex = RegExp(
    r'^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:watch\?v=|embed\/)|youtu\.be\/)([a-zA-Z0-9_-]{11})(?:\S+)?$',
    caseSensitive: false,
  );

  static final _twitterRegex = RegExp(
    r'^(?:https?:\/\/)?(?:www\.)?(?:twitter\.com|x\.com)\/([a-zA-Z0-9_]+)\/status\/(\d+)(?:\S+)?$',
    caseSensitive: false,
  );

  static final _videoExtRegex = RegExp(
    r'\.(mp4|webm|ogg|mov|avi|wmv|flv|mkv)$',
    caseSensitive: false,
  );

  // Emoji mapping
  static final Map<String, String> _emojiMap = {
    '640': '👉',
    '641': '👈',
    '642': '👍',
    '643': '👎',
    '644': '❤️',
    '645': '😂',
    '646': '😊',
    '647': '😢',
    '648': '😡',
    '649': '😮',
    '650': '😴',
    '651': '😎',
    '652': '😈',
    '653': '👻',
    '654': '💩',
    '655': '💪',
    '656': '👏',
    '657': '🙏',
    '658': '🎉',
    '659': '🎂',
    '660': '🎁',
    '661': '🎮',
    '662': '🎵',
    '663': '🎬',
    '664': '📱',
    '665': '📷',
    '666': '📚',
    '667': '✏️',
    '668': '🔍',
    '669': '🔒',
    '670': '🔓',
    '671': '🔔',
    '672': '🔑',
    '673': '💡',
    '674': '💣',
    '675': '💊',
    '676': '💉',
    '677': '💰',
    '678': '💎',
    '679': '💍',
    '680': '💋',
    '681': '💌',
    '682': '💘',
    '683': '💝',
    '684': '💞',
    '685': '💟',
    '686': '💠',
    '687': '💢',
    '688': '💣',
    '689': '💤',
    '690': '💥',
    '691': '💦',
    '692': '💨',
    '693': '💫',
    '694': '💬',
    '695': '💭',
    '696': '💮',
    '697': '💯',
    '698': '💱',
    '699': '💲',
    '700': '💳',
  };

  /// Checks if a URL is a YouTube video link
  static bool isYoutubeUrl(String url) {
    return _youtubeRegex.hasMatch(url);
  }

  /// Checks if a URL is a Twitter/X post link
  static bool isTwitterUrl(String url) {
    return _twitterRegex.hasMatch(url);
  }

  /// Extracts the video ID from a YouTube URL
  static String? extractYoutubeVideoId(String url) {
    final match = _youtubeRegex.firstMatch(url);
    return match?.group(1);
  }

  /// Extracts the tweet ID from a Twitter URL
  static String? extractTweetId(String url) {
    final match = _twitterRegex.firstMatch(url);
    return match?.group(2);
  }

  /// Checks if a URL is a video link
  static bool isVideoUrl(String url) {
    return _videoHostRegex.hasMatch(url) || _videoExtRegex.hasMatch(url);
  }

  static String htmlToBBCode(String text) {
    // Use html_unescape to handle HTML entities
    final unescape = HtmlUnescape();
    text = unescape.convert(text);

    // Parse HTML
    final document = htmlparser.parse(text);

    // Convert to BBCode (this would require implementing a DOM traversal)
    String bbcode = _convertNodeToBBCode(document.body);

    return bbcode;
  }

  static String _convertNodeToBBCode(dom.Node? node) {
    if (node == null) return '';

    if (node is dom.Text) {
      // Remove newlines from text nodes since HTML uses <br> for line breaks
      // This prevents double line breaks when <br> tags are converted to newlines
      return node.text.replaceAll(RegExp(r'[\r\n]+'), ' ');
    }

    if (node is dom.Element) {
      String content = '';
      for (var child in node.nodes) {
        content += _convertNodeToBBCode(child);
      }

      switch (node.localName) {
        case 'b':
          return '[b]$content[/b]';
        case 'i':
          return '[i]$content[/i]';
        case 'u':
          return '[u]$content[/u]';
        case 'a':
          final href = node.attributes['href'] ?? '';
          return '[url=$href]$content[/url]';
        case 'img':
          final src = node.attributes['src'] ?? '';
          return '[img]$src[/img]';
        case 'br':
          return '\n';
        default:
          return content;
      }
    }

    return '';
  }

  /// Normalizes BBCode tags to lowercase while preserving all other content exactly
  static String normalizeBBCode(String text) {
    // Match only the tag part of BBCode, preserving attributes exactly
    // Include common formatting tags: B, I, U, S, COLOR, SIZE, FONT, TABLE, TR, TD, TH, etc.
    final bbCodeTagRegex = RegExp(
      r'\[(/?)(?:QUOTE|URL|IMG|VIDEO|EMOJI|B|I|U|S|COLOR|SIZE|FONT|CENTER|LEFT|RIGHT|LIST|LI|\*|CODE|SPOILER|HR|MENTION|USER|ATTACH|ATTACHMENT|INLINEATTACHMENT|YOUTUBE|MEDIA|TWITTER|EMAIL|HEADING|TABLE|TR|TD|TH|THEAD|TBODY)(?=[\]=\s\]])',
      caseSensitive: false,
    );

    return text.replaceAllMapped(bbCodeTagRegex, (match) {
      final slash = match.group(1) ?? ''; // "/" or empty
      final tag = match.group(0)!.substring(slash.length + 1); // Get just the tag name
      return '[$slash${tag.toLowerCase()}'; // Convert only the tag name to lowercase
    });
  }

  /// Processes emoji codes in the text
  static String processEmoji(String text) {
    final emojiRegex = RegExp(r'\[emoji(\d+)\]', caseSensitive: false);
    return text.replaceAllMapped(emojiRegex, (match) {
      final emojiCode = match.group(1)!;
      return _emojiMap[emojiCode] ?? '[emoji$emojiCode]';
    });
  }

  /// Finds all URLs in the text that are not already wrapped in BBCode tags.
  /// Returns a list of Match objects for further processing.
  static List<Match> findPlainUrls(String text) {
    // First normalize BBCode tags to lowercase
    final normalizedText = normalizeBBCode(text);

    // Then identify all BBCode-wrapped URLs to exclude them
    final bbCodeRegex = RegExp(
      r'\[(?:url|img|video)(?:=[^\]]+)?\].*?\[/(?:url|img|video)\]',
      caseSensitive: false,
    );

    // Replace all BBCode sections with placeholders to prevent matching within them
    String processedText = normalizedText;
    final bbCodeMatches = bbCodeRegex.allMatches(normalizedText).toList();

    for (var i = 0; i < bbCodeMatches.length; i++) {
      processedText = processedText.replaceRange(bbCodeMatches[i].start, bbCodeMatches[i].end, ' ' * (bbCodeMatches[i].end - bbCodeMatches[i].start));
    }

    // Now match URLs in the remaining text
    final urlRegex = RegExp(
      r'https?:\/\/[^\s\[\]<>"]+',
      caseSensitive: false,
    );

    final matches = urlRegex.allMatches(processedText);
    final plainUrls = <Match>[];

    for (var match in matches) {
      plainUrls.add(match);
    }

    return plainUrls;
  }

  /// Removes all [color=...] and [/color] tags from the text.
  static String stripColorTags(String text) {
    // Remove [color=...] tags
    text = text.replaceAll(RegExp(r'\[color=[^\]]*\]', caseSensitive: false), '');
    // Remove [/color] tags
    text = text.replaceAll(RegExp(r'\[/color\]', caseSensitive: false), '');
    return text;
  }

  /// Removes all [size=...] and [/size] tags from the text.
  static String stripSizeTags(String text) {
    // Remove [size=...] tags
    text = text.replaceAll(RegExp(r'\[size=[^\]]*\]', caseSensitive: false), '');
    // Remove [/size] tags
    text = text.replaceAll(RegExp(r'\[/size\]', caseSensitive: false), '');
    return text;
  }

  /// Removes all [font=...] and [/font] tags from the text.
  static String stripFontTags(String text) {
    // Remove [font=...] tags
    text = text.replaceAll(RegExp(r'\[font=[^\]]*\]', caseSensitive: false), '');
    // Remove [/font] tags
    text = text.replaceAll(RegExp(r'\[/font\]', caseSensitive: false), '');
    return text;
  }

  /// Removes all [embed] and [/embed] tags from the text, preserving content.
  static String stripEmbedTags(String text) {
    // Remove [embed] or [embed=...] tags
    text = text.replaceAll(RegExp(r'\[embed(?:=[^\]]*)?\]', caseSensitive: false), '');
    // Remove [/embed] tags
    text = text.replaceAll(RegExp(r'\[/embed\]', caseSensitive: false), '');
    return text;
  }

  /// Processes text to wrap URLs in appropriate BBCode tags.
  /// [siteContext] - Optional site context. If provided and the site is XenForo, HTML processing will be skipped.
  static String processText(String text, {SiteContext? siteContext}) {
    // First, strip unsupported formatting tags
    text = stripColorTags(text);
    text = stripSizeTags(text);
    text = stripFontTags(text);
    text = stripEmbedTags(text);

    // Check if this is a XenForo forum - if so, skip HTML processing to preserve newlines
    final isXenForo = siteContext != null &&
        (siteContext.siteType == 'xenforo' ||
            (siteContext.configDataOutput != null &&
                siteContext.configDataOutput!.version
                    .toLowerCase()
                    .startsWith('xf')));

    // Only process HTML if not XenForo
    String bbcodeText;
    if (isXenForo) {
      // For XenForo, skip HTML processing and preserve newlines
      bbcodeText = text;
    } else {
      // For other forums, process HTML as before
      bbcodeText = htmlToBBCode(text);
    }

    // First normalize all existing BBCode tags
    String processedText = normalizeBBCode(bbcodeText);

    // Process emoji codes
    processedText = processEmoji(processedText);

    // Process URLs in [url] tags first
    final urlTagRegex = RegExp(r'\[url\](.*?)\[/url\]', caseSensitive: false);
    processedText = processedText.replaceAllMapped(urlTagRegex, (match) {
      final url = match.group(1)?.trim() ?? '';
      if (isYoutubeUrl(url)) {
        return '[youtube]$url[/youtube]';
      } else if (isTwitterUrl(url)) {
        return '[twitter]$url[/twitter]';
      } else if (isVideoUrl(url)) {
        return '[video]$url[/video]';
      }
      return match.group(0)!;
    });

    // Then process any plain URLs
    final plainUrls = findPlainUrls(processedText);
    if (plainUrls.isEmpty) {
      return processedText;
    }

    // Process URLs from end to start to avoid position issues
    for (var match in plainUrls.reversed) {
      final url = processedText.substring(match.start, match.end);
      final isVideo = isVideoUrl(url);
      final isTwitter = isTwitterUrl(url);
      final isYoutube = isYoutubeUrl(url);

      String wrappedUrl;
      if (isYoutube) {
        wrappedUrl = '[youtube]$url[/youtube]';
      } else if (isTwitter) {
        wrappedUrl = '[twitter]$url[/twitter]';
      } else if (isVideo) {
        wrappedUrl = '[video]$url[/video]';
      } else {
        wrappedUrl = '[url]$url[/url]';
      }

      processedText = processedText.replaceRange(match.start, match.end, wrappedUrl);
    }

    return processedText;
  }

  /// Replaces [url]...[/url] tags with [inlineattachment ...]...[/inlineattachment] if the URL matches any in the provided inlineAttachments list.
  ///
  /// [text]: The BBCode text to process.
  /// [inlineAttachments]: List of Attachment objects.
  /// Returns the modified text.
  static InlineAttachmentReplacementResult replaceInlineAttachmentUrlsAndFilter(String text, List<FCAttachment> inlineAttachments) {
    if (inlineAttachments.isEmpty) {
      return InlineAttachmentReplacementResult(text, []);
    }

    final Map<String, dynamic> urlToAttachment = {
      for (var att in inlineAttachments)
        if (att.url.isNotEmpty) att.url: att
    };

    final Set<String> replacedUrls = {};

    final urlTagRegex = RegExp(r'\[url\](.*?)\[/url\]', caseSensitive: false);
    final imgTagRegex = RegExp(r'\[img\](.*?)\[/img\]', caseSensitive: false);
    // Check [url]...[/url] tags
    String newText = text.replaceAllMapped(urlTagRegex, (match) {
      final url = match.group(1)?.trim();
      final att = url != null ? urlToAttachment[url] : null;
      if (att != null) {
        replacedUrls.add(url!);
        return AttachmentUtils.createInlineAttachmentTag(att);
      }
      return match.group(0)!;
    });

    // Also check [img]...[/img] tags
    newText = newText.replaceAllMapped(imgTagRegex, (match) {
      final url = match.group(1)?.trim();
      final att = url != null ? urlToAttachment[url] : null;
      if (att != null) {
        replacedUrls.add(url!);
        // If canViewUrl is false, replace with inline attachment tag
        // Handle both Attachment (can_view_url) and FCAttachment (canViewUrl) property names
        bool canViewUrl = true;
        try {
          // Try FCAttachment property name first (camelCase)
          canViewUrl = att.canViewUrl;
        } catch (e) {
          // Fall back to Attachment property name (snake_case)
          try {
            canViewUrl = att.can_view_url;
          } catch (e2) {
            // If both fail, default to true
            canViewUrl = true;
          }
        }

        if (canViewUrl != true) {
          return AttachmentUtils.createInlineAttachmentTag(att);
        }
        // If canViewUrl is true, just mark as used but keep the original [img] tag
      }
      return match.group(0)!;
    });

    // Filter out replaced attachments using utility function
    AppLogger.debug('Replaced URLs:');
    for (var url in replacedUrls) {
      AppLogger.debug('  - $url');
    }
    AppLogger.debug('All inlineAttachments URLs:');
    for (var att in inlineAttachments) {
      AppLogger.debug('  - ${att.url}');
    }
    final remaining = AttachmentUtils.filterUsedAttachments(inlineAttachments, replacedUrls);
    AppLogger.debug('Remaining inlineAttachments after filtering:');
    for (var att in remaining) {
      AppLogger.debug('  - ${att.url}');
    }

    return InlineAttachmentReplacementResult(newText, remaining);
  }

  /// Checks for basic BBCode structural validity (e.g., no nested [url=[url] patterns).
  bool isBBCodeStructurallyValid(String text) {
    // Detect nested [url=[url] or similar patterns
    final nestedUrlPattern = RegExp(r'\[url=[^\]]*\[url\]', caseSensitive: false);
    if (nestedUrlPattern.hasMatch(text)) {
      return false;
    }

    // Check for proper tag matching and nesting for all tags
    final tagPattern = RegExp(r'\[(/?)([a-zA-Z]+)(?:[^\]]*)?\]', caseSensitive: false);
    List<String> stack = [];
    int index = 0;

    while (index < text.length) {
      final match = tagPattern.matchAsPrefix(text, index);
      if (match != null) {
        final isClosing = match.group(1) == '/';
        final tagName = match.group(2)!.toLowerCase();

        if (isClosing) {
          if (stack.isEmpty || stack.last != tagName) {
            return false; // Mismatched closing tag
          }
          stack.removeLast();
        } else {
          stack.add(tagName);
        }
        index = match.end;
      } else {
        index++;
      }
    }

    // Check if all tags are closed
    return stack.isEmpty;
  }

  /// Attempts to remove mismatched BBCode tags from the text.
  /// This function identifies unpaired opening or closing tags and removes them,
  /// preserving the content between tags where possible.
  String removeMismatchedBBCode(String text) {
    final tagPattern = RegExp(r'\[(/?)([a-zA-Z]+)(?:[^\]]*)?\]', caseSensitive: false);
    List<Map<String, dynamic>> tagStack = [];
    List<int> removalRanges = [];
    int index = 0;

    // Parse the text to find all BBCode tags and track their positions
    while (index < text.length) {
      final match = tagPattern.matchAsPrefix(text, index);
      if (match != null) {
        final isClosing = match.group(1) == '/';
        final tagName = match.group(2)!.toLowerCase();
        final tagStart = match.start;
        final tagEnd = match.end;

        if (isClosing) {
          // Look for a matching opening tag in the stack
          bool matched = false;
          for (int i = tagStack.length - 1; i >= 0; i--) {
            if (tagStack[i]['name'] == tagName) {
              tagStack.removeAt(i);
              matched = true;
              break;
            }
          }
          if (!matched) {
            // No matching opening tag found, mark this closing tag for removal
            removalRanges.add(tagStart);
            removalRanges.add(tagEnd);
          }
        } else {
          // Add opening tag to stack with its position
          tagStack.add({'name': tagName, 'start': tagStart, 'end': tagEnd});
        }
        index = tagEnd;
      } else {
        index++;
      }
    }

    // Any remaining tags in the stack are unmatched opening tags, mark them for removal
    for (var unmatched in tagStack) {
      removalRanges.add(unmatched['start']);
      removalRanges.add(unmatched['end']);
    }

    // Sort removal ranges in descending order to avoid index shifting issues
    removalRanges.sort((a, b) => b.compareTo(a));

    // Build the cleaned text by removing marked ranges
    String cleanedText = text;
    for (int i = 0; i < removalRanges.length; i += 2) {
      final end = removalRanges[i];
      final start = removalRanges[i + 1];
      cleanedText = cleanedText.replaceRange(start, end, '');
    }

    return cleanedText;
  }

  /// Normalizes XenForo quote format to simplified format
  /// [QUOTE="username, post: X, member: Y"] -> [quote name="username"]
  static String normalizeQuoteTags(String text) {
    // Pattern to match: [QUOTE="username, post: X, member: Y"] or [QUOTE="username, post: X"] or [QUOTE="username"]
    // Captures the username (first part before comma, trimming whitespace)
    // The pattern matches: [QUOTE="..."] where ... can contain the full attribute value
    final quotePattern = RegExp(
      r'\[(/?)(?:QUOTE|quote)="([^"]+)"\]',
      caseSensitive: false,
    );

    // Also try pattern without quotes around the value
    final quotePatternNoQuotes = RegExp(
      r'\[(/?)(?:QUOTE|quote)=([^\]]+)\]',
      caseSensitive: false,
    );

    final matches = quotePattern.allMatches(text);
    final matchesNoQuotes = quotePatternNoQuotes.allMatches(text);

    // Process matches with quotes first
    String result = text;
    if (matches.isNotEmpty) {
      result = text.replaceAllMapped(quotePattern, (match) {
        final slash = match.group(1) ?? '';
        final fullValue = match.group(2)?.trim() ?? '';

        if (slash == '/') {
          // Closing tag
          return '[/quote]';
        } else {
          // Opening tag - extract username from the value
          // Format: "username, post: X, member: Y" or just "username"
          String username = fullValue;
          final commaIndex = fullValue.indexOf(',');
          if (commaIndex > 0) {
            username = fullValue.substring(0, commaIndex).trim();
          }

          // Convert to simplified format
          String result;
          if (username.isNotEmpty) {
            result = '[quote name="$username"]';
          } else {
            result = '[quote]';
          }
          return result;
        }
      });
    }

    // If no matches with quotes, try pattern without quotes
    if (matches.isEmpty && matchesNoQuotes.isNotEmpty) {
      final quotePatternNoQuotes2 = RegExp(
        r'\[(/?)(?:QUOTE|quote)=([^\]]+)\]',
        caseSensitive: false,
      );
      result = result.replaceAllMapped(quotePatternNoQuotes2, (match) {
        final slash = match.group(1) ?? '';
        final fullValue = match.group(2)?.trim() ?? '';

        if (slash == '/') {
          return '[/quote]';
        } else {
          String username = fullValue;
          final commaIndex = fullValue.indexOf(',');
          if (commaIndex > 0) {
            username = fullValue.substring(0, commaIndex).trim();
          }

          String result;
          if (username.isNotEmpty) {
            result = '[quote name="$username"]';
          } else {
            result = '[quote]';
          }
          return result;
        }
      });
    }

    return result;
  }

  /// Fixes malformed BBCode tags that could cause parser errors.
  /// Specifically handles empty attributes and malformed URL tags.
  static String fixMalformedBBCodeTags(String text) {
    String fixed = text;

    // First normalize quote tags from XenForo format
    fixed = normalizeQuoteTags(fixed);

    // First, remove orphaned closing tags (closing tags without matching opening tags)
    // This helps prevent "Inconsistent tag" errors
    final tagPattern = RegExp(r'\[(/?)([a-zA-Z]+)(?:[^\]]*)?\]', caseSensitive: false);
    List<String> openTags = [];
    List<int> orphanedClosingTagIndices = [];

    // First pass: identify orphaned closing tags
    int index = 0;
    while (index < fixed.length) {
      final match = tagPattern.matchAsPrefix(fixed, index);
      if (match != null) {
        final isClosing = match.group(1) == '/';
        final tagName = match.group(2)!.toLowerCase();

        if (isClosing) {
          // Look for matching opening tag
          bool foundMatch = false;
          for (int i = openTags.length - 1; i >= 0; i--) {
            if (openTags[i] == tagName) {
              // Found matching opening tag, remove it from stack
              openTags.removeAt(i);
              foundMatch = true;
              break;
            }
          }
          if (!foundMatch) {
            // Orphaned closing tag - mark for removal
            orphanedClosingTagIndices.add(match.start);
            orphanedClosingTagIndices.add(match.end);
          }
        } else {
          // Opening tag - add to stack
          openTags.add(tagName);
        }
        index = match.end;
      } else {
        index++;
      }
    }

    // Remove orphaned closing tags (in reverse order to maintain indices)
    orphanedClosingTagIndices.sort((a, b) => b.compareTo(a));
    for (int i = 0; i < orphanedClosingTagIndices.length; i += 2) {
      final end = orphanedClosingTagIndices[i];
      final start = orphanedClosingTagIndices[i + 1];
      fixed = fixed.replaceRange(start, end, '');
    }

    // Fix empty URL tags: [url=][/url] -> remove the tag completely
    fixed = fixed.replaceAll(RegExp(r'\[url=\s*\]\s*\[/url\]', caseSensitive: false), '');

    // Fix URL tags with only fragments or anchors: [url=#-][/url] or [url=#][/url] -> remove
    fixed = fixed.replaceAll(RegExp(r'\[url=#-?\s*\]\s*\[/url\]', caseSensitive: false), '');

    // Fix URL tags with empty attribute value but with content: [url=]content[/url] -> [url]content[/url]
    fixed = fixed.replaceAll(RegExp(r'\[url=\s*\](.*?)\[/url\]', caseSensitive: false), r'[url]$1[/url]');

    // Fix URL tags with empty content: [url=...][/url] where content is empty or just whitespace
    fixed = fixed.replaceAllMapped(RegExp(r'\[url=([^\]]+)\]\s*\[/url\]', caseSensitive: false), (match) {
      final url = match.group(1)?.trim() ?? '';
      // If URL is empty or just a fragment/anchor, remove the tag
      if (url.isEmpty || url == '#' || url.startsWith('#-')) {
        return '';
      }
      // If URL is valid, keep it but add the URL as content
      return '[url=$url]$url[/url]';
    });

    // Fix URL tags with malformed URLs (containing commas or other invalid characters)
    // Pattern: [url=http://Clearly, ...] -> extract valid URL part
    fixed = fixed.replaceAllMapped(RegExp(r'\[url=([^\]]+)\](.*?)\[/url\]', caseSensitive: false), (match) {
      final urlAttr = match.group(1)?.trim() ?? '';
      final content = match.group(2)?.trim() ?? '';

      // If URL attribute is empty or invalid, try to use content as URL
      if (urlAttr.isEmpty || urlAttr == '#' || urlAttr.startsWith('#-')) {
        if (content.isNotEmpty && (content.startsWith('http://') || content.startsWith('https://'))) {
          // Extract valid URL from content (stop at first space, comma, or bracket)
          final urlMatch = RegExp(r'^https?://[^\s,\]]+').firstMatch(content);
          if (urlMatch != null) {
            return '[url=${urlMatch.group(0)}]${content}[/url]';
          }
        }
        // If we can't fix it, remove the tag but keep the content
        return content;
      }

      // Check if URL starts with http:// or https:// but has invalid characters (like comma)
      if (urlAttr.startsWith('http://') || urlAttr.startsWith('https://')) {
        // Extract valid URL part (stop at comma, space, or other invalid chars)
        final validUrlMatch = RegExp(r'^https?://[^\s,\]]+').firstMatch(urlAttr);
        if (validUrlMatch != null) {
          final validUrl = validUrlMatch.group(0)!;
          // If the URL was truncated, use the valid part
          if (validUrl != urlAttr) {
            return '[url=$validUrl]${content.isNotEmpty ? content : validUrl}[/url]';
          }
        }
      }

      return match.group(0)!;
    });

    // Fix any remaining tags with empty attributes that could cause parser errors
    // Pattern: [tag=] -> remove the = part to make it [tag]
    fixed = fixed.replaceAll(RegExp(r'\[([a-zA-Z]+)=\s*\]', caseSensitive: false), r'[$1]');

    // Fix tags with empty attribute values followed by content: [tag=]content -> [tag]content
    // This handles cases where = is present but value is empty
    fixed = fixed.replaceAllMapped(RegExp(r'\[([a-zA-Z]+)=\s*\]([^\[]*)', caseSensitive: false), (match) {
      final tagName = match.group(1)!;
      final content = match.group(2) ?? '';
      return '[$tagName]$content';
    });

    return fixed;
  }

  /// Validates BBCode text and attempts to clean it if mismatched tags are found.
  /// Returns the valid text to render, either the original or cleaned version.
  String getValidBBCodeText(String text) {
    // First fix malformed tags that could cause parser errors
    String preprocessed = fixMalformedBBCodeTags(text);

    if (!isBBCodeStructurallyValid(preprocessed)) {
      final cleanedText = removeMismatchedBBCode(preprocessed);
      if (isBBCodeStructurallyValid(cleanedText)) {
        return cleanedText;
      } else {
        return preprocessed;
      }
    }
    return preprocessed;
  }

  /// Checks if a string is an email address
  static bool isEmail(String input) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+ ? ?$');
    return emailRegex.hasMatch(input);
  }

  /// Processes URLs in BBCode text and identifies same-forum URLs with their IDs
  ///
  /// [text] - The BBCode text to process
  /// Returns a list of ForumUrlAnalysisResult for all URLs found in [url] tags
  static List<ForumUrlAnalysisResult> analyzeUrlsInBBCode(SiteContext siteContext, String text) {
    final List<ForumUrlAnalysisResult> results = [];

    // Find all [url] tags with URLs
    final urlTagRegex = RegExp(r'\[url\](.*?)\[/url\]', caseSensitive: false);
    final urlWithParamRegex = RegExp(r'\[url=(.*?)\](.*?)\[/url\]', caseSensitive: false);

    // Process [url]...[/url] tags
    final urlMatches = urlTagRegex.allMatches(text);
    for (final match in urlMatches) {
      final url = match.group(1)?.trim();
      if (url != null && url.isNotEmpty) {
        final analysis = analyzeForumUrl(siteContext, url);
        results.add(analysis);
      }
    }

    // Process [url=...]...[/url] tags
    final urlWithParamMatches = urlWithParamRegex.allMatches(text);
    for (final match in urlWithParamMatches) {
      final url = match.group(1)?.trim();
      if (url != null && url.isNotEmpty) {
        final analysis = analyzeForumUrl(siteContext, url);
        results.add(analysis);
      }
    }

    return results;
  }

  /// Analyzes a URL to check if it belongs to the same forum and extracts topic_id or post_id
  ///
  /// [url] - The URL to analyze
  /// Returns a ForumUrlAnalysisResult with the analysis results
  static ForumUrlAnalysisResult analyzeForumUrl(SiteContext siteContext, String url) {
    try {
      // Get current forum information
      final currentForumUrl = siteContext.site.pluginUrl;
      final forumType = siteContext.ConfigData.version;

      if (currentForumUrl.isEmpty) {
        return ForumUrlAnalysisResult(isSameForum: false);
      }

      // Get the real forum URL by removing mobiquo directory from plugin URL
      String baseCurrentUrl = siteContext.site.url;

      // Check if the URL belongs to the same domain
      final Uri currentUri = Uri.parse(baseCurrentUrl);
      final Uri targetUri = Uri.parse(url);

      if (currentUri.host != targetUri.host) {
        return ForumUrlAnalysisResult(isSameForum: false);
      }

      // Check if URL starts with the same base path
      if (!url.toLowerCase().startsWith(baseCurrentUrl.toLowerCase())) {
        return ForumUrlAnalysisResult(isSameForum: false);
      }

      // Parse URL based on forum type to extract IDs
      return _parseUrlByForumType(url, forumType);
    } catch (e) {
      AppLogger.debug('Error analyzing forum URL: $e');
      return ForumUrlAnalysisResult(isSameForum: false);
    }
  }

  /// Parses URL based on forum type to extract topic_id and post_id
  static ForumUrlAnalysisResult _parseUrlByForumType(String url, dynamic forumType) {
    final String forumTypeStr = forumType.toString().toLowerCase();

    try {
      final Uri uri = Uri.parse(url);
      final String path = uri.path;
      final Map<String, String> queryParams = uri.queryParameters;

      // Try forum-specific patterns first
      final forumResult = _parseForumSpecificPatterns(path, queryParams, uri, forumTypeStr);
      if (forumResult != null) return forumResult;

      // Try legacy forum URL patterns (works for any forum type)
      final legacyResult = _parseLegacyForumPatterns(path, queryParams, uri);
      if (legacyResult != null) return legacyResult;

      // If we reach here, it's the same forum but couldn't parse specific IDs
      return ForumUrlAnalysisResult(isSameForum: true);
    } catch (e) {
      AppLogger.debug('Error parsing URL by forum type: $e');
      return ForumUrlAnalysisResult(isSameForum: true);
    }
  }

  /// Parses forum-specific URL patterns
  static ForumUrlAnalysisResult? _parseForumSpecificPatterns(String path, Map<String, String> queryParams, Uri uri, String forumTypeStr) {
    final patterns = _getForumPatterns();

    for (final pattern in patterns) {
      if (pattern.forumTypes.any((type) => forumTypeStr.contains(type))) {
        final result = pattern.parse(path, queryParams, uri);
        if (result != null) return result;
      }
    }

    return null;
  }

  /// Parses legacy forum URL patterns
  static ForumUrlAnalysisResult? _parseLegacyForumPatterns(String path, Map<String, String> queryParams, Uri uri) {
    // Query parameter patterns
    if (queryParams.containsKey('p') && uri.fragment.startsWith('p')) {
      final postId = queryParams['p'];
      final fragmentPostId = uri.fragment.substring(1);
      if (postId == fragmentPostId) {
        return ForumUrlAnalysisResult(isSameForum: true, postId: postId);
      }
    }

    if (queryParams.containsKey('t') && uri.fragment.startsWith('p')) {
      final topicId = queryParams['t'];
      final postId = uri.fragment.substring(1);
      return ForumUrlAnalysisResult(isSameForum: true, topicId: topicId, postId: postId);
    }

    // Fragment patterns
    if (uri.fragment.startsWith('f') && RegExp(r'^f(\d+)$').hasMatch(uri.fragment)) {
      final forumMatch = RegExp(r'^f(\d+)$').firstMatch(uri.fragment);
      return ForumUrlAnalysisResult(isSameForum: true, forumId: forumMatch?.group(1));
    }

    // Path patterns
    final pathPatterns = [
      _PathPattern(r'/forum/(\d+)(?:/|$)', (match) => ForumUrlAnalysisResult(isSameForum: true, forumId: match.group(1))),
      _PathPattern(r'/groups/[^/]+/[^/]+-f(\d+)/?$', (match) => ForumUrlAnalysisResult(isSameForum: true, forumId: match.group(1))),
      _PathPattern(r'-f(\d+)(?:\.html)?$', (match) => ForumUrlAnalysisResult(isSameForum: true, forumId: match.group(1))),
      _PathPattern(r'/groups/[^/]+/[^/]+-p(\d+)/?$', (match) => ForumUrlAnalysisResult(isSameForum: true, postId: match.group(1))),
      _PathPattern(r'-p(\d+)(?:\.html)?$', (match) => ForumUrlAnalysisResult(isSameForum: true, postId: match.group(1))),
      _PathPattern(r'-t(\d+)p(\d+)\.html$', (match) => ForumUrlAnalysisResult(isSameForum: true, topicId: match.group(1), postId: match.group(2))),
      _PathPattern(r'/groups/[^/]+/[^/]+-t(\d+)p(\d+)/?$', (match) => ForumUrlAnalysisResult(isSameForum: true, topicId: match.group(1), postId: match.group(2))),
      _PathPattern(r'/groups/[^/]+/[^/]+-t(\d+)/?$', (match) => ForumUrlAnalysisResult(isSameForum: true, topicId: match.group(1))),
      _PathPattern(r'-t(\d+)\.html$', (match) => ForumUrlAnalysisResult(isSameForum: true, topicId: match.group(1))),
    ];

    for (final pattern in pathPatterns) {
      final match = pattern.regex.firstMatch(path);
      if (match != null) {
        return pattern.resultBuilder(match);
      }
    }

    return null;
  }

  /// Gets all forum-specific patterns
  static List<_ForumPattern> _getForumPatterns() {
    return [
      // Discuz patterns
      _ForumPattern(
        forumTypes: ['dz'],
        patterns: [
          _QueryPattern(
            pathContains: 'forum.php',
            requiredParams: {'mod': 'viewthread'},
            resultBuilder: (params) => ForumUrlAnalysisResult(
              isSameForum: true,
              topicId: params['tid'],
              postId: params['pid'],
            ),
          ),
          _QueryPattern(
            pathContains: 'forum.php',
            requiredParams: {'goto': 'findpost'},
            resultBuilder: (params) => ForumUrlAnalysisResult(
              isSameForum: true,
              topicId: params['ptid'],
              postId: params['pid'],
            ),
          ),
        ],
      ),

      // vBulletin patterns
      _ForumPattern(
        forumTypes: ['vb'],
        patterns: [
          _QueryPattern(
            pathContains: 'showthread.php',
            resultBuilder: (params) => ForumUrlAnalysisResult(
              isSameForum: true,
              topicId: params['t'],
              postId: params['p'],
            ),
          ),
          _QueryPattern(
            pathContains: 'showpost.php',
            resultBuilder: (params) => ForumUrlAnalysisResult(
              isSameForum: true,
              postId: params['p'],
            ),
          ),
        ],
      ),

      // XenForo patterns
      _ForumPattern(
        forumTypes: ['xf'],
        patterns: [
          _PathPattern(r'/threads/(?:[\w-]+\.)?(\d+)/?', (match) => ForumUrlAnalysisResult(isSameForum: true, topicId: match.group(1))),
          _PathPattern(r'/posts/(\d+)/?', (match) => ForumUrlAnalysisResult(isSameForum: true, postId: match.group(1))),
        ],
      ),

      // Invision Power Board patterns
      _ForumPattern(
        forumTypes: ['ip'],
        patterns: [
          _PathPattern(r'/topic/(\d+)-', (match) => ForumUrlAnalysisResult(isSameForum: true, topicId: match.group(1))),
        ],
      ),

      // phpBB patterns
      _ForumPattern(
        forumTypes: ['pb', 'bb'],
        patterns: [
          _QueryPattern(
            pathContains: 'viewtopic.php',
            resultBuilder: (params) => ForumUrlAnalysisResult(
              isSameForum: true,
              topicId: params['t'],
              postId: params['p'],
            ),
          ),
        ],
      ),

      // SMF patterns
      _ForumPattern(
        forumTypes: ['smf', 'sm'],
        patterns: [
          _CustomPattern((path, params, uri) {
            if (path.contains('index.php') && params.containsKey('topic')) {
              final topicParam = params['topic']!;
              final topicMatch = RegExp(r'^(\d+)(?:\.msg(\d+))?').firstMatch(topicParam);
              if (topicMatch != null) {
                return ForumUrlAnalysisResult(
                  isSameForum: true,
                  topicId: topicMatch.group(1),
                  postId: topicMatch.group(2),
                );
              }
            }
            return null;
          }),
        ],
      ),

      // MyBB patterns
      _ForumPattern(
        forumTypes: ['mb'],
        patterns: [
          _QueryPattern(
            pathContains: 'showthread.php',
            resultBuilder: (params) => ForumUrlAnalysisResult(
              isSameForum: true,
              topicId: params['tid'],
              postId: params['pid'],
            ),
          ),
        ],
      ),

      // Kunena patterns
      _ForumPattern(
        forumTypes: ['kunena', 'kn'],
        patterns: [
          _QueryPattern(
            requiredParams: {'option': 'com_kunena', 'func': 'view'},
            resultBuilder: (params) => ForumUrlAnalysisResult(
              isSameForum: true,
              topicId: params['id'],
              forumId: params['catid'],
            ),
          ),
          _QueryPattern(
            requiredParams: {'view': 'topic'},
            resultBuilder: (params) => ForumUrlAnalysisResult(
              isSameForum: true,
              topicId: params['id'],
              forumId: params['catid'],
            ),
          ),
        ],
      ),

      // ProBoards patterns
      _ForumPattern(
        forumTypes: ['proboards'],
        patterns: [
          _PathPattern(r'/thread/(\d+)/?', (match) => ForumUrlAnalysisResult(isSameForum: true, topicId: match.group(1))),
          _PathPattern(r'/post/(\d+)/thread/(\d+)', (match) => ForumUrlAnalysisResult(isSameForum: true, postId: match.group(1), topicId: match.group(2))),
        ],
      ),

      // Vanilla patterns
      _ForumPattern(
        forumTypes: ['vanilla', 'vn'],
        patterns: [
          _PathPattern(r'/discussion/(\d+)/?', (match) => ForumUrlAnalysisResult(isSameForum: true, topicId: match.group(1))),
        ],
      ),

      // WBB patterns
      _ForumPattern(
        forumTypes: ['wbb', 'wb'],
        patterns: [
          _QueryPattern(
            requiredParams: {'page': 'Thread'},
            resultBuilder: (params) => ForumUrlAnalysisResult(
              isSameForum: true,
              topicId: params['threadID'],
              postId: params['postID'],
            ),
          ),
        ],
      ),
    ];
  }
}

/// Helper class for forum-specific patterns
class _ForumPattern {
  final List<String> forumTypes;
  final List<_Pattern> patterns;

  _ForumPattern({required this.forumTypes, required this.patterns});

  ForumUrlAnalysisResult? parse(String path, Map<String, String> queryParams, Uri uri) {
    for (final pattern in patterns) {
      final result = pattern.match(path, queryParams, uri);
      if (result != null) return result;
    }
    return null;
  }
}

/// Base class for URL patterns
abstract class _Pattern {
  ForumUrlAnalysisResult? match(String path, Map<String, String> queryParams, Uri uri);
}

/// Pattern for query parameter matching
class _QueryPattern extends _Pattern {
  final String? pathContains;
  final Map<String, String> requiredParams;
  final ForumUrlAnalysisResult Function(Map<String, String> params) resultBuilder;

  _QueryPattern({
    this.pathContains,
    this.requiredParams = const {},
    required this.resultBuilder,
  });

  @override
  ForumUrlAnalysisResult? match(String path, Map<String, String> queryParams, Uri uri) {
    if (pathContains != null && !path.contains(pathContains!)) return null;

    for (final entry in requiredParams.entries) {
      if (queryParams[entry.key] != entry.value) return null;
    }

    return resultBuilder(queryParams);
  }
}

/// Pattern for path regex matching
class _PathPattern extends _Pattern {
  final RegExp regex;
  final ForumUrlAnalysisResult Function(Match match) resultBuilder;

  _PathPattern(String pattern, this.resultBuilder) : regex = RegExp(pattern);

  @override
  ForumUrlAnalysisResult? match(String path, Map<String, String> queryParams, Uri uri) {
    final match = regex.firstMatch(path);
    return match != null ? resultBuilder(match) : null;
  }
}

/// Pattern for custom matching logic
class _CustomPattern extends _Pattern {
  final ForumUrlAnalysisResult? Function(String path, Map<String, String> queryParams, Uri uri) matcher;

  _CustomPattern(this.matcher);

  @override
  ForumUrlAnalysisResult? match(String path, Map<String, String> queryParams, Uri uri) {
    return matcher(path, queryParams, uri);
  }
}
