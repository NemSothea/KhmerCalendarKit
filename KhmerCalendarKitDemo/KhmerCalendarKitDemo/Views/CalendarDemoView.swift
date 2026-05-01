import SwiftUI
import KhmerCalendarKit

struct CalendarDemoView: View {
    @State private var selectedDate = Date()
    @AppStorage("locale")       private var localeRaw:    Int = 0
    @AppStorage("firstWeekday") private var firstWeekday: Int = 1

    private var locale: KhmerLocale { localeRaw == 1 ? .english : .khmer }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Language", selection: $localeRaw) {
                        Text("ខ្មែរ").tag(0)
                        Text("English").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    KhmerCalendarView(
                        selection: $selectedDate,
                        locale: locale,
                        firstWeekday: firstWeekday
                    )
                    // Recreate when locale or firstWeekday changes so the
                    // internal ObservedObject ViewModel is re-initialized.
                    .id("\(localeRaw)-\(firstWeekday)")
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.07), radius: 8, y: 2)
                    .padding(.horizontal)

                    VStack(spacing: 6) {
                        Text(selectedDate.khmerString(format: .dateOnly))
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        Text(selectedDate.khmerString(format: .buddhist))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.07), radius: 8, y: 2)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Calendar")
        }
    }
}
