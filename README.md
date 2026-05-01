# KhmerCalendarKit

![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)
![iOS](https://img.shields.io/badge/iOS-14%2B-blue?logo=apple)
![macOS](https://img.shields.io/badge/macOS-11%2B-blue?logo=apple)
![SPM](https://img.shields.io/badge/Swift_Package_Manager-compatible-brightgreen)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

A Swift Package for working with the Khmer calendar system — Gregorian date formatting in Khmer script, Khmer lunisolar (Chhankitek) calendar conversion, and ready-to-use SwiftUI components with runtime Khmer/English locale switching.

---

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Gregorian Formatting](#gregorian-formatting)
- [Lunar Calendar (Chhankitek)](#lunar-calendar-chhankitek)
- [SwiftUI Components](#swiftui-components)
- [Architecture](#architecture)
- [Demo App](#demo-app)
- [Extending the Package](#extending-the-package)
- [Comparison with Apple's DateFormatter](#comparison-with-apples-dateformatter)
- [Contributing](#contributing)
- [License](#license)

---

## Features

| Component | Description |
|---|---|
| **KhmerNumeralConverter** | Convert Arabic `0–9` ↔ Khmer `០–៩` digits |
| **KhmerCalendarSymbols** | Khmer names for all 12 months and 7 weekdays |
| **KhmerDateFormatter** | `Date` → `"ថ្ងៃច័ន្ទ ទី១ ខែមករា ឆ្នាំ២០២៦"` with CE/BE era support |
| **KhmerLunarCalendar** | Gregorian → Khmer lunisolar (Chhankitek) date conversion |
| **KhmerCalendarView** | SwiftUI month-grid calendar picker |
| **KhmerDatePickerView** | Combined date + time picker with scrollable wheels |

---

## Requirements

| Requirement | Minimum |
|---|---|
| Swift | 5.9 |
| iOS | 14.0 |
| macOS | 11.0 |
| tvOS | 14.0 |
| watchOS | 7.0 |
| Xcode | 15.0 |

> The Foundation and logic layers (`KhmerDateFormatter`, `KhmerLunarCalendar`, etc.) have no SwiftUI dependency and are compatible with iOS 13+ when used without the view components.

---

## Installation

### Xcode

1. Open your project in Xcode.
2. Go to **File → Add Package Dependencies…**
3. Enter the repository URL:
   ```
   https://github.com/NemSothea/KhmerCalendarKit
   ```
4. Select **Up to Next Major Version** from `1.0.0`.

### Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/NemSothea/KhmerCalendarKit", from: "1.0.0")
],
targets: [
    .target(name: "MyApp", dependencies: ["KhmerCalendarKit"])
]
```

---

## Quick Start

```swift
import KhmerCalendarKit

// Gregorian date in Khmer script
let text = Date().khmerString()
// → "ថ្ងៃច័ន្ទ ទី១ ខែមករា ឆ្នាំ២០២៦"

// Buddhist Era year
let be = Date().khmerString(format: .buddhist)
// → "ថ្ងៃច័ន្ទ ទី១ ខែមករា ឆ្នាំ២៥៦៩"

// Khmer lunisolar date
let lunar = Date().toKhmerLunar()
print(lunar.lunarDayString)          // "១កើត"
print(lunar.lunarMonth.khmerName)    // "ចេត្រ"
print(lunar.zodiacYear.khmerName)    // "មមីរ"
print(lunar.buddhistYear)            // 2569
print(lunar.khmerDescription())      // "ថ្ងៃ ១កើត ខែចេត្រ ឆ្នាំមមីរ ២៥៦៩"

// SwiftUI date picker
@State var date = Date()
KhmerDatePickerView(selection: $date)
```

---

## Gregorian Formatting

### KhmerDateFormatter

```swift
// One-off convenience
let s = KhmerDateFormatter.string(from: date)
// → "ថ្ងៃច័ន្ទ ទី១ ខែមករា ឆ្នាំ២០២៦"

// Buddhist Era
let be = KhmerDateFormatter.string(from: date, format: .buddhist)
// → "ថ្ងៃច័ន្ទ ទី១ ខែមករា ឆ្នាំ២៥៦៩"

// Reusable instance — preferred when formatting many dates
let formatter = KhmerDateFormatter(format: .dateOnly)
let results = dates.map { formatter.string(from: $0) }
```

### Format presets

| Preset | Output |
|---|---|
| `.default` | `ថ្ងៃច័ន្ទ ទី១ ខែមករា ឆ្នាំ២០២៦` |
| `.buddhist` | `ថ្ងៃច័ន្ទ ទី១ ខែមករា ឆ្នាំ២៥៦៩` |
| `.dateOnly` | `ទី១ ខែមករា ឆ្នាំ២០២៦` |
| `.monthYear` | `ខែមករា ឆ្នាំ២០២៦` |

### Custom format

```swift
var format = KhmerDateFormat(
    includesWeekday: false,
    era: .buddhist,
    separator: ", "
)
// → "ទី១, ខែមករា, ឆ្នាំ២៥៦៩"
```

### Custom labels

```swift
var labels = KhmerDateLabels.default
labels.dayPrefix = ""          // remove "ទី" prefix for compact cells
format.labels = labels
// → "ថ្ងៃច័ន្ទ ១ ខែមករា ឆ្នាំ២០២៦"
```

---

## Lunar Calendar (Chhankitek)

### KhmerLunarCalendar

```swift
let lunar = KhmerLunarCalendar.lunarDate(from: Date())

lunar.lunarDay           // Day within the half-month: 1–15
lunar.phase              // .kert (waxing) or .roch (waning)
lunar.lunarMonth         // KhmerLunarMonth enum value
lunar.buddhistYear       // Buddhist Era year, e.g. 2569
lunar.zodiacYear         // KhmerZodiacYear enum value
lunar.isLeapMonth        // true in intercalary months

lunar.lunarDayString     // "១កើត" or "១រោច"
lunar.khmerDescription() // "ថ្ងៃ ១កើត ខែចេត្រ ឆ្នាំមមីរ ២៥៦៩"
```

### Date extension

```swift
let lunar = date.toKhmerLunar()

// Explicit time zone (recommended for devices outside Cambodia)
let lunar = date.toKhmerLunar(timeZone: TimeZone(identifier: "Asia/Phnom_Penh")!)
```

### Lunar months (ចន្ទគតិ)

| # | Khmer | Romanised | Approx. Gregorian |
|---|---|---|---|
| 1 | ចេត្រ | Chetr | April |
| 2 | វិសាខ | Visak | May |
| 3 | ជេស្ឋ | Cheth | June |
| 4 | អាសាឍ | Asath | July |
| 5 | ស្រាពណ៍ | Srap | August |
| 6 | ភទ្របទ | Phetra | September |
| 7 | អស្សុជ | Assuj | October |
| 8 | កត្តិក | Kattek | November |
| 9 | មិគសិរ | Migsir | December |
| 10 | បុស្ស | Boss | January |
| 11 | មាឃ | Meakh | February |
| 12 | ផល្គុន | Phalgun | March |

### Zodiac years (របស់១២)

| Khmer | English | BE cycle (anchor: 2563 = ជូត) |
|---|---|---|
| ជូត | Rat | BE mod 12 = 0 |
| ឆ្លូវ | Ox | 1 |
| ខាល | Tiger | 2 |
| ថោះ | Rabbit | 3 |
| រោង | Dragon | 4 |
| មសាញ់ | Snake | 5 |
| មមីរ | Horse | 6 |
| មមែ | Goat | 7 |
| វក | Monkey | 8 |
| រកា | Rooster | 9 |
| ចូវ | Dog | 10 |
| កុរ | Pig | 11 |

---

## SwiftUI Components

### KhmerCalendarView

A month-grid calendar picker compatible with iOS 14+.

```swift
@State private var date   = Date()
@State private var locale: KhmerLocale = .khmer

KhmerCalendarView(
    selection: $date,
    locale: locale,
    firstWeekday: 1    // 1 = Sunday, 2 = Monday
)
```

### KhmerDatePickerView

Combines the calendar grid with scrollable time wheels.

```swift
// Date only (default)
KhmerDatePickerView(selection: $date)

// Time only
KhmerDatePickerView(selection: $date, mode: .time, locale: .khmer)

// Date and time with seconds wheel
KhmerDatePickerView(
    selection: $date,
    mode: .dateAndTime,
    locale: .khmer,
    showsSeconds: true
)
```

### Runtime locale switching

Both views re-render instantly when the locale binding changes.

```swift
@State private var locale: KhmerLocale = .khmer

VStack {
    Picker("Language", selection: $locale) {
        ForEach(KhmerLocale.allCases, id: \.self) { loc in
            Text(loc.displayName).tag(loc)
        }
    }
    .pickerStyle(.segmented)

    KhmerCalendarView(selection: $date, locale: locale)
        .id(locale)   // ensures ViewModel is recreated on change
}
```

---

## Architecture

```
KhmerCalendarKit
├── Localization
│   └── KhmerLocale              — .khmer / .english runtime switch
├── Numerals
│   └── KhmerNumeralConverter    — Arabic ↔ Khmer digit conversion (O(n))
├── Symbols
│   └── KhmerCalendarSymbols     — month and weekday name tables
├── Formatter
│   ├── KhmerDateFormat          — segment toggles, era, separator
│   ├── KhmerDateLabels          — ថ្ងៃ / ទី / ខែ / ឆ្នាំ prefix strings
│   ├── KhmerDateFormatter       — Date → Khmer string (value type, reusable)
│   └── KhmerEra                 — .christian (CE) / .buddhist (BE, +543)
├── Lunar
│   ├── KhmerLunarCalendar       — Gregorian → Chhankitek conversion engine
│   ├── KhmerLunarDate           — day, phase, month, Buddhist Era year, zodiac
│   ├── KhmerLunarMonth          — ចេត្រ … ផល្គុន (12-month enum)
│   ├── KhmerLunarPhase          — .kert (waxing) / .roch (waning)
│   └── KhmerZodiacYear          — 12-animal cycle
├── ViewModels
│   └── KhmerCalendarViewModel   — ObservableObject: grid, navigation, labels
├── Views
│   ├── KhmerCalendarView        — month grid (iOS 14+)
│   └── KhmerDatePickerView      — date + time picker
└── Extensions
    └── Date+KhmerCalendarKit    — khmerString() / toKhmerLunar()
```

Data flows in one direction: `KhmerLocale` → `KhmerCalendarViewModel` → Views. Views never compute calendar logic directly.

**Performance notes**

- `KhmerNumeralConverter` is O(n) per string and performs no heap allocations.
- `KhmerDateFormatter` is a value type — construct once and reuse for batches of dates.
- `KhmerLunarCalendar.lunarDate(from:)` is a pure O(1) function; no caching is needed.

---

## Demo App

A fully functional demo app is included at [`KhmerCalendarKitDemo/`](KhmerCalendarKitDemo/). Open the Xcode project to run it on the iOS Simulator or a device.

| Screen | Demonstrates |
|---|---|
| **Home** | Today's date in CE, BE, and Chhankitek formats |
| **Formatter** | Live output with segment toggles and era picker |
| **Calendar** | `KhmerCalendarView` with Khmer / English locale toggle |
| **Date Picker** | `KhmerDatePickerView` in Date, Time, and Date & Time modes |
| **Lunar** | Chhankitek detail card, date lookup, interactive 12-animal zodiac grid |
| **Settings** | Shared locale, era, and first-weekday preferences; numeral reference |

---

## Extending the Package

### Add a formatter preset

1. Add a static property to `KhmerDateFormat`:
   ```swift
   static let compact = KhmerDateFormat(includesWeekday: false, separator: "/")
   ```
2. Adjust `KhmerDateLabels` if needed.
3. Add a test in `KhmerDateFormatterTests`.

### Add a locale

1. Add a case to `KhmerLocale` with `foundationLocale` and `displayName`.
2. Add branches in `KhmerCalendarSymbols`, `KhmerLunarMonth.englishName`, etc.
3. Update `KhmerCalendarViewModel.weekdayHeaders` and `formattedHeader`.

### Custom theme

Apply SwiftUI environment modifiers directly to any view:

```swift
KhmerCalendarView(selection: $date)
    .accentColor(.indigo)
    .foregroundColor(.primary)
    .background(Color(.secondarySystemBackground))
```

---

## Comparison with Apple's DateFormatter

| Capability | KhmerCalendarKit | Apple `DateFormatter` |
|---|---|---|
| Khmer script month and weekday names | ✅ Full support | ❌ Not available |
| Khmer numerals (០–៩) | ✅ Full support | ❌ Not available |
| Chhankitek lunisolar date | ✅ Synodic approximation | ❌ Not available |
| 12-year zodiac cycle | ✅ | ❌ |
| Buddhist Era | ✅ | ✅ (via `.buddhist` `Calendar`) |
| Precise astronomical leap-month | ❌ Requires full ephemeris | N/A |
| Sub-second precision | ❌ | ✅ |
| Automatic locale-aware formatting | ❌ Manual | ✅ |

---

## Contributing

Contributions, bug reports, and feature requests are welcome. Please open an issue or submit a pull request on [GitHub](https://github.com/NemSothea/KhmerCalendarKit).

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/my-improvement`.
3. Commit your changes with a descriptive message.
4. Push the branch and open a pull request.

Please ensure all existing tests pass (`swift test`) and add tests for any new behaviour.

---

## License

KhmerCalendarKit is released under the **MIT License**. See [LICENSE](LICENSE) for details.
