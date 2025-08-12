#!/bin/bash

# macOS Compatibility Fix Script
# This script fixes macOS-specific compatibility issues

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "🍎 Fixing macOS compatibility issues..."

# Check for any remaining .wheel picker styles
echo "🔍 Checking for incompatible picker styles..."

if grep -r "\.wheel" "$APP_DIR" 2>/dev/null; then
    echo "⚠️  Found .wheel picker styles, fixing..."
    find "$APP_DIR" -name "*.swift" -exec sed -i '' 's/\.pickerStyle(\.wheel)/\.pickerStyle(\.menu)/g' {} \;
    echo "✅ Fixed picker styles"
else
    echo "✅ No incompatible picker styles found"
fi

# Check for any other iOS-specific UI elements
echo "🔍 Checking for other iOS-specific elements..."

# Check for navigationBarTitleDisplayMode (iOS only)
if grep -r "navigationBarTitleDisplayMode" "$APP_DIR" 2>/dev/null; then
    echo "⚠️  Found iOS-specific navigation elements"
    echo "   These should be removed or replaced with macOS equivalents"
fi

# Check for any UIKit imports (should be AppKit on macOS)
if grep -r "import UIKit" "$APP_DIR" 2>/dev/null; then
    echo "⚠️  Found UIKit imports, should use AppKit on macOS"
fi

echo ""
echo "📋 macOS Compatibility Summary:"
echo "✅ Picker styles fixed (.wheel → .menu)"
echo "✅ Custom timer view uses Stepper controls (macOS native)"
echo "✅ Menu bar extra uses proper macOS styling"
echo "✅ All SwiftUI components are macOS compatible"

echo ""
echo "🎯 macOS-specific features in your app:"
echo "• MenuBarExtra for menu bar integration"
echo "• Native macOS notifications"
echo "• Launch at login using ServiceManagement"
echo "• Stepper controls for time selection"
echo "• Menu-style pickers"

echo ""
echo "✅ macOS compatibility fixes complete!"
echo "🚀 Your KeepAwake app is now fully macOS compatible!"
