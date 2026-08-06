import 'package:dart_mappable/dart_mappable.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post_vote.dart';
import 'package:forumcopilot_sdk/models/entities/fc_post_reaction.dart';
import 'package:forumcopilot_sdk/models/results/fc_base_result.dart';

part 'fc_reaction_result.mapper.dart';

/// Result of toggling an emoji reaction on a post (Discourse:
/// `PUT /discourse-reactions/posts/{id}/custom-reactions/{value}/toggle.json`).
/// On success [reactions] carries the post's updated reaction list so
/// the UI can swap state in-place without a thread refetch.
@MappableClass()
class FCToggleReactionResult extends FCBaseResult
    with FCToggleReactionResultMappable {
  List<FCPostReaction> reactions;

  FCToggleReactionResult({
    required bool result,
    String? resultText,
    this.reactions = const [],
  }) : super(result: result, resultText: resultText);
}

/// Result of fetching the forum's enabled reaction set (Discourse:
/// `GET /discourse-reactions/custom-reactions`). Returns the configured
/// shortcodes in display order. Implementations may fall back to a
/// built-in default when the plugin isn't installed so the picker can
/// degrade gracefully.
@MappableClass()
class FCAvailableReactionsResult extends FCBaseResult
    with FCAvailableReactionsResultMappable {
  List<String> reactions;

  FCAvailableReactionsResult({
    required bool result,
    String? resultText,
    this.reactions = const [],
  }) : super(result: result, resultText: resultText);
}

/// Result of casting or removing a Q&A post vote (Discourse:
/// `POST /vote.json` / `DELETE /vote.json?post_id=`). [vote] is the
/// post-state the caller should reconcile to — null means the viewer
/// no longer has a vote on this post.
@MappableClass()
class FCPostVoteResult extends FCBaseResult with FCPostVoteResultMappable {
  FCPostVote? vote;

  FCPostVoteResult({
    required bool result,
    String? resultText,
    this.vote,
  }) : super(result: result, resultText: resultText);
}
