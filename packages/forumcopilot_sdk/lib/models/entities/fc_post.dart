import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/mapping/hooks.dart';
import 'fc_attachment.dart';
import 'fc_like.dart';
import 'fc_post_reaction.dart';
import 'fc_post_vote.dart';
import 'fc_thanks.dart';

part 'fc_post.mapper.dart';

/// FCPost (Forum Consolidated Post) is a unified post model for UI consumption
/// that abstracts away the specific implementation details of different post sources.
@MappableClass()
class FCPost with FCPostMappable {
  /// Unique identifier for the post
  String id;

  /// Title of the post
  String title;

  /// Content of the post
  String content;

  /// Topic ID this post belongs to
  String topicId;

  /// Title of the topic this post belongs to (used in search results)
  String? topicTitle;

  /// Author ID of the post creator
  String authorId;

  /// Author name of the post creator
  String authorName;

  /// Author user type (e.g., admin, moderator, user)
  String? authorUserType;

  /// Date/time when the post was created
  @MappableField(hook: MillisOrIsoDateHook())
  DateTime? timestamp;

  /// URL to the author's avatar/icon
  String? authorIconUrl;

  /// Indicates if the post author is currently online
  bool isAuthorOnline;

  /// Indicates if the user can edit this post
  bool canEdit;

  /// Indicates if smilies are allowed in this post
  bool allowSmilies;

  /// List of attachments in this post
  List<FCAttachment> attachments;

  /// List of inline attachments in this post
  List<FCAttachment> inlineAttachments;

  /// List of thanks information for this post
  List<FCThanks> thanksInfo;

  /// List of likes information for this post
  List<FCLike> likesInfo;

  /// Number of likes/main-reactions on this post. Prefer this over
  /// likesInfo.length — likesInfo may be empty when the actor list
  /// hasn't been fetched.
  int likeCount;

  /// POst number of this post in the forum
  int? postNumber;

  /// Moderation capabilities
  bool canBan;
  bool canDelete;
  bool canApprove;
  bool canMove;
  bool canReport;

  /// Moderation statuses
  bool isBanned;
  bool isDeleted;
  bool isApproved;

  /// Social capabilities
  bool isLiked;
  bool isThanked;
  bool canLike;
  bool canThank;

  /// Whether the current user has bookmarked this post (Discourse:
  /// `bookmarked:true`). XF-flavored impls leave false.
  bool bookmarked;

  /// Whether this post is the accepted answer for its topic (Discourse:
  /// `accepted_answer:true`, requires the discourse-solved plugin).
  bool isSolution;

  /// Whether the current viewer can mark this post as the accepted
  /// answer so the UI can render an "Accept this answer" action.
  bool canAcceptAnswer;

  /// Emoji reactions on this post (Discourse: `discourse-reactions`
  /// plugin). Empty when the plugin isn't installed or no one has
  /// reacted.
  List<FCPostReaction> reactions;

  /// Q&A vote state on this post (Discourse: `discourse-post-voting`
  /// plugin). Null on posts in topics without voting - the UI uses
  /// null to hide the vote arrows entirely.
  FCPostVote? vote;

  /// Revision count of this post (Discourse: `version`). A value
  /// greater than 1 means the post has been edited. Null when the
  /// backend doesn't expose revision counts.
  int? editVersion;

  /// Whether this post is a wiki post that any sufficiently trusted
  /// user may edit (Discourse: `wiki`). Backends without a wiki
  /// concept leave false.
  bool isWiki;

  FCPost(
      {required this.id,
      required this.title,
      required this.content,
      required this.topicId,
      this.topicTitle,
      required this.authorId,
      required this.authorName,
      this.authorUserType,
      this.timestamp,
      this.authorIconUrl,
      this.isAuthorOnline = false,
      this.canEdit = false,
      this.allowSmilies = true,
      this.attachments = const [],
      this.inlineAttachments = const [],
      this.thanksInfo = const [],
      this.likesInfo = const [],
      this.likeCount = 0,
      this.postNumber,
      // Moderation capabilities
      this.canBan = false,
      this.canDelete = false,
      this.canApprove = false,
      this.canMove = false,
      this.canReport = false,
      // Moderation statuses
      this.isBanned = false,
      this.isDeleted = false,
      this.isApproved = true,

      /// Social capabilities
      this.isLiked = false,
      this.isThanked = false,
      this.canLike = false,
      this.canThank = false,
      this.bookmarked = false,
      this.isSolution = false,
      this.canAcceptAnswer = false,
      this.reactions = const [],
      this.vote,
      this.editVersion,
      this.isWiki = false});
}
