import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/services/server_draft.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/i_fc_draft_proxy.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_sdk/models/entities/fc_draft.dart';
import 'package:forumcopilot_sdk/models/results/fc_draft_result.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart' show FCLoginResult, FCUser;

class _Drafts implements IFCDraftProxy {
  final saves = <Map<String, dynamic>>[];
  final deletes = <String>[];
  FCDraft? stored;

  @override
  Future<FCLoadDraftResult> loadDraftAsync(String draftKey) async => FCLoadDraftResult(result: true, draft: stored);

  @override
  Future<FCSaveDraftResult> saveDraftAsync({required String draftKey, required Map<String, dynamic> data, int sequence = 0}) async {
    saves.add(data);
    return FCSaveDraftResult(result: true);
  }

  @override
  Future<FCDeleteDraftResult> deleteDraftAsync(String draftKey, {int sequence = 0}) async {
    deletes.add(draftKey);
    return FCDeleteDraftResult(result: true);
  }

  @override
  Future<FCDraftListResult> getMyDraftsAsync({int page = 0}) async => FCDraftListResult(result: true, total: 0, items: []);
}

/// The forum's copy of a draft: read when the composer opens, saved when
/// typing pauses and on leaving, removed once posted.
void main() {
  SiteContext site({bool signedIn = true}) => SiteContext(
        siteType: 'xenforo',
        site: const Site(name: 'A', url: 'https://a.example', description: '', siteType: 'xenforo'),
        loginDataOutput: signedIn ? FCLoginResult(result: true, resultText: '', user: FCUser(id: '2', username: 'alice')) : null,
      )..initializeAuth();

  test("reads the forum's draft", () async {
    final drafts = _Drafts()..stored = FCDraft(draftKey: 'thread-4', sequence: 0, data: {'reply': 'From the web'});
    final draft = await ServerDraft(siteContext: site(), key: 'thread-4', proxy: drafts).load();
    expect(draft!.reply, 'From the web');
  });

  test('saves once typing pauses, not on every key', () {
    fakeAsync((async) {
      final drafts = _Drafts();
      final draft = ServerDraft(siteContext: site(), key: 'thread-4', proxy: drafts);
      draft.schedule('H');
      draft.schedule('He');
      draft.schedule('Hello');
      async.elapse(const Duration(seconds: 4));
      expect(drafts.saves, isEmpty);
      async.elapse(const Duration(seconds: 2));
      expect(drafts.saves, [
        {'reply': 'Hello'}
      ]);
    });
  });

  test('an unchanged draft is not saved again; a title goes with it', () async {
    final drafts = _Drafts()..stored = FCDraft(draftKey: 'thread-4', sequence: 0, data: {'reply': 'Same'});
    final draft = ServerDraft(siteContext: site(), key: 'thread-4', proxy: drafts);
    await draft.load();
    await draft.saveNow('Same');
    expect(drafts.saves, isEmpty);
    await draft.saveNow('Body', title: ' A title ');
    expect(drafts.saves.single, {'reply': 'Body', 'title': 'A title'});
  });

  test('posted: the draft is removed and a pending save dropped', () {
    fakeAsync((async) {
      final drafts = _Drafts();
      final draft = ServerDraft(siteContext: site(), key: 'thread-4', proxy: drafts);
      draft.schedule('Hello');
      draft.discard();
      async.elapse(const Duration(seconds: 10));
      expect(drafts.saves, isEmpty);
      expect(drafts.deletes, ['thread-4']);
    });
  });

  test('signed out: nothing on the forum', () async {
    final drafts = _Drafts()..stored = FCDraft(draftKey: 'thread-4', sequence: 0, data: {'reply': 'x'});
    final draft = ServerDraft(siteContext: site(signedIn: false), key: 'thread-4', proxy: drafts);
    expect(await draft.load(), isNull);
    await draft.saveNow('typed');
    expect(drafts.saves, isEmpty);
  });
}
