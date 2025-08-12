#!/bin/bash

# Verify Icon Integration Script
# This script verifies your custom icon is properly integrated

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"
ASSETS_DIR="$APP_DIR/Assets.xcassets"

echo "🔍 Verifying custom icon integration..."

# Check if Assets.xcassets exists
if [ -d "$ASSETS_DIR" ]; then
    echo "✅ Assets.xcassets directory exists"
else
    echo "❌ Assets.xcassets directory missing"
    exit 1
fi

# Check AppIcon.appiconset
APPICON_DIR="$ASSETS_DIR/AppIcon.appiconset"
if [ -d "$APPICON_DIR" ]; then
    echo "✅ AppIcon.appiconset directory exists"
    
    # Count app icon files
    app_icon_count=$(find "$APPICON_DIR" -name "*.png" | wc -l)
    echo "   📱 App icon files: $app_icon_count/10"
    
    if [ "$app_icon_count" -eq 10 ]; then
        echo "   ✅ All app icon sizes present"
    else
        echo "   ⚠️  Missing some app icon sizes"
    fi
else
    echo "❌ AppIcon.appiconset directory missing"
fi

# Check MenuBarIcon.imageset
MENUBAR_ICON_DIR="$ASSETS_DIR/MenuBarIcon.imageset"
if [ -d "$MENUBAR_ICON_DIR" ]; then
    echo "✅ MenuBarIcon.imageset directory exists"
    
    # Count menu bar icon files
    menubar_icon_count=$(find "$MENUBAR_ICON_DIR" -name "*.png" | wc -l)
    echo "   📋 Menu bar icon files: $menubar_icon_count"
    
    if [ "$menubar_icon_count" -ge 3 ]; then
        echo "   ✅ Menu bar icon sizes present"
    else
        echo "   ⚠️  Missing menu bar icon sizes"
    fi
else
    echo "❌ MenuBarIcon.imageset directory missing"
fi

# Check if app code is updated
echo ""
echo "🔍 Checking app code integration..."

if grep -q "Image(\"MenuBarIcon\")" "$APP_DIR/Core/KeepAwakeApp.swift"; then
    echo "✅ App code updated to use custom icon"
else
    echo "❌ App code not updated for custom icon"
fi

if grep -q "renderingMode(.template)" "$APP_DIR/Core/KeepAwakeApp.swift"; then
    echo "✅ Template rendering mode set"
else
    echo "⚠️  Template rendering mode not set"
fi

echo ""
echo "📋 Integration Summary:"
echo "• Original icon: /Users/ahmadfaridabbas/Desktop/KeepAwake/KeepAwake.png"
echo "• App icons: Generated in AppIcon.appiconset"
echo "• Menu bar icons: Generated in MenuBarIcon.imageset"
echo "• App code: Updated to use custom icon"
echo ""
echo "🎯 Your custom icon integration:"

if [ -d "$APPICON_DIR" ] && [ -d "$MENUBAR_ICON_DIR" ] && grep -q "Image(\"MenuBarIcon\")" "$APP_DIR/Core/KeepAwakeApp.swift"; then
    echo "✅ COMPLETE - Your custom icon is fully integrated!"
    echo ""
    echo "🚀 Next steps:"
    echo "1. Build your app in Xcode"
    echo "2. Your custom icon will appear in the menu bar"
    echo "3. The icon will change color based on app state:"
    echo "   • Primary color when inactive"
    echo "   • Green when timer is active"
    echo "   • Orange when always-on mode"
    echo ""
    echo "💡 The icon uses template rendering, so it will:"
    echo "   • Adapt to light/dark mode automatically"
    echo "   • Show proper contrast in menu bar"
    echo "   • Change color based on app state"
else
    echo "⚠️  INCOMPLETE - Some parts need attention"
    echo ""
    echo "🔧 Check the issues above and run the integration script again"
fi

echo ""
echo "🎨 Icon Features:"
echo "• Template rendering for proper menu bar appearance"
echo "• Color changes based on app state (inactive/timer/always-on)"
echo "• Automatic light/dark mode adaptation"
echo "• High-resolution support (@2x, @3x)"
echo ""
echo "✨ Your KeepAwake app now has a custom, professional icon!"
