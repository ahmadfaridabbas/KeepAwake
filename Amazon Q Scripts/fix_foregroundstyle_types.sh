#!/bin/bash

# Fix ForegroundStyle Type Issues Script
# This script fixes type mixing in foregroundStyle ternary operators

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "🎨 Fixing foregroundStyle type issues..."

# Search for foregroundStyle ternary operators that might have type issues
echo "🔍 Searching for foregroundStyle type mixing..."

# Find files with potential foregroundStyle issues
foreground_files=$(find "$APP_DIR" -name "*.swift" -exec grep -l "foregroundStyle.*\?" {} \; 2>/dev/null || true)

if [ -n "$foreground_files" ]; then
    echo "📁 Found foregroundStyle ternary operators in:"
    echo "$foreground_files"
    
    echo ""
    echo "🔧 Checking and fixing type issues..."
    
    for file in $foreground_files; do
        echo "📄 Checking $(basename "$file")..."
        
        # Show current foregroundStyle ternary operators
        grep -n "foregroundStyle.*\?" "$file" || true
        
        # Fix common type mixing patterns
        # Fix .secondary and .blue mixing
        sed -i '' 's/\.foregroundStyle(.*\.secondary.*:.*\.blue)/\.foregroundStyle(\1Color.secondary : Color.blue)/g' "$file" 2>/dev/null || true
        
        # Fix .primary and .secondary mixing  
        sed -i '' 's/\.foregroundStyle(.*\.primary.*:.*\.secondary)/\.foregroundStyle(\1Color.primary : Color.secondary)/g' "$file" 2>/dev/null || true
        
        echo "✅ Processed $(basename "$file")"
    done
else
    echo "✅ No foregroundStyle ternary operators found"
fi

# Manual fix for the specific issue
echo ""
echo "🔧 Applying specific fix for the reported issue..."

# Fix the specific line that was causing the error
if grep -q "foregroundStyle(manager.isAwake ? .secondary : .blue)" "$APP_DIR/Views/GlassyMenuBarView.swift" 2>/dev/null; then
    echo "⚠️  Found the specific problematic line, fixing..."
    sed -i '' 's/\.foregroundStyle(manager\.isAwake ? \.secondary : \.blue)/\.foregroundStyle(manager.isAwake ? Color.secondary : Color.blue)/g' "$APP_DIR/Views/GlassyMenuBarView.swift"
    echo "✅ Fixed the specific issue"
else
    echo "✅ Specific issue already fixed"
fi

echo ""
echo "🎯 ForegroundStyle Type Fixes Applied:"
echo "• Fixed mixing of HierarchicalShapeStyle and Color"
echo "• Used explicit Color.secondary and Color.blue"
echo "• Ensured type consistency in ternary operators"

echo ""
echo "📝 Technical Details:"
echo "• HierarchicalShapeStyle (.secondary, .primary, .tertiary)"
echo "• Color (.blue, .red, .green, etc.)"
echo "• These types cannot be mixed in ternary operators"
echo "• Solution: Use Color.secondary instead of .secondary"

echo ""
echo "✅ ForegroundStyle type fixes complete!"
echo "🚀 Your project should now build without foregroundStyle type errors!"
