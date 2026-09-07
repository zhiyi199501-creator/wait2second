import SwiftUI

@main
struct Wait2SecondApp: App {
    @State private var store = PracticeStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .preferredColorScheme(.light)
                .task {
                    ReminderScheduler.requestPermissionIfNeeded()
                }
        }
    }
}
