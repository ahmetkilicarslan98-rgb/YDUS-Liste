import SwiftUI
import WebKit

#if os(iOS)
import UIKit
typealias PlatformViewRepresentable = UIViewRepresentable
#else
import AppKit
typealias PlatformViewRepresentable = NSViewRepresentable
#endif

/// Tek bir WKWebView örneği; SwiftUI yeniden çizse de sayfa baştan yüklenmesin.
final class WebRuntime: NSObject, WKNavigationDelegate {

    static let shared = WebRuntime()
    let bridge = Bridge()

    lazy var webView: WKWebView = {
        let controller = WKUserContentController()
        controller.add(bridge, name: "native")
        controller.addUserScript(WKUserScript(source: "window.__isNativeShell = true;",
                                              injectionTime: .atDocumentStart,
                                              forMainFrameOnly: true))
        if let backup = BackupStore.read() {
            controller.addUserScript(WKUserScript(source: "window.__nativeBackup = \(Self.jsString(backup));",
                                                  injectionTime: .atDocumentStart,
                                                  forMainFrameOnly: true))
        }

        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.userContentController = controller
        config.setURLSchemeHandler(AppSchemeHandler(), forURLScheme: AppSchemeHandler.scheme)
        #if os(iOS)
        config.allowsInlineMediaPlayback = true
        #endif
        config.mediaTypesRequiringUserActionForPlayback = []

        let view = WKWebView(frame: .zero, configuration: config)
        view.navigationDelegate = self
        view.allowsBackForwardNavigationGestures = false
        #if os(iOS)
        view.scrollView.bounces = false
        view.scrollView.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.078, green: 0.102, blue: 0.086, alpha: 1)   // #141A16
                : UIColor(red: 0.953, green: 0.933, blue: 0.886, alpha: 1)   // #F3EEE2
        }
        view.isOpaque = false
        #endif
        bridge.webView = view
        view.load(URLRequest(url: AppSchemeHandler.startURL))
        return view
    }()

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(
            "window.__nativeReady && window.__nativeReady()", completionHandler: nil)
    }

    /// Swift metnini güvenli bir JS dizgesine çevirir.
    private static func jsString(_ text: String) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: [text]),
              var literal = String(data: data, encoding: .utf8) else { return "\"\"" }
        literal.removeFirst()   // [
        literal.removeLast()    // ]
        return literal
    }
}

struct WebHostView: PlatformViewRepresentable {
    #if os(iOS)
    func makeUIView(context: Context) -> WKWebView { WebRuntime.shared.webView }
    func updateUIView(_ view: WKWebView, context: Context) { }
    #else
    func makeNSView(context: Context) -> WKWebView { WebRuntime.shared.webView }
    func updateNSView(_ view: WKWebView, context: Context) { }
    #endif
}
