import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:bbob_dart/bbob_dart.dart' as bbob;
import 'package:flutter_bbcode/flutter_bbcode.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/bbcode_processor.dart';
import '../../utils/file_utils.dart';
import '../../utils/accessibility_helpers.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';
import 'video_card.dart';
import 'twitter_card.dart';
import 'cached_redirect_image.dart';
import 'attachment_item_widget.dart';
import 'user_avatar.dart';
import 'broken_image_widget.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

/// Callback configuration for BBCode interactions
class BBCodeCallbacks {
  /// Called when a URL is tapped
  final Function(String url)? onUrlTap;

  /// Called when an image is tapped
  final Function(String imageUrl, BuildContext context, String heroTag)? onImageTap;

  /// Called when a video is tapped
  final Function(String videoUrl)? onVideoTap;

  /// Called when a mention is tapped
  final Function(String username)? onMentionTap;

  /// Called when a user tag is tapped (with optional userId)
  final Function(String username, String? userId)? onUserTap;

  /// Called when an attachment is tapped
  final Function(String url, bool isImage, bool canView)? onAttachmentTap;

  /// List of inline attachments available for lookup by ID
  final List<dynamic>? inlineAttachments;

  /// List of regular attachments available for lookup by ID
  final List<dynamic>? attachments;

  const BBCodeCallbacks({
    this.onUrlTap,
    this.onImageTap,
    this.onVideoTap,
    this.onMentionTap,
    this.onUserTap,
    this.onAttachmentTap,
    this.inlineAttachments,
    this.attachments,
  });
}

class CustomBBStylesheet extends BBStylesheet {
  final BBCodeCallbacks? callbacks;
  final BuildContext? context;

  CustomBBStylesheet._({
    required this.callbacks,
    required this.context,
    required TextStyle defaultText,
    required List<AbstractTag> tags,
    required SiteContext siteContext,
  }) : super(
          defaultText: defaultText,
          tags: tags,
        );

  factory CustomBBStylesheet({
    required SiteContext siteContext,
    BBCodeCallbacks? callbacks,
    BuildContext? context,
    double? fontSize,
  }) {
    final effectiveFontSize = fontSize ?? 15.0;
    final defaultText = context != null
        ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: effectiveFontSize,
                ) ??
            TextStyle(
              fontSize: effectiveFontSize,
              height: DesignTokens.lineHeightTight,
              letterSpacing: DesignTokens.letterSpacingTight,
              color: Theme.of(context).colorScheme.onSurface,
            )
        : TextStyle(
            fontSize: effectiveFontSize,
            height: DesignTokens.lineHeightTight,
            letterSpacing: DesignTokens.letterSpacingTight,
            color: Colors.black,
          );

    return CustomBBStylesheet._(
      siteContext: siteContext,
      callbacks: callbacks,
      context: context,
      defaultText: defaultText,
      tags: [
        CustomBoldTag(),
        CustomHeadingTag(),
        CustomItalicTag(),
        UnderlineTag(),
        StrikeThroughTag(),
        ColorTag(),
        HeaderTag(1, 28),
        HeaderTag(2, 26),
        HeaderTag(2, 24),
        HeaderTag(3, 22),
        HeaderTag(4, 20),
        HeaderTag(5, 18),
        HeaderTag(6, 16),
        LeftAlignTag(),
        CenterAlignTag(),
        RightAlignTag(),
        CustomUrlTag("url", onTap: callbacks?.onUrlTap, onMentionTap: callbacks?.onMentionTap),
        CustomUrlTag("URL", onTap: callbacks?.onUrlTap, onMentionTap: callbacks?.onMentionTap),
        EmailTag("email"),
        EmailTag("EMAIL"),
        ImgTag("img", siteContext: siteContext, onImageTap: callbacks?.onImageTap),
        ImgTag("IMG", siteContext: siteContext, onImageTap: callbacks?.onImageTap),
        ImgTag("image", siteContext: siteContext, onImageTap: callbacks?.onImageTap),
        VideoTag("VIDEO", onTap: callbacks?.onVideoTap),
        VideoTag("video", onTap: callbacks?.onVideoTap),
        CustomQuoteTag("quote", siteContext),
        CustomQuoteTag("QUOTE", siteContext),
        MentionTag("mention", callbacks?.onMentionTap),
        MentionTag("MENTION", callbacks?.onMentionTap),
        UserTag("user", callbacks?.onUserTap, callbacks?.onMentionTap),
        UserTag("USER", callbacks?.onUserTap, callbacks?.onMentionTap),
        EmojiTag(),
        SpoilerTag(),
        HRTag("hr"),
        HRTag("HR"),
        ListTag(
          ListItemStyle("%index%.  ", TextStyle(fontWeight: FontWeight.bold)),
          ListItemStyle("●  ", TextStyle(fontWeight: FontWeight.bold)),
        ),
        CustomListTag(
          ListItemStyle("%index%.  ", TextStyle(fontWeight: FontWeight.bold)),
          ListItemStyle("●  ", TextStyle(fontWeight: FontWeight.bold)),
        ),
        OrderedList(ListItemStyle("%index%.  ", TextStyle(fontWeight: FontWeight.bold))),
        UnorderedList(ListItemStyle("●  ", TextStyle(fontWeight: FontWeight.bold))),
        CustomListItem(),
        AsteriskListItem(),
        InlineAttachmentTag("ATTACH", callbacks?.onAttachmentTap, callbacks?.inlineAttachments, callbacks?.attachments),
        InlineAttachmentTag("attach", callbacks?.onAttachmentTap, callbacks?.inlineAttachments, callbacks?.attachments),
        InlineAttachmentTag("ATTACHMENT", callbacks?.onAttachmentTap, callbacks?.inlineAttachments, callbacks?.attachments),
        InlineAttachmentTag("attachment", callbacks?.onAttachmentTap, callbacks?.inlineAttachments, callbacks?.attachments),
        InlineAttachmentTag("INLINEATTACHMENT", callbacks?.onAttachmentTap, callbacks?.inlineAttachments, callbacks?.attachments),
        InlineAttachmentTag("inlineattachment", callbacks?.onAttachmentTap, callbacks?.inlineAttachments, callbacks?.attachments),
        TwitterTag("twitter"),
        YoutubeTag('youtube', onTap: callbacks?.onVideoTap),
        YoutubeTag('MEDIA', onTap: callbacks?.onVideoTap),
        YoutubeTag('media', onTap: callbacks?.onVideoTap),
        // Table tags - case insensitive support
        TableTag("table"),
        TableTag("TABLE"),
        TableRowTag("tr"),
        TableRowTag("TR"),
        TableCellTag("td"),
        TableCellTag("TD"),
        TableCellTag("th"),
        TableCellTag("TH"),
        TableSectionTag("thead"),
        TableSectionTag("THEAD"),
        TableSectionTag("tbody"),
        TableSectionTag("TBODY"),
      ],
    );
  }
}

class EmailTag extends StyleTag {
  EmailTag(String name) : super(name);

  @override
  void onTagStart(FlutterRenderer renderer) {
    late String email;
    final children = renderer.currentTag?.children;

    // Get email from children (the content inside [email]...[/email])
    if (children != null && children.isNotEmpty) {
      email = children.first.textContent.trim();
    } else {
      email = "Email is missing!";
    }

    renderer.pushTapAction(() {
      // Remove mailto: prefix if present
      String cleanEmail = email;
      if (cleanEmail.toLowerCase().startsWith('mailto:')) {
        cleanEmail = cleanEmail.substring(7);
      }

      // Create mailto URI and launch it
      final mailtoUri = Uri.parse('mailto:$cleanEmail');
      launchUrl(mailtoUri);
    });
    super.onTagStart(renderer);
  }

  @override
  void onTagEnd(FlutterRenderer renderer) {
    renderer.popTapAction();
    super.onTagEnd(renderer);
  }

  @override
  TextStyle transformStyle(TextStyle oldStyle, Map<String, String>? attributes) {
    return oldStyle.copyWith(decoration: TextDecoration.underline);
  }
}

class CustomUrlTag extends StyleTag {
  final Function(String)? onTap;
  final Function(String)? onMentionTap;

  CustomUrlTag(String name, {this.onTap, this.onMentionTap}) : super(name);

  /// Extracts username from text if it matches @username pattern
  /// Returns null if not a mention
  String? _extractMentionUsername(String? text) {
    if (text == null || text.isEmpty) return null;

    final trimmed = text.trim();
    // Check if it starts with @ and has no spaces
    if (trimmed.startsWith('@') && !trimmed.contains(' ')) {
      // Extract username after @ (remove @ and any trailing punctuation that might be part of the link)
      final username = trimmed.substring(1).trim();
      // Username should be non-empty and not contain spaces
      if (username.isNotEmpty && !username.contains(' ')) {
        return username;
      }
    }
    return null;
  }

  @override
  void onTagStart(FlutterRenderer renderer) {
    late String url;
    String? linkText;
    final attributes = renderer.currentTag?.attributes;
    final children = renderer.currentTag?.children;

    // Get URL from attributes (href)
    if (attributes != null && attributes.isNotEmpty && attributes.keys.isNotEmpty) {
      url = attributes.keys.first;
    } else if (children != null && children.isNotEmpty) {
      url = children.first.textContent;
    } else {
      url = "URL is missing!";
    }

    // Get link text from children (the visible text inside [url]...[/url])
    if (children != null && children.isNotEmpty) {
      linkText = children.first.textContent;
    }

    // Debug logging
    AppLogger.debug('CustomUrlTag: URL=$url, linkText=$linkText');

    renderer.pushTapAction(() {
      // Check if link text is a mention (starts with @ and no spaces)
      final mentionUsername = _extractMentionUsername(linkText);

      if (mentionUsername != null && onMentionTap != null) {
        AppLogger.debug('CustomUrlTag: Detected mention @$mentionUsername, calling onMentionTap');
        onMentionTap!(mentionUsername);
      } else if (onTap != null) {
        AppLogger.debug('CustomUrlTag: Not a mention, calling onUrlTap with URL: $url');
        onTap!(url);
      }
    });
    super.onTagStart(renderer);
  }

  @override
  void onTagEnd(FlutterRenderer renderer) {
    renderer.popTapAction();
    super.onTagEnd(renderer);
  }

  @override
  TextStyle transformStyle(TextStyle oldStyle, Map<String, String>? attributes) {
    return oldStyle.copyWith(decoration: TextDecoration.underline);
  }
}

class ImgTag extends AdvancedTag {
  static int _counter = 0;
  final Function(String, BuildContext, String)? onImageTap;
  final SiteContext? siteContext;

  ImgTag(String name, {this.onImageTap, this.siteContext}) : super(name);

  /// Converts a relative URL to an absolute URL using the site's base URL
  String _makeAbsoluteUrl(String url) {
    // If already absolute, return as is
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    // If no site context, return as is (can't convert)
    if (siteContext == null) {
      return url;
    }

    try {
      // Get the base URL from site context
      final baseUrl = siteContext!.site.url;
      if (baseUrl.isEmpty) {
        return url;
      }

      // Parse the base URL to extract origin (scheme + host + port)
      final baseUri = Uri.parse(baseUrl);
      final origin = '${baseUri.scheme}://${baseUri.host}${baseUri.hasPort ? ':${baseUri.port}' : ''}';

      // If relative URL starts with /, it's relative to domain root
      // Otherwise, it's relative to the base URL path
      if (url.startsWith('/')) {
        // URL is relative to domain root
        return '$origin$url';
      } else {
        // URL is relative to base URL path
        final basePath = baseUri.path;
        final cleanBasePath = basePath.endsWith('/') ? basePath : '$basePath/';
        return '$origin$cleanBasePath$url';
      }
    } catch (e) {
      AppLogger.debug('Error converting relative URL to absolute: $e');
      return url;
    }
  }

  @override
  List<InlineSpan> parse(FlutterRenderer renderer, bbob.Element element) {
    String? imageUrl;

    // Helper function to check if a string looks like a URL
    bool looksLikeUrl(String text) {
      final trimmed = text.trim();
      return trimmed.startsWith('http://') ||
          trimmed.startsWith('https://') ||
          trimmed.startsWith('/') || // Relative URLs
          trimmed.startsWith('./') ||
          trimmed.startsWith('../');
    }

    // First check children for the URL (this is where the actual URL is typically located)
    // e.g., [IMG alt="📅"]https://example.com/image.png[/IMG]
    // or [IMG size="1280x720"]/xf2/proxy.php?image=...[/IMG]
    if (element.children.isNotEmpty) {
      final childText = element.children.first.textContent.trim();
      if (childText.isNotEmpty && looksLikeUrl(childText)) {
        imageUrl = childText;
      }
    }

    // If no URL in children, check attributes for URL-like values
    // e.g., [IMG=https://example.com/image.png] or [IMG url="https://example.com/image.png"]
    if (imageUrl == null && element.attributes.isNotEmpty) {
      // Check all attribute values for URL-like strings
      for (var value in element.attributes.values) {
        final valueStr = value.toString().trim();
        if (looksLikeUrl(valueStr)) {
          imageUrl = valueStr;
          break;
        }
      }
    }

    // Final fallback: use first child text content if it exists
    // This handles cases where child text might not have been recognized as URL initially
    if (imageUrl == null && element.children.isNotEmpty) {
      final childText = element.children.first.textContent.trim();
      if (childText.isNotEmpty) {
        imageUrl = childText;
      }
    }

    if (imageUrl == null || imageUrl.isEmpty) {
      return [TextSpan(text: "[$tag]")];
    }

    // Convert relative URLs to absolute URLs
    imageUrl = _makeAbsoluteUrl(imageUrl);

    final heroTag = 'image-${imageUrl.hashCode}-${_counter++}';

    final image = Builder(
      builder: (context) {
        return Hero(
          tag: heroTag,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: StyleBuilders.cardLikeDecoration(
              colorScheme: Theme.of(context).colorScheme,
              borderRadius: DesignTokens.radiusM,
              borderOpacity: 0.2,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              child: Semantics(
                label: AccessibilityHelpers.getImageLabel(context),
                hint: 'Tap to view full size image',
                image: true,
                button: onImageTap != null,
                child: GestureDetector(
                  onTap: () {
                    if (onImageTap != null) {
                      onImageTap!(imageUrl!, context, heroTag);
                    }
                  },
                  child: CachedRedirectImage(
                    imageUrl: imageUrl!,
                    errorWidget: (context, error, stack) {
                      AppLogger.debug('Error loading image: $error');
                      return BrokenImageWidget.forInlineImage(
                        width: 200,
                        height: 150,
                        imageUrl: imageUrl!,
                        iconSize: DesignTokens.iconSizeXL,
                        fontSize: DesignTokens.fontSizeXXS,
                      );
                    },
                    placeholder: (context, url) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingL,
                        vertical: DesignTokens.spacingS,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LinearProgressIndicator(
                            backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                            ),
                            borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
                            minHeight: DesignTokens.spacingXS,
                          ),
                          const SizedBox(height: DesignTokens.spacingS),
                          Text(
                            _getLoadingText(url),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    return [
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: image,
      ),
    ];
  }

  /// Helper method to generate loading text with domain name
  String _getLoadingText(String? url) {
    if (url == null || url.isEmpty) {
      return 'Loading image...';
    }

    try {
      final uri = Uri.parse(url);
      final host = uri.host;
      if (host.isNotEmpty) {
        return 'Loading image from $host';
      }
    } catch (e) {
      // If URL parsing fails, fall back to generic text
    }

    return 'Loading image...';
  }
}

class VideoTag extends AdvancedTag {
  final Function(String)? onTap;

  VideoTag(String name, {this.onTap}) : super(name);

  @override
  List<InlineSpan> parse(FlutterRenderer renderer, bbob.Element element) {
    String? videoUrl;

    if (element.attributes.isNotEmpty && element.attributes.values.isNotEmpty) {
      videoUrl = element.attributes.values.first;
    }

    if (videoUrl == null && element.children.isNotEmpty) {
      videoUrl = element.children.first.textContent;
    }

    if (videoUrl == null || videoUrl.isEmpty) {
      return [TextSpan(text: "[$tag]")];
    }

    final String url = videoUrl; // Create a non-null copy

    // Check if it's a YouTube video
    if (BBCodeProcessor.isYoutubeUrl(url)) {
      return [
        WidgetSpan(
          child: VideoCard(url: url),
        ),
      ];
    }

    // For non-YouTube videos, show a simple text link
    return [
      TextSpan(
        text: url,
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (onTap != null) {
              onTap!(url);
            } else {
              launchUrl(Uri.parse(url));
            }
          },
      ),
    ];
  }
}

class TwitterTag extends AdvancedTag {
  TwitterTag(String name) : super(name);

  @override
  List<InlineSpan> parse(FlutterRenderer renderer, bbob.Element element) {
    String? tweetUrl;

    if (element.attributes.isNotEmpty && element.attributes.values.isNotEmpty) {
      tweetUrl = element.attributes.values.first;
    }

    if (tweetUrl == null && element.children.isNotEmpty) {
      tweetUrl = element.children.first.textContent;
    }

    if (tweetUrl == null || tweetUrl.isEmpty) {
      return [TextSpan(text: "[$tag]")];
    }

    final String url = tweetUrl; // Create a non-null copy

    return [
      WidgetSpan(
        child: TwitterCard(url: url),
      ),
    ];
  }
}

class HRTag extends AdvancedTag {
  HRTag(String name) : super(name);

  @override
  List<InlineSpan> parse(FlutterRenderer renderer, bbob.Element element) {
    return [
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Builder(
          builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;
            return Padding(
              padding: const EdgeInsets.only(
                top: DesignTokens.spacingM,
                bottom: DesignTokens.spacingS,
              ),
              child: StyleBuilders.divider(colorScheme: colorScheme),
            );
          },
        ),
      ),
    ];
  }
}

class MentionTag extends StyleTag {
  final Function(String)? onMentionTap;

  MentionTag(String name, this.onMentionTap) : super(name);

  @override
  void onTagStart(FlutterRenderer renderer) {
    String? username;
    // Try to get username from attributes first
    final attributes = renderer.currentTag?.attributes;
    final children = renderer.currentTag?.children;
    if (attributes != null && attributes.isNotEmpty && attributes.keys.isNotEmpty) {
      username = attributes.keys.first;
    }
    // If not found in attributes, try to get from content
    if ((username?.isEmpty ?? true) && children != null && children.isNotEmpty) {
      username = children.first.textContent;
    }

    // Only create tap action if we have both a valid username and a callback
    final validUsername = username?.trim() ?? '';
    if (validUsername.isNotEmpty && onMentionTap != null) {
      renderer.pushTapAction(() {
        onMentionTap!(validUsername);
      });
    }
    super.onTagStart(renderer);
  }

  @override
  void onTagEnd(FlutterRenderer renderer) {
    renderer.popTapAction();
    super.onTagEnd(renderer);
  }

  @override
  TextStyle transformStyle(TextStyle oldStyle, Map<String, String>? attributes) {
    return oldStyle.copyWith(
      decoration: TextDecoration.underline,
    );
  }
}

class UserTag extends AdvancedTag {
  final Function(String, String?)? onUserTap;
  final Function(String)? onMentionTap;

  UserTag(String name, this.onUserTap, this.onMentionTap) : super(name);

  @override
  List<InlineSpan> parse(FlutterRenderer renderer, bbob.Element element) {
    String? userId;
    String? username;

    // Try to get userId from attributes (e.g., [USER=1]@admin[/USER])
    // For [USER=1], bbob_dart typically parses it as:
    // - attributes[''] = '1' (empty key with numeric value), OR
    // - attributes.values.first = '1' (first value is numeric)
    if (element.attributes.isNotEmpty) {
      // First, check if there's an attribute with empty key (most common case)
      if (element.attributes.containsKey('')) {
        final emptyKeyValue = element.attributes[''];
        if (emptyKeyValue != null && RegExp(r'^\d+$').hasMatch(emptyKeyValue)) {
          userId = emptyKeyValue;
        }
      }

      // If not found, check all attribute values for numeric ones
      if (userId == null) {
        for (var value in element.attributes.values) {
          if (RegExp(r'^\d+$').hasMatch(value)) {
            userId = value;
            break;
          }
        }
      }

      // Also check attribute keys (less common, but possible)
      if (userId == null) {
        for (var key in element.attributes.keys) {
          if (RegExp(r'^\d+$').hasMatch(key)) {
            userId = key;
            break;
          }
        }
      }
    }

    // Try to get username from content (e.g., [USER=1]@admin[/USER] -> "@admin")
    if (element.children.isNotEmpty) {
      username = element.children.first.textContent;
    }

    final validUsername = username?.trim() ?? '';
    if (validUsername.isEmpty) {
      return [TextSpan(text: "[$tag]")];
    }

    // Remove @ prefix if present (we'll add it back for display)
    final displayUsername = validUsername.startsWith('@') ? validUsername : '@$validUsername';

    // For the callback, use username without @
    final usernameForCallback = validUsername.startsWith('@') ? validUsername.substring(1) : validUsername;

    // Clean up userId (remove any non-numeric characters)
    final cleanUserId = userId?.trim();
    final validUserId = (cleanUserId != null && cleanUserId.isNotEmpty && RegExp(r'^\d+$').hasMatch(cleanUserId)) ? cleanUserId : null;

    return [
      TextSpan(
        text: displayUsername,
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (onUserTap != null) {
              onUserTap!(usernameForCallback, validUserId);
            } else if (onMentionTap != null) {
              onMentionTap!(usernameForCallback);
            }
          },
      ),
    ];
  }
}

class CustomQuoteTag extends AdvancedTag {
  CustomQuoteTag(String name, this.siteContext) : super(name);
  final SiteContext siteContext;

  /// Generates avatar URL for a given username
  /// This follows the same pattern used in the liked list implementation
  String? _generateAvatarUrl(String username) {
    try {
      // Use SiteContext to get forum info
      final baseForumInfo = siteContext.site;
      final pluginUrl = baseForumInfo.pluginUrl;

      if (pluginUrl.isNotEmpty) {
        // Use the same pattern as the liked list: replace mobiquo.php with avatar.php
        // Note: This requires user_id, but we only have username
        // For now, we'll return null to use the fallback avatar with username
        // In a future enhancement, we could:
        // 1. Look up user_id from username using a user service
        // 2. Cache username -> user_id mappings
        // 3. Use a different avatar endpoint that accepts username
        return null;
      }
    } catch (e) {
      // If there's any error accessing forum context, fall back to null
      debugPrint('Error generating avatar URL for $username: $e');
    }

    return null;
  }

  /// Extracts username from XenForo quote format: "username, post: X, member: Y"
  /// Returns the username (first part before comma) or null if not found
  String? _extractUsernameFromQuoteAttribute(String? attributeValue) {
    if (attributeValue == null || attributeValue.isEmpty) {
      return null;
    }

    // Remove surrounding quotes if present
    String cleaned = attributeValue.trim();
    if (cleaned.startsWith('"') && cleaned.endsWith('"')) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }

    // Extract username (first part before comma)
    // Format: "username, post: X, member: Y" or just "username"
    final commaIndex = cleaned.indexOf(',');
    if (commaIndex > 0) {
      return cleaned.substring(0, commaIndex).trim();
    }

    // If no comma, return the whole value as username
    return cleaned.isNotEmpty ? cleaned : null;
  }

  /// Cleans up quoted content by removing leading/trailing whitespace and newlines
  List<bbob.Node> _cleanQuotedContent(List<bbob.Node> children) {
    if (children.isEmpty) return children;

    final cleaned = <bbob.Node>[];

    // Find first and last text node indices
    int? firstTextIndex;
    int? lastTextIndex;
    for (int i = 0; i < children.length; i++) {
      if (children[i] is bbob.Text) {
        firstTextIndex ??= i;
        lastTextIndex = i;
      }
    }

    // If no text nodes found, return children as-is
    if (firstTextIndex == null) return children;

    for (int i = 0; i < children.length; i++) {
      final child = children[i];

      if (child is bbob.Text) {
        String text = child.text;

        // For the first text node, remove ALL leading whitespace, newlines, and non-display characters
        // \s includes: space, tab, newline, carriage return, form feed, vertical tab
        // The + quantifier ensures all combinations (whitespace + newlines, multiple newlines, etc.) are removed
        if (i == firstTextIndex) {
          text = text.replaceFirst(RegExp(r'^\s+'), '');
        }

        // For the last text node, remove ALL trailing whitespace, newlines, and non-display characters
        // \s includes: space, tab, newline, carriage return, form feed, vertical tab
        // The + quantifier ensures all combinations (whitespace + newlines, multiple newlines, etc.) are removed
        if (i == lastTextIndex) {
          text = text.replaceFirst(RegExp(r'\s+$'), '');
        }

        // Replace tabs and other non-display characters with spaces (but preserve newlines for paragraph breaks)
        text = text.replaceAll(RegExp(r'[\t\f\v]+'), ' ');

        // Only add non-empty text nodes
        if (text.isNotEmpty) {
          cleaned.add(bbob.Text(text));
        }
      } else {
        // Keep non-text nodes as-is
        cleaned.add(child);
      }
    }

    return cleaned;
  }

  /// Helper method to adjust fontSize in TextSpans to 14.0 for quote content
  InlineSpan _adjustQuoteSpanFontSize(InlineSpan span, double targetFontSize) {
    if (span is TextSpan) {
      final style = span.style;
      final adjustedStyle = (style ?? const TextStyle()).copyWith(fontSize: targetFontSize);
      return TextSpan(
        text: span.text,
        style: adjustedStyle,
        children: span.children?.map((child) => _adjustQuoteSpanFontSize(child, targetFontSize)).toList(),
        recognizer: span.recognizer,
        semanticsLabel: span.semanticsLabel,
        locale: span.locale,
        spellOut: span.spellOut,
      );
    }
    return span;
  }

  List<InlineSpan> parseWithDepth(FlutterRenderer renderer, bbob.Element element, {int depth = 0}) {
    String? authorName;

    // First, check for the 'name' attribute (simplified format)
    if (element.attributes.containsKey('name')) {
      authorName = element.attributes['name'];
    }

    // If not found, check for XenForo format: [QUOTE="username, post: X, member: Y"]
    // bbob_dart may parse this as an attribute with empty key or as the first value
    if (authorName == null || authorName.isEmpty) {
      // Check all attribute values for the quote format
      for (var entry in element.attributes.entries) {
        final extracted = _extractUsernameFromQuoteAttribute(entry.value);
        if (extracted != null && extracted.isNotEmpty) {
          authorName = extracted;
          break;
        }
      }

      // Also check if there's an attribute with empty key (some parsers do this)
      if ((authorName == null || authorName.isEmpty) && element.attributes.containsKey('')) {
        final extracted = _extractUsernameFromQuoteAttribute(element.attributes['']);
        if (extracted != null && extracted.isNotEmpty) {
          authorName = extracted;
        }
      }

      // Check the first attribute value if no key matches (fallback)
      if ((authorName == null || authorName.isEmpty) && element.attributes.isNotEmpty) {
        final firstValue = element.attributes.values.first;
        final extracted = _extractUsernameFromQuoteAttribute(firstValue);
        if (extracted != null && extracted.isNotEmpty) {
          authorName = extracted;
        }
      }
    }

    String quoteHeader = authorName ?? '';

    // Clean up quoted content before rendering
    final cleanedChildren = _cleanQuotedContent(element.children);

    final spans = <InlineSpan>[
      WidgetSpan(
        child: Builder(
          builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;
            final textTheme = Theme.of(context).textTheme;
            final quoteColor = StyleBuilders.getQuoteColor(context, depth);
            return SizedBox(
              width: double.infinity,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: DesignTokens.spacingM),
                elevation: DesignTokens.elevationNone,
                color: quoteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(
                      DesignTokens.opacityLow,
                    ),
                    width: DesignTokens.borderWidthThin,
                  ),
                ),
                child: Padding(
                  padding: DesignTokens.paddingL,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (quoteHeader.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: DesignTokens.spacingS,
                          ),
                          child: Row(
                            children: [
                              UserAvatar(
                                username: quoteHeader,
                                iconUrl: _generateAvatarUrl(quoteHeader),
                                radius: DesignTokens.spacingM,
                              ),
                              const SizedBox(width: DesignTokens.spacingS),
                              Text(
                                quoteHeader,
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurfaceVariant,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      DefaultTextStyle(
                        style: textTheme.bodyMedium?.copyWith(
                              fontSize: 14.0,
                              color: colorScheme.onSurfaceVariant.withOpacity(0.75),
                              letterSpacing: 0.15,
                              height: 1.5,
                            ) ??
                            TextStyle(
                              fontSize: 14.0,
                              color: colorScheme.onSurfaceVariant.withOpacity(0.75),
                            ),
                        child: Builder(
                          builder: (context) {
                            return Text.rich(
                              TextSpan(
                                children: cleanedChildren.map((child) {
                                  if (child is bbob.Element && (child.tag == 'quote' || child.tag == 'QUOTE')) {
                                    // Recursively render nested quotes with increased depth
                                    return parseWithDepth(renderer, child, depth: depth + 1).isNotEmpty ? parseWithDepth(renderer, child, depth: depth + 1).first : const TextSpan();
                                  } else {
                                    // Render other children normally, then adjust fontSize to 14.0 for quotes
                                    final spans = renderer.render([child]);
                                    if (spans.isNotEmpty) {
                                      return _adjustQuoteSpanFontSize(spans.first, 14.0);
                                    }
                                    return const TextSpan();
                                  }
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ];
    return spans;
  }

  @override
  List<InlineSpan> parse(FlutterRenderer renderer, bbob.Element element) {
    return parseWithDepth(renderer, element, depth: 0);
  }
}

class SpoilerTag extends AdvancedTag {
  SpoilerTag() : super("spoiler");

  @override
  List<InlineSpan> parse(FlutterRenderer renderer, bbob.Element element) {
    return [
      WidgetSpan(
        child: Builder(
          builder: (context) {
            return _SpoilerWidget(content: element.textContent);
          },
        ),
      ),
    ];
  }
}

class _SpoilerWidget extends StatefulWidget {
  final String content;

  const _SpoilerWidget({required this.content});

  @override
  State<_SpoilerWidget> createState() => _SpoilerWidgetState();
}

class _SpoilerWidgetState extends State<_SpoilerWidget> {
  bool _isRevealed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        if (!_isRevealed) {
          setState(() {
            _isRevealed = true;
          });
        }
      },
      child: Container(
        padding: DesignTokens.paddingS,
        decoration: BoxDecoration(
          color: _isRevealed ? colorScheme.surfaceContainerHighest : colorScheme.surface,
          borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
          border: Border.all(
            color: _isRevealed ? colorScheme.outline.withOpacity(0.2) : colorScheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: _isRevealed
            ? Text(
                widget.content,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.visibility_off,
                    size: 16,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Spoiler',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(tap to reveal)',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CustomBoldTag extends StyleTag {
  CustomBoldTag() : super("b");

  @override
  void onTagStart(FlutterRenderer renderer) {
    AppLogger.debug('Processing Bold tag:');
    AppLogger.debug('  Content: ${renderer.currentTag?.children.map((e) => e.textContent).join()}');
    super.onTagStart(renderer);
  }

  @override
  TextStyle transformStyle(TextStyle oldStyle, Map<String, String>? attributes) {
    AppLogger.debug('  Applying bold style (FontWeight.w700)');
    return oldStyle.copyWith(
      fontWeight: FontWeight.w700,
    );
  }
}

class CustomHeadingTag extends StyleTag {
  CustomHeadingTag() : super("heading");

  @override
  void onTagStart(FlutterRenderer renderer) {
    AppLogger.debug('Processing Heading tag:');
    AppLogger.debug('  Content: ${renderer.currentTag?.children.map((e) => e.textContent).join()}');
    super.onTagStart(renderer);
  }

  @override
  TextStyle transformStyle(TextStyle oldStyle, Map<String, String>? attributes) {
    AppLogger.debug('  Applying bold style (FontWeight.w700)');
    return oldStyle.copyWith(
      fontWeight: FontWeight.w700,
    );
  }
}

class CustomItalicTag extends StyleTag {
  CustomItalicTag() : super("i");

  @override
  void onTagStart(FlutterRenderer renderer) {
    AppLogger.debug('Processing Italic tag:');
    AppLogger.debug('  Content: ${renderer.currentTag?.children.map((e) => e.textContent).join()}');
    super.onTagStart(renderer);
  }

  @override
  TextStyle transformStyle(TextStyle oldStyle, Map<String, String>? attributes) {
    AppLogger.debug('  Applying italic style');
    return oldStyle.copyWith(
      fontStyle: FontStyle.italic,
    );
  }
}

/// A wrapper tag that adds debug logging to any BBCode tag
class DebugTag extends StyleTag {
  final StyleTag baseTag;

  DebugTag(this.baseTag) : super(baseTag.tag);

  @override
  void onTagStart(FlutterRenderer renderer) {
    AppLogger.debug('\nProcessing [${baseTag.tag.toUpperCase()}] tag:');
    AppLogger.debug('  Content: ${renderer.currentTag?.children.map((e) => e.textContent).join()}');
    if (renderer.currentTag?.attributes.isNotEmpty ?? false) {
      AppLogger.debug('  Attributes: ${renderer.currentTag?.attributes}');
    }
    baseTag.onTagStart(renderer);
  }

  @override
  void onTagEnd(FlutterRenderer renderer) {
    baseTag.onTagEnd(renderer);
    AppLogger.debug('  End [${baseTag.tag.toUpperCase()}]');
  }

  @override
  TextStyle transformStyle(TextStyle oldStyle, Map<String, String>? attributes) {
    final newStyle = baseTag.transformStyle(oldStyle, attributes);
    AppLogger.debug('  Applied style changes:');
    AppLogger.debug('    - Font weight: ${newStyle.fontWeight}');
    AppLogger.debug('    - Font style: ${newStyle.fontStyle}');
    AppLogger.debug('    - Color: ${newStyle.color}');
    AppLogger.debug('    - Decoration: ${newStyle.decoration}');
    return newStyle;
  }
}

class EmojiTag extends AdvancedTag {
  EmojiTag() : super("emoji");

  @override
  List<InlineSpan> parse(FlutterRenderer renderer, bbob.Element element) {
    String? emojiCode;

    if (element.attributes.isNotEmpty && element.attributes.values.isNotEmpty) {
      emojiCode = element.attributes.values.first;
    }

    if (emojiCode == null && element.children.isNotEmpty) {
      emojiCode = element.children.first.textContent;
    }

    if (emojiCode == null || emojiCode.isEmpty) {
      return [TextSpan(text: "[$tag]")];
    }

    // The emoji code is already processed by BBCodeProcessor.processEmoji
    return [TextSpan(text: emojiCode)];
  }
}

class InlineAttachmentTag extends AdvancedTag {
  static int _counter = 0;
  final Function(String url, bool isImage, bool canView)? onAttachmentTap;
  final List<dynamic>? inlineAttachments;
  final List<dynamic>? attachments;

  InlineAttachmentTag(String name, this.onAttachmentTap, this.inlineAttachments, this.attachments) : super(name);

  /// Looks up an attachment by ID from the provided attachment lists
  dynamic _lookupAttachmentById(String attachmentId) {
    AppLogger.debug('InlineAttachmentTag._lookupAttachmentById: Looking for ID: $attachmentId');

    // Try inline attachments first
    if (inlineAttachments != null) {
      AppLogger.debug('InlineAttachmentTag._lookupAttachmentById: Checking ${inlineAttachments!.length} inline attachments');
      for (var att in inlineAttachments!) {
        final attId = att.id?.toString() ?? '';
        final attIdString = att.id.toString();
        AppLogger.debug('InlineAttachmentTag._lookupAttachmentById: Comparing "$attachmentId" with "$attId" / "$attIdString"');
        if (att.id == attachmentId || att.id.toString() == attachmentId || attId == attachmentId) {
          AppLogger.debug('InlineAttachmentTag._lookupAttachmentById: ✓ Found in inline attachments');
          return att;
        }
      }
    }
    // Try regular attachments
    if (attachments != null) {
      AppLogger.debug('InlineAttachmentTag._lookupAttachmentById: Checking ${attachments!.length} regular attachments');
      for (var att in attachments!) {
        final attId = att.id?.toString() ?? '';
        final attIdString = att.id.toString();
        AppLogger.debug('InlineAttachmentTag._lookupAttachmentById: Comparing "$attachmentId" with "$attId" / "$attIdString"');
        if (att.id == attachmentId || att.id.toString() == attachmentId || attId == attachmentId) {
          AppLogger.debug('InlineAttachmentTag._lookupAttachmentById: ✓ Found in regular attachments');
          return att;
        }
      }
    }
    AppLogger.debug('InlineAttachmentTag._lookupAttachmentById: ✗ Attachment not found');
    return null;
  }

  /// Checks if a string is a numeric ID
  bool _isNumericId(String? value) {
    if (value == null || value.isEmpty) return false;
    return RegExp(r'^\d+$').hasMatch(value.trim());
  }

  /// Determines if attachment is an image
  bool _isAttachmentImage(dynamic attachment) {
    if (attachment == null) return false;

    // Check isImage property
    try {
      if (attachment.isImage == true) return true;
    } catch (e) {
      // Property might not exist
    }

    // Check contentType
    try {
      final contentType = attachment.contentType;
      if (contentType != null && contentType.toString().startsWith('image/')) {
        return true;
      }
    } catch (e) {
      // Property might not exist
    }

    // Check filename extension
    try {
      final filename = attachment.filename;
      if (filename != null) {
        return isImageFile(filename.toString());
      }
    } catch (e) {
      // Property might not exist
    }

    return false;
  }

  /// Gets a property value from attachment, handling different property names
  T? _getAttachmentProperty<T>(dynamic attachment, List<String> propertyNames) {
    if (attachment == null) return null;

    for (var propName in propertyNames) {
      try {
        dynamic value;
        // Try different property name variations
        switch (propName) {
          case 'url':
            value = attachment.url;
            break;
          case 'directUrl':
            value = attachment.directUrl ?? attachment.url;
            break;
          case 'thumbnailUrl':
            value = attachment.thumbnailUrl ?? attachment.thumbnail_url;
            break;
          case 'thumbnail_url':
            value = attachment.thumbnail_url ?? attachment.thumbnailUrl;
            break;
          case 'filename':
            value = attachment.filename ?? attachment.fileName;
            break;
          case 'fileName':
            value = attachment.fileName ?? attachment.filename;
            break;
          case 'contentType':
            value = attachment.contentType ?? attachment.mimeType;
            break;
          case 'mimeType':
            value = attachment.mimeType ?? attachment.contentType;
            break;
          case 'fileSize':
            value = attachment.fileSize ?? attachment.file_size ?? attachment.filesize;
            break;
          case 'file_size':
            value = attachment.file_size ?? attachment.fileSize ?? attachment.filesize;
            break;
          case 'filesize':
            value = attachment.filesize ?? attachment.fileSize ?? attachment.file_size;
            break;
          case 'canViewUrl':
            value = attachment.canViewUrl ?? attachment.can_view_url;
            break;
          case 'can_view_url':
            value = attachment.can_view_url ?? attachment.canViewUrl;
            break;
          case 'canViewThumbnailUrl':
            value = attachment.canViewThumbnailUrl ?? attachment.can_view_thumbnail_url;
            break;
          case 'can_view_thumbnail_url':
            value = attachment.can_view_thumbnail_url ?? attachment.canViewThumbnailUrl;
            break;
          default:
            // Try direct property access
            value = (attachment as dynamic)[propName];
        }

        if (value != null) {
          if (T == String && value.toString().isEmpty) continue;
          return value as T;
        }
      } catch (e) {
        // Property doesn't exist or access failed, try next one
        continue;
      }
    }
    return null;
  }

  @override
  List<InlineSpan> parse(FlutterRenderer renderer, bbob.Element element) {
    // Parse attributes from the tag
    final attrs = element.attributes;

    // Check for [ATTACH type="full"] style attribute
    // BBCode [attach=full]123[/attach] or [ATTACH type="full"]123[/ATTACH] might parse as:
    // - attrs['type'] = 'full' (most common for [ATTACH type="full"] format)
    // - attrs[''] = 'full' (unnamed attribute value for [attach=full] format)
    // - attrs.values.first = 'full' (if only one value)
    // - Any value equals 'full'
    bool renderFullImage = false;

    // First check for [ATTACH type="full"] format (most common)
    if (attrs.containsKey('type')) {
      final typeValue = attrs['type']?.toString().toLowerCase().trim();
      if (typeValue == 'full') {
        renderFullImage = true;
      }
    }

    // Check for unnamed attribute (for [attach=full] format)
    if (!renderFullImage && attrs.containsKey('')) {
      final unnamedValue = attrs['']?.toString().toLowerCase().trim();
      if (unnamedValue == 'full') {
        renderFullImage = true;
      }
    }

    // Check if 'full' is a key
    if (!renderFullImage && attrs.containsKey('full')) {
      renderFullImage = true;
    }

    // Check all values for 'full' (fallback)
    if (!renderFullImage && attrs.isNotEmpty) {
      for (var entry in attrs.entries) {
        final key = entry.key.toLowerCase().trim();
        final value = entry.value.toString().toLowerCase().trim();
        if (key == 'full' || value == 'full') {
          renderFullImage = true;
          break;
        }
      }
    }

    String? thumbnailUrl = attrs['thumbnailUrl'];
    String? url = attrs['url'];
    String? filename = attrs['filename'];
    String? contentType = attrs['contentType'];
    String? fileSizeStr = attrs['fileSize'];
    String? id = attrs['id'];
    String? isImageStr = attrs['isImage'];
    String? canViewUrlStr = attrs['canViewUrl'];
    String? canViewThumbnailUrlStr = attrs['canViewThumbnailUrl'];
    bool isImage = isImageStr == 'true';
    // Default to true if not specified (most attachments are viewable)
    bool canViewUrl = canViewUrlStr == null ? true : (canViewUrlStr == 'true');
    bool canViewThumbnailUrl = canViewThumbnailUrlStr == 'true';
    int? fileSize = int.tryParse(fileSizeStr ?? '');

    // Get tag content (could be URL or numeric ID)
    String? tagContent;
    if (element.children.isNotEmpty) {
      tagContent = element.children.first.textContent.trim();
    }

    // Check if tag content is a numeric ID (like [attach]123[/attach])
    String? attachmentId;
    dynamic foundAttachment;

    AppLogger.debug('InlineAttachmentTag: ========== TAG CONTENT PARSING ==========');
    AppLogger.debug('InlineAttachmentTag: tagContent: $tagContent');
    AppLogger.debug('InlineAttachmentTag: tag: $tag');

    if (tagContent != null && _isNumericId(tagContent)) {
      attachmentId = tagContent;
      AppLogger.debug('InlineAttachmentTag: Detected numeric ID: $attachmentId');
      AppLogger.debug('InlineAttachmentTag: Looking up attachment in inlineAttachments: ${inlineAttachments?.length ?? 0} items');
      AppLogger.debug('InlineAttachmentTag: Looking up attachment in attachments: ${attachments?.length ?? 0} items');

      foundAttachment = _lookupAttachmentById(attachmentId);

      AppLogger.debug('InlineAttachmentTag: Found attachment: ${foundAttachment != null}');

      if (foundAttachment != null) {
        // Extract properties from found attachment
        id = foundAttachment.id?.toString() ?? id;
        // Try to get directUrl first (for direct image access), then fall back to url (which might be a PHP page)
        final extractedDirectUrl = _getAttachmentProperty<String>(foundAttachment, ['directUrl', 'link']);
        final extractedUrl = extractedDirectUrl ?? _getAttachmentProperty<String>(foundAttachment, ['url']);
        final extractedThumbnailUrl = _getAttachmentProperty<String>(foundAttachment, ['thumbnailUrl', 'thumbnail_url']);
        final extractedFilename = _getAttachmentProperty<String>(foundAttachment, ['filename', 'fileName']);
        final extractedContentType = _getAttachmentProperty<String>(foundAttachment, ['contentType', 'mimeType', 'content_type']);
        final extractedFileSize = _getAttachmentProperty<int>(foundAttachment, ['fileSize', 'file_size', 'filesize']);
        final extractedIsImage = _isAttachmentImage(foundAttachment);
        final extractedCanViewUrl = _getAttachmentProperty<bool>(foundAttachment, ['canViewUrl', 'can_view_url']);
        final extractedCanViewThumbnailUrl = _getAttachmentProperty<bool>(foundAttachment, ['canViewThumbnailUrl', 'can_view_thumbnail_url']);

        AppLogger.debug('InlineAttachmentTag: Extracted properties:');
        AppLogger.debug('InlineAttachmentTag:   - extractedUrl: $extractedUrl');
        AppLogger.debug('InlineAttachmentTag:   - extractedThumbnailUrl: $extractedThumbnailUrl');
        AppLogger.debug('InlineAttachmentTag:   - extractedFilename: $extractedFilename');
        AppLogger.debug('InlineAttachmentTag:   - extractedIsImage: $extractedIsImage');

        url = extractedUrl ?? url;
        thumbnailUrl = extractedThumbnailUrl ?? thumbnailUrl;
        filename = extractedFilename ?? filename;
        contentType = extractedContentType ?? contentType;
        fileSize = extractedFileSize ?? fileSize;
        isImage = extractedIsImage;
        if (extractedCanViewUrl != null) {
          canViewUrl = extractedCanViewUrl;
        }
        if (extractedCanViewThumbnailUrl != null) {
          canViewThumbnailUrl = extractedCanViewThumbnailUrl;
        }
      } else {
        AppLogger.debug('InlineAttachmentTag: ⚠ Attachment not found for ID: $attachmentId');
      }
    } else if (tagContent != null && (url == null || url.isEmpty)) {
      // Fallback: if url is not present, use tag content as URL
      AppLogger.debug('InlineAttachmentTag: Using tagContent as URL fallback: $tagContent');
      url = tagContent;
    }

    AppLogger.debug('InlineAttachmentTag: Final URL check: url=$url, thumbnailUrl=$thumbnailUrl');

    // If still no URL, try to use thumbnail URL as fallback
    if ((url == null || url.isEmpty) && (thumbnailUrl != null && thumbnailUrl.isNotEmpty)) {
      AppLogger.debug('InlineAttachmentTag: No full URL, but using thumbnail URL: $thumbnailUrl');
      url = thumbnailUrl;
    }

    // If still no URL at all, return fallback
    if (url == null || url.isEmpty) {
      AppLogger.debug('InlineAttachmentTag: ⚠ No URL or thumbnail URL found, returning fallback text');
      return [TextSpan(text: "[$tag]")];
    }

    final finalFilename = filename ?? '';
    final finalIsImage = isImage || (contentType != null && contentType.startsWith('image/')) || isImageFile(finalFilename);

    // Create a mock attachment object with the parsed attributes
    final attachment = MockAttachment(
      id: id ?? attachmentId ?? '',
      filename: finalFilename,
      contentType: contentType ?? '',
      fileSize: fileSize ?? 0,
      url: url,
      thumbnailUrl: thumbnailUrl,
      isImage: finalIsImage,
      canViewUrl: canViewUrl,
      canViewThumbnailUrl: canViewThumbnailUrl,
    );

    return [
      // Add newline before inline attachment to preserve line breaks in the original text
      const TextSpan(text: '\n'),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Builder(
          builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;

            // If it's an image, render as image (thumbnail or full based on renderFullImage)
            // Check if we have either a URL with permission, or a thumbnail URL
            final urlNonNull = url ?? '';
            final hasViewableImage = finalIsImage && ((urlNonNull.isNotEmpty && canViewUrl) || (thumbnailUrl?.isNotEmpty == true));

            if (hasViewableImage) {
              // For full images, use the full URL only if user has permission.
              // If user doesn't have permission for full URL, fall back to thumbnail (if available)
              String imageUrlToUse;
              bool useFullImageFit = false;

              if (renderFullImage && canViewUrl && urlNonNull.isNotEmpty) {
                // User requested full image and has permission - use full URL
                imageUrlToUse = urlNonNull;
                useFullImageFit = true;
              } else if (renderFullImage && !canViewUrl && thumbnailUrl?.isNotEmpty == true) {
                // User requested full image but doesn't have permission - fall back to thumbnail
                imageUrlToUse = thumbnailUrl!;
                useFullImageFit = false;
              } else if (renderFullImage && urlNonNull.isEmpty) {
                // User requested full image but URL is empty - fall back to thumbnail
                imageUrlToUse = thumbnailUrl ?? '';
                useFullImageFit = false;
              } else {
                // Default: use thumbnail if available, otherwise use full URL (if we have permission)
                if (thumbnailUrl?.isNotEmpty == true) {
                  imageUrlToUse = thumbnailUrl!;
                } else if (urlNonNull.isNotEmpty && canViewUrl) {
                  imageUrlToUse = urlNonNull;
                } else {
                  // Should not reach here due to hasViewableImage check, but handle gracefully
                  imageUrlToUse = urlNonNull.isNotEmpty ? urlNonNull : (thumbnailUrl ?? '');
                }
                useFullImageFit = false;
              }

              final heroTag = 'attachment-${urlNonNull.hashCode}-${_counter++}';

              // Render inline attachment images exactly like regular [img] tags - simple image with no filename card
              // Add lock icon overlay if it's a thumbnail and user doesn't have permission to view full version
              final showLockIcon = !useFullImageFit && !canViewUrl;

              return Hero(
                tag: heroTag,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: StyleBuilders.cardLikeDecoration(
                    colorScheme: colorScheme,
                    borderRadius: DesignTokens.radiusM,
                    borderOpacity: 0.2,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (canViewUrl && onAttachmentTap != null) {
                              onAttachmentTap!(urlNonNull, true, canViewUrl);
                            } else if (!canViewUrl && onAttachmentTap != null) {
                              // Show permission prompt
                              onAttachmentTap!(urlNonNull, true, false);
                            }
                          },
                          child: CachedRedirectImage(
                            imageUrl: imageUrlToUse,
                            errorWidget: (context, error, stack) {
                              AppLogger.debug('Error loading attachment image: $error, URL: $imageUrlToUse');
                              return BrokenImageWidget.forInlineImage(
                                width: 200,
                                height: 150,
                                imageUrl: imageUrlToUse,
                                iconSize: DesignTokens.iconSizeXL,
                                fontSize: DesignTokens.fontSizeXXS,
                              );
                            },
                            placeholder: (context, url) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: DesignTokens.spacingL,
                                vertical: DesignTokens.spacingS,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  LinearProgressIndicator(
                                    backgroundColor: colorScheme.surfaceVariant.withOpacity(0.3),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colorScheme.onSurfaceVariant.withOpacity(0.6),
                                    ),
                                    borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
                                    minHeight: DesignTokens.spacingXS,
                                  ),
                                  const SizedBox(height: DesignTokens.spacingS),
                                  Text(
                                    'Loading image...',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            // For full images (with permission), use contain to show full image at full width (like [img] tags)
                            // For thumbnails or when permission denied, use cover to fill the space nicely
                            fit: useFullImageFit ? BoxFit.contain : BoxFit.cover,
                          ),
                        ),
                        // Lock icon overlay for thumbnails when user doesn't have permission to view full version
                        if (showLockIcon)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                if (onAttachmentTap != null) {
                                  // Show permission prompt
                                  onAttachmentTap!(urlNonNull, true, false);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  // Use a semi-transparent dark background that works in both light and dark themes
                                  color: colorScheme.surface.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: colorScheme.outline.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.lock_outline,
                                  size: 14,
                                  color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              // For non-images or images without view permission, show attachment card
              final textTheme = Theme.of(context).textTheme;
              return Container(
                padding: DesignTokens.paddingM,
                decoration: StyleBuilders.surfaceContainerDecoration(
                  colorScheme: colorScheme,
                  borderRadius: DesignTokens.radiusM,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.attach_file,
                          size: 18,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Inline Attachments',
                          style: textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AttachmentItemWidget(
                      attachment: attachment,
                      isInline: true,
                      showDownloadIcon: true,
                      onTap: () {
                        if (onAttachmentTap != null) {
                          onAttachmentTap!(url ?? '', finalIsImage, canViewUrl);
                        }
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    ];
  }
}

class YoutubeTag extends AdvancedTag {
  final Function(String)? onTap;

  YoutubeTag(String name, {this.onTap}) : super(name);

  @override
  List<InlineSpan> parse(FlutterRenderer renderer, bbob.Element element) {
    String? videoUrl;

    // Check children first (this is where the actual video ID/URL usually is)
    // e.g., [MEDIA=youtube]VIDEO_ID[/MEDIA] or [youtube]VIDEO_ID[/youtube]
    if (element.children.isNotEmpty) {
      videoUrl = element.children.first.textContent.trim();
    }

    // If no children or children is empty, check attributes as fallback
    // e.g., [youtube=https://youtube.com/watch?v=VIDEO_ID]
    if ((videoUrl == null || videoUrl.isEmpty) && element.attributes.isNotEmpty && element.attributes.values.isNotEmpty) {
      final attrValue = element.attributes.values.first.trim();
      // Skip attribute values that look like type indicators (e.g., "youtube" from [MEDIA=youtube])
      // Only use attribute if it looks like a URL or video ID (not just a word)
      if (attrValue != 'youtube' && attrValue != 'YOUTUBE' && (attrValue.contains('/') || attrValue.length >= 11)) {
        videoUrl = attrValue;
      }
    }

    if (videoUrl == null || videoUrl.isEmpty) {
      return [TextSpan(text: "[$tag]")];
    }

    final String url = videoUrl; // Create a non-null copy

    return [
      WidgetSpan(
        child: VideoCard(url: url),
      ),
    ];
  }
}

/// Represents BBCode [list] tag.
/// Handles both [list] (unordered) and [list=1] (ordered) formats.
/// Requires both styles for ordered and unordered lists.
class ListTag extends AbstractListTag {
  ListItemStyle orderedStyle;
  ListItemStyle unorderedStyle;

  ListTag(this.orderedStyle, this.unorderedStyle) : super("list");

  @override
  void onTagStart(FlutterRenderer renderer) {
    super.onTagStart(renderer);

    // Get the type. [list=1] means ordered list
    var type = ListType.unordered;
    if (renderer.currentTag!.attributes.isNotEmpty && renderer.currentTag!.attributes.values.isNotEmpty) {
      if (renderer.currentTag!.attributes.values.first == "1") {
        type = ListType.ordered;
      }
    }

    // Insert render data to be used by child nodes.
    renderer.startRenderData(ListRenderData(
      listType: type,
      orderedListStyle: orderedStyle,
      unorderedListStyle: unorderedStyle,
    ));
  }
}

/// Represents BBCode list (legacy/custom format).
/// Requires both styles for ordered and unordered lists.
class CustomListTag extends AbstractListTag {
  ListItemStyle orderedStyle;
  ListItemStyle unorderedStyle;

  CustomListTag(this.orderedStyle, this.unorderedStyle) : super("li");

  @override
  void onTagStart(FlutterRenderer renderer) {
    super.onTagStart(renderer);

    // Get the type. [list=1]
    var type = ListType.unordered;
    if (renderer.currentTag!.attributes.isNotEmpty && renderer.currentTag!.attributes.values.isNotEmpty) {
      if (renderer.currentTag!.attributes.values.first == "1") {
        type = ListType.ordered;
      }
    }

    // Insert render data to be used by child nodes.
    renderer.startRenderData(ListRenderData(
      listType: type,
      orderedListStyle: orderedStyle,
      unorderedListStyle: unorderedStyle,
    ));
  }
}

/// Represents the [*] tag used in list to define an item.
/// Handles both [*] (parsed as tag "*") and [li] (parsed as tag "li") formats.
class CustomListItem extends AbstractTag {
  CustomListItem() : super(tag: "li");

  @override
  void onTagStart(FlutterRenderer renderer) {
    ListRenderData data = renderer.getRenderData() as ListRenderData;

    // Get the correct style based on the List type.
    // The other style might not be present.
    var style = data.listType == ListType.ordered ? data.orderedListStyle : data.unorderedListStyle;

    // Increment before rendering, since non-programmers won't really get lists
    // that start with 0.
    data.index++;

    // Append the prefix
    renderer.appendTextSpan(TextSpan(text: style!.prefix.replaceAll("%index%", data.index.toString()), style: style.prefixStyle));
  }
}

/// Represents the [*] BBCode tag (asterisk) used for list items.
/// This is needed because BBCode parsers typically parse [*] as tag "*", not "li".
class AsteriskListItem extends AbstractTag {
  AsteriskListItem() : super(tag: "*");

  @override
  void onTagStart(FlutterRenderer renderer) {
    ListRenderData? data;
    try {
      data = renderer.getRenderData() as ListRenderData?;
    } catch (e) {
      // If no list context, do nothing (item outside of list)
      return;
    }

    if (data == null) {
      // No list context available, skip prefix
      return;
    }

    // Get the correct style based on the List type.
    var style = data.listType == ListType.ordered ? data.orderedListStyle : data.unorderedListStyle;

    // Increment before rendering, since non-programmers won't really get lists
    // that start with 0.
    data.index++;

    // Append the prefix (bullet or number)
    renderer.appendTextSpan(TextSpan(text: style!.prefix.replaceAll("%index%", data.index.toString()), style: style.prefixStyle));
  }
}

/// Represents a parsed table cell with its content and properties
class _TableCellData {
  final List<bbob.Node> children;
  final bool isHeader;

  _TableCellData({required this.children, this.isHeader = false});
}

/// Represents a parsed table row with its cells
class _TableRowData {
  final List<_TableCellData> cells;

  _TableRowData({required this.cells});
}

/// Represents BBCode [table] tag.
/// Parses the table structure and renders it as a Flutter Table widget.
/// Supports [tr] for rows, [td] for data cells, and [th] for header cells.
class TableTag extends AdvancedTag {
  TableTag(String name) : super(name);

  /// Parses table rows from the element's children
  List<_TableRowData> _parseTableRows(bbob.Element element) {
    final rows = <_TableRowData>[];

    for (var child in element.children) {
      if (child is bbob.Element) {
        final tagName = child.tag.toLowerCase();
        if (tagName == 'tr') {
          final cells = _parseRowCells(child);
          if (cells.isNotEmpty) {
            rows.add(_TableRowData(cells: cells));
          }
        } else if (tagName == 'thead' || tagName == 'tbody') {
          // Handle thead/tbody by parsing their tr children
          for (var innerChild in child.children) {
            if (innerChild is bbob.Element && innerChild.tag.toLowerCase() == 'tr') {
              final cells = _parseRowCells(innerChild);
              if (cells.isNotEmpty) {
                // Mark cells in thead as headers
                final isInThead = tagName == 'thead';
                final headerCells = cells
                    .map((cell) => _TableCellData(
                          children: cell.children,
                          isHeader: isInThead || cell.isHeader,
                        ))
                    .toList();
                rows.add(_TableRowData(cells: headerCells));
              }
            }
          }
        }
      }
    }

    return rows;
  }

  /// Parses cells from a table row element
  List<_TableCellData> _parseRowCells(bbob.Element rowElement) {
    final cells = <_TableCellData>[];

    for (var child in rowElement.children) {
      if (child is bbob.Element) {
        final tagName = child.tag.toLowerCase();
        if (tagName == 'td' || tagName == 'th') {
          cells.add(_TableCellData(
            children: child.children,
            isHeader: tagName == 'th',
          ));
        }
      }
    }

    return cells;
  }

  @override
  List<InlineSpan> parse(FlutterRenderer renderer, bbob.Element element) {
    final rows = _parseTableRows(element);

    if (rows.isEmpty) {
      return [const TextSpan(text: '[table]')];
    }

    // Calculate the maximum number of columns
    int maxColumns = 0;
    for (var row in rows) {
      if (row.cells.length > maxColumns) {
        maxColumns = row.cells.length;
      }
    }

    if (maxColumns == 0) {
      return [const TextSpan(text: '[table]')];
    }

    return [
      WidgetSpan(
        child: Builder(
          builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;
            final textTheme = Theme.of(context).textTheme;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: DesignTokens.spacingM),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        color: colorScheme.outlineVariant.withOpacity(0.5),
                        width: 1.0,
                      ),
                      verticalInside: BorderSide(
                        color: colorScheme.outlineVariant.withOpacity(0.5),
                        width: 1.0,
                      ),
                    ),
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    children: rows.asMap().entries.map((entry) {
                      final rowIndex = entry.key;
                      final row = entry.value;
                      final isFirstRow = rowIndex == 0;
                      // Check if this row contains any header cells
                      final hasHeaderCells = row.cells.any((cell) => cell.isHeader);
                      final isHeaderRow = isFirstRow || hasHeaderCells;

                      return TableRow(
                        decoration: isHeaderRow
                            ? BoxDecoration(
                                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                              )
                            : null,
                        children: List.generate(maxColumns, (colIndex) {
                          if (colIndex < row.cells.length) {
                            final cell = row.cells[colIndex];
                            final isHeader = cell.isHeader || isHeaderRow;

                            return Container(
                              padding: const EdgeInsets.all(DesignTokens.spacingS),
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                maxWidth: 300,
                              ),
                              child: Text.rich(
                                TextSpan(
                                  children: cell.children.map((child) {
                                    final spans = renderer.render([child]);
                                    if (spans.isNotEmpty) {
                                      return spans.first;
                                    }
                                    return const TextSpan();
                                  }).toList(),
                                ),
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            );
                          } else {
                            // Empty cell for padding
                            return Container(
                              padding: const EdgeInsets.all(DesignTokens.spacingS),
                              constraints: const BoxConstraints(minWidth: 40),
                            );
                          }
                        }),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ];
  }
}

/// Placeholder tags for [tr], [td], [th], [thead], [tbody] that are handled by TableTag
/// These tags should not render anything on their own - they're parsed by the parent TableTag
class TableRowTag extends AdvancedTag {
  TableRowTag(String name) : super(name);

  @override
  List<InlineSpan> parse(FlutterRenderer renderer, bbob.Element element) {
    // If a [tr] tag is encountered outside of a [table], render its content inline
    final spans = <InlineSpan>[];
    for (var child in element.children) {
      spans.addAll(renderer.render([child]));
    }
    return spans.isNotEmpty ? spans : [const TextSpan(text: '')];
  }
}

class TableCellTag extends AdvancedTag {
  TableCellTag(String name) : super(name);

  @override
  List<InlineSpan> parse(FlutterRenderer renderer, bbob.Element element) {
    // If a [td] or [th] tag is encountered outside of a [table], render its content inline
    final spans = <InlineSpan>[];
    for (var child in element.children) {
      spans.addAll(renderer.render([child]));
    }
    return spans.isNotEmpty ? spans : [const TextSpan(text: '')];
  }
}

class TableSectionTag extends AdvancedTag {
  TableSectionTag(String name) : super(name);

  @override
  List<InlineSpan> parse(FlutterRenderer renderer, bbob.Element element) {
    // If a [thead] or [tbody] tag is encountered outside of a [table], render its content inline
    final spans = <InlineSpan>[];
    for (var child in element.children) {
      spans.addAll(renderer.render([child]));
    }
    return spans.isNotEmpty ? spans : [const TextSpan(text: '')];
  }
}
