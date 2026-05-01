import Foundation

extension Date {

    /// Returns a Khmer string representation of this date.
    ///
    /// This is sugar around ``KhmerDateFormatter`` for one-off conversions.
    /// When formatting many dates, prefer constructing a single
    /// `KhmerDateFormatter` and reusing it.
    ///
    /// - Parameters:
    ///   - format: The format to apply. Defaults to ``KhmerDateFormat/default``.
    ///   - timeZone: The time zone used for component extraction.
    ///     Defaults to ``TimeZone/current``.
    /// - Returns: A formatted Khmer string.
    public func khmerString(
        format: KhmerDateFormat = .default,
        timeZone: TimeZone = .current
    ) -> String {
        KhmerDateFormatter(format: format, timeZone: timeZone).string(from: self)
    }

    /// Converts this date to a ``KhmerLunarDate`` using the Chhankitek lunisolar calendar.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let lunar = Date().toKhmerLunar()
    /// print(lunar.lunarDayString)          // e.g. "១កើត"
    /// print(lunar.lunarMonth.khmerName)    // e.g. "ចេត្រ"
    /// print(lunar.zodiacYear.khmerName)    // e.g. "មមីរ"
    /// print(lunar.buddhistYear)            // e.g. 2569
    ///
    /// print(lunar.khmerDescription())
    /// // → "ថ្ងៃ ១កើត ខែចេត្រ ឆ្នាំមមីរ ២៥៦៩"
    /// ```
    ///
    /// - Parameter timeZone: The time zone used for component extraction.
    ///   Defaults to ``TimeZone/current``.
    /// - Returns: The equivalent ``KhmerLunarDate``.
    public func toKhmerLunar(timeZone: TimeZone = .current) -> KhmerLunarDate {
        KhmerLunarCalendar.lunarDate(from: self, timeZone: timeZone)
    }
}
