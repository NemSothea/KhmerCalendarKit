import SwiftUI
import KhmerCalendarKit

struct HomeView: View {
    @Binding var selectedTab: Int
    @State private var today = Date()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    dateCard
                    featuresCard
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("KhmerCalendarKit")
            .navigationBarTitleDisplayMode(.large)
            .onAppear { today = Date() }
        }
    }

    private var dateCard: some View {
        VStack(spacing: 12) {
            Label("ថ្ងៃនេះ · Today", systemImage: "calendar.badge.clock")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)

            Text(today.khmerString())
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)

            Divider()

            Text(today.khmerString(format: .buddhist))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Divider()

            Text(today.toKhmerLunar().khmerDescription())
                .font(.subheadline)
                .foregroundColor(.accentColor)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 8, y: 2)
    }

    private var featuresCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Features")
                .font(.headline)
                .padding(.bottom, 8)

            FeatureRow(icon: "textformat.abc",  title: "Formatter",   subtitle: "Khmer script · CE / BE era")    { selectedTab = 1 }
            Divider().padding(.leading, 42)
            FeatureRow(icon: "calendar",         title: "Calendar",    subtitle: "Month grid · Khmer & English")  { selectedTab = 2 }
            Divider().padding(.leading, 42)
            FeatureRow(icon: "clock",            title: "Date Picker", subtitle: "Date · Time · Date & Time")     { selectedTab = 3 }
            Divider().padding(.leading, 42)
            FeatureRow(icon: "moon.stars.fill",  title: "Lunar",       subtitle: "Chhankitek · Zodiac · Phase")   { selectedTab = 4 }
            Divider().padding(.leading, 42)
            FeatureRow(icon: "gearshape",        title: "Settings",    subtitle: "Locale · Era · Numerals")       { selectedTab = 5 }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 8, y: 2)
    }
}

private struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.subheadline.weight(.medium))
                    Text(subtitle).font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(Color(.tertiaryLabel))
            }
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
