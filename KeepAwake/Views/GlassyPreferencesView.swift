import SwiftUI
import KeyboardShortcuts
import ApplicationServices

struct GlassyPreferencesView: View {
    @ObservedObject var preferences: PreferencesManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Glassy Effect
            headerSection
            
            // Content
            ScrollView {
                VStack(spacing: 24) {
                    generalSettings
                    keyboardShortcutsSettings
                    sleepPreventionSettings
                    timerSettings
                    resetSection
                }
                .padding(24)
            }
            .background(.regularMaterial)
        }
        .frame(width: 520, height: 580)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.15), radius: 40, x: 0, y: 20)
        )
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack(spacing: 16) {
            // App Icon
            ZStack {
                Circle()
                    .fill(.blue.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: "moon.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.blue)
                    .shadow(color: .blue.opacity(0.3), radius: 4)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("KeepAwake Preferences")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text("Customize your KeepAwake experience")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button("Done") {
                dismiss()
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(LinearGradient(colors: [.blue.opacity(0.8), .blue], startPoint: .top, endPoint: .bottom))
                    .shadow(color: Color.blue.opacity(0.4), radius: 6)
            )
            .buttonStyle(.plain)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }
    
    // MARK: - General Settings
    
    private var generalSettings: some View {
        settingsCard(title: "General", icon: "gear.circle.fill", iconColor: .blue) {
            VStack(spacing: 16) {
                settingRow(
                    title: "Launch at Login",
                    subtitle: "Automatically start KeepAwake when you log in",
                    icon: "power.circle.fill",
                    iconColor: .green
                ) {
                    Toggle("", isOn: $preferences.launchAtLogin)
                        .toggleStyle(.switch)
                        .scaleEffect(0.8)
                }
                
                Divider()
                    .background(.white.opacity(0.1))
                
                settingRow(
                    title: "Show Notifications",
                    subtitle: "Display notifications for status changes and errors",
                    icon: "bell.circle.fill",
                    iconColor: .orange
                ) {
                    Toggle("", isOn: $preferences.showNotifications)
                        .toggleStyle(.switch)
                        .scaleEffect(0.8)
                }
            }
        }
    }
    
    // MARK: - Keyboard Shortcuts Settings
    
    private var keyboardShortcutsSettings: some View {
        settingsCard(title: "Keyboard Shortcuts", icon: "keyboard.fill", iconColor: .purple) {
            VStack(spacing: 16) {
                // Main toggle shortcut
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "command.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.purple)
                        
                        Text("Toggle KeepAwake")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        KeyboardShortcuts.Recorder(for: .toggleAwake)
                            .frame(width: 120)
                    }
                    
                    Text("Quickly toggle KeepAwake on/off from anywhere")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                    .background(.white.opacity(0.1))
                
                // Quick timer shortcuts
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "timer.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.green)
                        
                        Text("Quick Timer Shortcuts")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.primary)
                        
                        Spacer()
                    }
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("30 Minutes")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.primary)
                                .frame(width: 80, alignment: .leading)
                            
                            Spacer()
                            
                            KeyboardShortcuts.Recorder(for: .quickTimer30Min)
                                .frame(width: 120)
                        }
                        
                        HStack {
                            Text("1 Hour")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.primary)
                                .frame(width: 80, alignment: .leading)
                            
                            Spacer()
                            
                            KeyboardShortcuts.Recorder(for: .quickTimer1Hour)
                                .frame(width: 120)
                        }
                        
                        HStack {
                            Text("2 Hours")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.primary)
                                .frame(width: 80, alignment: .leading)
                            
                            Spacer()
                            
                            KeyboardShortcuts.Recorder(for: .quickTimer2Hours)
                                .frame(width: 120)
                        }
                        
                        HStack {
                            Text("4 Hours")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(.primary)
                                .frame(width: 80, alignment: .leading)
                            
                            Spacer()
                            
                            KeyboardShortcuts.Recorder(for: .quickTimer4Hours)
                                .frame(width: 120)
                        }
                    }
                    
                    Text("Set shortcuts for instant timer activation")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                
                // Accessibility note
                if !AXIsProcessTrusted() {
                    Divider()
                        .background(.white.opacity(0.1))
                    
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.orange)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Accessibility Permissions Required")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.orange)
                            
                            Text("Grant accessibility permissions in System Preferences for shortcuts to work")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Open Settings") {
                            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
                        }
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(.orange)
                        )
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.orange.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.orange.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
            }
        }
    }
    
    // MARK: - Sleep Prevention Settings
    
    private var sleepPreventionSettings: some View {
        settingsCard(title: "Sleep Prevention", icon: "moon.circle.fill", iconColor: .purple) {
            VStack(spacing: 16) {
                settingRow(
                    title: "Prevent Display Sleep",
                    subtitle: "Keep the screen from turning off",
                    icon: "display",
                    iconColor: .blue
                ) {
                    Toggle("", isOn: $preferences.preventDisplaySleep)
                        .toggleStyle(.switch)
                        .scaleEffect(0.8)
                }
                
                Divider()
                    .background(.white.opacity(0.1))
                
                settingRow(
                    title: "Prevent System Sleep",
                    subtitle: "Keep the system from going to sleep",
                    icon: "desktopcomputer",
                    iconColor: .green
                ) {
                    Toggle("", isOn: $preferences.preventSystemSleep)
                        .toggleStyle(.switch)
                        .scaleEffect(0.8)
                }
                
                if !preferences.preventDisplaySleep && !preferences.preventSystemSleep {
                    Divider()
                        .background(.white.opacity(0.1))
                    
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.orange)
                        
                        Text("At least one option should be enabled for proper functionality")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.orange)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.orange.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.orange.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
            }
        }
    }
    
    // MARK: - Timer Settings
    
    private var timerSettings: some View {
        settingsCard(title: "Timer Settings", icon: "timer.circle.fill", iconColor: .green) {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.green)
                        
                        Text("Default Timer Duration")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Text(formatDuration(preferences.defaultTimerDuration))
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(.secondary.opacity(0.1))
                            )
                    }
                    
                    Text("Default duration when opening custom timer")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                    
                    // Custom Slider with Glassy Effect
                    VStack(spacing: 8) {
                        Slider(
                            value: Binding(
                                get: { preferences.defaultTimerDuration / 60 },
                                set: { preferences.defaultTimerDuration = $0 * 60 }
                            ),
                            in: 15...480,
                            step: 15
                        ) {
                            Text("Duration")
                        } minimumValueLabel: {
                            Text("15m")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.secondary)
                        } maximumValueLabel: {
                            Text("8h")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.secondary)
                        }
                        .accentColor(.green)
                        
                        // Duration markers
                        HStack {
                            ForEach([30, 60, 120, 240, 480], id: \.self) { minutes in
                                VStack(spacing: 2) {
                                    Rectangle()
                                        .fill(.secondary.opacity(0.3))
                                        .frame(width: 1, height: 4)
                                    
                                    Text(minutes >= 60 ? "\(minutes/60)h" : "\(minutes)m")
                                        .font(.system(size: 8, weight: .medium))
                                        .foregroundStyle(.secondary)
                                }
                                
                                if minutes != 480 {
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
    }
    
    // MARK: - Reset Section
    
    private var resetSection: some View {
        settingsCard(title: "Reset", icon: "arrow.clockwise.circle.fill", iconColor: .red) {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.orange)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Reset to Defaults")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.primary)
                        
                        Text("This will reset all preferences to their default values")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                
                Button("Reset All Settings") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        preferences.resetToDefaults()
                    }
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(LinearGradient(colors: [.red.opacity(0.8), .red], startPoint: .top, endPoint: .bottom))
                        .shadow(color: Color.red.opacity(0.3), radius: 4)
                )
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func settingsCard<Content: View>(
        title: String,
        icon: String,
        iconColor: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Card Header
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(iconColor)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            
            // Card Content
            content()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private func settingRow<Content: View>(
        title: String,
        subtitle: String,
        icon: String,
        iconColor: Color,
        @ViewBuilder control: () -> Content
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(iconColor)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            control()
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
