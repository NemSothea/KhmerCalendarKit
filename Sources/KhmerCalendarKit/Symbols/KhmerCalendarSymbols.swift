import Foundation

/// A static catalog of Khmer calendar symbols — month and weekday names —
/// used when rendering Gregorian dates in Khmer.
///
/// The catalog is a thin, dependency-free data source. It does **not** know
/// about `Date` or `Calendar`; it simply maps integer indices to the canonical
/// Khmer names. Higher-level types such as ``KhmerDateFormatter`` consume it.
public enum KhmerCalendarSymbols {

    // MARK: - Months

    /// Khmer names for the 12 Gregorian months.
    ///
    /// Indexed `0 → មករា` (January) through `11 → ធ្នូ` (December).
    public static let monthNames: [String] = [
        "មករា",   // January
        "កុម្ភៈ",   // February
        "មីនា",    // March
        "មេសា",   // April
        "ឧសភា",  // May
        "មិថុនា",   // June
        "កក្កដា",  // July
        "សីហា",   // August
        "កញ្ញា",   // September
        "តុលា",   // October
        "វិច្ឆិកា",  // November
        "ធ្នូ",     // December
    ]

    /// Returns the Khmer month name for a 1-based Gregorian month number.
    ///
    /// - Parameter month: A month in the range `1...12`.
    /// - Returns: The Khmer name, or `nil` if `month` is out of range.
    public static func monthName(forMonth month: Int) -> String? {
        guard (1...12).contains(month) else { return nil }
        return monthNames[month - 1]
    }

    // MARK: - Weekdays

    /// Khmer names for the 7 weekdays.
    ///
    /// Indexed `0 → អាទិត្យ` (Sunday) through `6 → សៅរ៍` (Saturday), matching
    /// the order used by `Calendar`'s `weekday` component (offset by one).
    public static let weekdayNames: [String] = [
        "អាទិត្យ",     // Sunday
        "ច័ន្ទ",        // Monday
        "អង្គារ",       // Tuesday
        "ពុធ",         // Wednesday
        "ព្រហស្បតិ៍",   // Thursday
        "សុក្រ",        // Friday
        "សៅរ៍",        // Saturday
    ]

    /// Returns the Khmer weekday name for a `Calendar`-style weekday number.
    ///
    /// `Calendar` returns `1` for Sunday through `7` for Saturday, regardless
    /// of the user's first-day-of-week preference.
    ///
    /// - Parameter weekday: A weekday in the range `1...7`.
    /// - Returns: The Khmer name, or `nil` if `weekday` is out of range.
    public static func weekdayName(forWeekday weekday: Int) -> String? {
        guard (1...7).contains(weekday) else { return nil }
        return weekdayNames[weekday - 1]
    }
}
