import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:forumcopilot_flutter/views/widgets/message_compose_page.dart';
import 'package:forumcopilot_flutter/utils/attachment_constraints_utils.dart';
import 'package:forumcopilot_flutter/utils/attachment_validation_utils.dart';
import 'package:forumcopilot_flutter/utils/image_optimization_utils.dart';
import 'package:forumcopilot_flutter/utils/file_utils.dart';
import 'package:image_picker/image_picker.dart';

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
  final List<String> _attachmentIds = [];
  String? _groupId;
  List<FCAttachment>? _existingAttachments;

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
    _contentController.dispose();
    super.dispose();
  }

  Future<bool> _handleSubmit(String title, String content) async {
    try {
      final result = await SiteProxyFactory.getPrivateConversationProxy().saveRawMessageAsync(
        widget.messageId,
        content,
        attachmentIds: _attachmentIds.isNotEmpty ? _attachmentIds : null,
        groupId: _groupId,
      );

      if (!result.result) {
        final errorMessage = result.resultText?.trim();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage ?? 'Failed to save message'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return false;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.messageUpdatedSuccessfully ?? 'Message updated successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Dismiss keyboard before navigating back
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop(true); // Return true to indicate success
      }

      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)?.error ?? 'Error'}: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    }
  }

  Future<bool> _handleRemoveExistingAttachment(String attachmentId) async {
    try {
      var attachmentProxy = SiteProxyFactory.getAttachmentProxy();

      // For conversation messages, we need to call the API to remove the attachment
      // For existing attachments (already attached to message), omit groupId
      // Use messageId as postId to identify which message the attachment belongs to
      var removeResult = await attachmentProxy.removeAttachmentAsync(
        attachmentId,
        "", // forumId not needed for conversation messages
        "", // groupId should be omitted for existing/associated attachments
        widget.messageId, // Use messageId as postId to identify the message
      );

      if (removeResult.result) {
        setState(() {
          _attachmentIds.remove(attachmentId);
          // Also remove from existing attachments list so UI updates immediately
          if (_existingAttachments != null) {
            _existingAttachments = _existingAttachments!.where((a) => a.id != attachmentId).toList();
          }
        });
        return true;
      } else {
        // Provide a more descriptive error message
        final errorMessage = removeResult.resultText?.trim();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage ?? 'Failed to remove attachment. Please check your permissions.'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return false;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.failedToRemoveAttachment(e.toString()) ?? 'Failed to remove attachment: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    }
  }

  Future<String?> _handleFileUpload(XFile file) async {
    try {
      // Get constraints from SiteContext
      final siteContext = getCurrentSiteContext();
      final constraints = getAttachmentConstraintsFromSiteContext(siteContext);

      // Check attachment count limit
      if (!canAddMoreAttachments(_attachmentIds.length, constraints)) {
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
          currentAttachmentCount: _attachmentIds.length,
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
          } catch (e) {
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

      var attachmentProxy = SiteProxyFactory.getAttachmentProxy();
      // Use existing groupId if available, otherwise use empty string
      var groupId = _groupId ?? "";

      final fileBytes = await fileToUpload.readAsBytes();

      // For conversation messages, use "pm" type and conversationId
      var uploadAttachmentResult = await attachmentProxy.uploadAttachmentAsync(
        "pm",
        widget.conversationId,
        groupId,
        fileToUpload.name,
        fileBytes,
      );

      if (uploadAttachmentResult.result) {
        // Store attachment ID and group ID
        if (uploadAttachmentResult.attachmentId != null && uploadAttachmentResult.attachmentId!.isNotEmpty) {
          setState(() {
            _attachmentIds.add(uploadAttachmentResult.attachmentId!);
            // Update groupId if provided (should be consistent across all uploads)
            if (uploadAttachmentResult.groupId != null && uploadAttachmentResult.groupId!.isNotEmpty) {
              _groupId = uploadAttachmentResult.groupId;
            }
          });
        } else {
          return null;
        }

        return uploadAttachmentResult.attachmentId;
      } else {
        throw Exception(uploadAttachmentResult.resultText ?? 'Failed to upload file');
      }
    } catch (e) {
      throw Exception('Failed to upload file: ${e.toString()}');
    }
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
                  Text(AppLocalizations.of(context)?.failedToLoadMessage(snapshot.error.toString()) ?? 'Failed to load message: \n${snapshot.error}'),
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
                  Text(AppLocalizations.of(context)!.cannotEditMessage(snapshot.data?.resultText ?? AppLocalizations.of(context)!.anErrorOccurred)),
                ],
              ),
            ),
          );
        }

        // Only create compose page when data is ready
        // Use a stable key to preserve MessageComposePage state across rebuilds
        return MessageComposePage(
          key: const ValueKey('edit_conversation_message_compose'),
          siteContext: widget.siteContext,
          title: AppLocalizations.of(context)?.editMessage ?? 'Edit Message',
          showTitleField: false, // Messages don't have titles
          requireTitle: false,
          contentController: _contentController,
          contentHint: 'Edit your message...',
          autoFocusContent: false, // Don't auto-focus when editing
          onSubmit: _handleSubmit,
          onFileUpload: (widget.siteContext.loginDataOutput?.canUploadConversationAttachment ?? false) ? _handleFileUpload : null,
          existingAttachments: snapshot.data?.attachments ?? _existingAttachments,
          onRemoveExistingAttachment: _handleRemoveExistingAttachment,
          submitIcon: Icons.save_rounded,
          onRemoveAttachment: (attachmentId) {
            // For newly uploaded attachments, remove from list
            if (_attachmentIds.contains(attachmentId)) {
              setState(() {
                _attachmentIds.remove(attachmentId);
              });
            }
            return Future.value(true);
          },
        );
      },
    );
  }
}
