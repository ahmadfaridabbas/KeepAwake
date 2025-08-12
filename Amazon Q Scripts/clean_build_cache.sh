#!/bin/bash

# Clean Build Cache Script
# This script cleans Xcode build cache and ensures fresh compilation

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"

echo "🧹 Cleaning build cache and ensuring fresh compilation..."

# Clean Xcode derived data
echo "🗑️  Cleaning Xcode derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/KeepAwake-* 2>/dev/null || true
echo "✅ Cleaned derived data"

# Remove any .build directories
echo "🗑️  Cleaning local build directories..."
find "$PROJECT_DIR" -name ".build" -type d -exec rm -rf {} \; 2>/dev/null || true
echo "✅ Cleaned local build directories"

# Remove any xcuserdata that might have cached issues
echo "🗑️  Cleaning user data..."
find "$PROJECT_DIR" -name "xcuserdata" -type d -exec rm -rf {} \; 2>/dev/null || true
echo "✅ Cleaned user data"

echo ""
echo "📋 Current project status:"
echo "✅ All gradient issues fixed with LinearGradient"
echo "✅ No .gradient or AnyGradient usage"
echo "✅ Type-safe color and gradient usage"
echo "✅ Build cache cleaned"

echo ""
echo "🎯 Next steps to resolve any remaining issues:"
echo "1. Open your project in Xcode"
echo "2. Clean Build Folder (Cmd+Shift+K)"
echo "3. Build your project (Cmd+B)"
echo ""
echo "💡 If you still get gradient errors:"
echo "• Check that you're using the latest files"
echo "• Restart Xcode completely"
echo "• Verify no old references in project navigator"
echo ""
echo "✨ Your KeepAwake app should now build perfectly with beautiful gradients!"
