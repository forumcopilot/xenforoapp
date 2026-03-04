import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/results/fc_topic_result.dart';
import 'package:forumcopilot_flutter/views/widgets/message_compose_page.dart';
import 'package:forumcopilot_flutter/utils/attachment_constraints_utils.dart';
import 'package:forumcopilot_flutter/utils/attachment_validation_utils.dart';
import 'package:forumcopilot_flutter/utils/image_optimization_utils.dart';
import 'package:forumcopilot_flutter/utils/file_utils.dart';
import 'package:forumcopilot_flutter/theme/design_tokens.dart';

class NewTopicPage extends StatefulWidget {
  final SiteContext siteContext;
  final String forumId;
  final String forumName;

  const NewTopicPage({
    super.key,
    required this.siteContext,
    required this.forumId,
    required this.forumName,
  });

  @override
  State<NewTopicPage> createState() => _NewTopicPageState();
}

class _NewTopicPageState extends State<NewTopicPage> {
  final List<String> _attachmentIds = [];
  String? _groupId;
  String? _selectedPrefixId;

  // Prefix-related state
  List<FCPrefix> _availablePrefixes = [];
  bool _requirePrefix = false;
  bool _isLoadingPrefixes = true;
  String? _prefixError;

  @override
  void initState() {
    super.initState();
    _loadPrefixes();
  }

  Future<void> _loadPrefixes() async {
    try {
      setState(() {
        _isLoadingPrefixes = true;
        _prefixError = null;
      });

      final topicProxy = SiteProxyFactory.getTopicProxy();
      // Fetch minimal data just to get prefix information
      final topicData = await topicProxy.getTopicAsync(widget.forumId, 0, 1);

      if (mounted) {
        setState(() {
          _availablePrefixes = topicData.prefixes;
          _requirePrefix = topicData.requirePrefix;
          _isLoadingPrefixes = false;
        });

        debugPrint('🔍 [NEW_TOPIC] Prefixes loaded:');
        debugPrint('   - Available prefixes: ${_availablePrefixes.length}');
        debugPrint('   - Require prefix: $_requirePrefix');
        if (_availablePrefixes.isNotEmpty) {
          final prefixSummary = _availablePrefixes.map((p) => '${p.prefixId}:${p.prefixDisplayName}').join(', ');
          debugPrint('   - Prefixes: $prefixSummary');
        }
      }
    } catch (e) {
      debugPrint('❌ [NEW_TOPIC] Error loading prefixes: $e');
      if (mounted) {
        setState(() {
          _prefixError = e.toString();
          _isLoadingPrefixes = false;
        });
      }
    }
  }

  Future<bool> _handleSubmit(String title, String content) async {
    // Validate required prefix before submission
    if (_requirePrefix && (_selectedPrefixId == null || _selectedPrefixId!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)?.pleaseSelectPrefix ?? 'Please select a prefix',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          ),
          margin: DesignTokens.paddingS,
        ),
      );
      return false;
    }

    try {
      final topicProxy = SiteProxyFactory.getTopicProxy();
      final result = await topicProxy.newTopic(
        widget.forumId,
        title,
        content,
        prefixId: _selectedPrefixId, // Pass the selected prefix
        attachmentIds: _attachmentIds.isNotEmpty ? _attachmentIds : null,
        groupId: _groupId,
      );

      debugPrint('🔍 [NEW_TOPIC] Submit result:');
      debugPrint('   - result: ${result.result}');
      debugPrint('   - resultText: "${result.resultText}"');
      debugPrint('   - topicId: "${result.topicId}"');
      debugPrint('   - prefixId passed: "$_selectedPrefixId"');
      debugPrint('   - attachmentIds passed: $_attachmentIds');
      debugPrint('   - groupId passed: "$_groupId"');

      if (result.result) {
        return true;
      } else {
        // Server returned result=false with a message - throw it directly without wrapping
        // This allows the error handler to show the server's message cleanly
        final errorMessage = result.resultText?.trim();
        if (errorMessage != null && errorMessage.isNotEmpty) {
          throw Exception(errorMessage);
        } else {
          throw Exception('Failed to create topic');
        }
      }
    } catch (e) {
      // Only wrap if it's not already a clean server error message
      // Check if the exception message doesn't start with "Failed to create topic"
      final message = e.toString();
      if (message.startsWith('Exception: ') && !message.contains('Failed to create topic')) {
        // This is already a clean server message, re-throw as-is
        rethrow;
      } else {
        // Wrap other exceptions
        throw Exception('Failed to create topic: ${e.toString()}');
      }
    }
  }

  Future<String?> _handleFileUpload(XFile file) async {
    debugPrint('🔍 [NEW_TOPIC] _handleFileUpload called');
    debugPrint('🔍 [NEW_TOPIC] File details:');
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
          debugPrint('🔍 [NEW_TOPIC] Image optimized successfully');
        } catch (e) {
          debugPrint('❌ [NEW_TOPIC] Error optimizing image: $e');
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
      debugPrint('🔍 [NEW_TOPIC] Getting attachment proxy...');
      var attachmentProxy = SiteProxyFactory.getAttachmentProxy();
      // Use existing groupId if available, otherwise use empty string
      var groupId = _groupId ?? "";

      debugPrint('🔍 [NEW_TOPIC] Reading file bytes...');
      final fileBytes = await fileToUpload.readAsBytes();
      debugPrint('🔍 [NEW_TOPIC] File bytes read: ${fileBytes.length} bytes');

      debugPrint('🔍 [NEW_TOPIC] Calling uploadAttachmentAsync with:');
      debugPrint('   - type: "post"');
      debugPrint('   - id: "${widget.forumId}"');
      debugPrint('   - groupId: "$groupId"');
      debugPrint('   - attachmentName: "${fileToUpload.name}"');
      debugPrint('   - bytes length: ${fileBytes.length}');

      var uploadAttachmentResult = await attachmentProxy.uploadAttachmentAsync("post", widget.forumId, groupId, fileToUpload.name, fileBytes);

      debugPrint('🔍 [NEW_TOPIC] Upload result:');
      debugPrint('   - result: ${uploadAttachmentResult.result}');
      debugPrint('   - resultText: "${uploadAttachmentResult.resultText}"');
      debugPrint('   - attachmentId: "${uploadAttachmentResult.attachmentId}"');
      debugPrint('   - groupId: "${uploadAttachmentResult.groupId}"');

      if (uploadAttachmentResult.result) {
        debugPrint('✅ [NEW_TOPIC] File upload successful');

        // Store attachment ID and group ID
        if (uploadAttachmentResult.attachmentId != null && uploadAttachmentResult.attachmentId!.isNotEmpty) {
          setState(() {
            _attachmentIds.add(uploadAttachmentResult.attachmentId!);
            // Update groupId if provided (should be consistent across all uploads)
            if (uploadAttachmentResult.groupId != null && uploadAttachmentResult.groupId!.isNotEmpty) {
              _groupId = uploadAttachmentResult.groupId;
            }
          });
          debugPrint('✅ [NEW_TOPIC] Stored attachmentId: ${uploadAttachmentResult.attachmentId}');
          debugPrint('✅ [NEW_TOPIC] Current attachmentIds: $_attachmentIds');
          debugPrint('✅ [NEW_TOPIC] Current groupId: "$_groupId"');
          return uploadAttachmentResult.attachmentId;
        } else {
          debugPrint('⚠️ [NEW_TOPIC] Upload succeeded but attachmentId is null or empty');
          return null;
        }
      } else {
        debugPrint('❌ [NEW_TOPIC] File upload failed: ${uploadAttachmentResult.resultText}');
        throw Exception(uploadAttachmentResult.resultText ?? 'Failed to upload file');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [NEW_TOPIC] Exception in _handleFileUpload: $e');
      debugPrint('❌ [NEW_TOPIC] Stack trace: $stackTrace');
      throw Exception('Failed to create topic: ${e.toString()}');
    }
  }

  void _handlePrefixChanged(String? prefixId) {
    setState(() {
      _selectedPrefixId = prefixId;
    });
    debugPrint('🔍 [NEW_TOPIC] Prefix changed: "$prefixId"');
  }

  @override
  Widget build(BuildContext context) {
    return MessageComposePage(
      siteContext: widget.siteContext,
      title: AppLocalizations.of(context)?.newTopic ?? 'New Topic',
      showTitleField: true,
      titleHint: 'Write your topic title...',
      contentHint: 'Write your topic content...',
      onSubmit: _handleSubmit,
      onFileUpload: (widget.siteContext.loginDataOutput?.canUploadAttachment ?? false) ? _handleFileUpload : null,
      forumName: widget.forumName,
      prefixes: _availablePrefixes,
      requirePrefix: _requirePrefix,
      selectedPrefixId: _selectedPrefixId,
      isLoadingPrefixes: _isLoadingPrefixes,
      onRemoveAttachment: (attachmentId) async {
        // Remove the attachment ID from the list and call API to delete from server
        // Call API to remove attachment from server
        if (_groupId != null && _groupId!.isNotEmpty && widget.forumId.isNotEmpty) {
          try {
            var attachmentProxy = SiteProxyFactory.getAttachmentProxy();
            await attachmentProxy.removeAttachmentAsync(
              attachmentId,
              widget.forumId,
              _groupId!, // groupId is required for temporary attachments
              '', // postId is empty for new topics
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
      prefixError: _prefixError,
      onPrefixChanged: _handlePrefixChanged,
      showSignatureToggle: true,
      onError: (error) {
        if (context.mounted) {
          // Extract the clean message from the exception
          String errorMessage = error.toString();
          // Remove "Exception: " prefix if present
          if (errorMessage.startsWith('Exception: ')) {
            errorMessage = errorMessage.substring(11);
          }

          // Capture ScaffoldMessengerState to ensure dismiss button works correctly
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: DesignTokens.spacingM),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              ),
              margin: DesignTokens.paddingS,
              padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingL, vertical: DesignTokens.spacingL - DesignTokens.spacingXS),
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: AppLocalizations.of(context)?.dismiss ?? 'Dismiss',
                textColor: Theme.of(context).colorScheme.onErrorContainer,
                onPressed: () {
                  scaffoldMessenger.hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      },
    );
  }
}
