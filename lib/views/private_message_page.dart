import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/models/results/fc_private_message_result.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:get/get.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:intl/intl.dart';
import 'appbars/private_message_app_bar.dart';
import 'reply_private_message_page.dart';
import 'new_private_message_page.dart';
import 'user_profile_page.dart';
import 'widgets/user_avatar.dart';
import 'listitems/message_item.dart';
import 'dart:io';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import '../l10n/generated/app_localizations.dart';

class PrivateMessagePage extends StatefulWidget {
  final SiteContext siteContext;
  final String messageId;
  final String boxId;
  final String subject;
  final VoidCallback? onMarkUnread;

  const PrivateMessagePage({
    Key? key,
    required this.siteContext,
    required this.messageId,
    required this.boxId,
    required this.subject,
    this.onMarkUnread,
  }) : super(key: key);

  @override
  State<PrivateMessagePage> createState() => _PrivateMessagePageState();
}

class _PrivateMessagePageState extends State<PrivateMessagePage> {
  FCMessageResult? _message;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessage();
  }

  /// Cleans the subject by removing any existing "Re:" or "Fwd:" prefixes
  String _cleanSubject(String subject) {
    String cleanedSubject = subject.trim();

    // Remove "Re:" prefix (case insensitive, with optional spaces)
    cleanedSubject = cleanedSubject.replaceAll(RegExp(r'^re:\s*', caseSensitive: false), '');

    // Remove "Fwd:" prefix (case insensitive, with optional spaces)
    cleanedSubject = cleanedSubject.replaceAll(RegExp(r'^fwd:\s*', caseSensitive: false), '');

    return cleanedSubject.trim();
  }

  void _onReplyPressed() {
    if (_message != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReplyPrivateMessagePage(
            siteContext: widget.siteContext,
            conversationId: widget.messageId,
            initialRecipients: [_message!.msg_from ?? ''], // Pass sender as single recipient for "Reply"
            subject: widget.subject,
            isQuote: true,
          ),
        ),
      );
    }
  }

  void _onReplyAllPressed() {
    if (_message != null) {
      // For "Reply All", include all original recipients plus the sender
      List<String> allRecipients = [];

      // Add the sender (original message author)
      allRecipients.add(_message!.msg_from ?? '');

      // Add all original recipients
      for (var recipient in (_message!.msgTo as List<String>? ?? [])) {
        if (!allRecipients.contains(recipient)) {
          allRecipients.add(recipient);
        }
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReplyPrivateMessagePage(
            siteContext: widget.siteContext,
            conversationId: widget.messageId,
            initialRecipients: allRecipients, // Pass all recipients for "Reply All"
            subject: widget.subject,
            isQuote: true,
            showCcField: true,
          ),
        ),
      );
    }
  }

  void _onForwardPressed() {
    if (_message != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReplyPrivateMessagePage(
            siteContext: widget.siteContext,
            conversationId: widget.messageId,
            username: null, // No default recipient for forward
            subject: 'Fwd: ${_cleanSubject(widget.subject)}',
            isQuote: true, // Enable quote to trigger get_quoted_pm
            isForward: true, // Mark as forward to show correct title
          ),
        ),
      );
    }
  }

  Future<void> _markAsUnread() async {
    try {
      final pmProxy = SiteProxyFactory.getPrivateMessageProxy();
      await pmProxy.markPmUnreadAsync(widget.messageId);

      if (mounted) {
        // Call the callback to update the message state in the list
        widget.onMarkUnread?.call();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.messageMarkedAsUnread ?? 'Message marked as unread'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        // Pop back to the message list
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.failedToMarkAsUnread(e.toString()) ?? 'Failed to mark message as unread: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _loadMessage() async {
    AppLogger.debug('\n[PrivateMessagePage] Loading message: ${widget.messageId}');
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final pmProxy = SiteProxyFactory.getPrivateMessageProxy();

      AppLogger.debug('[PrivateMessagePage] Fetching message details');
      final message = await pmProxy.getMessageAsync(widget.messageId, widget.boxId, true);
      AppLogger.debug('[PrivateMessagePage] Message loaded successfully');

      if (mounted) {
        setState(() {
          _message = message;
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.debug('[PrivateMessagePage] Error loading message:');
      AppLogger.debug('  Error: $e');
      AppLogger.debug('  Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteMessage() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)?.deleteMessage ?? 'Delete Message',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        content: Text(
          'Are you sure you want to delete this message?',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)?.delete ?? 'Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final pmProxy = SiteProxyFactory.getPrivateMessageProxy();
      await pmProxy.deleteMessageAsync(widget.messageId, widget.boxId);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.failedToDeleteMessage(e.toString()) ?? 'Failed to delete message: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrivateMessageAppBar(
        title: widget.subject,
        siteContext: widget.siteContext,
        onDelete: _deleteMessage,
        onMarkUnread: _markAsUnread,
        onReply: _onReplyPressed,
        onReplyAll: _onReplyAllPressed,
        onForward: _onForwardPressed,
        onReport: () {
          // TODO: Implement report functionality
        },
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error loading message: $_error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadMessage,
              child: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
            ),
          ],
        ),
      );
    }

    if (_message == null) {
      return Center(
        child: Text(
          'Message not found',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    // Use MessageItem for rendering
    return MessageItem(
      siteContext: widget.siteContext,
      message: _message!,
      subject: widget.subject,
    );
  }
}
