import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleAwake = Self("toggleAwake", default: .init(.space, modifiers: [.command, .option]))
    
    // Quick timer shortcuts (users can set them in preferences)
    static let quickTimer30Min = Self("quickTimer30Min")
    static let quickTimer1Hour = Self("quickTimer1Hour")
    static let quickTimer2Hours = Self("quickTimer2Hours")
    static let quickTimer4Hours = Self("quickTimer4Hours")
}
