import SwiftUI

@main
struct QuickMeetApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var store = AppStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(store)
        }
    }
}
