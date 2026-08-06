import 'package:dart_mappable/dart_mappable.dart';

part 'fc_chat_channel.mapper.dart';

/// A single chat channel (Discourse: from `/chat/api/me/channels` or
/// `/chat/api/channels/:id`).
///
/// Phase 5.39 — promoted out of `discourse_core` (was
/// `DiscourseChatChannel`) so chat is a first-class SDK concept.
@MappableClass()
class FCChatChannel with FCChatChannelMappable {
  int id;
  String title;
  String? description;
  String? slug;

  /// Channel type: 'Category', 'DirectMessage', or 'TopicChat'.
  String chatableType;

  int unreadCount;
  int mentionCount;

  /// Most-recent message id the user has read.
  int? lastReadMessageId;

  bool isFollowing;
  bool canJoin;

  /// Status: 'open', 'closed', 'archived', 'read_only'. UI greys out
  /// the composer when not 'open'.
  String status;

  /// Last message timestamp, used for sorting the channel list.
  DateTime? lastMessageAt;

  FCChatChannel({
    required this.id,
    required this.title,
    this.description,
    this.slug,
    this.chatableType = 'Category',
    this.unreadCount = 0,
    this.mentionCount = 0,
    this.lastReadMessageId,
    this.isFollowing = false,
    this.canJoin = false,
    this.status = 'open',
    this.lastMessageAt,
  });

  bool get isOpen => status == 'open';
  bool get isReadOnly => status == 'read_only';
  bool get isArchived => status == 'archived';
  bool get isClosed => status == 'closed';
}
