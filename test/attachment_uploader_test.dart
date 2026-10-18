import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:forumcopilot_flutter/services/attachment_uploader.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';
import 'package:forumcopilot_sdk/models/domain/site.dart';
import 'package:forumcopilot_sdk/models/results/fc_attachment_result.dart';
import 'package:image_picker/image_picker.dart';

/// Records uploads and removals; each upload answers with the next scripted
/// reply (or waits for a completer).
class _Proxy implements IFCAttachmentProxy {
  final uploads = <(String type, String id, String groupId, String name)>[];
  final removals = <(String attachmentId, String forumId, String groupId)>[];
  final replies = <FutureOr<FCAttachmentUploadResult>>[];

  @override
  Future<FCAttachmentUploadResult> uploadAttachmentAsync(
      String type, String id, String groupId, String attachmentName, Uint8List attachmentBytes) async {
    uploads.add((type, id, groupId, attachmentName));
    return replies.removeAt(0);
  }

  @override
  Future<FCAttachmentRemoveResult> removeAttachmentAsync(String attachmentId, String forumId, String groupId, String postId) async {
    removals.add((attachmentId, forumId, groupId));
    return FCAttachmentRemoveResult(result: true);
  }

  @override
  Future<FCAttachmentUploadResult> uploadAvatarAsync(String imageExtension, Uint8List attachmentBytes) =>
      throw UnimplementedError();
}

FCAttachmentUploadResult _ok(String id, {String hash = 'h1'}) =>
    FCAttachmentUploadResult(result: true, attachmentId: id, groupId: hash);

void main() {
  final site = SiteContext(
    siteType: 'xenforo',
    site: const Site(name: 'A', url: 'https://a.example', description: '', siteType: 'xenforo'),
  );
  XFile file(String name) => XFile.fromData(Uint8List.fromList([1, 2, 3]), name: name, path: name);

  test('uploads go to the forum and target it was opened for, sharing one hash', () async {
    final proxy = _Proxy()..replies.addAll([_ok('10'), _ok('11')]);
    final uploader = AttachmentUploader(siteContext: site, kind: AttachmentKind.post, targetId: '7', proxy: proxy);
    expect(await uploader.upload(file('a.png')), '10');
    expect(await uploader.upload(file('b.png')), '11');
    expect(proxy.uploads.map((u) => (u.$1, u.$2, u.$3)), [('post', '7', ''), ('post', '7', 'h1')]);
    expect(uploader.attachmentIds, ['10', '11']);
    expect(uploader.groupId, 'h1');
  });

  test('direct messages upload as pm, and an edit keeps its hash', () async {
    final proxy = _Proxy()..replies.add(_ok('20', hash: 'existing'));
    final uploader = AttachmentUploader(
        siteContext: site, kind: AttachmentKind.message, targetId: '99', groupId: 'existing', proxy: proxy);
    await uploader.upload(file('a.pdf'));
    expect(proxy.uploads.single, ('pm', '99', 'existing', 'a.pdf'));
  });

  test("a refused upload says the forum's reason and keeps nothing", () async {
    final proxy = _Proxy()..replies.add(FCAttachmentUploadResult(result: false, resultText: 'Too big'));
    final uploader = AttachmentUploader(siteContext: site, kind: AttachmentKind.post, targetId: '7', proxy: proxy);
    await expectLater(
      uploader.upload(file('a.png')),
      throwsA(isA<AttachmentUploadException>().having((e) => e.message, 'message', 'Too big')),
    );
    expect(uploader.attachmentIds, isEmpty);
  });

  test('an unreachable forum is a network error, not the transport text', () async {
    final proxy = _Proxy()
      ..replies.add(FCAttachmentUploadResult(
          result: false, resultText: 'Error uploading attachment: DioException [connection error]: Connection refused'));
    final uploader = AttachmentUploader(siteContext: site, kind: AttachmentKind.post, targetId: '7', proxy: proxy);
    await expectLater(
      uploader.upload(file('a.png')),
      throwsA(isA<AttachmentUploadException>().having((e) => e.message, 'message', isNot(contains('Dio')))),
    );
  });

  test('removing one removes it from the forum too', () async {
    final proxy = _Proxy()..replies.add(_ok('10'));
    final uploader = AttachmentUploader(siteContext: site, kind: AttachmentKind.post, targetId: '7', proxy: proxy);
    await uploader.upload(file('a.png'));
    await uploader.remove('10');
    expect(uploader.attachmentIds, isEmpty);
    expect(proxy.removals.single, ('10', '7', 'h1'));
  });

  test('closed without posting: uploads are removed, and one still under way when it lands', () async {
    final late = Completer<FCAttachmentUploadResult>();
    final proxy = _Proxy()..replies.addAll([_ok('10'), late.future]);
    final uploader = AttachmentUploader(siteContext: site, kind: AttachmentKind.message, proxy: proxy);
    await uploader.upload(file('a.png'));
    final pending = uploader.upload(file('b.png'));
    await Future<void>.delayed(Duration.zero);

    uploader.close(sent: false);
    expect(proxy.removals.map((r) => r.$1), ['10']);

    late.complete(_ok('11'));
    await expectLater(pending, throwsA(isA<AttachmentUploadCancelled>()));
    await Future<void>.delayed(Duration.zero);
    expect(proxy.removals.map((r) => r.$1), ['10', '11']);
    expect(uploader.attachmentIds, isEmpty);
    await expectLater(uploader.upload(file('c.png')), throwsA(isA<AttachmentUploadCancelled>()));
  });

  test('closed after posting: nothing is removed', () async {
    final proxy = _Proxy()..replies.add(_ok('10'));
    final uploader = AttachmentUploader(siteContext: site, kind: AttachmentKind.post, targetId: '7', proxy: proxy);
    await uploader.upload(file('a.png'));
    uploader.close(sent: true);
    expect(proxy.removals, isEmpty);
  });
}
