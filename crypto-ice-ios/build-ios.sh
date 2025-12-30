#!/bin/bash

# Build iOS .ipa Script for CRYPTO ICE v4
# This script must be run on macOS with Xcode installed

echo "🔨 Building CRYPTO ICE v4 iOS App..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script must be run on macOS"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed. Please install Xcode from the App Store."
    exit 1
fi

# Sync Capacitor
echo "📱 Syncing Capacitor..."
npx cap sync ios

# Build the app
echo "🏗️  Building iOS app..."
xcodebuild -workspace ios/App.xcworkspace \
           -scheme App \
           -configuration Release \
           -destination generic/platform=iOS \
           -archivePath App.xcarchive \
           archive

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

# Export IPA
echo "📦 Exporting .ipa file..."
xcodebuild -exportArchive \
           -archivePath App.xcarchive \
           -exportPath ./build \
           -exportOptionsPlist ExportOptions.plist

if [ $? -eq 0 ]; then
    echo "✅ .ipa file created successfully!"
    echo "📍 Location: ./build/App.ipa"
    echo ""
    echo "To install on device:"
    echo "1. Connect iPhone to Mac"
    echo "2. Open Xcode → Window → Devices and Simulators"
    echo "3. Drag App.ipa to your device"
else
    echo "❌ Export failed"
    exit 1
fi
