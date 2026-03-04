import 'package:flutter/material.dart';
import '../widgets/cached_redirect_image.dart';
import '../../utils/file_utils.dart';

/// Mock attachment class to bridge BBCode attributes with AttachmentItemWidget
class MockAttachment {
  final String id;
  final String filename;
  final String contentType;
  final int fileSize;
  final String url;
  final String? thumbnailUrl;
  final bool isImage;
  final bool canViewUrl;
  final bool canViewThumbnailUrl;

  MockAttachment({
    required this.id,
    required this.filename,
    required this.contentType,
    required this.fileSize,
    required this.url,
    this.thumbnailUrl,
    required this.isImage,
    required this.canViewUrl,
    required this.canViewThumbnailUrl,
  });
}

/// A reusable widget for rendering individual attachment items
/// This can be used by both PostListItemAttachment and InlineAttachmentTag
class AttachmentItemWidget extends StatelessWidget {
  final dynamic attachment;
  final VoidCallback? onTap;
  final bool showDownloadIcon;
  final bool isInline;

  const AttachmentItemWidget({
    super.key,
    required this.attachment,
    this.onTap,
    this.showDownloadIcon = true,
    this.isInline = false,
  });

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
    
    // Use RichText to ensure extension is always visible
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isImage = isImageFile(attachment.filename);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isImage
                        ? colorScheme.surfaceVariant.withOpacity(0.3)
                        : getFileTypeColor(attachment.filename),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      // Main content
                      isImage
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedRedirectImage(
                                // Use thumbnail if available, otherwise use full image (similar to carousel)
                                // Don't check canViewThumbnailUrl - just try to use thumbnail if it exists
                                imageUrl: attachment.thumbnailUrl?.isNotEmpty == true
                                    ? attachment.thumbnailUrl!
                                    : attachment.url,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorWidget: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      getFileIcon(attachment.filename),
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Icon(
                                getFileIcon(attachment.filename),
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                      // Lock icon overlay if can't view URL (for all attachment types)
                      if (attachment.canViewUrl != true)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: colorScheme.error.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.lock,
                              size: 12,
                              color: colorScheme.onError,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFilenameWithExtension(
                          attachment.filename,
                          textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ) ?? const TextStyle(),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${getFileType(attachment.filename)} • ${formatFileSize(attachment.fileSize)}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isImage && !isInline && showDownloadIcon && attachment.canViewUrl == true) ...[
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
}
