import 'package:flutter/material.dart';
import '../widgets/cached_redirect_image.dart';
import '../../utils/file_utils.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../l10n/generated/app_localizations.dart';

/// Unified attachment widget that can display both remote and local attachments
class AttachmentWidget extends StatelessWidget {
  final List<dynamic> attachments;
  final String title;
  final AttachmentActions? actions;
  final AttachmentDisplayMode displayMode;
  final bool showRemoveButton;
  final Function(int index)? onRemove;

  const AttachmentWidget({
    super.key,
    required this.attachments,
    this.title = 'Attachments',
    this.actions,
    this.displayMode = AttachmentDisplayMode.list,
    this.showRemoveButton = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.attach_file,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          ...attachments.asMap().entries.map((entry) {
            final index = entry.key;
            final attachment = entry.value;
            
            return _buildAttachmentItem(
              context, 
              attachment, 
              index,
              colorScheme, 
              textTheme,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(
    BuildContext context,
    dynamic attachment,
    int index,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final isLocalFile = attachment is XFile;
    final filename = isLocalFile ? attachment.name : attachment.filename;
    final url = isLocalFile ? null : attachment.url;
    final thumbnailUrl = isLocalFile ? null : attachment.thumbnailUrl;
    final contentType = isLocalFile ? null : attachment.contentType;
    final fileSize = isLocalFile ? null : attachment.fileSize;
    
    final isImage = isLocalFile 
        ? isImageFile(filename)
        : (contentType?.startsWith('image/') ?? false) || isImageFile(filename);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _getOnTapHandler(context, attachment, isImage, isLocalFile, url, filename),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                _buildThumbnail(
                  context,
                  attachment,
                  isImage,
                  isLocalFile,
                  thumbnailUrl,
                  url,
                  filename,
                  colorScheme,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFileInfo(
                    filename,
                    fileSize,
                    isLocalFile ? attachment : null,
                    textTheme,
                    colorScheme,
                  ),
                ),
                if (showRemoveButton) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => onRemove?.call(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                  ),
                ] else if (!isImage && url != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.download,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(
    BuildContext context,
    dynamic attachment,
    bool isImage,
    bool isLocalFile,
    String? thumbnailUrl,
    String? url,
    String filename,
    ColorScheme colorScheme,
  ) {
    final fileTypeColor = getFileTypeColor(filename);
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isImage 
            ? colorScheme.surfaceVariant.withOpacity(0.3)
            : fileTypeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: isImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: isLocalFile
                  ? Image.file(
                      File(attachment.path),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          getFileIcon(filename),
                          size: 24,
                          color: Colors.white,
                        );
                      },
                    )
                  : CachedRedirectImage(
                      imageUrl: thumbnailUrl?.isNotEmpty == true ? thumbnailUrl! : url!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorWidget: (context, error, stackTrace) {
                        return Icon(
                          getFileIcon(filename),
                          size: 24,
                          color: Colors.white,
                        );
                      },
                    ),
            )
          : Icon(
              getFileIcon(filename),
              size: 24,
              color: Colors.white,
            ),
    );
  }

  /// Builds a filename widget that ensures the file extension is always visible
  /// even when the filename is truncated with ellipsis.
  Widget _buildFilenameWithExtension(String filename, TextStyle style) {
    // Find the last dot to separate base name and extension
    final lastDotIndex = filename.lastIndexOf('.');
    
    // If no extension found, just display the filename normally
    if (lastDotIndex == -1 || lastDotIndex == filename.length - 1) {
      return Text(
        filename,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }
    
    // Split into base name and extension
    final baseName = filename.substring(0, lastDotIndex);
    final extension = filename.substring(lastDotIndex);
    
    // Use Row to ensure extension is always visible
    return Row(
      children: [
        Flexible(
          child: Text(
            baseName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        Text(
          extension,
          style: style,
        ),
      ],
    );
  }

  Widget _buildFileInfo(
    String filename,
    int? fileSize,
    XFile? localFile,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return FutureBuilder<String?>(
      future: localFile != null ? _getLocalFileSize(localFile) : Future.value(null),
      builder: (context, snapshot) {
        final displaySize = snapshot.data ?? 
            (fileSize != null ? formatFileSize(fileSize) : null);
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilenameWithExtension(
              filename,
              textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ) ?? const TextStyle(),
            ),
            if (displaySize != null) ...[
              const SizedBox(height: 2),
              Text(
                '${getFileType(filename)} • $displaySize',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<String> _getLocalFileSize(XFile file) async {
    final length = await file.length();
    return formatFileSize(length);
  }

  VoidCallback? _getOnTapHandler(
    BuildContext context,
    dynamic attachment,
    bool isImage,
    bool isLocalFile,
    String? url,
    String filename,
  ) {
    if (isImage && !isLocalFile) {
      return () => actions?.onShowImage?.call(url!, attachment.id);
    } else if (!isImage && !isLocalFile && url != null) {
      // Use callback if provided, otherwise use default download
      if (actions?.onDownload != null) {
        return () => actions!.onDownload!(url, filename);
      } else {
        return () => _downloadAttachment(context, url, filename);
      }
    }
    return null;
  }

  Future<void> _downloadAttachment(BuildContext context, String url, String filename) async {
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text('Downloading $filename...'),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      final filePath = await downloadFileToDownloads(url, filename);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        
        // On iOS, filePath will be empty after sharing
        if (filePath.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)?.openingShareSheet(filename) ?? 'Opening share sheet for $filename'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.primary,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          // Determine if file was saved to Downloads or Documents (fallback)
          final isInDownloads = filePath.contains('/Downloads/') || 
                               (filePath.contains('Downloads') && !filePath.contains('Containers'));
          final locationMessage = isInDownloads 
              ? 'File saved to Downloads: $filename'
              : 'File saved to Documents: $filename';
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(locationMessage),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.primary,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.errorDownloading(filename, e.toString()) ?? 'Error downloading $filename: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}

enum AttachmentDisplayMode {
  list,
  grid,
  compact,
}

class AttachmentActions {
  final Function(String url, String? attachmentId)? onShowImage;
  final Function(String url, String filename)? onDownload;

  AttachmentActions({
    this.onShowImage,
    this.onDownload,
  });
} 