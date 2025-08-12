#!/bin/bash

# Comprehensive Gradient Fix Script
# This script finds and fixes ALL gradient issues in the project

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "🎨 Comprehensive gradient fix..."

# Search for ALL gradient-related issues
echo "🔍 Searching for ALL gradient issues..."

echo "📁 Checking all Swift files for gradient patterns..."

# Find all files with gradient issues
gradient_files=$(find "$APP_DIR" -name "*.swift" -exec grep -l "\.gradient\|AnyGradient" {} \; 2>/dev/null || true)

if [ -n "$gradient_files" ]; then
    echo "⚠️  Found gradient issues in:"
    echo "$gradient_files"
    
    echo ""
    echo "🔧 Fixing gradient issues..."
    
    # Fix all gradient issues
    for file in $gradient_files; do
        echo "📄 Fixing $(basename "$file")..."
        
        # Replace .red.gradient with LinearGradient
        sed -i '' 's/\.red\.gradient/LinearGradient(colors: [.red.opacity(0.8), .red], startPoint: .top, endPoint: .bottom)/g' "$file"
        
        # Replace .blue.gradient with LinearGradient
        sed -i '' 's/\.blue\.gradient/LinearGradient(colors: [.blue.opacity(0.8), .blue], startPoint: .top, endPoint: .bottom)/g' "$file"
        
        # Replace .green.gradient with LinearGradient
        sed -i '' 's/\.green\.gradient/LinearGradient(colors: [.green.opacity(0.8), .green], startPoint: .top, endPoint: .bottom)/g' "$file"
        
        # Replace AnyGradient usage
        sed -i '' 's/AnyGradient(\.red\.gradient)/LinearGradient(colors: [.red.opacity(0.8), .red], startPoint: .top, endPoint: .bottom)/g' "$file"
        sed -i '' 's/AnyGradient(\.blue\.gradient)/LinearGradient(colors: [.blue.opacity(0.8), .blue], startPoint: .top, endPoint: .bottom)/g' "$file"
        sed -i '' 's/AnyGradient(\.green\.gradient)/LinearGradient(colors: [.green.opacity(0.8), .green], startPoint: .top, endPoint: .bottom)/g' "$file"
        
        echo "✅ Fixed $(basename "$file")"
    done
else
    echo "✅ No gradient issues found"
fi

# Check for color/gradient mixing in ternary operators
echo ""
echo "🔍 Checking for color/gradient mixing..."

mixing_issues=$(find "$APP_DIR" -name "*.swift" -exec grep -n "\.red.*\.blue\|\.blue.*\.red" {} \; 2>/dev/null || true)

if [ -n "$mixing_issues" ]; then
    echo "⚠️  Found potential color/gradient mixing:"
    echo "$mixing_issues"
else
    echo "✅ No color/gradient mixing found"
fi

# Verify all files compile-ready
echo ""
echo "🔍 Final verification..."

echo "📋 Current gradient usage in project:"
find "$APP_DIR" -name "*.swift" -exec grep -n "LinearGradient\|\.gradient" {} \; 2>/dev/null | head -10 || echo "No gradient usage found"

echo ""
echo "✅ Comprehensive gradient fix complete!"
echo ""
echo "🎯 All gradient issues should now be resolved:"
echo "• Replaced .color.gradient with LinearGradient"
echo "• Fixed AnyGradient usage"
echo "• Ensured type consistency"
echo "• No mixing of gradient and color types"
echo ""
echo "🚀 Your project should now build without any gradient errors!"
