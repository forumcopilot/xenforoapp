import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/design_tokens.dart';
import '../../utils/embed_links.dart';
import '../../utils/link_preview_cache.dart';
import '../../utils/youtube_cache.dart';
import 'cached_redirect_image.dart';

/// A video embed as Flapp and the Discourse app draw it: the video's
/// picture at 16:9 (9:16 for TikTok and Shorts), its title over the top of
/// the picture, the site's play button in the middle. Tapping opens the
/// video, in the site's app where there is one. Adapted from flarum_ui's
/// lib/src/render/embed_cards.dart (_VideoPreview, _PlayBadge).
///
/// The title comes from YouTubeCache for YouTube, with the channel's name
/// and picture, and from the page's own preview (LinkPreviewCache) for the
/// other sites.
class EmbedVideoCard extends StatefulWidget {
  const EmbedVideoCard({super.key, required this.link, this.onOpen});

  final EmbedLink link;

  /// Opens the video; by default the platform opens the address.
  final void Function(String url)? onOpen;

  /// The radius every card in a post uses.
  static const double radius = DesignTokens.radiusM;

  @override
  State<EmbedVideoCard> createState() => _EmbedVideoCardState();
}

class _EmbedVideoCardState extends State<EmbedVideoCard> with AutomaticKeepAliveClientMixin {
  late EmbedLink _link;
  String? _channel;
  String? _channelAvatar;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _link = widget.link;
    _lookUp();
  }

  @override
  void didUpdateWidget(EmbedVideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.link.url != widget.link.url) {
      _link = widget.link;
      _channel = null;
      _channelAvatar = null;
      _lookUp();
    }
  }

  /// The title (and for YouTube the channel) for an embed that came without
  /// one: from memory in the first frame when this run already has it.
  void _lookUp() {
    if (_link.title != null) return;
    final url = _link.url;
    final id = _link.youtubeId;
    if (id != null) {
      final watch = 'https://www.youtube.com/watch?v=$id';
      final known = YouTubeCache.peek(watch);
      if (known != null) {
        _applyYouTube(known);
        return;
      }
      unawaited(YouTubeCache.fetchYouTubePreview(watch).then((data) {
        if (!mounted || data == null || _link.url != url) return;
        setState(() => _applyYouTube(data));
      }));
      return;
    }
    final known = LinkPreviewCache.peek(url);
    if (known != null) {
      _applyPage(known);
      return;
    }
    unawaited(LinkPreviewCache.fetchLinkPreview(url).then((data) {
      if (!mounted || data == null || _link.url != url) return;
      setState(() => _applyPage(data));
    }));
  }

  void _applyYouTube(YouTubePreviewData data) {
    _link = _link.copyWith(
      title: _nonEmpty(data.videoTitle),
      thumbnailUrl: _link.thumbnailUrl ?? _nonEmpty(data.previewImageUrl),
    );
    _channel = _nonEmpty(data.authorName);
    _channelAvatar = _nonEmpty(data.authorAvatar);
  }

  void _applyPage(LinkPreviewData data) {
    // A page that only names the site (a player page refusing the request)
    // says nothing the play button doesn't.
    final title = _nonEmpty(data.title);
    _link = _link.copyWith(
      title: title == null || title.toLowerCase() == _link.provider.name.toLowerCase() ? null : title,
      thumbnailUrl: _link.thumbnailUrl ?? _nonEmpty(data.imageUrl),
    );
  }

  static String? _nonEmpty(String? s) {
    final t = s?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  Future<void> _open() async {
    final url = _link.url;
    if (widget.onOpen != null) {
      widget.onOpen!(url);
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin
    final link = _link;
    final provider = link.provider;
    final thumbnail = link.thumbnailUrl;
    final title = link.title;
    final textTheme = Theme.of(context).textTheme;
    final dpr = MediaQuery.devicePixelRatioOf(context);

    // No picture: black, naming the site under the play button unless the
    // title bar already does.
    Widget placeholder() => ColoredBox(
          color: Colors.black,
          child: title != null
              ? null
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 72),
                    child: Text(provider.name, style: textTheme.bodySmall?.copyWith(color: Colors.white70)),
                  ),
                ),
        );

    // The channel, then the site: what the card named before it drew the
    // picture this way.
    final byline = [if (_channel != null) _channel!, provider.name].join(' · ');

    final frame = ClipRRect(
      borderRadius: BorderRadius.circular(EmbedVideoCard.radius),
      child: Material(
        color: Colors.black,
        child: InkWell(
          onTap: _open,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (thumbnail != null)
                LayoutBuilder(
                  builder: (context, constraints) => CachedRedirectImage(
                    imageUrl: thumbnail,
                    fit: BoxFit.cover,
                    cacheWidth: constraints.maxWidth.isFinite ? (constraints.maxWidth * dpr).round() : null,
                    errorWidget: (context, _, __) => placeholder(),
                  ),
                )
              else
                placeholder(),
              if (title != null)
                // The website's title bar: white text on a fade from black.
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      DesignTokens.spacingM,
                      DesignTokens.spacingM,
                      DesignTokens.spacingM,
                      DesignTokens.spacingXL,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x99000000), Color(0x00000000)],
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_channelAvatar != null) ...[
                          ClipOval(
                            child: CachedRedirectImage(
                              imageUrl: _channelAvatar!,
                              width: DesignTokens.iconSizeXL,
                              height: DesignTokens.iconSizeXL,
                              fit: BoxFit.cover,
                              cacheWidth: (DesignTokens.iconSizeXL * dpr).round(),
                              errorWidget: (context, _, __) => const SizedBox.shrink(),
                            ),
                          ),
                          const SizedBox(width: DesignTokens.spacingS),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  shadows: const [Shadow(blurRadius: 4, color: Colors.black54)],
                                ),
                              ),
                              Text(
                                byline,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall?.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Center(child: _PlayBadge(provider: provider)),
            ],
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      label: [provider.name, if (title != null) title].join(': '),
      excludeSemantics: true,
      onTap: _open,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: ConstrainedBox(
          // Tall videos (TikTok, Shorts) stay a sensible size instead of
          // filling a whole screen with one post.
          constraints: const BoxConstraints(maxHeight: 480),
          child: AspectRatio(
            aspectRatio: link.portrait ? 9 / 16 : 16 / 9,
            child: frame,
          ),
        ),
      ),
    );
  }
}

/// The site's play button: YouTube's red one, or the site's colour.
class _PlayBadge extends StatelessWidget {
  const _PlayBadge({required this.provider});

  final EmbedProvider provider;

  @override
  Widget build(BuildContext context) {
    if (identical(provider, EmbedLink.youtube)) {
      return Container(
        width: 68,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFFF0000),
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        ),
        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
      );
    }
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: provider.brand ?? Colors.black54,
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black38)],
      ),
      child: Icon(provider.icon, color: Colors.white, size: 34),
    );
  }
}

/// An embed that isn't a video (a Spotify track, an Instagram post) when the
/// page gives no preview: one row with the site's badge, the site and the
/// address. Adapted from flarum_ui's lib/src/render/embed_cards.dart
/// (_EmbedRow) and its card recipe (EmbeddedCard, FileRow).
class EmbedRow extends StatelessWidget {
  const EmbedRow({super.key, required this.link, required this.onOpen});

  final EmbedLink link;
  final void Function(String url) onOpen;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final provider = link.provider;
    final badge = provider.brand ?? colorScheme.onSurface;
    final onBadge = provider.brand == null ? colorScheme.surface : Colors.white;
    final title = link.title ?? provider.name;
    final subtitle = link.title != null ? provider.name : link.url.replaceFirst(RegExp(r'^https?://(www\.)?'), '');

    return Material(
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(EmbedVideoCard.radius),
        side: BorderSide(color: colorScheme.outlineVariant, width: DesignTokens.borderWidthThin),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onOpen(link.url),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingM),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: badge, borderRadius: BorderRadius.circular(DesignTokens.radiusS)),
                  child: Icon(provider.icon, color: onBadge, size: DesignTokens.iconSizeL),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
                    ),
                    const SizedBox(height: DesignTokens.spacingXS / 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DesignTokens.spacingXS),
              Icon(Icons.open_in_new, size: DesignTokens.iconSizeSMedium, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
