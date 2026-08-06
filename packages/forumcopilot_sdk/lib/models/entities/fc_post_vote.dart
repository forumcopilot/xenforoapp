import 'package:dart_mappable/dart_mappable.dart';

part 'fc_post_vote.mapper.dart';

/// Per-post voting state for Q&A-style topics (Discourse:
/// `discourse-post-voting` plugin). Null on regular topics or when the
/// plugin isn't installed.
///
/// Phase 5.36 — promoted out of `discourse_core` (was
/// `DiscoursePostVote`) so post-voting is a first-class SDK concept,
/// per CLAUDE.md's "extend the SDK interface to express the Discourse
/// concept directly" rule.
@MappableClass()
class FCPostVote with FCPostVoteMappable {
  /// Net score (upvotes − downvotes).
  int voteCount;

  /// True when the post has at least one vote. Used by the renderer
  /// to suppress the score chip when nobody's voted yet.
  bool hasVotes;

  /// Viewer's vote direction: `'up'`, `'down'`, or null when they
  /// haven't voted.
  String? viewerDirection;

  FCPostVote({
    this.voteCount = 0,
    this.hasVotes = false,
    this.viewerDirection,
  });

  bool get viewerVotedUp => viewerDirection == 'up';
  bool get viewerVotedDown => viewerDirection == 'down';
  bool get viewerVoted => viewerDirection != null;
}
