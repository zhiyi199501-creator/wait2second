import SwiftUI

struct PracticeButton: View {
    var title: String = DisplaySettings.defaultButtonTitle
    var action: () -> Void

    @State private var isPressing = false

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 196, height: 196)
                .shadow(color: Theme.skyDeep.opacity(0.28), radius: 18, y: 10)

            Circle()
                .fill(Theme.heart.opacity(0.28))
                .frame(width: 72, height: 72)
                .offset(y: -18)

            Text(title)
                .font(.custom("Songti SC", size: 36))
                .foregroundStyle(Theme.ink)
                .tracking(title.count <= 3 ? 4 : 0)
                .lineLimit(1)
                .minimumScaleFactor(0.45)
                .frame(width: 148)
        }
        .scaleEffect(isPressing ? 0.96 : 1)
        .animation(.easeOut(duration: 0.12), value: isPressing)
        .contentShape(Circle())
        .onLongPressGesture(
            minimumDuration: 0.4,
            pressing: { isPressing = $0 },
            perform: action
        )
        .accessibilityLabel("长按，记录一次\(title)")
        .accessibilityAddTraits(.isButton)
    }
}
