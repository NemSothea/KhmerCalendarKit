//
// Umbrella file — documents the package and provides the version constant.
// Public types live in their own files; import this module to access them all.

import Foundation

/// KhmerCalendarKit — Khmer calendar utilities for Swift.
///
/// The package is organised into four layers:
///
/// ## Numerals
/// - ``KhmerNumeralConverter`` — convert between Arabic (`0-9`) and Khmer
///   (`០-៩`) digits.
///
/// ## Gregorian formatting
/// - ``KhmerCalendarSymbols`` — Khmer names for the 12 Gregorian months and
///   7 weekdays.
/// - ``KhmerDateFormatter`` — turn a `Date` into a Khmer string
///   (`ថ្ងៃច័ន្ទ ទី១ ខែមករា ឆ្នាំ២០២៦`).
/// - ``KhmerDateFormat`` — configure which segments and which era to include.
/// - ``KhmerDateLabels`` — customise the Khmer prefix particles.
/// - ``KhmerEra`` — `.christian` (CE) or `.buddhist` (BE = CE + 543).
///
/// ## Lunar calendar (Chhankitek)
/// - ``KhmerLunarCalendar`` — convert a Gregorian `Date` to a
///   ``KhmerLunarDate``.
/// - ``KhmerLunarDate`` — day, phase (kert/roch), lunar month, Buddhist Era
///   year, and zodiac animal.
/// - ``KhmerLunarMonth`` — the 12 months from ចេត្រ to ផល្គុន.
/// - ``KhmerLunarPhase`` — waxing (``KhmerLunarPhase/kert``) or waning
///   (``KhmerLunarPhase/roch``).
/// - ``KhmerZodiacYear`` — the 12-year zodiac cycle.
///
/// ## SwiftUI components
/// - ``KhmerCalendarView`` — a month-grid calendar picker.
/// - ``KhmerDatePickerView`` — combines the calendar grid with hour/minute
///   wheels; supports `.date`, `.time`, and `.dateAndTime` modes.
/// - ``KhmerDatePickerMode`` — display-mode enum.
/// - ``KhmerLocale`` — `.khmer` or `.english`; switch at runtime to re-render
///   any view or formatter in the other language.
///
/// ## Date extensions
/// `Date` gains two convenience methods:
/// - `date.khmerString(format:timeZone:)` — shortcut to ``KhmerDateFormatter``.
/// - `date.toKhmerLunar(timeZone:)` — shortcut to ``KhmerLunarCalendar``.
///
/// ## Quick start
///
/// ```swift
/// import KhmerCalendarKit
///
/// // Gregorian formatting
/// let text = Date().khmerString()
/// // → "ថ្ងៃច័ន្ទ ទី១ ខែមករា ឆ្នាំ២០២៦"
///
/// // Buddhist Era year
/// let be = Date().khmerString(format: .buddhist)
/// // → "ថ្ងៃច័ន្ទ ទី១ ខែមករា ឆ្នាំ២៥៦៩"
///
/// // Lunar calendar
/// let lunar = Date().toKhmerLunar()
/// print("\(lunar.lunarDayString) ខែ\(lunar.lunarMonth.khmerName)")
/// // → "១កើត ខែចេត្រ"
///
/// // SwiftUI
/// @State var date = Date()
/// KhmerDatePickerView(selection: $date, mode: .dateAndTime, locale: .khmer)
/// ```
public enum KhmerCalendarKit {

    /// The semantic version of the package.
    public static let version: String = "1.0.0"
}
