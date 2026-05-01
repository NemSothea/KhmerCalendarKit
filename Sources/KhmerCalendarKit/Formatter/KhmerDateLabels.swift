import Foundation

/// The Khmer prefix strings prepended to each segment of a formatted date.
///
/// Pulling these prefixes into a value type — instead of hardcoding them
/// inside ``KhmerDateFormatter`` — lets callers customise the rendering for
/// short forms, alternate dialects, or stripped-down outputs without
/// subclassing or copying the formatter.
///
/// ## Example
///
/// ```swift
/// // Default: "ថ្ងៃច័ន្ទ ទី១៥ ខែមករា ឆ្នាំ២០២៦"
///
/// // Short labels — drop the day prefix:
/// var labels = KhmerDateLabels.default
/// labels.dayPrefix = ""
/// var format = KhmerDateFormat.default
/// format.labels = labels
/// // → "ថ្ងៃច័ន្ទ ១៥ ខែមករា ឆ្នាំ២០២៦"
/// ```
public struct KhmerDateLabels: Hashable, Sendable {

    /// Prefix written before the weekday name. Default: `"ថ្ងៃ"` ("day").
    public var weekdayPrefix: String

    /// Prefix written before the day-of-month number. Default: `"ទី"` ("number").
    public var dayPrefix: String

    /// Prefix written before the month name. Default: `"ខែ"` ("month").
    public var monthPrefix: String

    /// Prefix written before the year number. Default: `"ឆ្នាំ"` ("year").
    public var yearPrefix: String

    /// Creates a labels value. Each parameter defaults to the canonical Khmer
    /// prefix, so callers can override only what they need.
    public init(
        weekdayPrefix: String = "ថ្ងៃ",
        dayPrefix: String = "ទី",
        monthPrefix: String = "ខែ",
        yearPrefix: String = "ឆ្នាំ"
    ) {
        self.weekdayPrefix = weekdayPrefix
        self.dayPrefix = dayPrefix
        self.monthPrefix = monthPrefix
        self.yearPrefix = yearPrefix
    }

    /// The canonical Khmer prefixes used by the default format.
    public static let `default` = KhmerDateLabels()

    /// Empty prefixes — segments render as bare values (e.g. `"១៥"` instead
    /// of `"ទី១៥"`). Useful for compact UI like calendar cells.
    public static let none = KhmerDateLabels(
        weekdayPrefix: "",
        dayPrefix: "",
        monthPrefix: "",
        yearPrefix: ""
    )
}
