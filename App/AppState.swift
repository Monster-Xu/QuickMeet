import Foundation

final class AppState: ObservableObject {
    @Published var hasCompletedOnboarding = false
    @Published var selectedTab: AppTab = .discover
    @Published var activeChat: ChatThread?
    @Published var matchedUser: UserProfile?
    @Published var showMatchModal = false
}

enum AppTab: Hashable {
    case discover
    case messages
    case profile
}
