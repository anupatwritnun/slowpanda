# iOS Deployment Guide - KalmFu Panda

## Prerequisites

- Mac computer with macOS 13+ (Ventura or later recommended)
- Xcode 15.0+ installed
- Apple Developer Account ($99/year)
- CocoaPods installed: `sudo gem install cocoapods`

---

## Step 1: Open Project on Mac

```bash
cd /path/to/KalmFu\ Panda/slowpanda

# Install Flutter dependencies
flutter pub get

# Install CocoaPods dependencies
cd ios
pod install
cd ..

# Open in Xcode
open ios/Runner.xcworkspace
```

---

## Step 2: Configure Bundle Identifier

In Xcode:
1. Select **Runner** project in the left sidebar
2. Select **Runner** target
3. Go to **General** tab
4. Set **Bundle Identifier** to your unique ID (e.g., `com.kalmfu.panda`)

---

## Step 3: Code Signing

### For Development (TestFlight/Ad-hoc):
1. In Xcode, go to **Signing & Capabilities**
2. Check **Automatically manage signing**
3. Select your **Team** (Apple Developer account)
4. Xcode will create provisioning profile automatically

### For App Store Release:
1. Create app listing in **App Store Connect**
2. Use the same Bundle Identifier
3. Xcode will fetch the correct distribution profile

---

## Step 4: App Icons

Required sizes for all iOS devices:

| Size | Use |
|------|-----|
| 1024x1024 | App Store (required) |
| 180x180 | iPhone @3x |
| 120x120 | iPhone @2x |
| 167x167 | iPad Pro @2x |
| 152x152 | iPad @2x |
| 76x76 | iPad @1x |

**Location:** `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

---

## Step 5: Build for Release

### Option A: Build from Xcode (Recommended)
1. Select **Any iOS Device (arm64)** as target
2. **Product** → **Archive**
3. Wait for archive to complete
4. **Distribute App** → Follow prompts

### Option B: Build from Command Line
```bash
flutter build ios --release

# Then open Xcode to archive:
open ios/Runner.xcworkspace
# Product → Archive → Distribute App
```

---

## Step 6: Upload to App Store Connect

1. After archive completes, click **Distribute App**
2. Choose **App Store Connect**
3. Upload the build
4. Wait for processing (usually 5-30 minutes)

---

## Step 7: Submit for Review

In **App Store Connect**:
1. Go to your app
2. Select the build you just uploaded
3. Complete app information:
   - Screenshots (required for each device size)
   - Description
   - Keywords
   - Support URL
   - Privacy Policy URL
4. **Add for Review**

---

## Current Configuration Status

| Setting | Status |
|---------|--------|
| Min iOS Version | 15.0 ✓ |
| Podfile | Created ✓ |
| Photo Library Permission | ✓ Info.plist configured |
| Instagram/Facebook URL Schemes | ✓ Info.plist configured |
| Display Name | "KalmFu Panda" ✓ |
| Bundle Identifier | Set in Xcode |
| Code Signing | Configure in Xcode |
| App Icons | Add your icons |

---

## Required Privacy Info in App Store Connect

| Privacy Type | Data Collected |
|--------------|----------------|
| Photos | User can save quote cards to photo library |
| App Activity | None |
| Contact Info | None |
| User Content | None |

---

## Post-Release Checklist

- [ ] Test on physical iPhone device
- [ ] Verify TestFlight build works
- [ ] Check quote API is working
- [ ] Test share functionality (Instagram, Facebook, Twitter)
- [ ] Verify all permissions work
- [ ] Add App Store screenshots (6.7" and 6.1" iPhone required)
- [ ] Set app price (Free or Paid)
- [ ] Enable/disable age rating options

---

## Build Commands Reference

```bash
# Clean build
flutter clean
cd ios && rm -rf Pods Podfile.lock && cd ..

# Rebuild
flutter pub get
cd ios && pod install && cd ..

# Build release
flutter build ios --release

# Check for issues
flutter analyze
flutter test
```

---

## Troubleshooting

### "No such module" error
```bash
cd ios
pod deintegrate
pod install
```

### Code signing errors
- Clean Build Folder: **Cmd+Shift+K**
- Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`

### CocoaPods stuck
```bash
pod repo update --verbose
```

---

## Quick Summary

1. **On Mac**: `flutter build ios --release`
2. **Xcode**: Archive & Distribute
3. **App Store Connect**: Complete metadata & Submit

**Estimated Time to App Store**: 2-7 days (review period)
