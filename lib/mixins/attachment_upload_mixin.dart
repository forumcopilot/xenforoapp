import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/services/site_proxy_service.dart';
import 'package:forumcopilot_flutter/utils/file_picker_utils.dart';
import 'package:forumcopilot_flutter/utils/attachment_constraints_utils.dart';
import 'package:forumcopilot_flutter/utils/attachment_validation_utils.dart';
import 'package:forumcopilot_flutter/utils/image_optimization_utils.dart';
import 'package:forumcopilot_flutter/utils/file_utils.dart';
import 'package:forumcopilot_sdk/models/results/fc_attachment_result.dart';
import 'package:image_picker/image_picker.dart';

/// Mixin providing common attachment upload functionality
/// Can be used by pages that need to handle file uploads
mixin AttachmentUploadMixin<T extends StatefulWidget> on State<T> {
  /// List of attachments (XFile objects)
  List<XFile> get attachments;
  set attachments(List<XFile> value);

  /// List of uploaded attachment IDs
  List<String> get attachmentIds;
  set attachmentIds(List<String> value);

  /// Group ID for attachment management
  String? get groupId;
  set groupId(String? value);

  /// Upload state tracking
  bool get isUploading;
  set isUploading(bool value);

  /// Upload a file attachment
  /// [file] - The file to upload
  /// [type] - Type of upload ("post", "pm", etc.)
  /// [forumId] - Forum ID (required for posts, empty for PMs)
  /// [messageId] - Message ID (for PM replies, empty for new messages)
  /// Returns UploadData_Output with result and attachment information
  Future<FCAttachmentUploadResult> uploadAttachment(XFile file, String type, String forumId, String messageId) async {
    try {
      debugPrint('🔍 [ATTACHMENT_UPLOAD] Starting upload...');
      debugPrint('🔍 [ATTACHMENT_UPLOAD] XFile details:');
      debugPrint('   - file.path: "${file.path}"');
      debugPrint('   - file.name: "${file.name}"');
      debugPrint('   - type: $type');
      debugPrint('   - forumId: "$forumId"');
      debugPrint('   - messageId: "$messageId"');

      final attachmentProxy = SiteProxyService.getAttachmentProxy();
      final currentGroupId = groupId ?? "";
      debugPrint('🔍 [ATTACHMENT_UPLOAD] groupId: "$currentGroupId"');

      // Ensure we have a valid file name - extract from path if name is empty
      String fileName = file.name;
      debugPrint('🔍 [ATTACHMENT_UPLOAD] Initial fileName: "$fileName" (isEmpty: ${fileName.isEmpty})');

      if (fileName.isEmpty) {
        final path = file.path;
        debugPrint('🔍 [ATTACHMENT_UPLOAD] fileName is empty, checking path: "$path"');
        if (path.isNotEmpty) {
          fileName = path.split('/').last;
          debugPrint('🔍 [ATTACHMENT_UPLOAD] Extracted fileName from path: "$fileName"');
        } else {
          fileName = 'attachment';
          debugPrint('🔍 [ATTACHMENT_UPLOAD] Both name and path empty, using fallback: "$fileName"');
        }
      }

      debugPrint('🔍 [ATTACHMENT_UPLOAD] Reading file bytes...');
      final fileBytes = await file.readAsBytes();
      debugPrint('🔍 [ATTACHMENT_UPLOAD] File bytes read: ${fileBytes.length} bytes');

      debugPrint('🔍 [ATTACHMENT_UPLOAD] Calling uploadAttachmentAsync with:');
      debugPrint('   - type: $type');
      debugPrint('   - id: ${type == "pm" ? messageId : forumId}');
      debugPrint('   - groupId: "$currentGroupId"');
      debugPrint('   - attachmentName: "$fileName"');
      debugPrint('   - bytes length: ${fileBytes.length}');

      final uploadResult = await attachmentProxy.uploadAttachmentAsync(
        type,
        type == "pm" ? messageId : forumId, // Use messageId for PMs, forumId for posts
        currentGroupId,
        fileName,
        fileBytes,
      );

      debugPrint('🔍 [ATTACHMENT_UPLOAD] Upload result:');
      debugPrint('   - result: ${uploadResult.result}');
      debugPrint('   - resultText: "${uploadResult.resultText}"');
      debugPrint('   - attachmentId: "${uploadResult.attachmentId}"');
      debugPrint('   - fileName: "${uploadResult.fileName}"');

      return uploadResult;
    } catch (e, stackTrace) {
      debugPrint('❌ [ATTACHMENT_UPLOAD] Error uploading file: $e');
      debugPrint('❌ [ATTACHMENT_UPLOAD] Stack trace: $stackTrace');
      throw Exception('Failed to upload file: ${e.toString()}');
    }
  }

  /// Handle file attachment selection and upload
  /// [type] - Type of upload ("post", "pm", etc.)
  /// [forumId] - Forum ID (required for posts, empty for PMs)
  Future<void> handleFileAttachment(String type, String forumId) async {
    debugPrint('🔍 [HANDLE_FILE] handleFileAttachment called');
    debugPrint('   - type: $type');
    debugPrint('   - forumId: "$forumId"');
    debugPrint('   - isUploading: $isUploading');

    if (isUploading) {
      debugPrint('⚠️ [HANDLE_FILE] Already uploading, returning');
      return;
    }

    // Get constraints from SiteContext
    final siteContext = getCurrentSiteContext();
    final constraints = getAttachmentConstraintsFromSiteContext(siteContext);

    // Check attachment count limit before file selection
    if (!canAddMoreAttachments(attachments.length, constraints)) {
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

    debugPrint('🔍 [HANDLE_FILE] Calling FilePickerUtils.pickFile()...');
    final XFile? file = await FilePickerUtils.pickFile();

    debugPrint('🔍 [HANDLE_FILE] File picker returned: ${file != null ? "not null" : "null"}');
    if (file != null) {
      debugPrint('🔍 [HANDLE_FILE] Selected file:');
      debugPrint('   - file.path: "${file.path}"');
      debugPrint('   - file.name: "${file.name}"');

      // Hide keyboard when file is selected to focus on upload progress
      if (mounted) {
        FocusScope.of(context).unfocus();
      }

      // Validate file
      if (constraints != null) {
        final isImage = isImageFile(file.name);
        final validation = await validateFile(
          file,
          constraints,
          isImage,
          currentAttachmentCount: attachments.length,
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
        XFile fileToUpload = file;
        if (isImage && validation.needsOptimization) {
          // Optimize image
          setState(() {
            isUploading = true;
          });

          try {
            final optimizedFile = await optimizeImage(file, constraints);
            fileToUpload = optimizedFile;
            debugPrint('🔍 [HANDLE_FILE] Image optimized successfully');
          } catch (e) {
            debugPrint('❌ [HANDLE_FILE] Error optimizing image: $e');
            String errorMessage = _extractErrorMessage(e);
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
            setState(() {
              isUploading = false;
            });
            return;
          }
        }

        setState(() {
          isUploading = true;
        });

        try {
          debugPrint('🔍 [HANDLE_FILE] Starting upload...');
          final success = await uploadAttachment(fileToUpload, type, forumId, ""); // messageId is empty for new posts
          debugPrint('🔍 [HANDLE_FILE] Upload completed, result: ${success.result}');

          if (success.result) {
            debugPrint('🔍 [HANDLE_FILE] Upload successful, adding to attachments list');
            setState(() {
              attachments = [...attachments, fileToUpload];
            });
          } else {
            debugPrint('❌ [HANDLE_FILE] Upload failed: ${success.resultText}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success.resultText ?? 'Failed to upload file',
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
          }
        } catch (e, stackTrace) {
          debugPrint('❌ [HANDLE_FILE] Exception during upload: $e');
          debugPrint('❌ [HANDLE_FILE] Stack trace: $stackTrace');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  e.toString(),
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
        } finally {
          setState(() {
            isUploading = false;
          });
          debugPrint('🔍 [HANDLE_FILE] Upload process completed, isUploading set to false');
        }
      } else {
        // No constraints, proceed with upload directly
        setState(() {
          isUploading = true;
        });

        try {
          debugPrint('🔍 [HANDLE_FILE] Starting upload (no constraints)...');
          final success = await uploadAttachment(file, type, forumId, "");
          debugPrint('🔍 [HANDLE_FILE] Upload completed, result: ${success.result}');

          if (success.result) {
            debugPrint('🔍 [HANDLE_FILE] Upload successful, adding to attachments list');
            setState(() {
              attachments = [...attachments, file];
            });
          } else {
            debugPrint('❌ [HANDLE_FILE] Upload failed: ${success.resultText}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success.resultText ?? 'Failed to upload file',
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
          }
        } catch (e, stackTrace) {
          debugPrint('❌ [HANDLE_FILE] Exception during upload: $e');
          debugPrint('❌ [HANDLE_FILE] Stack trace: $stackTrace');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  e.toString(),
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
        } finally {
          setState(() {
            isUploading = false;
          });
          debugPrint('🔍 [HANDLE_FILE] Upload process completed, isUploading set to false');
        }
      }
    } else {
      debugPrint('🔍 [HANDLE_FILE] No file selected (user cancelled or error)');
    }
  }

  /// Handle image attachment selection and upload
  /// [type] - Type of upload ("post", "pm", etc.)
  /// [forumId] - Forum ID (required for posts, empty for PMs)
  /// [allowMultiple] - Whether to allow multiple image selection (default: false)
  Future<void> handleImageAttachment(String type, String forumId, {bool allowMultiple = false}) async {
    if (isUploading) return;

    // Get constraints from SiteContext
    final siteContext = getCurrentSiteContext();
    final constraints = getAttachmentConstraintsFromSiteContext(siteContext);

    // Check attachment count limit before file selection
    if (!canAddMoreAttachments(attachments.length, constraints)) {
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
    final remainingSlots = constraints != null && constraints.count != null && constraints.count! > 0 ? constraints.count! - attachments.length : null;

    List<XFile> selectedImages = [];
    if (allowMultiple) {
      // Pick multiple images
      selectedImages = await FilePickerUtils.pickMultiImage(
        imageQuality: ImageQuality.medium,
      );

      // Limit to remaining slots if there's a limit
      if (remainingSlots != null && selectedImages.length > remainingSlots) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Only ${remainingSlots} more attachment(s) allowed. Selecting first ${remainingSlots} image(s).',
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
    } else {
      // Pick single image
      final XFile? image = await FilePickerUtils.pickImage(
        imageQuality: ImageQuality.medium,
      );
      if (image != null) {
        selectedImages = [image];
      }
    }

    if (selectedImages.isNotEmpty) {
      // Hide keyboard when images are selected to focus on upload progress
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
      
      // Process each image
      for (final image in selectedImages) {
        // Check if we've reached the limit
        if (!canAddMoreAttachments(attachments.length, constraints)) {
          if (mounted && allowMultiple) {
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
        if (constraints != null) {
          final validation = await validateFile(
            image,
            constraints,
            true, // isImage = true
            currentAttachmentCount: attachments.length,
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
          XFile imageToUpload = image;
          if (validation.needsOptimization) {
            // Optimize image
            setState(() {
              isUploading = true;
            });

            try {
              final optimizedImage = await optimizeImage(image, constraints);
              imageToUpload = optimizedImage;
              debugPrint('🔍 [HANDLE_IMAGE] Image ${image.name} optimized successfully');
            } catch (e) {
              debugPrint('❌ [HANDLE_IMAGE] Error optimizing image ${image.name}: $e');
              String errorMessage = _extractErrorMessage(e);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${image.name}: $errorMessage',
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
              setState(() {
                isUploading = false;
              });
              continue; // Skip this image and continue with next
            }
          }

          setState(() {
            isUploading = true;
          });

          try {
            final success = await uploadAttachment(imageToUpload, type, forumId, ""); // messageId is empty for new posts
            if (success.result) {
              setState(() {
                attachments = [...attachments, imageToUpload];
              });
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${imageToUpload.name}: ${success.resultText ?? 'Failed to upload image'}',
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
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${imageToUpload.name}: ${e.toString()}',
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
          } finally {
            setState(() {
              isUploading = false;
            });
          }
        } else {
          // No constraints, proceed with upload directly
          setState(() {
            isUploading = true;
          });

          try {
            final success = await uploadAttachment(image, type, forumId, "");
            if (success.result) {
              setState(() {
                attachments = [...attachments, image];
              });
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${image.name}: ${success.resultText ?? 'Failed to upload image'}',
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
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${image.name}: ${e.toString()}',
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
          } finally {
            setState(() {
              isUploading = false;
            });
          }
        }
      }
    }
  }

  /// Remove an attachment at the specified index
  void removeAttachment(int index) {
    if (index >= 0 && index < attachments.length) {
      setState(() {
        attachments.removeAt(index);
      });
    }
  }

  /// Get upload function for MessageComposePage
  /// [type] - Type of upload ("post", "pm", etc.)
  /// [forumId] - Forum ID (required for posts, empty for PMs)
  Future<bool> Function(XFile) getUploadFunction(String type, String forumId) {
    return (XFile file) async {
      try {
        final result = await uploadAttachment(file, type, forumId, ""); // messageId is empty for new posts
        return result.result;
      } catch (e) {
        return false;
      }
    };
  }

  /// Extract clean error message from exception
  String _extractErrorMessage(dynamic error) {
    String errorMessage = error.toString();
    // Remove "Exception: " prefix if present
    if (errorMessage.startsWith('Exception: ')) {
      errorMessage = errorMessage.substring(11);
    }
    return errorMessage;
  }
}
