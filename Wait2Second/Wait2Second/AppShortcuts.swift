import AppIntents

struct Wait2SecondShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: IncrementPracticeIntent(),
            phrases: [
                "记一次\(.applicationName)",
                "\(.applicationName)加一",
            ],
            shortTitle: "宽两秒",
            systemImageName: "sun.max"
        )
    }
}
