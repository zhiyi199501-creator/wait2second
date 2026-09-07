import Foundation

struct ReminderSettings: Codable, Equatable {
    var dayStartMinutes: Int
    var dayEndMinutes: Int
    var intervalMinutes: Int

    static let `default` = ReminderSettings(
        dayStartMinutes: 8 * 60,
        dayEndMinutes: 21 * 60,
        intervalMinutes: 60
    )

    var interval: TimeInterval {
        TimeInterval(max(intervalMinutes, 15) * 60)
    }

    var intervalPhrase: String {
        let minutes = max(intervalMinutes, 15)
        if minutes % 60 == 0 {
            let hours = minutes / 60
            return hours == 1 ? "一个小时" : "\(hours) 小时"
        }
        if minutes > 60 {
            return "\(minutes / 60) 小时 \(minutes % 60) 分钟"
        }
        return "\(minutes) 分钟"
    }

    var intervalLabel: String {
        intervalPhrase
    }

    mutating func normalize() {
        dayStartMinutes = min(max(dayStartMinutes, 0), 23 * 60 + 45)
        dayEndMinutes = min(max(dayEndMinutes, 15), 24 * 60)
        intervalMinutes = min(max(intervalMinutes, 15), 180)
        if dayEndMinutes <= dayStartMinutes {
            dayEndMinutes = min(dayStartMinutes + 60, 24 * 60)
        }
    }
}

enum ReminderSettingsStore {
    static let storageKey = "reminder-settings-v1"

    private static var defaults: UserDefaults {
        UserDefaults(suiteName: SharedStore.appGroupID) ?? .standard
    }

    static func load() -> ReminderSettings {
        guard
            let data = defaults.data(forKey: storageKey),
            var settings = try? JSONDecoder().decode(ReminderSettings.self, from: data)
        else {
            return .default
        }
        settings.normalize()
        return settings
    }

    static func save(_ settings: ReminderSettings) {
        var next = settings
        next.normalize()
        guard let data = try? JSONEncoder().encode(next) else { return }
        defaults.set(data, forKey: storageKey)
        ReminderScheduler.reschedule(appIsActive: true)
    }
}

enum ClockTime {
    static func date(fromMinutes minutes: Int, on day: Date = Date()) -> Date {
        Calendar.current.startOfDay(for: day).addingTimeInterval(TimeInterval(minutes * 60))
    }

    static func minutes(from date: Date) -> Int {
        let parts = Calendar.current.dateComponents([.hour, .minute], from: date)
        return (parts.hour ?? 0) * 60 + (parts.minute ?? 0)
    }
}
