# iOS Deployment from Windows - KalmFu Panda

Since you're on Windows, you cannot build iOS apps directly. Here are your options:

---

## Option 1: Codemagic (Recommended - Free Tier)

Codemagic is a Flutter-focused CI/CD service with free tier for iOS builds.

### Steps:

1. **Go to** [codemagic.io](https://codemagic.io)
2. **Sign up** with GitHub/GitLab/Bitbucket
3. **Connect your repository**
4. **Configure app settings:**
   - Flutter project
   - iOS build target
   - Bundle ID (e.g., `com.kalmfu.panda`)

5. **Set up code signing:**
   - Upload your Apple Developer certificate (.p12)
   - Upload provisioning profile from Apple Developer Portal

6. **Start build** → Download `.ipa` file
7. **Upload to App Store Connect** via Transporter app

### Pricing:
- **Free**: 1 build/month (iOS)
- **Paid**: $10/month for more builds

---

## Option 2: GitHub Actions (Free for public repos)

If your code is on GitHub, use GitHub Actions macOS runners.

### Create file: `.github/workflows/ios.yml`

```yaml
name: iOS Release Build

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build:
    runs-on: macos-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Install CocoaPods
        run: |
          cd ios
          pod install
          cd ..

      - name: Build iOS (no codesign)
        run: flutter build ios --release --no-codesign

      - name: Archive
        run: |
          cd build/ios/iphoneos
          zip -r Runner.zip Runner.app

      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: ios-build
          path: build/ios/iphoneos/Runner.zip
```

**Note:** You'll still need a Mac for code signing or use a 3rd party signing service.

---

## Option 3: Cloud Mac Services

### MacStadium (macOS cloud VM)
- Website: [macstadium.com](https://macstadium.com)
- Pricing: ~$1-4/hour
- Full Mac control via remote desktop

### AWS Mac Instances
- `mac1.metal` instance
- ~$1.08/hour
- Full macOS environment

### MacInCloud
- Website: [macincloud.com](https://macincloud.com)
- Rent a Mac remotely
- ~$30-50/month

---

## Option 4: CI/CD Services with iOS Support

| Service | Free Tier | Price |
|---------|-----------|-------|
| **Codemagic** | 1 build/month | From $10/mo |
| **Bitrise** | Free tier limited | From $30/mo |
| **Appcircle** | Free tier available | From $50/mo |
| **Nevercode** | Free tier limited | From $39/mo |

---

## Option 5: Borrow/Remote Access to a Mac

- Ask a friend with a Mac
- Use Microsoft Remote Desktop to connect to a Mac
- Services like TeamViewer/AnyDesk with someone's Mac

---

## Quick Comparison

| Option | Cost | Difficulty | Speed |
|--------|------|------------|-------|
| **Codemagic** | Free/$10 | Easy | Fast |
| **GitHub Actions** | Free (public) | Medium | Medium |
| **MacStadium AWS** | $1-4/hour | Medium | Fast |
| **Borrow Mac** | Free | Hard (access) | Varies |

---

## Recommended Setup for You

### Easiest Path: Codemagic

1. Push code to GitHub/GitLab
2. Sign up at codemagic.io
3. Connect your repo
4. Add Apple Developer certificate
5. Build and download `.ipa`
6. Upload to App Store Connect via Transporter on Windows

### Transporter on Windows

You can upload iOS apps to App Store from Windows using:
- **Apple Transporter** via web: [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
- Or **iMazing** on Windows

---

## What You Need Regardless of Method

1. **Apple Developer Account** ($99/year)
2. **Bundle Identifier** (e.g., `com.kalmfu.panda`)
3. **Distribution Certificate** (.p12 file)
4. **Provisioning Profile**
5. **App Store Connect** app listing created

---

## Quick Start with Codemagic

```bash
# 1. Push your code to GitHub
git init
git add .
git commit -m "Ready for iOS build"
git remote add origin https://github.com/yourusername/slowpanda.git
git push -u origin main

# 2. Go to codemagic.io and:
#    - Sign up/login
#    - Click "Add new app"
#    - Connect GitHub
#    - Select this repository
#    - Configure iOS build

# 3. Download the .ipa file when build completes

# 4. Upload via:
#    - App Store Connect (web)
#    - or Transporter app on Windows
```

---

## Current Status

| Item | Ready |
|------|-------|
| Flutter project | ✓ |
| Podfile (iOS 15.0) | ✓ |
| Info.plist permissions | ✓ |
| Deployment config | ✓ |
| `codemagic.yaml` | ✓ Created |
| Apple Developer account | Needed |
| Certificate & profile | Needed |
| App icons | Needed |

---

Let me know which option you want to use, and I can provide more detailed steps!
