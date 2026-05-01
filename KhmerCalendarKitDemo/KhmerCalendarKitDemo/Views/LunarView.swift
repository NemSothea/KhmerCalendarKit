import SwiftUI
import KhmerCalendarKit

struct LunarView: View {
    @State private var lookupDate = Date()

    private var lunar: KhmerLunarDate { lookupDate.toKhmerLunar() }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    heroCard
                    datePicker
                    detailCard
                    zodiacGrid
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Lunar Calendar")
        }
    }

    private var heroCard: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.18, green: 0.09, blue: 0.48),
                    Color(red: 0.38, green: 0.08, blue: 0.58)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(spacing: 10) {
                Text(lunar.khmerDescription())
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text(lunar.khmerDescription(locale: .english))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.75))
                    .multilineTextAlignment(.center)
            }
            .padding(24)
        }
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.35), radius: 12, y: 4)
        .padding(.horizontal)
    }

    private var datePicker: some View {
        HStack {
            Text("Look up date")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            DatePicker("", selection: $lookupDate, displayedComponents: .date)
                .labelsHidden()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.07), radius: 8, y: 2)
        .padding(.horizontal)
    }

    private var detailCard: some View {
        VStack(spacing: 0) {
            LunarDetailRow(label: "ថ្ងៃ  Day",          value: lunar.lunarDayString)
            Divider().padding(.leading)
            LunarDetailRow(label: "ព្រះច័ន្ទ  Phase",    value: "\(lunar.phase.khmerName) · \(lunar.phase.englishName)")
            Divider().padding(.leading)
            LunarDetailRow(label: "ខែ  Month",           value: "\(lunar.lunarMonth.khmerName) · \(lunar.lunarMonth.englishName)")
            Divider().padding(.leading)
            LunarDetailRow(
                label: "ឆ្នាំ  Buddhist Era",
                value: "\(KhmerNumeralConverter.khmerNumerals(from: lunar.buddhistYear))  (\(lunar.buddhistYear) BE)"
            )
            Divider().padding(.leading)
            LunarDetailRow(label: "សត្វ  Zodiac",        value: "\(lunar.zodiacYear.khmerName) · \(lunar.zodiacYear.englishName)")
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 8, y: 2)
        .padding(.horizontal)
    }

    private var zodiacGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("12-Year Zodiac Cycle")
                .font(.headline)
                .padding(.horizontal)

            Text("Tap an animal to jump to that year")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                ForEach(KhmerZodiacYear.allCases, id: \.rawValue) { zodiac in
                    let active = zodiac == lunar.zodiacYear
                    Button { jumpToZodiac(zodiac) } label: {
                        VStack(spacing: 4) {
                            Text(zodiacEmoji(zodiac))
                                .font(.title2)
                            Text(zodiac.khmerName)
                                .font(.caption.bold())
                                .foregroundColor(active ? .accentColor : .primary)
                            Text(zodiac.englishName)
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(active ? Color.accentColor.opacity(0.12) : Color(.systemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(active ? Color.accentColor : Color(.separator), lineWidth: active ? 1.5 : 0.5)
                        )
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }

    private func jumpToZodiac(_ zodiac: KhmerZodiacYear) {
        let currentIndex = lunar.zodiacYear.rawValue
        let targetIndex  = zodiac.rawValue
        let yearsAhead   = (targetIndex - currentIndex + 12) % 12
        if yearsAhead == 0 { return }
        if let newDate = Calendar.current.date(byAdding: .year, value: yearsAhead, to: lookupDate) {
            lookupDate = newDate
        }
    }

    private func zodiacEmoji(_ z: KhmerZodiacYear) -> String {
        switch z {
        case .jut:     return "🐭"
        case .chhlauv: return "🐮"
        case .khal:    return "🐯"
        case .thos:    return "🐰"
        case .rong:    return "🐲"
        case .masanh:  return "🐍"
        case .mameir:  return "🐴"
        case .mamae:   return "🐐"
        case .vak:     return "🐒"
        case .roka:    return "🐓"
        case .chuv:    return "🐶"
        case .kor:     return "🐷"
        }
    }
}

private struct LunarDetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.medium))
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}
