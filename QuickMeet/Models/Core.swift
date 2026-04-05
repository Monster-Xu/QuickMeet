import Foundation
import SwiftUI

struct UserProfile: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var age: Int
    var city: String
    var distance: String
    var isOnline: Bool
    var bio: String
    var tags: [String]

    init(id: UUID = UUID(), name: String, age: Int, city: String, distance: String, isOnline: Bool, bio: String, tags: [String]) {
        self.id = id
        self.name = name
        self.age = age
        self.city = city
        self.distance = distance
        self.isOnline = isOnline
        self.bio = bio
        self.tags = tags
    }
}

struct ChatMessage: Identifiable, Codable, Hashable {
    let id: UUID
    let text: String
    let isMe: Bool
    let createdAt: Date

    init(id: UUID = UUID(), text: String, isMe: Bool, createdAt: Date = .now) {
        self.id = id
        self.text = text
        self.isMe = isMe
        self.createdAt = createdAt
    }
}

struct ChatThread: Identifiable, Codable, Hashable {
    let id: UUID
    let user: UserProfile
    var messages: [ChatMessage]
    var unreadCount: Int
    var updatedAt: Date

    init(id: UUID = UUID(), user: UserProfile, messages: [ChatMessage], unreadCount: Int) {
        self.id = id
        self.user = user
        self.messages = messages
        self.unreadCount = unreadCount
        self.updatedAt = messages.last?.createdAt ?? .now
    }
}

struct MyProfile: Codable, Hashable {
    var displayName: String
    var age: Int
    var city: String
    var bio: String
    var tags: [String]

    static let `default` = MyProfile(displayName: "MonsterX", age: 24, city: "Tokyo", bio: "热爱旅行和电影，想认识有趣的人。", tags: ["电影", "旅行", "咖啡"])
}

enum SampleData {
    static let discoverProfiles: [UserProfile] = [
        UserProfile(name: "Anna", age: 23, city: "Tokyo", distance: "2km", isOnline: true, bio: "喜欢旅行、咖啡和周末 city walk。", tags: ["旅行", "咖啡", "拍照"]),
        UserProfile(name: "Leo", age: 25, city: "Tokyo", distance: "5km", isOnline: true, bio: "喜欢电影、夜跑和健身。", tags: ["电影", "夜跑", "运动"]),
        UserProfile(name: "Mia", age: 22, city: "Yokohama", distance: "12km", isOnline: false, bio: "看展、摄影、音乐节爱好者。", tags: ["看展", "摄影", "音乐"])
    ]

    static var threads: [ChatThread] {
        [
            ChatThread(user: discoverProfiles[0], messages: [ChatMessage(text: "你好呀 👋", isMe: false), ChatMessage(text: "哈喽～", isMe: true)], unreadCount: 2),
            ChatThread(user: discoverProfiles[1], messages: [ChatMessage(text: "最近有看什么电影吗？", isMe: false)], unreadCount: 0),
            ChatThread(user: discoverProfiles[2], messages: [ChatMessage(text: "下次一起去看展？", isMe: false)], unreadCount: 1)
        ]
    }
}

enum StorageKey: String, CaseIterable {
    case isAuthenticated, didCompleteOnboarding, myProfile, threads, seenProfileIDs
}

final class StorageService {
    static let shared = StorageService()
    private let defaults = UserDefaults.standard
    private init() {}

    func saveBool(_ value: Bool, key: StorageKey) { defaults.set(value, forKey: key.rawValue) }
    func loadBool(key: StorageKey) -> Bool { defaults.bool(forKey: key.rawValue) }
    func save<T: Encodable>(_ value: T, key: StorageKey) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(value) { defaults.set(data, forKey: key.rawValue) }
    }
    func load<T: Decodable>(_ type: T.Type, key: StorageKey) -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    func removeAll() { StorageKey.allCases.forEach { defaults.removeObject(forKey: $0.rawValue) } }
}

@MainActor
final class AppStore: ObservableObject {
    @Published var isAuthenticated: Bool
    @Published var didCompleteOnboarding: Bool
    @Published var myProfile: MyProfile
    @Published var threads: [ChatThread]
    @Published var seenProfileIDs: Set<UUID>

    init() {
        let storage = StorageService.shared
        self.isAuthenticated = storage.loadBool(key: .isAuthenticated)
        self.didCompleteOnboarding = storage.loadBool(key: .didCompleteOnboarding)
        self.myProfile = storage.load(MyProfile.self, key: .myProfile) ?? .default
        self.threads = storage.load([ChatThread].self, key: .threads) ?? SampleData.threads
        self.seenProfileIDs = Set(storage.load([UUID].self, key: .seenProfileIDs) ?? [])
    }

    var unreadCount: Int { threads.reduce(0) { $0 + $1.unreadCount } }
    var availableProfiles: [UserProfile] { SampleData.discoverProfiles.filter { !seenProfileIDs.contains($0.id) } }

    func signIn(name: String, age: Int) {
        myProfile.displayName = name
        myProfile.age = age
        isAuthenticated = true
        persist()
    }
    func signOut() {
        StorageService.shared.removeAll()
        isAuthenticated = false
        didCompleteOnboarding = false
        myProfile = .default
        threads = SampleData.threads
        seenProfileIDs = []
    }
    func completeOnboarding() { didCompleteOnboarding = true; persist() }
    func saveMyProfile(_ profile: MyProfile) { myProfile = profile; persist() }
    func markSeen(_ user: UserProfile) { seenProfileIDs.insert(user.id); persist() }
    func resetDiscoverDeck() { seenProfileIDs = []; persist() }
    func markThreadRead(_ threadID: UUID) { if let i = threads.firstIndex(where: { $0.id == threadID }) { threads[i].unreadCount = 0; persist() } }
    func sendMessage(threadID: UUID, text: String) {
        guard let i = threads.firstIndex(where: { $0.id == threadID }) else { return }
        threads[i].messages.append(ChatMessage(text: text, isMe: true))
        threads[i].messages.append(ChatMessage(text: "不错，这个话题我也感兴趣～", isMe: false))
        threads[i].updatedAt = threads[i].messages.last?.createdAt ?? .now
        persist()
    }
    func thread(for id: UUID) -> ChatThread? { threads.first(where: { $0.id == id }) }
    private func persist() {
        let storage = StorageService.shared
        storage.saveBool(isAuthenticated, key: .isAuthenticated)
        storage.saveBool(didCompleteOnboarding, key: .didCompleteOnboarding)
        storage.save(myProfile, key: .myProfile)
        storage.save(threads, key: .threads)
        storage.save(Array(seenProfileIDs), key: .seenProfileIDs)
    }
}

enum QMColor {
    static let primary = Color(hex: "#7C5CFF")
    static let secondary = Color(hex: "#FF5FA2")
    static let background = Color(hex: "#F7F8FC")
    static let card = Color.white
    static let textPrimary = Color(hex: "#101828")
    static let textSecondary = Color(hex: "#667085")
    static let border = Color(hex: "#E6EAF2")
    static let success = Color(hex: "#22C55E")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
