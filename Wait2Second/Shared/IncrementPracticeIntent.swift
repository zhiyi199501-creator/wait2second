import AppIntents

struct IncrementPracticeIntent: AppIntent {
    static var title: LocalizedStringResource = "记一次宽两秒"
    static var description = IntentDescription("给今天的练习次数加一，不必打开应用。")
    static var openAppWhenRun = false
    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed

    func perform() async throws -> some IntentResult {
        SharedStore.increment()
        return .result()
    }
}
