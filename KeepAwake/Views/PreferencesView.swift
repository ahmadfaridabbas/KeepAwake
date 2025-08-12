import SwiftUI

struct PreferencesView: View {
    @ObservedObject var preferences: PreferencesManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("KeepAwake Preferences")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            Divider()
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // General Settings
                    generalSettings
                    
                    Divider()
                    
                    // Sleep Prevention Settings
                    sleepPreventionSettings
                    
                    Divider()
                    
                    // Timer Settings
                    timerSettings
                    
                    Divider()
                    
                    // Reset Section
                    resetSection
                }
                .padding()
            }
        }
        .frame(width: 450, height: 500)
    }
    
    // MARK: - General Settings
    
    private var generalSettings: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("General")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                Toggle("Launch at Login", isOn: $preferences.launchAtLogin)
                
                Text("Automatically start KeepAwake when you log in to your Mac")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Toggle("Show Notifications", isOn: $preferences.showNotifications)
                
                Text("Display notifications when KeepAwake starts, stops, or encounters errors")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Sleep Prevention Settings
    
    private var sleepPreventionSettings: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sleep Prevention")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                Toggle("Prevent Display Sleep", isOn: $preferences.preventDisplaySleep)
                
                Text("Keep the screen from turning off")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Toggle("Prevent System Sleep", isOn: $preferences.preventSystemSleep)
                
                Text("Keep the system from going to sleep")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !preferences.preventDisplaySleep && !preferences.preventSystemSleep {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("At least one option should be enabled for the app to function properly")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .padding(.top, 4)
            }
        }
    }
    
    // MARK: - Timer Settings
    
    private var timerSettings: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Timer Settings")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Default Timer Duration:")
                    Spacer()
                    Text(formatDuration(preferences.defaultTimerDuration))
                        .foregroundColor(.secondary)
                }
                
                Slider(
                    value: Binding(
                        get: { preferences.defaultTimerDuration / 60 }, // Convert to minutes
                        set: { preferences.defaultTimerDuration = $0 * 60 } // Convert back to seconds
                    ),
                    in: 15...480, // 15 minutes to 8 hours
                    step: 15
                ) {
                    Text("Duration")
                } minimumValueLabel: {
                    Text("15m")
                        .font(.caption)
                } maximumValueLabel: {
                    Text("8h")
                        .font(.caption)
                }
                
                Text("Default duration when opening custom timer")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Reset Section
    
    private var resetSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Reset")
                .font(.headline)
            
            Button("Reset to Defaults") {
                preferences.resetToDefaults()
            }
            .buttonStyle(.bordered)
            
            Text("Reset all preferences to their default values")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Helper Functions
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

#Preview {
    PreferencesView(preferences: PreferencesManager())
}
