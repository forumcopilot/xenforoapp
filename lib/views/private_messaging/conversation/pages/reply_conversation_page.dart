import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_conversation_result.dart';
import 'package:forumcopilot_flutter/views/widgets/message_compose_page.dart';
import 'package:forumcopilot_flutter/utils/attachment_constraints_utils.dart';
import 'package:forumcopilot_flutter/utils/attachment_validation_utils.dart';
import 'package:forumcopilot_flutter/utils/image_optimization_utils.dart';
import 'package:forumcopilot_flutter/utils/file_utils.dart';
import 'package:flutter/foundation.dart';

class ReplyConversationPage extends StatefulWidget {
  final SiteContext siteContext;
  final String conversationId;
  final String subject;
  final String? quotedMessageId;
  final bool? canUpload; // Whether user can upload attachments

  const ReplyConversationPage({
    super.key,
    required this.siteContext,
    required this.conversationId,
    required this.subject,
    this.quotedMessageId,
    this.canUpload,
  });

  @override
  State<ReplyConversationPage> createState() => _ReplyConversationPageState();
}

class _ReplyConversationPageState extends State<ReplyConversationPage> {
  final List<XFile> _attachments = [];
  final List<String> _attachmentIds = [];
  String? _groupId;
  bool _isUploading = false;
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

  Future<bool> _handleSubmit(String title, String content) async {
    try {
      if (content.trim().isEmpty) {
        throw Exception('Please enter a message');
      }

      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
      print('🐛 [ReplyConversationPage] Replying with attachment IDs: $_attachmentIds, groupId: $_groupId');
      final result = await conversationProxy.replyConversationAsync(
        widget.conversationId,
        content,
        _attachmentIds.isNotEmpty ? _attachmentIds : null,
        _groupId,
      );

      if (result.result) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
            ),
          );
        }
        return false;
      } else {
        // Wrap other exceptions
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)?.failedToSendReply(e.toString()) ?? 'Failed to send reply: ${e.toString()}'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
            ),
          );
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
            title: AppLocalizations.of(context)?.reply ?? 'Reply',
            onSubmit: _handleSubmit,
            onFileUpload:
                (widget.canUpload ?? false) ? _handleFileUpload : null,
            onRemoveAttachment: _handleRemoveAttachment,
            showTitleField: false,
            initialContent: quoteContent,
            contentHint: AppLocalizations.of(context)?.writeYourReply ?? 'Write your reply...',
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
                ModalBarrier(dismissible: false, color: Colors.black.withOpacity(0.2)),
                const Center(child: CircularProgressIndicator()),
              ],
            );
          } else if (hasError) {
            return Stack(
              children: [
                compose,
                ModalBarrier(dismissible: false, color: Colors.black.withOpacity(0.2)),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context)?.failedToLoadQuote(snapshot.error.toString()) ?? "Failed to load quote:\n${snapshot.error.toString()}",
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
        title: AppLocalizations.of(context)?.reply ?? 'Reply',
        onSubmit: _handleSubmit,
        onFileUpload:
            (widget.canUpload ?? false) ? _handleFileUpload : null,
        onRemoveAttachment: _handleRemoveAttachment,
        showTitleField: false,
        contentHint: AppLocalizations.of(context)?.writeYourReply ?? 'Write your reply...',
        topicTitle: widget.subject,
        onSuccess: (success) {
          // Return true to indicate reply was successful
          return true;
        },
      );
    }
  }

  Future<void> _handleRemoveAttachment(String attachmentId) async {
    // Remove the attachment ID from the list and call API to delete from server
    if (_groupId != null && _groupId!.isNotEmpty) {
      try {
        var attachmentProxy = SiteProxyFactory.getAttachmentProxy();
        await attachmentProxy.removeAttachmentAsync(
          attachmentId,
          "", // forumId is empty for conversation replies
          _groupId!, // groupId is required for temporary attachments
          "", // postId is empty for reply drafts
        );
      } catch (e) {
        // Silently handle errors
        debugPrint('⚠️ [REPLY_CONVERSATION] Error removing attachment: $e');
      }
    }

    // Remove from local list
    if (_attachmentIds.contains(attachmentId)) {
      setState(() {
        _attachmentIds.remove(attachmentId);
        // Also remove the corresponding file from _attachments
        _attachments.removeWhere((file) {
          // We can't directly match by attachmentId, so we'll remove by index if we track it
          // For now, just remove from IDs list - the file mapping is handled by MessageComposePage
          return false;
        });
      });
      debugPrint('✅ [REPLY_CONVERSATION] Removed attachmentId: $attachmentId');
      debugPrint('✅ [REPLY_CONVERSATION] Current attachmentIds: $_attachmentIds');
    }
  }

  Future<String?> _handleFileUpload(XFile file) async {
    debugPrint('🔍 [REPLY_CONVERSATION] _handleFileUpload called');
    debugPrint('🔍 [REPLY_CONVERSATION] File details:');
    debugPrint('   - file.path: "${file.path}"');
    debugPrint('   - file.name: "${file.name}"');
    debugPrint('   - conversationId: "${widget.conversationId}"');

    if (_isUploading) {
      debugPrint('⚠️ [REPLY_CONVERSATION] Already uploading, returning');
      return null;
    }

    // Get constraints from SiteContext
    final siteContext = getCurrentSiteContext();
    final constraints = getAttachmentConstraintsFromSiteContext(siteContext);

    // Check attachment count limit
    if (!canAddMoreAttachments(_attachments.length, constraints)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Maximum of ${constraints!.count} attachment(s) allowed',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            margin: const EdgeInsets.all(8),
          ),
        );
      }
      return null;
    }

    // Validate file
    XFile fileToUpload = file;
    if (constraints != null) {
      final isImage = isImageFile(file.name);
      final validation = await validateFile(
        file,
        constraints,
        isImage,
        currentAttachmentCount: _attachments.length,
      );

      if (!validation.isValid) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                validation.errorMessage ?? 'File validation failed',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              margin: const EdgeInsets.all(8),
            ),
          );
        }
        return null;
      }

      // For images that need optimization
      if (isImage && validation.needsOptimization) {
        // Optimize image
        try {
          final optimizedFile = await optimizeImage(file, constraints);
          fileToUpload = optimizedFile;
          debugPrint('🔍 [REPLY_CONVERSATION] Image optimized successfully');
        } catch (e) {
          debugPrint('❌ [REPLY_CONVERSATION] Error optimizing image: $e');
          String errorMessage = e.toString();
          if (errorMessage.startsWith('Exception: ')) {
            errorMessage = errorMessage.substring(11);
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  errorMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                margin: const EdgeInsets.all(8),
              ),
            );
          }
          return null;
        }
      }
    }

    setState(() {
      _isUploading = true;
    });

    try {
      debugPrint('🔍 [REPLY_CONVERSATION] Getting attachment proxy...');
      var attachmentProxy = SiteProxyFactory.getAttachmentProxy();
      // Use existing groupId if available, otherwise use empty string
      var groupId = _groupId ?? "";

      debugPrint('🔍 [REPLY_CONVERSATION] Reading file bytes...');
      final fileBytes = await fileToUpload.readAsBytes();
      debugPrint('🔍 [REPLY_CONVERSATION] File bytes read: ${fileBytes.length} bytes');

      debugPrint('🔍 [REPLY_CONVERSATION] Calling uploadAttachmentAsync with:');
      debugPrint('   - type: "pm"');
      debugPrint('   - id: "" (empty for reply drafts, attachments associated via groupId)');
      debugPrint('   - groupId: "$groupId"');
      debugPrint('   - attachmentName: "${fileToUpload.name}"');
      debugPrint('   - bytes length: ${fileBytes.length}');

      var uploadAttachmentResult = await attachmentProxy.uploadAttachmentAsync(
        "pm", // type for private messages/conversations
        "", // empty string for reply drafts (attachments associated via groupId when reply is saved)
        groupId,
        fileToUpload.name,
        fileBytes,
      );

      debugPrint('🔍 [REPLY_CONVERSATION] Upload result:');
      debugPrint('   - result: ${uploadAttachmentResult.result}');
      debugPrint('   - resultText: "${uploadAttachmentResult.resultText}"');
      debugPrint('   - attachmentId: "${uploadAttachmentResult.attachmentId}"');
      debugPrint('   - groupId: "${uploadAttachmentResult.groupId}"');

      if (uploadAttachmentResult.result) {
        debugPrint('✅ [REPLY_CONVERSATION] File upload successful');

        // Store attachment ID and group ID, and add file to local list
        if (uploadAttachmentResult.attachmentId != null && uploadAttachmentResult.attachmentId!.isNotEmpty) {
          setState(() {
            _attachmentIds.add(uploadAttachmentResult.attachmentId!);
            _attachments.add(file);
            // Update groupId if provided (should be consistent across all uploads)
            if (uploadAttachmentResult.groupId != null && uploadAttachmentResult.groupId!.isNotEmpty) {
              _groupId = uploadAttachmentResult.groupId;
            }
          });
          debugPrint('✅ [REPLY_CONVERSATION] Stored attachmentId: ${uploadAttachmentResult.attachmentId}');
          debugPrint('✅ [REPLY_CONVERSATION] Current attachmentIds: $_attachmentIds');
          debugPrint('✅ [REPLY_CONVERSATION] Current groupId: "$_groupId"');
          return uploadAttachmentResult.attachmentId;
        } else {
          debugPrint('⚠️ [REPLY_CONVERSATION] Upload succeeded but attachmentId is null or empty');
          setState(() {
            _attachments.add(file); // Still add to UI even if no ID
          });
          return null;
        }
      } else {
        debugPrint('❌ [REPLY_CONVERSATION] File upload failed: ${uploadAttachmentResult.resultText}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(uploadAttachmentResult.resultText ?? AppLocalizations.of(context)?.failedToUploadFile('') ?? 'Failed to upload file'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [REPLY_CONVERSATION] Exception in _handleFileUpload: $e');
      debugPrint('❌ [REPLY_CONVERSATION] Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.failedToUploadFile(e.toString()) ?? 'Failed to upload file: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      return null;
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
