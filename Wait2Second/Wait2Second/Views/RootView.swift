import SwiftUI

struct RootView: View {
    @Environment(PracticeStore.self) private var store
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("今日", systemImage: "sun.max")
                }

            MonthView()
                .tabItem {
                    Label("本月", systemImage: "calendar")
                }
        }
        .tint(Theme.skyDeep)
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                store.reloadFromDisk()
                ReminderScheduler.reschedule(appIsActive: true)
            }
        }
        .onReceive(Timer.publish(every: 30, on: .main, in: .common).autoconnect()) { _ in
            store.refreshToday()
        }
    }
}
