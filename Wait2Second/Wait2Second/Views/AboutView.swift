import SwiftUI

struct AboutView: View {
    private let steps: [(title: String, note: String)] = [
        ("觉知心情来了", ""),
        ("用手触摸内心", "内心的位置"),
        ("感受能量自由", "两秒钟"),
        ("继续说话动作", ""),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image("PracticeSteps")
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .accessibilityLabel("黄庭禅宽两秒四步骤示意图")

                Text("心情来的时候，宽两秒，再继续说话做事。")
                    .font(.custom("PingFang SC", size: 16))
                    .foregroundStyle(Theme.inkMuted)
                    .lineSpacing(6)

                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 8) {
                        Text("\(index + 1)")
                            .font(.custom("Songti SC", size: 24))
                            .foregroundStyle(Theme.heart)
                            .frame(width: 28, alignment: .leading)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(step.title)
                                .font(.custom("PingFang SC", size: 18))
                                .foregroundStyle(Theme.ink)
                            if !step.note.isEmpty {
                                Text(step.note)
                                    .font(.custom("PingFang SC", size: 14))
                                    .foregroundStyle(Theme.inkMuted)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 40)
        }
        .background(Theme.cloud.ignoresSafeArea())
        .navigationTitle("练习说明")
        .navigationBarTitleDisplayMode(.inline)
    }
}
