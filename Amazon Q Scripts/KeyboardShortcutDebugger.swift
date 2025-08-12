import Foundation
import KeyboardShortcuts

// Add this to your KeepAwakeApp.swift for debugging
extension KeepAwakeApp {
    private func debugKeyboardShortcuts() {
        print("🔍 Debugging Keyboard Shortcuts:")
        
        // Check if shortcuts are properly defined
        let toggleShortcut = KeyboardShortcuts.Name.toggleAwake
        print("   • Toggle shortcut name: \(toggleShortcut)")
        
        // Check accessibility permissions
        let hasAccessibility = AXIsProcessTrusted()
        print("   • Accessibility permissions: \(hasAccessibility ? "✅ Granted" : "❌ Not granted")")
        
        // Check if KeyboardShortcuts framework is working
        print("   • KeyboardShortcuts framework loaded: ✅")
        
        // Test shortcut registration
        KeyboardShortcuts.onKeyUp(for: .toggleAwake) {
            print("🎯 Keyboard shortcut triggered!")
        }
        
        print("   • Shortcut handler registered: ✅")
        print("")
        print("💡 If shortcut doesn't work:")
        print("   1. Check accessibility permissions in System Preferences")
        print("   2. Make sure no other app is using Cmd+Opt+Space")
        print("   3. Try restarting the app")
        print("   4. Check Console.app for error messages")
    }
}

// Alternative shortcut implementation for testing
class KeyboardShortcutTester {
    static func testShortcuts() {
        print("🧪 Testing keyboard shortcuts...")
        
        // Test basic shortcut registration
        KeyboardShortcuts.onKeyUp(for: .toggleAwake) {
            print("✅ Toggle shortcut works!")
            
            // Post a notification for visual feedback
            let notification = NSUserNotification()
            notification.title = "KeepAwake"
            notification.informativeText = "Keyboard shortcut works!"
            notification.soundName = NSUserNotificationDefaultSoundName
            
            NSUserNotificationCenter.default.deliver(notification)
        }
        
        print("   • Test shortcut registered")
        print("   • Press Cmd+Opt+Space to test")
    }
    
    static func checkPermissions() -> Bool {
        let trusted = AXIsProcessTrusted()
        
        if !trusted {
            print("⚠️  Requesting accessibility permissions...")
            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true]
            AXIsProcessTrustedWithOptions(options as CFDictionary)
        }
        
        return trusted
    }
}
