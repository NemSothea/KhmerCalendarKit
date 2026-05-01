import Foundation

/// Controls which components ``KhmerDatePickerView`` displays.
public enum KhmerDatePickerMode: Hashable, Sendable {
    /// Show only the month-grid calendar.
    case date
    /// Show only the hour/minute (and optional second) wheels.
    case time
    /// Show both the calendar grid and the time wheels.
    case dateAndTime
}
