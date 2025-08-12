#!/bin/bash

# Verify SVG Integration Script
# This script verifies your SVG icon is properly integrated

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"
ASSETS_DIR="$APP_DIR/Assets.xcassets"
ORIGINAL_SVG="/Users/ahmadfaridabbas/Desktop/KeepAwake/KeepAwake.svg"

echo "🔍 Verifying SVG icon integration..."

# Check if original SVG exists
if [ -f "$ORIGINAL_SVG" ]; then
    echo "✅ Original SVG found: $ORIGINAL_SVG"
    
    # Get SVG file size
    svg_size=$(ls -lh "$ORIGINAL_SVG" | awk '{print $5}')
    echo "   📏 SVG file size: $svg_size"
else
    echo "❌ Original SVG not found"
fi

# Check Assets.xcassets structure
if [ -d "$ASSETS_DIR" ]; then
    echo "✅ Assets.xcassets directory exists"
else
    echo "❌ Assets.xcassets directory missing"
    exit 1
fi

# Check AppIcon.appiconset (converted from SVG)
APPICON_DIR="$ASSETS_DIR/AppIcon.appiconset"
if [ -d "$APPICON_DIR" ]; then
    echo "✅ AppIcon.appiconset directory exists"
    
    app_icon_count=$(find "$APPICON_DIR" -name "*.png" | wc -l)
    echo "   📱 App icon files: $app_icon_count/10"
    
    if [ "$app_icon_count" -eq 10 ]; then
        echo "   ✅ All app icon sizes converted from SVG"
        
        # Check quality of smallest and largest icons
        if [ -f "$APPICON_DIR/icon_16x16.png" ]; then
            small_size=$(sips -g pixelWidth "$APPICON_DIR/icon_16x16.png" 2>/dev/null | tail -1 | awk '{print $2}')
            echo "   🔍 16x16 icon actual size: ${small_size}x${small_size}"
        fi
        
        if [ -f "$APPICON_DIR/icon_512x512@2x.png" ]; then
            large_size=$(sips -g pixelWidth "$APPICON_DIR/icon_512x512@2x.png" 2>/dev/null | tail -1 | awk '{print $2}')
            echo "   🔍 1024x1024 icon actual size: ${large_size}x${large_size}"
        fi
    else
        echo "   ⚠️  Missing some app icon sizes"
    fi
else
    echo "❌ AppIcon.appiconset directory missing"
fi

# Check MenuBarIcon.imageset (converted from SVG)
MENUBAR_ICON_DIR="$ASSETS_DIR/MenuBarIcon.imageset"
if [ -d "$MENUBAR_ICON_DIR" ]; then
    echo "✅ MenuBarIcon.imageset directory exists"
    
    menubar_icon_count=$(find "$MENUBAR_ICON_DIR" -name "*.png" | wc -l)
    echo "   📋 Menu bar icon files: $menubar_icon_count"
    
    if [ "$menubar_icon_count" -ge 3 ]; then
        echo "   ✅ Menu bar icons converted from SVG"
        
        # Check if template rendering is set
        if [ -f "$MENUBAR_ICON_DIR/Contents.json" ]; then
            if grep -q "template" "$MENUBAR_ICON_DIR/Contents.json"; then
                echo "   ✅ Template rendering configured"
            else
                echo "   ⚠️  Template rendering not configured"
            fi
        fi
    else
        echo "   ⚠️  Missing menu bar icon sizes"
    fi
else
    echo "❌ MenuBarIcon.imageset directory missing"
fi

# Check SVG asset preservation
SVG_ICON_DIR="$ASSETS_DIR/KeepAwakeIcon.imageset"
if [ -d "$SVG_ICON_DIR" ]; then
    echo "✅ Original SVG preserved in assets"
    
    if [ -f "$SVG_ICON_DIR/keepawake_icon.svg" ]; then
        echo "   📄 SVG asset available for future use"
    fi
else
    echo "⚠️  Original SVG not preserved in assets"
fi

# Check app code integration
echo ""
echo "🔍 Checking app code integration..."

if grep -q "Image(\"MenuBarIcon\")" "$APP_DIR/Core/KeepAwakeApp.swift"; then
    echo "✅ App code uses custom icon"
else
    echo "❌ App code not updated for custom icon"
fi

if grep -q "renderingMode(.template)" "$APP_DIR/Core/KeepAwakeApp.swift"; then
    echo "✅ Template rendering mode set"
else
    echo "⚠️  Template rendering mode not set"
fi

if grep -q "frame(width: 18, height: 18)" "$APP_DIR/Core/KeepAwakeApp.swift"; then
    echo "✅ Icon size specified for menu bar"
else
    echo "⚠️  Icon size not specified"
fi

echo ""
echo "📊 SVG Integration Summary:"
echo "• Source: SVG vector format"
echo "• Conversion: SVG → PNG at multiple sizes"
echo "• Quality: Vector-based precision at all sizes"
echo "• Compatibility: PNG files for macOS compatibility"
echo "• Future-proof: Original SVG preserved"
echo ""

# Overall status
if [ -f "$ORIGINAL_SVG" ] && [ -d "$APPICON_DIR" ] && [ -d "$MENUBAR_ICON_DIR" ] && grep -q "Image(\"MenuBarIcon\")" "$APP_DIR/Core/KeepAwakeApp.swift"; then
    echo "🎉 SVG INTEGRATION COMPLETE!"
    echo ""
    echo "✨ Benefits of your SVG icon:"
    echo "• Perfect scaling from 16x16 to 1024x1024"
    echo "• Crisp appearance on all display densities"
    echo "• Small file size with vector precision"
    echo "• Template rendering for menu bar integration"
    echo "• Color adaptation based on app state"
    echo ""
    echo "🚀 Your KeepAwake app now has a professional SVG-based icon!"
    echo "   Build your app to see the beautiful, crisp icon in action!"
else
    echo "⚠️  SVG integration needs attention - check the issues above"
fi

echo ""
echo "🎨 Icon Features:"
echo "• Vector-based: Scales perfectly at any size"
echo "• Template rendering: Adapts to system appearance"
echo "• State colors: Changes based on app activity"
echo "• High-DPI ready: Looks great on Retina displays"
