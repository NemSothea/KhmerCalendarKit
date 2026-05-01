import XCTest
@testable import KhmerCalendarKit

final class KhmerLunarCalendarTests: XCTestCase {

    // MARK: - Julian Day Number

    func test_julianDay_knownDate() {
        // J2000.0: January 1.5, 2000 = JD 2451545.0
        let jd = KhmerLunarCalendar.gregorianToJD(year: 2000, month: 1, day: 1)
        // Noon Jan 1, 2000 = JD 2451545.0
        XCTAssertEqual(jd, 2451545.0, accuracy: 0.5)
    }

    // MARK: - Reference date smoke test

    func test_referenceDate_boss2566() {
        // Jan 11, 2024 is in Khmer lunar month បុស្ស (index 9 = .boss)
        let lunar = KhmerLunarCalendar.convert(year: 2024, month: 1, day: 11)
        XCTAssertEqual(lunar.lunarMonth, .boss)
    }

    // MARK: - Phase

    func test_phaseAndDay_earlyInMonth() {
        // Jan 11, 2024 is day 1 of lunar month (reference new moon)
        let lunar = KhmerLunarCalendar.convert(year: 2024, month: 1, day: 11)
        XCTAssertEqual(lunar.phase, .kert)
        XCTAssertGreaterThanOrEqual(lunar.lunarDay, 1)
    }

    func test_phaseAndDay_midMonth() {
        // Jan 25 2024 is ~full moon (day 15 kert); Jan 27 is clearly waning
        let lunar = KhmerLunarCalendar.convert(year: 2024, month: 1, day: 27)
        XCTAssertEqual(lunar.phase, .roch)
    }

    func test_lunarDayRange_kert() {
        for offset in 0..<15 {
            var cal = Calendar(identifier: .gregorian)
            cal.timeZone = TimeZone(identifier: "UTC")!
            let date = cal.date(from: DateComponents(year: 2024, month: 1, day: 11 + offset))!
            let lunar = KhmerLunarCalendar.lunarDate(from: date, timeZone: TimeZone(identifier: "UTC")!)
            if lunar.phase == .kert {
                XCTAssertTrue((1...15).contains(lunar.lunarDay), "kert day \(lunar.lunarDay) out of range")
            }
        }
    }

    func test_lunarDayRange_roch() {
        for offset in 15..<30 {
            var cal = Calendar(identifier: .gregorian)
            cal.timeZone = TimeZone(identifier: "UTC")!
            let date = cal.date(from: DateComponents(year: 2024, month: 1, day: 11 + offset))!
            let lunar = KhmerLunarCalendar.lunarDate(from: date, timeZone: TimeZone(identifier: "UTC")!)
            if lunar.phase == .roch {
                XCTAssertTrue((1...15).contains(lunar.lunarDay), "roch day \(lunar.lunarDay) out of range")
            }
        }
    }

    // MARK: - Buddhist year

    func test_buddhistYear_afterKhmerNewYear() {
        // May 2026 → after April 13 → BE = 2026 + 543 = 2569
        let lunar = KhmerLunarCalendar.convert(year: 2026, month: 5, day: 1)
        XCTAssertEqual(lunar.buddhistYear, 2569)
    }

    func test_buddhistYear_beforeKhmerNewYear() {
        // January 2026 → before April 13 → BE = 2026 + 542 = 2568
        let lunar = KhmerLunarCalendar.convert(year: 2026, month: 1, day: 1)
        XCTAssertEqual(lunar.buddhistYear, 2568)
    }

    // MARK: - Zodiac

    func test_zodiac_2563_isRat() {
        // BE 2563 (after Apr 13, 2020) = ជូត (Rat)
        let lunar = KhmerLunarCalendar.convert(year: 2020, month: 5, day: 1)
        XCTAssertEqual(lunar.zodiacYear, .jut)
    }

    func test_zodiac_2569_isHorse() {
        // BE 2569 (after Apr 13, 2026) = មមីរ (Horse)
        let lunar = KhmerLunarCalendar.convert(year: 2026, month: 5, day: 1)
        XCTAssertEqual(lunar.zodiacYear, .mameir)
    }

    func test_zodiac_cycle_is12() {
        // Every 12 BE years returns to the same zodiac
        let base = KhmerLunarCalendar.convert(year: 2020, month: 5, day: 1)
        let plus12 = KhmerLunarCalendar.convert(year: 2032, month: 5, day: 1)
        XCTAssertEqual(base.zodiacYear, plus12.zodiacYear)
    }

    // MARK: - Formatted strings

    func test_lunarDayString_kert() {
        let lunar = KhmerLunarCalendar.convert(year: 2024, month: 1, day: 11)
        XCTAssertTrue(lunar.lunarDayString.hasSuffix("កើត"), "Expected suffix កើត, got \(lunar.lunarDayString)")
    }

    func test_lunarDayString_roch() {
        let lunar = KhmerLunarCalendar.convert(year: 2024, month: 1, day: 26)
        XCTAssertTrue(lunar.lunarDayString.hasSuffix("រោច"), "Expected suffix រោច, got \(lunar.lunarDayString)")
    }

    func test_khmerDescription_containsComponents() {
        let lunar = KhmerLunarCalendar.convert(year: 2024, month: 1, day: 11)
        let desc = lunar.khmerDescription(locale: .khmer)
        XCTAssertTrue(desc.contains("ខែ"),   "Missing ខែ in: \(desc)")
        XCTAssertTrue(desc.contains("ឆ្នាំ"), "Missing ឆ្នាំ in: \(desc)")
    }

    func test_englishDescription() {
        let lunar = KhmerLunarCalendar.convert(year: 2024, month: 1, day: 11)
        let desc = lunar.khmerDescription(locale: .english)
        XCTAssertTrue(desc.contains("BE"), "Missing BE in: \(desc)")
        XCTAssertTrue(desc.contains("Waxing") || desc.contains("Waning"))
    }

    // MARK: - Month cycle

    func test_monthCycle_chetr_aroundApril2024() {
        // New moon ~April 8, 2024 starts ចេត្រ 2567
        let lunar = KhmerLunarCalendar.convert(year: 2024, month: 4, day: 9)
        XCTAssertEqual(lunar.lunarMonth, .chetr)
    }

    func test_monthCycle_wrapsAt12() {
        // All 12 months are returned across a calendar year
        var months = Set<KhmerLunarMonth>()
        for month in 1...12 {
            for day in [1, 15] {
                let lunar = KhmerLunarCalendar.convert(year: 2024, month: month, day: day)
                months.insert(lunar.lunarMonth)
            }
        }
        XCTAssertGreaterThanOrEqual(months.count, 10, "Expected most of the 12 Khmer months to appear")
    }

    // MARK: - Date extension

    func test_dateExtension_toKhmerLunar() {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        let date = cal.date(from: DateComponents(year: 2024, month: 1, day: 11))!
        let lunar = date.toKhmerLunar(timeZone: TimeZone(identifier: "UTC")!)
        XCTAssertEqual(lunar.lunarMonth, .boss)
    }
}
