#!/bin/bash

# Icon Resizing Script
# This script helps resize your icon to all required sizes

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"
ASSETS_DIR="$APP_DIR/Assets.xcassets"

echo "🖼️  Icon Resizing Helper"
echo ""

# Check if sips command is available (built into macOS)
if ! command -v sips &> /dev/null; then
    echo "❌ sips command not found. This script requires macOS."
    exit 1
fi

echo "📝 Instructions:"
echo "1. Place your original icon file in this directory"
echo "2. Name it 'original_icon.png' (should be at least 1024x1024)"
echo "3. Run this script to generate all required sizes"
echo ""

ORIGINAL_ICON="$PROJECT_DIR/Amazon Q Scripts/original_icon.png"

if [ ! -f "$ORIGINAL_ICON" ]; then
    echo "⚠️  Original icon not found at: $ORIGINAL_ICON"
    echo ""
    echo "📋 To use this script:"
    echo "1. Copy your icon to: $PROJECT_DIR/Amazon Q Scripts/original_icon.png"
    echo "2. Make sure it's at least 1024x1024 pixels"
    echo "3. Run this script again"
    echo ""
    echo "🔧 Manual Alternative:"
    echo "You can manually resize your icon using any image editor to these sizes:"
    echo "• 16x16, 32x32, 64x64, 128x128, 256x256, 512x512, 1024x1024"
    echo ""
    exit 0
fi

echo "✅ Found original icon: $ORIGINAL_ICON"

# Create directories if they don't exist
APPICON_DIR="$ASSETS_DIR/AppIcon.appiconset"
MENUBAR_ICON_DIR="$ASSETS_DIR/MenuBarIcon.imageset"

mkdir -p "$APPICON_DIR"
mkdir -p "$MENUBAR_ICON_DIR"

echo "🔄 Resizing app icons..."

# App Icon sizes
sips -z 16 16 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_16x16.png" > /dev/null
sips -z 32 32 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_16x16@2x.png" > /dev/null
sips -z 32 32 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_32x32.png" > /dev/null
sips -z 64 64 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_32x32@2x.png" > /dev/null
sips -z 128 128 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_128x128.png" > /dev/null
sips -z 256 256 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_128x128@2x.png" > /dev/null
sips -z 256 256 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_256x256.png" > /dev/null
sips -z 512 512 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_256x256@2x.png" > /dev/null
sips -z 512 512 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_512x512.png" > /dev/null
sips -z 1024 1024 "$ORIGINAL_ICON" --out "$APPICON_DIR/icon_512x512@2x.png" > /dev/null

echo "✅ Created app icons (10 sizes)"

echo "🔄 Creating menu bar icons..."

# Menu Bar Icon sizes (template images - should be black/white)
sips -z 18 18 "$ORIGINAL_ICON" --out "$MENUBAR_ICON_DIR/menubar_icon.png" > /dev/null
sips -z 36 36 "$ORIGINAL_ICON" --out "$MENUBAR_ICON_DIR/menubar_icon@2x.png" > /dev/null
sips -z 54 54 "$ORIGINAL_ICON" --out "$MENUBAR_ICON_DIR/menubar_icon@3x.png" > /dev/null

echo "✅ Created menu bar icons (3 sizes)"

echo ""
echo "🎉 Icon resizing complete!"
echo ""
echo "📁 Generated files:"
echo "App Icons: $APPICON_DIR"
echo "Menu Bar Icons: $MENUBAR_ICON_DIR"
echo ""
echo "⚠️  Important Notes:"
echo "• Menu bar icons should be black/white template images"
echo "• If your original icon is colorful, you may need to create"
echo "  separate black/white versions for the menu bar"
echo "• Test the icons in both light and dark modes"
echo ""
echo "🔧 Next step: Update your app code to use the custom icons"
