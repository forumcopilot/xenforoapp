import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_draft_proxy.dart';
import 'package:forumcopilot_sdk/models/entities/fc_draft.dart';

/// A composer's draft kept on the forum (XenForo's own drafts), so it is in
/// the forum's editor on the web, and on another phone, as well as here. It
/// sits beside the copy kept on this device, which stays the one restored
/// first.
///
/// Best effort: a forum without drafts, a signed-out visitor or a failed
/// call only means no server copy; nothing is shown.
class ServerDraft {
  ServerDraft({required this.siteContext, required this.key, IFCDraftProxy? proxy}) : _proxy = proxy;

  final SiteContext siteContext;

  /// XenForo's key: thread-{id}, forum-{id}, conversation-reply-{id}.
  final String key;

  IFCDraftProxy? _proxy;
  bool _unsupported = false;
  Timer? _timer;
  String? _lastSaved;

  /// How long typing has to pause before the draft is saved to the forum,
  /// as the web editor does.
  static const Duration saveDelay = Duration(seconds: 5);

  IFCDraftProxy? get _drafts {
    if (_unsupported || !siteContext.isLoggedIn) return null;
    try {
      return _proxy ??= SiteProxyFactory.draftProxyFor(siteContext);
    } catch (_) {
      _unsupported = true;
      return null;
    }
  }

  /// The draft on the forum, or null.
  Future<FCDraft?> load() async {
    final drafts = _drafts;
    if (drafts == null) return null;
    try {
      final result = await drafts.loadDraftAsync(key);
      final draft = result.result ? result.draft : null;
      if (draft != null) _lastSaved = _signature(draft.reply, draft.topicTitle);
      return draft != null && (draft.reply.trim().isNotEmpty || (draft.topicTitle ?? '').isNotEmpty) ? draft : null;
    } catch (e) {
      debugPrint('ServerDraft: loading $key failed: $e');
      return null;
    }
  }

  /// Saves [message] (and [title]) once typing pauses for [saveDelay].
  void schedule(String message, {String? title}) {
    _timer?.cancel();
    _timer = Timer(saveDelay, () => saveNow(message, title: title));
  }

  /// Saves now; an empty message and title remove the draft. Skipped when
  /// nothing changed since the last save or load.
  Future<void> saveNow(String message, {String? title}) async {
    _timer?.cancel();
    final signature = _signature(message, title);
    if (signature == _lastSaved) return;
    final drafts = _drafts;
    if (drafts == null) return;
    _lastSaved = signature;
    try {
      await drafts.saveDraftAsync(
        draftKey: key,
        data: {'reply': message, if (title != null && title.trim().isNotEmpty) 'title': title.trim()},
      );
    } catch (e) {
      debugPrint('ServerDraft: saving $key failed: $e');
    }
  }

  /// The message was posted: no draft left on the forum.
  Future<void> discard() async {
    _timer?.cancel();
    _lastSaved = _signature('', null);
    final drafts = _drafts;
    if (drafts == null) return;
    try {
      await drafts.deleteDraftAsync(key);
    } catch (e) {
      debugPrint('ServerDraft: deleting $key failed: $e');
    }
  }

  void cancel() => _timer?.cancel();

  static String _signature(String message, String? title) => '${(title ?? '').trim()}\u0000${message.trim()}';
}
