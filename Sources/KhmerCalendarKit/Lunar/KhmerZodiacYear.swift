import Foundation

/// The twelve-year zodiac cycle used in the Khmer calendar.
///
/// The cycle follows the same animals as the Chinese/SE-Asian tradition.
/// The mapping is anchored to Buddhist Era 2563 = ជូត (Rat).
///
/// | BE   | CE   | Khmer | English |
/// |------|------|-------|---------|
/// | 2563 | 2020 | ជូត   | Rat     |
/// | 2567 | 2024 | រោង   | Dragon  |
/// | 2568 | 2025 | មសាញ់ | Snake   |
/// | 2569 | 2026 | មមីរ  | Horse   |
public enum KhmerZodiacYear: Int, CaseIterable, Hashable, Sendable {

    case jut     = 0  // ជូត   — Rat
    case chhlauv       // ឆ្លូវ  — Ox
    case khal          // ខាល   — Tiger
    case thos          // ថោះ   — Rabbit
    case rong          // រោង   — Dragon
    case masanh        // មសាញ់ — Snake
    case mameir        // មមីរ  — Horse
    case mamae         // មមែ   — Goat
    case vak           // វក    — Monkey
    case roka          // រកា   — Rooster
    case chuv          // ចូវ   — Dog
    case kor           // កុរ   — Pig

    // MARK: - Names

    /// Full Khmer name of this zodiac year.
    public var khmerName: String {
        switch self {
        case .jut:     return "ជូត"
        case .chhlauv: return "ឆ្លូវ"
        case .khal:    return "ខាល"
        case .thos:    return "ថោះ"
        case .rong:    return "រោង"
        case .masanh:  return "មសាញ់"
        case .mameir:  return "មមីរ"
        case .mamae:   return "មមែ"
        case .vak:     return "វក"
        case .roka:    return "រកា"
        case .chuv:    return "ចូវ"
        case .kor:     return "កុរ"
        }
    }

    /// English animal name.
    public var englishName: String {
        switch self {
        case .jut:     return "Rat"
        case .chhlauv: return "Ox"
        case .khal:    return "Tiger"
        case .thos:    return "Rabbit"
        case .rong:    return "Dragon"
        case .masanh:  return "Snake"
        case .mameir:  return "Horse"
        case .mamae:   return "Goat"
        case .vak:     return "Monkey"
        case .roka:    return "Rooster"
        case .chuv:    return "Dog"
        case .kor:     return "Pig"
        }
    }

    // MARK: - Lookup

    /// Returns the zodiac animal for the given Buddhist Era year.
    ///
    /// The Khmer year is used (starts around April 13), so for Gregorian dates
    /// before mid-April the caller should pass `buddhistYear - 1`.
    public static func year(forBuddhistEra be: Int) -> KhmerZodiacYear {
        // Anchor: BE 2563 = ជូត (Rat), rawValue 0
        let index = ((be - 2563) % 12 + 12) % 12
        return KhmerZodiacYear(rawValue: index) ?? .jut
    }
}
