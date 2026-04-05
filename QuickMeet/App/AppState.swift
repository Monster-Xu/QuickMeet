import Foundation

final class AppState: ObservableObject {
    @Published var selectedTab: AppTab = .discover
    @Published var activeChatThreadID: UUID?
    @Published var matchedUser: UserProfile?
    @Published var showMatchSuccess = false
}

enum AppTab: Hashable {
    case discover, messages, profile
}
