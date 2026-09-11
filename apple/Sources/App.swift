import SwiftUI
import UserNotifications

@main
struct CalismaZamaniApp: App {
    init() {
        UNUserNotificationCenter.current().delegate = WebRuntime.shared.bridge
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        .defaultSize(width: 520, height: 900)
        .commands {
            CommandGroup(replacing: .newItem) { }   // "Yeni Pencere" gerekmiyor
        }
        #endif
    }
}

struct ContentView: View {
    var body: some View {
        WebHostView()
            .ignoresSafeArea()          // CSS zaten env(safe-area-inset-*) kullanıyor
            .background(Color(white: 0.95))
        #if os(macOS)
            .frame(minWidth: 360, minHeight: 520)
        #endif
    }
}
