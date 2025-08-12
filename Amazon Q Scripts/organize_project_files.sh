#!/bin/bash

# KeepAwake Project File Organization Script
# This script organizes the enhanced files into a proper folder structure

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "🗂️  Organizing KeepAwake project files..."

# Create organized folder structure
echo "📁 Creating folder structure..."

# Create subdirectories for better organization
mkdir -p "$APP_DIR/Core"
mkdir -p "$APP_DIR/Views"
mkdir -p "$APP_DIR/Managers"
mkdir -p "$APP_DIR/Utilities"
mkdir -p "$APP_DIR/Resources"

# Move files to appropriate folders
echo "📦 Moving files to organized folders..."

# Core app files
if [ -f "$APP_DIR/KeepAwakeApp.swift" ]; then
    mv "$APP_DIR/KeepAwakeApp.swift" "$APP_DIR/Core/"
    echo "✅ Moved KeepAwakeApp.swift to Core/"
fi

if [ -f "$APP_DIR/ContentView.swift" ]; then
    mv "$APP_DIR/ContentView.swift" "$APP_DIR/Views/"
    echo "✅ Moved ContentView.swift to Views/"
fi

# Manager files
if [ -f "$APP_DIR/KeepAwakeManager.swift" ]; then
    mv "$APP_DIR/KeepAwakeManager.swift" "$APP_DIR/Managers/"
    echo "✅ Moved KeepAwakeManager.swift to Managers/"
fi

if [ -f "$APP_DIR/PreferencesManager.swift" ]; then
    mv "$APP_DIR/PreferencesManager.swift" "$APP_DIR/Managers/"
    echo "✅ Moved PreferencesManager.swift to Managers/"
fi

if [ -f "$APP_DIR/LaunchAgentManager.swift" ]; then
    mv "$APP_DIR/LaunchAgentManager.swift" "$APP_DIR/Managers/"
    echo "✅ Moved LaunchAgentManager.swift to Managers/"
fi

# View files
if [ -f "$APP_DIR/EnhancedMenuBarView.swift" ]; then
    mv "$APP_DIR/EnhancedMenuBarView.swift" "$APP_DIR/Views/"
    echo "✅ Moved EnhancedMenuBarView.swift to Views/"
fi

if [ -f "$APP_DIR/PreferencesView.swift" ]; then
    mv "$APP_DIR/PreferencesView.swift" "$APP_DIR/Views/"
    echo "✅ Moved PreferencesView.swift to Views/"
fi

# Utility files
if [ -f "$APP_DIR/KeyboardShortcuts+Names.swift" ]; then
    mv "$APP_DIR/KeyboardShortcuts+Names.swift" "$APP_DIR/Utilities/"
    echo "✅ Moved KeyboardShortcuts+Names.swift to Utilities/"
fi

# Resource files
if [ -f "$APP_DIR/KeepAwake.entitlements" ]; then
    mv "$APP_DIR/KeepAwake.entitlements" "$APP_DIR/Resources/"
    echo "✅ Moved KeepAwake.entitlements to Resources/"
fi

if [ -d "$APP_DIR/Assets.xcassets" ]; then
    mv "$APP_DIR/Assets.xcassets" "$APP_DIR/Resources/"
    echo "✅ Moved Assets.xcassets to Resources/"
fi

echo ""
echo "🎯 Final project structure:"
echo "KeepAwake/"
echo "├── Core/"
echo "│   └── KeepAwakeApp.swift"
echo "├── Managers/"
echo "│   ├── KeepAwakeManager.swift"
echo "│   ├── PreferencesManager.swift"
echo "│   └── LaunchAgentManager.swift"
echo "├── Views/"
echo "│   ├── ContentView.swift"
echo "│   ├── EnhancedMenuBarView.swift"
echo "│   └── PreferencesView.swift"
echo "├── Utilities/"
echo "│   └── KeyboardShortcuts+Names.swift"
echo "└── Resources/"
echo "    ├── Assets.xcassets/"
echo "    └── KeepAwake.entitlements"
echo ""
echo "✅ Project files organized successfully!"
echo ""
echo "📝 Next steps:"
echo "1. Open your Xcode project"
echo "2. The files should automatically appear in the organized structure"
echo "3. If needed, you can create groups in Xcode to match this folder structure"
echo "4. Build and test your enhanced KeepAwake app"
echo ""
echo "🎉 Your project is now properly organized!"
