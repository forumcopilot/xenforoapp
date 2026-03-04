import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:forumcopilot_sdk/models/entities/fc_attachment.dart';
import 'cached_redirect_image.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

/// A carousel widget for displaying multiple image attachments
class AttachmentImageCarousel extends StatefulWidget {
  final List<FCAttachment> attachments;
  final Function(String imageUrl, BuildContext context, String heroTag)? onImageTap;
  final Function(BuildContext context)? onLoginRequired;

  const AttachmentImageCarousel({
    super.key,
    required this.attachments,
    this.onImageTap,
    this.onLoginRequired,
  });

  @override
  State<AttachmentImageCarousel> createState() => _AttachmentImageCarouselState();
}

class _AttachmentImageCarouselState extends State<AttachmentImageCarousel> {
  late ScrollController _scrollController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (widget.attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image count
          Row(
            children: [
              Icon(
                Icons.photo_library,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'Images (${widget.attachments.length})',
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              // Page indicator
              if (widget.attachments.length > 1) ...[
                Text(
                  '${_currentIndex + 1} / ${widget.attachments.length}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),

          // Image carousel with partial preview
          SizedBox(
            height: 200, // Fixed height for consistent layout
            child: widget.attachments.length == 1 ? _buildImageItem(widget.attachments[0], colorScheme) : _buildCarouselWithPartialViews(colorScheme),
          ),

          // Page dots indicator (only show if more than 1 image)
          if (widget.attachments.length > 1) ...[
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.attachments.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index ? colorScheme.primary : colorScheme.onSurfaceVariant.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCarouselWithPartialViews(ColorScheme colorScheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final itemWidth = screenWidth * 0.75; // Each item takes 75% of screen width
        final spacing = 16.0; // Space between items

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo is ScrollUpdateNotification) {
              final newIndex = ((scrollInfo.metrics.pixels + itemWidth / 2) / (itemWidth + spacing)).round();
              if (newIndex >= 0 && newIndex < widget.attachments.length && newIndex != _currentIndex) {
                setState(() {
                  _currentIndex = newIndex;
                });
              }
            }
            return false;
          },
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            itemCount: widget.attachments.length,
            itemBuilder: (context, index) {
              final attachment = widget.attachments[index];
              final isActive = index == _currentIndex;

              return Container(
                width: itemWidth,
                margin: EdgeInsets.only(
                  right: index < widget.attachments.length - 1 ? spacing : 0,
                ),
                child: AnimatedScale(
                  scale: isActive ? 1.0 : 0.95,
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedOpacity(
                    opacity: isActive ? 1.0 : 0.7,
                    duration: const Duration(milliseconds: 200),
                    child: _buildImageItem(attachment, colorScheme),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildImageItem(FCAttachment attachment, ColorScheme colorScheme) {
    // Prefer thumbnail for performance (smaller file size, faster loading)
    // Use full image only if thumbnail is not available
    final hasThumbnail = attachment.thumbnailUrl?.isNotEmpty == true;
    final imageUrl = hasThumbnail
        ? attachment.thumbnailUrl! // Prefer thumbnail for carousel preview
        : attachment.url; // Fall back to full image if no thumbnail
    final isUsingFullImage = !hasThumbnail && attachment.url.isNotEmpty;
    final isUsingThumbnail = hasThumbnail;

    // Debug: Print image URL selection
    if (kDebugMode) {
      AppLogger.debug('=== CAROUSEL IMAGE DEBUG ===');
      AppLogger.debug('Attachment: ${attachment.filename}');
      AppLogger.debug('Can View Full URL: ${attachment.canViewUrl}');
      AppLogger.debug('Thumbnail URL: ${attachment.thumbnailUrl}');
      AppLogger.debug('Full URL: ${attachment.url}');
      AppLogger.debug('Using full image: $isUsingFullImage');
      AppLogger.debug('Using thumbnail: $isUsingThumbnail');
      AppLogger.debug('Final image URL: $imageUrl');
      AppLogger.debug('============================');
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4), // Reduced margin since spacing is handled by ListView
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Image - try to load thumbnail even if flag says we can't
            Positioned.fill(
              child: GestureDetector(
                onTap: attachment.canViewUrl == true ? () => widget.onImageTap?.call(attachment.url, context, attachment.id) : () => widget.onLoginRequired?.call(context),
                child: CachedRedirectImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover, // Fill the square container
                  errorWidget: (context, error, stackTrace) {
                    // If thumbnail failed to load, show placeholder
                    return Container(
                      color: colorScheme.surfaceVariant.withOpacity(0.5),
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Lock overlay if can't view
            if (attachment.canViewUrl != true)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.lock,
                    size: 16,
                    color: colorScheme.onError,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
