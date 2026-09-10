import SwiftUI

struct MonthView: View {
    @Environment(PracticeStore.self) private var store
    @State private var ym = YearMonth.current
    @State private var selectedDay: Int? = CalendarMath.todayDay()

    private var stats: MonthStats {
        store.stats(for: ym)
    }

    var body: some View {
        ZStack {
            SkyBackground()
            ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Button {
                        go(-1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Theme.ink)
                            .frame(width: 44, height: 44)
                    }
                    .accessibilityLabel("上个月")

                    Spacer()
                    Text(ym.title)
                        .font(.custom("Songti SC", size: 26))
                        .foregroundStyle(Theme.ink)
                        .tracking(2)
                    Spacer()

                    Button {
                        go(1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(ym.isCurrent ? Theme.inkFaint : Theme.ink)
                            .frame(width: 44, height: 44)
                    }
                    .disabled(ym.isCurrent)
                    .accessibilityLabel("下个月")
                }
                .padding(.horizontal, 8)

                HStack(spacing: 10) {
                    statCard(value: "\(stats.total)", label: "总次数")
                    statCard(value: "\(stats.days)", label: "天数")
                    statCard(value: CalendarMath.formatAverage(stats.average), label: "日均")
                }
                .padding(.horizontal, 20)

                VStack(spacing: 14) {
                    MonthCalendarView(ym: ym, store: store, selectedDay: $selectedDay)
                }
                .padding(.horizontal, 10)
                .padding(.top, 14)
                .padding(.bottom, 18)
                .background(Theme.cloud.opacity(0.72), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.horizontal, 16)

                VStack(spacing: 10) {
                    Text(detailText)
                        .font(.custom("PingFang SC", size: 15))
                        .foregroundStyle(Theme.inkMuted)
                    ForEach(Array(timeRows.enumerated()), id: \.offset) { _, row in
                        HStack(spacing: 0) {
                            ForEach(0..<5, id: \.self) { index in
                                Text(index < row.count ? row[index] : "")
                                    .font(.custom("PingFang SC", size: 13))
                                    .foregroundStyle(Theme.inkMuted)
                                    .frame(maxWidth: .infinity)
                                    .monospacedDigit()
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Theme.cloud.opacity(0.72), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.horizontal, 16)
            }
            .padding(.top, 8)
            .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .toolbarBackground(Theme.cloud, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }

    private var detailText: String {
        guard let selectedDay else {
            return stats.total == 0 ? "这个月还没有练习记录" : "点某一天，看当天次数"
        }
        let count = store.count(on: CalendarMath.dateKey(year: ym.year, month: ym.month, day: selectedDay))
        let day = CalendarMath.monthDayLabel(month: ym.month, day: selectedDay)
        return count == 0 ? "\(day) · 还没有练习" : "\(day) · \(count) 次"
    }

    private var timeRows: [[String]] {
        guard let selectedDay else { return [] }
        let key = CalendarMath.dateKey(year: ym.year, month: ym.month, day: selectedDay)
        let times = store.times(on: key).map(CalendarMath.formatClock)
        return stride(from: 0, to: times.count, by: 5).map {
            Array(times[$0..<min($0 + 5, times.count)])
        }
    }

    private func go(_ delta: Int) {
        let next = ym.shifted(by: delta)
        if delta > 0, next.isAfter(.current) { return }
        ym = next
        selectedDay = next.isCurrent ? CalendarMath.todayDay() : nil
    }

    private func statCard(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.custom("Songti SC", size: 28))
                .foregroundStyle(Theme.ink)
            Text(label)
                .font(.custom("PingFang SC", size: 12))
                .foregroundStyle(Theme.inkMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.white.opacity(0.55), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
