import Foundation

/// The phase of the moon within a Khmer lunar half-month.
public enum KhmerLunarPhase: Hashable, Sendable {

    /// Waxing moon — days 1-15 of the first half (new moon → full moon).
    case kert

    /// Waning moon — days 1-15 of the second half (full moon → new moon).
    case roch

    /// Khmer name for this phase.
    public var khmerName: String {
        switch self {
        case .kert: return "កើត"
        case .roch: return "រោច"
        }
    }

    /// English name for this phase.
    public var englishName: String {
        switch self {
        case .kert: return "Waxing"
        case .roch: return "Waning"
        }
    }
}
