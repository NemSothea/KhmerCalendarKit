import Foundation

/// Converts between Arabic (Western) digits `0-9` and Khmer digits `០-៩`.
///
/// All operations are pure and stateless. The converter operates on individual
/// `Character` values, so it is safe to feed it strings that mix Khmer text,
/// digits, and arbitrary Unicode — only the digit characters are transformed,
/// everything else is preserved verbatim.
public enum KhmerNumeralConverter {

    /// The ten Khmer digit characters, indexed `0` (`០`) through `9` (`៩`).
    public static let digits: [Character] = [
        "០", "១", "២", "៣", "៤",
        "៥", "៦", "៧", "៨", "៩",
    ]

    /// Reverse lookup table from Khmer digit to its `Character` form (`"0"`...`"9"`).
    private static let arabicByKhmer: [Character: Character] = {
        var map: [Character: Character] = [:]
        map.reserveCapacity(digits.count)
        for (index, digit) in digits.enumerated() {
            map[digit] = Character(String(index))
        }
        return map
    }()

    // MARK: - Integer → Khmer

    /// Returns the Khmer-numeral representation of an integer.
    ///
    /// - Parameter value: Any `Int`. Negative values are prefixed with `"-"`.
    /// - Returns: A Khmer-digit string, e.g. `2026 → "២០២៦"`.
    public static func khmerNumerals(from value: Int) -> String {
        if value == 0 { return String(digits[0]) }
        let isNegative = value < 0
        // `value.magnitude` is `UInt`, which lets us safely handle `Int.min`.
        var remaining = value.magnitude
        var reversed = ""
        while remaining > 0 {
            reversed.append(digits[Int(remaining % 10)])
            remaining /= 10
        }
        return (isNegative ? "-" : "") + String(reversed.reversed())
    }

    // MARK: - String transforms

    /// Replaces every Arabic digit (`0-9`) inside `string` with its Khmer
    /// counterpart. Non-digit characters are preserved unchanged.
    ///
    /// - Parameter string: Any string, possibly containing Arabic digits.
    /// - Returns: The transformed string.
    public static func toKhmerNumerals(_ string: String) -> String {
        var result = ""
        result.reserveCapacity(string.count)
        for character in string {
            if let asciiValue = character.asciiValue,
               asciiValue >= 0x30, asciiValue <= 0x39 {
                result.append(digits[Int(asciiValue - 0x30)])
            } else {
                result.append(character)
            }
        }
        return result
    }

    /// Replaces every Khmer digit (`០-៩`) inside `string` with its Arabic
    /// counterpart. Non-digit characters are preserved unchanged.
    ///
    /// - Parameter string: Any string, possibly containing Khmer digits.
    /// - Returns: The transformed string.
    public static func toArabicNumerals(_ string: String) -> String {
        var result = ""
        result.reserveCapacity(string.count)
        for character in string {
            if let arabic = arabicByKhmer[character] {
                result.append(arabic)
            } else {
                result.append(character)
            }
        }
        return result
    }
}
