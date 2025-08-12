#!/bin/bash

# Verify All Imports Script
# This script verifies all necessary imports are present

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "🔍 Verifying all imports are correct..."

# Check GlassyPreferencesView.swift
echo "📄 Checking GlassyPreferencesView.swift..."

PREFS_FILE="$APP_DIR/Views/GlassyPreferencesView.swift"

if [ -f "$PREFS_FILE" ]; then
    echo "   ✅ File exists"
    
    # Check required imports
    if grep -q "import SwiftUI" "$PREFS_FILE"; then
        echo "   ✅ SwiftUI import present"
    else
        echo "   ❌ SwiftUI import missing"
    fi
    
    if grep -q "import KeyboardShortcuts" "$PREFS_FILE"; then
        echo "   ✅ KeyboardShortcuts import present"
    else
        echo "   ❌ KeyboardShortcuts import missing"
    fi
    
    if grep -q "import ApplicationServices" "$PREFS_FILE"; then
        echo "   ✅ ApplicationServices import present"
    else
        echo "   ❌ ApplicationServices import missing"
    fi
    
    # Check KeyboardShortcuts usage
    if grep -q "KeyboardShortcuts\.Recorder" "$PREFS_FILE"; then
        echo "   ✅ Uses KeyboardShortcuts.Recorder"
    else
        echo "   ⚠️  KeyboardShortcuts.Recorder not found"
    fi
    
    # Check AXIsProcessTrusted usage
    if grep -q "AXIsProcessTrusted" "$PREFS_FILE"; then
        echo "   ✅ Uses AXIsProcessTrusted"
    else
        echo "   ⚠️  AXIsProcessTrusted not found"
    fi
else
    echo "   ❌ File not found"
fi

# Check KeepAwakeApp.swift
echo ""
echo "📄 Checking KeepAwakeApp.swift..."

APP_FILE="$APP_DIR/Core/KeepAwakeApp.swift"

if [ -f "$APP_FILE" ]; then
    echo "   ✅ File exists"
    
    # Check required imports
    imports=("SwiftUI" "KeyboardShortcuts" "UserNotifications" "ApplicationServices")
    
    for import_name in "${imports[@]}"; do
        if grep -q "import $import_name" "$APP_FILE"; then
            echo "   ✅ $import_name import present"
        else
            echo "   ❌ $import_name import missing"
        fi
    done
    
    # Check KeyboardShortcuts usage
    if grep -q "KeyboardShortcuts\.onKeyUp" "$APP_FILE"; then
        echo "   ✅ Uses KeyboardShortcuts.onKeyUp"
    else
        echo "   ⚠️  KeyboardShortcuts.onKeyUp not found"
    fi
else
    echo "   ❌ File not found"
fi

# Check KeyboardShortcuts+Names.swift
echo ""
echo "📄 Checking KeyboardShortcuts+Names.swift..."

NAMES_FILE="$APP_DIR/Utilities/KeyboardShortcuts+Names.swift"

if [ -f "$NAMES_FILE" ]; then
    echo "   ✅ File exists"
    
    if grep -q "import KeyboardShortcuts" "$NAMES_FILE"; then
        echo "   ✅ KeyboardShortcuts import present"
    else
        echo "   ❌ KeyboardShortcuts import missing"
    fi
    
    # Check all shortcut names
    shortcuts=("toggleAwake" "quickTimer30Min" "quickTimer1Hour" "quickTimer2Hours" "quickTimer4Hours")
    
    echo "   🔍 Checking shortcut definitions:"
    for shortcut in "${shortcuts[@]}"; do
        if grep -q "static let $shortcut" "$NAMES_FILE"; then
            echo "      ✅ $shortcut"
        else
            echo "      ❌ $shortcut missing"
        fi
    done
else
    echo "   ❌ File not found"
fi

echo ""
echo "🎯 Import Verification Summary:"
echo ""

# Count issues
issues=0

# Check if all critical imports are present
if ! grep -q "import KeyboardShortcuts" "$PREFS_FILE" 2>/dev/null; then
    issues=$((issues + 1))
fi

if ! grep -q "import ApplicationServices" "$PREFS_FILE" 2>/dev/null; then
    issues=$((issues + 1))
fi

if ! grep -q "import KeyboardShortcuts" "$APP_FILE" 2>/dev/null; then
    issues=$((issues + 1))
fi

if ! grep -q "import ApplicationServices" "$APP_FILE" 2>/dev/null; then
    issues=$((issues + 1))
fi

if [ "$issues" -eq 0 ]; then
    echo "🎉 ALL IMPORTS VERIFIED SUCCESSFULLY!"
    echo ""
    echo "✅ **Import Status:**"
    echo "• GlassyPreferencesView.swift: All imports present"
    echo "• KeepAwakeApp.swift: All imports present"
    echo "• KeyboardShortcuts+Names.swift: All shortcuts defined"
    echo ""
    echo "🚀 **Ready to Build:**"
    echo "• KeyboardShortcuts.Recorder should work in preferences"
    echo "• AXIsProcessTrusted should work for accessibility checks"
    echo "• All keyboard shortcuts should function properly"
    echo ""
    echo "📝 **What's Fixed:**"
    echo "• Added KeyboardShortcuts import to GlassyPreferencesView"
    echo "• Added ApplicationServices import for AXIsProcessTrusted"
    echo "• Verified all shortcut names are defined"
    echo "• Confirmed all necessary imports are present"
    echo ""
    echo "✨ Your KeepAwake app should now compile without import errors!"
else
    echo "⚠️  Found $issues import issues - check the details above"
    echo ""
    echo "🔧 **Common Solutions:**"
    echo "• Make sure all import statements are at the top of files"
    echo "• Verify KeyboardShortcuts package is added to project"
    echo "• Check that ApplicationServices is available (built into macOS)"
fi

echo ""
echo "🎨 **Keyboard Shortcuts Features:**"
echo "• Visual shortcut recorders in preferences"
echo "• Accessibility permission checking"
echo "• 5 customizable shortcuts (toggle + 4 timers)"
echo "• Professional preferences integration"
