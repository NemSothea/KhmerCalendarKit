import Foundation

/// A date expressed in the Khmer lunisolar (Chhankitek) calendar.
///
/// A `KhmerLunarDate` encodes the day within the lunar half-month (1–15),
/// the phase (waxing/waning), the lunar month, the Buddhist Era year, and the
/// zodiac year.
///
/// Obtain one from a Gregorian `Date` via ``KhmerLunarCalendar/lunarDate(from:timeZone:)``,
/// or via the ``Date/toKhmerLunar(timeZone:)`` convenience extension.
public struct KhmerLunarDate: Hashable, Sendable {

    /// Day number within the lunar half-month, in the range `1...15`.
    public let lunarDay: Int

    /// Whether the day falls in the waxing (``KhmerLunarPhase/kert``) or
    /// waning (``KhmerLunarPhase/roch``) half.
    public let phase: KhmerLunarPhase

    /// The Khmer lunar month.
    public let lunarMonth: KhmerLunarMonth

    /// Year in Buddhist Era (Gregorian + 543 before mid-April, or + 542 for
    /// the portion of the Gregorian year before Khmer New Year ~April 13).
    public let buddhistYear: Int

    /// The twelve-year zodiac animal for this year.
    public let zodiacYear: KhmerZodiacYear

    /// `true` if this date falls in an intercalary (doubled) month.
    ///
    /// The simplified Chhankitek engine always returns `false`; a full
    /// astronomical engine is required for accurate leap-month detection.
    public let isLeapMonth: Bool

    // MARK: - Formatted helpers

    /// Khmer string combining day number and phase, e.g. `"១កើត"` or `"១រោច"`.
    public var lunarDayString: String {
        KhmerNumeralConverter.khmerNumerals(from: lunarDay) + phase.khmerName
    }

    /// Full Khmer description: `"ថ្ងៃ ១កើត ខែចេត្រ ឆ្នាំរោង ២៥៦៧"`.
    public func khmerDescription(locale: KhmerLocale = .khmer) -> String {
        switch locale {
        case .khmer:
            let year = KhmerNumeralConverter.khmerNumerals(from: buddhistYear)
            return "ថ្ងៃ \(lunarDayString) ខែ\(lunarMonth.khmerName) ឆ្នាំ\(zodiacYear.khmerName) \(year)"
        case .english:
            return "\(phase.englishName) \(lunarDay), \(lunarMonth.englishName), Year of the \(zodiacYear.englishName) (\(buddhistYear) BE)"
        }
    }
}
