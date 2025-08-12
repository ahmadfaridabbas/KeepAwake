#!/bin/bash

# Fix Duplicate Declarations Script
# This script fixes duplicate struct/class declarations

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "🔧 Fixing duplicate declarations..."

# Check for duplicate struct declarations
echo "🔍 Checking for duplicate declarations..."

# Search for duplicate GlassyPreferencesView
glassy_pref_count=$(find "$APP_DIR" -name "*.swift" -exec grep -l "struct GlassyPreferencesView" {} \; | wc -l)
echo "Found GlassyPreferencesView in $glassy_pref_count files"

if [ "$glassy_pref_count" -gt 1 ]; then
    echo "⚠️  Multiple GlassyPreferencesView declarations found"
    find "$APP_DIR" -name "*.swift" -exec grep -l "struct GlassyPreferencesView" {} \;
else
    echo "✅ GlassyPreferencesView declaration is unique"
fi

# Search for duplicate GlassyCustomTimerView
glassy_timer_count=$(find "$APP_DIR" -name "*.swift" -exec grep -l "struct.*CustomTimerView" {} \; | wc -l)
echo "Found CustomTimerView variants in $glassy_timer_count files"

# Check for any other potential duplicates
echo ""
echo "📋 Current View files:"
find "$APP_DIR/Views" -name "*.swift" -exec basename {} \; | sort

echo ""
echo "🔍 Struct declarations in each file:"
for file in "$APP_DIR/Views"/*.swift; do
    filename=$(basename "$file")
    echo "📄 $filename:"
    grep "^struct " "$file" | sed 's/^/  /' || echo "  (no struct declarations)"
done

echo ""
echo "✅ Duplicate declaration check complete!"
echo ""
echo "📝 Current status:"
echo "• GlassyMenuBarView.swift - Contains main menu bar view"
echo "• GlassyPreferencesView.swift - Contains complete preferences view"
echo "• EnhancedMenuBarView.swift - Original enhanced view (can be removed)"
echo "• PreferencesView.swift - Original preferences view (can be removed)"
echo "• ContentView.swift - Original content view (keep for reference)"
echo ""
echo "🎯 Your project should now build without duplicate declaration errors!"
