import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var store: AppStore

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("发现")
                            .font(.system(size: 28, weight: .bold))
                        Text("\(store.myProfile.city) · 在线优先")
                            .foregroundStyle(QMColor.textSecondary)
                    }
                    Spacer()
                    Image(systemName: "slider.horizontal.3")
                        .frame(width: 40, height: 40)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                if let user = store.availableProfiles.first {
                    NavigationLink {
                        ProfileDetailView(user: user)
                    } label: {
                        DiscoverUserCard(user: user)
                    }
                    .buttonStyle(.plain)

                    HStack(spacing: 16) {
                        actionButton(title: "跳过", system: "xmark", tint: QMColor.textSecondary, background: .white) { store.markSeen(user) }
                        actionButton(title: "喜欢", system: "heart.fill", tint: .pink, background: Color.pink.opacity(0.12)) {
                            store.markSeen(user)
                            if user.name == "Anna" {
                                appState.matchedUser = user
                                appState.showMatchSuccess = true
                            }
                        }
                        actionButton(title: "超级喜欢", system: "star.fill", tint: QMColor.primary, background: QMColor.primary.opacity(0.12)) { store.markSeen(user) }
                    }
                } else {
                    EmptyStateView(title: "今日推荐已看完", subtitle: "稍后再来看看新的匹配对象，或重新开始浏览。", buttonTitle: "重新开始", action: { store.resetDiscoverDeck() })
                }
            }
            .padding(20)
        }
        .background(QMColor.background.ignoresSafeArea())
    }

    @ViewBuilder
    private func actionButton(title: String, system: String, tint: Color, background: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: system)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(tint)
                    .frame(width: 62, height: 62)
                    .background(background)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 8)
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(QMColor.textSecondary)
            }
        }
        .buttonStyle(.plain)
    }
}

struct DiscoverUserCard: View {
    let user: UserProfile
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                LinearGradient(colors: [QMColor.primary.opacity(0.85), QMColor.secondary.opacity(0.85)], startPoint: .topLeading, endPoint: .bottomTrailing)
                Text(String(user.name.prefix(1)))
                    .font(.system(size: 78, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(height: 420)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("\(user.name), \(user.age)")
                        .font(.system(size: 26, weight: .bold))
                    Spacer()
                    Label("在线", systemImage: "circle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(user.isOnline ? QMColor.success : QMColor.textSecondary)
                }
                Text("\(user.city) · \(user.distance)")
                    .foregroundStyle(QMColor.textSecondary)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(user.tags, id: \.self) { TagChip(title: $0) }
                    }
                }
                Text(user.bio)
                    .foregroundStyle(QMColor.textPrimary)
            }
            .padding(16)
        }
        .background(QMColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 10)
    }
}

struct ProfileDetailView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var store: AppStore
    let user: UserProfile

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ZStack {
                    LinearGradient(colors: [QMColor.primary.opacity(0.85), QMColor.secondary.opacity(0.85)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    Text(String(user.name.prefix(1)))
                        .font(.system(size: 76, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(height: 320)
                .clipShape(RoundedRectangle(cornerRadius: 28))

                SectionCard {
                    Text("\(user.name), \(user.age)")
                        .font(.system(size: 26, weight: .bold))
                    Text("\(user.city) · \(user.distance)")
                        .foregroundStyle(QMColor.textSecondary)
                    HStack(spacing: 8) { ForEach(user.tags, id: \.self) { TagChip(title: $0) } }
                }

                SectionCard {
                    Text("自我介绍")
                        .font(.system(size: 18, weight: .semibold))
                    Text(user.bio)
                        .foregroundStyle(QMColor.textPrimary)
                }

                HStack(spacing: 12) {
                    PrimaryButton(title: "喜欢") {
                        store.markSeen(user)
                        if user.name == "Anna" {
                            appState.matchedUser = user
                            appState.showMatchSuccess = true
                        }
                    }
                    SecondaryButton(title: "超级喜欢") { store.markSeen(user) }
                }
            }
            .padding(20)
        }
        .background(QMColor.background.ignoresSafeArea())
        .navigationTitle("资料详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MatchSuccessView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var store: AppStore

    var body: some View {
        VStack(spacing: 20) {
            Text("🎉 匹配成功")
                .font(.system(size: 28, weight: .bold))
            HStack(spacing: 16) {
                AvatarCircle(title: String(store.myProfile.displayName.prefix(1)))
                Image(systemName: "heart.fill").foregroundStyle(.pink)
                AvatarCircle(title: String(appState.matchedUser?.name.prefix(1) ?? "A"))
            }
            Text("你和 \(appState.matchedUser?.name ?? "TA") 互相喜欢了！")
                .font(.system(size: 18, weight: .medium))
            PrimaryButton(title: "立即聊天") {
                if let matched = appState.matchedUser,
                   let thread = store.threads.first(where: { $0.user.name == matched.name }) {
                    appState.activeChatThreadID = thread.id
                    appState.selectedTab = .messages
                }
                appState.showMatchSuccess = false
            }
            Button("继续浏览") { appState.showMatchSuccess = false }
                .foregroundStyle(QMColor.textSecondary)
        }
        .padding(24)
    }
}
