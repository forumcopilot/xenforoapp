import 'package:dart_mappable/dart_mappable.dart';

part 'fc_like.mapper.dart';

/// FCLike (Forum Consolidated Like) represents a like/reaction on a post
@MappableClass()
class FCLike with FCLikeMappable {
  /// User ID who liked/reacted to the post
  String userId;

  /// Username who liked/reacted to the post
  String username;

  /// Avatar URL of the user who liked/reacted to the post
  String avatarUrl;

  /// Timestamp when the like/reaction was given
  DateTime? timestamp;

  /// Reaction ID (1=Like, 2=Love, 3=Haha, 4=Wow, 5=Sad, 6=Angry, etc.)
  int? reactionId;

  /// Human-readable reaction name (e.g., "Like", "Love", "Haha")
  String? reactionName;

  /// The actual emoji character (👍, 😍, 😂, etc.) or null if using a custom image
  String? reactionEmoji;

  /// Full URL to custom reaction icon/image, or null if using emoji
  String? reactionIconUrl;

  FCLike({
    required this.userId,
    required this.username,
    required this.avatarUrl,
    this.timestamp,
    this.reactionId,
    this.reactionName,
    this.reactionEmoji,
    this.reactionIconUrl,
  });
}
