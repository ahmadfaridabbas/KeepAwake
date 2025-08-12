import Foundation
import ServiceManagement

class PreferencesManager: ObservableObject {
    @Published var launchAtLogin: Bool {
        didSet {
            setLaunchAtLogin(launchAtLogin)
        }
    }
    
    @Published var showNotifications: Bool {
        didSet {
            UserDefaults.standard.set(showNotifications, forKey: "showNotifications")
        }
    }
    
    @Published var defaultTimerDuration: TimeInterval {
        didSet {
            UserDefaults.standard.set(defaultTimerDuration, forKey: "defaultTimerDuration")
        }
    }
    
    @Published var preventDisplaySleep: Bool {
        didSet {
            UserDefaults.standard.set(preventDisplaySleep, forKey: "preventDisplaySleep")
        }
    }
    
    @Published var preventSystemSleep: Bool {
        didSet {
            UserDefaults.standard.set(preventSystemSleep, forKey: "preventSystemSleep")
        }
    }
    
    init() {
        // Load saved preferences
        self.launchAtLogin = SMAppService.mainApp.status == .enabled
        self.showNotifications = UserDefaults.standard.object(forKey: "showNotifications") as? Bool ?? true
        self.defaultTimerDuration = UserDefaults.standard.object(forKey: "defaultTimerDuration") as? TimeInterval ?? 3600 // 1 hour
        self.preventDisplaySleep = UserDefaults.standard.object(forKey: "preventDisplaySleep") as? Bool ?? true
        self.preventSystemSleep = UserDefaults.standard.object(forKey: "preventSystemSleep") as? Bool ?? true
    }
    
    private func setLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Failed to \(enabled ? "enable" : "disable") launch at login: \(error)")
        }
    }
    
    func getCaffeinateArguments() -> [String] {
        var args: [String] = []
        
        if preventDisplaySleep {
            args.append("-d")
        }
        
        if preventSystemSleep {
            args.append("-i")
        }
        
        // If neither is selected, default to both
        if args.isEmpty {
            args = ["-di"]
        } else if args.count == 2 {
            args = ["-di"] // Combine flags
        }
        
        return args
    }
    
    func resetToDefaults() {
        showNotifications = true
        defaultTimerDuration = 3600
        preventDisplaySleep = true
        preventSystemSleep = true
        launchAtLogin = false
    }
}
