import Foundation
import UserNotifications

enum ReminderScheduler {
    static let idPrefix = "wait2second.hourly."
    static let maxPending = 10

    static func requestPermissionIfNeeded() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
                    if granted {
                        reschedule(appIsActive: true)
                    }
                }
            case .authorized, .provisional:
                reschedule(appIsActive: true)
            default:
                break
            }
        }
    }

    static func nextFireDate(
        last: Date? = SharedStore.lastPracticeDate(),
        now: Date = Date(),
        settings: ReminderSettings = ReminderSettingsStore.load(),
        appIsActive: Bool = true
    ) -> Date? {
        upcomingFires(
            after: last,
            now: now,
            skipImmediate: appIsActive,
            settings: settings
        ).first
    }

    static func reschedule(appIsActive: Bool = false) {
        let center = UNUserNotificationCenter.current()
        let settings = ReminderSettingsStore.load()
        center.getPendingNotificationRequests { pending in
            let ours = pending
                .map(\.identifier)
                .filter { $0.hasPrefix(idPrefix) }
            center.removePendingNotificationRequests(withIdentifiers: ours)

            let dates = upcomingFires(
                after: SharedStore.lastPracticeDate(),
                now: Date(),
                skipImmediate: appIsActive,
                settings: settings
            )
            for (index, date) in dates.enumerated() {
                schedule(center: center, identifier: "\(idPrefix)\(index)", at: date, settings: settings)
            }
        }
    }

    private static func upcomingFires(
        after last: Date?,
        now: Date,
        skipImmediate: Bool,
        settings: ReminderSettings
    ) -> [Date] {
        let gap = settings.interval
        var first = (last ?? now).addingTimeInterval(gap)
        if first <= now {
            first = skipImmediate ? now.addingTimeInterval(gap) : now.addingTimeInterval(20)
        }
        first = clampToDaytime(first, settings: settings)

        var result = [first]
        while result.count < maxPending {
            guard let next = Calendar.current.date(
                byAdding: .minute,
                value: settings.intervalMinutes,
                to: result[result.count - 1]
            ) else {
                break
            }
            result.append(clampToDaytime(next, settings: settings))
        }

        var seen = Set<Int>()
        return result.filter { date in
            guard date > now else { return false }
            let stamp = Int(date.timeIntervalSince1970)
            if seen.contains(stamp) { return false }
            seen.insert(stamp)
            return true
        }
    }

    private static func clampToDaytime(_ date: Date, settings: ReminderSettings) -> Date {
        let calendar = Calendar.current
        let minutes = ClockTime.minutes(from: date)
        if minutes >= settings.dayStartMinutes && minutes < settings.dayEndMinutes {
            return date
        }

        if minutes < settings.dayStartMinutes {
            return ClockTime.date(fromMinutes: settings.dayStartMinutes, on: date)
        }

        let nextDay = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: date)) ?? date
        return ClockTime.date(fromMinutes: settings.dayStartMinutes, on: nextDay)
    }

    private static func schedule(
        center: UNUserNotificationCenter,
        identifier: String,
        at date: Date,
        settings: ReminderSettings
    ) {
        let content = UNMutableNotificationContent()
        content.title = "宽两秒"
        content.body = "已经\(settings.intervalPhrase)了。心情来的时候，宽两秒。"
        content.sound = .default

        let parts = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: false)
        center.add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
    }
}
