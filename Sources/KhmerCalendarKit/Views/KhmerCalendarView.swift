import SwiftUI

/// A SwiftUI month-grid calendar with full Khmer localization.
///
/// Renders the days of a month in a 7-column grid. The header row shows
/// weekday abbreviations; tapping a cell selects that date and updates the
/// `selection` binding.
///
/// ```swift
/// @State private var date = Date()
/// @State private var locale: KhmerLocale = .khmer
///
/// KhmerCalendarView(selection: $date, locale: locale)
/// ```
///
/// The view is iOS 13-compatible: it uses `HStack`/`VStack` instead of
/// `LazyVGrid` (iOS 14+).
public struct KhmerCalendarView: View {

    @Binding private var selection: Date
    @ObservedObject private var viewModel: KhmerCalendarViewModel

    // MARK: - Init

    /// Creates a calendar view.
    ///
    /// - Parameters:
    ///   - selection: Binding to the currently selected date.
    ///   - locale: Display language. Defaults to `.khmer`.
    ///   - firstWeekday: `1` = Sunday, `2` = Monday. Defaults to `1`.
    public init(
        selection: Binding<Date>,
        locale: KhmerLocale = .khmer,
        firstWeekday: Int = 1
    ) {
        self._selection = selection
        self._viewModel = ObservedObject(
            wrappedValue: KhmerCalendarViewModel(
                selection: selection.wrappedValue,
                locale: locale,
                firstWeekday: firstWeekday
            )
        )
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            monthHeader
            weekdayRow
            Divider()
            daysGrid
        }
        .onChange(of: selection) { newValue in
            viewModel.selection = newValue
        }
        .onChange(of: viewModel.selection) { newValue in
            selection = newValue
        }
    }

    // MARK: - Sub-views

    private var monthHeader: some View {
        HStack {
            Button(action: viewModel.goToPreviousMonth) {
                Image(systemName: "chevron.left")
                    .padding(8)
            }
            Spacer()
            Text(viewModel.formattedHeader)
                .font(.headline)
            Spacer()
            Button(action: viewModel.goToNextMonth) {
                Image(systemName: "chevron.right")
                    .padding(8)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }

    private var weekdayRow: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.weekdayHeaders, id: \.self) { header in
                Text(header)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
        }
    }

    private var daysGrid: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.weeks.indices, id: \.self) { rowIndex in
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { colIndex in
                        let date = viewModel.weeks[rowIndex][colIndex]
                        dayCellView(for: date)
                    }
                }
            }
        }
    }

    private func dayCellView(for date: Date?) -> some View {
        Group {
            if let date = date {
                let isSelected = viewModel.isSelected(date)
                let isToday    = viewModel.isToday(date)

                Button(action: {
                    viewModel.selection = date
                    selection = date
                }) {
                    Text(viewModel.dayLabel(for: date))
                        .font(.body)
                        .frame(maxWidth: .infinity, minHeight: 36)
                        .foregroundColor(
                            isSelected ? .white :
                            isToday    ? .accentColor :
                                         .primary
                        )
                        .background(
                            isSelected
                                ? Circle().fill(Color.accentColor)
                                : Circle().fill(Color.clear)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Color.clear
                    .frame(maxWidth: .infinity, minHeight: 36)
            }
        }
    }
}
