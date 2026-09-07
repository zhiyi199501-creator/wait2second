import SwiftUI

struct SkyBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Theme.skyTop, Theme.skyMid, Color(red: 0.847, green: 0.933, blue: 0.973)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}
