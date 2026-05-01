import Foundation

/// Converts Gregorian dates to Khmer lunisolar (Chhankitek) calendar dates.
///
/// ## Algorithm
///
/// The conversion uses a synodic-month approximation anchored to a verified
/// new moon reference:
///
/// - **Reference new moon**: January 11, 2024 at 11:57 UTC (JD ≈ 2460320.998).
///   This new moon begins Khmer lunar month **បុស្ស** (index 9 in the
///   12-month cycle that starts with ចេត្រ = 0).
///   Verified: +3 synodic months → April 8, 2024 new moon = ចេត្រ,
///   consistent with Khmer New Year falling on April 13, 2024.
/// - **Synodic month length**: 29.53058867 days.
///
/// Steps for any input date:
/// 1. Compute its Julian Day Number (JDN) at midnight UTC.
/// 2. `daysSinceRef = JDN − referenceNewMoonJD`
/// 3. `completedCycles = floor(daysSinceRef / synodicMonth)`
/// 4. `lunarAge = daysSinceRef − completedCycles × synodicMonth` → `[0, 29.53)`
/// 5. `lunarAge < 15` → waxing (kert); else waning (roch).
/// 6. Month index wraps modulo 12 from the reference month.
/// 7. Buddhist Era year accounts for the Khmer New Year boundary (~April 13).
///
/// ## Accuracy note
///
/// This implementation yields the correct lunar day for dates within a few
/// centuries of the reference. For precise inter-month boundary detection
/// (distinguishing a late day-29 from day-1 of the next month), a full
/// astronomical ephemeris is required. Leap-month (intercalary ជេស្ឋ/អាសាឍ)
/// detection is outside the scope of this simplified engine.
public enum KhmerLunarCalendar {

    // Astronomical constants
    private static let synodicMonth: Double = 29.53058867

    // Reference: new moon on January 11, 2024 at 11:57 UTC
    // JDN at midnight Jan 11, 2024 = 2460320.5; adding 11.95h/24 ≈ 2460320.998
    private static let referenceNewMoonJD: Double = 2460320.998

    // This new moon begins Khmer lunar month បុស្ស (index 9; ចេត្រ = 0).
    // Verified: counting 3 synodic months forward reaches the April 8, 2024 new
    // moon which starts ចេត្រ, consistent with Khmer New Year falling on Apr 13.
    private static let referenceMonthIndex: Int = 9

    // MARK: - Public API

    /// Converts a Gregorian `Date` to a ``KhmerLunarDate``.
    ///
    /// - Parameters:
    ///   - date: The Gregorian date to convert.
    ///   - timeZone: Time zone used to extract year/month/day. Defaults to the
    ///     device's current time zone.
    /// - Returns: The equivalent Khmer lunisolar date.
    public static func lunarDate(from date: Date, timeZone: TimeZone = .current) -> KhmerLunarDate {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = timeZone
        let c = cal.dateComponents([.year, .month, .day], from: date)
        return convert(year: c.year ?? 2024, month: c.month ?? 1, day: c.day ?? 1)
    }

    // MARK: - Core conversion (internal, exposed for testing)

    static func convert(year: Int, month: Int, day: Int) -> KhmerLunarDate {
        // Use noon (+ 0.5) as the representative instant for a calendar date.
        // The reference new moon at 11:57 UTC is near noon; using noon keeps the
        // day that contains the new moon as day 1 of the new lunar month.
        let jd = gregorianToJD(year: year, month: month, day: day) + 0.5

        let daysSinceRef = jd - referenceNewMoonJD
        let completedCycles = Int(floor(daysSinceRef / synodicMonth))
        let lunarAge = daysSinceRef - Double(completedCycles) * synodicMonth

        // Lunar day and phase
        let phase: KhmerLunarPhase
        let lunarDay: Int
        if lunarAge < 15.0 {
            phase = .kert
            lunarDay = max(1, Int(lunarAge) + 1)
        } else {
            phase = .roch
            lunarDay = max(1, Int(lunarAge - 15.0) + 1)
        }

        // Lunar month: wrap the completed-cycles offset into [0, 11]
        let rawIndex = referenceMonthIndex + completedCycles
        let monthIndex = ((rawIndex % 12) + 12) % 12
        let lunarMonth = KhmerLunarMonth(rawValue: monthIndex) ?? .chetr

        // Buddhist Era year: Khmer year increments at Khmer New Year (~April 13)
        let buddhistYear: Int
        if month > 4 || (month == 4 && day >= 13) {
            buddhistYear = year + 543
        } else {
            buddhistYear = year + 542
        }

        let zodiac = KhmerZodiacYear.year(forBuddhistEra: buddhistYear)

        return KhmerLunarDate(
            lunarDay: lunarDay,
            phase: phase,
            lunarMonth: lunarMonth,
            buddhistYear: buddhistYear,
            zodiacYear: zodiac,
            isLeapMonth: false
        )
    }

    // MARK: - Julian Day Number

    /// Standard Gregorian → Julian Day Number conversion (result at noon UTC).
    /// Using the algorithm from Meeus, "Astronomical Algorithms", ch. 7.
    static func gregorianToJD(year: Int, month: Int, day: Int) -> Double {
        var y = Double(year)
        var m = Double(month)
        if month <= 2 {
            y -= 1
            m += 12
        }
        let a = floor(y / 100.0)
        let b = 2.0 - a + floor(a / 4.0)
        return floor(365.25 * (y + 4716.0))
             + floor(30.6001 * (m + 1.0))
             + Double(day) + b - 1524.5
    }
}
