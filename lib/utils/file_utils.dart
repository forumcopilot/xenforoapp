import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:forumcopilot_sdk/services/fc_http_client.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Returns a human-readable file type for a given filename or extension.
String getFileType(String filename) {
  final extension = filename.split('.').last.toLowerCase();
  switch (extension) {
    // Images
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
    case 'bmp':
    case 'webp':
    case 'svg':
    case 'heic':
    case 'heif':
      return 'Image';

    // Media
    case 'mp4':
    case 'mov':
    case 'avi':
    case 'wmv':
    case 'flv':
    case 'mkv':
    case 'webm':
      return 'Video';
    case 'mp3':
    case 'wav':
    case 'ogg':
    case 'm4a':
    case 'flac':
      return 'Audio';

    // Documents
    case 'pdf':
      return 'PDF';
    case 'doc':
    case 'docx':
      return 'Word';
    case 'xls':
    case 'xlsx':
      return 'Excel';
    case 'ppt':
    case 'pptx':
      return 'PowerPoint';
    case 'txt':
      return 'Text';

    // Archives
    case 'zip':
    case 'rar':
    case '7z':
    case 'tar':
    case 'gz':
      return 'Archive';

    default:
      // For unknown, return the extension in uppercase or 'File'
      if (extension.length <= 5) {
        return extension.toUpperCase();
      }
      return 'File';
  }
}

/// Returns a human-readable file size string for a given byte count.
String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024)
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}

/// Returns an appropriate icon for a given filename or file type string.
IconData getFileIcon(String filenameOrType) {
  final value = filenameOrType.toLowerCase();
  // Try to match by extension first
  final ext = value.contains('.') ? value.split('.').last : value;
  switch (ext) {
    // Images
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
    case 'bmp':
    case 'webp':
    case 'svg':
    case 'image':
      return Icons.image;
    // Video
    case 'mp4':
    case 'mov':
    case 'avi':
    case 'wmv':
    case 'flv':
    case 'mkv':
    case 'webm':
    case 'video':
      return Icons.videocam;
    // Audio
    case 'mp3':
    case 'wav':
    case 'ogg':
    case 'm4a':
    case 'flac':
    case 'audio':
      return Icons.audio_file;
    // Documents
    case 'pdf':
      return Icons.picture_as_pdf;
    case 'doc':
    case 'docx':
    case 'word':
      return Icons.description;
    case 'xls':
    case 'xlsx':
    case 'excel':
      return Icons.table_chart;
    case 'ppt':
    case 'pptx':
    case 'powerpoint':
      return Icons.slideshow;
    case 'txt':
    case 'text':
      return Icons.text_snippet;
    // Archives
    case 'zip':
    case 'rar':
    case '7z':
    case 'tar':
    case 'gz':
    case 'archive':
      return Icons.archive;
    default:
      return Icons.insert_drive_file;
  }
}

/// Returns an appropriate background color for a file type icon container.
/// Uses Material Design 3 color palette for consistent theming.
Color getFileTypeColor(String filenameOrType) {
  final value = filenameOrType.toLowerCase();
  // Try to match by extension first
  final ext = value.contains('.') ? value.split('.').last : value;
  switch (ext) {
    // Images - Material 3 Blue (primary)
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
    case 'bmp':
    case 'webp':
    case 'svg':
    case 'image':
      return const Color(0xFF1976D2); // Material 3 blue-700
    // Video - Material 3 Purple
    case 'mp4':
    case 'mov':
    case 'avi':
    case 'wmv':
    case 'flv':
    case 'mkv':
    case 'webm':
    case 'video':
      return const Color(0xFF7B1FA2); // Material 3 purple-700
    // Audio - Material 3 Teal (less bright than green)
    case 'mp3':
    case 'wav':
    case 'ogg':
    case 'm4a':
    case 'flac':
    case 'audio':
      return const Color(0xFF00897B); // Material 3 teal-600 (muted green)
    // Documents
    case 'pdf':
      return const Color(0xFFD32F2F); // Material 3 red-700
    case 'doc':
    case 'docx':
    case 'word':
      return const Color(0xFF1976D2); // Material 3 blue-700 (Word blue)
    case 'xls':
    case 'xlsx':
    case 'excel':
      return const Color(0xFF388E3C); // Material 3 green-700 (Excel green)
    case 'ppt':
    case 'pptx':
    case 'powerpoint':
      return const Color(0xFFFF5722); // Material 3 deep-orange-600 (PowerPoint)
    case 'txt':
    case 'text':
      return const Color(0xFF546E7A); // Material 3 blue-grey-600
    // Archives - Material 3 Orange
    case 'zip':
    case 'rar':
    case '7z':
    case 'tar':
    case 'gz':
    case 'archive':
      return const Color(0xFFF57C00); // Material 3 orange-700
    default:
      return const Color(0xFF616161); // Material 3 grey-700 (default)
  }
}

/// Returns true if the filename has an image file extension.
bool isImageFile(String filename) {
  final extension = filename.split('.').last.toLowerCase();
  return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'svg', 'heic', 'heif']
      .contains(extension);
}

/// Returns true if the filename or URL has a video file extension.
bool isVideoFile(String filenameOrUrl) {
  final uri = Uri.tryParse(filenameOrUrl);
  final source = uri?.path.isNotEmpty == true ? uri!.path : filenameOrUrl;
  final extension = source.split('.').last.toLowerCase();
  return ['mp4', 'mov', 'avi', 'wmv', 'flv', 'mkv', 'webm', 'm4v']
      .contains(extension);
}

/// Downloads a file from the given URL and saves it appropriately for each platform.
/// - iOS: Uses Share Sheet to let user save to Files app
/// - Android/macOS/Desktop: Saves to Downloads folder
/// Uses the app's cookie-aware HTTP client to ensure authentication cookies are included.
///
/// [url] - The URL of the file to download
/// [filename] - The desired filename for the downloaded file
///
/// Returns the path to the downloaded file (or empty string on iOS after sharing).
/// Throws an exception if the download fails.
Future<String> downloadFileToDownloads(String url, String filename) async {
  // iOS uses Share Sheet instead of direct file saving
  if (Platform.isIOS) {
    return _downloadFileIOS(url, filename);
  }
  try {
    final uri = Uri.parse(url);

    // Download the file using cookie-aware HTTP client
    final response = await FCHttpClient.get<List<int>>(
      uri,
      responseType: ResponseType.bytes,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to download file: HTTP ${response.statusCode}');
    }

    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw Exception('Downloaded file is empty');
    }

    // Get the Downloads directory
    Directory downloadDir;
    if (Platform.isAndroid) {
      // Check Android version to determine best approach
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      // On Android 10+ (API 29+), scoped storage prevents direct access to public Downloads
      // Use app's external storage instead (accessible via Files app, no permission needed)
      if (sdkInt >= 29) {
        // Android 10+: Use app's external storage (always accessible, no permission needed)
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          downloadDir = Directory('${externalDir.path}/Download');
        } else {
          downloadDir = await getApplicationDocumentsDirectory();
        }
      } else {
        // Android < 10: Try public Downloads directory first
        try {
          final possiblePaths = [
            '/storage/emulated/0/Download',
            '/sdcard/Download',
            '/storage/sdcard0/Download',
          ];

          Directory? foundDir;
          for (final path in possiblePaths) {
            final dir = Directory(path);
            if (await dir.exists()) {
              foundDir = dir;
              break;
            }
          }

          if (foundDir != null) {
            downloadDir = foundDir;
          } else {
            // Fallback to app's external storage
            final externalDir = await getExternalStorageDirectory();
            if (externalDir != null) {
              downloadDir = Directory('${externalDir.path}/Download');
            } else {
              downloadDir = await getApplicationDocumentsDirectory();
            }
          }
        } catch (e) {
          // If we can't access public Downloads, use app's external storage
          final externalDir = await getExternalStorageDirectory();
          downloadDir = externalDir ?? await getApplicationDocumentsDirectory();
        }
      }
    } else if (Platform.isMacOS) {
      // On macOS, try to use the user's Downloads folder
      // With the downloads.read-write entitlement, this should work
      final homeDir = Platform.environment['HOME'] ?? '';
      if (homeDir.isNotEmpty) {
        final downloadsPath = '$homeDir/Downloads';
        downloadDir = Directory(downloadsPath);

        // If Downloads doesn't exist, create it
        if (!await downloadDir.exists()) {
          try {
            await downloadDir.create(recursive: true);
          } catch (e) {
            // Can't create Downloads, fallback to Documents
            downloadDir = await getApplicationDocumentsDirectory();
          }
        }
      } else {
        downloadDir = await getApplicationDocumentsDirectory();
      }
    } else {
      // For other platforms (Windows, Linux), use Downloads if available
      // Otherwise fallback to Documents
      final homeDir = Platform.environment['HOME'] ??
          Platform.environment['USERPROFILE'] ??
          '';
      if (homeDir.isNotEmpty) {
        final downloadsPath =
            Platform.isWindows ? '$homeDir\\Downloads' : '$homeDir/Downloads';
        downloadDir = Directory(downloadsPath);
        if (!await downloadDir.exists()) {
          // Fallback to Documents if Downloads doesn't exist
          downloadDir = await getApplicationDocumentsDirectory();
        }
      } else {
        downloadDir = await getApplicationDocumentsDirectory();
      }
    }

    // Ensure the directory exists
    if (!await downloadDir.exists()) {
      try {
        await downloadDir.create(recursive: true);
      } catch (e) {
        // If we can't create the directory (e.g., permission denied on macOS),
        // fallback to Documents directory
        if (Platform.isMacOS) {
          downloadDir = await getApplicationDocumentsDirectory();
          if (!await downloadDir.exists()) {
            await downloadDir.create(recursive: true);
          }
        } else {
          rethrow;
        }
      }
    }

    // Sanitize filename to remove any invalid characters
    final sanitizedFilename = _sanitizeFilename(filename);
    final filePath = '${downloadDir.path}/$sanitizedFilename';

    // Handle filename conflicts by appending a number
    final file = File(filePath);
    if (await file.exists()) {
      int counter = 1;
      String newPath;
      final nameWithoutExt =
          sanitizedFilename.substring(0, sanitizedFilename.lastIndexOf('.'));
      final ext =
          sanitizedFilename.substring(sanitizedFilename.lastIndexOf('.'));

      do {
        newPath = '${downloadDir.path}/$nameWithoutExt ($counter)$ext';
        counter++;
      } while (await File(newPath).exists());

      try {
        await File(newPath).writeAsBytes(bytes);
        return newPath;
      } catch (e) {
        // If write fails (e.g., permission denied), try Documents directory
        if (Platform.isMacOS &&
            e.toString().contains('Operation not permitted')) {
          final documentsDir = await getApplicationDocumentsDirectory();
          final fallbackPath = '${documentsDir.path}/$sanitizedFilename';
          await File(fallbackPath).writeAsBytes(bytes);
          return fallbackPath;
        }
        rethrow;
      }
    } else {
      try {
        await file.writeAsBytes(bytes);
        return filePath;
      } catch (e) {
        // If write fails (e.g., permission denied), try Documents directory
        if (Platform.isMacOS &&
            e.toString().contains('Operation not permitted')) {
          final documentsDir = await getApplicationDocumentsDirectory();
          final fallbackPath = '${documentsDir.path}/$sanitizedFilename';
          await File(fallbackPath).writeAsBytes(bytes);
          return fallbackPath;
        }
        rethrow;
      }
    }
  } catch (e) {
    throw Exception('Failed to download file: $e');
  }
}

/// Downloads a file on iOS using the Share Sheet.
/// Users can choose "Save to Files" to save to the Files app.
Future<String> _downloadFileIOS(String url, String filename) async {
  try {
    final uri = Uri.parse(url);

    // Download the file using cookie-aware HTTP client
    final response = await FCHttpClient.get<List<int>>(
      uri,
      responseType: ResponseType.bytes,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to download file: HTTP ${response.statusCode}');
    }

    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw Exception('Downloaded file is empty');
    }

    // Save to temporary directory
    final tempDir = await getTemporaryDirectory();
    final sanitizedFilename = _sanitizeFilename(filename);
    final filePath = '${tempDir.path}/$sanitizedFilename';
    final file = File(filePath);

    await file.writeAsBytes(bytes);

    // Use Share Sheet to let user save to Files app
    await Share.shareXFiles(
      [XFile(filePath)],
      subject: filename,
    );

    // Return empty string since file location is determined by user's choice
    // The file in temp directory will be cleaned up by the system
    return '';
  } catch (e) {
    throw Exception('Failed to download file on iOS: $e');
  }
}

/// Sanitizes a filename by removing invalid characters for the current platform.
String _sanitizeFilename(String filename) {
  // Remove invalid characters based on platform
  String sanitized = filename;

  if (Platform.isWindows) {
    // Windows invalid characters: < > : " / \ | ? *
    sanitized = sanitized.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  } else {
    // Unix-like systems invalid characters: / and null
    sanitized = sanitized.replaceAll('/', '_').replaceAll('\x00', '_');
  }

  // Remove leading/trailing spaces and dots (Windows doesn't allow these)
  sanitized = sanitized.trim();
  if (Platform.isWindows) {
    sanitized = sanitized.replaceAll(RegExp(r'^\.+|\.+$'), '');
  }

  // Ensure filename is not empty
  if (sanitized.isEmpty) {
    sanitized = 'download_${DateTime.now().millisecondsSinceEpoch}';
  }

  return sanitized;
}
