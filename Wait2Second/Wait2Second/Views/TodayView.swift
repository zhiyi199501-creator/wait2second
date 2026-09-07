import SwiftUI
import UIKit

struct TodayView: View {
    @Environment(PracticeStore.self) private var store
    @State private var showSettings = false

    var body: some View {
        ZStack {
            SkyBackground()
            VStack(spacing: 0) {
            HStack {
                Text("今日")
                    .font(.custom("Songti SC", size: 28))
                    .foregroundStyle(Theme.ink)
                    .tracking(4)
                Spacer()
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 21))
                        .foregroundStyle(Theme.ink)
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("设置")
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)

            Spacer()

            VStack(spacing: 8) {
                Text("\(store.todayCount)")
                    .font(.custom("Songti SC", size: 108))
                    .foregroundStyle(Theme.ink)
                    .contentTransition(.numericText())
                    .onLongPressGesture(minimumDuration: 0.4) {
                        guard store.todayCount > 0 else { return }
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        store.undoToday()
                    }
                    .accessibilityLabel(
                        store.todayCount > 0
                            ? "今天已练习\(store.todayCount)次，长按撤销一次"
                            : "今天还没有练习"
                    )

                Text(store.todayCount > 0 ? "长按次数可撤销一次" : "长按按钮，记一次宽两秒")
                    .font(.custom("PingFang SC", size: 14))
                    .foregroundStyle(Theme.inkMuted)
            }

            Spacer()

            PracticeButton(title: store.buttonTitle) {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                store.increment()
            }
            .padding(.bottom, 20)

            Text("本月 \(store.thisMonth.total) 次 · \(store.thisMonth.days) 天")
                .font(.custom("PingFang SC", size: 15))
                .foregroundStyle(Theme.inkMuted)
                .padding(.bottom, 12)
            }
        }
        .toolbarBackground(Theme.cloud, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}
