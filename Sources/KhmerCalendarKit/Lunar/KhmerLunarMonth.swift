import Foundation

/// The twelve months of the Khmer lunisolar (Chhankitek) calendar.
///
/// The cycle begins with ``chetr`` (ចេត្រ), which falls around April (Gregorian)
/// and aligns with the Khmer New Year. Raw values are 0-based so that modular
/// arithmetic wraps cleanly.
public enum KhmerLunarMonth: Int, CaseIterable, Hashable, Sendable {

    case chetr   = 0   // ចេត្រ  — ~April
    case visak         // វិសាខ  — ~May
    case cheth         // ជេស្ឋ  — ~June
    case asath         // អាសាឍ  — ~July  (can be doubled in intercalary years)
    case srap          // ស្រាពណ៍ — ~August
    case phetra        // ភទ្របទ  — ~September
    case assuj         // អស្សុជ  — ~October
    case kattek        // កត្តិក  — ~November
    case migsir        // មិគសិរ  — ~December
    case boss          // បុស្ស   — ~January
    case meakh         // មាឃ    — ~February
    case phalgun       // ផល្គុន  — ~March

    // MARK: - Names

    /// Full Khmer name of the month.
    public var khmerName: String {
        switch self {
        case .chetr:   return "ចេត្រ"
        case .visak:   return "វិសាខ"
        case .cheth:   return "ជេស្ឋ"
        case .asath:   return "អាសាឍ"
        case .srap:    return "ស្រាពណ៍"
        case .phetra:  return "ភទ្របទ"
        case .assuj:   return "អស្សុជ"
        case .kattek:  return "កត្តិក"
        case .migsir:  return "មិគសិរ"
        case .boss:    return "បុស្ស"
        case .meakh:   return "មាឃ"
        case .phalgun: return "ផល្គុន"
        }
    }

    /// Romanised transliteration of the month name.
    public var englishName: String {
        switch self {
        case .chetr:   return "Chetr"
        case .visak:   return "Visak"
        case .cheth:   return "Cheth"
        case .asath:   return "Asath"
        case .srap:    return "Srap"
        case .phetra:  return "Phetra"
        case .assuj:   return "Assuj"
        case .kattek:  return "Kattek"
        case .migsir:  return "Migsir"
        case .boss:    return "Boss"
        case .meakh:   return "Meakh"
        case .phalgun: return "Phalgun"
        }
    }
}
