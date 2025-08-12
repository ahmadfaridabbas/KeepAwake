#!/bin/bash

# Final Build Issues Fix Script
# This script fixes all remaining keyboard shortcut and build issues

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "🔧 Fixing final build issues..."

# Fix 1: Create a working KeyboardShortcuts+Names.swift
echo "⌨️  Fixing keyboard shortcuts..."

cat > "$APP_DIR/Utilities/KeyboardShortcuts+Names.swift" << 'EOF'
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleAwake = Self("toggleAwake", default: .init(.space, modifiers: [.command, .option]))
    // Additional shortcuts without default bindings (users can set them in preferences)
    static let quickTimer30Min = Self("quickTimer30Min")
    static let quickTimer1Hour = Self("quickTimer1Hour")
}
EOF

echo "✅ Fixed KeyboardShortcuts+Names.swift"

# Fix 2: Update KeepAwakeApp.swift to handle the keyboard shortcuts properly
echo "📱 Updating main app file..."

cat > "$APP_DIR/Core/KeepAwakeApp.swift" << 'EOF'
import SwiftUI
import KeyboardShortcuts
import UserNotifications

@main
struct KeepAwakeApp: App {
    @StateObject private var manager = KeepAwakeManager()
    @StateObject private var preferences = PreferencesManager()
    
    var body: some Scene {
        MenuBarExtra {
            EnhancedMenuBarView(manager: manager, preferences: preferences)
                .onAppear {
                    setupKeyboardShortcuts()
                }
        } label: {
            Image(systemName: menuBarIcon)
                .foregroundColor(menuBarIconColor)
        }
        .menuBarExtraStyle(.window)
    }
    
    // MARK: - Menu Bar Icon
    
    private var menuBarIcon: String {
        if manager.isAwake {
            if manager.isTimerMode {
                return "timer"
            } else {
                return "sun.max.fill"
            }
        } else {
            return "moon.fill"
        }
    }
    
    private var menuBarIconColor: Color {
        if manager.isAwake {
            if manager.isTimerMode {
                return .green
            } else {
                return .orange
            }
        } else {
            return .primary
        }
    }
    
    // MARK: - Keyboard Shortcuts
    
    private func setupKeyboardShortcuts() {
        KeyboardShortcuts.onKeyUp(for: .toggleAwake) {
            manager.toggleAwake()
        }
        
        KeyboardShortcuts.onKeyUp(for: .quickTimer30Min) {
            if !manager.isAwake {
                manager.startAwake(duration: 30 * 60) // 30 minutes
            }
        }
        
        KeyboardShortcuts.onKeyUp(for: .quickTimer1Hour) {
            if !manager.isAwake {
                manager.startAwake(duration: 60 * 60) // 1 hour
            }
        }
    }
}
EOF

echo "✅ Updated KeepAwakeApp.swift"

# Fix 3: Ensure all manager references are consistent
echo "🔄 Checking manager references..."

# Check if there are any remaining EnhancedKeepAwakeManager references
if grep -r "EnhancedKeepAwakeManager" "$APP_DIR" 2>/dev/null; then
    echo "⚠️  Found remaining EnhancedKeepAwakeManager references, fixing..."
    find "$APP_DIR" -name "*.swift" -exec sed -i '' 's/EnhancedKeepAwakeManager/KeepAwakeManager/g' {} \;
    echo "✅ Fixed manager references"
else
    echo "✅ All manager references are correct"
fi

# Fix 4: Verify all files exist and are properly named
echo "📁 Verifying file structure..."

required_files=(
    "Core/KeepAwakeApp.swift"
    "Managers/KeepAwakeManager.swift"
    "Managers/PreferencesManager.swift"
    "Managers/LaunchAgentManager.swift"
    "Views/EnhancedMenuBarView.swift"
    "Views/PreferencesView.swift"
    "Views/ContentView.swift"
    "Utilities/KeyboardShortcuts+Names.swift"
    "KeepAwake.entitlements"
)

all_files_exist=true
for file in "${required_files[@]}"; do
    if [ ! -f "$APP_DIR/$file" ]; then
        echo "❌ Missing: $file"
        all_files_exist=false
    else
        echo "✅ Found: $file"
    fi
done

if [ "$all_files_exist" = true ]; then
    echo "✅ All required files are present"
else
    echo "⚠️  Some files are missing. You may need to re-run the integration script."
fi

echo ""
echo "🎯 Build fixes complete!"
echo ""
echo "📝 What was fixed:"
echo "• Keyboard shortcut key codes (removed problematic digit3/digit1)"
echo "• Simplified keyboard shortcut definitions"
echo "• Ensured consistent manager class names"
echo "• Verified all required files exist"
echo ""
echo "⌨️  Keyboard shortcuts:"
echo "• Cmd+Opt+Space: Toggle Keep Awake (default binding)"
echo "• Quick timer shortcuts: Can be set by users in preferences"
echo ""
echo "🚀 Your project should now build successfully!"
EOF
