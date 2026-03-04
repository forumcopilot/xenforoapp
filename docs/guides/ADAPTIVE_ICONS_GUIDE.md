# Adaptive App Icons Guide

## Overview
This guide explains how to create app icons that automatically adapt to light and dark themes on iOS and Android.

## Required Image Assets

### 1. **iOS Adaptive Icons**

You need to prepare these images:

#### Light Mode Icon
- **File**: `assets/forumcopiloticon.png` (already exists)
- **Size**: 1024x1024 pixels
- **Format**: PNG
- **Background**: Transparent or light background
- **Content**: Your app logo/icon

#### Dark Mode Icon
- **File**: `assets/forumcopiloticon_dark.png` (already exists)
- **Size**: 1024x1024 pixels
- **Format**: PNG
- **Background**: Transparent or dark background
- **Content**: Dark mode optimized version of the logo

### 2. **Android Adaptive Icons**

You need to prepare these images:

#### Foreground Icon
- **File**: `assets/forumcopiloticon.png` (already exists)
- **Size**: 432x432 pixels (for xxxhdpi)
- **Format**: PNG
- **Background**: Transparent
- **Content**: Just the icon content without background

#### Background Icon (Optional)
- **File**: `assets/forum_copilot_background.png` (already exists)
- **Size**: 432x432 pixels
- **Format**: PNG
- **Content**: Solid color or gradient background

## Image Preparation Guidelines

### For iOS:
1. **Light Mode Icon**: Use your existing `forumcopiloticon.png`
2. **Dark Mode Icon**: Create a version that looks good on dark backgrounds
   - Use lighter colors for the icon
   - Ensure good contrast against dark backgrounds
   - Keep the same design but adjust colors

### For Android:
1. **Foreground Icon**: Extract just the icon content
   - Remove the background
   - Keep only the main icon elements
   - Use transparent background
2. **Background**: Can use a solid color or gradient

## Configuration

The `pubspec.yaml` has been updated with:

```yaml
flutter_icons:
  android: true
  ios: true
  image_path: "assets/forumcopiloticon.png"
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/forumcopiloticon.png"
  ios_content_mode: scaleAspectFit
  dark_mode_ios: "assets/forumcopiloticon_dark.png"
  dark_mode_android: "assets/forumcopiloticon_dark.png"
```

## Steps to Complete Setup

1. **Icon Setup Complete**:
   - Light mode: `assets/forumcopiloticon.png`
   - Dark mode: `assets/forumcopiloticon_dark.png`
   - Icons have been successfully generated for both platforms

2. **Generate Icons**:
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons:main
   ```

## Testing

### iOS:
- Icons will automatically switch based on system theme
- Test on device with light/dark mode switching

### Android:
- Adaptive icons will show foreground on system-provided background
- Test on different Android versions

## Best Practices

1. **Contrast**: Ensure good contrast in both light and dark modes
2. **Simplicity**: Keep icons simple and recognizable at small sizes
3. **Consistency**: Maintain the same design language across modes
4. **Testing**: Test on actual devices with different themes

## Troubleshooting

- If icons don't appear: Check file paths and regenerate
- If dark mode doesn't work: Verify dark mode image exists
- If Android icons look wrong: Check foreground image has transparent background 