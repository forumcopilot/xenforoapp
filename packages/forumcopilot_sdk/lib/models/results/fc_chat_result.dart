import 'package:forumcopilot_sdk/models/entities/fc_chat_channel.dart';
import 'package:forumcopilot_sdk/models/entities/fc_chat_message.dart';

/// Result of fetching the user's chat channels (Discourse:
/// `GET /chat/api/me/channels`).
///
/// Chat result types don't extend `FCBaseResult` because the chat
/// subsystem is independent of the dart_mappable round-trip surface
/// the other SDK results need (UI consumes them directly; no
/// toJson/copyWith required). They expose the same `result`/`resultText`
/// shape so callers can use them uniformly.
class FCChatChannelListResult {
  final bool result;
  final String? resultText;
  final List<FCChatChannel> channels;

  FCChatChannelListResult({
    required this.result,
    this.resultText,
    this.channels = const [],
  });
}

class FCChatChannelResult {
  final bool result;
  final String? resultText;
  final FCChatChannel? channel;

  FCChatChannelResult({
    required this.result,
    this.resultText,
    this.channel,
  });
}

class FCChatMessageListResult {
  final bool result;
  final String? resultText;
  final List<FCChatMessage> messages;

  FCChatMessageListResult({
    required this.result,
    this.resultText,
    this.messages = const [],
  });
}

class FCChatMessageResult {
  final bool result;
  final String? resultText;
  final FCChatMessage? message;

  FCChatMessageResult({
    required this.result,
    this.resultText,
    this.message,
  });
}

class FCChatActionResult {
  final bool result;
  final String? resultText;

  FCChatActionResult({
    required this.result,
    this.resultText,
  });
}
