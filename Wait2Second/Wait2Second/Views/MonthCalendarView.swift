import SwiftUI

struct MonthCalendarView: View {
    let ym: YearMonth
    let store: PracticeStore
    @Binding var selectedDay: Int?

    private let weekdays = ["日", "一", "二", "三", "四", "五", "六"]

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(weekdays, id: \.self) { label in
                    Text(label)
                        .font(.custom("PingFang SC", size: 13))
                        .foregroundStyle(Theme.inkFaint)
                        .frame(maxWidth: .infinity)
                }
            }

            let cells = makeCells()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 0) {
                ForEach(Array(cells.enumerated()), id: \.offset) { _, day in
                    if let day {
                        dayCell(day)
                    } else {
                        Color.clear.frame(minHeight: 58)
                    }
                }
            }
        }
    }

    private func makeCells() -> [Int?] {
        var cells: [Int?] = Array(repeating: nil, count: ym.leadingEmptyDays)
        cells += Array(1...ym.dayCount)
        while cells.count % 7 != 0 {
            cells.append(nil)
        }
        return cells
    }

    private func dayCell(_ day: Int) -> some View {
        let key = CalendarMath.dateKey(year: ym.year, month: ym.month, day: day)
        let count = store.count(on: key)
        let isToday = key == CalendarMath.localDateKey() && ym.isCurrent
        let selected = selectedDay == day

        return Button {
            selectedDay = day
        } label: {
            VStack(spacing: 2) {
                Text("\(day)")
                    .font(.custom("PingFang SC", size: 15))
                    .fontWeight(selected ? .semibold : .regular)
                    .foregroundStyle(Theme.ink)
                Text(count > 0 ? "\(count)" : " ")
                    .font(.custom("PingFang SC", size: 12))
                    .foregroundStyle(Theme.heart)
            }
            .frame(maxWidth: .infinity, minHeight: 58)
            .background {
                if selected {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white)
                } else if isToday {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Theme.todayFill)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(ym.month)月\(day)日\(count > 0 ? "，\(count)次" : "，没有练习")")
    }
}
