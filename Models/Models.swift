import Foundation

struct UserProfile: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let age: Int
    let city: String
    let distance: String
    let isOnline: Bool
    let bio: String
    let tags: [String]
}

struct Message: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isMe: Bool
    let createdAt: Date
}

struct ChatThread: Identifiable, Hashable {
    let id = UUID()
    let user: UserProfile
    var messages: [Message]
    var unreadCount: Int
}

enum SampleData {
    static let users: [UserProfile] = [
        UserProfile(name: "Anna", age: 23, city: "Tokyo", distance: "2km", isOnline: true, bio: "喜欢旅行、咖啡和周末 city walk。", tags: ["旅行", "咖啡", "拍照"]),
        UserProfile(name: "Leo", age: 25, city: "Tokyo", distance: "5km", isOnline: true, bio: "喜欢电影、夜跑和健身。", tags: ["电影", "夜跑", "运动"]),
        UserProfile(name: "Mia", age: 22, city: "Yokohama", distance: "12km", isOnline: false, bio: "看展、摄影、音乐节爱好者。", tags: ["看展", "摄影", "音乐"])
    ]

    static let threads: [ChatThread] = [
        ChatThread(user: users[0], messages: [
            Message(text: "你好呀 👋", isMe: false, createdAt: .now),
            Message(text: "哈喽～", isMe: true, createdAt: .now)
        ], unreadCount: 2),
        ChatThread(user: users[1], messages: [
            Message(text: "最近有看什么电影吗？", isMe: false, createdAt: .now)
        ], unreadCount: 0)
    ]
}
