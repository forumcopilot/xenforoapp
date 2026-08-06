import 'package:dart_mappable/dart_mappable.dart';

part 'fc_post_reaction.mapper.dart';

/// A single emoji reaction on a post (Discourse: one entry from
/// `reactions: []`, populated by the `discourse-reactions` plugin).
///
/// Named FCPostReaction rather than FCReaction because the SDK already
/// has an FCReaction (XenForo reaction-type descriptor backed by
/// ReactionRegistry); this class models a per-post emoji reaction.
@MappableClass()
class FCPostReaction with FCPostReactionMappable {
  /// Reaction id — for stock Discourse plugin reactions this is the
  /// emoji shortcode (e.g. "heart", "tada", "rocket"). The toggle
  /// API consumes the same identifier.
  String id;

  /// Reaction type — almost always `emoji`.
  String type;

  /// Number of users who reacted with this emoji.
  int count;

  /// True when the current viewer has applied this reaction. Discourse
  /// only allows one reaction per user per post.
  bool viewerReacted;

  /// True when the viewer can still remove this reaction (rate-limit
  /// window: typically 1 minute after applying on stock Discourse).
  bool canUndo;

  FCPostReaction({
    required this.id,
    this.type = 'emoji',
    required this.count,
    this.viewerReacted = false,
    this.canUndo = false,
  });
}
