import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'cached_redirect_image.dart';
import '../../utils/link_preview_cache.dart';
import '../../theme/design_tokens.dart';
import '../../l10n/generated/app_localizations.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';
import '../../utils/forum_links.dart';

class LinkPreviewCard extends StatefulWidget {
  final String url;
  final SiteContext siteContext;

  const LinkPreviewCard({
    super.key,
    required this.siteContext,
    required this.url,
  });

  @override
  State<LinkPreviewCard> createState() => _LinkPreviewCardState();
}

class _LinkPreviewCardState extends State<LinkPreviewCard> with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  LinkPreviewData? _previewData;
  String? _error;
  bool _shouldShow = true;
  bool _imageLoadFailed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Already resolved in this process? Show it in the first frame.
    final known = LinkPreviewCache.peek(widget.url);
    if (known != null) {
      _previewData = known;
      _isLoading = false;
      _shouldShow = true;
      return;
    }
    _fetchMetadata();
  }

  @override
  void didUpdateWidget(LinkPreviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only refetch if the URL actually changed
    if (oldWidget.url != widget.url && !_isLoading) {
      _fetchMetadata();
    }
  }

  Future<void> _fetchMetadata() async {
    try {
      AppLogger.debug('Fetching metadata for URL: ${widget.url}');

      // Use the cached link preview system
      final previewData = await LinkPreviewCache.fetchLinkPreview(widget.url);

      if (previewData != null) {
        AppLogger.debug('Retrieved preview data: title=${previewData.title}, domain=${previewData.domain}');

        if (mounted) {
          setState(() {
            _previewData = previewData;
            _isLoading = false;
            _shouldShow = true;
          });
        }
      } else {
        AppLogger.debug('No preview data available, hiding preview card');
        if (mounted) {
          setState(() {
            _shouldShow = false;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      AppLogger.debug('Error fetching metadata: $e');
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context).failedToLoadPreview('$e');
          _isLoading = false;
          _shouldShow = false;
        });
      }
    }
  }

  Future<void> _launchUrl() async {
    final cleanUrl = widget.url.trim().replaceAll('"', '');

    AppLogger.debug('LinkPreviewCard URL tapped: $cleanUrl');
    await ForumLinks.open(context, cleanUrl, widget.siteContext);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    if (!_shouldShow || _imageLoadFailed) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingXS),
        child: Center(
          child: SizedBox(
            width: DesignTokens.iconSizeS,
            height: DesignTokens.iconSizeS,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      AppLogger.debug('Showing error state: $_error');
      return Container(
        margin: EdgeInsets.only(top: DesignTokens.spacingS),
        padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacingM, vertical: DesignTokens.spacingS),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: DesignTokens.opacityLow),
            width: DesignTokens.borderWidthThin,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.link,
              size: DesignTokens.iconSizeS,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: DesignTokens.spacingS),
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
      );
    }

    return Container(
      margin: EdgeInsets.only(top: DesignTokens.spacingS),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: DesignTokens.opacityLow),
        borderRadius: BorderRadius.circular(DesignTokens.radiusS),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: DesignTokens.opacityLow),
          width: DesignTokens.borderWidthThin,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _launchUrl(),
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          child: Padding(
            padding: DesignTokens.paddingS,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_previewData?.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
                    child: CachedRedirectImage(
                      imageUrl: _previewData!.imageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      cacheWidth: (60 * MediaQuery.devicePixelRatioOf(context)).round(),
                      cacheHeight: (60 * MediaQuery.devicePixelRatioOf(context)).round(),
                      errorWidget: (context, error, stackTrace) {
                        // Defer setState to avoid calling it during build
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _imageLoadFailed = true;
                            });
                          }
                        });
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                const SizedBox(width: DesignTokens.spacingS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_previewData?.title != null)
                        Text(
                          _previewData!.title!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: DesignTokens.fontWeightMedium,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (_previewData?.description != null) ...[
                        SizedBox(height: 2),
                        Text(
                          _previewData!.description!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      SizedBox(height: DesignTokens.spacingXS),
                      Row(
                        children: [
                          Icon(
                            Icons.link,
                            size: DesignTokens.fontSizeXS,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: DesignTokens.spacingXS),
                          Text(
                            _previewData?.domain ?? widget.url,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.open_in_new_rounded,
                  size: DesignTokens.iconSizeM,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
