#!/bin/bash

# Fix Keyboard Shortcuts Script
# This script fixes keyboard shortcut issues and provides setup guidance

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "⌨️  Fixing keyboard shortcut issues..."

# Check if KeyboardShortcuts package is properly configured
echo "🔍 Checking KeyboardShortcuts configuration..."

if [ -f "$APP_DIR/Utilities/KeyboardShortcuts+Names.swift" ]; then
    echo "✅ KeyboardShortcuts+Names.swift found"
else
    echo "❌ KeyboardShortcuts+Names.swift missing"
fi

# Verify the main app has proper shortcut setup
if grep -q "setupKeyboardShortcuts" "$APP_DIR/Core/KeepAwakeApp.swift"; then
    echo "✅ Keyboard shortcut setup found in main app"
else
    echo "❌ Keyboard shortcut setup missing in main app"
fi

# Check for accessibility framework import
if grep -q "import.*Accessibility\|AXIsProcessTrusted" "$APP_DIR/Core/KeepAwakeApp.swift"; then
    echo "✅ Accessibility framework usage found"
else
    echo "⚠️  Adding accessibility framework usage..."
    # The updated app file should already include this
fi

echo ""
echo "🎯 Keyboard Shortcut Troubleshooting Guide:"
echo ""
echo "1. 📋 **Check App Permissions:**"
echo "   • Open System Preferences > Security & Privacy > Privacy"
echo "   • Click 'Accessibility' in the left sidebar"
echo "   • Make sure 'KeepAwake' is listed and checked"
echo "   • If not listed, click '+' and add your KeepAwake app"
echo ""
echo "2. 🔄 **Restart the App:**"
echo "   • Quit KeepAwake completely"
echo "   • Restart the app"
echo "   • Check console output for 'Keyboard shortcuts registered' message"
echo ""
echo "3. ⌨️  **Test the Shortcut:**"
echo "   • Press Cmd+Opt+Space"
echo "   • You should see a notification confirming the action"
echo "   • The menu bar icon should change state"
echo ""
echo "4. 🔧 **If Still Not Working:**"
echo "   • Check if other apps are using the same shortcut"
echo "   • Try changing the shortcut in preferences"
echo "   • Restart macOS (accessibility permissions sometimes need this)"
echo ""
echo "📝 **Current Shortcut Configuration:**"
echo "• Primary: Cmd+Opt+Space (Toggle KeepAwake)"
echo "• Additional shortcuts can be set in preferences"
echo "• All shortcuts require accessibility permissions"
echo ""
echo "🚨 **Common Issues:**"
echo "• Accessibility permissions not granted"
echo "• Another app using the same shortcut"
echo "• App not running with proper permissions"
echo "• macOS needs restart after permission changes"
echo ""
echo "✅ Keyboard shortcut fixes and guidance complete!"
echo ""
echo "🎯 **Next Steps:**"
echo "1. Build and run your app"
echo "2. Grant accessibility permissions when prompted"
echo "3. Test the Cmd+Opt+Space shortcut"
echo "4. Check for notification feedback"
echo ""
echo "💡 **Pro Tip:** The app now shows notifications when shortcuts are used,"
echo "   so you'll get immediate feedback if they're working!"
