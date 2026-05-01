import SwiftUI
import KhmerCalendarKit

struct FormatterView: View {
    @State private var date = Date()
    @State private var includesWeekday = true
    @State private var includesDay     = true
    @State private var includesMonth   = true
    @State private var includesYear    = true
    @AppStorage("era") private var eraRaw: Int = 0

    private var era: KhmerEra { eraRaw == 1 ? .buddhist : .christian }

    private var format: KhmerDateFormat {
        KhmerDateFormat(
            includesWeekday: includesWeekday,
            includesDay:     includesDay,
            includesMonth:   includesMonth,
            includesYear:    includesYear,
            era:             era
        )
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Date") {
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }

                Section("Segments") {
                    Toggle("Weekday · ថ្ងៃ",  isOn: $includesWeekday)
                    Toggle("Day · ទី",         isOn: $includesDay)
                    Toggle("Month · ខែ",       isOn: $includesMonth)
                    Toggle("Year · ឆ្នាំ",     isOn: $includesYear)
                }

                Section("Era") {
                    Picker("Era", selection: $eraRaw) {
                        Text("CE  (គ.ស.)").tag(0)
                        Text("BE  (ព.ស.)").tag(1)
                    }
                    .pickerStyle(.segmented)
                }

                Section("Output") {
                    let result = date.khmerString(format: format)
                    Text(result.isEmpty ? "—" : result)
                        .font(.body)
                        .foregroundColor(.accentColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textSelection(.enabled)
                }

                Section("Code") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(codeSnippet)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
                            .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Formatter")
        }
    }

    private var codeSnippet: String {
        let eraStr = eraRaw == 1 ? ".buddhist" : ".christian"
        return
            "date.khmerString(format:\n" +
            "  KhmerDateFormat(\n" +
            "    includesWeekday: \(includesWeekday),\n" +
            "    includesDay: \(includesDay),\n" +
            "    includesMonth: \(includesMonth),\n" +
            "    includesYear: \(includesYear),\n" +
            "    era: \(eraStr)\n" +
            "  )\n" +
            ")"
    }
}
