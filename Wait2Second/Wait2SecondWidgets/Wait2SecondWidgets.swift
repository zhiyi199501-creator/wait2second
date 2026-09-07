import SwiftUI
import WidgetKit

@main
struct Wait2SecondWidgets: WidgetBundle {
    var body: some Widget {
        PracticeLockWidget()
        if #available(iOS 18.0, *) {
            PracticeControl()
        }
    }
}
