import 'package:dart_mappable/dart_mappable.dart';

part 'fc_poll.mapper.dart';

/// A single poll option/response. API: id, text, voteCount?, viewerVotedFor.
@MappableClass()
class FCPollResponse with FCPollResponseMappable {
  /// Response (choice) ID. Use in votePoll as responseIds.
  String id;

  /// Choice text.
  String text;

  /// Number of votes for this choice. Null when user cannot view results.
  int? voteCount;

  /// Whether the current user selected this option.
  bool viewerVotedFor;

  FCPollResponse({
    required this.id,
    required this.text,
    this.voteCount,
    this.viewerVotedFor = false,
  });
}

/// Poll attached to a thread. API: pollId, topicId, question, responses, voterCount?, maxVotes, etc.
@MappableClass()
class FCPoll with FCPollMappable {
  /// Poll ID.
  String pollId;

  /// Thread (topic) ID.
  String topicId;

  /// Poll question text.
  String question;

  /// List of choices.
  List<FCPollResponse> responses;

  /// Total number of voters. Null when user cannot see results.
  int? voterCount;

  /// Max options a user can select. 0 = unlimited.
  int maxVotes;

  /// Whether the user can change their vote.
  bool changeVote;

  /// Whether votes are public.
  bool publicVotes;

  /// Whether results are visible before voting.
  bool viewResultsUnvoted;

  /// Close time in milliseconds (Unix timestamp × 1000). 0 if no close time.
  int closeDate;

  /// Whether the poll is closed.
  bool isClosed;

  /// Whether the current user can vote.
  bool canVote;

  /// Whether the current user has already voted.
  bool hasVoted;

  /// Whether the current user can see vote counts.
  bool canViewResults;

  FCPoll({
    required this.pollId,
    required this.topicId,
    required this.question,
    this.responses = const [],
    this.voterCount,
    this.maxVotes = 1,
    this.changeVote = false,
    this.publicVotes = false,
    this.viewResultsUnvoted = false,
    this.closeDate = 0,
    this.isClosed = false,
    this.canVote = false,
    this.hasVoted = false,
    this.canViewResults = false,
  });
}
