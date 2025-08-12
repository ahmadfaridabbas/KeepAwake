import Foundation
import ServiceManagement

class LaunchAgentManager {
    static let shared = LaunchAgentManager()
    
    private let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.yourname.KeepAwake"
    
    private init() {}
    
    // MARK: - Launch at Login Management
    
    func enableLaunchAtLogin() throws {
        try SMAppService.mainApp.register()
    }
    
    func disableLaunchAtLogin() throws {
        try SMAppService.mainApp.unregister()
    }
    
    func isLaunchAtLoginEnabled() -> Bool {
        return SMAppService.mainApp.status == .enabled
    }
    
    // MARK: - Legacy Launch Agent Support (for older macOS versions)
    
    private var launchAgentURL: URL {
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        return homeDirectory
            .appendingPathComponent("Library")
            .appendingPathComponent("LaunchAgents")
            .appendingPathComponent("\(bundleIdentifier).plist")
    }
    
    func createLegacyLaunchAgent() throws {
        let appURL = Bundle.main.bundleURL
        
        let launchAgentDict: [String: Any] = [
            "Label": bundleIdentifier,
            "ProgramArguments": [appURL.path],
            "RunAtLoad": true,
            "KeepAlive": false,
            "LaunchOnlyOnce": true
        ]
        
        let launchAgentData = try PropertyListSerialization.data(
            fromPropertyList: launchAgentDict,
            format: .xml,
            options: 0
        )
        
        // Ensure LaunchAgents directory exists
        let launchAgentsDir = launchAgentURL.deletingLastPathComponent()
        try FileManager.default.createDirectory(
            at: launchAgentsDir,
            withIntermediateDirectories: true,
            attributes: nil
        )
        
        try launchAgentData.write(to: launchAgentURL)
        
        // Load the launch agent
        try loadLaunchAgent()
    }
    
    func removeLegacyLaunchAgent() throws {
        // Unload first if it exists
        try? unloadLaunchAgent()
        
        // Remove the plist file
        if FileManager.default.fileExists(atPath: launchAgentURL.path) {
            try FileManager.default.removeItem(at: launchAgentURL)
        }
    }
    
    private func loadLaunchAgent() throws {
        let process = Process()
        process.launchPath = "/bin/launchctl"
        process.arguments = ["load", launchAgentURL.path]
        
        try process.run()
        process.waitUntilExit()
        
        if process.terminationStatus != 0 {
            throw LaunchAgentError.loadFailed
        }
    }
    
    private func unloadLaunchAgent() throws {
        let process = Process()
        process.launchPath = "/bin/launchctl"
        process.arguments = ["unload", launchAgentURL.path]
        
        try process.run()
        process.waitUntilExit()
        
        // Don't throw error if unload fails - the agent might not be loaded
    }
    
    func legacyLaunchAgentExists() -> Bool {
        return FileManager.default.fileExists(atPath: launchAgentURL.path)
    }
}

// MARK: - Errors

enum LaunchAgentError: LocalizedError {
    case loadFailed
    case unloadFailed
    
    var errorDescription: String? {
        switch self {
        case .loadFailed:
            return "Failed to load launch agent"
        case .unloadFailed:
            return "Failed to unload launch agent"
        }
    }
}
