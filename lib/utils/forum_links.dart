import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import '../controllers/site_manager.dart';
import '../core/logging/app_logger.dart';
import '../views/lists/posts_list.dart';
import '../views/login_page.dart';
import '../views/post_page.dart';
import '../views/private_messaging/conversation/pages/conversation_page.dart';
import '../views/user_profile_page.dart';
import 'app_navigation.dart';
import 'forum_navigation.dart';
import 'url_utils.dart';

/// A page of the open forum that the app has a screen for.
sealed class ForumLinkTarget {
  const ForumLinkTarget();
}

/// A thread, at [postId] when the link points at one of its posts.
class ThreadLink extends ForumLinkTarget {
  const ThreadLink(this.topicId, {this.postId});
  final String topicId;
  final String? postId;
}

/// A post, by its id alone (`/posts/123/`, `/goto/post?id=123`).
class PostLink extends ForumLinkTarget {
  const PostLink(this.postId);
  final String postId;
}

class ForumSectionLink extends ForumLinkTarget {
  const ForumSectionLink(this.forumId);
  final String forumId;
}

class MemberLink extends ForumLinkTarget {
  const MemberLink(this.userId);
  final String userId;
}

/// A direct message, at [messageId] when the link points at one message.
class ConversationLink extends ForumLinkTarget {
  const ConversationLink(this.conversationId, {this.messageId});
  final String conversationId;
  final String? messageId;
}

/// The one place a tapped link is opened: pages of the open forum on their
/// own screens, anything else in the browser (mail links in the mail app).
///
/// A link counts as the forum's when it is on the forum's host, with or
/// without `www.`, over http or https, and inside the forum's folder (a forum
/// at example.com/community/ does not claim example.com/shop/). Friendly
/// URLs (`/threads/title.123/`) and plain ones (`index.php?threads/123/`)
/// both work.
class ForumLinks {
  ForumLinks._();

  /// What [url] points at, when it is a page of [site] the app can show;
  /// null for another site or a page of this one with no screen in the app.
  static ForumLinkTarget? parse(String url, Site site) {
    final uri = Uri.tryParse(url.trim());
    if (uri == null || !(uri.scheme == 'http' || uri.scheme == 'https')) return null;
    final base = rootOf(site);
    if (base == null) return null;
    if (_host(uri.host) != _host(base.host)) return null;

    final basePath = _folder(base.path);
    final path = uri.path.toLowerCase();
    if (!(path == basePath.substring(0, basePath.length - 1) || path.startsWith(basePath))) return null;

    // The route: after the folder (friendly URLs, also /index.php/route), or
    // the query's first part (index.php?threads/123/&page=2).
    var route = uri.path.length >= basePath.length ? uri.path.substring(basePath.length) : '';
    if (route.toLowerCase().startsWith('index.php')) route = route.substring('index.php'.length);
    route = route.replaceFirst(RegExp(r'^/+'), '');
    final query = uri.query;
    if (route.isEmpty && query.isNotEmpty) {
      route = Uri.decodeComponent(query.split('&').first);
    }
    final params = <String, String>{};
    for (final part in query.split('&')) {
      final eq = part.indexOf('=');
      if (eq > 0) params[part.substring(0, eq)] = part.substring(eq + 1);
    }
    return _route(route, params, uri.fragment);
  }

  static final RegExp _thread = RegExp(r'^threads/(?:[^/]*\.)?(\d+)(?:/|$)(?:.*?post-(\d+))?', caseSensitive: false);
  static final RegExp _post = RegExp(r'^posts/(\d+)(?:/|$)', caseSensitive: false);
  static final RegExp _goto = RegExp(r'^goto/post(?:/|$)', caseSensitive: false);
  static final RegExp _forum = RegExp(r'^forums/(?:[^/]*\.)?(\d+)(?:/|$)', caseSensitive: false);
  static final RegExp _member = RegExp(r'^members/(?:[^/]*\.)?(\d+)(?:/|$)', caseSensitive: false);
  static final RegExp _conversation =
      RegExp(r'^(?:conversations|direct-messages)/(?:[^/]*\.)?(\d+)(?:/|$)', caseSensitive: false);

  static ForumLinkTarget? _route(String route, Map<String, String> params, String fragment) {
    var m = _thread.firstMatch(route);
    if (m != null) {
      final postId = m.group(2) ?? RegExp(r'^post-(\d+)$').firstMatch(fragment)?.group(1);
      return ThreadLink(m.group(1)!, postId: postId);
    }
    m = _post.firstMatch(route);
    if (m != null) return PostLink(m.group(1)!);
    if (_goto.hasMatch(route)) {
      final id = params['id'];
      return id != null && RegExp(r'^\d+$').hasMatch(id) ? PostLink(id) : null;
    }
    m = _forum.firstMatch(route);
    if (m != null) return ForumSectionLink(m.group(1)!);
    m = _member.firstMatch(route);
    if (m != null) return MemberLink(m.group(1)!);
    m = _conversation.firstMatch(route);
    if (m != null) {
      final messageId = RegExp(r'^(?:convMessage|message)-(\d+)$').firstMatch(fragment)?.group(1);
      return ConversationLink(m.group(1)!, messageId: messageId);
    }
    return null;
  }

  /// The forum's root, where the add-on's forumcopilot.php sits (XenForo's
  /// own root), or the forum's address when there is no endpoint.
  static Uri? rootOf(Site site) {
    final plugin = Uri.tryParse(site.pluginUrl);
    if (plugin != null && plugin.host.isNotEmpty && plugin.path.toLowerCase().endsWith('.php')) {
      final path = plugin.path;
      return Uri(scheme: plugin.scheme, host: plugin.host, port: plugin.hasPort ? plugin.port : null, path: path.substring(0, path.lastIndexOf('/') + 1));
    }
    final url = Uri.tryParse(site.baseUrl?.isNotEmpty == true ? site.baseUrl! : site.url);
    if (url == null || url.host.isEmpty) return null;
    final path = url.path.endsWith('/') ? url.path : '${url.path}/';
    return Uri(scheme: url.scheme, host: url.host, port: url.hasPort ? url.port : null, path: path);
  }

  /// A link to post [postId] of [site] that works with or without friendly
  /// URLs (XenForo sends it on to the thread, at the post).
  static String? postUrl(Site site, String postId) {
    final root = rootOf(site);
    if (root == null) return null;
    return '${root.scheme}://${root.authority}${root.path}index.php?posts/$postId/';
  }

  /// A link to forum [forumId] of [site], with or without friendly URLs.
  static String? forumUrl(Site site, String forumId) {
    final root = rootOf(site);
    if (root == null) return null;
    return '${root.scheme}://${root.authority}${root.path}index.php?forums/$forumId/';
  }

  static String _host(String host) {
    final h = host.toLowerCase();
    return h.startsWith('www.') ? h.substring(4) : h;
  }

  /// [path] as a folder: lower case, starting and ending with '/'.
  static String _folder(String path) {
    var p = path.toLowerCase();
    if (p.endsWith('index.php')) p = p.substring(0, p.length - 'index.php'.length);
    if (!p.startsWith('/')) p = '/$p';
    if (!p.endsWith('/')) p = '$p/';
    return p;
  }

  /// Opens [url]: a page of [siteContext]'s forum on its own screen, anything
  /// else outside the app.
  static Future<void> open(BuildContext context, String url, SiteContext siteContext) async {
    final clean = url.trim().replaceAll('"', '');
    final target = parse(clean, siteContext.site);
    if (target == null) {
      await UrlUtils.handleUrlTap(clean, context);
      return;
    }
    AppLogger.debug('ForumLinks: $clean -> ${target.runtimeType}');
    switch (target) {
      case ThreadLink(:final topicId, :final postId):
        await _signInIfRemembered(siteContext);
        if (!context.mounted) return;
        await AppNavigation.push(
          context,
          PostPage(
            siteContext: siteContext,
            topicId: topicId,
            title: '',
            mode: postId != null ? PostsListMode.thread_by_post : PostsListMode.normal,
            anchorPostId: postId,
          ),
        );
      case PostLink(:final postId):
        await _signInIfRemembered(siteContext);
        if (!context.mounted) return;
        // By post alone: the thread is found from the post.
        await AppNavigation.push(
          context,
          PostPage(
            siteContext: siteContext,
            topicId: postId,
            title: '',
            mode: PostsListMode.thread_by_post,
            anchorPostId: postId,
          ),
        );
      case ForumSectionLink(:final forumId):
        final forum = await SiteManagerRegistry.getManager(siteContext).getForumById(forumId);
        if (!context.mounted) return;
        if (forum == null) {
          await UrlUtils.handleUrlTap(clean, context);
        } else {
          pushForumOrLinkForum(context, forum, siteContext);
        }
      case MemberLink(:final userId):
        await AppNavigation.push(context, UserProfilePage(siteContext: siteContext, userId: userId));
      case ConversationLink(:final conversationId, :final messageId):
        // The conversation page signs in (or asks to) itself.
        await AppNavigation.push(
          context,
          ConversationPage(
            siteContext: siteContext,
            conversationId: conversationId,
            subject: '',
            anchorMessageId: messageId,
          ),
        );
    }
  }

  /// A guest with saved credentials is signed in first, as a thread they can
  /// see signed in may be hidden from guests; if that fails the sign-in page
  /// is offered, and the thread opens either way.
  static Future<void> _signInIfRemembered(SiteContext siteContext) async {
    if (siteContext.isLoggedIn) return;
    if (!Get.isRegistered<LoginController>()) Get.put(LoginController());
    final result = await Get.find<LoginController>().attemptAutomaticLogin(siteContext);
    if (!result.success && result.hadCredentials && Get.currentRoute != '/LoginPage') {
      await AppNavigation.pushGlobal(LoginPage(siteContext: siteContext), name: '/LoginPage');
    }
  }
}
