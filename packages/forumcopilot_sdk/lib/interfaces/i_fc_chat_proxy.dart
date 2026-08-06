import '../models/results/fc_chat_result.dart';

/// Chat operations exposed to the app (Discourse: `discourse-chat`
/// plugin). XF-shaped backends without a chat concept should
/// implement this as `result:false` stubs.
///
/// Phase 5.39 — promoted out of `DiscourseChatProxy.forCurrentSite()`
/// sidecar into a proper IFC proxy, per CLAUDE.md's "extend the SDK
/// interface to express the Discourse concept directly" rule.
///
/// Discourse endpoints used by the reference implementation:
///   * `GET    /chat/api/me/channels`                — list user's channels
///   * `GET    /chat/api/channels/:id`               — single channel
///   * `GET    /chat/api/channels/:id/messages`      — page of messages
///   * `POST   /chat/:channel_id`                    — send a message
///   * `PUT    /chat/api/channels/:cid/messages/:mid` — edit a message
///   * `DELETE /chat/api/channels/:cid/messages/:mid` — delete a message
///   * `PUT    /chat/api/channels/:cid/read/:mid`    — mark read
abstract class IFCChatProxy {
  Future<FCChatChannelListResult> getMyChannelsAsync();

  Future<FCChatChannelResult> getChannelAsync(int channelId);

  /// Fetch a page of messages. [targetMessageId] anchors the page;
  /// [direction] is `'past'` (older messages above the anchor) or
  /// `'future'` (newer below).
  Future<FCChatMessageListResult> getMessagesAsync(
    int channelId, {
    int pageSize = 30,
    int? targetMessageId,
    String direction = 'past',
  });

  /// Poll for messages newer than [lastMessageId]. Used by the
  /// channel page's tick loop to keep up with realtime updates
  /// without WebSocket plumbing.
  Future<FCChatMessageListResult> pollNewerAsync(
    int channelId, {
    required int lastMessageId,
    int pageSize = 50,
  });

  Future<FCChatMessageResult> sendMessageAsync(int channelId, String message);

  Future<FCChatActionResult> editMessageAsync(
    int channelId,
    int messageId,
    String message,
  );

  Future<FCChatActionResult> deleteMessageAsync(int channelId, int messageId);

  /// Mark the channel read up to [messageId] (or the latest if null).
  Future<FCChatActionResult> markChannelReadAsync(
    int channelId, {
    int? messageId,
  });
}
