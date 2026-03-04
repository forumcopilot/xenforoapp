import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../views/widgets/broken_image_widget.dart';
import '../theme/design_tokens.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

/// Extension to safely handle Image.network exceptions and provide fallback widgets
extension SafeImageNetwork on Image {
  /// Creates a network image with comprehensive exception handling
  ///
  /// This method wraps Image.network with try-catch and provides:
  /// - Automatic error handling for network failures (including HttpExceptions)
  /// - Debug logging for development
  /// - Customizable fallback widgets
  /// - All standard Image.network parameters
  static Widget networkSafe(
    String src, {
    Key? key,
    double scale = 1.0,
    Map<String, String>? headers,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
    Widget? fallbackWidget,
    IconData fallbackIcon = Icons.broken_image,
  }) {
    try {
      return Image.network(
        src,
        key: key,
        scale: scale,
        headers: headers,
        errorBuilder: errorBuilder ??
            (context, error, stackTrace) {
              if (kDebugMode) {
                AppLogger.debug('SafeImageNetwork: Image loading error for URL: $src');
                AppLogger.debug('Error: $error');
                if (stackTrace != null) {
                  AppLogger.debug('Stack trace: $stackTrace');
                }

                // Log specific error types for better debugging
                if (error.toString().contains('HttpException')) {
                  AppLogger.debug('SafeImageNetwork: Network/Proxy error detected');
                } else if (error.toString().contains('SocketException')) {
                  AppLogger.debug('SafeImageNetwork: Socket connection error detected');
                } else if (error.toString().contains('TimeoutException')) {
                  AppLogger.debug('SafeImageNetwork: Network timeout detected');
                } else if (error.toString().contains('FormatException')) {
                  AppLogger.debug('SafeImageNetwork: Invalid image format detected');
                }
              }

              // Call custom error builder if provided, otherwise use our fallback
              if (errorBuilder != null) {
                try {
                  return errorBuilder(context, error, stackTrace);
                } catch (builderError) {
                  if (kDebugMode) {
                    AppLogger.debug('SafeImageNetwork: Error in custom errorBuilder: $builderError');
                  }
                  // Fall back to our error widget if custom builder fails
                  return _buildErrorWidget(
                    context: context,
                    width: width,
                    height: height,
                    fallbackWidget: fallbackWidget,
                    fallbackIcon: fallbackIcon,
                  );
                }
              }

              // Use the improved broken image widget if no custom fallback is provided
              return fallbackWidget ??
                  BrokenImageWidget.forInlineImage(
                    width: width ?? 200,
                    height: height ?? 150,
                    imageUrl: src,
                    iconSize: DesignTokens.iconSizeXL,
                    fontSize: DesignTokens.fontSizeXXS,
                  );
            },
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        width: width,
        height: height,
        color: color,
        opacity: opacity,
        colorBlendMode: colorBlendMode,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
        centerSlice: centerSlice,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        isAntiAlias: isAntiAlias,
        filterQuality: filterQuality,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      );
    } catch (e) {
      if (kDebugMode) {
        AppLogger.debug('SafeImageNetwork: Exception creating Image.network for URL: $src');
        AppLogger.debug('Exception: $e');
      }

      return fallbackWidget ??
          BrokenImageWidget.forInlineImage(
            width: width ?? 200,
            height: height ?? 150,
            imageUrl: src,
            iconSize: DesignTokens.iconSizeXL,
            fontSize: DesignTokens.fontSizeXXS,
          );
    }
  }

  /// Helper method to build error widget
  static Widget _buildErrorWidget({
    required BuildContext context,
    double? width,
    double? height,
    Widget? fallbackWidget,
    required IconData fallbackIcon,
  }) {
    return fallbackWidget ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            fallbackIcon,
            size: 32,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        );
  }

  /// Creates a network image with pre-validation using a Future
  /// This method checks the URL accessibility before attempting to load the image
  static Widget networkSafeWithFuture(
    String src, {
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    Widget? fallbackWidget,
    IconData fallbackIcon = Icons.broken_image,
    Duration timeout = const Duration(seconds: 5),
  }) {
    return FutureBuilder<bool>(
      future: _checkImageUrl(src, timeout),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == false) {
          if (kDebugMode) {
            AppLogger.debug('SafeImageNetwork: Future-based check failed for URL: $src');
            if (snapshot.hasError) {
              AppLogger.debug('Error: ${snapshot.error}');
            }
          }
          return _buildErrorWidget(
            context: context,
            width: width,
            height: height,
            fallbackWidget: fallbackWidget,
            fallbackIcon: fallbackIcon,
          );
        }

        // URL is valid, proceed with normal Image.network
        return networkSafe(
          src,
          key: key,
          width: width,
          height: height,
          fit: fit,
          fallbackWidget: fallbackWidget,
          fallbackIcon: fallbackIcon,
        );
      },
    );
  }

  /// Checks if an image URL is accessible
  static Future<bool> _checkImageUrl(String url, Duration timeout) async {
    try {
      final uri = Uri.parse(url);

      // Check if it's a valid network URL
      if (uri.scheme != 'http' && uri.scheme != 'https') {
        if (kDebugMode) {
          AppLogger.debug('SafeImageNetwork: Invalid URL scheme, not checking: $url');
        }
        return false;
      }

      final client = HttpClient();
      client.connectionTimeout = timeout;

      final request = await client.headUrl(uri);
      final response = await request.close();

      client.close();

      // Check if the response is successful and content-type is an image
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final contentType = response.headers.contentType;
        if (contentType != null && contentType.primaryType == 'image') {
          return true;
        }
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        AppLogger.debug('SafeImageNetwork: URL check failed for $url: $e');
      }
      return false;
    }
  }
}

/// Convenience class for commonly used safe image configurations
class SafeImage {
  /// Creates a safe network image with forum-style styling
  static Widget forumAvatar(
    String src, {
    double size = 56,
    IconData fallbackIcon = Icons.forum_rounded,
    bool usePrecheck = false,
  }) {
    bool isAsset = src.startsWith('assets/');
    if (isAsset) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          src,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    if (usePrecheck) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SafeImageNetwork.networkSafeWithFuture(
          src,
          width: size,
          height: size,
          fit: BoxFit.cover,
          fallbackIcon: fallbackIcon,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SafeImageNetwork.networkSafe(
        src,
        width: size,
        height: size,
        fit: BoxFit.cover,
        fallbackIcon: fallbackIcon,
      ),
    );
  }

  /// Creates a safe network image with user avatar styling
  static Widget userAvatar(
    String src, {
    double size = 40,
    IconData fallbackIcon = Icons.person,
    bool usePrecheck = false,
  }) {
    final imageWidget = usePrecheck
        ? SafeImageNetwork.networkSafeWithFuture(
            src,
            width: size,
            height: size,
            fit: BoxFit.cover,
            fallbackIcon: fallbackIcon,
          )
        : SafeImageNetwork.networkSafe(
            src,
            width: size,
            height: size,
            fit: BoxFit.cover,
            fallbackIcon: fallbackIcon,
          );

    return ClipOval(child: imageWidget);
  }

  /// Creates a safe network image with thumbnail styling
  static Widget thumbnail(
    String src, {
    double width = 100,
    double height = 100,
    IconData fallbackIcon = Icons.image,
    bool usePrecheck = false,
  }) {
    return usePrecheck
        ? SafeImageNetwork.networkSafeWithFuture(
            src,
            width: width,
            height: height,
            fit: BoxFit.cover,
            fallbackIcon: fallbackIcon,
          )
        : SafeImageNetwork.networkSafe(
            src,
            width: width,
            height: height,
            fit: BoxFit.cover,
            fallbackIcon: fallbackIcon,
          );
  }

  /// Creates a safe network image for use as a forum/card background
  static Widget forumBackground(
    String src, {
    BoxFit fit = BoxFit.cover,
    bool usePrecheck = false,
  }) {
    return usePrecheck
        ? SafeImageNetwork.networkSafeWithFuture(
            src,
            fit: fit,
          )
        : SafeImageNetwork.networkSafe(
            src,
            fit: fit,
          );
  }
}
