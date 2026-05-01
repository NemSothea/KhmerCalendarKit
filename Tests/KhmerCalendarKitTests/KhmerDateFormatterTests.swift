import XCTest
@testable import KhmerCalendarKit

final class KhmerDateFormatterTests: XCTestCase {

    private let utc = TimeZone(identifier: "UTC")!

    /// Builds a fixed Gregorian `Date` in the given time zone, anchored at noon
    /// to keep test results stable regardless of DST or local-zone shifts.
    private func date(year: Int, month: Int, day: Int, in zone: TimeZone) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = zone
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        return calendar.date(from: components)!
    }

    // MARK: - Default format

    /// 2026-01-15 is a Thursday (ព្រហស្បតិ៍).
    func test_defaultFormat_january15_2026() {
        let formatter = KhmerDateFormatter(format: .default, timeZone: utc)
        let result = formatter.string(from: date(year: 2026, month: 1, day: 15, in: utc))
        XCTAssertEqual(result, "ថ្ងៃព្រហស្បតិ៍ ទី១៥ ខែមករា ឆ្នាំ២០២៦")
    }

    func test_defaultFormat_singleDigitDay() {
        let formatter = KhmerDateFormatter(format: .default, timeZone: utc)
        let result = formatter.string(from: date(year: 2026, month: 3, day: 5, in: utc))
        XCTAssertTrue(result.contains("ទី៥"), "Expected ទី៥, got \(result)")
        XCTAssertTrue(result.contains("ខែមីនា"), "Expected ខែមីនា, got \(result)")
    }

    // MARK: - Buddhist Era

    func test_buddhistEra_addsFiveHundredFortyThreeYears() {
        let formatter = KhmerDateFormatter(format: .buddhist, timeZone: utc)
        let result = formatter.string(from: date(year: 2026, month: 1, day: 15, in: utc))
        XCTAssertEqual(result, "ថ្ងៃព្រហស្បតិ៍ ទី១៥ ខែមករា ឆ្នាំ២៥៦៩")
    }

    func test_buddhistEra_yearOffset() {
        XCTAssertEqual(KhmerEra.buddhist.yearOffset, 543)
        XCTAssertEqual(KhmerEra.christian.yearOffset, 0)
        XCTAssertEqual(KhmerEra.buddhist.year(fromGregorian: 2026), 2569)
        XCTAssertEqual(KhmerEra.christian.year(fromGregorian: 2026), 2026)
    }

    // MARK: - Preset formats

    func test_dateOnlyFormat_omitsWeekday() {
        let formatter = KhmerDateFormatter(format: .dateOnly, timeZone: utc)
        let result = formatter.string(from: date(year: 2026, month: 1, day: 15, in: utc))
        XCTAssertEqual(result, "ទី១៥ ខែមករា ឆ្នាំ២០២៦")
    }

    func test_monthYearFormat_omitsWeekdayAndDay() {
        let formatter = KhmerDateFormatter(format: .monthYear, timeZone: utc)
        let result = formatter.string(from: date(year: 2026, month: 1, day: 15, in: utc))
        XCTAssertEqual(result, "ខែមករា ឆ្នាំ២០២៦")
    }

    // MARK: - Custom configuration

    func test_customSeparator() {
        var format = KhmerDateFormat.dateOnly
        format.separator = ", "
        let formatter = KhmerDateFormatter(format: format, timeZone: utc)
        let result = formatter.string(from: date(year: 2026, month: 1, day: 15, in: utc))
        XCTAssertEqual(result, "ទី១៥, ខែមករា, ឆ្នាំ២០២៦")
    }

    func test_disablingAllSegments_returnsEmptyString() {
        let format = KhmerDateFormat(
            includesWeekday: false,
            includesDay: false,
            includesMonth: false,
            includesYear: false
        )
        let formatter = KhmerDateFormatter(format: format, timeZone: utc)
        let result = formatter.string(from: date(year: 2026, month: 1, day: 15, in: utc))
        XCTAssertEqual(result, "")
    }

    // MARK: - Edge cases

    func test_leapDay_february29() {
        // 2024 is a leap year; Feb 29 must round-trip without error.
        let formatter = KhmerDateFormatter(format: .dateOnly, timeZone: utc)
        let result = formatter.string(from: date(year: 2024, month: 2, day: 29, in: utc))
        XCTAssertEqual(result, "ទី២៩ ខែកុម្ភៈ ឆ្នាំ២០២៤")
    }

    func test_endOfYear_december31() {
        let formatter = KhmerDateFormatter(format: .dateOnly, timeZone: utc)
        let result = formatter.string(from: date(year: 2025, month: 12, day: 31, in: utc))
        XCTAssertEqual(result, "ទី៣១ ខែធ្នូ ឆ្នាំ២០២៥")
    }

    func test_allTwelveMonths_renderUniqueNames() {
        let formatter = KhmerDateFormatter(format: .monthYear, timeZone: utc)
        var seen = Set<String>()
        for month in 1...12 {
            let text = formatter.string(from: date(year: 2026, month: month, day: 1, in: utc))
            seen.insert(text)
        }
        XCTAssertEqual(seen.count, 12, "Each month should produce a distinct string")
    }

    func test_timeZoneAffectsExtractedDay() {
        // 2026-01-15 23:30 UTC is 2026-01-16 in Tokyo (UTC+9).
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = utc
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 15
        components.hour = 23
        components.minute = 30
        let instant = calendar.date(from: components)!

        let utcResult = KhmerDateFormatter(format: .dateOnly, timeZone: utc).string(from: instant)
        let tokyoResult = KhmerDateFormatter(
            format: .dateOnly,
            timeZone: TimeZone(identifier: "Asia/Tokyo")!
        ).string(from: instant)

        XCTAssertTrue(utcResult.contains("ទី១៥"))
        XCTAssertTrue(tokyoResult.contains("ទី១៦"))
    }

    // MARK: - Static convenience

    func test_staticString_fromDate_returnsNonEmpty() {
        XCTAssertFalse(KhmerDateFormatter.string(from: Date()).isEmpty)
    }

    func test_staticString_withFormat_appliesFormat() {
        let result = KhmerDateFormatter.string(
            from: date(year: 2026, month: 1, day: 15, in: utc),
            format: KhmerDateFormat(
                includesWeekday: false,
                includesDay: false,
                includesMonth: false,
                includesYear: true,
                era: .buddhist
            )
        )
        // Year-only Buddhist format. Time-zone difference between UTC fixture
        // and the user's current zone can shift the calendar day, but the
        // year stays at 2026 → 2569 BE for any reasonable zone.
        XCTAssertEqual(result, "ឆ្នាំ២៥៦៩")
    }

    // MARK: - Custom labels

    func test_customLabels_strippedPrefixes() {
        var format = KhmerDateFormat.default
        format.labels = .none
        let formatter = KhmerDateFormatter(format: format, timeZone: utc)
        let result = formatter.string(from: date(year: 2026, month: 1, day: 15, in: utc))
        XCTAssertEqual(result, "ព្រហស្បតិ៍ ១៥ មករា ២០២៦")
    }

    func test_customLabels_overrideSinglePrefix() {
        var labels = KhmerDateLabels.default
        labels.dayPrefix = ""  // drop "ទី" but keep the others
        let format = KhmerDateFormat(
            includesWeekday: false,
            labels: labels
        )
        let formatter = KhmerDateFormatter(format: format, timeZone: utc)
        let result = formatter.string(from: date(year: 2026, month: 1, day: 15, in: utc))
        XCTAssertEqual(result, "១៥ ខែមករា ឆ្នាំ២០២៦")
    }

    // MARK: - Era description

    func test_eraDescription_isHumanReadable() {
        XCTAssertEqual(String(describing: KhmerEra.christian), "Christian Era (CE)")
        XCTAssertEqual(String(describing: KhmerEra.buddhist),  "Buddhist Era (BE)")
    }

    // MARK: - Date extension

    func test_dateExtension_khmerString_default() {
        let result = date(year: 2026, month: 1, day: 15, in: utc)
            .khmerString(format: .default, timeZone: utc)
        XCTAssertEqual(result, "ថ្ងៃព្រហស្បតិ៍ ទី១៥ ខែមករា ឆ្នាំ២០២៦")
    }

    func test_dateExtension_khmerString_buddhist() {
        let result = date(year: 2026, month: 1, day: 15, in: utc)
            .khmerString(format: .buddhist, timeZone: utc)
        XCTAssertEqual(result, "ថ្ងៃព្រហស្បតិ៍ ទី១៥ ខែមករា ឆ្នាំ២៥៦៩")
    }
}
