import 'package:forumcopilot_sdk/models/entities/fc_forum.dart';
import '../data/node/node.dart';

/// Converter for XenForo forum data to FCForum
class XenForoForumConverter {
  /// Convert XenForo node (forum) to FCForum
  static FCForum toFCForum(XenForoNode node) {
    final typeData = node.typeData ?? const {};
    return FCForum(
      id: node.id,
      name: node.title ?? '',
      description: node.description,
      logoUrl: null,
      backgroundUrl: null,
      parentId: node.parentId.isEmpty ? null : node.parentId,
      hasNewPosts: false,
      isProtected: false,
      isSubscribed: false,
      canSubscribe: true,
      canPost: (typeData['allow_posting'] as bool?) ?? true,
      externalUrl: typeData['link_url'] as String?,
      isSubForumContainer: false,
      childForums: const [],
    );
  }

  /// Convert list of XenForo forums to list of FCForums
  static List<FCForum> toFCForumList(List<XenForoNode> nodes) {
    return nodes.map((forumNode) => toFCForum(forumNode)).toList();
  }
}
