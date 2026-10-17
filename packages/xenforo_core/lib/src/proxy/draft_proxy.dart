import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_draft_proxy.dart';
import 'package:forumcopilot_sdk/models/entities/fc_draft.dart';
import 'package:forumcopilot_sdk/models/results/fc_draft_result.dart';

import '../base_xenforo_proxy.dart';
import '../network/xenforo_client.dart';
import '../xf_debug.dart';

/// XenForo drafts, in the forum's own draft store (the add-on's getDraft /
/// saveDraft / deleteDraft / getDrafts), so the web editor and the app share
/// them. Keys are XenForo's: `thread-{id}`, `forum-{id}`,
/// `conversation-reply-{id}`, `conversation`. In [FCDraft.data], `reply` is
/// the message (BBCode), and `title`, `prefixId` and `recipients` are the
/// extras a new thread or message keeps. XenForo has no sequence numbers;
/// [FCDraft.sequence] is always 0 and the `sequence` arguments are ignored.
class XenForoDraftProxy extends BaseXenForoProxy implements IFCDraftProxy {
  XenForoDraftProxy(SiteContext context, {XenForoClient? client}) : super(context, client: client);

  /// The draft key for a reply in thread [topicId].
  static String replyKey(String topicId) => 'thread-$topicId';

  /// The draft key for a new thread in forum [forumId].
  static String newThreadKey(String forumId) => 'forum-$forumId';

  /// The draft key for a reply in direct message [conversationId].
  static String conversationReplyKey(String conversationId) => 'conversation-reply-$conversationId';

  @override
  Future<FCSaveDraftResult> saveDraftAsync({
    required String draftKey,
    required Map<String, dynamic> data,
    int sequence = 0,
  }) async {
    try {
      final response = await callPluginApi('saveDraft', {
        'draftKey': draftKey,
        'message': (data['reply'] ?? data['message'] ?? '').toString(),
        'extra': {
          if (data['title'] != null) 'title': data['title'].toString(),
          if (data['prefixId'] != null) 'prefix_id': data['prefixId'].toString(),
          if (data['recipients'] != null) 'recipients': data['recipients'].toString(),
        },
      });
      return FCSaveDraftResult(
        result: response['result'] == true,
        resultText: response['resultText']?.toString(),
        sequence: 0,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_DRAFT] saveDraft error: $e');
      return FCSaveDraftResult(result: false, resultText: e.toString());
    }
  }

  @override
  Future<FCLoadDraftResult> loadDraftAsync(String draftKey) async {
    try {
      final response = await callPluginApi('getDraft', {'draftKey': draftKey});
      return FCLoadDraftResult(
        result: response['result'] == true,
        resultText: response['resultText']?.toString(),
        draft: _draft(response['draft']),
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_DRAFT] getDraft error: $e');
      return FCLoadDraftResult(result: false, resultText: e.toString());
    }
  }

  @override
  Future<FCDeleteDraftResult> deleteDraftAsync(String draftKey, {int sequence = 0}) async {
    try {
      final response = await callPluginApi('deleteDraft', {'draftKey': draftKey});
      return FCDeleteDraftResult(result: response['result'] == true, resultText: response['resultText']?.toString());
    } catch (e) {
      xfDebug('❌ [XENFORO_DRAFT] deleteDraft error: $e');
      return FCDeleteDraftResult(result: false, resultText: e.toString());
    }
  }

  @override
  Future<FCDraftListResult> getMyDraftsAsync({int page = 0}) async {
    try {
      final response = await callPluginApi('getDrafts', {'page': page});
      final items = <FCDraft>[
        for (final raw in (response['drafts'] is List ? response['drafts'] as List : const []))
          if (_draft(raw) case final FCDraft draft) draft,
      ];
      return FCDraftListResult(
        result: response['result'] == true,
        resultText: response['resultText']?.toString(),
        total: response['total'] is int ? response['total'] as int : items.length,
        items: items,
      );
    } catch (e) {
      xfDebug('❌ [XENFORO_DRAFT] getDrafts error: $e');
      return FCDraftListResult(result: false, resultText: e.toString(), total: 0, items: const []);
    }
  }

  static FCDraft? _draft(Object? raw) {
    if (raw is! Map) return null;
    final key = raw['draftKey']?.toString();
    if (key == null || key.isEmpty) return null;
    final extra = raw['extra'] is Map ? raw['extra'] as Map : const {};
    final topicId = key.startsWith('thread-') ? int.tryParse(key.substring('thread-'.length)) : null;
    final updated = raw['lastUpdate'] is int ? raw['lastUpdate'] as int : null;
    return FCDraft(
      draftKey: key,
      sequence: 0,
      data: {
        'reply': (raw['message'] ?? '').toString(),
        if (extra['title'] != null) 'title': extra['title'].toString(),
        if (extra['prefix_id'] != null) 'prefixId': extra['prefix_id'].toString(),
        if (extra['recipients'] != null) 'recipients': extra['recipients'].toString(),
      },
      topicId: topicId,
      title: extra['title']?.toString(),
      updatedAt: updated == null ? null : DateTime.fromMillisecondsSinceEpoch(updated * 1000),
    );
  }
}
