import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:forumcopilot_flutter/views/widgets/cached_redirect_image.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../utils/snackbar_helper.dart';

class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String heroTag;

  const FullScreenImageViewer({
    Key? key,
    required this.imageUrls,
    this.initialIndex = 0,
    required this.heroTag,
  }) : super(key: key);

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  bool _isSaving = false;
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  Future<void> _saveImage() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final imageUrl = widget.imageUrls[_currentIndex];

      // Request write permission only when saving
      bool hasPermission = false;
      try {
        if (Platform.isAndroid) {
          final deviceInfoPlugin = DeviceInfoPlugin();
          final deviceInfo = await deviceInfoPlugin.androidInfo;
          final sdkInt = deviceInfo.version.sdkInt;
          // For Android 10+ (API 29+), no permission needed for saving to Pictures directory
          hasPermission = sdkInt < 29 ? await Permission.storage.request().isGranted : true;
        } else if (Platform.isIOS) {
          // Only request permission to add photos, not to read them
          hasPermission = await Permission.photosAddOnly.request().isGranted;
        } else if (Platform.isMacOS) {
          // On macOS, try to request permission, but if plugin isn't available, proceed anyway
          // macOS will handle permissions through system dialogs if needed
          try {
            hasPermission = await Permission.photosAddOnly.request().isGranted;
          } catch (e) {
            // If permission handler fails on macOS, proceed anyway - system will prompt if needed
            hasPermission = true;
          }
        } else {
          hasPermission = true; // For other platforms like web, windows, linux
        }
      } catch (e) {
        // If permission check fails entirely, proceed anyway
        // The save operation itself may succeed or provide better error messages
        hasPermission = true;
      }

      if (!hasPermission) {
        if (mounted) {
          SnackbarHelper.showError(context, AppLocalizations.of(context).permissionDeniedToSaveImage);
        }
        return;
      }

      // Get cached image file directly - much faster than resolving image provider
      final imageData = await ImageLoader.fetchImageFile(imageUrl);
      
      if (!await imageData.file.exists()) {
        throw Exception('Image file not found');
      }
      
      final bytes = await imageData.file.readAsBytes();

      // Save image to gallery
      final fileName = "image_${DateTime.now().millisecondsSinceEpoch}";
      final result = await SaverGallery.saveImage(
        bytes,
        quality: 100,
        fileName: fileName,
        androidRelativePath: "Pictures", // Save to standard Pictures folder
        skipIfExists: false,
      );

      if (mounted) {
        SnackbarHelper.showError(context, result.isSuccess 
                ? AppLocalizations.of(context).imageSavedToGallery
                : AppLocalizations.of(context).failedToSaveImage(result.errorMessage ?? "Unknown error"));
      }
    } catch (e) {
      if (mounted) {
          SnackbarHelper.showError(context, AppLocalizations.of(context).failedToSaveImage(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.imageUrls[_currentIndex],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSaving ? Icons.downloading : Icons.download,
              color: Colors.white,
              size: 30,
            ),
            onPressed: _isSaving ? null : _saveImage,
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
                Navigator.of(context).pop();
              }
            },
            child: PhotoView(
              imageProvider: CachedRedirectNetworkImageProvider(widget.imageUrls[index]),
              heroAttributes: index == widget.initialIndex ? PhotoViewHeroAttributes(tag: widget.heroTag) : null,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null || event.expectedTotalBytes == null ? null : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
