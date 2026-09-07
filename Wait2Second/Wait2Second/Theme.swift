import SwiftUI

enum Theme {
    static let skyTop = Color(red: 0.788, green: 0.910, blue: 0.965)
    static let skyMid = Color(red: 0.557, green: 0.784, blue: 0.910)
    static let skyDeep = Color(red: 0.357, green: 0.643, blue: 0.800)
    static let cloud = Color(red: 0.969, green: 0.984, blue: 0.996)
    static let heart = Color(red: 0.941, green: 0.627, blue: 0.294)
    static let ink = Color(red: 0.184, green: 0.267, blue: 0.329)
    static let inkMuted = Color(red: 0.369, green: 0.467, blue: 0.525)
    static let inkFaint = Color(red: 0.541, green: 0.639, blue: 0.698)
    static let todayFill = Color(red: 0.941, green: 0.627, blue: 0.294).opacity(0.16)

    static let display = Font.custom("Songti SC", size: 28)
    static let body = Font.custom("PingFang SC", size: 16)
}
