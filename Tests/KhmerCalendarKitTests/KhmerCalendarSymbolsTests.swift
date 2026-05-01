import XCTest
@testable import KhmerCalendarKit

final class KhmerCalendarSymbolsTests: XCTestCase {

    // MARK: - Months

    func test_monthNames_hasTwelveEntries() {
        XCTAssertEqual(KhmerCalendarSymbols.monthNames.count, 12)
    }

    func test_monthName_january() {
        XCTAssertEqual(KhmerCalendarSymbols.monthName(forMonth: 1), "មករា")
    }

    func test_monthName_december() {
        XCTAssertEqual(KhmerCalendarSymbols.monthName(forMonth: 12), "ធ្នូ")
    }

    func test_monthName_outOfRange_returnsNil() {
        XCTAssertNil(KhmerCalendarSymbols.monthName(forMonth: 0))
        XCTAssertNil(KhmerCalendarSymbols.monthName(forMonth: 13))
        XCTAssertNil(KhmerCalendarSymbols.monthName(forMonth: -1))
    }

    func test_monthName_allTwelve_match() {
        let expected = [
            "មករា", "កុម្ភៈ", "មីនា", "មេសា",
            "ឧសភា", "មិថុនា", "កក្កដា", "សីហា",
            "កញ្ញា", "តុលា", "វិច្ឆិកា", "ធ្នូ",
        ]
        for index in 1...12 {
            XCTAssertEqual(
                KhmerCalendarSymbols.monthName(forMonth: index),
                expected[index - 1],
                "Month \(index) mismatch"
            )
        }
    }

    // MARK: - Weekdays

    func test_weekdayNames_hasSevenEntries() {
        XCTAssertEqual(KhmerCalendarSymbols.weekdayNames.count, 7)
    }

    func test_weekdayName_sunday() {
        XCTAssertEqual(KhmerCalendarSymbols.weekdayName(forWeekday: 1), "អាទិត្យ")
    }

    func test_weekdayName_saturday() {
        XCTAssertEqual(KhmerCalendarSymbols.weekdayName(forWeekday: 7), "សៅរ៍")
    }

    func test_weekdayName_outOfRange_returnsNil() {
        XCTAssertNil(KhmerCalendarSymbols.weekdayName(forWeekday: 0))
        XCTAssertNil(KhmerCalendarSymbols.weekdayName(forWeekday: 8))
        XCTAssertNil(KhmerCalendarSymbols.weekdayName(forWeekday: -1))
    }

    func test_weekdayName_allSeven_match() {
        let expected = [
            "អាទិត្យ", "ច័ន្ទ", "អង្គារ", "ពុធ",
            "ព្រហស្បតិ៍", "សុក្រ", "សៅរ៍",
        ]
        for index in 1...7 {
            XCTAssertEqual(
                KhmerCalendarSymbols.weekdayName(forWeekday: index),
                expected[index - 1],
                "Weekday \(index) mismatch"
            )
        }
    }
}
