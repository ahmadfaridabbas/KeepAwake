import SwiftUI
import AppKit

// Preferences Window Manager
// This manages a standalone preferences window that won't close when recording shortcuts

class PreferencesWindowManager: ObservableObject {
    private var preferencesWindow: NSWindow?
    private var windowDelegate: WindowDelegate?
    
    func showPreferences(preferences: PreferencesManager) {
        // If window already exists, just bring it to front
        if let existingWindow = preferencesWindow {
            existingWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        // Create the preferences view
        let preferencesView = GlassyPreferencesView(preferences: preferences)
        
        // Create the hosting view
        let hostingView = NSHostingView(rootView: preferencesView)
        
        // Create the window
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 700),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        // Configure window
        window.title = "KeepAwake Preferences"
        window.contentView = hostingView
        window.center()
        window.setFrameAutosaveName("KeepAwakePreferences")
        
        // Set minimum size
        window.minSize = NSSize(width: 500, height: 600)
        
        // Make window beautiful
        window.titlebarAppearsTransparent = true
        window.backgroundColor = NSColor.controlBackgroundColor
        
        // Handle window closing
        windowDelegate = WindowDelegate { [weak self] in
            self?.preferencesWindow = nil
            self?.windowDelegate = nil
        }
        window.delegate = windowDelegate
        
        // Store reference and show
        preferencesWindow = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func closePreferences() {
        preferencesWindow?.close()
        preferencesWindow = nil
    }
}

// Window delegate to handle closing
private class WindowDelegate: NSObject, NSWindowDelegate {
    private let onClose: () -> Void
    
    init(onClose: @escaping () -> Void) {
        self.onClose = onClose
        super.init()
    }
    
    func windowWillClose(_ notification: Notification) {
        onClose()
    }
}
