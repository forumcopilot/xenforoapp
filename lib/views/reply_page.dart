import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart' as forumcopilot_sdk;
import 'package:forumcopilot_flutter/views/widgets/message_compose_page.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../utils/snackbar_helper.dart';
import '../services/attachment_uploader.dart';

class ReplyPage extends StatefulWidget {
  final SiteContext siteContext;
  final String threadId;
  final String? forumId;
  final String? quotePostId;
  final String? quoteText;
  final String? quoteAuthor;
  final String topicTitle;
  final String? postId;
  final bool isQuote;

  const ReplyPage({
    super.key,
    required this.siteContext,
    required this.threadId,
    required this.topicTitle,
    this.forumId,
    this.quotePostId,
    this.quoteText,
    this.quoteAuthor,
    this.postId,
    this.isQuote = false,
  });

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {

  // The reply's attachments, sent to this forum and node whatever forum is
  // opened meanwhile.
  late final AttachmentUploader _uploader = AttachmentUploader(
    siteContext: widget.siteContext,
    kind: AttachmentKind.post,
    targetId: widget.forumId ?? '',
  );
  bool _sent = false;
  String? _createdPostId; // Store the created post ID
  Future<forumcopilot_sdk.FCQuotePostResult>? _quoteFuture;

  @override
  void initState() {
    super.initState();
    // Cache the future so it's only called once
    if (widget.isQuote && widget.postId != null) {
      _quoteFuture = SiteProxyFactory.getPostProxy().getQuotePostAsync(widget.postId!);
    }
  }

  @override
  void dispose() {
    // Closed without posting: the uploads are removed from the forum.
    _uploader.close(sent: _sent);
    super.dispose();
  }

  String? _getInitialContent() {
    if (widget.quoteText != null && widget.quoteAuthor != null) {
      return '[QUOTE="${widget.quoteAuthor}"]${widget.quoteText}[/QUOTE]\n\n';
    }
    return null;
  }

  /// The forum holds this post for a moderator: say so, or it seems to vanish.
  void _showAwaitingApproval() {
    if (!mounted) return;
    SnackbarHelper.showInfo(context, AppLocalizations.of(context).postAwaitingApproval);
  }

  Future<bool> _handleSubmit(String title, String content) async {
    try {
      AppLogger.debug('🟢 [REPLY_PAGE] _handleSubmit called');
      AppLogger.debug('   - widget.forumId: ${widget.forumId}');
      AppLogger.debug('   - widget.threadId: ${widget.threadId}');
      AppLogger.debug('   - content length: ${content.length}');
      AppLogger.debug('   - attachmentIds: ${_uploader.attachmentIds}');
      AppLogger.debug('   - groupId: ${_uploader.groupId}');
      
      var postProxy = SiteProxyFactory.getPostProxy();
      final forumIdParam = widget.forumId ?? "";
      final threadIdParam = widget.threadId;
      AppLogger.debug('🟢 [REPLY_PAGE] Calling replyPostAsync with:');
      AppLogger.debug('   - forumId: "$forumIdParam" (empty: ${forumIdParam.isEmpty})');
      AppLogger.debug('   - threadId: "$threadIdParam" (empty: ${threadIdParam.isEmpty})');
      AppLogger.debug('   - subject: ""');
      AppLogger.debug('   - content length: ${content.length}');
      AppLogger.debug('   - attachmentIds: ${_uploader.attachmentIds}');
      AppLogger.debug('   - groupId: ${_uploader.groupId}');
      
      var result = await postProxy.replyPostAsync(
        forumIdParam,
        threadIdParam,
        "", // Subject is optional for replies
        content,
        _uploader.attachmentIds.isNotEmpty ? _uploader.attachmentIds : null,
        _uploader.groupId,
        false, // Don't need HTML return
      );
      
      AppLogger.debug('🟢 [REPLY_PAGE] replyPostAsync returned:');
      AppLogger.debug('   - result.result: ${result.result}');
      AppLogger.debug('   - result.resultText: ${result.resultText}');
      AppLogger.debug('   - result.postId: ${result.postId}');
      AppLogger.debug('   - result.state: ${result.state}');
      
      if (result.result) {
        // Check if post needs moderation (state = 1)
        if (result.state == 1) {
          // Don't store postId if post needs moderation - it won't be visible yet
          _createdPostId = null;
          _showAwaitingApproval();
          debugPrint('🔍 [REPLY] Post submitted but needs moderation, postId not stored');
        } else {
          // Store the postId synchronously for immediate use in onSuccess callback
          // Only store if postId is not null and not empty
          if (result.postId != null && result.postId!.isNotEmpty) {
            _createdPostId = result.postId;
          } else {
            _createdPostId = null;
            debugPrint('⚠️ [REPLY] Warning: postId is null or empty after successful submission');
          }
        }
        _sent = true;
        return true;
      } else {
        // Server returned result=false with a message - throw it directly without wrapping
        // This allows the onError handler to show the server's message cleanly
        final errorMessage = result.resultText?.trim();
        if (errorMessage != null && errorMessage.isNotEmpty) {
          throw Exception(errorMessage);
        } else {
          throw Exception('Failed to post reply');
        }
      }
    } catch (e) {
      AppLogger.debug('🔴 [REPLY_PAGE] Exception in _handleSubmit:');
      AppLogger.debug('   - Exception type: ${e.runtimeType}');
      AppLogger.debug('   - Exception message: ${e.toString()}');
      if (e is DioException) {
        AppLogger.debug('   - DioException details:');
        AppLogger.debug('     - statusCode: ${e.response?.statusCode}');
        AppLogger.debug('     - statusMessage: ${e.response?.statusMessage}');
        AppLogger.debug('     - response data: ${e.response?.data}');
        AppLogger.debug('     - request path: ${e.requestOptions.path}');
        AppLogger.debug('     - request data: ${e.requestOptions.data}');
      }
      // Only wrap if it's not already a clean server error message
      // Check if the exception message doesn't start with "Failed to post reply"
      final message = e.toString();
      if (message.startsWith('Exception: ') && !message.contains('Failed to post reply')) {
        // This is already a clean server message, re-throw as-is
        rethrow;
      } else {
        // Wrap other exceptions
        throw Exception('Failed to post reply: ${e.toString()}');
      }
    }
  }

  /// The composer has checked and shrunk the file.
  Future<String?> _handleFileUpload(XFile file) => _uploader.upload(file);

  @override
  Widget build(BuildContext context) {
    if (widget.isQuote && widget.postId != null) {
      // Fetch quote content from API (using cached future)
      return FutureBuilder<forumcopilot_sdk.FCQuotePostResult>(
        future: _quoteFuture,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final hasError = snapshot.hasError;
          final hasData = snapshot.hasData && snapshot.data != null;
          // Only set quoteContent if we have data, otherwise use null to avoid overwriting user input
          final quoteContent = hasData && snapshot.data!.quoteContent != null && snapshot.data!.quoteContent!.isNotEmpty
              ? snapshot.data!.quoteContent
              : null;
          
          // Create the compose widget once and reuse it across all states
          // Use a stable key based on postId to preserve widget state (including attachments)
          Widget compose = MessageComposePage(
            key: ValueKey('reply_with_quote_${widget.postId}'),
            siteContext: widget.siteContext,
            title: AppLocalizations.of(context).reply,
            showTitleField: false,
            initialContent: quoteContent,
            contentHint: AppLocalizations.of(context).writeYourReply,
            onSubmit: _handleSubmit,
            onFileUpload: (widget.siteContext.loginDataOutput?.canUploadAttachment ?? false) ? _handleFileUpload : null,
            topicTitle: widget.topicTitle,
            onRemoveAttachment: _uploader.remove,
            onSuccess: (success) {
              // Never null on success: the caller reads null as "closed without posting".
              return _createdPostId ?? true;
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
                Center(child: Text(AppLocalizations.of(context).failedToLoadQuote(snapshot.error.toString()))),
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
        showTitleField: false,
        initialContent: _getInitialContent(),
        contentHint: AppLocalizations.of(context).writeYourReply,
        onSubmit: _handleSubmit,
        onFileUpload: (widget.siteContext.loginDataOutput?.canUploadAttachment ?? false) ? _handleFileUpload : null,
        topicTitle: widget.topicTitle,
        onRemoveAttachment: _uploader.remove,
        onSuccess: (success) {
          // Never null on success: the caller reads null as "closed without posting".
          return _createdPostId ?? true;
        },
        onError: (error) {
          if (context.mounted) {
            // Extract the clean message from the exception
            String errorMessage = error.toString();
            // Remove "Exception: " prefix if present
            if (errorMessage.startsWith('Exception: ')) {
              errorMessage = errorMessage.substring(11);
            }
            
            // Cache theme values to avoid multiple Theme.of(context) calls that could trigger rebuilds
            
            SnackbarHelper.showError(context, errorMessage);
          }
          // Note: We do NOT call Navigator.pop or trigger any parent widget operations
          // when a reply fails. Only MessageComposePage's setState will be called.
        },
      );
    }
  }
}
