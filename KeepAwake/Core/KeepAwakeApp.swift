import SwiftUI
import KeyboardShortcuts
import UserNotifications
import ApplicationServices

@main
struct KeepAwakeApp: App {
    @StateObject private var manager = KeepAwakeManager()
    @StateObject private var preferences = PreferencesManager()
    @StateObject private var preferencesWindowManager = PreferencesWindowManager()
    
    var body: some Scene {
        MenuBarExtra {
            GlassyMenuBarView(
                manager: manager, 
                preferences: preferences,
                preferencesWindowManager: preferencesWindowManager
            )
                .onAppear {
                    setupKeyboardShortcuts()
                    requestAccessibilityPermissions()
                    setupCleanupHandler()
                }
        } label: {
            // Use custom SVG-based icon with better rendering
            if Bundle.main.path(forResource: "MenuBarIcon", ofType: nil) != nil {
                Image("MenuBarIcon")
                    .renderingMode(.template)
                    .foregroundColor(menuBarIconColor)
                    .frame(width: 18, height: 18)
            } else {
                // Fallback to system icons
                Image(systemName: menuBarIcon)
                    .foregroundColor(menuBarIconColor)
                    .frame(width: 18, height: 18)
            }
        }
        .menuBarExtraStyle(.window)
    }
    
    // MARK: - Menu Bar Icon
    
    private var menuBarIcon: String {
        // System icon fallback (used when custom icon is not available)
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
        // Color for both custom and system icons
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
        // Capture manager weakly to avoid retain cycles
        let weakManager = { [weak manager] in return manager }
        
        // Main toggle shortcut with feedback
        KeyboardShortcuts.onKeyUp(for: .toggleAwake) {
            DispatchQueue.main.async {
                guard let manager = weakManager() else { return }
                manager.toggleAwake()
                
                // Show notification for feedback
                let content = UNMutableNotificationContent()
                content.title = "KeepAwake"
                content.body = manager.isAwake ? "Activated" : "Deactivated"
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
        KeyboardShortcuts.onKeyUp(for: .quickTimer30Min) {
            DispatchQueue.main.async {
                guard let manager = weakManager() else { return }
                if !manager.isAwake {
                    manager.startAwake(duration: 30 * 60) // 30 minutes
                }
            }
        }
        
        KeyboardShortcuts.onKeyUp(for: .quickTimer1Hour) {
            DispatchQueue.main.async {
                guard let manager = weakManager() else { return }
                if !manager.isAwake {
                    manager.startAwake(duration: 60 * 60) // 1 hour
                }
            }
        }
        
        KeyboardShortcuts.onKeyUp(for: .quickTimer2Hours) {
            DispatchQueue.main.async {
                guard let manager = weakManager() else { return }
                if !manager.isAwake {
                    manager.startAwake(duration: 2 * 60 * 60) // 2 hours
                }
            }
        }
        
        KeyboardShortcuts.onKeyUp(for: .quickTimer4Hours) {
            DispatchQueue.main.async {
                guard let manager = weakManager() else { return }
                if !manager.isAwake {
                    manager.startAwake(duration: 4 * 60 * 60) // 4 hours
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
            
            // Request permissions with prompt
            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true]
            AXIsProcessTrustedWithOptions(options as CFDictionary)
            
            // Show notification to user after a delay
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
            print("✅ Accessibility permissions granted - keyboard shortcuts should work")
        }
    }
    
    // MARK: - Cleanup
    
    private func setupCleanupHandler() {
        // Set up app termination handler
        NotificationCenter.default.addObserver(
            forName: NSApplication.willTerminateNotification,
            object: nil,
            queue: .main
        ) { _ in
            KeepAwakeApp.performCleanup(manager: self.manager)
        }
    }
    
    private static func performCleanup(manager: KeepAwakeManager) {
        print("🧹 Cleaning up KeepAwake...")
        
        // Stop any active keep awake processes
        manager.stopAwake()
        
        // Clear keyboard shortcuts to prevent dangling references
        KeyboardShortcuts.disable(.toggleAwake)
        KeyboardShortcuts.disable(.quickTimer30Min)
        KeyboardShortcuts.disable(.quickTimer1Hour)
        KeyboardShortcuts.disable(.quickTimer2Hours)
        KeyboardShortcuts.disable(.quickTimer4Hours)
        
        print("✅ Cleanup completed")
    }
}
