import Foundation
import Combine

/// View model for ``KhmerCalendarView``.
///
/// Holds the currently displayed month, the user's selection, the locale, and
/// the first-weekday preference. Mutating any `@Published` property causes the
/// calendar grid to re-render.
public final class KhmerCalendarViewModel: ObservableObject {

    // MARK: - Published state

    /// The date the user has selected.
    @Published public var selection: Date

    /// The month currently rendered in the grid (day component is ignored).
    @Published public var displayedMonth: Date

    /// Display language.
    @Published public var locale: KhmerLocale

    /// First day of the week: `1` = Sunday, `2` = Monday.
    @Published public var firstWeekday: Int

    // MARK: - Init

    public init(
        selection: Date = Date(),
        locale: KhmerLocale = .khmer,
        firstWeekday: Int = 1
    ) {
        self.selection = selection
        self.displayedMonth = selection
        self.locale = locale
        self.firstWeekday = firstWeekday
    }

    // MARK: - Calendar helpers

    private var calendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = firstWeekday
        return cal
    }

    /// Header string for the displayed month, e.g. `"មករា ២០២៦"` or `"January 2026"`.
    public var formattedHeader: String {
        let cal = calendar
        guard
            let month = cal.dateComponents([.month], from: displayedMonth).month,
            let year  = cal.dateComponents([.year],  from: displayedMonth).year
        else { return "" }

        switch locale {
        case .khmer:
            let monthName = KhmerCalendarSymbols.monthName(forMonth: month) ?? ""
            let yearStr   = KhmerNumeralConverter.khmerNumerals(from: year)
            return "\(monthName) \(yearStr)"
        case .english:
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US")
            df.dateFormat = "MMMM yyyy"
            return df.string(from: displayedMonth)
        }
    }

    /// Weekday header row (7 items), rotated to respect ``firstWeekday``.
    public var weekdayHeaders: [String] {
        let allShort: [String]
        switch locale {
        case .khmer:
            // Sun-first storage; short names are the first 2 cluster boundaries
            allShort = ["អា", "ចន្ទ", "អង", "ពុ", "ព្រ", "សុ", "ស"]
        case .english:
            allShort = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        }
        let offset = (firstWeekday - 1 + 7) % 7
        return Array(allShort[offset...] + allShort[..<offset])
    }

    /// A flat array of optional dates for the grid.
    ///
    /// Leading nils represent empty cells before the 1st of the month.
    /// The array length is always a multiple of 7.
    public var daysInDisplayedMonth: [Date?] {
        let cal = calendar
        guard
            let startOfMonth = cal.date(from: cal.dateComponents([.year, .month], from: displayedMonth)),
            let range = cal.range(of: .day, in: .month, for: startOfMonth)
        else { return [] }

        // Weekday (1–7) of the first day, adjusted for firstWeekday
        let firstWeekdayOfMonth = cal.component(.weekday, from: startOfMonth)
        let offset = (firstWeekdayOfMonth - firstWeekday + 7) % 7

        var cells: [Date?] = Array(repeating: nil, count: offset)
        for day in range {
            cells.append(cal.date(byAdding: .day, value: day - 1, to: startOfMonth))
        }
        // Pad to a complete final week
        let remainder = cells.count % 7
        if remainder != 0 {
            cells.append(contentsOf: Array(repeating: nil, count: 7 - remainder))
        }
        return cells
    }

    /// Organises ``daysInDisplayedMonth`` into rows of 7.
    public var weeks: [[Date?]] {
        let days = daysInDisplayedMonth
        return stride(from: 0, to: days.count, by: 7).map {
            Array(days[$0..<min($0 + 7, days.count)])
        }
    }

    // MARK: - Navigation

    /// Advance to the next month.
    public func goToNextMonth() {
        displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
    }

    /// Go back to the previous month.
    public func goToPreviousMonth() {
        displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
    }

    // MARK: - Selection helpers

    /// Returns `true` if `date` is the currently selected day.
    public func isSelected(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selection)
    }

    /// Returns `true` if `date` is today.
    public func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    /// Returns the display label for a grid cell (Khmer or Arabic numeral).
    public func dayLabel(for date: Date) -> String {
        let day = calendar.component(.day, from: date)
        switch locale {
        case .khmer:   return KhmerNumeralConverter.khmerNumerals(from: day)
        case .english: return "\(day)"
        }
    }
}
