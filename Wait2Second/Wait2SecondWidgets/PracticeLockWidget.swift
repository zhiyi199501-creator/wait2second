import AppIntents
import SwiftUI
import WidgetKit

struct PracticeEntry: TimelineEntry {
    let date: Date
    let todayCount: Int
    let monthTotal: Int
}

struct PracticeTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> PracticeEntry {
        PracticeEntry(date: Date(), todayCount: 0, monthTotal: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (PracticeEntry) -> Void) {
        completion(currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PracticeEntry>) -> Void) {
        let midnight = Calendar.current.nextDate(
            after: Date(),
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) ?? Date().addingTimeInterval(3600)
        completion(Timeline(entries: [currentEntry()], policy: .after(midnight)))
    }

    private func currentEntry() -> PracticeEntry {
        let log = SharedStore.load()
        return PracticeEntry(
            date: Date(),
            todayCount: SharedStore.todayCount(log),
            monthTotal: SharedStore.stats(for: .current, log: log).total
        )
    }
}

struct PracticeLockWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "PracticeLockWidget", provider: PracticeTimelineProvider()) { entry in
            PracticeLockView(entry: entry)
                .containerBackground(for: .widget) {
                    AccessoryWidgetBackground()
                }
        }
        .configurationDisplayName("宽两秒")
        .description("锁屏上看今日次数，点一下加一。")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

struct PracticeLockView: View {
    @Environment(\.widgetFamily) private var family
    let entry: PracticeEntry

    var body: some View {
        Button(intent: IncrementPracticeIntent()) {
            switch family {
            case .accessoryRectangular:
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("今日 \(entry.todayCount)")
                            .font(.headline)
                        Text("本月 \(entry.monthTotal)")
                            .font(.caption)
                    }
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                }
            case .accessoryInline:
                Text("宽两秒 \(entry.todayCount)")
            default:
                VStack(spacing: 1) {
                    Text("\(entry.todayCount)")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                    Text("宽两秒")
                        .font(.system(size: 9))
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("记一次宽两秒，今天已练习\(entry.todayCount)次")
    }
}
