import SwiftUI

struct MessagesView: View {
    @EnvironmentObject private var viewModel: QuickMeetViewModel

    var body: some View {
        List(viewModel.threads) { thread in
            NavigationLink {
                ChatView(thread: thread)
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    Text(thread.user.name).font(.headline)
                    Text(thread.messages.last?.text ?? "")
                        .foregroundStyle(QMColor.textSecondary)
                        .lineLimit(1)
                }
            }
        }
        .navigationTitle("消息")
    }
}
