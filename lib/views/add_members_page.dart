import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
// import 'package:get/get.dart';
import '../utils/error_dialog.dart';
import '../l10n/generated/app_localizations.dart';
// import '../utils/network_utils.dart';
// import '../views/widgets/message_compose_page.dart';
import '../views/user_search_page.dart';
// import '../views/widgets/cached_redirect_image.dart';
import 'widgets/user_avatar.dart';
import '../../theme/design_tokens.dart';

class AddMembersPage extends StatefulWidget {
  final SiteContext siteContext;
  final String conversationId;
  final String conversationTitle;
  final String? preSelectedUser;
  final String? preSelectedUserIcon;

  const AddMembersPage({
    Key? key,
    required this.siteContext,
    required this.conversationId,
    required this.conversationTitle,
    this.preSelectedUser,
    this.preSelectedUserIcon,
  }) : super(key: key);

  @override
  State<AddMembersPage> createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {
  final TextEditingController _messageController = TextEditingController();
  bool _isSubmitting = false;

  // Recipient field state
  final List<String> _toRecipients = [];
  final Map<String, String?> _recipientIcons = {}; // Store icon URLs for recipients

  @override
  void initState() {
    super.initState();
    _messageController.text = 'I would like to add you to this conversation.';
    if (widget.preSelectedUser != null) {
      _toRecipients.add(widget.preSelectedUser!);
      _recipientIcons[widget.preSelectedUser!] = widget.preSelectedUserIcon;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<bool> _handleSubmit(String content) async {
    try {
      final conversationProxy = SiteProxyFactory.getPrivateConversationProxy();
      // Add members to the conversation
      final result = await conversationProxy.inviteParticipantAsync(
        _toRecipients,
        widget.conversationId,
        content, // Use message content as invite reason
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
          throw Exception('Failed to add members');
        }
      }
    } catch (e) {
      // Only wrap if it's not already a clean server error message
      final message = e.toString();
      if (mounted) {
        String errorMessage = message;
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring(11);
        }
        // Remove ANSI color codes if present
        errorMessage = errorMessage.replaceAll(RegExp(r'\[\d+m'), '');
        showErrorDialog(AppLocalizations.of(context)?.errorAddingMembers(errorMessage) ?? 'Error adding members: $errorMessage');
      }
      return false;
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

  Widget _buildRecipientChips(List<String> recipients, Function(String) onAdd, Function(String) onRemove) {
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
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
                  onUserSelected: (username, iconUrl) {},
                  selectedUsers: [..._toRecipients],
                ),
              ),
            );
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)?.addMembers ?? 'Add Members',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
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
            onPressed: _isSubmitting || _toRecipients.isEmpty
                ? null
                : () async {
                    setState(() {
                      _isSubmitting = true;
                    });
                    try {
                      final content = _messageController.text;
                      final success = await _handleSubmit(content);
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)?.membersAddedSuccessfully ?? 'Members added successfully'),
                            backgroundColor: colorScheme.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.of(context).pop(true);
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
      body: Padding(
        padding: DesignTokens.paddingL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invite:',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildRecipientChips(
              _toRecipients,
              (username) => setState(() => _toRecipients.add(username)),
              (username) => setState(() {
                _toRecipients.remove(username);
                _recipientIcons.remove(username);
              }),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.inviteMessageOptional ?? 'Invite Message (optional)',
                hintText: AppLocalizations.of(context)?.iWouldLikeToAddYouToThisConversation ?? 'I would like to add you to this conversation.',
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
              minLines: 2,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
            ),
          ],
        ),
      ),
    );
  }
}
