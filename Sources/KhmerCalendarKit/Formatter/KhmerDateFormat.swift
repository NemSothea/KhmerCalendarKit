import Foundation

/// A value that describes which segments ``KhmerDateFormatter`` should render
/// when turning a `Date` into a Khmer string, and how to render them.
///
/// A format is a plain value type: cheap to copy, easy to mutate, and safe to
/// pass across concurrency boundaries.
///
/// ## Example
///
/// ```swift
/// var format = KhmerDateFormat.dateOnly
/// format.separator = ", "
/// format.era = .buddhist
/// // → "ទី១៥, ខែមករា, ឆ្នាំ២៥៦៩"
/// ```
public struct KhmerDateFormat: Hashable, Sendable {

    // MARK: - Segment toggles

    /// Whether to include the weekday segment (e.g. `"ថ្ងៃច័ន្ទ"`).
    public var includesWeekday: Bool

    /// Whether to include the day-of-month segment (e.g. `"ទី១៥"`).
    public var includesDay: Bool

    /// Whether to include the month segment (e.g. `"ខែមករា"`).
    public var includesMonth: Bool

    /// Whether to include the year segment (e.g. `"ឆ្នាំ២០២៦"`).
    public var includesYear: Bool

    // MARK: - Rendering options

    /// The era used when rendering the year.
    public var era: KhmerEra

    /// The string used to join non-empty segments. Defaults to a single space.
    public var separator: String

    /// The Khmer prefix labels written before each segment.
    public var labels: KhmerDateLabels

    // MARK: - Init

    /// Creates a new format. All segments are included by default and the era
    /// is ``KhmerEra/christian``.
    public init(
        includesWeekday: Bool = true,
        includesDay: Bool = true,
        includesMonth: Bool = true,
        includesYear: Bool = true,
        era: KhmerEra = .christian,
        separator: String = " ",
        labels: KhmerDateLabels = .default
    ) {
        self.includesWeekday = includesWeekday
        self.includesDay = includesDay
        self.includesMonth = includesMonth
        self.includesYear = includesYear
        self.era = era
        self.separator = separator
        self.labels = labels
    }

    // MARK: - Presets

    /// The default format: weekday + day + month + year, Christian Era.
    ///
    /// Renders as e.g. `"ថ្ងៃច័ន្ទ ទី១៥ ខែមករា ឆ្នាំ២០២៦"`.
    public static let `default` = KhmerDateFormat()

    /// Same as ``default`` but with the year rendered in Buddhist Era.
    ///
    /// Renders as e.g. `"ថ្ងៃច័ន្ទ ទី១៥ ខែមករា ឆ្នាំ២៥៦៩"`.
    public static let buddhist = KhmerDateFormat(era: .buddhist)

    /// Day + month + year, with the weekday omitted.
    ///
    /// Renders as e.g. `"ទី១៥ ខែមករា ឆ្នាំ២០២៦"`.
    public static let dateOnly = KhmerDateFormat(includesWeekday: false)

    /// Month + year only.
    ///
    /// Renders as e.g. `"ខែមករា ឆ្នាំ២០២៦"`.
    public static let monthYear = KhmerDateFormat(
        includesWeekday: false,
        includesDay: false
    )
}
