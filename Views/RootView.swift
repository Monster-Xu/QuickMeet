import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = QuickMeetViewModel()

    var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                MainTabView()
                    .environmentObject(viewModel)
            } else {
                OnboardingView()
            }
        }
        .sheet(isPresented: $appState.showMatchModal) {
            MatchSuccessView()
                .presentationDetents([.height(320)])
        }
    }
}
