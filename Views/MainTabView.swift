import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack { DiscoverView() }
                .tabItem { Label("发现", systemImage: "safari") }
                .tag(AppTab.discover)

            NavigationStack { MessagesView() }
                .tabItem { Label("消息", systemImage: "message") }
                .tag(AppTab.messages)

            NavigationStack { ProfileView() }
                .tabItem { Label("我的", systemImage: "person") }
                .tag(AppTab.profile)
        }
        .tint(QMColor.primary)
    }
}
