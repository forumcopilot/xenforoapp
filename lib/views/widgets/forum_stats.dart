import 'package:flutter/widgets.dart';
import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';

import '../../l10n/generated/app_localizations.dart';

/// "120 topics · 4.5K posts" for a forum's header and its row, worded as
/// the Home header's stats; null when the forum sends no counts (a category,
/// or an add-on that leaves them out).
String? forumStatsLine(BuildContext context, FCForum forum) {
  final l10n = AppLocalizations.of(context);
  final parts = [
    if (forum.topicCount > 0) l10n.statsTopics(forum.topicCount),
    if (forum.postCount > 0) l10n.statsPosts(forum.postCount),
  ];
  return parts.isEmpty ? null : parts.join(' · ');
}
