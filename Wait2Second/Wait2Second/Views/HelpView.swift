import SwiftUI

struct HelpView: View {
    private let sections: [(title: String, items: [(q: String, a: String)])] = [
        (
            "记一次",
            [
                (
                    "怎么记一次？",
                    "今日页长按中间的按钮，大约 0.4 秒，次数加一。点一下不算，是为了少误触。"
                ),
                (
                    "撤销是什么？",
                    "今日页长按那个大数字，去掉今天最近一次。只能撤今天的，一次只撤一下。以前的日子不能改。"
                ),
                (
                    "按钮上的字能换吗？",
                    "能。设置里「按钮文字」改的是圆按钮中间那几个字，最多 6 个。空着就是「宽两秒」。App 名字、通知标题不会跟着变。"
                ),
            ]
        ),
        (
            "锁屏和控制中心",
            [
                (
                    "锁屏小组件要点一下加一，要解锁吗？",
                    "要。苹果规定锁屏上的小组件按钮，必须先 Face ID 或密码，才能执行。能看今天的次数，要点加一得先解锁。"
                ),
                (
                    "控制中心呢？",
                    "不用解锁。锁屏往下拉，点「宽两秒」就会加一，不必打开 App。第一次用，要在控制中心编辑里把「宽两秒」加进去。"
                ),
                (
                    "口袋里会不会误触？",
                    "锁屏小组件要先解锁，口袋蹭到一般不会加上。控制中心要先下拉再点，也不容易误触。App 里是长按才记。"
                ),
                (
                    "Siri 能记吗？",
                    "能。可以说「记一次宽两秒」或「宽两秒加一」，不必打开 App。"
                ),
            ]
        ),
        (
            "提醒",
            [
                (
                    "间隔从什么时候开始算？",
                    "从上次练习的时间往后数，不是从打开 App 的时间数。比如 10:20 练了一次，间隔 60 分钟，下次约在 11:20。"
                ),
                (
                    "人在 App 里，到点会响吗？",
                    "不会。系统默认不盖横幅。"
                ),
                (
                    "晚上还会响吗？",
                    "不会。只在设置的白天时段里提醒，超出就推到第二天开始的时间。"
                ),
            ]
        )
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                ForEach(sections, id: \.title) { section in
                    VStack(alignment: .leading, spacing: 16) {
                        Text(section.title)
                            .font(.custom("Songti SC", size: 22))
                            .foregroundStyle(Theme.ink)
                            .tracking(2)

                        ForEach(Array(section.items.enumerated()), id: \.offset) { _, item in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.q)
                                    .font(.custom("PingFang SC", size: 16))
                                    .foregroundStyle(Theme.ink)
                                Text(item.a)
                                    .font(.custom("PingFang SC", size: 15))
                                    .foregroundStyle(Theme.inkMuted)
                                    .lineSpacing(5)
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
        .navigationTitle("使用帮助")
        .navigationBarTitleDisplayMode(.inline)
    }
}
