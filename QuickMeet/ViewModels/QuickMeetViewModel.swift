import Foundation

final class QuickMeetViewModel: ObservableObject {
    @Published var discoverUsers: [UserProfile] = SampleData.users
    @Published var threads: [ChatThread] = SampleData.threads

    func passUser() {
        guard !discoverUsers.isEmpty else { return }
        discoverUsers.removeFirst()
    }

    func likeUser(appState: AppState) {
        guard let current = discoverUsers.first else { return }
        if current.name == "Anna" {
            appState.matchedUser = current
            appState.showMatchModal = true
        }
        discoverUsers.removeFirst()
    }

    func sendMessage(_ text: String, in thread: ChatThread) {
        guard let idx = threads.firstIndex(where: { $0.id == thread.id }) else { return }
        threads[idx].messages.append(Message(text: text, isMe: true, createdAt: .now))
    }
}
