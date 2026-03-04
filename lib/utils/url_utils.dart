import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart'; // Added for BuildContext

/// Forum template types enum
enum ForumTemplate {
  dz,
  vb,
  vb3,
  vb5,
  xf,
  ip,
  ip4,
  pb,
  smf,
  smf1,
  mb,
  kunena,
  bb,
  kunena3,
  proboards,
  yuku,
  wbb,
  vanilla,
  unknown,
}

/// Utility class for URL sharing across different platforms
class UrlUtils {
  /// List of strings to replace with dashes in VB5 URLs
  static const List<String> _encodeReplaceList = [
    '%21',
    '%22',
    '%23',
    '%24',
    '%25',
    '%26',
    '%27',
    '%28',
    '%29',
    '%2A',
    '%2B',
    '%2C',
    '%2D',
    '%2E',
    '%2F',
    '%3A',
    '%3B',
    '%3C',
    '%3D',
    '%3E',
    '%3F',
    '%40',
    '%5B',
    '%5C',
    '%5D',
    '%5E',
    '%5F',
    '%60',
    '%7B',
    '%7C',
    '%7D',
    '%7E',
    ' ',
    '!',
    '"',
    '#',
    '\$',
    '%',
    '&',
    "'",
    '(',
    ')',
    '*',
    '+',
    ',',
    '.',
    '/',
    ':',
    ';',
    '<',
    '=',
    '>',
    '?',
    '@',
    '[',
    '\\',
    ']',
    '^',
    '_',
    '`',
    '{',
    '|',
    '}',
    '~'
  ];

  /// Generate a post URL for different forum types
  /// If [postId] is empty or "0", returns a topic URL instead of a post-specific URL.
  /// [postId] - The post ID (if empty or "0", returns topic URL)
  /// [topicTitle] - The topic title
  /// [subForumId] - The subforum ID
  /// [threadId] - The thread ID
  /// [forumUrl] - The base forum URL
  /// [forumType] - The forum template type
  /// [subforumPath] - Optional subforum path for VB5 forums
  static String getPostUrl({
    required SiteContext siteContext,
    required String postId,
    required String topicTitle,
    required String subForumId,
    required String threadId,
    required String forumUrl,
    required ForumTemplate forumType,
    String? subforumPath,
  }) {
    // Get the real forum URL by removing mobiquo directory from plugin URL
    String cleanForumUrl = siteContext.site.url;

    // URL encode the topic title
    String encodedTopicTitle = Uri.encodeComponent(topicTitle);

    // If postId is empty or "0", return topic URL instead of post URL
    if (postId.isEmpty || postId == '0') {
      return _getTopicUrl(
        siteContext: siteContext,
        topicTitle: topicTitle,
        subForumId: subForumId,
        threadId: threadId,
        forumUrl: cleanForumUrl,
        forumType: forumType,
        subforumPath: subforumPath,
        encodedTopicTitle: encodedTopicTitle,
      );
    }

    String postUrl;

    switch (forumType) {
      case ForumTemplate.dz:
        postUrl = '${cleanForumUrl}forum.php?mod=redirect&goto=findpost&pid=$postId&ptid=$threadId';
        break;

      case ForumTemplate.vb:
        postUrl = '${cleanForumUrl}showpost.php?p=$postId';
        break;

      case ForumTemplate.vb3:
        postUrl = '${cleanForumUrl}showthread.php?p=$postId';
        break;

      case ForumTemplate.vb5:
        // Replace encoded characters with dashes for VB5
        for (String replaceString in _encodeReplaceList) {
          encodedTopicTitle = encodedTopicTitle.replaceAll(replaceString, '-');
        }

        String forumPath = 'forum/';
        if (subforumPath != null && subforumPath.isNotEmpty) {
          forumPath = subforumPath;
        }

        // Remove trailing slash from forum URL for VB5
        String trimmedForumUrl = cleanForumUrl.replaceAll(RegExp(r'/$'), '');
        postUrl = '$trimmedForumUrl/$forumPath$threadId-$encodedTopicTitle?p=$postId#post$postId';
        break;

      case ForumTemplate.xf:
        postUrl = '${cleanForumUrl}index.php?posts/$postId/';
        break;

      case ForumTemplate.ip:
      case ForumTemplate.ip4:
        // Replace %20 with - and %2F with -
        encodedTopicTitle = encodedTopicTitle.replaceAll('%20', '-');
        encodedTopicTitle = encodedTopicTitle.replaceAll('%2F', '-');
        postUrl = '${cleanForumUrl}index.php?/topic/$threadId-$encodedTopicTitle/page__view__findpost__p__$postId';
        break;

      case ForumTemplate.pb:
        postUrl = '${cleanForumUrl}viewtopic.php?p=$postId#p$postId';
        break;

      case ForumTemplate.smf:
      case ForumTemplate.smf1:
        postUrl = '${cleanForumUrl}index.php?topic=$threadId.msg$postId#msg$postId';
        break;

      case ForumTemplate.mb:
        postUrl = '${cleanForumUrl}showthread.php?tid=$threadId&pid=$postId#pid$postId';
        break;

      case ForumTemplate.kunena:
        postUrl = '${cleanForumUrl}index.php?option=com_kunena&func=view&catid=$subForumId&id=$postId';
        break;

      case ForumTemplate.bb:
        postUrl = '$cleanForumUrl?post_type=topic&p=$threadId#post-$postId';
        break;

      case ForumTemplate.kunena3:
        postUrl = '${cleanForumUrl}index.php/forum?view=topic&catid=$subForumId&id=$threadId#$postId';
        break;

      case ForumTemplate.proboards:
        postUrl = '${cleanForumUrl}post/$postId/thread/$threadId';
        break;

      case ForumTemplate.yuku:
        if (postId.startsWith('lead_')) {
          // YUKU special case of first post of topic, should share topic URL instead
          return cleanForumUrl; // Return null equivalent - just the forum URL
        } else {
          postUrl = '${cleanForumUrl}sreply/$postId';
        }
        break;

      case ForumTemplate.wbb:
        postUrl = '${cleanForumUrl}index.php?page=Thread&postID=$postId#post$postId';
        break;

      case ForumTemplate.vanilla:
        postUrl = '${cleanForumUrl}discussion/$threadId/#Item_$postId';
        break;

      case ForumTemplate.unknown:
      default:
        postUrl = cleanForumUrl;
        break;
    }

    return postUrl;
  }

  /// Generate a topic URL for different forum types when postId is empty
  static String _getTopicUrl({
    required SiteContext siteContext,
    required String topicTitle,
    required String subForumId,
    required String threadId,
    required String forumUrl,
    required ForumTemplate forumType,
    String? subforumPath,
    required String encodedTopicTitle,
  }) {
    // Get the real forum URL by removing mobiquo directory from plugin URL
    String cleanForumUrl = siteContext.site.url;

    String topicUrl;

    switch (forumType) {
      case ForumTemplate.dz:
        topicUrl = '${cleanForumUrl}forum.php?mod=viewthread&tid=$threadId';
        break;

      case ForumTemplate.vb:
      case ForumTemplate.vb3:
        topicUrl = '${cleanForumUrl}showthread.php?t=$threadId';
        break;

      case ForumTemplate.vb5:
        // Replace encoded characters with dashes for VB5
        for (String replaceString in _encodeReplaceList) {
          encodedTopicTitle = encodedTopicTitle.replaceAll(replaceString, '-');
        }

        String forumPath = 'forum/';
        if (subforumPath != null && subforumPath.isNotEmpty) {
          forumPath = subforumPath;
        }

        // Remove trailing slash from forum URL for VB5
        String trimmedForumUrl = cleanForumUrl.replaceAll(RegExp(r'/$'), '');
        topicUrl = '$trimmedForumUrl/$forumPath$threadId-$encodedTopicTitle';
        break;

      case ForumTemplate.xf:
        topicUrl = '${cleanForumUrl}index.php?threads/$threadId/';
        break;

      case ForumTemplate.ip:
      case ForumTemplate.ip4:
        // Replace %20 with - and %2F with -
        encodedTopicTitle = encodedTopicTitle.replaceAll('%20', '-');
        encodedTopicTitle = encodedTopicTitle.replaceAll('%2F', '-');
        topicUrl = '${cleanForumUrl}index.php?/topic/$threadId-$encodedTopicTitle/';
        break;

      case ForumTemplate.pb:
        topicUrl = '${cleanForumUrl}viewtopic.php?t=$threadId';
        break;

      case ForumTemplate.smf:
      case ForumTemplate.smf1:
        topicUrl = '${cleanForumUrl}index.php?topic=$threadId.0';
        break;

      case ForumTemplate.mb:
        topicUrl = '${cleanForumUrl}showthread.php?tid=$threadId';
        break;

      case ForumTemplate.kunena:
        topicUrl = '${cleanForumUrl}index.php?option=com_kunena&func=view&catid=$subForumId&id=$threadId';
        break;

      case ForumTemplate.bb:
        topicUrl = '$cleanForumUrl?post_type=topic&p=$threadId';
        break;

      case ForumTemplate.kunena3:
        topicUrl = '${cleanForumUrl}index.php/forum?view=topic&catid=$subForumId&id=$threadId';
        break;

      case ForumTemplate.proboards:
        topicUrl = '${cleanForumUrl}thread/$threadId';
        break;

      case ForumTemplate.yuku:
        topicUrl = '${cleanForumUrl}topic/$threadId';
        break;

      case ForumTemplate.wbb:
        topicUrl = '${cleanForumUrl}index.php?page=Thread&threadID=$threadId';
        break;

      case ForumTemplate.vanilla:
        topicUrl = '${cleanForumUrl}discussion/$threadId/';
        break;

      case ForumTemplate.unknown:
      default:
        topicUrl = cleanForumUrl;
        break;
    }

    return topicUrl;
  }

  /// Parse forum type string to ForumTemplate enum
  ///
  /// [typeString] - The forum type string (e.g., "vb3", "xf", "ip4")
  static ForumTemplate parseForumType(String typeString) {
    final type = typeString.toLowerCase();

    // Discuz
    if (type.startsWith('dz')) return ForumTemplate.dz;

    // Invision Power Board
    if (type.startsWith('ip4')) return ForumTemplate.ip4;
    if (type.startsWith('ip3')) return ForumTemplate.ip;
    if (type.startsWith('ip')) return ForumTemplate.ip;

    // Simple Machines Forum
    if (type.startsWith('sm-2a')) return ForumTemplate.smf;
    if (type.startsWith('sm-2')) return ForumTemplate.smf;
    if (type.startsWith('sm21')) return ForumTemplate.smf;
    if (type.startsWith('sm20')) return ForumTemplate.smf1;
    if (type.startsWith('sm')) return ForumTemplate.smf;

    // PhpBB
    if (type.startsWith('pb31')) return ForumTemplate.pb;
    if (type.startsWith('pb30')) return ForumTemplate.pb;
    if (type.startsWith('pb')) return ForumTemplate.pb;

    // vBulletin
    if (type.startsWith('vb5')) return ForumTemplate.vb5;
    if (type.startsWith('vb4')) return ForumTemplate.vb;
    if (type.startsWith('vb3')) return ForumTemplate.vb3;
    if (type.startsWith('vb')) return ForumTemplate.vb;

    // XenForo
    if (type.startsWith('xenforo')) return ForumTemplate.xf;
    if (type.startsWith('xf')) return ForumTemplate.xf;

    // MyBB
    if (type.startsWith('mb')) return ForumTemplate.mb;

    // Kunena
    if (type.startsWith('kn50')) return ForumTemplate.kunena3;
    if (type.startsWith('kn40')) return ForumTemplate.kunena3;
    if (type.startsWith('kn30')) return ForumTemplate.kunena3;
    if (type.startsWith('kn3')) return ForumTemplate.kunena3;
    if (type.startsWith('kn2')) return ForumTemplate.kunena;
    if (type.startsWith('kn1')) return ForumTemplate.kunena;
    if (type.startsWith('kn')) return ForumTemplate.kunena;

    // bbPress
    if (type.startsWith('bb11')) return ForumTemplate.bb;
    if (type.startsWith('bb')) return ForumTemplate.bb;

    // Vanilla
    if (type.startsWith('vn')) return ForumTemplate.vanilla;

    // ProBoards
    if (type == 'proboards') return ForumTemplate.proboards;

    // Yuku (case insensitive)
    if (type.startsWith('yuku')) return ForumTemplate.yuku;

    // Woltlab Burning Board
    if (type.startsWith('wb50')) return ForumTemplate.wbb;
    if (type.startsWith('wb40')) return ForumTemplate.wbb;
    if (type.startsWith('wb')) return ForumTemplate.wbb;

    return ForumTemplate.unknown;
  }

  /// Generate subforum path for VB5 forums
  ///
  /// [subforumItems] - List of subforum items in hierarchy
  static String generateVB5SubforumPath(List<Map<String, String>> subforumItems) {
    if (subforumItems.isEmpty) return 'forum/';

    String forumPath = 'forum/';
    for (var subforumItem in subforumItems.reversed) {
      String forumName = (subforumItem['name'] ?? '').toLowerCase().replaceAll(' ', '-').replaceAll('/', '-');
      forumPath += '$forumName/';
    }

    return forumPath;
  }

  /// Share a post URL with context
  ///
  /// If [postId] is empty or "0", shares a topic URL instead of a post-specific URL.
  ///
  /// [postId] - The post ID (if empty or "0", shares topic URL)
  /// [topicTitle] - The topic title
  /// [subForumId] - The subforum ID
  /// [threadId] - The thread ID
  /// [forumUrl] - The base forum URL
  /// [forumType] - The forum template type
  /// [shareTitle] - Optional title for sharing
  /// [subforumPath] - Optional subforum path for VB5 forums
  static Future<void> sharePostUrl({
    required SiteContext siteContext,
    required String postId,
    required String topicTitle,
    required String subForumId,
    required String threadId,
    required String forumUrl,
    required ForumTemplate forumType,
    String? shareTitle,
    String? subforumPath,
  }) async {
    final postUrl = getPostUrl(
      siteContext: siteContext,
      postId: postId,
      topicTitle: topicTitle,
      subForumId: subForumId,
      threadId: threadId,
      forumUrl: forumUrl,
      forumType: forumType,
      subforumPath: subforumPath,
    );

    final title = shareTitle ?? 'Forum Post: $topicTitle';
    await shareUrl(postUrl, title: title);
  }

  /// Share a post URL with context using forum type string
  ///
  /// If [postId] is empty or "0", shares a topic URL instead of a post-specific URL.
  ///
  /// [postId] - The post ID (if empty or "0", shares topic URL)
  /// [topicTitle] - The topic title
  /// [subForumId] - The subforum ID
  /// [threadId] - The thread ID
  /// [forumUrl] - The base forum URL
  /// [forumTypeString] - The forum template type as string
  /// [shareTitle] - Optional title for sharing
  /// [subforumPath] - Optional subforum path for VB5 forums
  static Future<void> sharePostUrlWithTypeString({
    required SiteContext siteContext,
    required String postId,
    required String topicTitle,
    required String subForumId,
    required String threadId,
    required String forumUrl,
    required String forumTypeString,
    String? shareTitle,
    String? subforumPath,
  }) async {
    final forumType = parseForumType(forumTypeString);

    await sharePostUrl(
      siteContext: siteContext,
      postId: postId,
      topicTitle: topicTitle,
      subForumId: subForumId,
      threadId: threadId,
      forumUrl: forumUrl,
      forumType: forumType,
      shareTitle: shareTitle,
      subforumPath: subforumPath,
    );
  }

  /// Share a URL with optional title and subject
  ///
  /// [url] - The URL to share
  /// [title] - Optional title for the share dialog
  /// [subject] - Optional subject (mainly used for email sharing)
  /// [sharePositionOrigin] - Optional position for iPad popover (iOS only)
  static Future<void> shareUrl(
    String url, {
    String? title,
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    try {
      final String shareText = title != null ? '$title\n$url' : url;

      await Share.share(
        shareText,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      debugPrint('Error sharing URL: $e');
      // Fallback to copying URL to clipboard
      await copyUrlToClipboard(url);
    }
  }

  /// Share a URL with additional text content
  ///
  /// [url] - The URL to share
  /// [text] - Additional text content to share along with the URL
  /// [subject] - Optional subject for the share
  /// [sharePositionOrigin] - Optional position for iPad popover (iOS only)
  static Future<void> shareUrlWithText(
    String url,
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    try {
      final String shareContent = '$text\n\n$url';

      await Share.share(
        shareContent,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      debugPrint('Error sharing URL with text: $e');
      // Fallback to copying content to clipboard
      await Clipboard.setData(ClipboardData(text: '$text\n\n$url'));
    }
  }

  /// Copy URL to clipboard as a fallback sharing method
  ///
  /// [url] - The URL to copy to clipboard
  static Future<void> copyUrlToClipboard(String url) async {
    try {
      await Clipboard.setData(ClipboardData(text: url));
      debugPrint('URL copied to clipboard: $url');
    } catch (e) {
      debugPrint('Error copying URL to clipboard: $e');
    }
  }

  /// Share URL via platform-specific sharing with platform detection
  ///
  /// [url] - The URL to share
  /// [title] - Optional title for the share
  /// [subject] - Optional subject
  static Future<void> shareUrlPlatformSpecific(
    String url, {
    String? title,
    String? subject,
  }) async {
    try {
      if (kIsWeb) {
        // Web platform - copy to clipboard or use Web Share API if available
        await _shareOnWeb(url, title: title);
      } else if (Platform.isIOS) {
        // iOS specific sharing
        await _shareOnIOS(url, title: title, subject: subject);
      } else if (Platform.isAndroid) {
        // Android specific sharing
        await _shareOnAndroid(url, title: title, subject: subject);
      } else if (Platform.isMacOS) {
        // macOS specific sharing
        await _shareOnMacOS(url, title: title, subject: subject);
      } else if (Platform.isWindows || Platform.isLinux) {
        // Desktop platforms - copy to clipboard as fallback
        await copyUrlToClipboard(url);
      } else {
        // Unknown platform - use generic share
        await shareUrl(url, title: title, subject: subject);
      }
    } catch (e) {
      debugPrint('Error in platform-specific URL sharing: $e');
      // Ultimate fallback
      await copyUrlToClipboard(url);
    }
  }

  /// iOS specific URL sharing
  static Future<void> _shareOnIOS(
    String url, {
    String? title,
    String? subject,
  }) async {
    final String shareText = title != null ? '$title\n$url' : url;
    await Share.share(
      shareText,
      subject: subject,
    );
  }

  /// Android specific URL sharing
  static Future<void> _shareOnAndroid(
    String url, {
    String? title,
    String? subject,
  }) async {
    final String shareText = title != null ? '$title\n$url' : url;
    await Share.share(
      shareText,
      subject: subject,
    );
  }

  /// macOS specific URL sharing
  static Future<void> _shareOnMacOS(
    String url, {
    String? title,
    String? subject,
  }) async {
    final String shareText = title != null ? '$title\n$url' : url;
    await Share.share(
      shareText,
      subject: subject,
    );
  }

  /// Web platform URL sharing
  static Future<void> _shareOnWeb(
    String url, {
    String? title,
  }) async {
    try {
      // Try to use Web Share API - share_plus will handle availability internally
      final String shareText = title != null ? '$title\n$url' : url;
      await Share.share(shareText);
    } catch (e) {
      debugPrint('Web sharing failed, copying to clipboard: $e');
      // Fallback to clipboard if Web Share API is not available
      await copyUrlToClipboard(url);
    }
  }

  /// Open URL in browser as an alternative to sharing
  ///
  /// [url] - The URL to open
  static Future<void> openUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('Could not launch URL: $url');
      }
    } catch (e) {
      debugPrint('Error opening URL: $e');
    }
  }

  /// Share URL with multiple options (share, copy, or open)
  /// Returns a map with the results of each action
  ///
  /// [url] - The URL to share
  /// [title] - Optional title
  /// [includeOpen] - Whether to include option to open URL
  /// [includeCopy] - Whether to include option to copy URL
  static Future<Map<String, bool>> shareUrlWithOptions(
    String url, {
    String? title,
    bool includeOpen = true,
    bool includeCopy = true,
  }) async {
    final Map<String, bool> results = {};

    // Primary share action
    try {
      await shareUrl(url, title: title);
      results['share'] = true;
    } catch (e) {
      results['share'] = false;
      debugPrint('Share failed: $e');
    }

    // Copy to clipboard option
    if (includeCopy) {
      try {
        await copyUrlToClipboard(url);
        results['copy'] = true;
      } catch (e) {
        results['copy'] = false;
        debugPrint('Copy failed: $e');
      }
    }

    // Open URL option
    if (includeOpen) {
      try {
        await openUrl(url);
        results['open'] = true;
      } catch (e) {
        results['open'] = false;
        debugPrint('Open failed: $e');
      }
    }

    return results;
  }

  /// Validate if a string is a valid URL
  ///
  /// [url] - The string to validate
  /// Returns true if the string is a valid URL
  static bool isValidUrl(String url) {
    try {
      final Uri uri = Uri.parse(url);
      return uri.hasScheme && (uri.hasAuthority || uri.hasAbsolutePath);
    } catch (e) {
      return false;
    }
  }

  /// Format URL for sharing by ensuring it has a proper scheme
  ///
  /// [url] - The URL to format
  /// Returns a properly formatted URL with scheme
  static String formatUrlForSharing(String url) {
    if (url.isEmpty) return url;

    // If URL already has a scheme, return as is
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    // Add https:// as default scheme
    return 'https://$url';
  }

  /// Handle URL tap with simple external launch (default behavior)
  ///
  /// [url] - The URL that was tapped
  /// [context] - BuildContext for error handling
  static Future<void> handleUrlTap(
    String url,
    BuildContext context,
  ) async {
    try {
      final cleanUrl = url.trim().replaceAll('"', '');

      // Check if it's an email address
      if (_isEmailAddress(cleanUrl)) {
        await _openEmailAddress(cleanUrl, context);
        return;
      }

      await openUrl(cleanUrl);
    } catch (e) {
      debugPrint('Error handling URL tap: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link: ${url.length > 50 ? '${url.substring(0, 50)}...' : url}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Handle URL tap with intelligent forum URL detection (advanced behavior)
  ///
  /// [url] - The URL that was tapped
  /// [context] - BuildContext for navigation and error handling
  /// [forumUrl] - Current forum URL for same-forum detection
  /// [forumType] - Forum type for URL analysis
  /// [onForumNavigation] - Callback for forum navigation (optional)
  static Future<void> handleUrlTapWithForumDetection(
    SiteContext siteContext,
    String url,
    BuildContext context, {
    required String forumUrl,
    required String forumType,
    Function(String topicId, String? postId, String? forumId)? onForumNavigation,
  }) async {
    try {
      final cleanUrl = url.trim().replaceAll('"', '');

      // Check if it's an email address first
      if (_isEmailAddress(cleanUrl)) {
        await _openEmailAddress(cleanUrl, context);
        return;
      }

      // Check if this is a forum URL that should be handled internally
      final analysis = _analyzeForumUrl(siteContext, cleanUrl, forumUrl, forumType);
      if (analysis.isSameForum) {
        // Use callback if provided, otherwise fallback to external launch
        if (onForumNavigation != null) {
          onForumNavigation(
            analysis.topicId ?? '',
            analysis.postId,
            analysis.forumId,
          );
        } else {
          // Fallback to external launch if no callback provided
          await openUrl(cleanUrl);
        }
        return;
      }

      // Launch external URL
      await openUrl(cleanUrl);
    } catch (e) {
      debugPrint('Error handling URL tap: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link: ${url.length > 50 ? '${url.substring(0, 50)}...' : url}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Check if a URL is from the same domain as the forum site
  ///
  /// [siteContext] - The site context containing forum information
  /// [url] - The URL to check
  /// Returns true if the URL is from the same domain as the forum
  static bool isSameDomain(SiteContext siteContext, String url) {
    try {
      // Get the real forum URL
      String baseCurrentUrl = siteContext.site.url;

      // Parse both URLs
      final Uri currentUri = Uri.parse(baseCurrentUrl);
      final Uri targetUri = Uri.parse(url);

      // Check if the URL belongs to the same domain
      return currentUri.host == targetUri.host;
    } catch (e) {
      debugPrint('Error checking same domain: $e');
      return false;
    }
  }

  /// Analyze if a URL belongs to the current forum
  static _ForumUrlAnalysis _analyzeForumUrl(SiteContext siteContext, String url, String forumUrl, String forumType) {
    try {
      // Get the real forum URL by removing mobiquo directory from plugin URL
      String baseCurrentUrl = siteContext.site.url;

      // Check if the URL belongs to the same domain
      final Uri currentUri = Uri.parse(baseCurrentUrl);
      final Uri targetUri = Uri.parse(url);

      if (currentUri.host != targetUri.host) {
        return _ForumUrlAnalysis(isSameForum: false, originalUrl: url);
      }

      // Parse URL based on forum type to extract IDs
      return _parseUrlByForumType(url, parseForumType(forumType));
    } catch (e) {
      debugPrint('Error analyzing forum URL: $e');
      return _ForumUrlAnalysis(isSameForum: false, originalUrl: url);
    }
  }

  /// Parse URL based on forum type to extract topic_id and post_id
  static _ForumUrlAnalysis _parseUrlByForumType(String url, ForumTemplate forumType) {
    try {
      String? topicId;
      String? postId;
      String? forumId;

      switch (forumType) {
        case ForumTemplate.dz:
          // forum.php?mod=viewthread&tid=123 or forum.php?mod=redirect&goto=findpost&pid=456&ptid=123
          final tidMatch = RegExp(r'tid=(\d+)').firstMatch(url);
          final pidMatch = RegExp(r'pid=(\d+)').firstMatch(url);
          topicId = tidMatch?.group(1);
          postId = pidMatch?.group(1);
          break;

        case ForumTemplate.vb:
        case ForumTemplate.vb3:
          // showthread.php?t=123 or showpost.php?p=456
          final tMatch = RegExp(r'[?&]t=(\d+)').firstMatch(url);
          final pMatch = RegExp(r'[?&]p=(\d+)').firstMatch(url);
          topicId = tMatch?.group(1);
          postId = pMatch?.group(1);
          break;

        case ForumTemplate.vb5:
          // /forum/123-topic-title?p=456#post456
          final topicMatch = RegExp(r'/(\d+)-[^?]+').firstMatch(url);
          final postMatch = RegExp(r'[?&]p=(\d+)').firstMatch(url);
          topicId = topicMatch?.group(1);
          postId = postMatch?.group(1);
          break;

        case ForumTemplate.xf:
          // XenForo URL parsing rules:
          // 1) /threads/{thread}/post-{post_id}
          // 2) /posts/{post_id}
          // 3) /threads/{thread}#post-{post_id}
          // 4) /threads/{thread}
          final Uri xfUri = Uri.parse(url);
          final String pathWithQuery = xfUri.query.isNotEmpty ? '${xfUri.path}?${xfUri.query}' : xfUri.path;
          final String fragment = xfUri.fragment;
          final directPostMatch = RegExp(r'(?:/|\?|&)threads/(?:[^/]+\.)?(\d+)/post-(\d+)', caseSensitive: false).firstMatch(pathWithQuery);
          if (directPostMatch != null) {
            topicId = directPostMatch.group(1);
            postId = directPostMatch.group(2);
            break;
          }
          final shortPostMatch = RegExp(r'(?:/|\?|&)posts/(\d+)/?', caseSensitive: false).firstMatch(pathWithQuery);
          if (shortPostMatch != null) {
            postId = shortPostMatch.group(1);
            break;
          }
          final threadMatch = RegExp(r'(?:/|\?|&)threads/(?:[^/]+\.)?(\d+)(?:/|$|(?=page-)|(?=unread))', caseSensitive: false).firstMatch(pathWithQuery);
          if (threadMatch != null) {
            topicId = threadMatch.group(1);
            final fragmentMatch = RegExp(r'^post-(\d+)$', caseSensitive: false).firstMatch(fragment);
            if (fragmentMatch != null) {
              postId = fragmentMatch.group(1);
            }
            break;
          }
          // Fallback: index.php?threads/123/ or index.php?posts/456/
          final threadQueryMatch = RegExp(r'threads/(?:[^/]+\.)?(\d+)', caseSensitive: false).firstMatch(url);
          final postQueryMatch = RegExp(r'posts/(\d+)', caseSensitive: false).firstMatch(url);
          topicId = threadQueryMatch?.group(1);
          postId = postQueryMatch?.group(1);
          break;

        case ForumTemplate.ip:
        case ForumTemplate.ip4:
          // index.php?/topic/123-topic-title/page__view__findpost__p__456
          final topicMatch = RegExp(r'/topic/(\d+)').firstMatch(url);
          final postMatch = RegExp(r'p__(\d+)').firstMatch(url);
          topicId = topicMatch?.group(1);
          postId = postMatch?.group(1);
          break;

        case ForumTemplate.pb:
          // viewtopic.php?t=123 or viewtopic.php?p=456#p456
          // Also handle legacy pattern: -t12345.html
          final tMatch = RegExp(r'[?&]t=(\d+)').firstMatch(url);
          final pMatch = RegExp(r'[?&]p=(\d+)').firstMatch(url);
          final tapatalkTopicMatch = RegExp(r'-t(\d+)\.html').firstMatch(url);

          topicId = tMatch?.group(1) ?? tapatalkTopicMatch?.group(1);
          postId = pMatch?.group(1);
          break;

        case ForumTemplate.smf:
        case ForumTemplate.smf1:
          // index.php?topic=123.0 or index.php?topic=123.msg456#msg456
          final topicMatch = RegExp(r'topic=(\d+)').firstMatch(url);
          final msgMatch = RegExp(r'msg(\d+)').firstMatch(url);
          topicId = topicMatch?.group(1);
          postId = msgMatch?.group(1);
          break;

        default:
          // For other forum types, try generic patterns
          final genericTopicMatch = RegExp(r'[?&](?:tid|thread|topic)=(\d+)').firstMatch(url);
          final genericPostMatch = RegExp(r'[?&](?:pid|post)=(\d+)').firstMatch(url);

          topicId = genericTopicMatch?.group(1);
          postId = genericPostMatch?.group(1);
          break;
      }

      final bool isSameForum = topicId != null || postId != null || forumId != null;
      return _ForumUrlAnalysis(
        isSameForum: isSameForum,
        topicId: topicId,
        postId: postId,
        forumId: forumId,
        originalUrl: url,
      );
    } catch (e) {
      debugPrint('Error parsing URL by forum type: $e');
      return _ForumUrlAnalysis(isSameForum: false, originalUrl: url);
    }
  }

  /// Check if a string is a valid email address
  ///
  /// [email] - The string to check
  /// Returns true if the string is a valid email address
  static bool _isEmailAddress(String email) {
    // Simple email regex pattern
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Open email address with platform-specific handling
  ///
  /// [email] - The email address to open
  /// [context] - BuildContext for error handling
  static Future<void> _openEmailAddress(String email, BuildContext context) async {
    try {
      // Remove mailto: prefix if present
      String cleanEmail = email;
      if (cleanEmail.toLowerCase().startsWith('mailto:')) {
        cleanEmail = cleanEmail.substring(7);
      }

      // Create mailto URI
      final Uri mailtoUri = Uri.parse('mailto:$cleanEmail');

      if (await canLaunchUrl(mailtoUri)) {
        await launchUrl(mailtoUri);
      } else {
        // Fallback: try to copy email to clipboard
        await Clipboard.setData(ClipboardData(text: cleanEmail));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email copied to clipboard: $cleanEmail'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error opening email address: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open email: $email'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

/// Internal class for forum URL analysis results
class _ForumUrlAnalysis {
  final bool isSameForum;
  final String? topicId;
  final String? postId;
  final String? forumId;
  final String originalUrl;

  _ForumUrlAnalysis({
    required this.isSameForum,
    this.topicId,
    this.postId,
    this.forumId,
    required this.originalUrl,
  });
}
