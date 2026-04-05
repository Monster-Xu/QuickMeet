import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var store: AppStore

    var body: some View {
        Group {
            if !store.isAuthenticated {
                AuthView()
            } else if !store.didCompleteOnboarding {
                OnboardingView()
            } else {
                MainTabView()
            }
        }
        .sheet(isPresented: $appState.showMatchSuccess) {
            MatchSuccessView()
                .presentationDetents([.height(360)])
        }
    }
}

struct AuthView: View {
    @EnvironmentObject private var store: AppStore
    @State private var name = "MonsterX"
    @State private var ageText = "24"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 14) {
                    Text("QuickMeet")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(QMColor.textPrimary)
                    Text("更轻、更快、更直接的社交方式")
                        .foregroundStyle(QMColor.textSecondary)

                    RoundedRectangle(cornerRadius: 28)
                        .fill(LinearGradient(colors: [QMColor.primary.opacity(0.9), QMColor.secondary.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: 220)
                        .overlay(
                            VStack(spacing: 12) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 42))
                                    .foregroundStyle(.white)
                                Text("快速交友")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        )
                }

                SectionCard {
                    Text("开始体验")
                        .font(.system(size: 22, weight: .bold))
                    TextField("昵称", text: $name)
                        .textFieldStyle(.roundedBorder)
                    TextField("年龄", text: $ageText)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    PrimaryButton(title: "继续") {
                        store.signIn(name: name.isEmpty ? "MonsterX" : name, age: Int(ageText) ?? 24)
                    }
                }
            }
            .padding(20)
        }
        .background(QMColor.background.ignoresSafeArea())
    }
}

struct OnboardingView: View {
    @EnvironmentObject private var store: AppStore
    @State private var selectedTags: Set<String> = ["电影", "旅行"]
    private let tags = ["电影", "旅行", "运动", "摄影", "咖啡", "音乐", "游戏", "看展"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("快速交友")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(QMColor.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(QMColor.primary.opacity(0.12))
                        .clipShape(Capsule())

                    Text("3 分钟认识新朋友")
                        .font(.system(size: 32, weight: .bold))
                    Text("先选几个兴趣标签，让匹配更准确。")
                        .foregroundStyle(QMColor.textSecondary)
                }

                SectionCard {
                    Text("兴趣标签")
                        .font(.system(size: 22, weight: .bold))

                    LazyVGrid(columns: [.init(.flexible()), .init(.flexible()), .init(.flexible())], spacing: 10) {
                        ForEach(tags, id: \.self) { tag in
                            Button {
                                if selectedTags.contains(tag) { selectedTags.remove(tag) } else { selectedTags.insert(tag) }
                            } label: {
                                TagChip(title: tag, selected: selectedTags.contains(tag))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    PrimaryButton(title: "进入 App") {
                        var profile = store.myProfile
                        profile.tags = Array(selectedTags)
                        store.saveMyProfile(profile)
                        store.completeOnboarding()
                    }
                    .padding(.top, 8)
                }
            }
            .padding(20)
        }
        .background(QMColor.background.ignoresSafeArea())
    }
}

struct MainTabView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var store: AppStore

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack { DiscoverView() }
                .tabItem { Label("发现", systemImage: "safari") }
                .tag(AppTab.discover)

            NavigationStack(path: $appState.messagesPath) { MessagesView() }
                .tabItem { Label("消息", systemImage: "message") }
                .badge(store.unreadCount > 0 ? store.unreadCount : 0)
                .tag(AppTab.messages)

            NavigationStack { ProfileView() }
                .tabItem { Label("我的", systemImage: "person") }
                .tag(AppTab.profile)
        }
        .tint(QMColor.primary)
        .onChange(of: appState.activeChatThreadID) { _, threadID in
            guard let threadID else { return }
            appState.selectedTab = .messages
            appState.messagesPath = [threadID]
            appState.activeChatThreadID = nil
        }
    }
}
