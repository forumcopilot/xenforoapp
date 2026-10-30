import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/design_tokens.dart';
import '../../utils/embed_links.dart';
import 'embed_cards.dart';

/// A video in a BBCode post (`[MEDIA=youtube]`, `[VIDEO]`) or a video link
/// shown under a post: the video card Flapp and the Discourse app draw
/// ([EmbedVideoCard]), with the title, channel name and picture it showed
/// before. An address no video site matches stays a link.
class VideoCard extends StatelessWidget {
  final String url;

  const VideoCard({
    super.key,
    required this.url,
  });

  /// The embed for [url]: a video address, or a bare YouTube id as
  /// `[MEDIA=youtube]id[/MEDIA]` carries it.
  static EmbedLink? linkFor(String url) {
    final clean = url.trim().replaceAll('"', '');
    final address = RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(clean) ? 'https://www.youtube.com/watch?v=$clean' : clean;
    return EmbedLink.fromUrl(address);
  }

  Future<void> _launchUrl() async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final link = linkFor(url);
    if (link != null) {
      return Padding(
        padding: const EdgeInsets.only(top: DesignTokens.spacingS),
        child: EmbedVideoCard(link: link),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: DesignTokens.spacingS),
      padding: DesignTokens.paddingS,
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
          onTap: _launchUrl,
          borderRadius: BorderRadius.circular(DesignTokens.radiusS),
          child: Row(
            children: [
              Icon(Icons.video_library, size: 16, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  url,
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
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
}
