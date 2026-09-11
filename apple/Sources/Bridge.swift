import Foundation
import WebKit
import UserNotifications

#if os(iOS)
import UIKit
#endif

/// Web tarafı ile native taraf arasındaki tek kapı.
/// JS: window.webkit.messageHandlers.native.postMessage({action: "...", ...})
final class Bridge: NSObject, WKScriptMessageHandler, UNUserNotificationCenterDelegate {

    static let alarmID = "faz-bitisi"
    weak var webView: WKWebView?

    // MARK: - JS -> native

    func userContentController(_ controller: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any],
              let action = body["action"] as? String else { return }

        switch action {
        case "persist":
            if let json = body["json"] as? String { BackupStore.write(json) }

        case "scheduleAlarm":
            let ms = (body["ms"] as? Double) ?? 0
            let title = (body["title"] as? String) ?? "Süre doldu"
            let text = (body["body"] as? String) ?? ""
            scheduleAlarm(after: ms / 1000.0, title: title, body: text)

        case "cancelAlarm":
            cancelAlarm()

        case "requestNotify":
            requestAuthorization { granted in self.reportNotifyState(granted) }

        case "keepAwake":
            setKeepAwake((body["on"] as? Bool) ?? false)

        case "haptic":
            playHaptic()

        case "ready":
            UNUserNotificationCenter.current().getNotificationSettings { s in
                self.reportNotifyState(s.authorizationStatus == .authorized)
            }

        default:
            break
        }
    }

    // MARK: - Bildirim

    private func requestAuthorization(_ done: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    DispatchQueue.main.async { done(granted) }
                }
            case .denied:
                DispatchQueue.main.async { done(false) }
            default:
                DispatchQueue.main.async { done(true) }
            }
        }
    }

    private func scheduleAlarm(after seconds: TimeInterval, title: String, body: String) {
        let delay = max(1, seconds)
        requestAuthorization { granted in
            guard granted else { return }
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
            let request = UNNotificationRequest(identifier: Bridge.alarmID,
                                                content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [Bridge.alarmID])
            center.add(request)
        }
    }

    private func cancelAlarm() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [Bridge.alarmID])
        center.removeDeliveredNotifications(withIdentifiers: [Bridge.alarmID])
    }

    private func reportNotifyState(_ granted: Bool) {
        DispatchQueue.main.async {
            self.webView?.evaluateJavaScript(
                "window.__nativeNotify && window.__nativeNotify(\(granted ? "true" : "false"))",
                completionHandler: nil)
        }
    }

    /// Uygulama öndeyken web tarafı zaten zil çalıyor, bildirimi bastır.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler:
                                   @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([])
    }

    // MARK: - Ekran ve titreşim

    private func setKeepAwake(_ on: Bool) {
        #if os(iOS)
        DispatchQueue.main.async { UIApplication.shared.isIdleTimerDisabled = on }
        #endif
    }

    private func playHaptic() {
        #if os(iOS)
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
        #endif
    }
}
