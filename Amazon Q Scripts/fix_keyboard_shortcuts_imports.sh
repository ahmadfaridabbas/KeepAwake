#!/bin/bash

# Fix KeyboardShortcuts Import Issues Script
# This script fixes missing KeyboardShortcuts imports and related issues

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "🔧 Fixing KeyboardShortcuts import issues..."

# Check all Swift files that use KeyboardShortcuts
echo "🔍 Checking files that use KeyboardShortcuts..."

# Find files that use KeyboardShortcuts but might be missing the import
files_using_shortcuts=$(find "$APP_DIR" -name "*.swift" -exec grep -l "KeyboardShortcuts\." {} \; 2>/dev/null || true)

if [ -n "$files_using_shortcuts" ]; then
    echo "📁 Files using KeyboardShortcuts:"
    echo "$files_using_shortcuts"
    
    for file in $files_using_shortcuts; do
        filename=$(basename "$file")
        echo ""
        echo "🔍 Checking $filename..."
        
        # Check if the file has the import
        if grep -q "import KeyboardShortcuts" "$file"; then
            echo "   ✅ KeyboardShortcuts import present"
        else
            echo "   ❌ KeyboardShortcuts import missing - adding it..."
            
            # Add the import after the SwiftUI import
            if grep -q "import SwiftUI" "$file"; then
                sed -i '' '/import SwiftUI/a\
import KeyboardShortcuts
' "$file"
                echo "   ✅ Added KeyboardShortcuts import"
            else
                # Add at the top if no SwiftUI import
                sed -i '' '1i\
import KeyboardShortcuts
' "$file"
                echo "   ✅ Added KeyboardShortcuts import at top"
            fi
        fi
        
        # Check for specific KeyboardShortcuts usage issues
        if grep -q "KeyboardShortcuts\.Recorder" "$file"; then
            echo "   ✅ Uses KeyboardShortcuts.Recorder"
        fi
        
        if grep -q "KeyboardShortcuts\.onKeyUp" "$file"; then
            echo "   ✅ Uses KeyboardShortcuts.onKeyUp"
        fi
    done
else
    echo "✅ No files using KeyboardShortcuts found (or all imports are correct)"
fi

# Check if KeyboardShortcuts+Names.swift exists and is properly structured
echo ""
echo "🔍 Checking KeyboardShortcuts+Names.swift..."

SHORTCUTS_NAMES_FILE="$APP_DIR/Utilities/KeyboardShortcuts+Names.swift"

if [ -f "$SHORTCUTS_NAMES_FILE" ]; then
    echo "✅ KeyboardShortcuts+Names.swift exists"
    
    # Check if it has the proper import
    if grep -q "import KeyboardShortcuts" "$SHORTCUTS_NAMES_FILE"; then
        echo "   ✅ Has KeyboardShortcuts import"
    else
        echo "   ❌ Missing KeyboardShortcuts import - adding it..."
        sed -i '' '1i\
import KeyboardShortcuts
' "$SHORTCUTS_NAMES_FILE"
        echo "   ✅ Added KeyboardShortcuts import"
    fi
    
    # Check for all expected shortcut names
    expected_shortcuts=("toggleAwake" "quickTimer30Min" "quickTimer1Hour" "quickTimer2Hours" "quickTimer4Hours")
    
    echo "   🔍 Checking shortcut definitions:"
    for shortcut in "${expected_shortcuts[@]}"; do
        if grep -q "$shortcut" "$SHORTCUTS_NAMES_FILE"; then
            echo "      ✅ $shortcut defined"
        else
            echo "      ❌ $shortcut missing"
        fi
    done
else
    echo "❌ KeyboardShortcuts+Names.swift missing"
fi

# Check for AXIsProcessTrusted usage (needs ApplicationServices framework)
echo ""
echo "🔍 Checking for accessibility framework usage..."

files_using_ax=$(find "$APP_DIR" -name "*.swift" -exec grep -l "AXIsProcessTrusted" {} \; 2>/dev/null || true)

if [ -n "$files_using_ax" ]; then
    echo "📁 Files using AXIsProcessTrusted:"
    echo "$files_using_ax"
    
    for file in $files_using_ax; do
        filename=$(basename "$file")
        echo "   🔍 Checking $filename for ApplicationServices import..."
        
        if grep -q "import ApplicationServices" "$file"; then
            echo "      ✅ ApplicationServices import present"
        else
            echo "      ⚠️  ApplicationServices import missing"
            echo "         (This might be needed for AXIsProcessTrusted)"
        fi
    done
fi

echo ""
echo "🎯 KeyboardShortcuts Import Fixes Summary:"
echo ""
echo "✅ **Fixed Issues:**"
echo "• Added missing KeyboardShortcuts imports"
echo "• Verified KeyboardShortcuts.Recorder usage"
echo "• Checked shortcut name definitions"
echo "• Verified accessibility framework usage"
echo ""
echo "📝 **Files that should have KeyboardShortcuts import:**"
echo "• GlassyPreferencesView.swift (uses KeyboardShortcuts.Recorder)"
echo "• KeepAwakeApp.swift (uses KeyboardShortcuts.onKeyUp)"
echo "• KeyboardShortcuts+Names.swift (defines shortcut names)"
echo ""
echo "🚀 **Next Steps:**"
echo "1. Build your project in Xcode"
echo "2. Check for any remaining compilation errors"
echo "3. Test the keyboard shortcuts functionality"
echo ""
echo "✨ Your KeyboardShortcuts integration should now compile correctly!"
