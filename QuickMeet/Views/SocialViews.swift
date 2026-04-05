import SwiftUI

struct MessagesView: View {
    @EnvironmentObject private var store: AppStore

    private var sortedThreads: [ChatThread] {
        store.threads.sorted { $0.updatedAt > $1.updatedAt }
    }

    var body: some View {
        List {
            ForEach(sortedThreads) { thread in
                NavigationLink(value: thread.id) {
                    MessageRow(thread: thread)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(QMColor.background)
        .navigationTitle("消息")
        .navigationDestination(for: UUID.self) { threadID in
            ChatView(threadID: threadID)
        }
    }
}

struct MessageRow: View {
    let thread: ChatThread

    var body: some View {
        HStack(spacing: 12) {
            AvatarCircle(title: String(thread.user.name.prefix(1)))
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(thread.user.name)
                        .font(.system(size: 16, weight: .semibold))
                    if thread.user.isOnline {
                        Circle().fill(QMColor.success).frame(width: 8, height: 8)
                    }
                    Spacer()
                    if thread.unreadCount > 0 {
                        Text("\(thread.unreadCount)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.red)
                            .clipShape(Capsule())
                    }
                }
                Text(thread.messages.last?.text ?? "")
                    .font(.system(size: 14))
                    .foregroundStyle(QMColor.textSecondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 8)
    }
}

struct ChatView: View {
    @EnvironmentObject private var store: AppStore
    let threadID: UUID
    @State private var inputText = ""
    private let icebreakers = ["周末一般做什么？", "你最喜欢哪个城市？"]

    private var thread: ChatThread? {
        store.thread(for: threadID)
    }

    var body: some View {
        VStack(spacing: 12) {
            if let thread {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(thread.messages) { message in
                            HStack {
                                if message.isMe { Spacer() }
                                VStack(alignment: message.isMe ? .trailing : .leading, spacing: 4) {
                                    Text(message.text)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                        .background(message.isMe ? AnyShapeStyle(QMColor.primary) : AnyShapeStyle(Color.white))
                                        .foregroundStyle(message.isMe ? .white : QMColor.textPrimary)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                    Text(message.createdAt, style: .time)
                                        .font(.system(size: 11))
                                        .foregroundStyle(QMColor.textSecondary)
                                }
                                if !message.isMe { Spacer() }
                            }
                        }
                    }
                    .padding(.top, 12)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(icebreakers, id: \.self) { item in
                            Button(item) { inputText = item }
                                .font(.system(size: 13, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .overlay(Capsule().stroke(QMColor.border, lineWidth: 1))
                                .clipShape(Capsule())
                        }
                    }
                }

                HStack(spacing: 10) {
                    TextField("输入消息...", text: $inputText)
                        .textFieldStyle(.roundedBorder)
                    Button("发送") {
                        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !text.isEmpty else { return }
                        store.sendMessage(threadID: threadID, text: text)
                        inputText = ""
                    }
                    .foregroundStyle(QMColor.primary)
                }
                .padding(.bottom, 8)
            } else {
                EmptyStateView(title: "会话不存在", subtitle: "这个聊天暂时不可用。", buttonTitle: nil, action: nil)
            }
        }
        .padding(.horizontal, 20)
        .background(QMColor.background.ignoresSafeArea())
        .navigationTitle(thread?.user.name ?? "聊天")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { store.markThreadRead(threadID) }
    }
}

struct ProfileView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SectionCard {
                    VStack(spacing: 12) {
                        AvatarCircle(title: String(store.myProfile.displayName.prefix(1)), size: 84)
                        Text(store.myProfile.displayName)
                            .font(.system(size: 24, weight: .bold))
                        Text("ID: QM2026")
                            .foregroundStyle(QMColor.textSecondary)
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("资料完善度")
                                Spacer()
                                Text("70%")
                                    .foregroundStyle(QMColor.primary)
                            }
                            ProgressView(value: 0.7)
                                .tint(QMColor.primary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                SectionCard {
                    NavigationLink("我的喜欢") { Text("我的喜欢") }
                    NavigationLink("我的匹配") { Text("我的匹配") }
                    NavigationLink("编辑资料") { EditProfileView() }
                    Button("退出登录", role: .destructive) { store.signOut() }
                }
            }
            .padding(20)
        }
        .background(QMColor.background.ignoresSafeArea())
        .navigationTitle("我的")
    }
}

struct EditProfileView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var displayName = ""
    @State private var ageText = ""
    @State private var city = ""
    @State private var bio = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SectionCard {
                    Text("昵称").foregroundStyle(QMColor.textSecondary)
                    TextField("昵称", text: $displayName).textFieldStyle(.roundedBorder)
                    Text("年龄").foregroundStyle(QMColor.textSecondary)
                    TextField("年龄", text: $ageText).textFieldStyle(.roundedBorder)
                    Text("城市").foregroundStyle(QMColor.textSecondary)
                    TextField("城市", text: $city).textFieldStyle(.roundedBorder)
                    Text("一句话介绍").foregroundStyle(QMColor.textSecondary)
                    TextField("一句话介绍", text: $bio).textFieldStyle(.roundedBorder)
                    PrimaryButton(title: "保存资料") {
                        var profile = store.myProfile
                        profile.displayName = displayName.isEmpty ? profile.displayName : displayName
                        profile.age = Int(ageText) ?? profile.age
                        profile.city = city.isEmpty ? profile.city : city
                        profile.bio = bio.isEmpty ? profile.bio : bio
                        store.saveMyProfile(profile)
                        dismiss()
                    }
                    .padding(.top, 8)
                }
            }
            .padding(20)
        }
        .background(QMColor.background.ignoresSafeArea())
        .navigationTitle("编辑资料")
        .onAppear {
            displayName = store.myProfile.displayName
            ageText = String(store.myProfile.age)
            city = store.myProfile.city
            bio = store.myProfile.bio
        }
    }
}
