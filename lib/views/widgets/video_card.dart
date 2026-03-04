import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/youtube_cache.dart';
import '../../utils/safe_image.dart';
import '../../theme/design_tokens.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class VideoCard extends StatefulWidget {
  final String url;

  const VideoCard({
    super.key,
    required this.url,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  bool _shouldShow = true;
  bool _showAsLink = false;
  YouTubePreviewData? _youtubeData;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchVideoData();
  }

  @override
  void didUpdateWidget(VideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only refetch if the URL actually changed
    if (oldWidget.url != widget.url && !_isLoading) {
      _fetchVideoData();
    }
  }

  Future<void> _fetchVideoData() async {
    try {
      AppLogger.debug('VideoCard: Initializing for URL: ${widget.url}');

      // Use the cached YouTube preview system
      final youtubeData = await YouTubeCache.fetchYouTubePreview(widget.url);

      if (youtubeData != null) {
        AppLogger.debug('VideoCard: Retrieved cached data: title=${youtubeData.videoTitle}, author=${youtubeData.authorName}');

        if (mounted) {
          setState(() {
            _youtubeData = youtubeData;
            _isLoading = false;
            _shouldShow = true;
            _showAsLink = false;
          });
        }
      } else {
        AppLogger.debug('VideoCard: No YouTube data available, showing as link');
        if (mounted) {
          setState(() {
            _isLoading = false;
            _showAsLink = true;
          });
        }
      }
    } catch (e) {
      AppLogger.debug('VideoCard: Error fetching video data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showAsLink = true;
        });
      }
    }
  }

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    if (!_shouldShow) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
        ),
      );
    }

    // Show as simple link if fallback is needed
    if (_showAsLink) {
      return Container(
        margin: EdgeInsets.only(top: DesignTokens.spacingS),
        padding: DesignTokens.paddingS,
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityLow),
            width: DesignTokens.borderWidthThin,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _launchUrl,
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            child: Row(
              children: [
                Icon(
                  Icons.video_library,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.url,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: DesignTokens.spacingS),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
        borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(DesignTokens.opacityLow),
          width: DesignTokens.borderWidthThin,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _launchUrl,
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          child: Padding(
            padding: DesignTokens.paddingS,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author info
                Row(
                  children: [
                    // Channel avatar or YouTube logo
                    if (_youtubeData?.authorAvatar != null && _youtubeData!.authorAvatar!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(DesignTokens.iconSizeM),
                        child: SafeImageNetwork.networkSafe(
                          _youtubeData!.authorAvatar!,
                          width: DesignTokens.iconSizeXL,
                          height: DesignTokens.iconSizeXL,
                          fit: BoxFit.cover,
                          fallbackIcon: Icons.play_arrow,
                        ),
                      )
                    else
                      Container(
                        width: DesignTokens.iconSizeXL,
                        height: DesignTokens.iconSizeXL,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(DesignTokens.iconSizeM),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: DesignTokens.iconSizeM,
                        ),
                      ),
                    const SizedBox(width: DesignTokens.spacingM),
                    // Author name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_youtubeData?.authorName != null && _youtubeData!.authorName!.isNotEmpty)
                            Text(
                              _youtubeData!.authorName!,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          Text(
                            'youtube.com',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Video title
                if (_youtubeData?.videoTitle != null && _youtubeData!.videoTitle!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    _youtubeData!.videoTitle!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                // Preview image if available
                if (_youtubeData?.previewImageUrl != null) ...[
                  const SizedBox(height: 8),
                  AspectRatio(
                    aspectRatio: 16 / 9, // YouTube standard aspect ratio
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
                        color: colorScheme.outlineVariant.withOpacity(0.2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SafeImageNetwork.networkSafe(
                              _youtubeData!.previewImageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              fallbackIcon: Icons.video_library,
                            ),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
