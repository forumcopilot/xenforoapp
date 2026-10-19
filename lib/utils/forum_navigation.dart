import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';
import 'package:forumcopilot_flutter/views/forum_topics_page.dart';
import 'package:forumcopilot_flutter/views/in_app_web_view_page.dart';
import 'app_navigation.dart';

/// Pushes either the in-app web view (for link forums) or [ForumTopicsPage].
///
/// If [forum] has [FCForum.isLinkForum] true and a non-empty [FCForum.externalUrl],
/// pushes [InAppWebViewPage] with that URL. Otherwise pushes [ForumTopicsPage].
///
/// [parent] is the forum [forum] is in, for the page's breadcrumb, when the
/// caller has it; [openedFromParent] says the caller is [parent]'s own page,
/// which the breadcrumb then goes back to rather than opening it again.
void pushForumOrLinkForum(
  BuildContext context,
  FCForum forum,
  SiteContext siteContext, {
  FCForum? parent,
  bool openedFromParent = false,
}) {
  if (forum.isLinkForum && forum.externalUrl != null && forum.externalUrl!.isNotEmpty) {
    AppNavigation.push(context, InAppWebViewPage(
          url: forum.externalUrl!,
          title: forum.name,
        ));
  } else {
    AppNavigation.push(context, ForumTopicsPage(
          forum: forum,
          siteContext: siteContext,
          parent: parent,
          openedFromParent: openedFromParent,
        ));
  }
}
