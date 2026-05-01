import XCTest
@testable import KhmerCalendarKit

final class KhmerNumeralConverterTests: XCTestCase {

    // MARK: - Integer → Khmer

    func test_khmerNumerals_zero() {
        XCTAssertEqual(KhmerNumeralConverter.khmerNumerals(from: 0), "០")
    }

    func test_khmerNumerals_singleDigit() {
        XCTAssertEqual(KhmerNumeralConverter.khmerNumerals(from: 7), "៧")
    }

    func test_khmerNumerals_multipleDigits() {
        XCTAssertEqual(KhmerNumeralConverter.khmerNumerals(from: 2026), "២០២៦")
    }

    func test_khmerNumerals_largeNumber() {
        XCTAssertEqual(KhmerNumeralConverter.khmerNumerals(from: 1234567890), "១២៣៤៥៦៧៨៩០")
    }

    func test_khmerNumerals_negativeNumber() {
        XCTAssertEqual(KhmerNumeralConverter.khmerNumerals(from: -15), "-១៥")
    }

    func test_khmerNumerals_intMin_doesNotOverflow() {
        // `Int.min`'s magnitude can't be represented as a positive Int. The
        // implementation uses `UInt` magnitude to avoid the trap.
        let result = KhmerNumeralConverter.khmerNumerals(from: .min)
        XCTAssertTrue(result.hasPrefix("-"))
        XCTAssertFalse(result.dropFirst().isEmpty)
    }

    // MARK: - String transforms

    func test_toKhmerNumerals_replacesDigitsOnly() {
        XCTAssertEqual(
            KhmerNumeralConverter.toKhmerNumerals("Year 2026"),
            "Year ២០២៦"
        )
    }

    func test_toKhmerNumerals_preservesNonDigits() {
        XCTAssertEqual(
            KhmerNumeralConverter.toKhmerNumerals("abc!@#"),
            "abc!@#"
        )
    }

    func test_toKhmerNumerals_emptyString() {
        XCTAssertEqual(KhmerNumeralConverter.toKhmerNumerals(""), "")
    }

    func test_toArabicNumerals_replacesKhmerDigits() {
        XCTAssertEqual(
            KhmerNumeralConverter.toArabicNumerals("ឆ្នាំ២០២៦"),
            "ឆ្នាំ2026"
        )
    }

    func test_toArabicNumerals_preservesNonDigits() {
        XCTAssertEqual(
            KhmerNumeralConverter.toArabicNumerals("មករា"),
            "មករា"
        )
    }

    func test_roundTrip_arabicToKhmerToArabic() {
        let original = "Date: 2026-01-15, ID #42"
        let khmer = KhmerNumeralConverter.toKhmerNumerals(original)
        let back = KhmerNumeralConverter.toArabicNumerals(khmer)
        XCTAssertEqual(back, original)
    }

    func test_digitsArray_hasTenEntries() {
        XCTAssertEqual(KhmerNumeralConverter.digits.count, 10)
    }
}
