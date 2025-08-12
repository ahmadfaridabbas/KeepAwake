#!/bin/bash

# Integrate Your Custom Icon Script
# This script integrates your KeepAwake.png icon into the app

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"
ASSETS_DIR="$APP_DIR/Assets.xcassets"
ORIGINAL_ICON="/Users/ahmadfaridabbas/Desktop/KeepAwake/KeepAwake.png"

echo "🎨 Integrating your custom KeepAwake icon..."

# Check if the original icon exists
if [ ! -f "$ORIGINAL_ICON" ]; then
    echo "❌ Icon not found at: $ORIGINAL_ICON"
    echo "Please make sure the file exists and try again."
    exit 1
fi

echo "✅ Found your icon: $ORIGINAL_ICON"

# Check if sips command is available (built into macOS)
if ! command -v sips &> /dev/null; then
    echo "❌ sips command not found. This script requires macOS."
    exit 1
fi

# Create directories
APPICON_DIR="$ASSETS_DIR/AppIcon.appiconset"
MENUBAR_ICON_DIR="$ASSETS_DIR/MenuBarIcon.imageset"

mkdir -p "$APPICON_DIR"
mkdir -p "$MENUBAR_ICON_DIR"

echo "🔄 Resizing your icon to all required sizes..."

# App Icon sizes for macOS
echo "📱 Creating app icons..."
sips -z 16 16 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_16x16.png" > /dev/null 2>&1
sips -z 32 32 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_16x16@2x.png" > /dev/null 2>&1
sips -z 32 32 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_32x32.png" > /dev/null 2>&1
sips -z 64 64 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_32x32@2x.png" > /dev/null 2>&1
sips -z 128 128 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_128x128.png" > /dev/null 2>&1
sips -z 256 256 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_128x128@2x.png" > /dev/null 2>&1
sips -z 256 256 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_256x256.png" > /dev/null 2>&1
sips -z 512 512 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_256x256@2x.png" > /dev/null 2>&1
sips -z 512 512 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_512x512.png" > /dev/null 2>&1
sips -z 1024 1024 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_512x512@2x.png" > /dev/null 2>&1

echo "✅ Created 10 app icon sizes"

# Menu Bar Icon sizes (for menu bar display)
echo "📋 Creating menu bar icons..."
sips -z 18 18 "$ORIGINAL_ICON" --out "$MENUBAR_ICON_DIR/menubar_icon.png" > /dev/null 2>&1
sips -z 36 36 "$ORIGINAL_ICON" --out "$MENUBAR_ICON_DIR/menubar_icon@2x.png" > /dev/null 2>&1
sips -z 54 54 "$ORIGINAL_ICON" --out "$MENUBAR_ICON_DIR/menubar_icon@3x.png" > /dev/null 2>&1

echo "✅ Created 3 menu bar icon sizes"

# Create a template version for menu bar (black/white)
echo "🎨 Creating template version for menu bar..."

# Create a black version for template rendering
sips -z 18 18 "$ORIGINAL_ICON" --out "$MENUBAR_ICON_DIR/template_icon.png" > /dev/null 2>&1
sips -z 36 36 "$ORIGINAL_ICON" --out "$MENUBAR_ICON_DIR/template_icon@2x.png" > /dev/null 2>&1
sips -z 54 54 "$ORIGINAL_ICON" --out "$MENUBAR_ICON_DIR/template_icon@3x.png" > /dev/null 2>&1

echo "✅ Created template icons"

echo ""
echo "🎉 Icon integration complete!"
echo ""
echo "📁 Generated files:"
echo "• App Icons: $APPICON_DIR (10 files)"
echo "• Menu Bar Icons: $MENUBAR_ICON_DIR (6 files)"
echo ""
echo "📋 Files created:"
ls -la "$APPICON_DIR" | grep "\.png" | wc -l | xargs echo "App icons:"
ls -la "$MENUBAR_ICON_DIR" | grep "\.png" | wc -l | xargs echo "Menu bar icons:"
echo ""
echo "🔧 Next step: Update app code to use your custom icon"
