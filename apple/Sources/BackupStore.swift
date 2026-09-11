import Foundation

/// Kayıtların ikinci kopyası. WKWebView deposu bozulsa veya boş açılsa bile
/// veri buradan geri yüklenir. Dosya uygulamanın kendi klasöründe durur,
/// iCloud yedeğine dahildir.
enum BackupStore {

    private static let fileName = "state.json"

    private static var folder: URL? {
        guard let base = FileManager.default.urls(for: .applicationSupportDirectory,
                                                  in: .userDomainMask).first else { return nil }
        let dir = base.appendingPathComponent("CalismaZamani", isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    static var fileURL: URL? { folder?.appendingPathComponent(fileName) }

    static func write(_ json: String) {
        guard let url = fileURL, let data = json.data(using: .utf8) else { return }
        try? data.write(to: url, options: .atomic)
    }

    static func read() -> String? {
        guard let url = fileURL,
              let data = try? Data(contentsOf: url),
              let text = String(data: data, encoding: .utf8),
              !text.isEmpty else { return nil }
        return text
    }
}
