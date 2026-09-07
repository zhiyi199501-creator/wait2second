import Foundation
import Observation

@Observable
final class PracticeStore {
    var log = PracticeLog()
    var todayKey = CalendarMath.localDateKey()
    var buttonTitle = DisplaySettings.loadButtonTitle()

    var todayCount: Int {
        SharedStore.count(on: todayKey, log: log)
    }

    var thisMonth: MonthStats {
        SharedStore.stats(for: .current, log: log)
    }

    init() {
        reloadFromDisk()
    }

    func reloadFromDisk() {
        log = SharedStore.load()
        buttonTitle = DisplaySettings.loadButtonTitle()
        refreshToday()
    }

    func setButtonTitle(_ title: String) {
        DisplaySettings.saveButtonTitle(title)
        buttonTitle = DisplaySettings.loadButtonTitle()
    }

    func refreshToday() {
        todayKey = CalendarMath.localDateKey()
    }

    func increment() {
        SharedStore.increment()
        reloadFromDisk()
    }

    func undoToday() {
        SharedStore.undoLastToday()
        reloadFromDisk()
    }

    func count(on key: String) -> Int {
        SharedStore.count(on: key, log: log)
    }

    func times(on key: String) -> [Date] {
        SharedStore.times(on: key, log: log)
    }

    func stats(for ym: YearMonth) -> MonthStats {
        SharedStore.stats(for: ym, log: log)
    }
}
