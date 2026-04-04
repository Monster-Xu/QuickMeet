import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var viewModel: QuickMeetViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("发现").font(.system(size: 28, weight: .bold))
                        Text("Tokyo · 在线优先").foregroundStyle(QMColor.textSecondary)
                    }
                    Spacer()
                }

                if let user = viewModel.discoverUsers.first {
                    VStack(alignment: .leading, spacing: 12) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(colors: [QMColor.primary.opacity(0.8), QMColor.secondary.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .frame(height: 420)
                            .overlay(
                                Text(String(user.name.prefix(1)))
                                    .font(.system(size: 72, weight: .bold))
                                    .foregroundStyle(.white)
                            )

                        Text("\(user.name), \(user.age)")
                            .font(.system(size: 26, weight: .bold))
                        Text(user.bio)
                            .foregroundStyle(QMColor.textSecondary)
                    }
                    .padding(16)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                    HStack(spacing: 16) {
                        Button("跳过") { viewModel.passUser() }
                        Button("喜欢") { viewModel.likeUser(appState: appState) }
                    }
                }
            }
            .padding(20)
        }
        .background(QMColor.background.ignoresSafeArea())
    }
}
