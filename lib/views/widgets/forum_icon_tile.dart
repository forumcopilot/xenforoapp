import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/avatar_color_utils.dart';
import '../../utils/safe_image.dart';

/// A forum's square logo as a tile, corners 28% of the side. The logo is
/// drawn whole (contained, never cropped) on white, as it was drawn to; SVG
/// logos work too. A forum with no logo, or one that fails to load, gets its
/// initial on a colour from its name.
class ForumIconTile extends StatelessWidget {
  const ForumIconTile({
    super.key,
    required this.name,
    this.url,
    this.size = 28,
  });

  final String name;
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.28);
    final url = this.url;
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: size,
        height: size,
        color: Colors.white,
        foregroundDecoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        ),
        child: url == null || url.isEmpty
            ? _initial(context)
            : BrandImage(url, width: size, height: size, fallback: _initial),
      ),
    );
  }

  Widget _initial(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final colors = AvatarColorUtils.getGradientColors(name, isLightTheme: light);
    final text = AvatarColorUtils.getUserAvatarColorScheme(name, isLightTheme: light)['text']!;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Text(
          initialOf(name, fallback: 'F'),
          textScaler: TextScaler.noScaling,
          style: TextStyle(color: text, fontWeight: FontWeight.w600, fontSize: size * 0.5),
        ),
      ),
    );
  }
}

/// A forum's logo from the network, contained in its box, in whatever format
/// the admin uploaded: SVG through flutter_svg (the image widget cannot
/// decode it and showed the fallback), anything else through
/// [SafeImageNetwork].
class BrandImage extends StatelessWidget {
  const BrandImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    required this.fallback,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final Widget Function(BuildContext) fallback;

  static bool isSvg(String url) {
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
    return path.endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    if (isSvg(url)) {
      return SvgPicture.network(
        url,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        placeholderBuilder: (_) => SizedBox(width: width, height: height),
        errorBuilder: (context, _, __) => fallback(context),
      );
    }
    return SafeImageNetwork.networkSafe(
      url,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, _, __) => fallback(context),
    );
  }
}

/// The first visible character of [text], upper-cased, for letter tiles.
/// `text[0]` is a UTF-16 code unit: for a name that starts with an emoji it
/// is half a surrogate pair, and a Text holding it throws on layout.
String initialOf(String text, {String fallback = '?'}) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return fallback;
  return trimmed.characters.first.toUpperCase();
}
