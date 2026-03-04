import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';
import 'package:forumcopilot_flutter/views/forum_topics_page.dart';
import 'package:forumcopilot_flutter/views/in_app_web_view_page.dart';

/// Pushes either the in-app web view (for link forums) or [ForumTopicsPage].
///
/// If [forum] has [FCForum.isLinkForum] true and a non-empty [FCForum.externalUrl],
/// pushes [InAppWebViewPage] with that URL. Otherwise pushes [ForumTopicsPage].
void pushForumOrLinkForum(
  BuildContext context,
  FCForum forum,
  SiteContext siteContext,
) {
  if (forum.isLinkForum && forum.externalUrl != null && forum.externalUrl!.isNotEmpty) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => InAppWebViewPage(
          url: forum.externalUrl!,
          title: forum.name,
        ),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ForumTopicsPage(
          forum: forum,
          siteContext: siteContext,
        ),
      ),
    );
  }
}
