#!/bin/bash

# Cleanup Old View Files Script
# This script removes old view files that are no longer needed

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "🧹 Cleaning up old view files..."

# Create backup first
BACKUP_DIR="$PROJECT_DIR/old_views_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "📦 Creating backup of old files..."

# Backup old files before removing
if [ -f "$APP_DIR/Views/EnhancedMenuBarView.swift" ]; then
    cp "$APP_DIR/Views/EnhancedMenuBarView.swift" "$BACKUP_DIR/"
    echo "✅ Backed up EnhancedMenuBarView.swift"
fi

if [ -f "$APP_DIR/Views/PreferencesView.swift" ]; then
    cp "$APP_DIR/Views/PreferencesView.swift" "$BACKUP_DIR/"
    echo "✅ Backed up PreferencesView.swift"
fi

echo "📁 Backup created at: $BACKUP_DIR"

# Remove old files (optional - uncomment if you want to remove them)
# echo "🗑️  Removing old view files..."
# rm -f "$APP_DIR/Views/EnhancedMenuBarView.swift"
# rm -f "$APP_DIR/Views/PreferencesView.swift"
# echo "✅ Removed old view files"

echo ""
echo "📋 Current view files structure:"
echo "✨ Active Files (used by app):"
echo "  • GlassyMenuBarView.swift - Main menu bar interface"
echo "  • GlassyPreferencesView.swift - Preferences window"
echo ""
echo "📚 Reference Files (kept for reference):"
echo "  • ContentView.swift - Original SwiftUI content view"
echo "  • EnhancedMenuBarView.swift - Previous enhanced version"
echo "  • PreferencesView.swift - Previous preferences version"
echo ""
echo "💡 Note: Old files have been backed up but kept in project"
echo "   You can remove them manually if desired, or keep them for reference"
echo ""
echo "✅ Cleanup complete! Your app now uses the beautiful glassy interface!"
