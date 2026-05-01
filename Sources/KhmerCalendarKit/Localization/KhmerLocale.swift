import Foundation

/// Controls whether the package renders text in Khmer or English.
///
/// Pass a `KhmerLocale` to any formatter or view to switch the display language
/// at runtime without reloading the component.
///
/// ```swift
/// @State var locale: KhmerLocale = .khmer
///
/// KhmerCalendarView(selection: $date, locale: locale)
///
/// Toggle("English", isOn: Binding(
///     get: { locale == .english },
///     set: { locale = $0 ? .english : .khmer }
/// ))
/// ```
public enum KhmerLocale: Hashable, Sendable, CaseIterable {

    /// Khmer script and Khmer numerals (០-៩).
    case khmer

    /// Latin script and Arabic numerals (0-9).
    case english

    /// The corresponding Foundation `Locale`.
    public var foundationLocale: Locale {
        switch self {
        case .khmer:   return Locale(identifier: "km_KH")
        case .english: return Locale(identifier: "en_US")
        }
    }

    /// Display label suitable for a language-toggle UI.
    public var displayName: String {
        switch self {
        case .khmer:   return "ខ្មែរ"
        case .english: return "English"
        }
    }
}
