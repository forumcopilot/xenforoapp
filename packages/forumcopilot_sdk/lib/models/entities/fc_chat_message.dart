import 'package:dart_mappable/dart_mappable.dart';

part 'fc_chat_message.mapper.dart';

/// One chat message (Discourse: from `/chat/api/channels/:id/messages`).
///
/// Phase 5.39 — promoted out of `discourse_core` (was
/// `DiscourseChatMessage`). Author avatar URL is pre-resolved against
/// the forum base URL by the proxy, so consumers don't need to
/// expand templates themselves.
@MappableClass()
class FCChatMessage with FCChatMessageMappable {
  int id;
  int channelId;
  int? threadId;

  /// Raw markdown the user typed.
  String message;

  /// Server-rendered HTML (with mentions, oneboxes, emoji expanded).
  /// Equivalent to a post's `cooked` field.
  String cooked;

  String? excerpt;

  int authorId;
  String authorUsername;
  String? authorName;

  /// Pre-resolved absolute avatar URL (the proxy expands any
  /// `{size}` template against the forum base URL before construct).
  String? authorAvatarUrl;

  DateTime createdAt;

  bool edited;
  bool deleted;

  /// True when the message is currently being LLM-streamed (token by
  /// token); UI should debounce updates and not allow edits.
  bool streaming;

  /// Emoji reactions on this message. Empty when the backend doesn't
  /// support message reactions or no one has reacted.
  List<FCChatMessageReaction> reactions;

  FCChatMessage({
    required this.id,
    required this.channelId,
    this.threadId,
    required this.message,
    required this.cooked,
    this.excerpt,
    required this.authorId,
    required this.authorUsername,
    this.authorName,
    this.authorAvatarUrl,
    required this.createdAt,
    this.edited = false,
    this.deleted = false,
    this.streaming = false,
    this.reactions = const [],
  });
}

/// One aggregated emoji reaction on a chat message: the emoji, how
/// many users applied it, and whether the current viewer is among
/// them.
@MappableClass()
class FCChatMessageReaction with FCChatMessageReactionMappable {
  /// Emoji identifier — typically the shortcode without colons
  /// (e.g. "heart", "tada"). The toggle API consumes the same
  /// identifier.
  String emoji;

  /// Number of users who reacted with this emoji.
  int count;

  /// True when the current viewer has applied this reaction.
  bool reacted;

  /// Usernames of (some of) the users who reacted, for tooltip-style
  /// display. May be a truncated subset on backends that cap the list.
  List<String> usernames;

  FCChatMessageReaction({
    required this.emoji,
    required this.count,
    this.reacted = false,
    this.usernames = const [],
  });
}
