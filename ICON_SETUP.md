# Pakida App Icon Setup

## Configuration Status ✅

### iOS Configuration
- **App Name**: Pakida (CFBundleDisplayName)
- **App ID**: pakida
- **Icon Location**: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- **Info.plist**: Configured with app name "Pakida"

### Android Configuration
- **App Name**: pakida
- **App Label**: Pakida
- **Icon Location**: `android/app/src/main/res/mipmap-*/ic_launcher.png`
- **Manifest**: Configured with app label and icon reference

### Web Configuration
- **Web Icon**: Set in `web/favicon.png`
- **Web manifest**: Configured in `web/manifest.json`

## Icon Assets
- **Logo SVG**: `assets/images/pakida_logo.svg` - Used in-app
- **Logo PNG**: `assets/images/pakida_logo.png` - Mobile app icon

## To Apply Custom Icons

### Option 1: Using flutter_launcher_icons (Automated)
Run the following command to auto-generate all platform icons from the PNG:
```bash
flutter pub run flutter_launcher_icons
```

This will automatically:
- Generate iOS app icons in multiple sizes
- Generate Android app icons in multiple densities
- Generate web and macOS icons

### Option 2: Manual Setup
1. **For iOS**: Replace the AppIcon set in Xcode
2. **For Android**: Replace PNG files in mipmap-* directories

## Current Setup
- Flutter configuration ready
- App name: "Pakida"
- Icon asset paths configured in pubspec.yaml
- Ready for deployment

## Next Steps
1. Place the high-resolution PNG icon (1024x1024 or larger) at `assets/images/pakida_logo.png`
2. Run `flutter pub run flutter_launcher_icons` to generate all sizes
3. Build for iOS/Android: `flutter build ios` or `flutter build apk`
