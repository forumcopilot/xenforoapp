import 'package:forumcopilot_sdk/models/entities/fc_user.dart';
import '../data/user/user.dart';

/// Converter for mapping XenForoUser to FCUser
class XenForoUserConverter {
  /// Convert a single XenForoUser to FCUser
  static FCUser toFCUser(XenForoUser xenForoUser) {
    return FCUser(
      id: xenForoUser.userId.toString(),
      username: xenForoUser.username,
      loginName: xenForoUser.username,
      email: xenForoUser.email,
      userType: xenForoUser.userTitle,
      iconUrl: _getAvatarUrl(xenForoUser),
      postCount: xenForoUser.messageCount ?? 0,
      registrationTime: xenForoUser.registerDate != null ? DateTime.fromMillisecondsSinceEpoch(xenForoUser.registerDate! * 1000) : null,
      lastActivityTime: xenForoUser.lastActivity != null ? DateTime.fromMillisecondsSinceEpoch(xenForoUser.lastActivity! * 1000) : null,
      isOnline: xenForoUser.isOnline,
      acceptsPM: xenForoUser.canConverse ?? false,
      canSendPM: xenForoUser.canConverse ?? false,
      canPM: xenForoUser.canConverse ?? false,
      isFollowing: xenForoUser.isFollowed ?? false,
      isFollowingMe: false, // Not available in API
      acceptsFollowers: false, // Not available in API
      followingCount: 0, // Not available in API
      followerCount: 0, // Not available in API
      displayText: xenForoUser.userTitle,
      customFields: _getCustomFields(xenForoUser),
      canBan: xenForoUser.canBan ?? false,
      isBanned: xenForoUser.isBanned ?? false,
      isIgnored: xenForoUser.isIgnored ?? false,
      userGroups: _getUserGroups(xenForoUser),
      canModerate: xenForoUser.isModerator ?? false,
      canSearch: false, // Not available in API
    );
  }

  /// Convert a list of XenForoUser to FCUser list
  static List<FCUser> toFCUserList(List<XenForoUser> xenForoUsers) {
    return xenForoUsers.map((user) => toFCUser(user)).toList();
  }

  /// Get avatar URL from XenForoUser
  static String? _getAvatarUrl(XenForoUser user) {
    // Try different avatar URL sources
    if (user.avatarUrls != null && user.avatarUrls!.isNotEmpty) {
      // Get the largest avatar available
      final urls = user.avatarUrls!;
      if (urls.containsKey('l')) return urls['l'];
      if (urls.containsKey('m')) return urls['m'];
      if (urls.containsKey('s')) return urls['s'];
      // Return first available URL
      return urls.values.first;
    }

    // Fallback to direct avatar URL
    return user.avatarUrl;
  }

  /// Get user groups list from XenForoUser
  static List<String> _getUserGroups(XenForoUser user) {
    final groups = <String>[];

    // Add primary group if available
    if (user.userGroupId != null) {
      groups.add('Group ${user.userGroupId}');
    }

    // Add secondary groups if available
    if (user.secondaryGroupIds != null && user.secondaryGroupIds!.isNotEmpty) {
      groups.addAll(user.secondaryGroupIds!.map((id) => 'Group $id'));
    }

    // Add user title as a group
    if (user.userTitle != null && user.userTitle!.isNotEmpty) {
      groups.add(user.userTitle!);
    }

    return groups;
  }

  /// Extract custom fields from XenForoUser
  static List<FCUserCustomField> _getCustomFields(XenForoUser user) {
    final customFields = <FCUserCustomField>[];

    // Add profile fields as custom fields
    if (user.location != null) {
      customFields.add(FCUserCustomField(name: 'location', value: user.location!));
    }
    if (user.website != null) {
      customFields.add(FCUserCustomField(name: 'website', value: user.website!));
    }
    if (user.about != null) {
      customFields.add(FCUserCustomField(name: 'about', value: user.about!));
    }

    return customFields;
  }
}
