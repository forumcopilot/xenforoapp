# File Picker Setup Guide

## Overview

This document explains the changes made to enable file attachment upload functionality across all platforms (macOS, iOS, Android, Windows, Linux). The Flutter app now uses:

- **`file_picker`** package for selecting any file type (via paperclip icon) - works on all platforms
- **`image_picker`** package for selecting images from gallery (via image icon) - optimized for iOS/Android with quality settings

This allows users on iOS and Android to upload non-image file attachments (PDFs, documents, etc.) via the paperclip icon, while maintaining the optimized image selection experience via the image icon.

## Changes Made

### 1. Added `file_picker` Package

Added `file_picker: ^8.1.4` to `pubspec.yaml` dependencies. This package provides native file picker dialogs for macOS, Windows, and Linux.

### 2. Updated macOS Entitlements

Added the required entitlement for file access in both debug and release configurations:

**macos/Runner/DebugProfile.entitlements** and **macos/Runner/Release.entitlements**:
```xml
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
```

This entitlement allows the app to access files that the user explicitly selects through the file picker dialog. This is required for macOS sandboxed apps.

### 3. Created Platform-Aware File Picker Utility

Created `lib/utils/file_picker_utils.dart` which provides a unified interface for file picking across platforms:

- **macOS/Windows/Linux**: Uses `file_picker` package for native file dialogs
- **iOS/Android**: Uses `image_picker` package (existing behavior)

The utility automatically detects the platform and uses the appropriate picker, ensuring compatibility across all platforms.

### 4. Updated All File Picker Usage

Updated the following files to use the new `FilePickerUtils`:

- `lib/mixins/attachment_upload_mixin.dart`
- `lib/views/widgets/message_compose_page.dart`
- `lib/views/new_conversation_page.dart`
- `lib/views/new_private_message_page.dart`
- `lib/views/reply_private_message_page.dart`
- `lib/views/widgets/profile_picture_section.dart`

## How It Works

### File Selection (Paperclip Icon) - All Platforms

When a user clicks the **paperclip icon** (attach file button):
1. **macOS/Windows/Linux**: Native file picker dialog opens
2. **iOS/Android**: System document picker opens (allows selecting any file type)
3. User can select any file type (PDFs, documents, images, etc.)
4. The selected file is converted to `XFile` format for compatibility
5. File is uploaded using the existing upload logic

### Image Selection (Image Icon) - Platform Optimized

When a user clicks the **image icon**:
1. **macOS/Windows/Linux**: Uses `file_picker` with image filter
2. **iOS/Android**: Uses `image_picker` for optimized gallery access with:
   - Image quality settings (compression)
   - Direct photo library integration
   - Better user experience for image selection

This dual approach provides:
- **Paperclip icon** → Full file selection capability (any file type) on all platforms
- **Image icon** → Optimized image selection experience on mobile platforms

## Testing

### Testing on macOS

1. Run the app on macOS: `flutter run -d macos`
2. Navigate to any page with attachment functionality (e.g., new post, reply, private message)
3. Click the paperclip icon (attach file button)
4. Verify that a native macOS file picker dialog appears
5. Select a file and verify it uploads successfully

### Testing on iOS

1. Run the app on iOS: `flutter run -d ios`
2. Navigate to any page with attachment functionality
3. **Paperclip icon test**: Click paperclip icon → Should open document picker allowing selection of any file type (PDFs, documents, etc.)
4. **Image icon test**: Click image icon → Should open photo library for image selection
5. Verify both file types upload successfully

### Testing on Android

1. Run the app on Android: `flutter run -d android`
2. Navigate to any page with attachment functionality
3. **Paperclip icon test**: Click paperclip icon → Should open file manager allowing selection of any file type
4. **Image icon test**: Click image icon → Should open gallery for image selection
5. Verify both file types upload successfully

## Troubleshooting

### File Picker Doesn't Open

- Verify that `flutter pub get` has been run to install the `file_picker` package
- **macOS**: Check that the entitlements are correctly set in both DebugProfile.entitlements and Release.entitlements
- **iOS**: Verify Info.plist has photo library permissions (already configured)
- **Android**: Verify AndroidManifest.xml has storage permissions (already configured)

### Permission Denied Errors

- The `com.apple.security.files.user-selected.read-write` entitlement should allow access to user-selected files
- If issues persist, check macOS System Preferences > Security & Privacy > Privacy > Files and Folders

### File Upload Fails

- Verify the file size is within forum limits
- Check network connectivity
- Review server logs for upload errors

## Future Enhancements

Potential improvements:
- Add file type filtering (e.g., only images, only documents)
- Support for multiple file selection
- File size validation before upload
- Image compression/resizing for large images on macOS

## References

- [file_picker package documentation](https://pub.dev/packages/file_picker)
- [macOS App Sandbox entitlements](https://developer.apple.com/documentation/security/app_sandbox)
- [Flutter platform detection](https://docs.flutter.dev/development/platform-integration/platform-adaptations)

