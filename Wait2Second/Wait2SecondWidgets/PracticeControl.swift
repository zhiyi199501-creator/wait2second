import AppIntents
import SwiftUI
import WidgetKit

@available(iOS 18.0, *)
struct PracticeControl: ControlWidget {
    static let kind = "com.wait2second.native.control"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: IncrementPracticeIntent()) {
                Label("宽两秒", systemImage: "sun.max.fill")
            }
        }
        .displayName("宽两秒")
        .description("点一下，给今天的练习加一。")
    }
}
