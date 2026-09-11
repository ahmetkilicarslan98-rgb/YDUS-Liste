import Foundation
import WebKit

/// Web dosyalarını uygulama paketinden özel bir şema üzerinden sunar.
/// file:// yerine gerçek bir origin gerekiyor, yoksa WKWebView localStorage'ı kalıcı tutmuyor.
final class AppSchemeHandler: NSObject, WKURLSchemeHandler {

    static let scheme = "czapp"
    static let host = "local"
    static let startPage = "zamanlayici.html"

    static var startURL: URL {
        URL(string: "\(scheme)://\(host)/\(startPage)")!
    }

    func webView(_ webView: WKWebView, start task: WKURLSchemeTask) {
        guard let url = task.request.url else {
            task.didFailWithError(URLError(.badURL))
            return
        }

        var name = url.path
        if name.hasPrefix("/") { name.removeFirst() }
        if name.isEmpty { name = Self.startPage }

        guard let fileURL = Bundle.main.url(forResource: name, withExtension: nil),
              let data = try? Data(contentsOf: fileURL) else {
            let response = HTTPURLResponse(url: url, statusCode: 404,
                                           httpVersion: "HTTP/1.1", headerFields: nil)!
            task.didReceive(response)
            task.didFinish()
            return
        }

        let headers = [
            "Content-Type": Self.mimeType(for: (name as NSString).pathExtension),
            "Content-Length": String(data.count),
            "Cache-Control": "no-store"
        ]
        let response = HTTPURLResponse(url: url, statusCode: 200,
                                       httpVersion: "HTTP/1.1", headerFields: headers)!
        task.didReceive(response)
        task.didReceive(data)
        task.didFinish()
    }

    func webView(_ webView: WKWebView, stop task: WKURLSchemeTask) { }

    private static func mimeType(for ext: String) -> String {
        switch ext.lowercased() {
        case "html", "htm":     return "text/html; charset=utf-8"
        case "js", "mjs":       return "text/javascript; charset=utf-8"
        case "css":             return "text/css; charset=utf-8"
        case "json":            return "application/json; charset=utf-8"
        case "webmanifest":     return "application/manifest+json; charset=utf-8"
        case "svg":             return "image/svg+xml"
        case "png":             return "image/png"
        case "jpg", "jpeg":     return "image/jpeg"
        case "ico":             return "image/x-icon"
        case "woff2":           return "font/woff2"
        default:                return "application/octet-stream"
        }
    }
}
