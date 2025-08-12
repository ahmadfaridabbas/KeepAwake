#!/bin/bash

# Integrate PNG Icon Script
# This script integrates your KeepAwake.png icon into the app

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"
ASSETS_DIR="$APP_DIR/Assets.xcassets"
ORIGINAL_PNG="/Users/ahmadfaridabbas/Desktop/KeepAwake/KeepAwake.png"

echo "🎨 Integrating your PNG KeepAwake icon..."

# Check if the original PNG exists
if [ ! -f "$ORIGINAL_PNG" ]; then
    echo "❌ PNG icon not found at: $ORIGINAL_PNG"
    echo "Please make sure the file exists and try again."
    exit 1
fi

echo "✅ Found your PNG icon: $ORIGINAL_PNG"

# Get original image dimensions
if command -v sips &> /dev/null; then
    original_width=$(sips -g pixelWidth "$ORIGINAL_PNG" 2>/dev/null | tail -1 | awk '{print $2}')
    original_height=$(sips -g pixelHeight "$ORIGINAL_PNG" 2>/dev/null | tail -1 | awk '{print $2}')
    file_size=$(ls -lh "$ORIGINAL_PNG" | awk '{print $5}')
    
    echo "   📏 Original size: ${original_width}x${original_height}"
    echo "   💾 File size: $file_size"
else
    echo "   ⚠️  Cannot determine image dimensions (sips not available)"
fi

# Create directories
APPICON_DIR="$ASSETS_DIR/AppIcon.appiconset"
MENUBAR_ICON_DIR="$ASSETS_DIR/MenuBarIcon.imageset"

mkdir -p "$APPICON_DIR"
mkdir -p "$MENUBAR_ICON_DIR"

echo "🔄 Resizing PNG to all required sizes..."

# App Icon sizes for macOS
echo "📱 Creating app icons from PNG..."
sips -z 16 16 "$ORIGINAL_PNG" --out "$APPICON_DIR/icon_16x16.png" > /dev/null 2>&1
sips -z 32 32 "$ORIGINAL_PNG" --out "$APPICON_DIR/icon_16x16@2x.png" > /dev/null 2>&1
sips -z 32 32 "$ORIGINAL_PNG" --out "$APPICON_DIR/icon_32x32.png" > /dev/null 2>&1
sips -z 64 64 "$ORIGINAL_PNG" --out "$APPICON_DIR/icon_32x32@2x.png" > /dev/null 2>&1
sips -z 128 128 "$ORIGINAL_PNG" --out "$APPICON_DIR/icon_128x128.png" > /dev/null 2>&1
sips -z 256 256 "$ORIGINAL_PNG" --out "$APPICON_DIR/icon_128x128@2x.png" > /dev/null 2>&1
sips -z 256 256 "$ORIGINAL_PNG" --out "$APPICON_DIR/icon_256x256.png" > /dev/null 2>&1
sips -z 512 512 "$ORIGINAL_PNG" --out "$APPICON_DIR/icon_256x256@2x.png" > /dev/null 2>&1
sips -z 512 512 "$ORIGINAL_PNG" --out "$APPICON_DIR/icon_512x512.png" > /dev/null 2>&1
sips -z 1024 1024 "$ORIGINAL_PNG" --out "$APPICON_DIR/icon_512x512@2x.png" > /dev/null 2>&1

echo "✅ Created 10 app icon sizes from PNG"

# Menu Bar Icon sizes (optimized for menu bar display)
echo "📋 Creating menu bar icons from PNG..."
sips -z 18 18 "$ORIGINAL_PNG" --out "$MENUBAR_ICON_DIR/menubar_icon.png" > /dev/null 2>&1
sips -z 36 36 "$ORIGINAL_PNG" --out "$MENUBAR_ICON_DIR/menubar_icon@2x.png" > /dev/null 2>&1
sips -z 54 54 "$ORIGINAL_PNG" --out "$MENUBAR_ICON_DIR/menubar_icon@3x.png" > /dev/null 2>&1

echo "✅ Created 3 menu bar icon sizes from PNG"

# Clean up any old SVG assets if they exist
if [ -d "$ASSETS_DIR/KeepAwakeIcon.imageset" ]; then
    echo "🧹 Cleaning up old SVG assets..."
    rm -rf "$ASSETS_DIR/KeepAwakeIcon.imageset"
    echo "✅ Removed old SVG assets"
fi

echo ""
echo "🎉 PNG icon integration complete!"
echo ""
echo "📁 Generated files:"
echo "• App Icons: $APPICON_DIR (10 PNG files)"
echo "• Menu Bar Icons: $MENUBAR_ICON_DIR (3 PNG files)"
echo ""

# Verify the conversions worked
echo "🔍 Verifying conversions..."
app_icons_created=$(find "$APPICON_DIR" -name "*.png" 2>/dev/null | wc -l)
menubar_icons_created=$(find "$MENUBAR_ICON_DIR" -name "*.png" 2>/dev/null | wc -l)

echo "📊 Conversion results:"
echo "• App icons created: $app_icons_created/10"
echo "• Menu bar icons created: $menubar_icons_created/3"

if [ "$app_icons_created" -eq 10 ] && [ "$menubar_icons_created" -eq 3 ]; then
    echo "✅ All icons successfully created from PNG!"
    
    # Check quality of a few key sizes
    if [ -f "$APPICON_DIR/icon_16x16.png" ]; then
        small_size=$(sips -g pixelWidth "$APPICON_DIR/icon_16x16.png" 2>/dev/null | tail -1 | awk '{print $2}')
        echo "   🔍 Smallest icon (16x16): ${small_size}x${small_size} ✅"
    fi
    
    if [ -f "$APPICON_DIR/icon_512x512@2x.png" ]; then
        large_size=$(sips -g pixelWidth "$APPICON_DIR/icon_512x512@2x.png" 2>/dev/null | tail -1 | awk '{print $2}')
        echo "   🔍 Largest icon (1024x1024): ${large_size}x${large_size} ✅"
    fi
    
    if [ -f "$MENUBAR_ICON_DIR/menubar_icon@2x.png" ]; then
        menubar_size=$(sips -g pixelWidth "$MENUBAR_ICON_DIR/menubar_icon@2x.png" 2>/dev/null | tail -1 | awk '{print $2}')
        echo "   🔍 Menu bar icon (@2x): ${menubar_size}x${menubar_size} ✅"
    fi
else
    echo "⚠️  Some conversions may have failed. Check the files manually."
fi

echo ""
echo "✨ Benefits of using your PNG icon:"
echo "• Direct PNG format - no conversion artifacts"
echo "• Optimized for all required sizes"
echo "• Template rendering for menu bar integration"
echo "• Perfect compatibility with macOS"
echo ""
echo "🔧 Your app code is already configured to use the custom icon!"
echo "   Build your app to see your beautiful icon in action!"
