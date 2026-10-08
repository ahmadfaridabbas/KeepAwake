import SwiftUI
import AppKit

class PreferencesWindowManager: ObservableObject {
    private var preferencesWindow: NSWindow?
    private var customTimerWindow: NSWindow?
    private var windowDelegate: PreferencesWindowDelegate?
    private var timerWindowDelegate: PreferencesWindowDelegate?
    
    func showPreferences(preferences: PreferencesManager) {
        // If window already exists, just bring it to front
        if let existingWindow = preferencesWindow, existingWindow.isVisible {
            existingWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        // Create the preferences view with close action
        let preferencesView = GlassyPreferencesView(preferences: preferences) { [weak self] in
            self?.closePreferences()
        }
        
        let hostingView = NSHostingView(rootView: preferencesView)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 700),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "KeepAwake Preferences"
        window.contentView = hostingView
        window.center()
        window.setFrameAutosaveName("KeepAwakePreferences")
        window.minSize = NSSize(width: 500, height: 600)
        window.titlebarAppearsTransparent = true
        window.backgroundColor = NSColor.controlBackgroundColor
        window.animationBehavior = .none
        // CRITICAL: We hold a strong reference to this window and manage its
        // lifetime via ARC. Leaving this true causes AppKit to also release the
        // window on close, resulting in an over-release / use-after-free that
        // crashes in objc_release during the autorelease pool drain.
        window.isReleasedWhenClosed = false
        
        let delegate = PreferencesWindowDelegate { [weak self] in
            DispatchQueue.main.async {
                self?.preferencesWindow = nil
            }
        }
        windowDelegate = delegate
        window.delegate = delegate
        
        preferencesWindow = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func closePreferences() {
        // close() triggers windowWillClose, which releases our reference.
        // With isReleasedWhenClosed = false this is safe (no over-release).
        preferencesWindow?.close()
    }
    
    func showCustomTimer(defaultDuration: TimeInterval, onStart: @escaping (TimeInterval) -> Void) {
        // If window already exists, bring to front
        if let existingWindow = customTimerWindow, existingWindow.isVisible {
            existingWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        let timerView = GlassyCustomTimerView(
            defaultDuration: defaultDuration,
            onStart: { [weak self] duration in
                onStart(duration)
                self?.closeCustomTimer()
            },
            onCancel: { [weak self] in
                self?.closeCustomTimer()
            }
        )
        
        let hostingView = NSHostingView(rootView: timerView)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 360, height: 420),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "Custom Timer"
        window.contentView = hostingView
        window.center()
        window.titlebarAppearsTransparent = true
        window.backgroundColor = NSColor.controlBackgroundColor
        window.animationBehavior = .none
        // See note in showPreferences: we own this window via ARC, so AppKit
        // must not release it on close.
        window.isReleasedWhenClosed = false
        
        let delegate = PreferencesWindowDelegate { [weak self] in
            DispatchQueue.main.async {
                self?.customTimerWindow = nil
            }
        }
        timerWindowDelegate = delegate
        window.delegate = delegate
        
        customTimerWindow = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func closeCustomTimer() {
        // close() triggers windowWillClose, which releases our reference.
        customTimerWindow?.close()
    }
}

private class PreferencesWindowDelegate: NSObject, NSWindowDelegate {
    private let onClose: () -> Void
    
    init(onClose: @escaping () -> Void) {
        self.onClose = onClose
        super.init()
    }
    
    func windowWillClose(_ notification: Notification) {
        // With isReleasedWhenClosed = false, the window is NOT freed here.
        // We let the standard close proceed and release our strong reference,
        // allowing ARC to deallocate it cleanly afterwards.
        onClose()
    }
}
