import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)
            FormatterView()
                .tabItem { Label("Formatter", systemImage: "textformat") }
                .tag(1)
            CalendarDemoView()
                .tabItem { Label("Calendar", systemImage: "calendar") }
                .tag(2)
            DatePickerDemoView()
                .tabItem { Label("Picker", systemImage: "clock") }
                .tag(3)
            LunarView()
                .tabItem { Label("Lunar", systemImage: "moon.stars.fill") }
                .tag(4)
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
                .tag(5)
        }
        .accentColor(Color(red: 88/255, green: 86/255, blue: 214/255))
    }
}
