import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_conversation_result.dart';
import 'package:forumcopilot_flutter/views/widgets/message_compose_page.dart';
import 'package:flutter/foundation.dart';
import '../../../../utils/snackbar_helper.dart';
import '../../../../services/attachment_uploader.dart';
import 'package:xenforo_core/xenforo_core.dart' show XenForoDraftProxy;

class ReplyConversationPage extends StatefulWidget {
  final SiteContext siteContext;
  final String conversationId;
  final String subject;
  final String? quotedMessageId;
  final bool? canUpload; // Whether user can upload attachments
  /// The conversation's quick-reply text, edited here in place (a plain
  /// reply only).
  final TextEditingController? contentController;

  const ReplyConversationPage({
    super.key,
    required this.siteContext,
    required this.conversationId,
    required this.subject,
    this.quotedMessageId,
    this.canUpload,
    this.contentController,
  });

  @override
  State<ReplyConversationPage> createState() => _ReplyConversationPageState();
}

class _ReplyConversationPageState extends State<ReplyConversationPage> {
  // The reply's attachments, in this conversation of this forum.
  late final AttachmentUploader _uploader = AttachmentUploader(
    siteContext: widget.siteContext,
    kind: AttachmentKind.message,
    targetId: widget.conversationId,
  );
  bool _sent = false;
  Future<FCQuoteConversationResult>? _quoteFuture;

  @override
  void initState() {
    super.initState();
    // Cache the future so it's only called once
    if (widget.quotedMessageId != null) {
      _quoteFuture = SiteProxyFactory.getPrivateConversationProxy().getQuoteConversationAsync(
        widget.conversationId,
        widget.quotedMessageId!,
      );
    }
  }

  @override
  void dispose() {
    // Closed without sending: the uploads are removed from the forum.
    _uploader.close(sent: _sent);
    super.dispose();
  }

  Future<bool> _handleSubmit(String title, String content) async {
    try {
      if (content.trim().isEmpty) {
        throw Exception('Please enter a message');
      }

      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
      final result = await conversationProxy.replyConversationAsync(
        widget.conversationId,
        content,
        _uploader.attachmentIds.isNotEmpty ? _uploader.attachmentIds : null,
        _uploader.groupId,
      );

      if (result.result) {
        _sent = true;
        return true;
      } else {
        // Server returned result=false with a message - throw it directly without wrapping
        // This allows the error handler to show the server's message cleanly
        final errorMessage = result.resultText?.trim();
        if (errorMessage != null && errorMessage.isNotEmpty) {
          throw Exception(errorMessage);
        } else {
          throw Exception('Failed to send reply');
        }
      }
    } catch (e) {
      // Only wrap if it's not already a clean server error message
      final message = e.toString();
      if (message.startsWith('Exception: ') && !message.contains('Failed to send reply')) {
        // This is already a clean server message, show it directly
        if (mounted) {
          String errorMessage = message;
          if (errorMessage.startsWith('Exception: ')) {
            errorMessage = errorMessage.substring(11);
          }
          SnackbarHelper.showError(context, errorMessage);
        }
        return false;
      } else {
        // Wrap other exceptions
        if (mounted) {
          SnackbarHelper.showError(context, AppLocalizations.of(context).failedToSendReply(e.toString()));
        }
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quotedMessageId != null) {
      // Fetch quote content from API (using cached future)
      return FutureBuilder<FCQuoteConversationResult>(
        future: _quoteFuture,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final hasError = snapshot.hasError;
          final hasData = snapshot.hasData && snapshot.data != null;
          // Only set quoteContent if we have data, otherwise use null to avoid overwriting user input
          final quoteContent = hasData && snapshot.data!.quoteText != null && snapshot.data!.quoteText!.isNotEmpty ? snapshot.data!.quoteText : null;

          // Create the compose widget once and reuse it across all states
          // Use a stable key based on quotedMessageId to preserve widget state (including attachments)
          Widget compose = MessageComposePage(
            key: ValueKey('reply_with_quote_${widget.quotedMessageId}'),
            siteContext: widget.siteContext,
            title: AppLocalizations.of(context).reply,
            onSubmit: _handleSubmit,
            onFileUpload:
                (widget.canUpload ?? false) ? _handleFileUpload : null,
            onRemoveAttachment: _handleRemoveAttachment,
            showTitleField: false,
            initialContent: quoteContent,
            contentHint: AppLocalizations.of(context).writeYourReply,
            topicTitle: widget.subject,
            onSuccess: (success) {
              // Return true to indicate reply was successful
              return true;
            },
          );

          if (isLoading) {
            return Stack(
              children: [
                compose,
                ModalBarrier(dismissible: false, color: Colors.black.withValues(alpha: 0.2)),
                const Center(child: CircularProgressIndicator()),
              ],
            );
          } else if (hasError) {
            return Stack(
              children: [
                compose,
                ModalBarrier(dismissible: false, color: Colors.black.withValues(alpha: 0.2)),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context).failedToLoadQuote(snapshot.error.toString()),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return compose;
          }
        },
      );
    } else {
      return MessageComposePage(
        siteContext: widget.siteContext,
        title: AppLocalizations.of(context).reply,
        onSubmit: _handleSubmit,
        onFileUpload:
            (widget.canUpload ?? false) ? _handleFileUpload : null,
        onRemoveAttachment: _handleRemoveAttachment,
        showTitleField: false,
        contentController: widget.contentController,
        contentHint: AppLocalizations.of(context).writeYourReply,
        topicTitle: widget.subject,
        // A plain reply keeps a draft on this device, per forum and
        // conversation (a reply with a quote opens with the quote instead).
        draftKey: 'dm_reply_draft:${widget.siteContext.site.pluginUrl}:${widget.conversationId}',
        // And on the forum, where the web editor shows it.
        serverDraftKey: XenForoDraftProxy.conversationReplyKey(widget.conversationId),
        onSuccess: (success) {
          // Return true to indicate reply was successful
          return true;
        },
      );
    }
  }

  Future<void> _handleRemoveAttachment(String attachmentId) => _uploader.remove(attachmentId);

  /// The composer has checked and shrunk the file.
  Future<String?> _handleFileUpload(XFile file) => _uploader.upload(file);
}
