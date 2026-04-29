import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:forumcopilot_sdk/models/entities/fc_attachment_data.dart';

/// Optimization plan describing what changes will be made
class ImageOptimizationPlan {
  final bool needsResize;
  final int? originalWidth;
  final int? originalHeight;
  final int? targetWidth;
  final int? targetHeight;
  final bool needsFormatConversion;
  final String? originalFormat;
  final String? targetFormat;
  final bool needsCompression;
  final int originalSize;
  final int? estimatedSize;
  final int? quality;

  ImageOptimizationPlan({
    this.needsResize = false,
    this.originalWidth,
    this.originalHeight,
    this.targetWidth,
    this.targetHeight,
    this.needsFormatConversion = false,
    this.originalFormat,
    this.targetFormat,
    this.needsCompression = false,
    required this.originalSize,
    this.estimatedSize,
    this.quality,
  });
}

/// Main optimization function
/// Returns optimized XFile or throws an exception with detailed error message
Future<XFile> optimizeImage(
  XFile imageFile,
  FCAttachmentConstraints constraints,
) async {
  try {
    // Step 1: Load image to get dimensions
    final image = await loadImageFromFile(imageFile);
    final currentWidth = image.width;
    final currentHeight = image.height;

    // Step 2: Calculate if dimension resizing is needed
    bool needsDimensionResize = false;
    int targetWidth = currentWidth;
    int targetHeight = currentHeight;

    if (constraints.width != null &&
        constraints.width! > 0 &&
        currentWidth > constraints.width!) {
      needsDimensionResize = true;
      targetWidth = constraints.width!;
    }
    if (constraints.height != null &&
        constraints.height! > 0 &&
        currentHeight > constraints.height!) {
      needsDimensionResize = true;
      targetHeight = constraints.height!;
    }

    // Step 3: Calculate new dimensions maintaining aspect ratio
    if (needsDimensionResize) {
      double scaleFactor = 1.0;
      final widthLimit = constraints.width != null && constraints.width! > 0
          ? constraints.width!
          : null;
      final heightLimit = constraints.height != null && constraints.height! > 0
          ? constraints.height!
          : null;

      if (widthLimit != null && heightLimit != null) {
        // Both dimensions have limits - use the more restrictive one
        scaleFactor = (widthLimit / currentWidth).clamp(0.0, 1.0);
        final heightScale = (heightLimit / currentHeight).clamp(0.0, 1.0);
        scaleFactor = scaleFactor < heightScale ? scaleFactor : heightScale;
      } else if (widthLimit != null) {
        scaleFactor = (widthLimit / currentWidth).clamp(0.0, 1.0);
      } else if (heightLimit != null) {
        scaleFactor = (heightLimit / currentHeight).clamp(0.0, 1.0);
      }

      targetWidth = (currentWidth * scaleFactor).round();
      targetHeight = (currentHeight * scaleFactor).round();
    }

    // Step 4: Determine format conversion
    final extension = imageFile.path.split('.').last.toLowerCase();
    final jpgAllowed =
        constraints.extensions?.any((e) => e == 'jpg' || e == 'jpeg') == true;

    // Convert to JPG if:
    // 1. Original format is PNG/WebP/GIF/HEIC and JPG is allowed (size reduction or compatibility)
    // 2. Original format is not in allowed extensions but JPG is allowed (unsupported format)
    final isPng = extension == 'png';
    final isWebp = extension == 'webp';
    final isGif = extension == 'gif';
    final isHeic = extension == 'heic' || extension == 'heif';
    final isJpg = extension == 'jpg' || extension == 'jpeg';
    final isFormatSupported =
        constraints.extensions?.contains(extension) == true;

    final shouldConvertToJpg = jpgAllowed &&
        !isJpg &&
        (isPng || isWebp || isGif || isHeic || !isFormatSupported);

    // Step 5: Apply optimizations
    XFile optimizedFile = imageFile;

    // Resize if needed
    if (needsDimensionResize) {
      optimizedFile =
          await resizeImage(optimizedFile, targetWidth, targetHeight);
    }

    // Convert format if beneficial
    if (shouldConvertToJpg) {
      optimizedFile = await convertToJpg(optimizedFile, quality: 85);
    }

    // Compress if size still exceeds limit
    if (constraints.size != null && constraints.size! > 0) {
      final optimizedSize = await optimizedFile.length();
      if (optimizedSize > constraints.size!) {
        optimizedFile =
            await compressImageToSize(optimizedFile, constraints.size!);
      }
    }

    return optimizedFile;
  } on FileSystemException catch (e) {
    debugPrint('Error optimizing image (file system): $e');
    if (e.osError != null) {
      if (e.osError!.errorCode == 2) {
        throw Exception(
            'Image file not found. The file may have been moved or deleted.');
      } else if (e.osError!.errorCode == 13) {
        throw Exception('Permission denied. Cannot read the image file.');
      } else if (e.osError!.errorCode == 28) {
        throw Exception('Insufficient disk space to optimize the image.');
      }
    }
    throw Exception('Cannot access image file: ${e.message}');
  } on FormatException catch (e) {
    debugPrint('Error optimizing image (format): $e');
    throw Exception(
        'Image format is corrupted or not supported. Please try a different image.');
  } catch (e) {
    debugPrint('Error optimizing image: $e');
    final errorMessage = e.toString();

    // Provide user-friendly messages for common errors
    if (errorMessage.contains('Failed to resize image')) {
      throw Exception(
          'Failed to resize image. The image may be corrupted or in an unsupported format.');
    } else if (errorMessage.contains('Failed to convert image to JPG')) {
      throw Exception(
          'Failed to convert image to JPG format. The image may be corrupted.');
    } else if (errorMessage.contains('Failed to compress image')) {
      throw Exception(
          'Failed to compress image. There may be insufficient disk space or the image is corrupted.');
    } else if (errorMessage.contains('instantiateImageCodec')) {
      throw Exception(
          'Cannot decode image. The file may be corrupted or in an unsupported format.');
    } else if (errorMessage.contains('readAsBytes')) {
      throw Exception(
          'Cannot read image file. The file may have been moved or deleted.');
    } else {
      // Extract clean error message
      String cleanMessage = errorMessage;
      if (cleanMessage.startsWith('Exception: ')) {
        cleanMessage = cleanMessage.substring(11);
      }
      throw Exception('Failed to optimize image: $cleanMessage');
    }
  }
}

/// Load image from file for dimension checking
Future<ui.Image> loadImageFromFile(XFile file) async {
  try {
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  } on FileSystemException catch (e) {
    throw FileSystemException(
        'Cannot read image file: ${e.message}', e.path, e.osError);
  } on FormatException catch (e) {
    throw FormatException(
        'Image format is corrupted or not supported: ${e.message}');
  } catch (e) {
    if (e.toString().contains('instantiateImageCodec')) {
      throw FormatException(
          'Cannot decode image. The file may be corrupted or in an unsupported format.');
    }
    rethrow;
  }
}

/// Resize image maintaining aspect ratio
Future<XFile> resizeImage(XFile file, int maxWidth, int maxHeight) async {
  try {
    final tempDir = await getTemporaryDirectory();
    final originalBaseName = path.basenameWithoutExtension(file.path);
    final outputFormat = _outputFormatForPath(file.path);
    final outputExtension = _outputExtensionForFormat(outputFormat);
    final targetFileName = 'resized_$originalBaseName$outputExtension';
    final targetPath = '${tempDir.path}/$targetFileName';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      format: outputFormat,
      minWidth: maxWidth,
      minHeight: maxHeight,
      quality: 100, // Don't compress during resize, just resize
    );

    if (result == null) {
      throw Exception(
          'Failed to resize image. The image may be corrupted or in an unsupported format.');
    }

    return XFile(result.path, name: targetFileName);
  } on FileSystemException catch (e) {
    if (e.osError?.errorCode == 28) {
      throw Exception('Insufficient disk space to resize image.');
    }
    throw Exception('Cannot access file during resize: ${e.message}');
  } catch (e) {
    if (e is Exception && e.toString().contains('Failed to resize')) {
      rethrow;
    }
    throw Exception('Failed to resize image: $e');
  }
}

/// Convert image to JPG format
Future<XFile> convertToJpg(XFile file, {int quality = 85}) async {
  try {
    final tempDir = await getTemporaryDirectory();
    final originalName = path.basenameWithoutExtension(file.path);
    final targetPath = '${tempDir.path}/$originalName.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      format: CompressFormat.jpeg,
      quality: quality,
    );

    if (result == null) {
      throw Exception(
          'Failed to convert image to JPG. The image may be corrupted or in an unsupported format.');
    }

    return XFile(result.path, name: '$originalName.jpg');
  } on FileSystemException catch (e) {
    if (e.osError?.errorCode == 28) {
      throw Exception('Insufficient disk space to convert image.');
    }
    throw Exception('Cannot access file during conversion: ${e.message}');
  } catch (e) {
    if (e is Exception && e.toString().contains('Failed to convert')) {
      rethrow;
    }
    throw Exception('Failed to convert image to JPG: $e');
  }
}

/// Compress image to meet size limit
Future<XFile> compressImageToSize(XFile file, int maxSizeBytes) async {
  int quality = 85;
  XFile compressedFile = file;

  while (quality >= 60) {
    final currentSize = await compressedFile.length();
    if (currentSize <= maxSizeBytes) {
      break; // Size is acceptable
    }

    // Reduce quality
    quality -= 5;
    compressedFile = await compressImage(compressedFile, quality: quality);

    // If still too large and we can resize further
    final newSize = await compressedFile.length();
    if (newSize > maxSizeBytes && quality >= 60) {
      // Resize by 10% more
      final image = await loadImageFromFile(compressedFile);
      final newWidth = (image.width * 0.9).round();
      final newHeight = (image.height * 0.9).round();
      compressedFile = await resizeImage(compressedFile, newWidth, newHeight);
    }
  }

  return compressedFile;
}

/// Compress image with specified quality
Future<XFile> compressImage(XFile file, {required int quality}) async {
  try {
    final tempDir = await getTemporaryDirectory();
    final originalBaseName = path.basenameWithoutExtension(file.path);
    final outputFormat = _outputFormatForPath(file.path);
    final outputExtension = _outputExtensionForFormat(outputFormat);
    final targetFileName = 'compressed_$originalBaseName$outputExtension';
    final targetPath = '${tempDir.path}/$targetFileName';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      format: outputFormat,
      quality: quality,
    );

    if (result == null) {
      throw Exception(
          'Failed to compress image. The image may be corrupted or there may be insufficient disk space.');
    }

    return XFile(result.path, name: targetFileName);
  } on FileSystemException catch (e) {
    if (e.osError?.errorCode == 28) {
      throw Exception('Insufficient disk space to compress image.');
    }
    throw Exception('Cannot access file during compression: ${e.message}');
  } catch (e) {
    if (e is Exception && e.toString().contains('Failed to compress')) {
      rethrow;
    }
    throw Exception('Failed to compress image: $e');
  }
}

CompressFormat _outputFormatForPath(String filePath) {
  switch (path.extension(filePath).toLowerCase()) {
    case '.png':
      return CompressFormat.png;
    case '.webp':
      return CompressFormat.webp;
    case '.jpg':
    case '.jpeg':
      return CompressFormat.jpeg;
    default:
      return CompressFormat.jpeg;
  }
}

String _outputExtensionForFormat(CompressFormat format) {
  switch (format) {
    case CompressFormat.png:
      return '.png';
    case CompressFormat.webp:
      return '.webp';
    case CompressFormat.heic:
      return '.heic';
    case CompressFormat.jpeg:
      return '.jpg';
  }
}

/// Calculate optimization plan (what changes will be made)
Future<ImageOptimizationPlan> calculateOptimizationPlan(
  XFile file,
  FCAttachmentConstraints constraints,
) async {
  final image = await loadImageFromFile(file);
  final currentWidth = image.width;
  final currentHeight = image.height;
  final currentSize = await file.length();

  // Check if resizing is needed
  bool needsResize = false;
  int? targetWidth;
  int? targetHeight;

  if (constraints.width != null &&
      constraints.width! > 0 &&
      currentWidth > constraints.width!) {
    needsResize = true;
    targetWidth = constraints.width;
  }
  if (constraints.height != null &&
      constraints.height! > 0 &&
      currentHeight > constraints.height!) {
    needsResize = true;
    targetHeight = constraints.height;
  }

  if (needsResize) {
    double scaleFactor = 1.0;
    if (targetWidth != null && targetHeight != null) {
      scaleFactor = (targetWidth / currentWidth).clamp(0.0, 1.0);
      final heightScale = (targetHeight / currentHeight).clamp(0.0, 1.0);
      scaleFactor = scaleFactor < heightScale ? scaleFactor : heightScale;
    } else if (targetWidth != null) {
      scaleFactor = (targetWidth / currentWidth).clamp(0.0, 1.0);
    } else if (targetHeight != null) {
      scaleFactor = (targetHeight / currentHeight).clamp(0.0, 1.0);
    }

    targetWidth = (currentWidth * scaleFactor).round();
    targetHeight = (currentHeight * scaleFactor).round();
  }

  // Check if format conversion is needed
  final extension = file.path.split('.').last.toLowerCase();
  final jpgAllowed =
      constraints.extensions?.any((e) => e == 'jpg' || e == 'jpeg') == true;
  final isPng = extension == 'png';
  final isWebp = extension == 'webp';
  final isGif = extension == 'gif';
  final isHeic = extension == 'heic' || extension == 'heif';
  final isJpg = extension == 'jpg' || extension == 'jpeg';
  final isFormatSupported = constraints.extensions?.contains(extension) == true;

  final needsFormatConversion = jpgAllowed &&
      !isJpg &&
      (isPng || isWebp || isGif || isHeic || !isFormatSupported);

  // Check if compression is needed
  final needsCompression = constraints.size != null &&
      constraints.size! > 0 &&
      currentSize > constraints.size!;

  // Estimate final size (rough estimate)
  int? estimatedSize;
  if (needsResize || needsFormatConversion || needsCompression) {
    // Rough estimate: resizing reduces size proportionally, JPG conversion reduces by ~50-70%
    double sizeMultiplier = 1.0;
    if (needsResize && targetWidth != null && targetHeight != null) {
      final areaRatio =
          (targetWidth * targetHeight) / (currentWidth * currentHeight);
      sizeMultiplier *= areaRatio;
    }
    if (needsFormatConversion) {
      sizeMultiplier *= 0.6; // JPG is typically 60% of PNG size
    }
    if (needsCompression) {
      sizeMultiplier *= 0.85; // 85% quality compression
    }
    estimatedSize = (currentSize * sizeMultiplier).round();
  }

  return ImageOptimizationPlan(
    needsResize: needsResize,
    originalWidth: currentWidth,
    originalHeight: currentHeight,
    targetWidth: targetWidth,
    targetHeight: targetHeight,
    needsFormatConversion: needsFormatConversion,
    originalFormat: extension,
    targetFormat: needsFormatConversion ? 'jpg' : null,
    needsCompression: needsCompression,
    originalSize: currentSize,
    estimatedSize: estimatedSize,
    quality: needsCompression ? 85 : null,
  );
}
