import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("快速交友")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(QMColor.primary)
                    Text("3 分钟认识新朋友")
                        .font(.system(size: 32, weight: .bold))
                    Text("更轻、更快、更直接的社交方式")
                        .foregroundStyle(QMColor.textSecondary)
                }

                SectionCard {
                    Text("快速开始")
                        .font(.system(size: 22, weight: .bold))
                    PrimaryButton(title: "进入 App") {
                        appState.hasCompletedOnboarding = true
                    }
                }
            }
            .padding(20)
        }
        .background(QMColor.background.ignoresSafeArea())
    }
}
