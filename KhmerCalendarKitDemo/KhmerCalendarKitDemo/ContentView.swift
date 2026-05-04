import SwiftUI

struct ContentView: View {
    @State private var selectedTab  = 0
    @State private var showSettings = false

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab, showSettings: $showSettings)
                .tabItem { Label("Home",      systemImage: "house.fill") }
                .tag(0)
            FormatterView(showSettings: $showSettings)
                .tabItem { Label("Formatter", systemImage: "textformat") }
                .tag(1)
            CalendarDemoView(showSettings: $showSettings)
                .tabItem { Label("Calendar",  systemImage: "calendar") }
                .tag(2)
            DatePickerDemoView(showSettings: $showSettings)
                .tabItem { Label("Picker",    systemImage: "clock") }
                .tag(3)
            LunarView(showSettings: $showSettings)
                .tabItem { Label("Lunar",     systemImage: "moon.stars.fill") }
                .tag(4)
        }
        .accentColor(Color(red: 88/255, green: 86/255, blue: 214/255))
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}
