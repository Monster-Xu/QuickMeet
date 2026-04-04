import SwiftUI

struct ChatView: View {
    @EnvironmentObject private var viewModel: QuickMeetViewModel
    let thread: ChatThread
    @State private var inputText = ""

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(thread.messages) { message in
                        HStack {
                            if message.isMe { Spacer() }
                            Text(message.text)
                                .padding()
                                .background(message.isMe ? QMColor.primary : .white)
                                .foregroundStyle(message.isMe ? .white : QMColor.textPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            if !message.isMe { Spacer() }
                        }
                    }
                }
                .padding()
            }

            HStack {
                TextField("输入消息...", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                Button("发送") {
                    let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !text.isEmpty else { return }
                    viewModel.sendMessage(text, in: thread)
                    inputText = ""
                }
            }
            .padding()
        }
        .background(QMColor.background.ignoresSafeArea())
        .navigationTitle(thread.user.name)
    }
}
