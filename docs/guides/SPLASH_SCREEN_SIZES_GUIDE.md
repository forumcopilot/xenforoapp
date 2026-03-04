# Splash Screen Sizes Guide

## **Optimal Image Sizes for Different Devices**

### **iPhone Sizes (iOS)**
- **iPhone 14 Pro Max**: 1290x2796 pixels
- **iPhone 14 Pro**: 1179x2556 pixels
- **iPhone 14 Plus**: 1284x2778 pixels
- **iPhone 14**: 1170x2532 pixels
- **iPhone 13 Pro Max**: 1284x2778 pixels
- **iPhone 13 Pro**: 1170x2532 pixels
- **iPhone 13**: 1170x2532 pixels
- **iPhone 12 Pro Max**: 1284x2778 pixels
- **iPhone 12 Pro**: 1170x2532 pixels
- **iPhone 12**: 1170x2532 pixels

**Recommended iOS size**: **1170x2532 pixels** (covers most modern iPhones)

### **Android Sizes**
- **High-end phones**: 1440x3200 pixels
- **Mid-range phones**: 1080x2400 pixels
- **Budget phones**: 720x1600 pixels

**Recommended Android size**: **1080x2400 pixels** (good balance)

### **Universal Approach**
- **Primary size**: 1170x2532 pixels (iPhone 14 size)
- **Format**: PNG with transparency support
- **Background**: Should match your app's theme

## **Current Configuration**

Your current setup uses:
```yaml
flutter_native_splash:
  image: assets/splash.png
  ios_content_mode: scaleAspectFill  # Fills entire screen
  fullscreen: true
  android_gravity: center
```

## **How to Create Multi-Size Splash Screens**

### **Option 1: Single High-Resolution Image**
1. Create a 1170x2532 image
2. Design for iPhone aspect ratio
3. Let Android scale it down

### **Option 2: Platform-Specific Images**
```yaml
flutter_native_splash:
  color: "#FFFFFF"
  
  # Android image
  image: assets/splash_android.png
  
  # iOS image
  image_ios: assets/splash_ios.png
  
  android_12:
    image: assets/splash_android.png
    color: "#FFFFFF"
```

### **Option 3: Multiple Density Images**
```yaml
flutter_native_splash:
  color: "#FFFFFF"
  image: assets/splash.png
  
  # Different sizes for different densities
  image_android: assets/splash_android.png
  image_ios: assets/splash_ios.png
```

## **Design Guidelines**

### **For Full-Screen Coverage**
1. **Use `scaleAspectFill`**: Ensures no letterboxing
2. **Design for center**: Important elements in center 1/3
3. **Extend background**: Fill entire canvas
4. **Test on devices**: Always test on actual devices

### **Safe Zones**
- **Center area**: 390x844 pixels (iPhone 12/13/14 center)
- **Top safe area**: 47px from top
- **Bottom safe area**: 34px from bottom
- **Side margins**: 20px from edges

## **Testing Different Sizes**

### **Current Test Setup**
- ✅ Using `forumcopiloticon.png` as temporary splash
- ✅ `scaleAspectFill` ensures full-screen coverage
- ✅ Generated for all Android densities
- ✅ Generated for iOS devices

### **Next Steps**
1. **Replace with your 1170x2532 image**
2. **Test on different devices**
3. **Adjust design if needed**

## **Commands for Regeneration**

```bash
# Regenerate splash screens
dart run flutter_native_splash:create

# Clean and rebuild
flutter clean
flutter pub get

# Test on devices
flutter run -d [device_id]
```

## **Troubleshooting**

### **Common Issues**
1. **File corruption**: Check file size and format
2. **Wrong aspect ratio**: Use `scaleAspectFill`
3. **Letterboxing**: Ensure full-screen design
4. **Performance**: Keep file size under 1MB

### **File Requirements**
- **Format**: PNG (preferred) or JPG
- **Size**: 1170x2532 pixels (recommended)
- **File size**: Under 1MB
- **Transparency**: PNG supports alpha channel

## **Current Status**
- ✅ Configuration updated for full-screen coverage
- ✅ Splash screens generated for all densities
- ✅ Ready for your 1170x2532 image
- ✅ iOS and Android support configured 