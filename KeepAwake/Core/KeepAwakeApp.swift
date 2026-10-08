import SwiftUI
import KeyboardShortcuts
import UserNotifications
import ApplicationServices

@main
struct KeepAwakeApp: App {
    @StateObject private var preferences: PreferencesManager
    @StateObject private var manager: KeepAwakeManager
    @StateObject private var preferencesWindowManager: PreferencesWindowManager
    
    init() {
        let prefs = PreferencesManager()
        let mgr = KeepAwakeManager(preferences: prefs)
        let prefsWindowManager = PreferencesWindowManager()
        
        _preferences = StateObject(wrappedValue: prefs)
        _manager = StateObject(wrappedValue: mgr)
        _preferencesWindowManager = StateObject(wrappedValue: prefsWindowManager)
        
        // Setup immediately in init — not tied to any view lifecycle
        Self.setupKeyboardShortcuts(manager: mgr)
        Self.requestAccessibilityPermissions()
        Self.requestNotificationPermissions()
    }
    
    var body: some Scene {
        MenuBarExtra {
            GlassyMenuBarView(
                manager: manager,
                preferences: preferences,
                preferencesWindowManager: preferencesWindowManager
            )
        } label: {
            Image(systemName: menuBarIcon)
                .foregroundColor(menuBarIconColor)
        }
        .menuBarExtraStyle(.window)
    }
    
    // MARK: - Menu Bar Icon
    
    private var menuBarIcon: String {
        if manager.isAwake {
            return manager.isTimerMode ? "timer" : "sun.max.fill"
        }
        return "moon.fill"
    }
    
    private var menuBarIconColor: Color {
        if manager.isAwake {
            return manager.isTimerMode ? .green : .orange
        }
        return .primary
    }
    
    // MARK: - Keyboard Shortcuts
    
    private static func setupKeyboardShortcuts(manager mgr: KeepAwakeManager) {
        KeyboardShortcuts.onKeyUp(for: .toggleAwake) { [weak mgr] in
            guard let mgr = mgr else { return }
            // Already on main thread from KeyboardShortcuts library
            mgr.toggleAwake()
        }
        
        KeyboardShortcuts.onKeyUp(for: .quickTimer30Min) { [weak mgr] in
            guard let mgr = mgr else { return }
            if !mgr.isAwake { mgr.startAwake(duration: 30 * 60) }
        }
        
        KeyboardShortcuts.onKeyUp(for: .quickTimer1Hour) { [weak mgr] in
            guard let mgr = mgr else { return }
            if !mgr.isAwake { mgr.startAwake(duration: 60 * 60) }
        }
        
        KeyboardShortcuts.onKeyUp(for: .quickTimer2Hours) { [weak mgr] in
            guard let mgr = mgr else { return }
            if !mgr.isAwake { mgr.startAwake(duration: 2 * 60 * 60) }
        }
        
        KeyboardShortcuts.onKeyUp(for: .quickTimer4Hours) { [weak mgr] in
            guard let mgr = mgr else { return }
            if !mgr.isAwake { mgr.startAwake(duration: 4 * 60 * 60) }
        }
    }
    
    // MARK: - Permissions
    
    private static func requestAccessibilityPermissions() {
        if !AXIsProcessTrusted() {
            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true]
            AXIsProcessTrustedWithOptions(options as CFDictionary)
        }
    }
    
    private static func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
}
