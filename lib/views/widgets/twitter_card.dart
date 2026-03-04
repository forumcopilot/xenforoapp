import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/twitter_cache.dart';
import '../../theme/design_tokens.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class TwitterCard extends StatefulWidget {
  final String url;

  const TwitterCard({
    super.key,
    required this.url,
  });

  @override
  State<TwitterCard> createState() => _TwitterCardState();
}

class _TwitterCardState extends State<TwitterCard> with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  bool _shouldShow = true;
  bool _showAsLink = false;
  TwitterPreviewData? _twitterData;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fetchTweetData();
  }

  @override
  void didUpdateWidget(TwitterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only refetch if the URL actually changed
    if (oldWidget.url != widget.url && !_isLoading) {
      _fetchTweetData();
    }
  }

  Future<void> _fetchTweetData() async {
    try {
      AppLogger.debug('TwitterCard: Initializing for URL: ${widget.url}');

      // Use the cached Twitter preview system
      final twitterData = await TwitterCache.fetchTwitterPreview(widget.url);

      if (twitterData != null) {
        AppLogger.debug('TwitterCard: Retrieved cached data: authorName=${twitterData.authorName}, handle=${twitterData.authorHandle}');

        if (mounted) {
          setState(() {
            _twitterData = twitterData;
            _isLoading = false;
            _shouldShow = true;
            _showAsLink = false;
          });
        }
      } else {
        AppLogger.debug('TwitterCard: No Twitter data available, showing as link');
        if (mounted) {
          setState(() {
            _isLoading = false;
            _showAsLink = true;
          });
        }
      }
    } catch (e) {
      AppLogger.debug('TwitterCard: Error fetching tweet data: $e');
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

    // Show as simple link if API failed or URL doesn't match pattern
    if (_showAsLink) {
      return Container(
        margin: DesignTokens.paddingVerticalS,
        child: InkWell(
          onTap: _launchUrl,
          borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: DesignTokens.spacingXS),
            child: Text(
              widget.url,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
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
                    // X (Twitter) logo
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: DesignTokens.iconSizeM,
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingM),
                    // Author name and handle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _twitterData?.authorName ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: DesignTokens.fontWeightSemiBold,
                            ),
                          ),
                          if (_twitterData?.authorHandle != null)
                            Text(
                              '@${_twitterData!.authorHandle}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Tweet text
                if (_twitterData?.tweetText != null && _twitterData!.tweetText!.isNotEmpty) ...[
                  SizedBox(height: DesignTokens.spacingS),
                  Text(
                    _twitterData!.tweetText!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
