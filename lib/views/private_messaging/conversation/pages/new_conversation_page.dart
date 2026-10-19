import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forumcopilot_flutter/utils/file_picker_utils.dart';
import 'package:forumcopilot_flutter/utils/attachment_validation_utils.dart';
import 'package:forumcopilot_flutter/views/user_search_page.dart';
import 'package:forumcopilot_flutter/views/widgets/discard_changes_scope.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'conversation_page.dart';
import '../../../../theme/design_tokens.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../../../utils/file_utils.dart';
import '../../../../utils/snackbar_helper.dart';
import '../../../../utils/app_navigation.dart';
import '../../../../services/attachment_uploader.dart';

class NewConversationPage extends StatefulWidget {
  final SiteContext siteContext;
  final String? initialRecipient;
  final String? initialRecipientIconUrl;

  const NewConversationPage({
    super.key,
    required this.siteContext,
    this.initialRecipient,
    this.initialRecipientIconUrl,
  });

  @override
  State<NewConversationPage> createState() => _NewConversationPageState();
}

class _NewConversationPageState extends State<NewConversationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final List<String> _toRecipients = [];
  final Map<String, String?> _recipientIcons = {}; // Store icon URLs for recipients
  final List<XFile> _attachments = [];
  final Map<String, bool> _uploadingFiles = {}; // Track which files are currently uploading (key: file path)
  // Attachment ids by the picked file's path.
  final Map<String, String> _attachmentIdByPath = {};
  // The attachments, sent to this forum whatever forum is opened meanwhile.
  late final AttachmentUploader _uploader = AttachmentUploader(
    siteContext: widget.siteContext,
    kind: AttachmentKind.message,
    targetId: '',
  );
  bool _sent = false;
  bool _isSubmitting = false;
  final FocusNode _messageFocusNode = FocusNode();
  String? _createdConversationId; // Store created conversation ID
  String? _createdConversationTitle; // Store created conversation title
  bool _canUpload = false; // Whether user can upload attachments
  bool _openInvite = false; // Whether any participant can invite others (XenForo only)
  bool _conversationLocked = false; // Whether conversation is created as closed (XenForo only)
  bool _isMessageFieldFocused = false; // Track if message field has focus

  @override
  void initState() {
    super.initState();
    if (widget.initialRecipient != null) {
      _toRecipients.add(widget.initialRecipient!);
      if (widget.initialRecipientIconUrl != null) {
        _recipientIcons[widget.initialRecipient!] = widget.initialRecipientIconUrl;
      }
    }
    _fetchCanUpload();
    // Listen to focus changes
    _messageFocusNode.addListener(() {
      setState(() {
        _isMessageFieldFocused = _messageFocusNode.hasFocus;
      });
    });
  }

  Future<void> _fetchCanUpload() async {
    try {
      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
      // Fetch minimal data (startNum=0, lastNum=0) to get the canUpload flag
      final conversationsData = await conversationProxy.getConversationsAsync(0, 0);
      debugPrint('🔍 [NEW_CONVERSATION] Fetched canUpload: ${conversationsData.canUpload}');
      if (mounted) {
        setState(() {
          _canUpload = conversationsData.canUpload;
          debugPrint('🔍 [NEW_CONVERSATION] Updated _canUpload to: $_canUpload');
        });
      }
    } catch (e) {
      debugPrint('❌ [NEW_CONVERSATION] Error fetching canUpload: $e');
      // Default to false on error
      if (mounted) {
        setState(() {
          _canUpload = false;
          debugPrint('🔍 [NEW_CONVERSATION] Set _canUpload to false due to error');
        });
      }
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

      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();

      // Create new conversation
      print('🐛 [NewConversationPage] Creating conversation with recipients: $_toRecipients, title: $title');
      print('🐛 [NewConversationPage] Attachment IDs: ${_uploader.attachmentIds}, groupId: ${_uploader.groupId}');
      final result = await conversationProxy.newConversationAsync(
        _toRecipients,
        title,
        content,
        attachmentIds: _uploader.attachmentIds.isNotEmpty ? _uploader.attachmentIds : null,
        groupId: _uploader.groupId,
        openInvite: _openInvite,
        conversationLocked: _conversationLocked,
      );

      print('🐛 [NewConversationPage] Conversation creation result: result=${result.result}, resultText=${result.resultText}, convId=${result.convId}');

      if (result.result) {
        if (result.convId.isEmpty) {
          print('⚠️  [NewConversationPage] WARNING: Conversation creation succeeded but convId is empty!');
          throw Exception('Conversation created but no conversation ID returned');
        }
        print('✅ [NewConversationPage] Conversation created successfully with ID: ${result.convId}');
        // Store the conversation ID for navigation
        _createdConversationId = result.convId;
        _createdConversationTitle = title;
        _sent = true;
        return true;
      } else {
        // Server returned result=false with a message - throw it directly without wrapping
        // This allows the error handler to show the server's message cleanly
        print('❌ [NewConversationPage] Conversation creation failed: ${result.resultText}');
        final errorMessage = result.resultText?.trim();
        if (errorMessage != null && errorMessage.isNotEmpty) {
          throw Exception(errorMessage);
        } else {
          throw Exception('Failed to create conversation');
        }
      }
    } catch (e) {
      // Only wrap if it's not already a clean server error message
      final message = e.toString();
      if (message.startsWith('Exception: ') && !message.contains('Failed to create conversation') && !message.contains('Conversation created but no conversation ID returned')) {
        // This is already a clean server message, re-throw as-is
        if (mounted) {
          // Extract the clean message from the exception
          String errorMessage = message;
          if (errorMessage.startsWith('Exception: ')) {
            errorMessage = errorMessage.substring(11);
          }
          // Capture ScaffoldMessengerState to ensure dismiss button works correctly
          SnackbarHelper.showError(context, errorMessage);
        }
        return false;
      } else {
        // Wrap other exceptions
        if (mounted) {
          // Capture ScaffoldMessengerState to ensure dismiss button works correctly
          SnackbarHelper.showError(context, AppLocalizations.of(context).failedToCreateConversation('$e'));
        }
        return false;
      }
    }
  }

  Widget _buildRecipientChip(String username, List<String> recipients, Function(String) onRemove) {
    return Padding(
      padding: EdgeInsets.only(right: DesignTokens.spacingS),
      child: Chip(
        avatar: UserAvatar(
          username: username,
          iconUrl: _recipientIcons[username],
          radius: DesignTokens.radiusM,
        ),
        label: Text(username),
        deleteIcon: Icon(
          Icons.close,
          size: DesignTokens.iconSizeSMedium,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onDeleted: () => onRemove(username),
      ),
    );
  }

  Widget _buildRecipientField(List<String> recipients, Function(String) onAdd, Function(String) onRemove) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).participantsLabel,
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: DesignTokens.fontWeightMedium,
          ),
        ),
        SizedBox(height: DesignTokens.spacingS),
        Wrap(
          spacing: DesignTokens.spacingXS,
          runSpacing: DesignTokens.spacingXS,
          children: [
            ...recipients.map((username) => _buildRecipientChip(username, recipients, onRemove)),
            ActionChip(
              avatar: Icon(
                Icons.add,
                size: DesignTokens.iconSizeSMedium,
                color: colorScheme.primary,
              ),
              label: Text(
                AppLocalizations.of(context).add,
                style: TextStyle(
                  color: colorScheme.primary,
                ),
              ),
              backgroundColor: colorScheme.primaryContainer.withValues(alpha: DesignTokens.opacityLow),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DiscardChangesScope(
      listenable: Listenable.merge([_titleController, _messageController]),
      hasChanges: _hasUnsavedChanges,
      busy: _isSubmitting,
      child: Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).newConversation,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightSemiBold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 3,
        shadowColor: colorScheme.shadow.withValues(alpha: DesignTokens.opacityLow),
        surfaceTintColor: colorScheme.surfaceTint,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
        actions: [
          IconButton(
            icon: _isSubmitting
                ? SizedBox(
                    width: DesignTokens.iconSizeL,
                    height: DesignTokens.iconSizeL,
                    child: CircularProgressIndicator(
                      strokeWidth: DesignTokens.borderWidthMedium,
                      color: colorScheme.onSurface,
                    ),
                  )
                : Icon(Icons.send_rounded, color: colorScheme.onSurface),
            tooltip: AppLocalizations.of(context).send,
            onPressed: _isSubmitting
                ? null
                : () async {
                    setState(() {
                      _isSubmitting = true;
                    });
                    try {
                      // Get the title and content from the MessageComposePage
                      final title = _titleController.text;
                      final content = _messageController.text;

                      final success = await _handleSubmit(title, content);
                      if (success && mounted) {
                        SnackbarHelper.showSuccess(context, AppLocalizations.of(context).conversationCreatedSuccessfully);

                        // Dismiss keyboard before navigating
                        FocusScope.of(context).unfocus();
                        // Navigate to the newly created conversation instead of just popping
                        if (_createdConversationId != null && _createdConversationId!.isNotEmpty) {
                          print('🐛 [NewConversationPage] Navigating to newly created conversation: $_createdConversationId');
                          // Pop the new conversation page first
                          Navigator.of(context).pop();
                          // Then navigate to the conversation page
                          AppNavigation.push(context, ConversationPage(
                                siteContext: widget.siteContext,
                                conversationId: _createdConversationId!,
                                subject: _createdConversationTitle ?? title,
                              ));
                        } else {
                          // Fallback: just pop if conversation ID is missing
                          Navigator.of(context).pop(true);
                        }
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isSubmitting = false;
                        });
                      }
                    }
                  },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: DesignTokens.paddingL,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRecipientField(
                        _toRecipients,
                        (username) => setState(() => _toRecipients.add(username)),
                        (username) => setState(() {
                          _toRecipients.remove(username);
                          _recipientIcons.remove(username);
                        }),
                      ),
                      SizedBox(height: DesignTokens.spacingL),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).subject,
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: DesignTokens.fontWeightMedium,
                            ),
                          ),
                          SizedBox(height: DesignTokens.spacingS),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context).enterSubject,
                              hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: DesignTokens.opacityLow),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                  width: DesignTokens.borderWidthMedium,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                borderSide: BorderSide(
                                  color: colorScheme.error,
                                  width: DesignTokens.borderWidthMedium,
                                ),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),
                      SizedBox(height: DesignTokens.spacingL),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).message,
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: DesignTokens.fontWeightMedium,
                            ),
                          ),
                          SizedBox(height: DesignTokens.spacingS),
                          TextField(
                            controller: _messageController,
                            focusNode: _messageFocusNode,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context).writeYourMessage,
                              hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: DesignTokens.opacityLow),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                  width: DesignTokens.borderWidthMedium,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                                borderSide: BorderSide(
                                  color: colorScheme.error,
                                  width: DesignTokens.borderWidthMedium,
                                ),
                              ),
                            ),
                            minLines: 5,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                          ),
                        ],
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
                                  AppLocalizations.of(context).attachments,
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
                                color: colorScheme.surfaceContainerHighest.withValues(alpha: DesignTokens.opacityLow),
                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ..._attachments.asMap().entries.map((entry) {
                                    final attachment = entry.value;
                                    // Try to find matching attachment ID (they should be in sync)
                                    final attachmentId = _attachmentIdByPath[attachment.path];
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
                                                        color: colorScheme.surfaceContainerHighest.withValues(alpha: DesignTokens.opacityLow),
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
                                              ? Text(AppLocalizations.of(context).uploading, style: textTheme.bodySmall?.copyWith(color: colorScheme.primary))
                                              : attachmentId != null
                                                  ? Text(AppLocalizations.of(context).uploaded, style: textTheme.bodySmall?.copyWith(color: colorScheme.primary))
                                                  : null,
                                          trailing: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: isUploading
                                                ? null
                                                : () => _removeAttachmentFile(attachment),
                                          ),
                                        ),
                                        if (isUploading)
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingM),
                                            child: LinearProgressIndicator(
                                              minHeight: 2,
                                              backgroundColor: colorScheme.surfaceContainerHighest,
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
                      // XenForo-only options
                      if (widget.siteContext.siteType == 'xenforo') ...[
                        SizedBox(height: DesignTokens.spacingL),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).options,
                              style: textTheme.titleSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: DesignTokens.fontWeightMedium,
                              ),
                            ),
                            SizedBox(height: DesignTokens.spacingS),
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest.withValues(alpha: DesignTokens.opacityLow),
                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                              ),
                              child: Column(
                                children: [
                                  SwitchListTile(
                                    title: Text(
                                      AppLocalizations.of(context).openInvite,
                                      style: textTheme.titleSmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: DesignTokens.fontWeightMedium,
                                      ),
                                    ),
                                    subtitle: Text(
                                      AppLocalizations.of(context).allowAnyParticipantToInviteOthers,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    value: _openInvite,
                                    onChanged: (value) {
                                      setState(() {
                                        _openInvite = value;
                                      });
                                    },
                                    activeThumbColor: colorScheme.primary,
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                                  ),
                                  SwitchListTile(
                                    title: Text(
                                      AppLocalizations.of(context).lockConversation,
                                      style: textTheme.titleSmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: DesignTokens.fontWeightMedium,
                                      ),
                                    ),
                                    subtitle: Text(
                                      AppLocalizations.of(context).createConversationAsClosed,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    value: _conversationLocked,
                                    onChanged: (value) {
                                      setState(() {
                                        _conversationLocked = value;
                                      });
                                    },
                                    activeThumbColor: colorScheme.primary,
                                  ),
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
            ),
          ),
          _buildBottomToolbar(),
        ],
      ),
      ),
    );
  }

  /// Whether closing now would lose something: text, an attachment, or a
  /// recipient beyond the one the page was opened for.
  bool _hasUnsavedChanges() {
    return _titleController.text.trim().isNotEmpty ||
        _messageController.text.trim().isNotEmpty ||
        _attachments.isNotEmpty ||
        _toRecipients.any((r) => r != widget.initialRecipient);
  }

  /// Checks, shrinks and uploads [file], already in the list; it leaves the
  /// list again (with the reason) when it cannot be sent.
  Future<void> _handleFileUpload(XFile file) async {
    if (_uploadingFiles[file.path] == true) return;
    setState(() => _uploadingFiles[file.path] = true);
    try {
      final prepared = await _uploader.prepare(file, currentCount: _attachments.length - 1);
      final id = await _uploader.upload(prepared);
      if (!mounted) return;
      setState(() {
        _uploadingFiles.remove(file.path);
        _attachmentIdByPath[file.path] = id;
      });
    } on AttachmentUploadCancelled {
      return;
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _uploadingFiles.remove(file.path);
        _attachments.removeWhere((f) => f.path == file.path);
      });
      SnackbarHelper.showError(
        context,
        e is AttachmentUploadException ? e.message : AppLocalizations.of(context).failedToUploadFile(e.toString()),
      );
    }
  }

  /// Takes [file] off the list, and off the forum when it was uploaded.
  void _removeAttachmentFile(XFile file) {
    setState(() {
      _attachments.removeWhere((f) => f.path == file.path);
      _uploadingFiles.remove(file.path);
    });
    final id = _attachmentIdByPath.remove(file.path);
    if (id != null) _uploader.remove(id);
  }

  void _handleFileAttachment() async {
    final XFile? file = await FilePickerUtils.pickFile();
    if (file != null) {
      // Hide keyboard when file is selected to focus on upload progress
      FocusScope.of(context).unfocus();
      
      // Add file to list immediately so user can see it
      setState(() {
        _attachments.add(file);
      });
      // Start upload in background
      _handleFileUpload(file);
    }
  }

  void _handleImageAttachment() async {
    // Get constraints and check count limit before showing picker
    final constraints = _uploader.constraints;

    if (!canAddMoreAttachments(_attachments.length, constraints)) {
      if (mounted) {
        SnackbarHelper.showError(context, AppLocalizations.of(context).maximumAttachmentsAllowed(constraints!.count ?? 0));
      }
      return;
    }

    final XFile? image = await FilePickerUtils.pickImage();
    if (image != null) {
      // Hide keyboard when image is selected to focus on upload progress
      FocusScope.of(context).unfocus();
      
      // Add file to list immediately so user can see it
      setState(() {
        _attachments.add(image);
      });
      // Start upload in background
      _handleFileUpload(image);
    }
  }

  void _insertBBCode(String tag) {
    // Ensure the message field has focus before modifying
    if (!_messageFocusNode.hasFocus) {
      _messageFocusNode.requestFocus();
    }

    final TextEditingValue value = _messageController.value;
    final int start = value.selection.start;
    final int end = value.selection.end;

    // If start is -1, it means there's no valid cursor position
    if (start < 0) {
      // Append to the end if no cursor position
      final newText = '${value.text}[$tag][/$tag]';
      _messageController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length - (tag.length + 3)),
      );
      return;
    }

    String newText;
    int cursorPosition;

    if (start == end) {
      // No text selected, just insert empty tags at cursor position
      newText = value.text.replaceRange(start, start, '[$tag][/$tag]');
      cursorPosition = start + tag.length + 2; // Position cursor between tags
    } else {
      // Text is selected, wrap it with tags
      final String selectedText = value.text.substring(start, end);
      newText = value.text.replaceRange(start, end, '[$tag]$selectedText[/$tag]');
      // Position cursor at the end of the inserted tag structure
      // start + opening tag length + selected text length + closing tag length
      cursorPosition = start + tag.length + 2 + selectedText.length + tag.length + 3;
    }

    // Ensure cursor position is within bounds
    cursorPosition = cursorPosition.clamp(0, newText.length);

    _messageController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );

    // Ensure the field maintains focus after insertion
    _messageFocusNode.requestFocus();
  }

  void _handleMention() {
    AppNavigation.push(context, UserSearchPage(
          siteContext: widget.siteContext,
          onUserSelected: (username, iconUrl) {
            final currentText = _messageController.text;
            final currentSelection = _messageController.selection;
            final beforeCursor = currentText.substring(0, currentSelection.start);
            final afterCursor = currentText.substring(currentSelection.end);
            final newText = '$beforeCursor@$username $afterCursor';
            _messageController.text = newText;
            _messageController.selection = TextSelection.fromPosition(
              TextPosition(offset: (beforeCursor.length + username.length + 2).toInt()), // +2 for @ and space
            );
            // Ensure the message field is focused after inserting the username
            _messageFocusNode.requestFocus();
          },
          selectedUsers: const [],
        ));
  }

  Widget _buildBottomToolbar() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Debug: Log the current state
    debugPrint(
        '🔍 [NEW_CONVERSATION] _buildBottomToolbar: siteType=${widget.siteContext.siteType}, _canUpload=$_canUpload, willShowButtons=$_canUpload');

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: DesignTokens.opacityLow * 0.33),
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingS, vertical: DesignTokens.spacingXS),
          child: Row(
            children: [
              // File attachment button
              if (_canUpload)
                IconButton(
                  icon: Icon(
                    Icons.attach_file,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  tooltip: AppLocalizations.of(context).attachFile,
                  onPressed: _handleFileAttachment,
                ),
              // Image upload button
              if (_canUpload)
                IconButton(
                  icon: Icon(
                    Icons.image,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  tooltip: AppLocalizations.of(context).uploadImage,
                  onPressed: _handleImageAttachment,
                ),
              // BBCode button
              PopupMenuButton<String>(
                enabled: _isMessageFieldFocused,
                icon: Icon(Icons.format_bold, color: _isMessageFieldFocused ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withValues(alpha: 0.38)),
                tooltip: AppLocalizations.of(context).formatting,
                onSelected: _insertBBCode,
                itemBuilder: (context) => [
                  // Text formatting
                  PopupMenuItem(
                    value: 'B',
                    child: Row(
                      children: [
                        Icon(Icons.format_bold, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).bold, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'I',
                    child: Row(
                      children: [
                        Icon(Icons.format_italic, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).italic, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'U',
                    child: Row(
                      children: [
                        Icon(Icons.format_underline, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).underline, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'S',
                    child: Row(
                      children: [
                        Icon(Icons.strikethrough_s, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).strikethrough, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  // Links and Media
                  PopupMenuItem(
                    value: 'URL',
                    child: Row(
                      children: [
                        Icon(Icons.link, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).link, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'IMG',
                    child: Row(
                      children: [
                        Icon(Icons.image, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).image, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'VIDEO',
                    child: Row(
                      children: [
                        Icon(Icons.videocam, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).video, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  // Content blocks
                  PopupMenuItem(
                    value: 'QUOTE',
                    child: Row(
                      children: [
                        Icon(Icons.format_quote, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).quote, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'CODE',
                    child: Row(
                      children: [
                        Icon(Icons.code, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).code, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'SPOILER',
                    child: Row(
                      children: [
                        Icon(Icons.visibility_off, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).spoiler, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  // Lists
                  PopupMenuItem(
                    value: 'LIST',
                    child: Row(
                      children: [
                        Icon(Icons.format_list_bulleted, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).bulletList, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'LIST=1',
                    child: Row(
                      children: [
                        Icon(Icons.format_list_numbered, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).numberedList, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: '*',
                    child: Row(
                      children: [
                        Icon(Icons.subdirectory_arrow_right, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).listItem, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  // Alignment
                  PopupMenuItem(
                    value: 'LEFT',
                    child: Row(
                      children: [
                        Icon(Icons.format_align_left, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).alignLeft, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'CENTER',
                    child: Row(
                      children: [
                        Icon(Icons.format_align_center, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).alignCenter, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'RIGHT',
                    child: Row(
                      children: [
                        Icon(Icons.format_align_right, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context).alignRight, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
              // Mention button
              IconButton(
                icon: Icon(Icons.alternate_email, color: _isMessageFieldFocused ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withValues(alpha: 0.38)),
                tooltip: AppLocalizations.of(context).mentionUser,
                onPressed: _isMessageFieldFocused ? _handleMention : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Closed without sending: the uploads are removed from the forum.
    _uploader.close(sent: _sent);
    _titleController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }
}
