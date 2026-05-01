import SwiftUI
import KhmerCalendarKit

struct SettingsView: View {
    @AppStorage("locale")      private var localeRaw:      Int = 0
    @AppStorage("era")         private var eraRaw:         Int = 0
    @AppStorage("firstWeekday") private var firstWeekday:  Int = 1

    private var era: KhmerEra { eraRaw == 1 ? .buddhist : .christian }

    var body: some View {
        NavigationView {
            Form {
                Section("Display Language") {
                    Picker("Language", selection: $localeRaw) {
                        Text("ខ្មែរ  (Khmer)").tag(0)
                        Text("English").tag(1)
                    }
                    .pickerStyle(.segmented)
                }

                Section("Year Era") {
                    Picker("Era", selection: $eraRaw) {
                        Text("CE  (គ.ស.)").tag(0)
                        Text("BE  (ព.ស.)").tag(1)
                    }
                    .pickerStyle(.segmented)
                }

                Section("First Day of Week") {
                    Picker("First Weekday", selection: $firstWeekday) {
                        Text("Sunday").tag(1)
                        Text("Monday").tag(2)
                    }
                    .pickerStyle(.segmented)
                }

                Section("Khmer Numerals  ០–៩") {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible()), count: 5),
                        spacing: 14
                    ) {
                        ForEach(0..<10, id: \.self) { digit in
                            VStack(spacing: 2) {
                                Text(KhmerNumeralConverter.khmerNumerals(from: digit))
                                    .font(.title2.bold())
                                    .foregroundColor(.accentColor)
                                Text("\(digit)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section("Today's Date Preview") {
                    Text(Date().khmerString(format: KhmerDateFormat(era: era)))
                        .font(.body)
                        .foregroundColor(.accentColor)
                        .textSelection(.enabled)
                }

                Section("About") {
                    LabeledContent("Package", value: "KhmerCalendarKit")
                    LabeledContent("Version", value: KhmerCalendarKit.version)
                    LabeledContent("Swift",   value: "5.9")
                    LabeledContent("iOS",     value: "16.0+")
                }
            }
            .navigationTitle("Settings")
        }
    }
}
