import SwiftUI

struct MatchSuccessView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            Text("🎉 匹配成功")
                .font(.system(size: 28, weight: .bold))
            Text("你和 \(appState.matchedUser?.name ?? "TA") 互相喜欢了！")
            PrimaryButton(title: "立即聊天") {
                appState.showMatchModal = false
                appState.selectedTab = .messages
            }
        }
        .padding(24)
    }
}
