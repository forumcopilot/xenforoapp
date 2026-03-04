import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

import 'package:forumcopilot_flutter/utils/network_utils.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart';
import 'package:forumcopilot_sdk/services/fc_http_overrides.dart';

/// Handles all the behind-the-scenes work of loading and storing images
class ImageLoader {
  /// Gets an image from the internet or from local storage if we've seen it before
  /// Think of it like checking your photo album before downloading the same picture again
  static Future<ImageData> fetchImageFile(String url, {String? cacheKey}) async {
    final effectiveCacheKey = cacheKey ?? url;
    File? imageFile;
    String resolvedUrl = url;

    try {
      // First check if we already have this image saved locally
      final cachedFile = await FCCacheManager().getFileFromCache(effectiveCacheKey);

      if (cachedFile != null) {
        // We found it in our local storage - no need to download again
        imageFile = cachedFile;
      } else {
        // We don't have it saved yet, so try to download it
        try {
          debugPrint('ImageLoader.fetchImageFile: Attempting to download $url');
          imageFile = await FCCacheManager().getSingleFile(
            url,
            key: effectiveCacheKey,
          );
          debugPrint('ImageLoader.fetchImageFile: Successfully downloaded $url');
        } catch (e) {
          debugPrint('ImageLoader.fetchImageFile: Download failed for $url: $e');

          // If that didn't work, the URL might have changed (been redirected)
          // So we'll try to find where it points to now
          debugPrint('ImageLoader.fetchImageFile: Attempting redirect resolution for $url');
          resolvedUrl = await NetworkUtils.resolveRedirects(url);

          if (resolvedUrl != url) {
            debugPrint('ImageLoader.fetchImageFile: Redirect resolved from $url to $resolvedUrl');
            // The URL was indeed redirected, so try the new address
            try {
              imageFile = await FCCacheManager().getSingleFile(
                resolvedUrl,
                key: effectiveCacheKey,
              );
              debugPrint('ImageLoader.fetchImageFile: Successfully downloaded redirected URL $resolvedUrl');
            } catch (redirectError) {
              debugPrint('ImageLoader.fetchImageFile: Redirect download also failed: $redirectError');
              rethrow;
            }
          } else {
            debugPrint('ImageLoader.fetchImageFile: No redirect found, rethrowing original error');
            // No redirect was found, so pass along the original error
            rethrow;
          }
        }
      }

      // Return both the image file and the final URL where we found it
      return ImageData(file: imageFile, resolvedUrl: resolvedUrl);
    } catch (e) {
      // Something went wrong, print the error and pass it along
      debugPrint('Error loading image $url: $e');
      rethrow;
    }
  }
}

/// A simple container that holds both an image file and the URL where it came from
class ImageData {
  final File file;
  final String resolvedUrl;

  ImageData({required this.file, required this.resolvedUrl});
}

/// A widget that displays images from the internet with smart caching and redirect handling
/// This is like a picture frame that knows how to get photos from the internet
class CachedRedirectImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Duration placeholderFadeInDuration;
  final Duration fadeInDuration;
  final String? cacheKey;
  final int? cacheWidth;
  final int? cacheHeight;

  const CachedRedirectImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.placeholderFadeInDuration = const Duration(milliseconds: 500),
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.cacheKey,
    this.cacheWidth,
    this.cacheHeight,
  }) : super(key: key);

  @override
  State<CachedRedirectImage> createState() => _CachedRedirectImageState();
}

class _CachedRedirectImageState extends State<CachedRedirectImage> {
  late Future<String> _resolvedUrlFuture;
  late Future<ImageData?> _imageDataFuture;

  /// Sets up the widget when it's first created
  /// Like opening a new picture frame and getting it ready to show a photo
  @override
  void initState() {
    super.initState();
    // Defer the image loading to avoid build-time conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _resolvedUrlFuture = _getImageUrl();
          _imageDataFuture = _getImageData();
        });
      }
    });
    // Initialize with a completed future to avoid null issues
    _resolvedUrlFuture = Future.value(widget.imageUrl);
    _imageDataFuture = Future.value(null);
  }

  /// Checks if we need to update the image when the widget's properties change
  /// Like noticing someone changed which photo should go in the frame
  @override
  void didUpdateWidget(CachedRedirectImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl || oldWidget.cacheKey != widget.cacheKey) {
      // Defer the image loading to avoid build-time conflicts
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _resolvedUrlFuture = _getImageUrl();
            _imageDataFuture = _getImageData();
          });
        }
      });
    }
  }

  /// Gets the final URL for the image, handling any redirects along the way
  /// Like finding the correct address when someone has moved to a new house
  Future<String> _getImageUrl() async {
    try {
      // Use our shared helper to get the image
      final imageData = await ImageLoader.fetchImageFile(
        widget.imageUrl,
        cacheKey: widget.cacheKey,
      );
      return imageData.resolvedUrl;
    } catch (e) {
      // If something goes wrong, note the error but return the original URL
      debugPrint('Error in CachedRedirectImage for ${widget.imageUrl}: $e');
      return widget.imageUrl;
    }
  }

  /// Gets the image data (file) using cookie-aware download
  /// This ensures authenticated image requests work properly
  Future<ImageData?> _getImageData() async {
    try {
      return await ImageLoader.fetchImageFile(
        widget.imageUrl,
        cacheKey: widget.cacheKey,
      );
    } catch (e) {
      debugPrint('Error getting image data in CachedRedirectImage for ${widget.imageUrl}: $e');
      return null;
    }
  }

  /// Builds the actual visual part of the widget that appears on screen
  /// This is like assembling the picture frame with the photo inside
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageData?>(
      future: _imageDataFuture,
      builder: (context, imageDataSnapshot) {
        // If we have the cached file, use it directly with Image.file for better cookie/cache handling
        // This uses the same cookie-aware download path as the full-screen viewer
        if (imageDataSnapshot.hasData && imageDataSnapshot.data != null) {
          final imageFile = imageDataSnapshot.data!.file;
          return Image(
            image: FileImage(imageFile),
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              }
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: widget.fadeInDuration,
                child: child,
              );
            },
            errorBuilder: (context, error, stackTrace) {
              // Fall back to network loading if file loading fails
              debugPrint('Error loading cached file, falling back to network: $error');
              return _buildNetworkImage();
            },
          );
        }

        // While loading image data, show placeholder or use network image
        if (imageDataSnapshot.connectionState == ConnectionState.waiting) {
          return widget.placeholder?.call(context, widget.imageUrl) ??
              Container(
                width: widget.width,
                height: widget.height,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
                child: const Center(child: CircularProgressIndicator()),
              );
        }

        // If image data fetch failed, fall back to network loading
        return _buildNetworkImage();
      },
    );
  }

  /// Fallback network image builder using CachedNetworkImage
  /// This is used when file-based loading fails
  Widget _buildNetworkImage() {
    return FutureBuilder<String>(
      future: _resolvedUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.placeholder?.call(context, widget.imageUrl) ??
              Container(
                width: widget.width,
                height: widget.height,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
                child: const Center(child: CircularProgressIndicator()),
              );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Builder(
            builder: (context) {
              return widget.errorWidget?.call(context, widget.imageUrl, snapshot.error) ??
                  Container(
                    width: widget.width,
                    height: widget.height,
                    color: Colors.grey.shade200,
                    child: const Center(child: Icon(Icons.error)),
                  );
            },
          );
        }

        final resolvedUrl = snapshot.data!;

        // Get cookies for this URL to include in the request
        // This ensures authenticated image requests work properly
        return FutureBuilder<String>(
          future: FCDioClient.instance.getCookiesForUrl(Uri.parse(resolvedUrl)),
          builder: (context, cookieSnapshot) {
            Map<String, String> httpHeaders = {};
            if (cookieSnapshot.hasData && cookieSnapshot.data!.isNotEmpty) {
              httpHeaders['Cookie'] = cookieSnapshot.data!;
            }

            // Fallback to CachedNetworkImage if file-based loading fails
            return CachedNetworkImage(
              imageUrl: resolvedUrl,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              placeholder: widget.placeholder,
              errorWidget: widget.errorWidget,
              fadeInDuration: widget.fadeInDuration,
              placeholderFadeInDuration: widget.placeholderFadeInDuration,
              cacheKey: widget.cacheKey ?? resolvedUrl,
              memCacheWidth: widget.cacheWidth,
              memCacheHeight: widget.cacheHeight,
              httpHeaders: httpHeaders,
            );
          },
        );
      },
    );
  }
}

/// A special version that provides images for widgets that need ImageProvider
/// This is like a photo service that other widgets can use when they need pictures
class CachedRedirectNetworkImageProvider extends ImageProvider<NetworkImage> {
  final String url;
  final double scale;
  final String? cacheKey;

  CachedRedirectNetworkImageProvider(
    this.url, {
    this.scale = 1.0,
    this.cacheKey,
  });

  /// Creates a key to identify this image uniquely
  /// Like creating a unique label for each photo in your collection
  @override
  Future<NetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<NetworkImage>(NetworkImage(url, scale: scale));
  }

  /// Sets up how the image will be loaded and displayed
  /// Like establishing the process for getting and showing a photo
  @override
  ImageStreamCompleter loadImage(NetworkImage key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(url, decode),
      scale: scale,
      debugLabel: url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<String>('URL', url),
      ],
    );
  }

  /// Does the actual work of loading the image from cache or internet
  /// Like going to get a photo from your album or downloading it if needed
  Future<ui.Codec> _loadAsync(String urlToLoad, ImageDecoderCallback decode) async {
    try {
      // Use our shared helper to get the image
      final imageData = await ImageLoader.fetchImageFile(
        urlToLoad,
        cacheKey: cacheKey,
      );

      // Convert the image file to a format Flutter can display
      final bytes = await imageData.file.readAsBytes();
      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      return decode(buffer);
    } catch (e) {
      // If something goes wrong, note the error and pass it along
      debugPrint('Error in CachedRedirectNetworkImageProvider for $urlToLoad: $e');
      rethrow;
    }
  }
}
