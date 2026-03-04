import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart' as forumcopilot_sdk;
import 'package:forumcopilot_flutter/views/widgets/message_compose_page.dart';
import 'package:forumcopilot_flutter/utils/attachment_constraints_utils.dart';
import 'package:forumcopilot_flutter/utils/attachment_validation_utils.dart';
import 'package:forumcopilot_flutter/utils/image_optimization_utils.dart';
import 'package:forumcopilot_flutter/utils/file_utils.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../theme/design_tokens.dart';

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

  final List<String> _attachmentIds = [];
  String? _groupId;
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

  String? _getInitialContent() {
    if (widget.quoteText != null && widget.quoteAuthor != null) {
      return '[QUOTE="${widget.quoteAuthor}"]${widget.quoteText}[/QUOTE]\n\n';
    }
    return null;
  }

  Future<bool> _handleSubmit(String title, String content) async {
    try {
      AppLogger.debug('🟢 [REPLY_PAGE] _handleSubmit called');
      AppLogger.debug('   - widget.forumId: ${widget.forumId}');
      AppLogger.debug('   - widget.threadId: ${widget.threadId}');
      AppLogger.debug('   - content length: ${content.length}');
      AppLogger.debug('   - attachmentIds: $_attachmentIds');
      AppLogger.debug('   - groupId: $_groupId');
      
      var postProxy = SiteProxyFactory.getPostProxy();
      final forumIdParam = widget.forumId ?? "";
      final threadIdParam = widget.threadId;
      AppLogger.debug('🟢 [REPLY_PAGE] Calling replyPostAsync with:');
      AppLogger.debug('   - forumId: "$forumIdParam" (empty: ${forumIdParam.isEmpty})');
      AppLogger.debug('   - threadId: "$threadIdParam" (empty: ${threadIdParam.isEmpty})');
      AppLogger.debug('   - subject: ""');
      AppLogger.debug('   - content length: ${content.length}');
      AppLogger.debug('   - attachmentIds: $_attachmentIds');
      AppLogger.debug('   - groupId: $_groupId');
      
      var result = await postProxy.replyPostAsync(
        forumIdParam,
        threadIdParam,
        "", // Subject is optional for replies
        content,
        _attachmentIds.isNotEmpty ? _attachmentIds : null,
        _groupId,
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

  Future<String?> _handleFileUpload(XFile file) async {
    debugPrint('🔍 [REPLY] _handleFileUpload called');
    debugPrint('🔍 [REPLY] File details:');
    debugPrint('   - file.path: "${file.path}"');
    debugPrint('   - file.name: "${file.name}"');
    debugPrint('   - forumId: "${widget.forumId}"');

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
          debugPrint('🔍 [REPLY] Image optimized successfully');
        } catch (e) {
          debugPrint('❌ [REPLY] Error optimizing image: $e');
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
      debugPrint('🔍 [REPLY] Getting attachment proxy...');
      var attachmentProxy = SiteProxyFactory.getAttachmentProxy();
      // Use existing groupId if available, otherwise use empty string
      var groupId = _groupId ?? "";

      debugPrint('🔍 [REPLY] Reading file bytes...');
      final fileBytes = await fileToUpload.readAsBytes();
      debugPrint('🔍 [REPLY] File bytes read: ${fileBytes.length} bytes');

      debugPrint('🔍 [REPLY] Calling uploadAttachmentAsync with:');
      debugPrint('   - type: "post"');
      debugPrint('   - id: "${widget.forumId ?? ""}"');
      debugPrint('   - groupId: "$groupId"');
      debugPrint('   - attachmentName: "${fileToUpload.name}"');
      debugPrint('   - bytes length: ${fileBytes.length}');

      var uploadAttachmentResult = await attachmentProxy.uploadAttachmentAsync("post", widget.forumId ?? "", groupId, fileToUpload.name, fileBytes);
      
      debugPrint('🔍 [REPLY] Upload result:');
      debugPrint('   - result: ${uploadAttachmentResult.result}');
      debugPrint('   - resultText: "${uploadAttachmentResult.resultText}"');
      debugPrint('   - attachmentId: "${uploadAttachmentResult.attachmentId}"');
      debugPrint('   - groupId: "${uploadAttachmentResult.groupId}"');
      
      if (uploadAttachmentResult.result) {
        debugPrint('✅ [REPLY] File upload successful');
        
        // Store attachment ID and group ID
        if (uploadAttachmentResult.attachmentId != null && uploadAttachmentResult.attachmentId!.isNotEmpty) {
          setState(() {
            _attachmentIds.add(uploadAttachmentResult.attachmentId!);
            // Update groupId if provided (should be consistent across all uploads)
            if (uploadAttachmentResult.groupId != null && uploadAttachmentResult.groupId!.isNotEmpty) {
              _groupId = uploadAttachmentResult.groupId;
            }
          });
          debugPrint('✅ [REPLY] Stored attachmentId: ${uploadAttachmentResult.attachmentId}');
          debugPrint('✅ [REPLY] Current attachmentIds: $_attachmentIds');
          debugPrint('✅ [REPLY] Current groupId: "$_groupId"');
          return uploadAttachmentResult.attachmentId;
        } else {
          debugPrint('⚠️ [REPLY] Upload succeeded but attachmentId is null or empty');
          return null;
        }
      } else {
        debugPrint('❌ [REPLY] File upload failed: ${uploadAttachmentResult.resultText}');
        throw Exception(uploadAttachmentResult.resultText ?? 'Failed to upload file');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [REPLY] Exception in _handleFileUpload: $e');
      debugPrint('❌ [REPLY] Stack trace: $stackTrace');
      throw Exception('Failed to upload file: ${e.toString()}');
    }
  }

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
            title: AppLocalizations.of(context)?.reply ?? 'Reply',
            showTitleField: false,
            initialContent: quoteContent,
            contentHint: AppLocalizations.of(context)?.writeYourReply ?? 'Write your reply...',
            onSubmit: _handleSubmit,
            onFileUpload: (widget.siteContext.loginDataOutput?.canUploadAttachment ?? false) ? _handleFileUpload : null,
            topicTitle: widget.topicTitle,
            onRemoveAttachment: (attachmentId) async {
              // Remove the attachment ID from the list and call API to delete from server
              // Call API to remove attachment from server
              if (_groupId != null && _groupId!.isNotEmpty && widget.forumId != null && widget.forumId!.isNotEmpty) {
                try {
                  var attachmentProxy = SiteProxyFactory.getAttachmentProxy();
                  await attachmentProxy.removeAttachmentAsync(
                    attachmentId,
                    widget.forumId!,
                    _groupId!, // groupId is required for temporary attachments
                    '', // postId is empty for new replies
                  );
                } catch (e) {
                  // Silently handle errors
                }
              }
              
              // Remove from local list
              if (_attachmentIds.contains(attachmentId)) {
                setState(() {
                  _attachmentIds.remove(attachmentId);
                });
              }
            },
            onSuccess: (success) {
              return _createdPostId;
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
                Center(child: Text(AppLocalizations.of(context)?.failedToLoadQuote(snapshot.error.toString()) ?? 'Failed to load quote: \n${snapshot.error}')),
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
        showTitleField: false,
        initialContent: _getInitialContent(),
        contentHint: 'Write your reply...',
        onSubmit: _handleSubmit,
        onFileUpload: (widget.siteContext.loginDataOutput?.canUploadAttachment ?? false) ? _handleFileUpload : null,
        topicTitle: widget.topicTitle,
        onRemoveAttachment: (attachmentId) async {
          // Remove the attachment ID from the list and call API to delete from server
          // Call API to remove attachment from server
          if (_groupId != null && _groupId!.isNotEmpty && widget.forumId != null && widget.forumId!.isNotEmpty) {
            try {
              var attachmentProxy = SiteProxyFactory.getAttachmentProxy();
              await attachmentProxy.removeAttachmentAsync(
                attachmentId,
                widget.forumId!,
                _groupId!, // groupId is required for temporary attachments
                '', // postId is empty for new replies
              );
            } catch (e) {
              // Silently handle errors
            }
          }
          
          // Remove from local list
          if (_attachmentIds.contains(attachmentId)) {
            setState(() {
              _attachmentIds.remove(attachmentId);
            });
          }
        },
        onSuccess: (success) {
          return _createdPostId;
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
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;
            final textTheme = theme.textTheme;
            
            // Capture ScaffoldMessengerState to ensure dismiss button works correctly
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: DesignTokens.spacingM),
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
                  label: 'Dismiss',
                  textColor: colorScheme.onErrorContainer,
                  onPressed: () {
                    scaffoldMessenger.hideCurrentSnackBar();
                  },
                ),
              ),
            );
          }
          // Note: We do NOT call Navigator.pop or trigger any parent widget operations
          // when a reply fails. Only MessageComposePage's setState will be called.
        },
      );
    }
  }
}
