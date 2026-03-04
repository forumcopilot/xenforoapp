import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forumcopilot_flutter/utils/file_picker_utils.dart';
import 'package:forumcopilot_flutter/utils/attachment_constraints_utils.dart';
import 'package:forumcopilot_flutter/utils/attachment_validation_utils.dart';
import 'package:forumcopilot_flutter/utils/image_optimization_utils.dart';
import 'package:forumcopilot_flutter/views/user_search_page.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'conversation_page.dart';
import '../../../../theme/design_tokens.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../../../utils/file_utils.dart';

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
  final List<String> _attachmentIds = [];
  final Map<String, bool> _uploadingFiles = {}; // Track which files are currently uploading (key: file path)
  String? _groupId;
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
      print('🐛 [NewConversationPage] Attachment IDs: $_attachmentIds, groupId: $_groupId');
      final result = await conversationProxy.newConversationAsync(
        _toRecipients,
        title,
        content,
        attachmentIds: _attachmentIds.isNotEmpty ? _attachmentIds : null,
        groupId: _groupId,
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
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final colorScheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: colorScheme.onErrorContainer,
                  ),
                  SizedBox(width: DesignTokens.spacingM),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: colorScheme.errorContainer,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              ),
              margin: DesignTokens.paddingS,
              padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingL - DesignTokens.spacingXS),
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: AppLocalizations.of(context)?.dismiss ?? 'Dismiss',
                textColor: colorScheme.onErrorContainer,
                onPressed: () {
                  scaffoldMessenger.hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
        return false;
      } else {
        // Wrap other exceptions
        if (mounted) {
          // Capture ScaffoldMessengerState to ensure dismiss button works correctly
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final colorScheme = Theme.of(context).colorScheme;
          final textTheme = Theme.of(context).textTheme;
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: colorScheme.onErrorContainer,
                  ),
                  SizedBox(width: DesignTokens.spacingM),
                  Expanded(
                    child: Text(
                      'Failed to create conversation: ${e.toString()}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: colorScheme.errorContainer,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              ),
              margin: DesignTokens.paddingS,
              padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingL - DesignTokens.spacingXS),
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: AppLocalizations.of(context)?.dismiss ?? 'Dismiss',
                textColor: colorScheme.onErrorContainer,
                onPressed: () {
                  scaffoldMessenger.hideCurrentSnackBar();
                },
              ),
            ),
          );
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
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
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
          'Participants',
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
                'Add',
                style: TextStyle(
                  color: colorScheme.primary,
                ),
              ),
              backgroundColor: colorScheme.primaryContainer.withOpacity(DesignTokens.opacityLow),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Conversation',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: DesignTokens.fontWeightSemiBold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 3,
        shadowColor: colorScheme.shadow.withOpacity(DesignTokens.opacityLow),
        surfaceTintColor: colorScheme.surfaceTint,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
        centerTitle: true,
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)?.conversationCreatedSuccessfully ?? 'Conversation created successfully'),
                            backgroundColor: colorScheme.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );

                        // Dismiss keyboard before navigating
                        FocusScope.of(context).unfocus();
                        // Navigate to the newly created conversation instead of just popping
                        if (_createdConversationId != null && _createdConversationId!.isNotEmpty) {
                          print('🐛 [NewConversationPage] Navigating to newly created conversation: $_createdConversationId');
                          // Pop the new conversation page first
                          Navigator.of(context).pop();
                          // Then navigate to the conversation page
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ConversationPage(
                                siteContext: widget.siteContext,
                                conversationId: _createdConversationId!,
                                subject: _createdConversationTitle ?? title,
                              ),
                            ),
                          );
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
                            'Subject',
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: DesignTokens.fontWeightMedium,
                            ),
                          ),
                          SizedBox(height: DesignTokens.spacingS),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: 'Enter subject',
                              hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                              filled: true,
                              fillColor: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
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
                            'Message',
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
                              hintText: AppLocalizations.of(context)?.writeYourMessage ?? 'Write your message...',
                              hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                              filled: true,
                              fillColor: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
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
                                    // Try to find matching attachment ID (they should be in sync)
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
                      // XenForo-only options
                      if (widget.siteContext.siteType == 'xenforo') ...[
                        SizedBox(height: DesignTokens.spacingL),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Options',
                              style: textTheme.titleSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: DesignTokens.fontWeightMedium,
                              ),
                            ),
                            SizedBox(height: DesignTokens.spacingS),
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                              ),
                              child: Column(
                                children: [
                                  SwitchListTile(
                                    title: Text(
                                      'Open Invite',
                                      style: textTheme.titleSmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: DesignTokens.fontWeightMedium,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Allow any participant to invite others',
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
                                    activeColor: colorScheme.primary,
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: colorScheme.outlineVariant.withOpacity(0.3),
                                  ),
                                  SwitchListTile(
                                    title: Text(
                                      'Lock Conversation',
                                      style: textTheme.titleSmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: DesignTokens.fontWeightMedium,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Create conversation as closed (no replies allowed)',
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
                                    activeColor: colorScheme.primary,
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
    );
  }

  Future<String?> _handleFileUpload(XFile file) async {
    debugPrint('🔍 [NEW_CONVERSATION] _handleFileUpload called');
    debugPrint('🔍 [NEW_CONVERSATION] File details:');
    debugPrint('   - file.path: "${file.path}"');
    debugPrint('   - file.name: "${file.name}"');

    // Check if this specific file is already uploading
    if (_uploadingFiles[file.path] == true) {
      debugPrint('⚠️ [NEW_CONVERSATION] File already uploading, returning');
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
          debugPrint('🔍 [NEW_CONVERSATION] Image optimized successfully');
        } catch (e) {
          debugPrint('❌ [NEW_CONVERSATION] Error optimizing image: $e');
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

    // Mark this file as uploading
    setState(() {
      _uploadingFiles[fileToUpload.path] = true;
    });

    try {
      debugPrint('🔍 [NEW_CONVERSATION] Getting attachment proxy...');
      var attachmentProxy = SiteProxyFactory.getAttachmentProxy();
      // Use existing groupId if available, otherwise use empty string
      var groupId = _groupId ?? "";

      debugPrint('🔍 [NEW_CONVERSATION] Reading file bytes...');
      final fileBytes = await fileToUpload.readAsBytes();
      debugPrint('🔍 [NEW_CONVERSATION] File bytes read: ${fileBytes.length} bytes');

      debugPrint('🔍 [NEW_CONVERSATION] Calling uploadAttachmentAsync with:');
      debugPrint('   - type: "pm"');
      debugPrint('   - id: "" (empty for new conversations)');
      debugPrint('   - groupId: "$groupId"');
      debugPrint('   - attachmentName: "${fileToUpload.name}"');
      debugPrint('   - bytes length: ${fileBytes.length}');

      var uploadAttachmentResult = await attachmentProxy.uploadAttachmentAsync(
        "pm", // type for private messages/conversations
        "", // empty string for new conversations (no conversation ID yet)
        groupId,
        file.name,
        fileBytes,
      );

      debugPrint('🔍 [NEW_CONVERSATION] Upload result:');
      debugPrint('   - result: ${uploadAttachmentResult.result}');
      debugPrint('   - resultText: "${uploadAttachmentResult.resultText}"');
      debugPrint('   - attachmentId: "${uploadAttachmentResult.attachmentId}"');
      debugPrint('   - groupId: "${uploadAttachmentResult.groupId}"');

      if (uploadAttachmentResult.result) {
        debugPrint('✅ [NEW_CONVERSATION] File upload successful');

        // Store attachment ID and group ID
        if (uploadAttachmentResult.attachmentId != null && uploadAttachmentResult.attachmentId!.isNotEmpty) {
          setState(() {
            // Find the index of this file in the attachments list
            final fileIndex = _attachments.indexWhere((f) => f.path == file.path);
            if (fileIndex != -1) {
              // Insert attachment ID at the correct position
              while (_attachmentIds.length <= fileIndex) {
                _attachmentIds.add('');
              }
              _attachmentIds[fileIndex] = uploadAttachmentResult.attachmentId!;
            }
            // Update groupId if provided (should be consistent across all uploads)
            if (uploadAttachmentResult.groupId != null && uploadAttachmentResult.groupId!.isNotEmpty) {
              _groupId = uploadAttachmentResult.groupId;
            }
            _uploadingFiles.remove(file.path);
          });
          debugPrint('✅ [NEW_CONVERSATION] Stored attachmentId: ${uploadAttachmentResult.attachmentId}');
          debugPrint('✅ [NEW_CONVERSATION] Current attachmentIds: $_attachmentIds');
          debugPrint('✅ [NEW_CONVERSATION] Current groupId: "$_groupId"');
          return uploadAttachmentResult.attachmentId;
        } else {
          debugPrint('⚠️ [NEW_CONVERSATION] Upload succeeded but attachmentId is null or empty');
          setState(() {
            _uploadingFiles.remove(fileToUpload.path);
          });
          return null;
        }
      } else {
        debugPrint('❌ [NEW_CONVERSATION] File upload failed: ${uploadAttachmentResult.resultText}');
        // Remove file from list on failure
        setState(() {
          final fileIndex = _attachments.indexWhere((f) => f.path == file.path);
          if (fileIndex != -1) {
            _attachments.removeAt(fileIndex);
            if (fileIndex < _attachmentIds.length) {
              _attachmentIds.removeAt(fileIndex);
            }
          }
          _uploadingFiles.remove(file.path);
        });
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
      debugPrint('❌ [NEW_CONVERSATION] Exception in _handleFileUpload: $e');
      debugPrint('❌ [NEW_CONVERSATION] Stack trace: $stackTrace');
      // Remove file from list on error
      setState(() {
        final fileIndex = _attachments.indexWhere((f) => f.path == file.path);
        if (fileIndex != -1) {
          _attachments.removeAt(fileIndex);
          if (fileIndex < _attachmentIds.length) {
            _attachmentIds.removeAt(fileIndex);
          }
        }
        _uploadingFiles.remove(file.path);
      });
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
    }
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSearchPage(
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
        ),
      ),
    );
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
            color: colorScheme.shadow.withOpacity(DesignTokens.opacityLow * 0.33),
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
                  tooltip: 'Attach File',
                  onPressed: _handleFileAttachment,
                ),
              // Image upload button
              if (_canUpload)
                IconButton(
                  icon: Icon(
                    Icons.image,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  tooltip: 'Upload Image',
                  onPressed: _handleImageAttachment,
                ),
              // BBCode button
              PopupMenuButton<String>(
                enabled: _isMessageFieldFocused,
                icon: Icon(Icons.format_bold, color: _isMessageFieldFocused ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withOpacity(0.38)),
                tooltip: 'Formatting',
                onSelected: _insertBBCode,
                itemBuilder: (context) => [
                  // Text formatting
                  PopupMenuItem(
                    value: 'B',
                    child: Row(
                      children: [
                        Icon(Icons.format_bold, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context)?.bold ?? 'Bold', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'I',
                    child: Row(
                      children: [
                        Icon(Icons.format_italic, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context)?.italic ?? 'Italic', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'U',
                    child: Row(
                      children: [
                        Icon(Icons.format_underline, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context)?.underline ?? 'Underline', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'S',
                    child: Row(
                      children: [
                        Icon(Icons.strikethrough_s, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context)?.strikethrough ?? 'Strikethrough', style: textTheme.bodyMedium),
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
                        Text(AppLocalizations.of(context)?.link ?? 'Link', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'IMG',
                    child: Row(
                      children: [
                        Icon(Icons.image, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context)?.image ?? 'Image', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'VIDEO',
                    child: Row(
                      children: [
                        Icon(Icons.videocam, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context)?.video ?? 'Video', style: textTheme.bodyMedium),
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
                        Text(AppLocalizations.of(context)?.quote ?? 'Quote', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'CODE',
                    child: Row(
                      children: [
                        Icon(Icons.code, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context)?.code ?? 'Code', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'SPOILER',
                    child: Row(
                      children: [
                        Icon(Icons.visibility_off, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context)?.spoiler ?? 'Spoiler', style: textTheme.bodyMedium),
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
                        Text(AppLocalizations.of(context)?.bulletList ?? 'Bullet List', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'LIST=1',
                    child: Row(
                      children: [
                        Icon(Icons.format_list_numbered, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context)?.numberedList ?? 'Numbered List', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: '*',
                    child: Row(
                      children: [
                        Icon(Icons.subdirectory_arrow_right, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context)?.listItem ?? 'List Item', style: textTheme.bodyMedium),
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
                        Text(AppLocalizations.of(context)?.alignLeft ?? 'Align Left', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'CENTER',
                    child: Row(
                      children: [
                        Icon(Icons.format_align_center, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context)?.alignCenter ?? 'Align Center', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'RIGHT',
                    child: Row(
                      children: [
                        Icon(Icons.format_align_right, size: 20, color: colorScheme.onSurface),
                        const SizedBox(width: DesignTokens.spacingS),
                        Text(AppLocalizations.of(context)?.alignRight ?? 'Align Right', style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
              // Mention button
              IconButton(
                icon: Icon(Icons.alternate_email, color: _isMessageFieldFocused ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withOpacity(0.38)),
                tooltip: 'Mention User',
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
    _titleController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }
}
