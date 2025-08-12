#!/bin/bash

# KeepAwake Build Issues Fix Script
# This script fixes common build issues

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "🔧 Fixing KeepAwake build issues..."

# Fix 1: Ensure entitlements file is in the correct location
echo "📋 Checking entitlements file location..."
if [ -f "$APP_DIR/Resources/KeepAwake.entitlements" ]; then
    echo "⚠️  Moving entitlements file to root directory..."
    mv "$APP_DIR/Resources/KeepAwake.entitlements" "$APP_DIR/"
    echo "✅ Entitlements file moved to correct location"
elif [ -f "$APP_DIR/KeepAwake.entitlements" ]; then
    echo "✅ Entitlements file is in correct location"
else
    echo "❌ Entitlements file not found! Creating new one..."
    cat > "$APP_DIR/KeepAwake.entitlements" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.app-sandbox</key>
    <true/>
    <key>com.apple.security.files.user-selected.read-only</key>
    <true/>
    <key>com.apple.security.network.client</key>
    <false/>
    <key>com.apple.security.network.server</key>
    <false/>
    <key>com.apple.security.automation.apple-events</key>
    <true/>
    <key>com.apple.security.temporary-exception.apple-events</key>
    <array>
        <string>com.apple.systemevents</string>
    </array>
</dict>
</plist>
EOF
    echo "✅ New entitlements file created"
fi

# Fix 2: Verify all required files exist
echo "📁 Verifying all required files exist..."

required_files=(
    "Core/KeepAwakeApp.swift"
    "Managers/KeepAwakeManager.swift"
    "Managers/PreferencesManager.swift"
    "Managers/LaunchAgentManager.swift"
    "Views/EnhancedMenuBarView.swift"
    "Views/PreferencesView.swift"
    "Utilities/KeyboardShortcuts+Names.swift"
    "KeepAwake.entitlements"
)

missing_files=()

for file in "${required_files[@]}"; do
    if [ ! -f "$APP_DIR/$file" ]; then
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -eq 0 ]; then
    echo "✅ All required files are present"
else
    echo "❌ Missing files:"
    for file in "${missing_files[@]}"; do
        echo "   - $file"
    done
    echo ""
    echo "💡 Run the integration script again to restore missing files:"
    echo "   ./integrate_improvements.sh"
fi

# Fix 3: Check for duplicate ContentView references
echo "🔍 Checking for potential duplicate files..."
if [ -f "$APP_DIR/ContentView.swift" ] && [ -f "$APP_DIR/Views/ContentView.swift" ]; then
    echo "⚠️  Found duplicate ContentView.swift files"
    echo "   Removing the one in root directory..."
    rm "$APP_DIR/ContentView.swift"
    echo "✅ Duplicate removed"
fi

# Fix 4: Verify project structure
echo "📊 Current project structure:"
echo "KeepAwake/"
echo "├── KeepAwake.entitlements"
find "$APP_DIR" -name "*.swift" -type f | sed 's|.*/KeepAwake/||' | sort | sed 's/^/├── /'

echo ""
echo "✅ Build issues check complete!"
echo ""
echo "📝 If you still have build issues:"
echo "1. Clean build folder in Xcode (Cmd+Shift+K)"
echo "2. Clean derived data (Xcode > Preferences > Locations > Derived Data > Delete)"
echo "3. Restart Xcode"
echo "4. Try building again"
echo ""
echo "🎯 Your KeepAwake project should now build successfully!"
