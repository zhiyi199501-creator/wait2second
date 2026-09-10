import Foundation

struct YearMonth: Equatable {
    var year: Int
    var month: Int

    var prefix: String {
        String(format: "%04d-%02d-", year, month)
    }

    var title: String {
        "\(year)年\(month)月"
    }

    var isCurrent: Bool {
        self == .current
    }

    var dayCount: Int {
        let comps = DateComponents(year: year, month: month)
        return Calendar.current.range(of: .day, in: .month, for: Calendar.current.date(from: comps) ?? Date())?.count ?? 30
    }

    /// 已过完的月份用整月天数；本月用今天是几号。
    var elapsedDayCount: Int {
        if isCurrent {
            return min(CalendarMath.todayDay(), dayCount)
        }
        return dayCount
    }

    /// Sunday = 0, matching 日一二三四五六.
    var leadingEmptyDays: Int {
        var comps = DateComponents(calendar: Calendar.current, year: year, month: month, day: 1)
        guard let date = comps.date else { return 0 }
        return Calendar.current.component(.weekday, from: date) - 1
    }

    func shifted(by delta: Int) -> YearMonth {
        var comps = DateComponents()
        comps.year = year
        comps.month = month + delta
        comps.day = 1
        let date = Calendar.current.date(from: comps) ?? Date()
        let parts = Calendar.current.dateComponents([.year, .month], from: date)
        return YearMonth(year: parts.year ?? year, month: parts.month ?? month)
    }

    func isAfter(_ other: YearMonth) -> Bool {
        year * 12 + month > other.year * 12 + other.month
    }

    static var current: YearMonth {
        let parts = Calendar.current.dateComponents([.year, .month], from: Date())
        return YearMonth(year: parts.year ?? 2026, month: parts.month ?? 1)
    }
}

enum CalendarMath {
    static func dateKey(year: Int, month: Int, day: Int) -> String {
        String(format: "%04d-%02d-%02d", year, month, day)
    }

    static func localDateKey(_ date: Date = Date()) -> String {
        let parts = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return dateKey(year: parts.year ?? 0, month: parts.month ?? 0, day: parts.day ?? 0)
    }

    static func todayDay() -> Int {
        Calendar.current.component(.day, from: Date())
    }

    static func monthDayLabel(month: Int, day: Int) -> String {
        "\(month)月\(day)日"
    }

    static func formatNextReminder(_ date: Date) -> String {
        let calendar = Calendar.current
        let time = formatClock(date)
        if calendar.isDateInToday(date) {
            return "今天 \(time)"
        }
        if calendar.isDateInTomorrow(date) {
            return "明天 \(time)"
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "M月d日 HH:mm"
        return formatter.string(from: date)
    }

    static func formatClock(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    static func formatAverage(_ average: Double) -> String {
        if average == 0 { return "0" }
        let rounded = (average * 10).rounded() / 10
        if rounded.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(rounded))
        }
        return String(format: "%.1f", rounded)
    }
}
