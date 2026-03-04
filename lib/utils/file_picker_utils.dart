import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Platform-aware file picker utility
/// Uses file_picker for file selection (all platforms) and image_picker for image selection (mobile only)
class FilePickerUtils {
  /// Pick a file (any type) - uses file_picker on all platforms
  /// This allows iOS/Android users to select non-image files via the paperclip icon
  /// Returns null if user cancels or an error occurs
  static Future<XFile?> pickFile() async {
    try {
      debugPrint('🔍 [FILE_PICKER] Starting file picker...');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      debugPrint('🔍 [FILE_PICKER] File picker result: ${result != null ? "not null" : "null"}');
      
      if (result != null) {
        debugPrint('🔍 [FILE_PICKER] Files count: ${result.files.length}');
        
        if (result.files.isNotEmpty) {
          final platformFile = result.files.single;
          debugPrint('🔍 [FILE_PICKER] PlatformFile details:');
          debugPrint('   - name: "${platformFile.name}" (isEmpty: ${platformFile.name.isEmpty})');
          debugPrint('   - path: "${platformFile.path}" (isNull: ${platformFile.path == null})');
          debugPrint('   - size: ${platformFile.size}');
          debugPrint('   - extension: "${platformFile.extension}"');
          
          if (platformFile.path != null) {
            // Convert PlatformFile to XFile
            // Use name from PlatformFile if available, otherwise extract from path
            final fileName = platformFile.name.isNotEmpty 
                ? platformFile.name 
                : platformFile.path!.split('/').last;
            
            debugPrint('🔍 [FILE_PICKER] Creating XFile with:');
            debugPrint('   - path: "${platformFile.path}"');
            debugPrint('   - name: "$fileName"');
            
            final xFile = XFile(
              platformFile.path!,
              name: fileName,
            );
            
            debugPrint('🔍 [FILE_PICKER] XFile created successfully:');
            debugPrint('   - xFile.path: "${xFile.path}"');
            debugPrint('   - xFile.name: "${xFile.name}"');
            
            return xFile;
          } else {
            debugPrint('❌ [FILE_PICKER] PlatformFile.path is null!');
          }
        } else {
          debugPrint('❌ [FILE_PICKER] No files in result');
        }
      } else {
        debugPrint('🔍 [FILE_PICKER] User cancelled file selection');
      }
      return null;
    } catch (e, stackTrace) {
      debugPrint('❌ [FILE_PICKER] Error picking file: $e');
      debugPrint('❌ [FILE_PICKER] Stack trace: $stackTrace');
      return null;
    }
  }

  /// Pick an image - uses image_picker on mobile (for gallery access with quality settings),
  /// file_picker on desktop platforms
  /// Returns null if user cancels or an error occurs
  static Future<XFile?> pickImage({ImageQuality? imageQuality}) async {
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      // Use file_picker for desktop platforms
      try {
        debugPrint('🔍 [FILE_PICKER] Starting image picker for desktop platform...');
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );

        if (result != null && result.files.isNotEmpty) {
          final platformFile = result.files.single;
          debugPrint('🔍 [FILE_PICKER] Image selected: ${platformFile.name}');
          
          if (platformFile.path != null) {
            // Convert PlatformFile to XFile
            // Use name from PlatformFile if available, otherwise extract from path
            final fileName = platformFile.name.isNotEmpty 
                ? platformFile.name 
                : platformFile.path!.split('/').last;
            final xFile = XFile(
              platformFile.path!,
              name: fileName,
            );
            debugPrint('🔍 [FILE_PICKER] XFile created: ${xFile.path}');
            return xFile;
          } else {
            debugPrint('❌ [FILE_PICKER] PlatformFile.path is null');
          }
        } else {
          debugPrint('🔍 [FILE_PICKER] User cancelled image selection or no file selected');
        }
        return null;
      } catch (e, stackTrace) {
        debugPrint('❌ [FILE_PICKER] Error picking image: $e');
        debugPrint('❌ [FILE_PICKER] Stack trace: $stackTrace');
        return null;
      }
    } else {
      // Use image_picker for mobile platforms (iOS/Android) - provides better gallery integration
      // and image quality/compression options
      final ImagePicker picker = ImagePicker();
      try {
        return await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: imageQuality?.value,
        );
      } catch (e) {
        debugPrint('Error picking image: $e');
        return null;
      }
    }
  }

  /// Pick multiple images - uses image_picker on mobile (iOS 14+ / Android 4.3+),
  /// file_picker on desktop platforms
  /// Returns empty list if user cancels or an error occurs
  static Future<List<XFile>> pickMultiImage({ImageQuality? imageQuality}) async {
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      // Use file_picker for desktop platforms
      try {
        debugPrint('🔍 [FILE_PICKER] Starting multi-image picker for desktop platform...');
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: true,
        );

        if (result != null && result.files.isNotEmpty) {
          debugPrint('🔍 [FILE_PICKER] ${result.files.length} image(s) selected');
          
          return result.files
              .where((file) => file.path != null)
              .map((file) {
                // Use name from PlatformFile if available, otherwise extract from path
                final fileName = file.name.isNotEmpty 
                    ? file.name 
                    : file.path!.split('/').last;
                return XFile(
                  file.path!,
                  name: fileName,
                );
              })
              .toList();
        } else {
          debugPrint('🔍 [FILE_PICKER] User cancelled image selection or no files selected');
        }
        return [];
      } catch (e, stackTrace) {
        debugPrint('❌ [FILE_PICKER] Error picking images: $e');
        debugPrint('❌ [FILE_PICKER] Stack trace: $stackTrace');
        return [];
      }
    } else {
      // Use image_picker for mobile platforms (iOS/Android) - supports multiple selection
      // iOS: Requires iOS 14+ (uses PHPicker)
      // Android: Requires Android 4.3+ (API 18+)
      final ImagePicker picker = ImagePicker();
      try {
        final List<XFile>? images = await picker.pickMultiImage(
          imageQuality: imageQuality?.value,
        );
        if (images != null && images.isNotEmpty) {
          debugPrint('🔍 [FILE_PICKER] ${images.length} image(s) selected');
          
          // On iOS, copy images to temporary directory immediately to prevent access issues
          // iOS PHPicker provides temporary access that can become invalid after first read
          if (Platform.isIOS) {
            debugPrint('🔍 [FILE_PICKER] iOS detected - copying images to temp directory...');
            final List<XFile> copiedImages = [];
            final tempDir = await getTemporaryDirectory();
            
            // Create a unique subdirectory for this batch to avoid filename conflicts
            // while preserving original filenames
            final timestamp = DateTime.now().millisecondsSinceEpoch;
            final batchDir = Directory(path.join(tempDir.path, 'picked_images_$timestamp'));
            await batchDir.create(recursive: true);
            
            for (int i = 0; i < images.length; i++) {
              try {
                final originalImage = images[i];
                final bytes = await originalImage.readAsBytes();
                
                // Get original filename or generate one
                String originalFileName = originalImage.name;
                if (originalFileName.isEmpty) {
                  // Extract extension from path if available
                  final pathExtension = path.extension(originalImage.path);
                  originalFileName = 'image_$i${pathExtension.isNotEmpty ? pathExtension : '.jpg'}';
                }
                
                // Preserve original filename, only sanitize if needed for filesystem compatibility
                String safeFileName = originalFileName;
                // Only sanitize if filename contains invalid characters for filesystem
                if (safeFileName.contains(RegExp(r'[<>:"|?*\x00-\x1f]'))) {
                  safeFileName = safeFileName.replaceAll(RegExp(r'[<>:"|?*\x00-\x1f]'), '_');
                  debugPrint('🔍 [FILE_PICKER] Sanitized filename: "$originalFileName" -> "$safeFileName"');
                }
                
                // Use original filename in the unique subdirectory
                final tempPath = path.join(batchDir.path, safeFileName);
                
                // Handle duplicate filenames within the same batch
                String finalPath = tempPath;
                int counter = 1;
                while (await File(finalPath).exists()) {
                  final lastDotIndex = safeFileName.lastIndexOf('.');
                  final baseName = lastDotIndex > 0 
                      ? safeFileName.substring(0, lastDotIndex)
                      : safeFileName;
                  final extension = lastDotIndex > 0 
                      ? safeFileName.substring(lastDotIndex)
                      : '';
                  final newFileName = '${baseName}_$counter$extension';
                  finalPath = path.join(batchDir.path, newFileName);
                  counter++;
                }
                
                final tempFile = File(finalPath);
                await tempFile.writeAsBytes(bytes);
                
                // Preserve original filename in XFile.name property
                final copiedXFile = XFile(
                  finalPath,
                  name: originalFileName,
                );
                copiedImages.add(copiedXFile);
                debugPrint('🔍 [FILE_PICKER] Copied image $i: "$originalFileName" -> $finalPath');
              } catch (e) {
                debugPrint('❌ [FILE_PICKER] Error copying image $i: $e');
                // Continue with other images even if one fails
              }
            }
            
            if (copiedImages.isNotEmpty) {
              debugPrint('🔍 [FILE_PICKER] Successfully copied ${copiedImages.length} image(s) to temp directory');
              return copiedImages;
            } else {
              debugPrint('❌ [FILE_PICKER] Failed to copy any images to temp directory');
              // Clean up empty directory
              try {
                await batchDir.delete(recursive: true);
              } catch (_) {}
              return [];
            }
          }
          
          return images;
        } else {
          debugPrint('🔍 [FILE_PICKER] User cancelled or no images selected');
        }
        return [];
      } catch (e) {
        debugPrint('❌ [FILE_PICKER] Error picking multiple images: $e');
        return [];
      }
    }
  }

  /// Pick multiple files - uses file_picker on all platforms
  /// Returns empty list if user cancels or an error occurs
  static Future<List<XFile>> pickFiles({bool allowMultiple = true}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: allowMultiple,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files
            .where((file) => file.path != null)
            .map((file) {
              // Use name from PlatformFile if available, otherwise extract from path
              final fileName = file.name.isNotEmpty 
                  ? file.name 
                  : file.path!.split('/').last;
              return XFile(
                file.path!,
                name: fileName,
              );
            })
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error picking files: $e');
      return [];
    }
  }
}

/// Image quality enum for compatibility with image_picker
enum ImageQuality {
  low(50),
  medium(80),
  high(100);

  final int value;
  const ImageQuality(this.value);
}

