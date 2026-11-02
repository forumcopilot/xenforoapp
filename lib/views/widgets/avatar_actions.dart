import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_flutter/views/user_profile_page.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import '../../utils/app_navigation.dart';

class AvatarActions {
  /// Opens the member's profile, for guests too: the forum decides what they
  /// see. The add-on sends XenForo's member card to anyone, and the full
  /// profile (about, location, custom fields, follow counts, recent posts)
  /// only where "View member profiles" and the member's privacy allow it, as
  /// the website's member page does.
  void handleAvatarTap(BuildContext context, SiteContext siteContext, String userId, String userName) {
    AppLogger.debug('Avatar tapped for user: $userId $userName');
    AppNavigation.push(context, UserProfilePage(
          siteContext: siteContext,
          userId: userId,
          userName: userName,
        ));
  }
}
