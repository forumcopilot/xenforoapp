import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:forumcopilot_sdk/models/entities/fc_thread_posting.dart';
import 'package:forumcopilot_sdk/models/results/fc_topic_result.dart';
import 'package:forumcopilot_flutter/views/widgets/message_compose_page.dart';
import '../utils/snackbar_helper.dart';
import '../services/attachment_uploader.dart';
import 'widgets/thread_options_section.dart';

class NewTopicPage extends StatefulWidget {
  final SiteContext siteContext;
  final String forumId;
  final String forumName;

  /// The thread type, poll, custom fields and tags the forum takes
  /// (add-on 1.11.0+; null before, and for forums that take none).
  final FCThreadPostingOptions? postingOptions;

  const NewTopicPage({
    super.key,
    required this.siteContext,
    required this.forumId,
    required this.forumName,
    this.postingOptions,
  });

  @override
  State<NewTopicPage> createState() => _NewTopicPageState();
}

class _NewTopicPageState extends State<NewTopicPage> {
  // The topic's attachments, sent to this forum (node) whatever forum is
  // opened meanwhile.
  late final AttachmentUploader _uploader = AttachmentUploader(
    siteContext: widget.siteContext,
    kind: AttachmentKind.post,
    targetId: widget.forumId,
  );
  bool _sent = false;
  String? _selectedPrefixId;

  // Prefix-related state
  List<FCPrefix> _availablePrefixes = [];
  bool _requirePrefix = false;
  bool _isLoadingPrefixes = true;
  String? _prefixError;

  late final ThreadOptionsController? _threadOptions =
      widget.postingOptions == null ? null : ThreadOptionsController(widget.postingOptions!);

  @override
  void initState() {
    super.initState();
    _loadPrefixes();
  }

  @override
  void dispose() {
    // Closed without posting: the uploads are removed from the forum.
    _uploader.close(sent: _sent);
    _threadOptions?.dispose();
    super.dispose();
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

  /// The forum holds this topic for a moderator: say so, or it seems to vanish.
  void _showAwaitingApproval() {
    if (!mounted) return;
    SnackbarHelper.showInfo(context, AppLocalizations.of(context).postAwaitingApproval);
  }

  Future<bool> _handleSubmit(String title, String content) async {
    // Validate required prefix before submission
    if (_requirePrefix && (_selectedPrefixId == null || _selectedPrefixId!.isEmpty)) {
      SnackbarHelper.showError(context, AppLocalizations.of(context).pleaseSelectPrefix);
      return false;
    }

    // The thread type, poll, fields and tags the forum takes (the forum
    // checks them again)
    final threadOptions = _threadOptions;
    final missing = threadOptions?.validate(AppLocalizations.of(context));
    if (missing != null) {
      SnackbarHelper.showError(context, missing);
      return false;
    }

    try {
      final topicProxy = SiteProxyFactory.getTopicProxy();
      final result = await topicProxy.newTopic(
        widget.forumId,
        title,
        content,
        prefixId: _selectedPrefixId, // Pass the selected prefix
        attachmentIds: _uploader.attachmentIds.isNotEmpty ? _uploader.attachmentIds : null,
        groupId: _uploader.groupId,
        tags: threadOptions?.tags,
        customFields: threadOptions?.customFields,
        threadType: threadOptions?.threadTypeToSend,
        poll: threadOptions?.poll,
      );

      debugPrint('🔍 [NEW_TOPIC] Submit result:');
      debugPrint('   - result: ${result.result}');
      debugPrint('   - resultText: "${result.resultText}"');
      debugPrint('   - topicId: "${result.topicId}"');
      debugPrint('   - prefixId passed: "$_selectedPrefixId"');
      debugPrint('   - attachmentIds passed: ${_uploader.attachmentIds}');
      debugPrint('   - groupId passed: "${_uploader.groupId}"');

      if (result.result) {
        if (result.state == 1) _showAwaitingApproval();
        _sent = true;
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

  /// The composer has checked and shrunk the file.
  Future<String?> _handleFileUpload(XFile file) => _uploader.upload(file);

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
      title: AppLocalizations.of(context).newTopic,
      showTitleField: true,
      titleHint: AppLocalizations.of(context).writeYourTopicTitle,
      contentHint: AppLocalizations.of(context).writeYourTopicContent,
      onSubmit: _handleSubmit,
      onFileUpload: (widget.siteContext.loginDataOutput?.canUploadAttachment ?? false) ? _handleFileUpload : null,
      forumName: widget.forumName,
      optionsSection: _threadOptions == null ? null : ThreadOptionsSection(controller: _threadOptions),
      prefixes: _availablePrefixes,
      requirePrefix: _requirePrefix,
      selectedPrefixId: _selectedPrefixId,
      isLoadingPrefixes: _isLoadingPrefixes,
      onRemoveAttachment: _uploader.remove,
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

          SnackbarHelper.showError(context, errorMessage);
        }
      },
    );
  }
}
