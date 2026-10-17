import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:forumcopilot_flutter/views/widgets/message_compose_page.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/snackbar_helper.dart';
import '../../../../services/attachment_uploader.dart';

class EditConversationMessagePage extends StatefulWidget {
  final SiteContext siteContext;
  final String messageId;
  final String conversationId;

  const EditConversationMessagePage({
    super.key,
    required this.siteContext,
    required this.messageId,
    required this.conversationId,
  });

  @override
  State<EditConversationMessagePage> createState() => _EditConversationMessagePageState();
}

class _EditConversationMessagePageState extends State<EditConversationMessagePage> {
  // The message's own attachments that stay; new ones are the uploader's.
  final List<String> _attachmentIds = [];
  String? _groupId;
  List<FCAttachment>? _existingAttachments;
  // Bound to this conversation of this forum once the message has loaded.
  AttachmentUploader? _uploader;
  bool _sent = false;

  // Controllers created once and reused
  late final TextEditingController _contentController;
  bool _controllersInitialized = false;

  // Cache the future to prevent FutureBuilder from recreating it on every build
  late final Future<FCRawMessageResult> _rawMessageFuture;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty values
    _contentController = TextEditingController();
    // Cache the future so it doesn't recreate on every build
    _rawMessageFuture = SiteProxyFactory.getPrivateConversationProxy().getRawMessageAsync(widget.messageId);
  }

  @override
  void dispose() {
    // Closed without saving: new uploads are removed from the forum.
    _uploader?.close(sent: _sent);
    _contentController.dispose();
    super.dispose();
  }

  Future<bool> _handleSubmit(String title, String content) async {
    try {
      final result = await SiteProxyFactory.getPrivateConversationProxy().saveRawMessageAsync(
        widget.messageId,
        content,
        attachmentIds: [..._attachmentIds, ...?_uploader?.attachmentIds],
        groupId: _uploader?.groupId ?? _groupId,
      );

      if (!result.result) {
        final errorMessage = result.resultText?.trim();
        if (mounted) {
          SnackbarHelper.showError(context, errorMessage ?? 'Failed to save message');
        }
        return false;
      }

      _sent = true;
      if (mounted) {
        SnackbarHelper.showSuccess(context, AppLocalizations.of(context).messageUpdatedSuccessfully);
        // Dismiss keyboard before navigating back
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop(true); // Return true to indicate success
      }

      return true;
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showError(context, '${AppLocalizations.of(context).error}: ${e.toString()}');
      }
      return false;
    }
  }

  Future<bool> _handleRemoveExistingAttachment(String attachmentId) async {
    final uploader = _uploader;
    if (uploader == null) return false;
    try {
      await uploader.removeExisting(attachmentId, contentId: widget.messageId);
      if (mounted) {
        setState(() {
          _attachmentIds.remove(attachmentId);
          // Also remove from existing attachments list so UI updates immediately
          _existingAttachments = _existingAttachments?.where((a) => a.id != attachmentId).toList();
        });
      }
      return true;
    } catch (e) {
      if (mounted) SnackbarHelper.showError(context, e.toString());
      return false;
    }
  }

  /// The composer has checked and shrunk the file.
  Future<String?> _handleFileUpload(XFile file) {
    final uploader = _uploader;
    if (uploader == null) throw AttachmentUploadException(AppLocalizations.of(context).failedToUploadFileTryAgain);
    return uploader.upload(file);
  }

  @override
  Widget build(BuildContext context) {
    // Fetch raw message content from API
    // Use cached future to prevent FutureBuilder from recreating MessageComposePage on every build
    return FutureBuilder<FCRawMessageResult>(
      future: _rawMessageFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final hasError = snapshot.hasError;

        // Update controllers when data arrives (only once)
        if (!isLoading && !hasError && snapshot.data != null && !_controllersInitialized) {
          final data = snapshot.data!;
          _contentController.text = data.messageContent ?? '';
          _controllersInitialized = true;
        }

        // Initialize attachment data from API response
        if (!isLoading && !hasError && snapshot.data != null) {
          final data = snapshot.data!;

          // Store groupId synchronously
          if (_groupId == null && data.attachments != null && data.attachments!.isNotEmpty) {
            // Try to get groupId from first attachment
            if (data.attachments!.first.groupId != null && data.attachments!.first.groupId!.isNotEmpty) {
              _groupId = data.attachments!.first.groupId;
            }
          }

          // Store existing attachments and initialize attachment IDs (only once, when data first arrives)
          if (_existingAttachments == null && data.attachments != null) {
            _existingAttachments = data.attachments;

            // Initialize attachment IDs from existing attachments
            if (data.attachments!.isNotEmpty) {
              _attachmentIds.clear();
              _attachmentIds.addAll(data.attachments!.map((a) => a.id).where((id) => id.isNotEmpty));
            }
          }
          _uploader ??= AttachmentUploader(
            siteContext: widget.siteContext,
            kind: AttachmentKind.message,
            targetId: widget.conversationId,
            groupId: _groupId,
          );
        }

        // Show loading indicator first, then compose page once data is ready
        if (isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context).failedToLoadMessage(snapshot.error.toString())),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.result) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context).cannotEditMessage(snapshot.data?.resultText ?? AppLocalizations.of(context).anErrorOccurred)),
                ],
              ),
            ),
          );
        }

        // Only create compose page when data is ready
        // Use a stable key to preserve MessageComposePage state across rebuilds
        return MessageComposePage(
          isEditing: true,
          key: const ValueKey('edit_conversation_message_compose'),
          siteContext: widget.siteContext,
          title: AppLocalizations.of(context).editMessage,
          showTitleField: false, // Messages don't have titles
          requireTitle: false,
          contentController: _contentController,
          contentHint: AppLocalizations.of(context).writeYourMessage,
          autoFocusContent: false, // Don't auto-focus when editing
          onSubmit: _handleSubmit,
          onFileUpload: (widget.siteContext.loginDataOutput?.canUploadConversationAttachment ?? false) ? _handleFileUpload : null,
          existingAttachments: snapshot.data?.attachments ?? _existingAttachments,
          onRemoveExistingAttachment: _handleRemoveExistingAttachment,
          submitIcon: Icons.save_rounded,
          onRemoveAttachment: (attachmentId) async => _uploader?.remove(attachmentId),
        );
      },
    );
  }
}
