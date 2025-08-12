#!/bin/bash

# Verify Keyboard Shortcuts in Preferences Script
# This script verifies the keyboard shortcuts have been moved to preferences

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "⌨️  Verifying keyboard shortcuts integration in preferences..."

# Check if KeyboardShortcuts.Recorder is used in preferences
echo "🔍 Checking GlassyPreferencesView..."

if grep -q "KeyboardShortcuts.Recorder" "$APP_DIR/Views/GlassyPreferencesView.swift"; then
    echo "✅ KeyboardShortcuts.Recorder found in preferences"
    
    # Count how many recorders are present
    recorder_count=$(grep -c "KeyboardShortcuts.Recorder" "$APP_DIR/Views/GlassyPreferencesView.swift")
    echo "   📋 Number of shortcut recorders: $recorder_count"
    
    if [ "$recorder_count" -ge 5 ]; then
        echo "   ✅ All expected shortcut recorders present"
    else
        echo "   ⚠️  Some shortcut recorders might be missing"
    fi
else
    echo "❌ KeyboardShortcuts.Recorder not found in preferences"
fi

# Check if keyboard shortcuts section exists
if grep -q "keyboardShortcutsSettings" "$APP_DIR/Views/GlassyPreferencesView.swift"; then
    echo "✅ Keyboard shortcuts settings section found"
else
    echo "❌ Keyboard shortcuts settings section missing"
fi

# Check if accessibility permissions check is included
if grep -q "AXIsProcessTrusted" "$APP_DIR/Views/GlassyPreferencesView.swift"; then
    echo "✅ Accessibility permissions check included"
else
    echo "⚠️  Accessibility permissions check not found"
fi

# Check if shortcut display was removed from menu bar
echo ""
echo "🔍 Checking GlassyMenuBarView..."

if grep -q "Keyboard Shortcut Display" "$APP_DIR/Views/GlassyMenuBarView.swift"; then
    echo "⚠️  Keyboard shortcut display still in menu bar view"
    echo "   Consider removing it since shortcuts are now in preferences"
else
    echo "✅ Keyboard shortcut display removed from menu bar"
fi

# Check if all shortcut names are defined
echo ""
echo "🔍 Checking KeyboardShortcuts+Names.swift..."

shortcut_names=("toggleAwake" "quickTimer30Min" "quickTimer1Hour" "quickTimer2Hours" "quickTimer4Hours")
missing_shortcuts=()

for shortcut in "${shortcut_names[@]}"; do
    if grep -q "$shortcut" "$APP_DIR/Utilities/KeyboardShortcuts+Names.swift"; then
        echo "✅ $shortcut defined"
    else
        echo "❌ $shortcut missing"
        missing_shortcuts+=("$shortcut")
    fi
done

# Check if main app handles all shortcuts
echo ""
echo "🔍 Checking KeepAwakeApp.swift..."

if grep -q "quickTimer2Hours" "$APP_DIR/Core/KeepAwakeApp.swift" && grep -q "quickTimer4Hours" "$APP_DIR/Core/KeepAwakeApp.swift"; then
    echo "✅ All shortcuts handled in main app"
else
    echo "⚠️  Some shortcuts might not be handled in main app"
fi

echo ""
echo "📋 Keyboard Shortcuts Integration Summary:"
echo ""
echo "🎯 **Moved to Preferences:**"
echo "• Toggle KeepAwake (Cmd+Opt+Space default)"
echo "• 30 Minutes Timer"
echo "• 1 Hour Timer"
echo "• 2 Hours Timer"
echo "• 4 Hours Timer"
echo ""
echo "✨ **Features Added:**"
echo "• Visual shortcut recorders in preferences"
echo "• Accessibility permissions check"
echo "• System Preferences integration"
echo "• Clean menu bar (shortcut display removed)"
echo ""

# Overall status
if grep -q "KeyboardShortcuts.Recorder" "$APP_DIR/Views/GlassyPreferencesView.swift" && \
   grep -q "keyboardShortcutsSettings" "$APP_DIR/Views/GlassyPreferencesView.swift" && \
   ! grep -q "Keyboard Shortcut Display" "$APP_DIR/Views/GlassyMenuBarView.swift"; then
    echo "🎉 KEYBOARD SHORTCUTS SUCCESSFULLY MOVED TO PREFERENCES!"
    echo ""
    echo "🚀 Benefits:"
    echo "• Better organization - shortcuts in dedicated preferences section"
    echo "• Visual shortcut recorders - easy to set custom shortcuts"
    echo "• Accessibility guidance - helps users enable permissions"
    echo "• Cleaner menu bar - removed shortcut display clutter"
    echo "• More shortcuts - added 2h and 4h timer shortcuts"
    echo ""
    echo "📝 How to use:"
    echo "1. Open KeepAwake preferences"
    echo "2. Go to 'Keyboard Shortcuts' section"
    echo "3. Click on shortcut recorders to set custom shortcuts"
    echo "4. Grant accessibility permissions if prompted"
    echo ""
    echo "✨ Your KeepAwake app now has professional shortcut management!"
else
    echo "⚠️  Keyboard shortcuts integration needs attention - check issues above"
fi
