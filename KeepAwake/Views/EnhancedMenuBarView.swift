import SwiftUI
import KeyboardShortcuts

struct EnhancedMenuBarView: View {
    @ObservedObject var manager: KeepAwakeManager
    @ObservedObject var preferences: PreferencesManager
    @State private var showingPreferences = false
    @State private var showingTimerPicker = false
    @State private var selectedTimerDuration: TimeInterval = 3600
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Status Section
            statusSection
            
            Divider()
            
            // Timer Section
            if manager.isTimerMode {
                timerSection
                Divider()
            }
            
            // Controls Section
            controlsSection
            
            Divider()
            
            // Timer Presets
            timerPresetsSection
            
            Divider()
            
            // Settings and Info
            settingsSection
        }
        .padding(.vertical, 4)
        .frame(minWidth: 250)
        .sheet(isPresented: $showingPreferences) {
            PreferencesView(preferences: preferences)
        }
        .sheet(isPresented: $showingTimerPicker) {
            ImprovedCustomTimerView(
                selectedDuration: $selectedTimerDuration,
                onStart: { duration in
                    manager.startAwake(duration: duration)
                    showingTimerPicker = false
                }
            )
        }
    }
    
    // MARK: - Status Section
    
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: manager.isAwake ? "sun.max.fill" : "moon.fill")
                    .foregroundColor(manager.isAwake ? .orange : .blue)
                Text(manager.isAwake ? "Keep Awake Active" : "Keep Awake Inactive")
                    .font(.headline)
                Spacer()
            }
            
            if let errorMessage = manager.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    // MARK: - Timer Section
    
    private var timerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(.green)
                Text("Timer Active")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
            }
            
            HStack {
                Text("Time Remaining:")
                    .font(.caption)
                Spacer()
                Text(manager.formatTimeRemaining())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
        }
    }
    
    // MARK: - Controls Section
    
    private var controlsSection: some View {
        VStack(spacing: 4) {
            Button(action: {
                manager.toggleAwake()
            }) {
                HStack {
                    Image(systemName: manager.isAwake ? "stop.fill" : "play.fill")
                    Text(manager.isAwake ? "Stop Keep Awake" : "Start Keep Awake")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            // Keyboard shortcut display
            HStack {
                Text("Keyboard Shortcut:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                KeyboardShortcuts.Recorder("", name: .toggleAwake)
                    .fixedSize()
            }
        }
    }
    
    // MARK: - Timer Presets Section
    
    private var timerPresetsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Quick Timer")
                .font(.subheadline)
                .fontWeight(.medium)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 4) {
                ForEach(KeepAwakeManager.timerPresets, id: \.self) { duration in
                    Button(manager.formatDuration(duration)) {
                        manager.startAwake(duration: duration)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .disabled(manager.isAwake)
                }
            }
            
            Button("Custom Timer...") {
                selectedTimerDuration = preferences.defaultTimerDuration
                showingTimerPicker = true
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .disabled(manager.isAwake)
        }
    }
    
    // MARK: - Settings Section
    
    private var settingsSection: some View {
        VStack(spacing: 4) {
            Button("Preferences...") {
                showingPreferences = true
            }
            .buttonStyle(.bordered)
            
            Divider()
            
            Button("Quit KeepAwake") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.bordered)
        }
    }
}

// MARK: - Custom Timer View

struct ImprovedCustomTimerView: View {
    @Binding var selectedDuration: TimeInterval
    let onStart: (TimeInterval) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var hours: Int = 1
    @State private var minutes: Int = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Custom Timer")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                // Hours selection with stepper
                HStack {
                    Text("Hours:")
                        .frame(width: 60, alignment: .leading)
                    
                    Stepper(value: $hours, in: 0...23) {
                        Text("\(hours)")
                            .frame(width: 40, alignment: .center)
                            .padding(.horizontal, 8)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                
                // Minutes selection with stepper
                HStack {
                    Text("Minutes:")
                        .frame(width: 60, alignment: .leading)
                    
                    Stepper(value: $minutes, in: 0...59, step: 5) {
                        Text("\(minutes)")
                            .frame(width: 40, alignment: .center)
                            .padding(.horizontal, 8)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                
                // Quick preset buttons
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quick Presets:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        Button("15m") { setTime(hours: 0, minutes: 15) }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        
                        Button("30m") { setTime(hours: 0, minutes: 30) }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        
                        Button("1h") { setTime(hours: 1, minutes: 0) }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        
                        Button("2h") { setTime(hours: 2, minutes: 0) }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        
                        Button("4h") { setTime(hours: 4, minutes: 0) }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        
                        Button("8h") { setTime(hours: 8, minutes: 0) }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                    }
                }
            }
            
            // Duration display
            HStack {
                Text("Duration:")
                    .foregroundColor(.secondary)
                Spacer()
                Text(formatDuration(hours: hours, minutes: minutes))
                    .fontWeight(.medium)
            }
            .padding(.top, 8)
            
            // Action buttons
            HStack(spacing: 12) {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Button("Start Timer") {
                    let duration = TimeInterval(hours * 3600 + minutes * 60)
                    if duration > 0 {
                        onStart(duration)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(hours == 0 && minutes == 0)
            }
        }
        .padding(20)
        .frame(width: 320)
        .onAppear {
            let totalMinutes = Int(selectedDuration / 60)
            hours = totalMinutes / 60
            minutes = totalMinutes % 60
        }
    }
    
    private func setTime(hours: Int, minutes: Int) {
        self.hours = hours
        self.minutes = minutes
    }
    
    private func formatDuration(hours: Int, minutes: Int) -> String {
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "0m"
        }
    }
}
