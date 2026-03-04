import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/design_tokens.dart';
import '../../theme/style_builders.dart';
import '../../l10n/generated/app_localizations.dart';

class BrokenImageWidget extends StatelessWidget {
  final double width;
  final double height;
  final double iconSize;
  final double fontSize;
  final String? imageUrl;
  final VoidCallback? onTap;

  const BrokenImageWidget({
    super.key,
    required this.width,
    required this.height,
    this.iconSize = 24.0,
    this.fontSize = 12.0,
    this.imageUrl,
    this.onTap,
  });

  /// Creates a broken image widget specifically for inline images with URL
  factory BrokenImageWidget.forInlineImage({
    required double width,
    required double height,
    required String imageUrl,
    double iconSize = 32.0,
    double fontSize = 11.0,
    VoidCallback? onTap,
  }) {
    return BrokenImageWidget(
      width: width,
      height: height,
      imageUrl: imageUrl,
      iconSize: iconSize,
      fontSize: fontSize,
      onTap: onTap,
    );
  }

  /// Shortens a URL to make it more readable
  static String shortenUrl(String url) {
    try {
      final uri = Uri.parse(url);
      String host = uri.host;

      // Remove 'www.' prefix if present
      if (host.startsWith('www.')) {
        host = host.substring(4);
      }

      // If the host is too long, truncate it
      if (host.length > 20) {
        host = '${host.substring(0, 17)}...';
      }

      // If there's a path, try to show a bit of it
      String path = uri.path;
      if (path.isNotEmpty && path != '/') {
        // Get the last segment of the path (filename)
        final segments = path.split('/').where((s) => s.isNotEmpty).toList();
        if (segments.isNotEmpty) {
          String filename = segments.last;
          // If filename is too long, truncate it
          if (filename.length > 15) {
            filename = '${filename.substring(0, 12)}...';
          }
          return '$host/$filename';
        }
      }

      return host;
    } catch (e) {
      // If URL parsing fails, return a truncated version of the original
      if (url.length > 30) {
        return '${url.substring(0, 27)}...';
      }
      return url;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: width,
      height: height,
      decoration: StyleBuilders.cardLikeDecoration(
        colorScheme: colorScheme,
        borderRadius: DesignTokens.radiusS,
        borderOpacity: 0.2,
      ).copyWith(
        color: colorScheme.surfaceVariant.withOpacity(DesignTokens.opacityLow),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: DesignTokens.paddingM,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_rounded,
                  size: iconSize,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                ),
                const SizedBox(height: 8),
                if (imageUrl != null) ...[
                  GestureDetector(
                    onTap: onTap ??
                        () async {
                          try {
                            final uri = Uri.parse(imageUrl!);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context)?.couldNotOpenLink(e.toString()) ?? 'Could not open link: ${e.toString()}'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.link,
                            size: fontSize,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              shortenUrl(imageUrl!),
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                                fontSize: fontSize,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to open',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                      fontSize: fontSize - 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Text(
                    'Image not available',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                      fontSize: fontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
