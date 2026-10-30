import 'package:flutter/material.dart';

/// What an embed is, which decides how its preview card looks: a video
/// gets a thumbnail with a play button, the rest a row naming the site.
///
/// Adapted from forum_kit's lib/utils/embed_links.dart (Flapp, the Discourse
/// app), keeping the providers and brand colours, recognising the media
/// sites XenForo embeds (`[MEDIA=site]`).
enum EmbedKind { video, audio, post, map, page }

/// A site whose players a forum embeds in posts.
class EmbedProvider {
  const EmbedProvider(this.name, this.kind, this.icon, {this.brand});

  final String name;
  final EmbedKind kind;
  final IconData icon;

  /// The site's colour, for the badge behind [icon]; null uses the theme's
  /// on-surface colour (a black brand would vanish in the dark theme).
  final Color? brand;
}

/// An embed in a post, reduced to what its preview card needs. The app
/// doesn't run the site's player inside a post: it shows a native preview
/// and opens the site (or its app, e.g. YouTube) on tap.
class EmbedLink {
  const EmbedLink({
    required this.provider,
    required this.url,
    this.title,
    this.thumbnailUrl,
    this.youtubeId,
    this.portrait = false,
  });

  final EmbedProvider provider;

  /// The page to open: the video or post itself, not the player.
  final String url;
  final String? title;
  final String? thumbnailUrl;

  /// Set for YouTube, so the card can look the video up (YouTubeCache).
  final String? youtubeId;

  /// TikTok and YouTube Shorts are tall.
  final bool portrait;

  EmbedLink copyWith({String? title, String? thumbnailUrl}) => EmbedLink(
        provider: provider,
        url: url,
        title: title ?? this.title,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        youtubeId: youtubeId,
        portrait: portrait,
      );

  // ---------------------------------------------------------------------
  // Providers
  // ---------------------------------------------------------------------

  static const youtube = EmbedProvider('YouTube', EmbedKind.video, Icons.play_arrow_rounded, brand: Color(0xFFFF0000));
  static const vimeo = EmbedProvider('Vimeo', EmbedKind.video, Icons.play_arrow_rounded, brand: Color(0xFF1AB7EA));
  static const tiktok = EmbedProvider('TikTok', EmbedKind.video, Icons.music_note_rounded, brand: Color(0xFFFE2C55));
  static const dailymotion = EmbedProvider('Dailymotion', EmbedKind.video, Icons.play_arrow_rounded, brand: Color(0xFF0066DC));
  static const twitch = EmbedProvider('Twitch', EmbedKind.video, Icons.play_arrow_rounded, brand: Color(0xFF9146FF));
  static const loom = EmbedProvider('Loom', EmbedKind.video, Icons.play_arrow_rounded, brand: Color(0xFF625DF5));
  static const streamable = EmbedProvider('Streamable', EmbedKind.video, Icons.play_arrow_rounded, brand: Color(0xFF0F90FA));

  static const facebook = EmbedProvider('Facebook', EmbedKind.post, Icons.facebook, brand: Color(0xFF1877F2));
  static const instagram = EmbedProvider('Instagram', EmbedKind.post, Icons.photo_camera_outlined, brand: Color(0xFFE1306C));
  static const reddit = EmbedProvider('Reddit', EmbedKind.post, Icons.forum_outlined, brand: Color(0xFFFF4500));
  static const x = EmbedProvider('X', EmbedKind.post, Icons.tag);
  static const tumblr = EmbedProvider('Tumblr', EmbedKind.post, Icons.article_outlined, brand: Color(0xFF001935));
  static const medium = EmbedProvider('Medium', EmbedKind.post, Icons.article_outlined);
  static const pinterest = EmbedProvider('Pinterest', EmbedKind.post, Icons.push_pin_outlined, brand: Color(0xFFE60023));
  static const imgur = EmbedProvider('Imgur', EmbedKind.post, Icons.image_outlined, brand: Color(0xFF1BB76E));
  static const flickr = EmbedProvider('Flickr', EmbedKind.post, Icons.photo_library_outlined, brand: Color(0xFFFF0084));
  static const giphy = EmbedProvider('GIPHY', EmbedKind.post, Icons.gif_box_outlined);

  static const soundcloud = EmbedProvider('SoundCloud', EmbedKind.audio, Icons.graphic_eq, brand: Color(0xFFFF5500));
  static const spotify = EmbedProvider('Spotify', EmbedKind.audio, Icons.graphic_eq, brand: Color(0xFF1DB954));
  static const appleMusic = EmbedProvider('Apple Music', EmbedKind.audio, Icons.music_note_rounded, brand: Color(0xFFFA243C));

  /// XenForo's media site ids (`[MEDIA=site]`, `data-media-site`) for the
  /// sites it ships with.
  static const Map<String, EmbedProvider> _mediaSites = {
    'youtube': youtube,
    'vimeo': vimeo,
    'tiktok': tiktok,
    'dailymotion': dailymotion,
    'twitch': twitch,
    'streamable': streamable,
    'facebook': facebook,
    'instagram': instagram,
    'reddit': reddit,
    'twitter': x,
    'tumblr': tumblr,
    'medium': medium,
    'pinterest': pinterest,
    'imgur': imgur,
    'flickr': flickr,
    'giphy': giphy,
    'soundcloud': soundcloud,
    'spotify': spotify,
    'applemusic': appleMusic,
    'apple_music': appleMusic,
  };

  // ---------------------------------------------------------------------
  // Recognition
  // ---------------------------------------------------------------------

  /// A XenForo media embed: its site id and the address the app opens. A
  /// video address gets the video card; anything else names its site.
  static EmbedLink fromMediaSite(String site, String url) =>
      fromUrl(url) ??
      EmbedLink(
        provider: _mediaSites[site.toLowerCase()] ?? EmbedProvider(site, EmbedKind.page, Icons.public),
        url: url,
      );

  /// A video page URL. Only video sites qualify: anything else stays a
  /// link, as on the website.
  static EmbedLink? fromUrl(String url, {String? title, String? thumbnailUrl}) {
    final uri = Uri.tryParse(url.trim());
    if (uri == null || !uri.hasScheme || !uri.scheme.startsWith('http')) return null;
    final host = _host(uri);
    final ytId = youtubeIdOf(url);
    if (ytId != null) {
      return EmbedLink(
        provider: youtube,
        url: url,
        title: title,
        thumbnailUrl: thumbnailUrl ?? youtubeThumbnail(ytId),
        youtubeId: ytId,
        portrait: uri.path.startsWith('/shorts/'),
      );
    }
    if (_is(host, 'vimeo.com') && RegExp(r'^/\d+').hasMatch(uri.path)) {
      return EmbedLink(provider: vimeo, url: url, title: title, thumbnailUrl: thumbnailUrl);
    }
    if (_is(host, 'tiktok.com') && uri.path.contains('/video/')) {
      return EmbedLink(provider: tiktok, url: url, title: title, thumbnailUrl: thumbnailUrl, portrait: true);
    }
    final dm = _dailymotionId(uri);
    if (dm != null) {
      return EmbedLink(
        provider: dailymotion,
        url: 'https://www.dailymotion.com/video/$dm',
        title: title,
        thumbnailUrl: thumbnailUrl ?? 'https://www.dailymotion.com/thumbnail/video/$dm',
      );
    }
    if (_is(host, 'twitch.tv') && (uri.path.startsWith('/videos/') || host.startsWith('clips.'))) {
      return EmbedLink(provider: twitch, url: url, title: title, thumbnailUrl: thumbnailUrl);
    }
    if (_is(host, 'loom.com') && uri.path.startsWith('/share/')) {
      return EmbedLink(provider: loom, url: url, title: title, thumbnailUrl: thumbnailUrl);
    }
    if (host == 'streamable.com' && RegExp(r'^/\w+$').hasMatch(uri.path)) {
      return EmbedLink(provider: streamable, url: url, title: title, thumbnailUrl: thumbnailUrl);
    }
    return null;
  }

  // ---------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------

  static final RegExp _youtubeId = RegExp(
    r'^(?:https?:)?//(?:www\.|m\.|music\.)?(?:youtube\.com/(?:watch\?(?:.*&)?v=|embed/|shorts/|live/|v/)|youtube-nocookie\.com/embed/|youtu\.be/)(?!videoseries)([A-Za-z0-9_-]{11})',
    caseSensitive: false,
  );

  /// The 11-character video id in a YouTube watch, share, Shorts or embed
  /// URL; null for anything else.
  static String? youtubeIdOf(String url) => _youtubeId.firstMatch(url.trim())?.group(1);

  /// YouTube's own still for a video, which exists for every video.
  static String youtubeThumbnail(String id) => 'https://i.ytimg.com/vi/$id/hqdefault.jpg';

  static String? _dailymotionId(Uri uri) {
    final host = _host(uri);
    if (host == 'dai.ly') {
      final seg = uri.pathSegments.firstOrNull;
      return (seg == null || seg.isEmpty) ? null : seg;
    }
    if (!_is(host, 'dailymotion.com')) return null;
    final m = RegExp(r'^/(?:embed/)?video/([A-Za-z0-9]+)').firstMatch(uri.path);
    if (m != null) return m.group(1);
    // The newer player: geo.dailymotion.com/player/xyz.html?video=ID
    final id = uri.queryParameters['video']?.trim();
    return (id == null || id.isEmpty) ? null : id;
  }

  static String _host(Uri uri) {
    final h = uri.host.toLowerCase();
    return h.startsWith('www.') ? h.substring(4) : h;
  }

  /// [host] is [domain] or a subdomain of it.
  static bool _is(String host, String domain) => host == domain || host.endsWith('.$domain');
}
