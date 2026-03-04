import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forumcopilot_sdk/models/entities/fc_attachment_data.dart';
import 'file_utils.dart';

/// Result of file validation
class AttachmentValidationResult {
  final bool isValid;
  final String? errorMessage;
  final bool needsOptimization;
  final int? currentWidth;
  final int? currentHeight;
  final int currentSize;

  AttachmentValidationResult({
    required this.isValid,
    this.errorMessage,
    this.needsOptimization = false,
    this.currentWidth,
    this.currentHeight,
    required this.currentSize,
  });
}

/// Validates a file against attachment constraints
/// Returns validation result with details about whether file is valid and if optimization is needed
Future<AttachmentValidationResult> validateFile(
  XFile file,
  FCAttachmentConstraints? constraints,
  bool isImage, {
  int currentAttachmentCount = 0,
}) async {
  // If no constraints, file is valid (no restrictions)
  if (constraints == null) {
    final fileSize = await file.length();
    return AttachmentValidationResult(
      isValid: true,
      currentSize: fileSize,
    );
  }

  // 1. Check attachment count limit
  if (constraints.count != null && constraints.count! > 0) {
    if (currentAttachmentCount >= constraints.count!) {
      return AttachmentValidationResult(
        isValid: false,
        errorMessage: 'Maximum of ${constraints.count!} attachment(s) allowed per post/message',
        currentSize: await file.length(),
      );
    }
  }

  // 2. Check file extension
  final extension = file.name.split('.').last.toLowerCase();
  bool needsFormatConversion = false;
  
  if (constraints.extensions != null && constraints.extensions!.isNotEmpty) {
    if (!constraints.extensions!.contains(extension)) {
      // For images, check if we can convert to JPG
      if (isImage) {
        final jpgAllowed = constraints.extensions!.any((e) => e == 'jpg' || e == 'jpeg');
        if (jpgAllowed) {
          // Can convert unsupported image type to JPG
          needsFormatConversion = true;
        } else {
          // Cannot convert - JPG not allowed
          return AttachmentValidationResult(
            isValid: false,
            errorMessage: 'File type .$extension is not allowed. Allowed types: ${constraints.extensions!.join(', ')}',
            currentSize: await file.length(),
          );
        }
      } else {
        // Non-image file with unsupported extension - cannot convert
        return AttachmentValidationResult(
          isValid: false,
          errorMessage: 'File type .$extension is not allowed. Allowed types: ${constraints.extensions!.join(', ')}',
          currentSize: await file.length(),
        );
      }
    }
  }

  // 3. Check file size
  final fileSize = await file.length();
  bool needsSizeOptimization = false;
  if (constraints.size != null && constraints.size! > 0) {
    if (fileSize > constraints.size!) {
      if (isImage) {
        // Images can be optimized
        needsSizeOptimization = true;
      } else {
        // Non-images cannot be optimized
        return AttachmentValidationResult(
          isValid: false,
          errorMessage: 'File size (${formatFileSize(fileSize)}) exceeds maximum of ${formatFileSize(constraints.size!)})',
          currentSize: fileSize,
        );
      }
    }
  }

  // 4. For images, check dimensions and format
  bool needsDimensionOptimization = false;
  int? imageWidth;
  int? imageHeight;

  if (isImage) {
    try {
      // Load image to get dimensions
      final image = await _loadImageFromFile(file);
      imageWidth = image.width;
      imageHeight = image.height;

      // Check width limit
      if (constraints.width != null && constraints.width! > 0) {
        if (imageWidth > constraints.width!) {
          needsDimensionOptimization = true;
        }
      }

      // Check height limit
      if (constraints.height != null && constraints.height! > 0) {
        if (imageHeight > constraints.height!) {
          needsDimensionOptimization = true;
        }
      }

      // Check if format conversion would be beneficial (if not already needed due to unsupported extension)
      if (!needsFormatConversion && constraints.extensions != null) {
        final isPng = extension == 'png';
        final isWebp = extension == 'webp';
        final isGif = extension == 'gif';
        final isHeic = extension == 'heic' || extension == 'heif';
        final isJpg = extension == 'jpg' || extension == 'jpeg';
        final jpgAllowed = constraints.extensions!.any((e) => e == 'jpg' || e == 'jpeg');
        
        // Convert PNG/WebP/GIF/HEIC to JPG if JPG is allowed and it would reduce size
        // (Skip if already JPG)
        if (!isJpg && (isPng || isWebp || isGif || isHeic) && jpgAllowed) {
          needsFormatConversion = true;
        }
      }
    } catch (e) {
      // If we can't load the image, it might be corrupted
      // But we'll let the server handle this error
      debugPrint('Warning: Could not load image for validation: $e');
    }
  }

  // Determine if optimization is needed
  final needsOptimization = needsSizeOptimization || needsDimensionOptimization || needsFormatConversion;

  return AttachmentValidationResult(
    isValid: true,
    needsOptimization: needsOptimization,
    currentWidth: imageWidth,
    currentHeight: imageHeight,
    currentSize: fileSize,
  );
}

/// Quick check to see if more attachments can be added
bool canAddMoreAttachments(int currentCount, FCAttachmentConstraints? constraints) {
  if (constraints == null) {
    return true; // No constraints, unlimited
  }
  if (constraints.count == null || constraints.count == 0) {
    return true; // No limit
  }
  return currentCount < constraints.count!;
}

/// Load image from file to get dimensions
Future<ui.Image> _loadImageFromFile(XFile file) async {
  final bytes = await file.readAsBytes();
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
}
