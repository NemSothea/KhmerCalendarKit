# KhmerCalendarKit

A production-ready Swift Package providing a complete Khmer calendar system: Gregorian date formatting in Khmer script, Khmer lunisolar (Chhankitek) calendar conversion, and reusable SwiftUI components.

---

## Features

| Layer | What it does |
|---|---|
| **KhmerNumeralConverter** | Convert Arabic `0-9` ↔ Khmer `០-៩` digits |
| **KhmerCalendarSymbols** | Khmer month and weekday names |
| **KhmerDateFormatter** | `Date` → `"ថ្ងៃច័ន្ទ ទី១ ខែមករា ឆ្នាំ២០២៦"` |
| **KhmerLunarCalendar** | Gregorian → Khmer lunisolar date (Chhankitek) |
| **KhmerCalendarView** | SwiftUI month-grid picker |
| **KhmerDatePickerView** | Combined date + time picker |

---

## Installation

### Xcode

**File → Add Package Dependencies** → paste the repository URL → select **Up to Next Major Version**.

### Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/your-org/KhmerCalendarKit", from: "1.0.0")
],
targets: [
    .target(name: "MyApp", dependencies: ["KhmerCalendarKit"])
]
```

---

## Quick Start

```swift
import KhmerCalendarKit

// Gregorian date in Khmer
let text = Date().khmerString()
// → "ថ្ងៃច័ន្ទ ទី១ ខែមករា ឆ្នាំ២០២៦"

// Lunar date
let lunar = Date().toKhmerLunar()
print(lunar.lunarDayString)            // "១កើត"
print(lunar.lunarMonth.khmerName)      // "ចេត្រ"
print(lunar.zodiacYear.khmerName)      // "មមីរ"
print(lunar.buddhistYear)              // 2569

// SwiftUI picker
@State var date = Date()
KhmerDatePickerView(selection: $date)
```

---

## Gregorian Formatting

### KhmerDateFormatter

```swift
// Static convenience
let s = KhmerDateFormatter.string(from: date)
// → "ថ្ងៃច័ន្ទ ទី១ ខែមករា ឆ្នាំ២០២៦"

// Buddhist Era year (+543)
let be = KhmerDateFormatter.string(from: date, format: .buddhist)
// → "ថ្ងៃច័ន្ទ ទី១ ខែមករា ឆ្នាំ២៥៦៩"

// Reusable instance
let formatter = KhmerDateFormatter(format: .dateOnly)
dates.map { formatter.string(from: $0) }
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
labels.dayPrefix = ""          // drop "ទី" for compact cells
format.labels = labels
// → "ថ្ងៃច័ន្ទ ១ ខែមករា ឆ្នាំ២០២៦"
```

---

## Lunar Calendar (Chhankitek)

### KhmerLunarCalendar

```swift
let lunar = KhmerLunarCalendar.lunarDate(from: Date())

lunar.lunarDay           // 1–15
lunar.phase              // .kert (waxing) or .roch (waning)
lunar.lunarMonth         // KhmerLunarMonth enum
lunar.buddhistYear       // e.g. 2569
lunar.zodiacYear         // KhmerZodiacYear enum
lunar.isLeapMonth        // true in intercalary years (simplified engine: always false)

lunar.lunarDayString     // "១កើត" or "១រោច"
lunar.khmerDescription() // "ថ្ងៃ ១កើត ខែចេត្រ ឆ្នាំមមីរ ២៥៦៩"
```

### Date extension

```swift
let lunar = date.toKhmerLunar()
let lunar = date.toKhmerLunar(timeZone: TimeZone(identifier: "Asia/Phnom_Penh")!)
```

### Lunar months (ចន្ទគតិ)

| Index | Khmer | Approx. Gregorian |
|---|---|---|
| 0 | ចេត្រ | April |
| 1 | វិសាខ | May |
| 2 | ជេស្ឋ | June |
| 3 | អាសាឍ | July |
| 4 | ស្រាពណ៍ | August |
| 5 | ភទ្របទ | September |
| 6 | អស្សុជ | October |
| 7 | កត្តិក | November |
| 8 | មិគសិរ | December |
| 9 | បុស្ស | January |
| 10 | មាឃ | February |
| 11 | ផល្គុន | March |

### Zodiac years

| BE mod 12 | Khmer | English |
|---|---|---|
| 0 (2563 BE) | ជូត | Rat |
| 1 | ឆ្លូវ | Ox |
| 2 | ខាល | Tiger |
| 3 | ថោះ | Rabbit |
| 4 | រោង | Dragon |
| 5 | មសាញ់ | Snake |
| 6 | មមីរ | Horse |
| 7 | មមែ | Goat |
| 8 | វក | Monkey |
| 9 | រកា | Rooster |
| 10 | ចូវ | Dog |
| 11 | កុរ | Pig |

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

Combines the calendar grid with time wheels.

```swift
// Date only (default)
KhmerDatePickerView(selection: $date)

// Time only
KhmerDatePickerView(selection: $date, mode: .time, locale: .khmer)

// Date + time with seconds
KhmerDatePickerView(
    selection: $date,
    mode: .dateAndTime,
    locale: .khmer,
    showsSeconds: true
)
```

### Locale switching at runtime

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
}
```

---

## Architecture

```
KhmerCalendarKit
├── Localization
│   └── KhmerLocale          ← .khmer / .english runtime switch
├── Numerals
│   └── KhmerNumeralConverter ← Arabic ↔ Khmer digit conversion (O(n), Unicode-safe)
├── Symbols
│   └── KhmerCalendarSymbols  ← month + weekday name tables
├── Formatter
│   ├── KhmerDateFormat       ← segment toggles + era + separator
│   ├── KhmerDateLabels       ← ថ្ងៃ / ទី / ខែ / ឆ្នាំ prefixes
│   ├── KhmerDateFormatter    ← Date → Khmer string (value type, reusable)
│   └── KhmerEra              ← .christian / .buddhist (+543)
├── Lunar
│   ├── KhmerLunarCalendar    ← Gregorian → Chhankitek conversion engine
│   ├── KhmerLunarDate        ← result model (day, phase, month, BE year, zodiac)
│   ├── KhmerLunarMonth       ← ចេត្រ … ផល្គុន enum
│   ├── KhmerLunarPhase       ← .kert / .roch
│   └── KhmerZodiacYear       ← 12-animal cycle
├── ViewModels
│   └── KhmerCalendarViewModel ← ObservableObject (days grid, navigation, labels)
├── Views
│   ├── KhmerCalendarView     ← month grid (HStack/VStack, iOS 14+)
│   └── KhmerDatePickerView   ← date + time picker
└── Extensions
    └── Date+KhmerCalendarKit ← khmerString() / toKhmerLunar()
```

Data flows one way: `KhmerLocale` → `KhmerCalendarViewModel` → Views.
Views never compute calendar math directly.

---

## Extending the Package

### Add a new formatter style

1. Add a case to `KhmerDateFormat` (e.g. `static let compact = KhmerDateFormat(includesWeekday: false, separator: "/")`).
2. Optionally adjust `KhmerDateLabels` for that style.
3. Add a test in `KhmerDateFormatterTests`.

### Add a new locale

1. Add a case to `KhmerLocale` with a `foundationLocale` and `displayName`.
2. Add switch branches in `KhmerCalendarSymbols`, `KhmerLunarMonth.englishName`, etc.
3. Update `KhmerCalendarViewModel.weekdayHeaders` and `formattedHeader`.

### Custom theme

Wrap `KhmerCalendarView` in a `ViewModifier` or subclass the background/accent colors via SwiftUI environment values:

```swift
KhmerCalendarView(selection: $date)
    .accentColor(.red)
    .foregroundColor(.primary)
```

---

## Limitations vs. Apple's DateFormatter

| Capability | KhmerCalendarKit | Apple DateFormatter |
|---|---|---|
| Khmer script month names | Full support | None |
| Khmer numerals (០-៩) | Full support | None |
| Chhankitek lunar date | Synodic approximation | None |
| Zodiac year | Yes | None |
| Buddhist Era | Yes | Yes (via `.buddhist` calendar) |
| Sub-second precision | No | Yes |
| Precise leap-month detection | No (requires full ephemeris) | N/A |
| Locale-aware formatting | Manual | Automatic |

### Performance notes

- `KhmerNumeralConverter` is O(n) and allocation-free (operates on `Character`).
- `KhmerDateFormatter` is a value type; construct once and reuse across many dates.
- `KhmerLunarCalendar.lunarDate` is a pure function with no caching needed — all operations are O(1) floating-point arithmetic.
- `KhmerCalendarViewModel` recomputes `daysInDisplayedMonth` on every SwiftUI render pass. For performance-sensitive lists, extract only the values you need from the view model.

---

## iOS Version Rationale

The package targets **iOS 14+** (and macOS 11+). iOS 14 is required for:
- `Image(systemName:)` navigation chevrons (macOS 11+ on Mac)
- `.onChange(of:)` binding synchronisation
- `.font(.title2)` in the time picker separator

The Foundation + logic layer has no iOS 14 dependencies and could be used from iOS 13 by importing only those types and omitting the SwiftUI views.

---

## License

MIT — see LICENSE file.
