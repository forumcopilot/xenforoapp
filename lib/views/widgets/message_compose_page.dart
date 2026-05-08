import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../config/app_forum_config.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/models/results/fc_topic_result.dart';
import 'package:forumcopilot_sdk/models/entities/fc_attachment.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forumcopilot_flutter/views/user_search_page.dart';
import 'package:forumcopilot_flutter/utils/file_picker_utils.dart';
import 'package:forumcopilot_flutter/utils/attachment_constraints_utils.dart';
import 'package:forumcopilot_flutter/utils/attachment_validation_utils.dart';
import 'package:forumcopilot_flutter/utils/image_optimization_utils.dart';
import 'package:forumcopilot_flutter/views/widgets/cached_redirect_image.dart';
import 'dart:io';
import 'package:forumcopilot_flutter/utils/file_utils.dart';
import '../../theme/design_tokens.dart';

class MessageComposePage extends StatefulWidget {
  final SiteContext siteContext;
  final String title;
  final bool showTitleField;
  final bool requireTitle; // New parameter to control title requirement
  final String? initialContent;
  final Future<bool> Function(String title, String content) onSubmit;
  // Returns attachment ID on success, null on failure
  // If null, attachment upload buttons will be hidden
  final Future<String?> Function(XFile file)? onFileUpload;
  final String titleHint;
  final String contentHint;
  final bool showAppBar;
  final bool autoFocusContent;
  final String? forumName;
  final String? topicTitle;
  final void Function(Exception error)? onError;
  final TextEditingController? titleController;
  final TextEditingController? contentController;
  final dynamic Function(bool success)? onSuccess; // Optional callback to return custom value

  // Prefix-related parameters
  final List<FCPrefix>? prefixes;
  final bool requirePrefix;
  final String? selectedPrefixId;
  final bool isLoadingPrefixes;
  final String? prefixError;
  final ValueChanged<String?>? onPrefixChanged;

  // Existing attachments (from API)
  final List<FCAttachment>? existingAttachments;
  final Future<bool> Function(String attachmentId)? onRemoveExistingAttachment;

  // Callback when a newly uploaded attachment is removed (by attachment ID)
  // Returns Future to allow async operations (like API calls)
  final Future<void> Function(String attachmentId)? onRemoveAttachment;

  // Icon to display in the submit button (defaults to send icon)
  final IconData? submitIcon;

  // Show signature toggle for new topic editor
  final bool showSignatureToggle;

  const MessageComposePage({
    super.key,
    required this.siteContext,
    required this.title,
    required this.onSubmit,
    this.onFileUpload,
    this.showTitleField = false,
    this.requireTitle = true, // Default to true to maintain existing behavior
    this.initialContent,
    this.titleHint = 'Write your title...',
    this.contentHint = 'Write your content...',
    this.showAppBar = true,
    this.autoFocusContent = true,
    this.forumName,
    this.topicTitle,
    this.onError,
    this.titleController,
    this.contentController,
    this.onSuccess,
    this.prefixes,
    this.requirePrefix = false,
    this.selectedPrefixId,
    this.isLoadingPrefixes = false,
    this.prefixError,
    this.onPrefixChanged,
    this.existingAttachments,
    this.onRemoveExistingAttachment,
    this.onRemoveAttachment,
    this.submitIcon,
    this.showSignatureToggle = false,
  });

  @override
  State<MessageComposePage> createState() => _MessageComposePageState();
}

class _MessageComposePageState extends State<MessageComposePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();
  bool _isSubmitting = false;
  final List<XFile> _attachments = [];
  final Map<String, String> _fileToAttachmentId = {}; // Map file path to attachment ID
  final Map<String, bool> _uploadingFiles = {}; // Track which files are currently uploading (key: file path)
  final Set<String> _removedExistingAttachmentIds = {}; // Track removed existing attachments
  bool _isRemovingAttachment = false;
  bool _ownsTitleController = false;
  bool _ownsContentController = false;
  bool _isContentFieldFocused = false; // Track if content field has focus
  bool _includeSignature = true; // Default to enabled

  // Cache the attachment processing future to prevent reprocessing on rebuilds
  Future<List<Widget>>? _cachedAttachmentWidgetsFuture;
  String _cachedAttachmentsKey = ''; // Key to track when attachments change

  @override
  void initState() {
    super.initState();

    // Use external controllers if provided, otherwise create internal ones
    if (widget.titleController != null) {
      _titleController = widget.titleController!;
      _ownsTitleController = false;
    } else {
      _titleController = TextEditingController();
      _ownsTitleController = true;
    }

    if (widget.contentController != null) {
      _contentController = widget.contentController!;
      _ownsContentController = false;
    } else {
      _contentController = TextEditingController();
      _ownsContentController = true;
    }

    if (widget.initialContent != null) {
      _contentController.text = widget.initialContent!;
      _contentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _contentController.text.length),
      );
    }

    // Request focus after a short delay (only if auto-focus is enabled)
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      if (widget.showTitleField && widget.autoFocusContent) {
        // Only auto-focus title if autoFocusContent is true
        _titleFocusNode.requestFocus();
      } else if (widget.autoFocusContent) {
        // Auto-focus content if enabled
        _contentFocusNode.requestFocus();
      }
      // If autoFocusContent is false, don't focus anything
    });

    // Listen to focus changes
    _contentFocusNode.addListener(() {
      setState(() {
        _isContentFieldFocused = _contentFocusNode.hasFocus;
      });
    });
  }

  @override
  void didUpdateWidget(MessageComposePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update content if initialContent changed from null to a value (quote loaded)
    // Only update if controller is empty or contains the old initialContent
    if (widget.initialContent != null && widget.initialContent != oldWidget.initialContent) {
      // If old widget had no initialContent and new one does, or content matches old initialContent
      if (oldWidget.initialContent == null || _contentController.text == oldWidget.initialContent || _contentController.text.isEmpty) {
        _contentController.text = widget.initialContent!;
        _contentController.selection = TextSelection.fromPosition(
          TextPosition(offset: _contentController.text.length),
        );
      }
    }
  }

  @override
  void dispose() {
    // Only dispose controllers if we own them
    if (_ownsTitleController) {
      _titleController.dispose();
    }
    if (_ownsContentController) {
      _contentController.dispose();
    }
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _insertBBCode(String tag) {
    // Ensure the content field has focus before modifying
    if (!_contentFocusNode.hasFocus) {
      _contentFocusNode.requestFocus();
    }

    final TextEditingValue value = _contentController.value;
    final int start = value.selection.start;
    final int end = value.selection.end;

    // If start is -1, it means there's no valid cursor position
    if (start < 0) {
      // Append to the end if no cursor position
      final newText = '${value.text}[$tag][/$tag]';
      _contentController.value = TextEditingValue(
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

    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );

    // Ensure the field maintains focus after insertion
    _contentFocusNode.requestFocus();
  }

  /// Checks if a filename has an insertable image extension
  bool _isInsertableImage(String filename) {
    final extension = filename.split('.').last.toLowerCase();
    return ['gif', 'jpg', 'jpeg', 'jpe', 'pjpeg', 'png', 'ico', 'webp'].contains(extension);
  }

  /// Shows a dialog asking the user how to insert the image (thumbnail or full size)
  Future<String?> _showInsertImageDialog() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.insertImage ?? 'Insert Image'),
          content: Text(AppLocalizations.of(context)?.howWouldYouLikeToInsertImage ?? 'How would you like to insert this image?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('thumbnail'),
              child: Text(AppLocalizations.of(context)?.thumbnail ?? 'Thumbnail'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop('full'),
              child: Text(AppLocalizations.of(context)?.fullSize ?? 'Full Size'),
            ),
          ],
        );
      },
    );
  }

  /// Inserts attachment BBCode at the current cursor position
  void _insertAttachmentBBCode(String attachmentId, String insertType) {
    // Ensure content field has focus
    if (!_contentFocusNode.hasFocus) {
      _contentFocusNode.requestFocus();
    }

    final TextEditingValue value = _contentController.value;
    final int start = value.selection.start;
    final int end = value.selection.end;

    // Construct BBCode based on insert type
    final String bbcode = insertType == 'full' 
        ? '[ATTACH=full]$attachmentId[/ATTACH]'
        : '[ATTACH]$attachmentId[/ATTACH]';

    String newText;
    int cursorPosition;

    if (start < 0) {
      // No valid cursor position - append to end
      newText = '${value.text}$bbcode';
      cursorPosition = newText.length;
    } else {
      // Insert at cursor position (replacing selection if any)
      newText = value.text.replaceRange(start, end, bbcode);
      cursorPosition = start + bbcode.length;
    }

    // Update controller with new text and cursor position
    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );

    // Maintain focus
    _contentFocusNode.requestFocus();
  }

  void _handleFileUpload() async {
    if (widget.onFileUpload == null) return;
    try {
      // Get constraints from SiteContext
      final siteContext = getCurrentSiteContext();
      final constraints = getAttachmentConstraintsFromSiteContext(siteContext);

      // Check attachment count limit before file selection
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

      final XFile? file = await FilePickerUtils.pickFile();

      if (file != null && mounted) {
        // Hide keyboard when file is selected to focus on upload progress
        FocusScope.of(context).unfocus();
        
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
            return;
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
          }
        }

        // Add file to list immediately so user can see it
        setState(() {
          _attachments.add(fileToUpload);
          _uploadingFiles[fileToUpload.path] = true;
          // Clear cached future when adding attachment so it gets regenerated
          _cachedAttachmentWidgetsFuture = null;
          _cachedAttachmentsKey = '';
        });

        // Start upload in background
        try {
          final attachmentId = await widget.onFileUpload!(fileToUpload);

          if (attachmentId != null && attachmentId.isNotEmpty && mounted) {
            setState(() {
              _fileToAttachmentId[fileToUpload.path] = attachmentId;
              _uploadingFiles.remove(fileToUpload.path);
              // Clear cached future when updating attachment so it gets regenerated
              _cachedAttachmentWidgetsFuture = null;
              _cachedAttachmentsKey = '';
            });
          } else {
            // Remove file on failure
            setState(() {
              _attachments.removeWhere((f) => f.path == fileToUpload.path);
              _uploadingFiles.remove(fileToUpload.path);
              _cachedAttachmentWidgetsFuture = null;
              _cachedAttachmentsKey = '';
            });
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Failed to upload file. Please try again.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(8),
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          }
        } catch (e) {
          // Remove file on error
          setState(() {
            _attachments.removeWhere((f) => f.path == file.path);
            _uploadingFiles.remove(file.path);
            _cachedAttachmentWidgetsFuture = null;
            _cachedAttachmentsKey = '';
          });
          if (mounted) {
            // Extract clean error message
            String errorMessage = e.toString();
            if (errorMessage.startsWith('Exception: ')) {
              errorMessage = errorMessage.substring(11);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to upload file: $errorMessage',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                ),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(8),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to pick file',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
          ),
        );
      }
    }
  }

  void _handleImageUpload() async {
    if (widget.onFileUpload == null) return;
    try {
      // Get constraints from SiteContext
      final siteContext = getCurrentSiteContext();
      final constraints = getAttachmentConstraintsFromSiteContext(siteContext);

      // Check attachment count limit before file selection
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

      // Calculate how many images can still be added
      final remainingSlots = constraints != null && constraints.count != null && constraints.count! > 0 ? constraints.count! - _attachments.length : null;

      // Pick multiple images (iOS 14+ / Android 4.3+)
      List<XFile> selectedImages = await FilePickerUtils.pickMultiImage(
        imageQuality: ImageQuality.medium,
      );

      // Limit to remaining slots if there's a limit
      if (remainingSlots != null && selectedImages.length > remainingSlots) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Only ${remainingSlots} more attachment(s) allowed. Processing first ${remainingSlots} image(s).',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              margin: const EdgeInsets.all(8),
            ),
          );
        }
        selectedImages = selectedImages.take(remainingSlots).toList();
      }

      if (selectedImages.isNotEmpty && mounted) {
        // Hide keyboard when images are selected to focus on upload progress
        FocusScope.of(context).unfocus();
        
        // Process each image
        for (final image in selectedImages) {
          // Check if we've reached the limit
          if (!canAddMoreAttachments(_attachments.length, constraints)) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Attachment limit reached. Skipping remaining images.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  margin: const EdgeInsets.all(8),
                ),
              );
            }
            break;
          }

          // Validate image
          XFile imageToUpload = image;
          if (constraints != null) {
            final validation = await validateFile(
              image,
              constraints,
              true, // isImage = true
              currentAttachmentCount: _attachments.length,
            );

            if (!validation.isValid) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${image.name}: ${validation.errorMessage ?? 'Image validation failed'}',
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
              continue; // Skip this image and continue with next
            }

            // If optimization is needed, optimize automatically
            if (validation.needsOptimization) {
              // Optimize image
              try {
                final optimizedImage = await optimizeImage(image, constraints);
                imageToUpload = optimizedImage;
              } catch (e) {
                String errorMessage = e.toString();
                if (errorMessage.startsWith('Exception: ')) {
                  errorMessage = errorMessage.substring(11);
                }
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${image.name}: $errorMessage',
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
                continue; // Skip this image and continue with next
              }
            }
          }

          // Add file to list immediately so user can see it
          setState(() {
            _attachments.add(imageToUpload);
            _uploadingFiles[imageToUpload.path] = true;
            // Clear cached future when adding attachment so it gets regenerated
            _cachedAttachmentWidgetsFuture = null;
            _cachedAttachmentsKey = '';
          });

          // Start upload in background
          try {
            final attachmentId = await widget.onFileUpload!(imageToUpload);
            if (attachmentId != null && attachmentId.isNotEmpty && mounted) {
              setState(() {
                _fileToAttachmentId[imageToUpload.path] = attachmentId;
                _uploadingFiles.remove(imageToUpload.path);
                // Clear cached future when updating attachment so it gets regenerated
                _cachedAttachmentWidgetsFuture = null;
                _cachedAttachmentsKey = '';
              });
            } else {
              // Remove file on failure
              setState(() {
                _attachments.removeWhere((f) => f.path == imageToUpload.path);
                _uploadingFiles.remove(imageToUpload.path);
                _cachedAttachmentWidgetsFuture = null;
                _cachedAttachmentsKey = '';
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${imageToUpload.name}: Failed to upload image. Please try again.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(8),
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            }
          } catch (e) {
            // Remove file on error
            setState(() {
              _attachments.removeWhere((f) => f.path == imageToUpload.path);
              _uploadingFiles.remove(imageToUpload.path);
              _cachedAttachmentWidgetsFuture = null;
              _cachedAttachmentsKey = '';
            });
            if (mounted) {
              // Extract clean error message
              String errorMessage = e.toString();
              if (errorMessage.startsWith('Exception: ')) {
                errorMessage = errorMessage.substring(11);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${imageToUpload.name}: Failed to upload image: $errorMessage',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(8),
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to pick image',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
          ),
        );
      }
    }
  }

  Future<void> _removeAttachment(int index) async {
    if (index < 0 || index >= _attachments.length) {
      return;
    }

    final file = _attachments[index];
    final attachmentId = _fileToAttachmentId[file.path];

    setState(() {
      _attachments.removeAt(index);
      if (attachmentId != null) {
        _fileToAttachmentId.remove(file.path);
      }
      // Clear cached future when removing attachment so it gets regenerated
      _cachedAttachmentWidgetsFuture = null;
      _cachedAttachmentsKey = '';
    });

    // Notify parent to remove the corresponding attachment ID
    // This will call the API to remove it from the server
    if (widget.onRemoveAttachment != null) {
      if (attachmentId != null && attachmentId.isNotEmpty) {
        try {
          await widget.onRemoveAttachment!(attachmentId);
        } catch (e) {
          // Silently handle errors
        }
      }
    }
  }

  Future<void> _removeExistingAttachment(String attachmentId) async {
    if (_isRemovingAttachment) return;

    // Show confirmation dialog before removing
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.removeAttachment ?? 'Remove Attachment'),
          content: Text(
            AppLocalizations.of(context)?.areYouSureYouWantToRemoveThisAttachment ?? 'Are you sure you want to remove this attachment?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(AppLocalizations.of(context)?.delete ?? 'Delete'),
            ),
          ],
        );
      },
    );

    // If user cancelled, don't proceed
    if (confirmed != true) {
      return;
    }

    setState(() => _isRemovingAttachment = true);
    try {
      if (widget.onRemoveExistingAttachment != null) {
        final success = await widget.onRemoveExistingAttachment!(attachmentId);
        if (success && mounted) {
          setState(() {
            _removedExistingAttachmentIds.add(attachmentId);
          });
        } else if (mounted) {}
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to remove attachment: ${e.toString()}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRemovingAttachment = false);
      }
    }
  }

  Widget _buildAttachmentsList() {
    // Get existing attachments that haven't been removed
    final existingAttachments = widget.existingAttachments?.where((a) => !_removedExistingAttachmentIds.contains(a.id)).toList() ?? [];

    // Show section if we have either existing or new attachments
    if (existingAttachments.isEmpty && _attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
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
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            border: Border.all(
              color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityLow),
              width: DesignTokens.borderWidthThin,
            ),
          ),
          child: Column(
            children: [
              // Existing attachments from API
              ...existingAttachments.map((attachment) => _buildExistingAttachmentItem(attachment)),
              // New attachments (XFile)
              if (_attachments.isNotEmpty)
                Builder(
                  builder: (context) {
                    // Create a stable key based on attachments to detect changes
                    final attachmentsKey = '${_attachments.length}_${_attachments.map((a) => a.path).join('|')}';

                    // Only recreate the future if attachments have changed
                    if (_cachedAttachmentsKey != attachmentsKey || _cachedAttachmentWidgetsFuture == null) {
                      _cachedAttachmentsKey = attachmentsKey;
                      _cachedAttachmentWidgetsFuture = Future.wait(
                        _attachments.asMap().entries.map((entry) async {
                          final index = entry.key;
                          final attachment = entry.value;
                          debugPrint('   - Processing attachment $index: ${attachment.name}');
                          final fileSize = formatFileSize(await attachment.length());
                          final fileType = getFileType(attachment.name);
                          final isImage = isImageFile(attachment.name);
                          final isUploading = _uploadingFiles[attachment.path] ?? false;
                          final attachmentId = _fileToAttachmentId[attachment.path];

                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () async {
                                      if (attachmentId != null && _isInsertableImage(attachment.name)) {
                                        final result = await _showInsertImageDialog();
                                        if (result != null) {
                                          _insertAttachmentBBCode(attachmentId, result);
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: isImage ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow) : getFileTypeColor(attachment.name),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: isImage
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.file(
                                                      File(attachment.path),
                                                      width: 48,
                                                      height: 48,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Icon(
                                                          Icons.image,
                                                          size: 24,
                                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Icon(
                                                    getFileIcon(fileType),
                                                    size: 24,
                                                    color: Colors.white,
                                                  ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  attachment.name,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                        color: Theme.of(context).colorScheme.onSurface,
                                                      ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  isUploading
                                                      ? AppLocalizations.of(context)?.uploading ?? 'Uploading...'
                                                      : attachmentId != null
                                                          ? '$fileType • $fileSize • ${AppLocalizations.of(context)?.uploaded ?? 'Uploaded'}'
                                                          : '$fileType • $fileSize',
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                        color: isUploading ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              size: 20,
                                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            ),
                                            onPressed: isUploading ? null : () => _removeAttachment(index),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            splashRadius: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (isUploading)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingM),
                                  child: LinearProgressIndicator(
                                    minHeight: 2,
                                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                                  ),
                                ),
                            ],
                          );
                        }),
                      );
                    }

                    return FutureBuilder<List<Widget>>(
                      key: ValueKey('attachments_$_cachedAttachmentsKey'),
                      future: _cachedAttachmentWidgetsFuture!,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          debugPrint('   - Data count: ${snapshot.data?.length ?? 0}');
                        }
                        if (snapshot.hasError) {
                          debugPrint('   - Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          debugPrint('   - Showing loading indicator');
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          debugPrint('   - Showing error: ${snapshot.error}');
                          return Text('${AppLocalizations.of(context)?.error ?? 'Error'}: ${snapshot.error}');
                        }
                        debugPrint('   - Returning ${snapshot.data?.length ?? 0} attachment widgets');
                        return Column(
                          children: snapshot.data ?? [],
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExistingAttachmentItem(FCAttachment attachment) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final fileType = getFileType(attachment.filename);
    final fileSize = attachment.fileSizePrintable ?? formatFileSize(attachment.fileSize);
    final isImage = attachment.isImage;
    final isLoading = _isRemovingAttachment && _removedExistingAttachmentIds.contains(attachment.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            if (_isInsertableImage(attachment.filename)) {
              final result = await _showInsertImageDialog();
              if (result != null) {
                _insertAttachmentBBCode(attachment.id, result);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isImage && attachment.thumbnailUrl != null && attachment.thumbnailUrl!.isNotEmpty
                        ? colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow)
                        : getFileTypeColor(attachment.filename),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isImage && attachment.thumbnailUrl != null && attachment.thumbnailUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedRedirectImage(
                            imageUrl: attachment.thumbnailUrl!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorWidget: (context, error, stackTrace) {
                              return Icon(
                                getFileIcon(attachment.filename),
                                size: 24,
                                color: Colors.white,
                              );
                            },
                          ),
                        )
                      : Icon(
                          getFileIcon(attachment.filename),
                          size: 24,
                          color: Colors.white,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachment.filename,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '$fileType • $fileSize',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (isLoading) ...[
                            SizedBox(width: DesignTokens.spacingS),
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: isLoading ? null : () => _removeExistingAttachment(attachment.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureToggle() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SwitchListTile(
      title: Text(
        'Sent from ${AppForumConfig.forumName} mobile app',
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      value: _includeSignature,
      onChanged: (value) {
        setState(() {
          _includeSignature = value;
        });
      },
      activeColor: colorScheme.primary,
    );
  }

  Widget _buildPrefixSelector() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Don't show if no prefixes available and not loading
    if ((widget.prefixes == null || widget.prefixes!.isEmpty) && !widget.isLoadingPrefixes && widget.prefixError == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Prefix',
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: DesignTokens.fontWeightMedium,
              ),
            ),
            if (widget.requirePrefix) ...[
              SizedBox(width: DesignTokens.spacingXS),
              Text(
                '*',
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: DesignTokens.spacingS),
        if (widget.isLoadingPrefixes)
          SizedBox(
            height: 40,
            child: Center(
              child: SizedBox(
                width: DesignTokens.iconSizeM,
                height: DesignTokens.iconSizeM,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              ),
            ),
          )
        else if (widget.prefixError != null)
          Container(
            padding: DesignTokens.paddingM,
            decoration: BoxDecoration(
              color: colorScheme.errorContainer.withOpacity(DesignTokens.opacityLow),
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 20,
                  color: colorScheme.onErrorContainer,
                ),
                SizedBox(width: DesignTokens.spacingS),
                Expanded(
                  child: Text(
                    'Failed to load prefixes',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          )
        else if (widget.prefixes != null && widget.prefixes!.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // "None" option if prefix is not required
              if (!widget.requirePrefix)
                FilterChip(
                  label: Text(AppLocalizations.of(context)?.none ?? 'None'),
                  selected: widget.selectedPrefixId == null,
                  onSelected: (selected) {
                    if (widget.onPrefixChanged != null) {
                      // Always clear selection when "None" is clicked
                      if (selected) {
                        widget.onPrefixChanged!(null);
                      }
                    }
                  },
                  selectedColor: colorScheme.primaryContainer,
                  checkmarkColor: colorScheme.onPrimaryContainer,
                  labelStyle: textTheme.bodyMedium?.copyWith(
                    color: widget.selectedPrefixId == null ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
                  ),
                  backgroundColor: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                  side: BorderSide(
                    color: widget.selectedPrefixId == null ? colorScheme.primary : colorScheme.outlineVariant,
                    width: widget.selectedPrefixId == null ? DesignTokens.borderWidthThinMedium : DesignTokens.borderWidthThin,
                  ),
                ),
              // Available prefixes
              ...widget.prefixes!.map((prefix) {
                // Normalize prefix IDs for comparison (handle null, empty string, and whitespace)
                // Convert to string and trim for reliable comparison
                final currentPrefixId = widget.selectedPrefixId?.toString().trim();
                final prefixId = prefix.prefixId.toString().trim();
                final isSelected = currentPrefixId != null && currentPrefixId.isNotEmpty && currentPrefixId != 'null' && currentPrefixId == prefixId;
                return FilterChip(
                  label: Text(prefix.prefixDisplayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    // Always call the callback when a prefix chip is clicked
                    // FilterChip's onSelected receives the new state (true = selected, false = deselected)
                    if (widget.onPrefixChanged != null) {
                      if (selected) {
                        // Chip is being selected - set this prefix
                        // This allows users to change between prefixes even when required
                        widget.onPrefixChanged!(prefix.prefixId);
                      } else if (!widget.requirePrefix) {
                        // Chip is being deselected - clear selection (only if not required)
                        widget.onPrefixChanged!(null);
                      } else {
                        // Prefix is required, can't deselect - re-select it to maintain required state
                        widget.onPrefixChanged!(prefix.prefixId);
                      }
                    }
                  },
                  selectedColor: colorScheme.primaryContainer,
                  checkmarkColor: colorScheme.onPrimaryContainer,
                  labelStyle: textTheme.bodyMedium?.copyWith(
                    color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
                  ),
                  backgroundColor: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                  side: BorderSide(
                    color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
                    width: isSelected ? DesignTokens.borderWidthThinMedium : DesignTokens.borderWidthThin,
                  ),
                );
              }),
            ],
          ),
      ],
    );
  }

  void _handleMention() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSearchPage(
          siteContext: widget.siteContext,
          onUserSelected: (username, iconUrl) {
            final currentText = _contentController.text;
            final currentSelection = _contentController.selection;
            final beforeCursor = currentText.substring(0, currentSelection.start);
            final afterCursor = currentText.substring(currentSelection.end);
            final newText = '$beforeCursor@$username $afterCursor';
            _contentController.text = newText;
            _contentController.selection = TextSelection.fromPosition(
              TextPosition(offset: (beforeCursor.length + username.length + 2).toInt()), // +2 for @ and space
            );
            // Ensure the content field is focused after inserting the username
            _contentFocusNode.requestFocus();
          },
          selectedUsers: const [],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (widget.showTitleField && widget.requireTitle && _titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.pleaseEnterTitle ?? 'Please enter a title',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(8),
        ),
      );
      return;
    }

    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.pleaseEnterContent ?? 'Please enter some content',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(8),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      String content = _contentController.text.trim();
      
      // Append signature if enabled
      if (widget.showSignatureToggle && _includeSignature) {
        final signature = 'Sent from ${AppForumConfig.forumName} mobile app';
        // Add two line breaks before signature
        content = '$content\n\n$signature';
      }
      
      final success = await widget.onSubmit(
        _titleController.text.trim(),
        content,
      );

      if (mounted && success) {
        // Dismiss keyboard before navigating back
        FocusScope.of(context).unfocus();
        if (widget.onSuccess != null) {
          final result = widget.onSuccess!(true);
          Navigator.of(context).pop(result);
        } else {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        if (widget.onError != null) {
          widget.onError!(e as Exception);
        } else {
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
                      e.toString(),
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
      }
    } finally {
      // Only update state if it actually changed to avoid unnecessary rebuilds
      // This setState only rebuilds MessageComposePage, not parent widgets
      if (mounted && _isSubmitting) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _buildBottomToolbar() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
              // File attachment button - only show if onFileUpload is provided
              if (widget.onFileUpload != null)
                Semantics(
                  label: AppLocalizations.of(context)?.attachFile ?? 'Attach File',
                  hint: 'Attach a file to this message',
                  button: true,
                  child: IconButton(
                    icon: Icon(
                      Icons.attach_file,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    tooltip: AppLocalizations.of(context)?.attachFile ?? 'Attach File',
                    onPressed: _handleFileUpload,
                  ),
                ),
              // Image upload button - only show if onFileUpload is provided
              if (widget.onFileUpload != null)
                Semantics(
                  label: AppLocalizations.of(context)?.uploadImage ?? 'Upload Image',
                  hint: 'Upload an image to this message',
                  button: true,
                  child: IconButton(
                    icon: Icon(
                      Icons.image,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    tooltip: AppLocalizations.of(context)?.uploadImage ?? 'Upload Image',
                    onPressed: _handleImageUpload,
                  ),
                ),
              // BBCode button
              Semantics(
                label: AppLocalizations.of(context)?.formatting ?? 'Formatting',
                hint: 'Open formatting options',
                button: true,
                enabled: _isContentFieldFocused,
                child: PopupMenuButton<String>(
                  enabled: _isContentFieldFocused,
                  icon: Icon(Icons.format_bold, color: _isContentFieldFocused ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withOpacity(0.38)),
                  tooltip: AppLocalizations.of(context)?.formatting ?? 'Formatting',
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
              ),
              // Mention button
              IconButton(
                icon: Icon(Icons.alternate_email, color: _isContentFieldFocused ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withOpacity(0.38)),
                tooltip: AppLocalizations.of(context)?.mentionUser ?? 'Mention User',
                onPressed: _isContentFieldFocused ? _handleMention : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBackNavigation() {
    // Dismiss keyboard before navigating back (especially important on iOS)
    _titleFocusNode.unfocus();
    _contentFocusNode.unfocus();
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // Dismiss keyboard when back gesture/button is triggered
        // This handles iOS swipe-back and Android back button
        _titleFocusNode.unfocus();
        _contentFocusNode.unfocus();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: widget.showAppBar
            ? AppBar(
                title: Text(
                  widget.title,
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: DesignTokens.fontWeightMedium,
                  ),
                ),
                backgroundColor: colorScheme.surface,
                elevation: 3,
                shadowColor: colorScheme.shadow.withOpacity(DesignTokens.opacityLow),
                surfaceTintColor: colorScheme.surfaceTint,
                iconTheme: IconThemeData(
                  color: colorScheme.onSurface,
                ),
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: _handleBackNavigation,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: _isSubmitting
                        ? SizedBox(
                            width: DesignTokens.iconSizeL,
                            height: DesignTokens.iconSizeL,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onSurface,
                            ),
                          )
                        : Icon(widget.submitIcon ?? Icons.send_rounded, color: colorScheme.onSurface),
                    onPressed: _isSubmitting ? null : _submit,
                  ),
                  const SizedBox(width: DesignTokens.spacingS),
                ],
              )
            : null,
        body: GestureDetector(
          onTap: () {
            // Hide keyboard when tapping outside input fields
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: DesignTokens.paddingL,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (widget.forumName != null) ...[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)?.forum ?? 'Forum',
                                    style: textTheme.titleSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontWeight: DesignTokens.fontWeightMedium,
                                    ),
                                  ),
                                  SizedBox(height: DesignTokens.spacingS),
                                  Wrap(
                                    spacing: DesignTokens.spacingS,
                                    runSpacing: 8,
                                    children: [
                                      Chip(
                                        avatar: CircleAvatar(
                                          backgroundColor: colorScheme.primaryContainer,
                                          child: Icon(
                                            Icons.forum,
                                            size: 18,
                                            color: colorScheme.onPrimaryContainer,
                                          ),
                                        ),
                                        label: Text(widget.forumName!),
                                        backgroundColor: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                                        labelStyle: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurface,
                                        ),
                                        side: BorderSide(
                                          color: colorScheme.outlineVariant,
                                          width: DesignTokens.borderWidthThin,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: DesignTokens.spacingL),
                            ],
                            // Add prefix selector here
                            _buildPrefixSelector(),
                            if (widget.prefixes != null && widget.prefixes!.isNotEmpty) SizedBox(height: DesignTokens.spacingL),
                            if (widget.showTitleField)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Title',
                                    style: textTheme.titleSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontWeight: DesignTokens.fontWeightMedium,
                                    ),
                                  ),
                                  SizedBox(height: DesignTokens.spacingS),
                                  TextField(
                                    controller: _titleController,
                                    focusNode: _titleFocusNode,
                                    decoration: InputDecoration(
                                      hintText: widget.titleHint,
                                      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
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
                                      filled: true,
                                      fillColor: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                                      contentPadding: DesignTokens.paddingInput,
                                    ),
                                    style: textTheme.titleMedium?.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                    textCapitalization: TextCapitalization.sentences,
                                    enabled: !_isSubmitting,
                                  ),
                                ],
                              ),
                            if (widget.showTitleField) SizedBox(height: DesignTokens.spacingL),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)?.content ?? 'Content',
                                  style: textTheme.titleSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: DesignTokens.fontWeightMedium,
                                  ),
                                ),
                                SizedBox(height: DesignTokens.spacingS),
                                TextField(
                                  controller: _contentController,
                                  focusNode: _contentFocusNode,
                                  minLines: 10,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    hintText: widget.contentHint,
                                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
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
                                    filled: true,
                                    fillColor: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
                                    contentPadding: DesignTokens.paddingL,
                                  ),
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                  enabled: !_isSubmitting,
                                ),
                              ],
                            ),
                            SizedBox(height: DesignTokens.spacingL),
                            _buildAttachmentsList(),
                            if (widget.showSignatureToggle) ...[
                              SizedBox(height: DesignTokens.spacingL),
                              _buildSignatureToggle(),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (_isSubmitting)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
              _buildBottomToolbar(),
            ],
          ),
        ),
      ),
    );
  }
}
