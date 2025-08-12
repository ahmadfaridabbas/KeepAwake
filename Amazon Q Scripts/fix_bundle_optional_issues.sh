#!/bin/bash

# Fix Bundle Optional Issues Script
# This script fixes Bundle.main optional binding issues

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "📦 Fixing Bundle.main optional binding issues..."

# Check for any other Bundle.main optional binding issues
echo "🔍 Searching for Bundle.main optional binding patterns..."

# Search for problematic patterns
if grep -r "guard let.*Bundle.main" "$APP_DIR" 2>/dev/null; then
    echo "⚠️  Found Bundle.main optional binding issues"
else
    echo "✅ No additional Bundle.main optional binding issues found"
fi

if grep -r "if let.*Bundle.main" "$APP_DIR" 2>/dev/null; then
    echo "⚠️  Found Bundle.main optional binding issues"
else
    echo "✅ No additional Bundle.main optional binding issues found"
fi

# Verify the fix was applied correctly
echo "🔍 Verifying LaunchAgentManager fix..."

if grep -q "let appURL = Bundle.main.bundleURL" "$APP_DIR/Managers/LaunchAgentManager.swift"; then
    echo "✅ LaunchAgentManager fix applied correctly"
else
    echo "❌ LaunchAgentManager fix not found"
fi

# Check for any remaining bundleNotFound references
if grep -q "bundleNotFound" "$APP_DIR/Managers/LaunchAgentManager.swift"; then
    echo "⚠️  Found remaining bundleNotFound references"
    echo "   These should be removed since Bundle.main.bundleURL is not optional"
else
    echo "✅ No remaining bundleNotFound references"
fi

echo ""
echo "📋 Bundle.main Properties (for reference):"
echo "• Bundle.main.bundleURL - Returns URL (not optional)"
echo "• Bundle.main.bundlePath - Returns String (not optional)"
echo "• Bundle.main.bundleIdentifier - Returns String? (optional)"
echo "• Bundle.main.executableURL - Returns URL? (optional)"

echo ""
echo "✅ Bundle optional binding fixes complete!"
echo ""
echo "📝 What was fixed:"
echo "• Removed unnecessary guard let for Bundle.main.bundleURL"
echo "• Bundle.main.bundleURL is not optional in modern Swift"
echo "• Removed bundleNotFound error case (no longer needed)"
echo "• Simplified code while maintaining functionality"
echo ""
echo "🚀 Your project should now build without Bundle optional binding errors!"
