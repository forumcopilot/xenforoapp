import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/interfaces/interfaces.dart';
import 'package:forumcopilot_sdk/models/entities/fc_attachment_data.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/attachment_constraints_utils.dart';
import '../utils/attachment_validation_utils.dart';
import '../utils/file_utils.dart';
import '../utils/image_optimization_utils.dart';
import '../utils/l10n_now.dart';
import '../utils/network_utils.dart';

/// What the attachments are for.
enum AttachmentKind {
  /// A topic, reply or post edit; the target is the forum (node) id.
  post,

  /// A direct message; the target is the conversation id, or empty for a
  /// new conversation.
  message,
}

/// A file that was not uploaded, with a message for the reader.
class AttachmentUploadException implements Exception {
  const AttachmentUploadException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// The composer closed while the file was uploading; it was not kept.
class AttachmentUploadCancelled implements Exception {
  const AttachmentUploadCancelled();
}

/// Uploads one composer's attachments, to the forum it was opened in.
///
/// It holds that forum's [siteContext] and [targetId] from the start and
/// talks to that forum's attachment proxy, so a forum opened meanwhile (a
/// push, another tab) never receives them; pages used to look the proxy up
/// from whichever forum was current at upload time. When the composer closes
/// without posting ([close] with `sent: false`) its uploads are removed from
/// the forum, and an upload still under way is removed when it lands.
///
/// It replaces a copy of this logic in each composer page.
class AttachmentUploader {
  AttachmentUploader({
    required this.siteContext,
    required this.kind,
    this.targetId = '',
    String? groupId,
    IFCAttachmentProxy? proxy,
  })  : groupId = (groupId?.isEmpty ?? true) ? null : groupId,
        _proxy = proxy ?? SiteProxyFactory.attachmentProxyFor(siteContext);

  final SiteContext siteContext;
  final AttachmentKind kind;

  /// The forum id for posts; the conversation id ('' for a new one) for
  /// direct messages.
  final String targetId;

  /// The forum's id for this set of uploads (XenForo's attachment hash), from
  /// the first upload on; an edit starts with the post's own.
  String? groupId;

  final IFCAttachmentProxy _proxy;
  final List<String> _uploaded = [];
  bool _closed = false;
  bool _sent = false;

  /// The ids uploaded here and not removed, in order.
  List<String> get attachmentIds => List.unmodifiable(_uploaded);

  bool get isClosed => _closed;

  /// The forum's limits for this member (count, size, types), or null when
  /// it gives none.
  FCAttachmentConstraints? get constraints => getAttachmentConstraintsFromSiteContext(siteContext);

  /// Checks [file] against the forum's limits, with [currentCount] files
  /// already attached, and shrinks an image that is too big. Throws
  /// [AttachmentUploadException] with the reason when it cannot be sent.
  Future<XFile> prepare(XFile file, {required int currentCount}) async {
    final limits = constraints;
    if (limits == null) return file;
    if (!canAddMoreAttachments(currentCount, limits)) {
      throw AttachmentUploadException(l10nNow().maximumAttachmentsAllowed(limits.count ?? 0));
    }
    final isImage = isImageFile(file.name);
    final validation = await validateFile(file, limits, isImage, currentAttachmentCount: currentCount);
    if (!validation.isValid) {
      throw AttachmentUploadException(validation.errorMessage ?? l10nNow().failedToUploadFileTryAgain);
    }
    if (isImage && validation.needsOptimization) {
      try {
        return await optimizeImage(file, limits);
      } catch (e) {
        final message = e.toString();
        throw AttachmentUploadException(message.startsWith('Exception: ') ? message.substring(11) : message);
      }
    }
    return file;
  }

  /// Uploads [file] (already [prepare]d) and returns its attachment id.
  /// Throws [AttachmentUploadException] with the forum's reason when it was
  /// not uploaded, and [AttachmentUploadCancelled] when the composer closed
  /// meanwhile.
  Future<String> upload(XFile file) async {
    if (_closed) throw const AttachmentUploadCancelled();
    final bytes = await file.readAsBytes();
    if (_closed) throw const AttachmentUploadCancelled();
    final result = await _proxy.uploadAttachmentAsync(_type, targetId, groupId ?? '', file.name, bytes);
    final id = result.attachmentId;
    if (!result.result || id == null || id.isEmpty) {
      final reason = result.resultText?.trim();
      throw AttachmentUploadException(
        NetworkUtils.isUnreachable(reason)
            ? l10nNow().errorNetwork
            : (reason != null && reason.isNotEmpty ? reason : l10nNow().failedToUploadFileTryAgain),
      );
    }
    final hash = result.groupId;
    if (hash != null && hash.isNotEmpty) groupId = hash;
    if (_closed) {
      // Landed after the composer closed: not part of anything.
      if (!_sent) unawaited(_removeOnForum(id));
      throw const AttachmentUploadCancelled();
    }
    _uploaded.add(id);
    return id;
  }

  /// Removes [attachmentId], uploaded here, from the forum too. Failures are
  /// only logged: the forum drops unused uploads itself after a while.
  Future<void> remove(String attachmentId) async {
    _uploaded.remove(attachmentId);
    await _removeOnForum(attachmentId);
  }

  /// Removes [attachmentId], already part of post or message [contentId]
  /// (an edit), from the forum. Throws [AttachmentUploadException] with the
  /// forum's reason when it refuses.
  Future<void> removeExisting(String attachmentId, {required String contentId}) async {
    final result = await _proxy.removeAttachmentAsync(
        attachmentId, kind == AttachmentKind.post ? targetId : '', groupId ?? '', contentId);
    if (!result.result) {
      final reason = result.resultText?.trim();
      throw AttachmentUploadException(reason != null && reason.isNotEmpty ? reason : l10nNow().failedToRemoveAttachment(''));
    }
  }

  /// The composer is closing: [sent] when what it posted carries the
  /// uploads. Otherwise they are removed from the forum, and any upload
  /// still under way is removed when it lands.
  void close({required bool sent}) {
    if (_closed) return;
    _closed = true;
    _sent = sent;
    if (sent) return;
    for (final id in List.of(_uploaded)) {
      unawaited(_removeOnForum(id));
    }
    _uploaded.clear();
  }

  String get _type => kind == AttachmentKind.post ? 'post' : 'pm';

  Future<void> _removeOnForum(String attachmentId) async {
    final hash = groupId;
    if (hash == null) return;
    try {
      await _proxy.removeAttachmentAsync(attachmentId, kind == AttachmentKind.post ? targetId : '', hash, '');
    } catch (e) {
      debugPrint('AttachmentUploader: removing $attachmentId failed: $e');
    }
  }
}
