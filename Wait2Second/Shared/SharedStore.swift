import Foundation
import WidgetKit

struct PracticeLog: Codable, Equatable {
    var version: Int = 3
    var counts: [String: Int] = [:]
    var events: [PracticeEvent] = []

    enum CodingKeys: String, CodingKey {
        case version, counts, events
    }

    init(version: Int = 3, counts: [String: Int] = [:], events: [PracticeEvent] = []) {
        self.version = version
        self.counts = counts
        self.events = events
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decodeIfPresent(Int.self, forKey: .version) ?? 1
        counts = try container.decodeIfPresent([String: Int].self, forKey: .counts) ?? [:]
        events = try container.decodeIfPresent([PracticeEvent].self, forKey: .events) ?? []
    }
}

struct MonthStats: Equatable {
    var total: Int
    var days: Int
    var average: Double
}

enum SharedStore {
    static let appGroupID = "group.com.wait2second.native"
    static let storageKey = "practice-log-v1"

    private static var defaults: UserDefaults {
        UserDefaults(suiteName: appGroupID) ?? .standard
    }

    static func load() -> PracticeLog {
        if let data = defaults.data(forKey: storageKey),
           let decoded = decode(data) {
            return upgraded(decoded)
        }

        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = decode(data) {
            let log = upgraded(decoded)
            save(log)
            return log
        }

        return PracticeLog()
    }

    static func save(_ log: PracticeLog) {
        guard let data = try? JSONEncoder().encode(log) else { return }
        defaults.set(data, forKey: storageKey)
        WidgetCenter.shared.reloadAllTimelines()
    }

    static func increment() {
        var log = load()
        log.version = 3
        log.events.append(PracticeEvent(date: Date()))
        let today = CalendarMath.localDateKey()
        log.counts[today] = count(on: today, log: log)
        save(log)
        ReminderScheduler.reschedule()
    }

    static func undoLastToday() {
        var log = load()
        let today = CalendarMath.localDateKey()
        if let index = log.events.lastIndex(where: { CalendarMath.localDateKey($0.date) == today }) {
            log.events.remove(at: index)
        } else if let current = log.counts[today], current > 0 {
            if current <= 1 {
                log.counts.removeValue(forKey: today)
            } else {
                log.counts[today] = current - 1
            }
            save(log)
            ReminderScheduler.reschedule()
            return
        }

        let remaining = count(on: today, log: log)
        if remaining == 0 {
            log.counts.removeValue(forKey: today)
        } else {
            log.counts[today] = remaining
        }
        save(log)
        ReminderScheduler.reschedule()
    }

    static func count(on key: String, log: PracticeLog = load()) -> Int {
        let stamped = log.events.filter { CalendarMath.localDateKey($0.date) == key }.count
        if stamped > 0 {
            return stamped
        }
        return log.counts[key] ?? 0
    }

    static func events(on key: String, log: PracticeLog = load()) -> [PracticeEvent] {
        log.events
            .filter { CalendarMath.localDateKey($0.date) == key }
            .sorted { $0.date < $1.date }
    }

    static func times(on key: String, log: PracticeLog = load()) -> [Date] {
        events(on: key, log: log).map(\.date)
    }

    static func lastPracticeDate(_ log: PracticeLog = load()) -> Date? {
        log.events.map(\.date).max()
    }

    static func todayCount(_ log: PracticeLog = load()) -> Int {
        count(on: CalendarMath.localDateKey(), log: log)
    }

    static func stats(for ym: YearMonth, log: PracticeLog = load()) -> MonthStats {
        var keys = Set(log.counts.keys)
        for event in log.events {
            keys.insert(CalendarMath.localDateKey(event.date))
        }

        let prefix = ym.prefix
        var total = 0
        var days = 0
        for key in keys where key.hasPrefix(prefix) {
            let value = count(on: key, log: log)
            if value > 0 {
                total += value
                days += 1
            }
        }

        return MonthStats(
            total: total,
            days: days,
            average: days > 0 ? Double(total) / Double(days) : 0
        )
    }

    private static func upgraded(_ log: PracticeLog) -> PracticeLog {
        guard log.version < 3 else { return log }
        var next = log
        next.version = 3
        save(next)
        return next
    }

    private static func decode(_ data: Data) -> PracticeLog? {
        try? JSONDecoder().decode(PracticeLog.self, from: data)
    }
}
