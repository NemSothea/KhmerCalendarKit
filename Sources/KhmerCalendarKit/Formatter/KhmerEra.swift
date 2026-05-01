import Foundation

/// The era used to render the year component of a Khmer date.
///
/// Cambodia commonly uses both the Gregorian/Christian Era and the Buddhist
/// Era (B.E.). The Buddhist Era is offset from the Gregorian year by **+543**
/// (e.g. `2026 CE → 2569 BE`).
public enum KhmerEra: Hashable, Sendable {

    /// Common Era (Gregorian year, e.g. `2026`).
    case christian

    /// Buddhist Era (Gregorian year + 543, e.g. `2569`).
    case buddhist

    /// The integer offset added to a Gregorian year to obtain the year in
    /// this era.
    public var yearOffset: Int {
        switch self {
        case .christian: return 0
        case .buddhist:  return 543
        }
    }

    /// Converts a Gregorian year into the equivalent year in this era.
    ///
    /// - Parameter gregorian: A Gregorian (proleptic) year, e.g. `2026`.
    /// - Returns: The same instant expressed in this era's year numbering.
    public func year(fromGregorian gregorian: Int) -> Int {
        gregorian + yearOffset
    }
}

extension KhmerEra: CustomStringConvertible {

    /// A short identifier suitable for logs and debug output.
    public var description: String {
        switch self {
        case .christian: return "Christian Era (CE)"
        case .buddhist:  return "Buddhist Era (BE)"
        }
    }
}
