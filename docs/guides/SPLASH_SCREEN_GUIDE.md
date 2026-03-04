# Splash Screen Update Guide

## Overview
This guide explains how to update splash screens for both iOS and Android in your Flutter project.

## Current Setup
Your project now uses:
- **Native splash screen**: Generated using `flutter_native_splash` package
- **Flutter splash screen widget**: Updated to show loading state
- **Launcher icons**: Generated using `flutter_launcher_icons`

## How to Update Splash Screen

### 1. Update the Splash Image
1. Replace `assets/splash.png` with your new splash screen image
2. Recommended image specifications:
   - **Format**: PNG (better quality) or JPG
   - **Size**: At least 1024x1024 pixels
   - **Aspect ratio**: 1:1 (square) works best
   - **Background**: Should match your app's theme

### 2. Update Configuration
Edit `flutter_native_splash.yaml` to customize:
```yaml
flutter_native_splash:
  # Background color
  color: "#FFFFFF"  # Change to your preferred color
  
  # Image to display
  image: assets/splash.png  # Update path if needed
  
  # Android specific settings
  android_12:
    image: assets/splash.png
    color: "#FFFFFF"
    icon_background_color: "#FFFFFF"
  
  # iOS specific settings
  ios_content_mode: scaleAspectFit
  
  # Full screen mode
  fullscreen: true
  
  # Platform-specific settings
  android: true
  ios: true
  web: false
  
  # Remove splash screen after initialization
  android_gravity: center
```

### 3. Generate Native Splash Screen
Run this command to generate the native splash screen:
```bash
dart run flutter_native_splash:create
```

### 4. Update Launcher Icons (Optional)
If you want to update app icons to match your splash screen:
1. Update the icon images in `assets/`
2. Run: `dart run flutter_launcher_icons`

## Platform-Specific Customization

### Android
- **Location**: `android/app/src/main/res/`
- **Files**: Various `drawable` and `values` folders
- **Android 12+**: Uses splash screen API with different styling

### iOS
- **Location**: `ios/Runner/`
- **Files**: `LaunchScreen.storyboard` and `Info.plist`
- **Status bar**: Can be hidden/shown during splash

## Advanced Customization

### Dark Mode Support
Add dark mode variants to your configuration:
```yaml
flutter_native_splash:
  color: "#FFFFFF"
  image: assets/splash.png
  
  # Dark mode variants
  color_dark: "#000000"
  image_dark: assets/splash_dark.png
  
  android_12:
    image: assets/splash.png
    color: "#FFFFFF"
    image_dark: assets/splash_dark.png
    color_dark: "#000000"
```

### Custom Branding
You can add text or logos to your splash screen:
```yaml
flutter_native_splash:
  color: "#FFFFFF"
  image: assets/splash.png
  
  # Add branding text
  branding: assets/branding.png
  branding_dark: assets/branding_dark.png
  
  # Text styling
  branding_mode: bottom
  fullscreen: true
```

## Testing
1. **Clean build**: `flutter clean && flutter pub get`
2. **Test on device**: Run on actual iOS/Android devices
3. **Verify timing**: Ensure splash screen doesn't show too long

## Troubleshooting

### Common Issues
1. **Image not showing**: Check file path and format
2. **Wrong colors**: Verify color values in configuration
3. **Build errors**: Clean and rebuild project
4. **iOS issues**: Check `Info.plist` for status bar settings

### Commands
```bash
# Clean and rebuild
flutter clean
flutter pub get

# Regenerate splash screen
dart run flutter_native_splash:create

# Regenerate icons
dart run flutter_launcher_icons

# Build for testing
flutter build apk --debug
flutter build ios --debug
```

## Best Practices
1. **Keep it simple**: Avoid complex animations or text
2. **Match branding**: Use consistent colors and logos
3. **Test on devices**: Always test on real devices
4. **Consider loading time**: Don't make splash screen too long
5. **Accessibility**: Ensure good contrast and readability

## Files Modified
- `flutter_native_splash.yaml` - Configuration file
- `lib/views/splash_screen.dart` - Flutter splash widget
- `pubspec.yaml` - Added flutter_native_splash dependency
- Platform-specific files generated automatically 