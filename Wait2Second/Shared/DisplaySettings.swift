import Foundation

enum DisplaySettings {
    static let defaultButtonTitle = "宽两秒"
    static let maxButtonTitleCount = 6

    private static let storageKey = "button-title-v1"

    private static var defaults: UserDefaults {
        SharedStore.suite
    }

    static func loadButtonTitle() -> String {
        normalized(defaults.string(forKey: storageKey))
    }

    static func saveButtonTitle(_ title: String) {
        let next = normalized(title)
        if next == defaultButtonTitle {
            defaults.removeObject(forKey: storageKey)
        } else {
            defaults.set(next, forKey: storageKey)
        }
    }

    static func normalized(_ title: String?) -> String {
        let trimmed = title?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if trimmed.isEmpty {
            return defaultButtonTitle
        }
        return String(trimmed.prefix(maxButtonTitleCount))
    }
}
