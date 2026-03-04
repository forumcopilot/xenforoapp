import 'package:forumcopilot_sdk/models/entities/fc_post.dart';
import '../data/post/post.dart';
import 'xenforo_attachment_converter.dart';

/// Converter for XenForo post data to FCPost
class XenForoPostConverter {
  /// Convert XenForo post to FCPost
  static FCPost toFCPost(XenForoPost xenForoPost) {
    return FCPost(
      id: xenForoPost.id,
      title: xenForoPost.title,
      content: xenForoPost.content,
      topicId: xenForoPost.topicId,
      authorId: xenForoPost.authorId,
      authorName: xenForoPost.authorName,
      authorUserType: xenForoPost.authorUserType,
      timestamp: xenForoPost.postDateTime,
      authorIconUrl: xenForoPost.authorAvatarUrl,
      isAuthorOnline: xenForoPost.user?.isOnline ?? false,
      canEdit: xenForoPost.canEdit ?? false,
      allowSmilies: true, // Assume smilies are allowed
      attachments: (xenForoPost.attachments ?? []).map((attachment) => XenForoAttachmentConverter.toFCAttachment(attachment)).toList(),
      inlineAttachments: const [],
      thanksInfo: const [],
      likesInfo: const [],
      postNumber: xenForoPost.postNumber,
      canBan: false, // Not available in API
      canDelete: xenForoPost.canDelete,
      canApprove: false, // Not available in API
      canMove: false, // Not available in API
      canReport: xenForoPost.canReport,
      isBanned: xenForoPost.user?.isBanned ?? false,
      isDeleted: xenForoPost.isDeleted,
      isApproved: xenForoPost.isApproved,
      isLiked: xenForoPost.isLiked,
      isThanked: false, // Not available in API
      canLike: xenForoPost.canLike,
      canThank: false, // Not available in API
    );
  }

  /// Convert list of XenForo posts to list of FCPosts
  static List<FCPost> toFCPostList(List<XenForoPost> xenForoPosts) {
    return xenForoPosts.map((post) => toFCPost(post)).toList();
  }
}
