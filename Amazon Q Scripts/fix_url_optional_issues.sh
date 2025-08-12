#!/bin/bash

# Fix URL Optional Issues Script
# This script fixes potential URL and Optional binding issues

set -e

PROJECT_DIR="/Users/ahmadfaridabbas/Desktop/KeepAwake"
APP_DIR="$PROJECT_DIR/KeepAwake"

echo "🔗 Fixing URL and Optional binding issues..."

# Fix 1: Update KeepAwakeManager to handle Process setup more safely
echo "🔧 Updating KeepAwakeManager Process handling..."

# Create a safer version of the startCaffeinate method
cat > "$APP_DIR/Managers/KeepAwakeManager_temp.swift" << 'EOF'
import Foundation
import UserNotifications

class KeepAwakeManager: ObservableObject {
    @Published var isAwake = false
    @Published var timeRemaining: TimeInterval = 0
    @Published var isTimerMode = false
    @Published var errorMessage: String?
    
    private var caffeinateProcess: Process?
    private var timer: Timer?
    private var startTime: Date?
    
    // Timer presets in seconds
    static let timerPresets: [TimeInterval] = [
        30 * 60,    // 30 minutes
        60 * 60,    // 1 hour
        2 * 60 * 60,  // 2 hours
        4 * 60 * 60,  // 4 hours
        8 * 60 * 60   // 8 hours
    ]
    
    init() {
        requestNotificationPermission()
    }
    
    // MARK: - Main Controls
    
    func toggleAwake() {
        if isAwake {
            stopAwake()
        } else {
            startAwake()
        }
    }
    
    func startAwake(duration: TimeInterval? = nil) {
        guard !isAwake else { return }
        
        do {
            try startCaffeinate()
            isAwake = true
            errorMessage = nil
            
            if let duration = duration {
                startTimer(duration: duration)
                showNotification(title: "KeepAwake Started", 
                               body: "Mac will stay awake for \(formatDuration(duration))")
            } else {
                showNotification(title: "KeepAwake Started", 
                               body: "Mac will stay awake indefinitely")
            }
        } catch {
            errorMessage = "Failed to start: \(error.localizedDescription)"
            showNotification(title: "KeepAwake Error", body: errorMessage!)
        }
    }
    
    func stopAwake() {
        caffeinateProcess?.terminate()
        caffeinateProcess = nil
        stopTimer()
        isAwake = false
        errorMessage = nil
        
        showNotification(title: "KeepAwake Stopped", 
                        body: "Mac can now sleep normally")
    }
    
    // MARK: - Caffeinate Process Management
    
    private func startCaffeinate() throws {
        let process = Process()
        
        // Use launchPath instead of executableURL for better compatibility
        process.launchPath = "/usr/bin/caffeinate"
        process.arguments = ["-di"] // Prevent display and idle sleep
        
        // Set up error handling
        let pipe = Pipe()
        process.standardError = pipe
        
        // Monitor process termination
        process.terminationHandler = { [weak self] process in
            DispatchQueue.main.async {
                if process.terminationStatus != 0 && self?.isAwake == true {
                    self?.handleProcessError()
                }
            }
        }
        
        process.launch()
        caffeinateProcess = process
    }
    
    private func handleProcessError() {
        errorMessage = "Caffeinate process terminated unexpectedly"
        isAwake = false
        stopTimer()
        showNotification(title: "KeepAwake Error", 
                        body: "Process stopped unexpectedly. Please try again.")
    }
    
    // MARK: - Timer Functionality
    
    private func startTimer(duration: TimeInterval) {
        isTimerMode = true
        timeRemaining = duration
        startTime = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func updateTimer() {
        guard let startTime = startTime else { return }
        
        let elapsed = Date().timeIntervalSince(startTime)
        let originalDuration = timeRemaining + elapsed
        timeRemaining = max(0, originalDuration - elapsed)
        
        if timeRemaining <= 0 {
            stopAwake()
            showNotification(title: "KeepAwake Timer Finished", 
                           body: "Your Mac can now sleep normally")
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerMode = false
        timeRemaining = 0
        startTime = nil
    }
    
    // MARK: - Notifications
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    
    private func showNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Utility Functions
    
    func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    func formatTimeRemaining() -> String {
        let hours = Int(timeRemaining) / 3600
        let minutes = (Int(timeRemaining) % 3600) / 60
        let seconds = Int(timeRemaining) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    // MARK: - Cleanup
    
    deinit {
        stopAwake()
    }
}
EOF

# Replace the original file
mv "$APP_DIR/Managers/KeepAwakeManager_temp.swift" "$APP_DIR/Managers/KeepAwakeManager.swift"

echo "✅ Updated KeepAwakeManager with safer Process handling"

# Fix 2: Update LaunchAgentManager to use launchPath instead of executableURL
echo "🔧 Updating LaunchAgentManager Process handling..."

# Update the LaunchAgentManager to use launchPath
sed -i '' 's/process.executableURL = URL(fileURLWithPath: "\/bin\/launchctl")/process.launchPath = "\/bin\/launchctl"/g' "$APP_DIR/Managers/LaunchAgentManager.swift"

echo "✅ Updated LaunchAgentManager Process handling"

echo ""
echo "🎯 URL and Optional binding fixes complete!"
echo ""
echo "📝 Changes made:"
echo "• Changed Process.executableURL to Process.launchPath"
echo "• Removed URL() initializations that could cause Optional issues"
echo "• Used more compatible Process setup methods"
echo "• Maintained all existing functionality"
echo ""
echo "🚀 Your project should now build without URL/Optional errors!"
EOF
