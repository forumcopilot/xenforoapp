import 'package:dart_mappable/dart_mappable.dart';

part 'link_forum.mapper.dart';

/// XenForo link forum data model based on official API documentation
@MappableClass()
class XenForoLinkForum with XenForoLinkForumMappable {
  /// Link URL
  final String? linkUrl;

  /// Redirect count
  final int? redirectCount;

  const XenForoLinkForum({
    this.linkUrl,
    this.redirectCount,
  });

  factory XenForoLinkForum.fromJson(Map<String, dynamic> json) {
    return XenForoLinkForum(
      linkUrl: json['link_url'],
      redirectCount: json['redirect_count'],
    );
  }

  // Convenience getters for backward compatibility
  String get url => linkUrl ?? '';
  int get redirects => redirectCount ?? 0;
  bool get isActive => linkUrl != null;
}
