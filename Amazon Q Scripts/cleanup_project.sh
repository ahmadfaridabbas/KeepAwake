#!/bin/bash

# KeepAwake Project Cleanup Script
# This script removes unnecessary files and cleans up the project

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"

echo "🧹 Starting KeepAwake project cleanup..."

# Files and directories that can be safely deleted
files_to_delete=(
    # macOS system files
    "$PROJECT_DIR/.DS_Store"
    "$PROJECT_DIR/KeepAwake/.DS_Store"
    "$PROJECT_DIR/KeepAwake/Resources/Assets.xcassets/.DS_Store"
    
    # Amazon Q Scripts (now that integration is complete)
    # Note: We'll keep the documentation files but remove the duplicate Swift files
    "$PROJECT_DIR/Amazon Q Scripts/EnhancedKeepAwakeManager.swift"
    "$PROJECT_DIR/Amazon Q Scripts/PreferencesManager.swift"
    "$PROJECT_DIR/Amazon Q Scripts/EnhancedMenuBarView.swift"
    "$PROJECT_DIR/Amazon Q Scripts/PreferencesView.swift"
    "$PROJECT_DIR/Amazon Q Scripts/LaunchAgentManager.swift"
    "$PROJECT_DIR/Amazon Q Scripts/EnhancedKeepAwakeApp.swift"
    
    # Backup directory (optional - you can keep this if you want)
    # "$PROJECT_DIR/backup_20250811_102318"
)

# Count deleted files
deleted_count=0
kept_files=()

echo "🗑️  Removing unnecessary files..."

for file in "${files_to_delete[@]}"; do
    if [ -f "$file" ] || [ -d "$file" ]; then
        rm -rf "$file"
        echo "✅ Deleted: $(basename "$file")"
        ((deleted_count++))
    fi
done

# Keep useful files in Amazon Q Scripts
useful_scripts=(
    "FEATURE_GUIDE.md"
    "INTEGRATION_NOTES.md"
    "integrate_improvements.sh"
    "organize_project_files.sh"
    "fix_build_issues.sh"
    "cleanup_project.sh"
)

echo ""
echo "📋 Keeping useful files in Amazon Q Scripts:"
for script in "${useful_scripts[@]}"; do
    if [ -f "$PROJECT_DIR/Amazon Q Scripts/$script" ]; then
        echo "✅ Kept: $script"
        kept_files+=("$script")
    fi
done

# Optional: Clean up Xcode derived data and build artifacts
echo ""
echo "🧽 Cleaning Xcode build artifacts..."

# Remove user-specific Xcode files (these get regenerated)
if [ -d "$PROJECT_DIR/KeepAwake.xcodeproj/xcuserdata" ]; then
    rm -rf "$PROJECT_DIR/KeepAwake.xcodeproj/xcuserdata"
    echo "✅ Removed Xcode user data"
    ((deleted_count++))
fi

if [ -d "$PROJECT_DIR/KeepAwake.xcodeproj/project.xcworkspace/xcuserdata" ]; then
    rm -rf "$PROJECT_DIR/KeepAwake.xcodeproj/project.xcworkspace/xcuserdata"
    echo "✅ Removed workspace user data"
    ((deleted_count++))
fi

echo ""
echo "📊 Cleanup Summary:"
echo "🗑️  Files/folders deleted: $deleted_count"
echo "📁 Useful scripts kept: ${#kept_files[@]}"

echo ""
echo "🎯 Final clean project structure:"
echo "KeepAwake/"
echo "├── KeepAwake.xcodeproj/          (Xcode project)"
echo "├── KeepAwake/                    (Source code)"
echo "│   ├── Core/                     (Main app files)"
echo "│   ├── Managers/                 (Business logic)"
echo "│   ├── Views/                    (UI components)"
echo "│   ├── Utilities/                (Helper code)"
echo "│   ├── Resources/                (Assets & entitlements)"
echo "│   └── KeepAwake.entitlements    (App permissions)"
echo "├── KeepAwakeTests/               (Unit tests)"
echo "├── KeepAwakeUITests/             (UI tests)"
echo "├── Amazon Q Scripts/             (Documentation & utilities)"
echo "├── backup_20250811_102318/       (Original files backup)"
echo "└── .git/                         (Git repository)"

echo ""
echo "✨ Project cleanup complete!"
echo ""
echo "📝 What was removed:"
echo "• .DS_Store files (macOS system files)"
echo "• Duplicate Swift files from Amazon Q Scripts"
echo "• Xcode user-specific data (gets regenerated)"
echo ""
echo "📝 What was kept:"
echo "• All source code in organized folders"
echo "• Documentation and utility scripts"
echo "• Backup of original files"
echo "• Git repository"
echo "• Xcode project files"
echo "• Test files"
echo ""
echo "🎉 Your KeepAwake project is now clean and organized!"
