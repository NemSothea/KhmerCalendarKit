import Foundation

/// Renders a `Date` as a human-readable Khmer string, optionally using the
/// Buddhist Era.
///
/// `KhmerDateFormatter` is a value type — it is cheap to construct and safe to
/// copy. Reuse a single instance when formatting many dates to avoid rebuilding
/// the underlying `Calendar` for each call.
///
/// ## Example
///
/// ```swift
/// // Static convenience — quick one-off use:
/// let text = KhmerDateFormatter.string(from: Date())
/// // → "ថ្ងៃច័ន្ទ ទី១៥ ខែមករា ឆ្នាំ២០២៦"
///
/// // Instance — reuse for many dates:
/// let formatter = KhmerDateFormatter(format: .buddhist)
/// for date in dates {
///     print(formatter.string(from: date))
/// }
/// ```
public struct KhmerDateFormatter {

    // MARK: - Configuration

    /// The format describing which segments to include and how to join them.
    public var format: KhmerDateFormat

    /// The time zone used when extracting calendar components.
    /// Defaults to ``TimeZone/current``.
    public var timeZone: TimeZone

    // MARK: - Init

    /// Creates a formatter with the given configuration.
    ///
    /// - Parameters:
    ///   - format: The segments and rendering options to use. Defaults to
    ///     ``KhmerDateFormat/default``.
    ///   - timeZone: The time zone used when extracting components from the
    ///     `Date`. Defaults to the current zone.
    public init(
        format: KhmerDateFormat = .default,
        timeZone: TimeZone = .current
    ) {
        self.format = format
        self.timeZone = timeZone
    }

    // MARK: - Instance API

    /// Returns a Khmer string representation of `date` using this formatter's
    /// configuration.
    public func string(from date: Date) -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone

        let components = calendar.dateComponents(
            [.year, .month, .day, .weekday],
            from: date
        )

        let labels = format.labels
        var segments: [String] = []
        segments.reserveCapacity(4)

        if format.includesWeekday,
           let weekday = components.weekday,
           let name = KhmerCalendarSymbols.weekdayName(forWeekday: weekday) {
            segments.append(labels.weekdayPrefix + name)
        }

        if format.includesDay, let day = components.day {
            segments.append(labels.dayPrefix + KhmerNumeralConverter.khmerNumerals(from: day))
        }

        if format.includesMonth,
           let month = components.month,
           let name = KhmerCalendarSymbols.monthName(forMonth: month) {
            segments.append(labels.monthPrefix + name)
        }

        if format.includesYear, let gregorianYear = components.year {
            let displayYear = format.era.year(fromGregorian: gregorianYear)
            segments.append(labels.yearPrefix + KhmerNumeralConverter.khmerNumerals(from: displayYear))
        }

        return segments.joined(separator: format.separator)
    }

    // MARK: - Static convenience

    /// Returns a Khmer string for `date` using ``KhmerDateFormat/default``
    /// in the current time zone.
    public static func string(from date: Date) -> String {
        KhmerDateFormatter().string(from: date)
    }

    /// Returns a Khmer string for `date` using the supplied format in the
    /// current time zone.
    public static func string(from date: Date, format: KhmerDateFormat) -> String {
        KhmerDateFormatter(format: format).string(from: date)
    }
}
