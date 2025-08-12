#!/bin/bash

# KeepAwake Enhancement Integration Script
# This script helps integrate all the improvements into your existing project

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
SCRIPTS_DIR="$PROJECT_DIR/Amazon Q Scripts"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "🚀 Starting KeepAwake Enhancement Integration..."

# Create backup of existing files
echo "📦 Creating backup of existing files..."
BACKUP_DIR="$PROJECT_DIR/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup existing files
cp "$APP_DIR/KeepAwakeApp.swift" "$BACKUP_DIR/" 2>/dev/null || true
cp "$APP_DIR/KeepAwakeManager.swift" "$BACKUP_DIR/" 2>/dev/null || true
cp "$APP_DIR/KeyboardShortcuts+Names.swift" "$BACKUP_DIR/" 2>/dev/null || true

echo "✅ Backup created at: $BACKUP_DIR"

# Copy enhanced files to main project
echo "📁 Integrating enhanced files..."

# Replace main files with enhanced versions
cp "$SCRIPTS_DIR/EnhancedKeepAwakeApp.swift" "$APP_DIR/KeepAwakeApp.swift"
cp "$SCRIPTS_DIR/EnhancedKeepAwakeManager.swift" "$APP_DIR/KeepAwakeManager.swift"

# Add new files
cp "$SCRIPTS_DIR/PreferencesManager.swift" "$APP_DIR/"
cp "$SCRIPTS_DIR/EnhancedMenuBarView.swift" "$APP_DIR/"
cp "$SCRIPTS_DIR/PreferencesView.swift" "$APP_DIR/"
cp "$SCRIPTS_DIR/LaunchAgentManager.swift" "$APP_DIR/"

# Update KeyboardShortcuts+Names.swift with additional shortcuts
cat > "$APP_DIR/KeyboardShortcuts+Names.swift" << 'EOF'
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleAwake = Self("toggleAwake", default: .init(.space, modifiers: [.command, .option]))
    static let quickTimer30Min = Self("quickTimer30Min", default: .init(.init("3"), modifiers: [.command, .option]))
    static let quickTimer1Hour = Self("quickTimer1Hour", default: .init(.init("1"), modifiers: [.command, .option]))
}
EOF

echo "✅ Files integrated successfully!"

# Update entitlements for notifications and launch services
echo "🔐 Updating entitlements..."
cat > "$APP_DIR/KeepAwake.entitlements" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.app-sandbox</key>
    <true/>
    <key>com.apple.security.files.user-selected.read-only</key>
    <true/>
    <key>com.apple.security.network.client</key>
    <false/>
    <key>com.apple.security.network.server</key>
    <false/>
    <key>com.apple.security.automation.apple-events</key>
    <true/>
    <key>com.apple.security.temporary-exception.apple-events</key>
    <array>
        <string>com.apple.systemevents</string>
    </array>
</dict>
</plist>
EOF

echo "✅ Entitlements updated!"

# Create Info.plist additions for notifications
echo "📋 Info.plist recommendations:"
echo "Add the following to your Info.plist for notifications:"
echo "<key>NSUserNotificationAlertStyle</key>"
echo "<string>alert</string>"
echo ""

# Create installation instructions
cat > "$SCRIPTS_DIR/INTEGRATION_NOTES.md" << 'EOF'
# KeepAwake Enhancement Integration Notes

## What's Been Added

### New Features
1. **Timer Functionality**: Set specific durations for keep awake
2. **Enhanced Error Handling**: Better process management and error reporting
3. **Notifications**: System notifications for status changes
4. **Preferences**: Comprehensive settings management
5. **Launch at Login**: Automatic startup capability
6. **Status Indicators**: Visual feedback in menu bar

### New Files Added
- `PreferencesManager.swift` - Handles app preferences and settings
- `EnhancedMenuBarView.swift` - Enhanced menu bar interface
- `PreferencesView.swift` - Settings window
- `LaunchAgentManager.swift` - Launch at login management

### Modified Files
- `KeepAwakeApp.swift` - Enhanced with new features
- `KeepAwakeManager.swift` - Improved with timer and error handling
- `KeyboardShortcuts+Names.swift` - Additional shortcuts
- `KeepAwake.entitlements` - Updated permissions

## Next Steps

1. **Add to Xcode Project**: Add all new .swift files to your Xcode project
2. **Update Info.plist**: Add notification permissions
3. **Test Build**: Build and test the enhanced functionality
4. **Customize**: Adjust settings and preferences as needed

## New Keyboard Shortcuts
- `Cmd+Opt+Space`: Toggle Keep Awake (existing)
- `Cmd+Opt+3`: Quick 30-minute timer
- `Cmd+Opt+1`: Quick 1-hour timer

## Features Overview

### Timer Presets
- 30 minutes, 1 hour, 2 hours, 4 hours, 8 hours
- Custom timer with hours/minutes picker
- Visual countdown in menu bar

### Preferences
- Launch at login
- Notification settings
- Sleep prevention options (display/system)
- Default timer duration

### Enhanced UI
- Status indicators with icons
- Timer countdown display
- Error message display
- Improved menu organization

## Troubleshooting

If you encounter issues:
1. Check that all files are added to the Xcode project
2. Verify entitlements are properly configured
3. Ensure notification permissions are granted
4. Check console for error messages

## Backup
Your original files have been backed up to the backup directory created during integration.
EOF

echo "✅ Integration complete!"
echo ""
echo "📝 Next steps:"
echo "1. Open your Xcode project"
echo "2. Add the new .swift files to your project"
echo "3. Build and test the enhanced functionality"
echo "4. Check INTEGRATION_NOTES.md for detailed information"
echo ""
echo "🎉 Your KeepAwake app now has all the requested improvements!"
