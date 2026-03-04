import 'package:dart_mappable/dart_mappable.dart';

part 'poll.mapper.dart';

/// XenForo poll data model based on official API documentation
@MappableClass()
class XenForoPoll with XenForoPollMappable {
  /// True if the viewing user can vote in this poll
  final bool? canVote;

  /// True if the viewing user has voted in this poll
  final bool? hasVoted;

  /// List of responses with text, vote count (if visible) and whether selected
  final List<Map<String, dynamic>>? responses;

  /// Poll ID
  final int pollId;

  /// Question
  final String? question;

  /// Number of voters
  final int? voterCount;

  /// True if votes are public
  final bool? publicVotes;

  /// Maximum number of votes allowed
  final int? maxVotes;

  /// Poll close date (Unix timestamp)
  final int? closeDate;

  /// True if a voter can change their vote
  final bool? changeVote;

  /// True if results can be viewed without voting
  final bool? viewResultsUnvoted;

  const XenForoPoll({
    this.canVote,
    this.hasVoted,
    this.responses,
    required this.pollId,
    this.question,
    this.voterCount,
    this.publicVotes,
    this.maxVotes,
    this.closeDate,
    this.changeVote,
    this.viewResultsUnvoted,
  });

  factory XenForoPoll.fromJson(Map<String, dynamic> json) {
    return XenForoPoll(
      canVote: json['can_vote'],
      hasVoted: json['has_voted'],
      responses: json['responses'] != null ? (json['responses'] as List).map((response) => Map<String, dynamic>.from(response)).toList() : null,
      pollId: json['poll_id'] ?? 0,
      question: json['question'],
      voterCount: json['voter_count'],
      publicVotes: json['public_votes'],
      maxVotes: json['max_votes'],
      closeDate: json['close_date'],
      changeVote: json['change_vote'],
      viewResultsUnvoted: json['view_results_unvoted'],
    );
  }

  // Convenience getters for backward compatibility
  String get id => pollId.toString();
  String get questionText => question ?? '';
  List<Map<String, dynamic>> get responseList => responses ?? [];
}
