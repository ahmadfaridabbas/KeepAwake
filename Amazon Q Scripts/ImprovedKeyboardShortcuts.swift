import SwiftUI
import KeyboardShortcuts
import UserNotifications

@main
struct KeepAwakeApp: App {
    @StateObject private var manager = KeepAwakeManager()
    @StateObject private var preferences = PreferencesManager()
    
    var body: some Scene {
        MenuBarExtra {
            GlassyMenuBarView(manager: manager, preferences: preferences)
        } label: {
            Image(systemName: menuBarIcon)
                .foregroundColor(menuBarIconColor)
        }
        .menuBarExtraStyle(.window)
        .onAppear {
            setupKeyboardShortcuts()
            requestAccessibilityPermissions()
        }
    }
    
    // MARK: - Menu Bar Icon
    
    private var menuBarIcon: String {
        if manager.isAwake {
            if manager.isTimerMode {
                return "timer"
            } else {
                return "sun.max.fill"
            }
        } else {
            return "moon.fill"
        }
    }
    
    private var menuBarIconColor: Color {
        if manager.isAwake {
            if manager.isTimerMode {
                return .green
            } else {
                return .orange
            }
        } else {
            return .primary
        }
    }
    
    // MARK: - Keyboard Shortcuts
    
    private func setupKeyboardShortcuts() {
        // Main toggle shortcut
        KeyboardShortcuts.onKeyUp(for: .toggleAwake) { [weak manager] in
            DispatchQueue.main.async {
                manager?.toggleAwake()
                
                // Show notification for feedback
                let content = UNMutableNotificationContent()
                content.title = "KeepAwake"
                content.body = manager?.isAwake == true ? "Activated" : "Deactivated"
                content.sound = .default
                
                let request = UNNotificationRequest(
                    identifier: "shortcut-feedback",
                    content: content,
                    trigger: nil
                )
                
                UNUserNotificationCenter.current().add(request)
            }
        }
        
        // Quick timer shortcuts
        KeyboardShortcuts.onKeyUp(for: .quickTimer30Min) { [weak manager] in
            DispatchQueue.main.async {
                if manager?.isAwake != true {
                    manager?.startAwake(duration: 30 * 60) // 30 minutes
                }
            }
        }
        
        KeyboardShortcuts.onKeyUp(for: .quickTimer1Hour) { [weak manager] in
            DispatchQueue.main.async {
                if manager?.isAwake != true {
                    manager?.startAwake(duration: 60 * 60) // 1 hour
                }
            }
        }
        
        print("✅ Keyboard shortcuts registered:")
        print("   • Cmd+Opt+Space: Toggle KeepAwake")
        print("   • Quick timers: Available in preferences")
    }
    
    // MARK: - Accessibility Permissions
    
    private func requestAccessibilityPermissions() {
        // Check if we have accessibility permissions
        let trusted = AXIsProcessTrusted()
        
        if !trusted {
            print("⚠️  Accessibility permissions not granted")
            print("   Keyboard shortcuts may not work without accessibility access")
            
            // Show notification to user
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let content = UNMutableNotificationContent()
                content.title = "KeepAwake Setup"
                content.body = "For keyboard shortcuts to work, please grant accessibility permissions in System Preferences > Security & Privacy > Accessibility"
                content.sound = .default
                
                let request = UNNotificationRequest(
                    identifier: "accessibility-request",
                    content: content,
                    trigger: nil
                )
                
                UNUserNotificationCenter.current().add(request)
            }
        } else {
            print("✅ Accessibility permissions granted")
        }
    }
}

// MARK: - Enhanced KeyboardShortcuts Names

import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleAwake = Self("toggleAwake", default: .init(.space, modifiers: [.command, .option]))
    static let quickTimer30Min = Self("quickTimer30Min")
    static let quickTimer1Hour = Self("quickTimer1Hour")
    
    // Additional shortcuts for power users
    static let quickTimer2Hours = Self("quickTimer2Hours")
    static let quickTimer4Hours = Self("quickTimer4Hours")
    static let showPreferences = Self("showPreferences")
}

// MARK: - Keyboard Shortcut Helper

class KeyboardShortcutHelper {
    static func registerAllShortcuts(manager: KeepAwakeManager) {
        // Ensure shortcuts are registered on main thread
        DispatchQueue.main.async {
            // Main toggle
            KeyboardShortcuts.onKeyUp(for: .toggleAwake) {
                manager.toggleAwake()
                Self.showShortcutFeedback(action: manager.isAwake ? "Activated" : "Deactivated")
            }
            
            // Quick timers
            KeyboardShortcuts.onKeyUp(for: .quickTimer30Min) {
                if !manager.isAwake {
                    manager.startAwake(duration: 30 * 60)
                    Self.showShortcutFeedback(action: "30min timer started")
                }
            }
            
            KeyboardShortcuts.onKeyUp(for: .quickTimer1Hour) {
                if !manager.isAwake {
                    manager.startAwake(duration: 60 * 60)
                    Self.showShortcutFeedback(action: "1 hour timer started")
                }
            }
            
            KeyboardShortcuts.onKeyUp(for: .quickTimer2Hours) {
                if !manager.isAwake {
                    manager.startAwake(duration: 2 * 60 * 60)
                    Self.showShortcutFeedback(action: "2 hour timer started")
                }
            }
            
            KeyboardShortcuts.onKeyUp(for: .quickTimer4Hours) {
                if !manager.isAwake {
                    manager.startAwake(duration: 4 * 60 * 60)
                    Self.showShortcutFeedback(action: "4 hour timer started")
                }
            }
        }
    }
    
    private static func showShortcutFeedback(action: String) {
        let content = UNMutableNotificationContent()
        content.title = "KeepAwake"
        content.body = action
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "shortcut-\(UUID().uuidString)",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    static func checkAccessibilityPermissions() -> Bool {
        return AXIsProcessTrusted()
    }
    
    static func requestAccessibilityPermissions() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true]
        AXIsProcessTrustedWithOptions(options as CFDictionary)
    }
}
