import SwiftUI

/// A full-featured Khmer date/time picker combining a month-grid calendar
/// with optional hour/minute scroll wheels.
///
/// ```swift
/// @State private var date   = Date()
/// @State private var locale: KhmerLocale = .khmer
///
/// KhmerDatePickerView(selection: $date, locale: locale)
///
/// // Time only:
/// KhmerDatePickerView(selection: $date, mode: .time, locale: locale)
///
/// // Date + time with seconds:
/// KhmerDatePickerView(selection: $date, mode: .dateAndTime,
///                     locale: locale, showsSeconds: true)
/// ```
public struct KhmerDatePickerView: View {

    @Binding private var selection: Date
    private let mode: KhmerDatePickerMode
    private let locale: KhmerLocale
    private let firstWeekday: Int
    private let showsSeconds: Bool

    // Local state for the time wheels
    @State private var hour: Int
    @State private var minute: Int
    @State private var second: Int

    // MARK: - Init

    /// Creates a Khmer date/time picker.
    ///
    /// - Parameters:
    ///   - selection: Binding to the selected date.
    ///   - mode: Which components to display. Defaults to `.date`.
    ///   - locale: Display language. Defaults to `.khmer`.
    ///   - firstWeekday: `1` = Sunday, `2` = Monday. Defaults to `1`.
    ///   - showsSeconds: Whether to include a seconds wheel in time mode.
    ///     Defaults to `false`.
    public init(
        selection: Binding<Date>,
        mode: KhmerDatePickerMode = .date,
        locale: KhmerLocale = .khmer,
        firstWeekday: Int = 1,
        showsSeconds: Bool = false
    ) {
        self._selection = selection
        self.mode = mode
        self.locale = locale
        self.firstWeekday = firstWeekday
        self.showsSeconds = showsSeconds

        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: selection.wrappedValue)
        self._hour   = State(initialValue: components.hour   ?? 0)
        self._minute = State(initialValue: components.minute ?? 0)
        self._second = State(initialValue: components.second ?? 0)
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 12) {
            if mode == .date || mode == .dateAndTime {
                KhmerCalendarView(
                    selection: $selection,
                    locale: locale,
                    firstWeekday: firstWeekday
                )
            }

            if mode == .time || mode == .dateAndTime {
                timePicker
            }
        }
    }

    // MARK: - Time picker

    private var timePicker: some View {
        HStack(spacing: 0) {
            wheelPicker(
                values: 0..<24,
                selection: $hour,
                label: timeLabel("ម៉ោង", english: "Hr"),
                onChange: applyTime
            )

            Text(":")
                .font(.title2.bold())
                .padding(.top, 8)

            wheelPicker(
                values: 0..<60,
                selection: $minute,
                label: timeLabel("នាទី", english: "Min"),
                onChange: applyTime
            )

            if showsSeconds {
                Text(":")
                    .font(.title2.bold())
                    .padding(.top, 8)

                wheelPicker(
                    values: 0..<60,
                    selection: $second,
                    label: timeLabel("វិនាទី", english: "Sec"),
                    onChange: applyTime
                )
            }
        }
        .frame(height: 160)
        .padding(.horizontal)
    }

    private func wheelPicker(
        values: Range<Int>,
        selection: Binding<Int>,
        label: String,
        onChange: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)

            Picker("", selection: selection) {
                ForEach(values, id: \.self) { value in
                    Text(rowLabel(value))
                        .tag(value)
                }
            }
            #if os(iOS) || os(tvOS) || os(watchOS)
            .pickerStyle(WheelPickerStyle())
            #else
            .pickerStyle(DefaultPickerStyle())
            #endif
            .frame(width: 64)
            .clipped()
            .onChange(of: selection.wrappedValue) { _ in onChange() }
        }
    }

    private func timeLabel(_ khmer: String, english: String) -> String {
        locale == .khmer ? khmer : english
    }

    private func rowLabel(_ value: Int) -> String {
        switch locale {
        case .khmer:   return KhmerNumeralConverter.khmerNumerals(from: value)
        case .english: return String(format: "%02d", value)
        }
    }

    private func applyTime() {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = .current
        var comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: selection)
        comps.hour   = hour
        comps.minute = minute
        comps.second = showsSeconds ? second : 0
        if let updated = cal.date(from: comps) {
            selection = updated
        }
    }
}
