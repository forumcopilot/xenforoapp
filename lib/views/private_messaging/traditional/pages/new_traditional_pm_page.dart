import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forumcopilot_flutter/utils/file_picker_utils.dart';
import 'package:forumcopilot_flutter/utils/attachment_constraints_utils.dart';
import 'package:forumcopilot_flutter/utils/attachment_validation_utils.dart';
import 'package:forumcopilot_flutter/utils/image_optimization_utils.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_flutter/views/user_search_page.dart';
import '../../../../theme/design_tokens.dart';
import 'dart:io';
import '../../../../utils/file_utils.dart';

class NewTraditionalPMPage extends StatefulWidget {
  final SiteContext siteContext;
  final String? initialRecipient;
  final String? subject;
  final String? initialRecipientIconUrl;

  const NewTraditionalPMPage({
    super.key,
    required this.siteContext,
    this.initialRecipient,
    this.subject,
    this.initialRecipientIconUrl,
  });

  @override
  State<NewTraditionalPMPage> createState() => _NewTraditionalPMPageState();
}

class _NewTraditionalPMPageState extends State<NewTraditionalPMPage> {
  final TextEditingController _titleController = TextEditingController();
  final List<String> _toRecipients = [];
  final Map<String, String?> _recipientIcons = {}; // Store icon URLs for recipients
  String? _groupId;
  final TextEditingController _messageController = TextEditingController();
  final List<XFile> _attachments = [];
  final List<String> _attachmentIds = []; // Track uploaded attachment IDs
  final Map<String, bool> _uploadingFiles = {}; // Track which files are currently uploading (key: file path)
  bool _isSubmitting = false;
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialRecipient != null) {
      _toRecipients.add(widget.initialRecipient!);
      if (widget.initialRecipientIconUrl != null) {
        _recipientIcons[widget.initialRecipient!] = widget.initialRecipientIconUrl;
      }
    }
    if (widget.subject != null) {
      _titleController.text = widget.subject!;
    }
  }

  Future<bool> _handleSubmit(String title, String content) async {
    try {
      if (_toRecipients.isEmpty) {
        throw Exception('Please add at least one recipient');
      }
      if (title.trim().isEmpty) {
        throw Exception('Please enter a subject');
      }
      if (content.trim().isEmpty) {
        throw Exception('Please enter a message');
      }
      final proxy = SiteProxyFactory.getPrivateMessageProxy();
      final result = await proxy.createMessageAsync(
        _toRecipients,
        title,
        content,
        null, // action (null for new message)
        null, // pmId (null for new message)
        _attachmentIds.isNotEmpty ? _attachmentIds : null, // attachment IDs
        _groupId, // group ID
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
          throw Exception('Failed to send message');
        }
      }
    } catch (e) {
      // Only wrap if it's not already a clean server error message
      final message = e.toString();
      if (message.startsWith('Exception: ') && !message.contains('Failed to send message')) {
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
              content: Text(AppLocalizations.of(context)?.failedToSendMessage(e.toString()) ?? 'Failed to send message: ${e.toString()}'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
            ),
          );
        }
        return false;
      }
    }
  }

  Future<String?> _handleFileUpload(XFile file) async {
    // Check if this specific file is already uploading
    if (_uploadingFiles[file.path] == true) {
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

    try {
      var attachmentProxy = SiteProxyFactory.getAttachmentProxy();
      var groupId = _groupId ?? "";

      var uploadAttachmentResult = await attachmentProxy.uploadAttachmentAsync(
        "pm", // type
        "", // message_id - empty for new messages, should be set for replies
        groupId,
        fileToUpload.name,
        await fileToUpload.readAsBytes(),
      );

      if (uploadAttachmentResult.result) {
        // Update groupId
        if (uploadAttachmentResult.groupId != null && uploadAttachmentResult.groupId!.isNotEmpty) {
          _groupId = uploadAttachmentResult.groupId;
        }
        return uploadAttachmentResult.attachmentId;
      } else {
        throw Exception(uploadAttachmentResult.resultText);
      }
    } catch (e) {
      throw Exception('Failed to upload file: ${e.toString()}');
    }
  }

  Widget _buildRecipientChip(String username, List<String> recipients, Function(String) onRemove) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        avatar: UserAvatar(
          username: username,
          iconUrl: _recipientIcons[username],
          radius: 12,
        ),
        label: Text(username),
        deleteIcon: Icon(
          Icons.close,
          size: 18,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onDeleted: () => onRemove(username),
      ),
    );
  }

  Widget _buildRecipientField(String label, List<String> recipients, Function(String) onAdd, Function(String) onRemove) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                ...recipients.map((username) => _buildRecipientChip(username, recipients, onRemove)),
                ActionChip(
                  avatar: Icon(
                    Icons.add,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  label: Text(
                    AppLocalizations.of(context)?.add ?? 'Add',
                    style: TextStyle(
                      color: colorScheme.primary,
                    ),
                  ),
                  backgroundColor: colorScheme.primaryContainer.withOpacity(0.3),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserSearchPage(
                          siteContext: widget.siteContext,
                          onUserSelected: (username, iconUrl) {
                            // This callback is no longer used since we're returning data instead
                          },
                          selectedUsers: [..._toRecipients],
                        ),
                      ),
                    );

                    // Handle the returned user data
                    if (result != null && result is Map<String, dynamic>) {
                      final username = result['username'] as String;
                      final iconUrl = result['iconUrl'] as String?;

                      if (!recipients.contains(username)) {
                        onAdd(username);
                        _recipientIcons[username] = iconUrl;
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.newMessage ?? 'New Message', style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w500)),
        backgroundColor: colorScheme.surface,
        elevation: 3,
        shadowColor: colorScheme.shadow.withOpacity(0.3),
        surfaceTintColor: colorScheme.surfaceTint,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isSubmitting
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onSurface,
                    ),
                  )
                : Icon(Icons.send_rounded, color: colorScheme.onSurface),
            onPressed: _isSubmitting
                ? null
                : () async {
                    setState(() {
                      _isSubmitting = true;
                    });
                    try {
                      final success = await _handleSubmit(_titleController.text, _messageController.text);
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)?.messageSentSuccessfully ?? 'Message sent successfully'),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        // Dismiss keyboard before navigating back
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).pop(true);
                      }
                    } finally {
                      setState(() {
                        _isSubmitting = false;
                      });
                    }
                  },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 'attach_file') {
                _handleFileAttachment();
              } else if (value == 'attach_image') {
                _handleImageAttachment();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'attach_file',
                child: Row(
                  children: [
                    Icon(Icons.attach_file, color: colorScheme.onSurface),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)?.attachFile ?? 'Attach File', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'attach_image',
                child: Row(
                  children: [
                    Icon(Icons.image, color: colorScheme.onSurface),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)?.uploadImage ?? 'Attach Image', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: DesignTokens.paddingL,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRecipientField('To', _toRecipients, (username) => setState(() => _toRecipients.add(username)), (username) => setState(() => _toRecipients.remove(username))),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.subject ?? 'Subject',
                  hintText: AppLocalizations.of(context)?.enterSubject ?? 'Enter subject',
                  labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  floatingLabelStyle: TextStyle(color: colorScheme.primary),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.error,
                      width: 2,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _messageController,
                focusNode: _messageFocusNode,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.message ?? 'Message',
                  hintText: AppLocalizations.of(context)?.typeYourMessageHere ?? 'Type your message here',
                  labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  floatingLabelStyle: TextStyle(color: colorScheme.primary),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.error,
                      width: 2,
                    ),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 10,
                minLines: 5,
                textInputAction: TextInputAction.newline,
              ),
              if (_attachments.isNotEmpty) ...[
                SizedBox(height: DesignTokens.spacingL),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.attach_file, size: DesignTokens.iconSizeM, color: colorScheme.onSurfaceVariant),
                        SizedBox(width: DesignTokens.spacingS),
                        Text(
                          'Attachments',
                          style: textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: DesignTokens.fontWeightMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: DesignTokens.spacingS),
                    Container(
                      padding: DesignTokens.paddingS,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._attachments.asMap().entries.map((entry) {
                            final index = entry.key;
                            final attachment = entry.value;
                            final attachmentId = index < _attachmentIds.length ? _attachmentIds[index] : null;
                            final isUploading = _uploadingFiles[attachment.path] ?? false;
                            final isImage = isImageFile(attachment.name);
                            return Column(
                              children: [
                                ListTile(
                                  leading: isImage
                                      ? Stack(
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                                child: Image.file(
                                                  File(attachment.path),
                                                  width: 48,
                                                  height: 48,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Icon(
                                                      getFileIcon(attachment.name),
                                                      size: 24,
                                                      color: colorScheme.onSurfaceVariant,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            if (attachmentId != null)
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: colorScheme.surface,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.check_circle,
                                                    color: colorScheme.primary,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        )
                                      : Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: getFileTypeColor(attachment.name),
                                            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                          ),
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Icon(
                                                  getFileIcon(attachment.name),
                                                  size: 24,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              if (attachmentId != null)
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: colorScheme.surface,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.check_circle,
                                                      color: colorScheme.primary,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                  title: Text(attachment.name),
                                  subtitle: isUploading
                                      ? Text(AppLocalizations.of(context)?.uploading ?? 'Uploading...', style: textTheme.bodySmall?.copyWith(color: colorScheme.primary))
                                      : attachmentId != null
                                          ? Text(AppLocalizations.of(context)?.uploaded ?? 'Uploaded', style: textTheme.bodySmall?.copyWith(color: colorScheme.primary))
                                          : null,
                                  trailing: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: isUploading
                                        ? null
                                        : () => setState(() {
                                              _attachments.removeAt(index);
                                              _uploadingFiles.remove(attachment.path);
                                              if (index < _attachmentIds.length) {
                                                _attachmentIds.removeAt(index);
                                              }
                                            }),
                                  ),
                                ),
                                if (isUploading)
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingM),
                                    child: LinearProgressIndicator(
                                      minHeight: 2,
                                      backgroundColor: colorScheme.surfaceVariant,
                                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                                    ),
                                  ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleFileAttachment() async {
    final XFile? file = await FilePickerUtils.pickFile();
    if (file != null) {
      // Hide keyboard when file is selected to focus on upload progress
      FocusScope.of(context).unfocus();
      
      // Add file to list immediately so user can see it
      setState(() {
        _attachments.add(file);
        _uploadingFiles[file.path] = true;
      });
      // Start upload in background
      try {
        final attachmentId = await _handleFileUpload(file);
        if (attachmentId != null && attachmentId.isNotEmpty) {
          setState(() {
            final fileIndex = _attachments.indexWhere((f) => f.path == file.path);
            if (fileIndex != -1) {
              while (_attachmentIds.length <= fileIndex) {
                _attachmentIds.add('');
              }
              _attachmentIds[fileIndex] = attachmentId;
            }
            _uploadingFiles.remove(file.path);
          });
        } else {
          // Remove file on failure
          setState(() {
            _attachments.removeWhere((f) => f.path == file.path);
            _uploadingFiles.remove(file.path);
          });
        }
      } catch (e) {
        // Remove file on error
        setState(() {
          _attachments.removeWhere((f) => f.path == file.path);
          _uploadingFiles.remove(file.path);
        });
        // Show error to user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)?.failedToUploadFile(e.toString()) ?? 'Failed to upload file: ${e.toString()}'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleImageAttachment() async {
    // Get constraints and check count limit before showing picker
    final siteContext = getCurrentSiteContext();
    final constraints = getAttachmentConstraintsFromSiteContext(siteContext);

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
      return;
    }

    final XFile? image = await FilePickerUtils.pickImage(imageQuality: ImageQuality.medium);
    if (image != null) {
      // Hide keyboard when image is selected to focus on upload progress
      FocusScope.of(context).unfocus();
      
      // Add file to list immediately so user can see it
      setState(() {
        _attachments.add(image);
        _uploadingFiles[image.path] = true;
      });
      // Start upload in background
      try {
        final attachmentId = await _handleFileUpload(image);
        if (attachmentId != null && attachmentId.isNotEmpty) {
          setState(() {
            final fileIndex = _attachments.indexWhere((f) => f.path == image.path);
            if (fileIndex != -1) {
              while (_attachmentIds.length <= fileIndex) {
                _attachmentIds.add('');
              }
              _attachmentIds[fileIndex] = attachmentId;
            }
            _uploadingFiles.remove(image.path);
          });
        } else {
          // Remove file on failure
          setState(() {
            _attachments.removeWhere((f) => f.path == image.path);
            _uploadingFiles.remove(image.path);
          });
        }
      } catch (e) {
        // Remove file on error
        setState(() {
          _attachments.removeWhere((f) => f.path == image.path);
          _uploadingFiles.remove(image.path);
        });
        // Show error to user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)?.failedToUploadImage(e.toString()) ?? 'Failed to upload image: ${e.toString()}'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}
