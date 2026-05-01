import SwiftUI
import KhmerCalendarKit

struct DatePickerDemoView: View {
    @State private var selectedDate = Date()
    @State private var modeIndex    = 0
    @AppStorage("locale")       private var localeRaw:    Int = 0
    @AppStorage("firstWeekday") private var firstWeekday: Int = 1

    private var locale: KhmerLocale { localeRaw == 1 ? .english : .khmer }

    private var mode: KhmerDatePickerMode {
        switch modeIndex {
        case 1:  return .time
        case 2:  return .dateAndTime
        default: return .date
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Mode", selection: $modeIndex) {
                        Text("Date").tag(0)
                        Text("Time").tag(1)
                        Text("Date & Time").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    KhmerDatePickerView(
                        selection: $selectedDate,
                        mode: mode,
                        locale: locale,
                        firstWeekday: firstWeekday
                    )
                    // Recreate when locale, firstWeekday, or mode changes so the
                    // internal ObservedObject ViewModel is re-initialized.
                    .id("\(localeRaw)-\(firstWeekday)-\(modeIndex)")
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.07), radius: 8, y: 2)
                    .padding(.horizontal)

                    selectionCard
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Date Picker")
        }
    }

    private var selectionCard: some View {
        VStack(spacing: 8) {
            if mode == .date || mode == .dateAndTime {
                Text(selectedDate.khmerString())
                    .font(.headline)
                    .foregroundColor(.accentColor)
                    .multilineTextAlignment(.center)
            }
            if mode == .time || mode == .dateAndTime {
                let comps = Calendar.current.dateComponents([.hour, .minute], from: selectedDate)
                let h = KhmerNumeralConverter.khmerNumerals(from: comps.hour ?? 0)
                let m = KhmerNumeralConverter.khmerNumerals(from: comps.minute ?? 0)
                Text("ម៉ោង \(h)  នាទី \(m)")
                    .font(.title3.bold())
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.07), radius: 8, y: 2)
        .padding(.horizontal)
    }
}
