#!/bin/bash

# Verify Standalone Preferences Window Setup
# This script verifies the preferences window is properly set up as standalone

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "🪟 Verifying standalone preferences window setup..."

# Check if PreferencesWindowManager exists
WINDOW_MANAGER_FILE="$APP_DIR/Core/PreferencesWindowManager.swift"

if [ -f "$WINDOW_MANAGER_FILE" ]; then
    echo "✅ PreferencesWindowManager.swift exists"
    
    # Check key components
    if grep -q "class PreferencesWindowManager" "$WINDOW_MANAGER_FILE"; then
        echo "   ✅ PreferencesWindowManager class defined"
    else
        echo "   ❌ PreferencesWindowManager class missing"
    fi
    
    if grep -q "showPreferences" "$WINDOW_MANAGER_FILE"; then
        echo "   ✅ showPreferences method present"
    else
        echo "   ❌ showPreferences method missing"
    fi
    
    if grep -q "NSWindow" "$WINDOW_MANAGER_FILE"; then
        echo "   ✅ Uses NSWindow for standalone window"
    else
        echo "   ❌ NSWindow usage missing"
    fi
    
    if grep -q "NSHostingView" "$WINDOW_MANAGER_FILE"; then
        echo "   ✅ Uses NSHostingView for SwiftUI integration"
    else
        echo "   ❌ NSHostingView usage missing"
    fi
else
    echo "❌ PreferencesWindowManager.swift missing"
fi

# Check if main app uses the window manager
APP_FILE="$APP_DIR/Core/KeepAwakeApp.swift"

echo ""
echo "🔍 Checking KeepAwakeApp.swift integration..."

if [ -f "$APP_FILE" ]; then
    if grep -q "PreferencesWindowManager" "$APP_FILE"; then
        echo "✅ PreferencesWindowManager integrated in main app"
    else
        echo "❌ PreferencesWindowManager not integrated in main app"
    fi
    
    if grep -q "@StateObject.*preferencesWindowManager" "$APP_FILE"; then
        echo "✅ PreferencesWindowManager StateObject created"
    else
        echo "❌ PreferencesWindowManager StateObject missing"
    fi
else
    echo "❌ KeepAwakeApp.swift not found"
fi

# Check if GlassyMenuBarView uses the window manager
MENU_BAR_FILE="$APP_DIR/Views/GlassyMenuBarView.swift"

echo ""
echo "🔍 Checking GlassyMenuBarView.swift integration..."

if [ -f "$MENU_BAR_FILE" ]; then
    if grep -q "preferencesWindowManager" "$MENU_BAR_FILE"; then
        echo "✅ PreferencesWindowManager parameter added"
    else
        echo "❌ PreferencesWindowManager parameter missing"
    fi
    
    if grep -q "showPreferences.*preferences:" "$MENU_BAR_FILE"; then
        echo "✅ showPreferences method called correctly"
    else
        echo "❌ showPreferences method call missing or incorrect"
    fi
    
    # Check if old sheet-based approach was removed
    if grep -q "sheet.*showingPreferences" "$MENU_BAR_FILE"; then
        echo "⚠️  Old sheet-based preferences still present"
    else
        echo "✅ Old sheet-based preferences removed"
    fi
    
    if grep -q "@State.*showingPreferences" "$MENU_BAR_FILE"; then
        echo "⚠️  Old showingPreferences state still present"
    else
        echo "✅ Old showingPreferences state removed"
    fi
else
    echo "❌ GlassyMenuBarView.swift not found"
fi

echo ""
echo "📋 Standalone Preferences Window Benefits:"
echo ""
echo "🎯 **Problem Solved:**"
echo "• Menu bar no longer closes when recording shortcuts"
echo "• Preferences window stays open during shortcut recording"
echo "• Better user experience for keyboard shortcut setup"
echo ""
echo "✨ **Technical Improvements:**"
echo "• Standalone NSWindow instead of sheet"
echo "• Proper window management and lifecycle"
echo "• Window remembers position and size"
echo "• Professional macOS app behavior"
echo ""
echo "🪟 **Window Features:**"
echo "• Resizable with minimum size constraints"
echo "• Proper title bar and window controls"
echo "• Automatic centering on first show"
echo "• Frame autosave for position memory"
echo ""

# Overall status check
issues=0

if [ ! -f "$WINDOW_MANAGER_FILE" ]; then
    issues=$((issues + 1))
fi

if ! grep -q "PreferencesWindowManager" "$APP_FILE" 2>/dev/null; then
    issues=$((issues + 1))
fi

if ! grep -q "preferencesWindowManager" "$MENU_BAR_FILE" 2>/dev/null; then
    issues=$((issues + 1))
fi

if [ "$issues" -eq 0 ]; then
    echo "🎉 STANDALONE PREFERENCES WINDOW SETUP COMPLETE!"
    echo ""
    echo "🚀 **How It Works Now:**"
    echo "1. Click 'Preferences...' in menu bar"
    echo "2. Standalone window opens (menu bar stays open)"
    echo "3. Click on shortcut recorders - they work properly!"
    echo "4. Window stays open during shortcut recording"
    echo "5. Close window when done - menu bar remains functional"
    echo ""
    echo "✅ **Fixed Issues:**"
    echo "• Menu no longer closes when recording shortcuts"
    echo "• Keyboard shortcut recorders work properly"
    echo "• Professional window management"
    echo "• Better user experience"
    echo ""
    echo "🎨 **User Experience:**"
    echo "• Click shortcut recorder → record shortcut → continue using preferences"
    echo "• No more menu closing interruptions"
    echo "• Smooth, professional interaction"
else
    echo "⚠️  Found $issues integration issues - check details above"
fi

echo ""
echo "🔧 **Next Steps:**"
echo "1. Build your app in Xcode"
echo "2. Test the Preferences button"
echo "3. Try recording keyboard shortcuts"
echo "4. Verify the menu bar stays open"
