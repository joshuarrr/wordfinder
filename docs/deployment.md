# Deployment Guide

This guide covers deploying the Word Finder app to:
1. **Web (Vercel)** - Production web deployment
2. **iOS (TestFlight)** - Testing distribution

## Prerequisites

- Flutter SDK installed and configured
- Vercel account (for web deployment)
- Apple Developer account (for iOS testing)
- Xcode installed (for iOS builds)

---

## 1. Web Deployment (Vercel)

**Important**: Vercel doesn't have Flutter SDK installed. You must build Flutter web locally first, then deploy the static files.

### Option A: Using Vercel CLI (Recommended)

1. **Install Vercel CLI** (if not already installed):
```bash
npm i -g vercel
```

2. **Build Flutter web app**:
```bash
flutter build web --release
```

3. **Deploy to Vercel**:
```bash
cd build/web
vercel --prod
```

Follow the prompts to:
- Link to existing project or create new one
- Configure project settings
- Deploy

### Option B: Using Git Integration with GitHub Actions (Recommended)

**Note**: Vercel doesn't have Flutter SDK, so we use GitHub Actions to build, then deploy to Vercel.

1. **Set up GitHub Actions** (already configured in `.github/workflows/deploy-vercel.yml`):
   - The workflow builds Flutter web and deploys to Vercel automatically

2. **Configure Vercel Secrets** in GitHub:
   - Go to your GitHub repo → Settings → Secrets and variables → Actions
   - Add these secrets:
     - `VERCEL_TOKEN`: Get from [Vercel Settings → Tokens](https://vercel.com/account/tokens)
     - `VERCEL_ORG_ID`: Found in Vercel project settings → General
     - `VERCEL_PROJECT_ID`: Found in Vercel project settings → General

3. **Push to main branch**:
   - The workflow will automatically build and deploy on each push

### Option B2: Manual Git Integration (Build Locally First)

1. **Build Flutter web locally**:
```bash
flutter build web --release
```

2. **Commit the build folder** (or use .gitignore and deploy manually):
   - Option A: Add `build/web` to git and commit
   - Option B: Deploy manually using Option A or C

3. **Configure Vercel**:
   - Go to [vercel.com](https://vercel.com)
   - Import your Git repository
   - Set Output Directory to `build/web`
   - Remove build/install commands (Vercel will serve static files)

### Option C: Manual Deployment

1. **Build the web app**:
```bash
flutter build web --release
```

2. **Deploy the `build/web` directory**:
   - Use Vercel dashboard: drag & drop the `build/web` folder
   - Or use CLI: `vercel --prod` from the `build/web` directory

### Post-Deployment

- Configure custom domain (optional)
- Set up environment variables if needed
- Configure redirects/rewrites in `vercel.json` if required

---

## 2. iOS Testing Distribution (TestFlight)

### Step 1: Configure App in Xcode

1. **Open the project in Xcode**:
```bash
open ios/Runner.xcworkspace
```

2. **Register Bundle Identifier** (if not already done):
   - Go to [Apple Developer Portal](https://developer.apple.com/account)
   - Navigate to Certificates, Identifiers & Profiles
   - Click Identifiers → "+" → App IDs
   - Select "App" → Continue
   - Description: Wordfinder
   - Bundle ID: Select "Explicit" and enter `fun.mindcookie.wordsearch`
   - Enable required capabilities (Push Notifications, etc. if needed)
   - Register the identifier

3. **Set up Signing & Capabilities**:
   - Select the `Runner` target
   - Go to "Signing & Capabilities" tab
   - Enable "Automatically manage signing"
   - Select your Team (Apple Developer account)
   - Ensure Bundle Identifier is `fun.mindcookie.wordsearch`

4. **Update Version & Build Number**:
   - In `pubspec.yaml`, update version (e.g., `1.0.0+1`)
   - Or set in Xcode: General tab → Version and Build

### Step 2: Build Archive

**Important**: Before archiving, ensure Flutter framework is built:
```bash
flutter build ios --release --no-codesign
```

1. **Select "Any iOS Device" or a specific device** from the device dropdown in Xcode

2. **Create Archive**:
   - Product → Clean Build Folder (Cmd+Shift+K)
   - Product → Archive
   - Wait for build to complete

3. **Distribute App**:
   - In Organizer window, select your archive
   - Click "Distribute App"
   - Choose "App Store Connect"
   - Select distribution method: "Upload"
   - Follow the wizard to upload

### Step 3: Configure in App Store Connect

1. **Go to [App Store Connect](https://appstoreconnect.apple.com)**

2. **Create App** (if not exists):
   - My Apps → "+" → New App
   - Platform: iOS
   - Name: Wordfinder
   - Primary Language: English
   - Bundle ID: `fun.mindcookie.wordsearch` (must be registered in Developer Portal first)
   - SKU: `wordfinder-001` (or unique identifier)
   
   **Note**: If bundle ID doesn't appear in dropdown, register it first in [Apple Developer Portal](https://developer.apple.com/account/resources/identifiers/list) under Identifiers → App IDs

3. **Set up TestFlight**:
   - Go to TestFlight tab
   - Wait for build processing (can take 10-30 minutes)
   - Once processed, add internal/external testers
   - Add test information (What to Test notes)

### Step 4: Add Testers

**Internal Testing** (up to 100 testers):
- TestFlight → Internal Testing → "+" → Add testers
- Testers must be added to your App Store Connect team

**External Testing** (up to 10,000 testers):
- TestFlight → External Testing → Create group
- Add testers via email or public link
- Requires App Review (first time only)

### Alternative: Ad Hoc Distribution (No TestFlight)

For direct device installation:

1. **Register Test Devices**:
   - App Store Connect → Users and Access → Devices
   - Add UDIDs of test devices

2. **Create Ad Hoc Provisioning Profile**:
   - Xcode → Preferences → Accounts → Download Manual Profiles
   - Or use Apple Developer portal

3. **Build with Ad Hoc Profile**:
   - In Xcode, select Ad Hoc scheme
   - Product → Archive
   - Distribute → Ad Hoc
   - Export IPA file

4. **Distribute IPA**:
   - Use TestFlight (recommended)
   - Or distribute via email/Diawi/TestFairy

---

## Quick Commands Reference

### Web Deployment
```bash
# Build
flutter build web --release

# Deploy (from build/web)
cd build/web && vercel --prod

# Or deploy from root with vercel.json
vercel --prod
```

### iOS Build
```bash
# Build iOS app
flutter build ios --release

# Build for specific configuration
flutter build ios --release --no-codesign

# Open in Xcode for manual archive
open ios/Runner.xcworkspace
```

---

## Troubleshooting

### Web Deployment Issues

- **Build fails**: Ensure Flutter web is enabled (`flutter config --enable-web`)
- **Assets not loading**: Check `pubspec.yaml` assets are correctly listed
- **Routing issues**: Configure redirects in `vercel.json`:
```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

### iOS Build Issues

- **Code signing errors**: Check Team selection in Xcode Signing & Capabilities
- **Bundle ID conflicts**: Ensure unique bundle identifier
- **Missing provisioning profile**: Enable "Automatically manage signing"
- **Archive not appearing**: Ensure "Any iOS Device" is selected, not simulator
- **"module 'Flutter' not found" errors**: 
  1. Build Flutter framework first: `flutter build ios --release --no-codesign`
  2. Clean Xcode derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
  3. Clean Flutter: `flutter clean && flutter pub get`
  4. Reinstall pods: `cd ios && pod install`
  5. In Xcode: Product → Clean Build Folder (Cmd+Shift+K)
  6. Close and reopen Xcode
  7. Try archiving again
  8. **If still failing**: The VerifyModule errors are often non-fatal. Try building from command line: `flutter build ipa --release` (creates .ipa file directly)
- **Deprecation warnings** (e.g., `allowBluetooth` in audioplayers_darwin): These are warnings from plugins and won't block the build. They'll be fixed in future plugin updates.

---

## Notes

- **Version Management**: Update version in `pubspec.yaml` before each release
- **Build Numbers**: Increment build number for each TestFlight upload
- **Web Assets**: Ensure all assets in `pubspec.yaml` are included
- **iOS Permissions**: Review `Info.plist` for required permissions/usage descriptions

