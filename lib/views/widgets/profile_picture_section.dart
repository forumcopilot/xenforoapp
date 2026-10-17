import 'package:flutter/material.dart';
import 'package:forumcopilot_flutter/views/widgets/full_screen_image_viewer.dart';
import 'package:forumcopilot_flutter/views/widgets/user_avatar.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:forumcopilot_sdk/factory/site_proxy_factory.dart';
import 'package:image_picker/image_picker.dart';
import 'package:forumcopilot_flutter/utils/file_picker_utils.dart';
import 'dart:io';
import '../../theme/design_tokens.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

class ProfilePictureSection extends StatefulWidget {
  final SiteContext siteContext;
  final String username;
  final String imageUrl;
  final VoidCallback? onImagePick;
  final VoidCallback? onProfileUpdated;

  const ProfilePictureSection({
    Key? key,
    required this.siteContext,
    required this.username,
    required this.imageUrl,
    this.onImagePick,
    this.onProfileUpdated,
  }) : super(key: key);

  @override
  State<ProfilePictureSection> createState() => _ProfilePictureSectionState();
}

class _ProfilePictureSectionState extends State<ProfilePictureSection> {
  File? _selectedImageFile;
  bool _isUploading = false;

  Future<void> _pickImage(BuildContext context) async {
    // Check permission before allowing image pick
    final canUploadAvatar = widget.siteContext.loginDataOutput?.canUploadAvatar ?? false;
    if (!canUploadAvatar) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You do not have permission to upload avatars',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    try {
      // Use FilePickerUtils for macOS compatibility, fallback to image_picker for mobile
      XFile? image;
      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        image = await FilePickerUtils.pickImage(imageQuality: ImageQuality.high);
      } else {
        final ImagePicker picker = ImagePicker();
        image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );
      }

      if (image != null) {
        if (mounted) {
          setState(() {
            _selectedImageFile = File(image!.path);
            _isUploading = true;
          });
        }
        try {
          var attachmentProxy = SiteProxyFactory.getAttachmentProxy();
          var uploadAttachmentResult = await attachmentProxy.uploadAvatarAsync("jpg", await image.readAsBytes());
          if (uploadAttachmentResult.result == true) {
            // After successful upload, refresh user info to get updated image URL
            await _refreshUserInfo();

            if (mounted) {
              setState(() {
                _isUploading = false;
                _selectedImageFile = null;
              });
            }
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Avatar uploaded successfully',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(8),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          } else {
            throw Exception(uploadAttachmentResult.resultText);
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _isUploading = false;
              _selectedImageFile = null;
            });
          }
          throw Exception('Failed to upload file: ${e.toString()}');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _selectedImageFile = null;
        });
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to pick image: $e',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _refreshUserInfo() async {
    try {
      final username = widget.siteContext.loginDataOutput?.user?.username;
      if (username == null) return;

      final proxy = SiteProxyFactory.getUserProxy();
      final userInfo = await proxy.getUserInfoAsync(username, null);

      // Update the userForumData with the new image URL
      if (widget.siteContext.loginDataOutput != null) {
        widget.siteContext.loginDataOutput!.user?.iconUrl = userInfo.iconUrl ?? '';
      }

      // Save the updated context to device
      await widget.siteContext.saveToDevice();

      // Notify parent widget to refresh
      widget.onProfileUpdated?.call();
    } catch (e) {
      AppLogger.debug('Error refreshing user info after avatar upload: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Check if user has permission to upload avatar
    final canUploadAvatar = widget.siteContext.loginDataOutput?.canUploadAvatar ?? false;

    return Padding(
      padding: EdgeInsets.only(
        top: DesignTokens.spacingXL,
        left: DesignTokens.spacingXL,
        right: DesignTokens.spacingXL,
        bottom: 0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile Picture with Camera Icon
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.imageUrl.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImageViewer(
                          imageUrls: [widget.imageUrl],
                          initialIndex: 0,
                          heroTag: 'profile_picture_${widget.username}',
                        ),
                      ),
                    );
                  }
                },
                child: _selectedImageFile != null
                    ? ClipOval(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.file(
                            _selectedImageFile!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : UserAvatar(
                        username: widget.username,
                        iconUrl: widget.imageUrl,
                        radius: 50,
                      ),
              ),
              if (_isUploading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: DesignTokens.iconSizeL,
                      height: DesignTokens.iconSizeL,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                      ),
                    ),
                  ),
                ),
              // Only show camera icon if user has permission to upload avatar
              if (canUploadAvatar)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: widget.onImagePick ?? () => _pickImage(context),
                    child: Container(
                      padding: DesignTokens.paddingS,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: DesignTokens.borderWidthThin,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: DesignTokens.iconSizeM,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: DesignTokens.spacingM),
          // Username
          Text(
            widget.username,
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: DesignTokens.fontWeightBold,
            ),
          ),
        ],
      ),
    );
  }
}
