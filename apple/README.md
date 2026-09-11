# Çalışma Zamanı — iOS ve Mac uygulaması

Bu klasör, depo kökündeki `zamanlayici.html` dosyasını native bir kabuğun içinde çalıştırır.
Arayüz aynı HTML'dir; kabuk yalnızca işletim sistemiyle konuşması gereken işleri üstlenir:

- **Alarm**: faz bitişi `UNUserNotificationCenter` ile yerel bildirim olarak kaydedilir.
  Uygulama kapalıyken ve telefon kilitliyken de çalar.
- **Yedek**: her kayıt değişikliğinde JSON, uygulamanın Application Support klasörüne
  ikinci bir kopya olarak yazılır. WKWebView deposu boş açılırsa veri buradan geri yüklenir.
- **Ekranı açık tutma** (iOS) ve **dokunsal geri bildirim** (iOS).

Web tarafı kabuğu `window.webkit.messageHandlers.native` üzerinden tanır. Tarayıcıda
bu köprü yoktur ve uygulama eskisi gibi çalışır; yani tek bir HTML dosyası üç ortamı birden besler.

## Gereken

- macOS ve Xcode 15 veya üzeri
- [XcodeGen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`
- Apple kimliği (ücretsiz olan da olur, sınırları aşağıda)

## Kurulum

```bash
git clone https://github.com/ahmetkilicarslan98-rgb/YDUS-Liste.git
cd YDUS-Liste/apple
xcodegen generate
open CalismaZamani.xcodeproj
```

Xcode açıldıktan sonra her iki hedef için de **Signing & Capabilities** sekmesinde
**Team** alanını kendi Apple kimliğinle doldur. `PRODUCT_BUNDLE_IDENTIFIER` başkası
tarafından kullanılıyorsa `project.yml` içinde değiştirip `xcodegen generate` komutunu tekrarla.

- **Mac**: şema olarak `CalismaZamani-macOS` seç, Run. Uygulama `/Applications` klasörüne
  kopyalanabilir, süre sınırı yoktur.
- **iPhone**: telefonu kabloyla bağla, şema olarak `CalismaZamani-iOS` ve cihazını seç, Run.
  İlk çalıştırmada telefonda **Ayarlar → Genel → VPN ve Aygıt Yönetimi** altından
  geliştirici sertifikasına güvenmen gerekir.

## Ücretsiz Apple kimliğinin sınırları

| | Ücretsiz kimlik | Developer Program (yılda 99 USD) |
|---|---|---|
| Mac uygulaması | Süresiz çalışır | Süresiz çalışır |
| iPhone uygulaması | 7 günde bir yeniden kurulmalı | 1 yıl geçerli |
| TestFlight | Yok | Var |
| iCloud ile cihazlar arası eşitleme | Yok | Var |

Yeniden kurma işlemi veriyi silmez; aynı paket kimliğiyle üzerine kurulum yapıldığında
kayıtlar yerinde kalır. Uygulamayı telefondan silersen veri de gider, bu yüzden
uygulama içinden düzenli yedek al.

## Dosyalar

| Dosya | İşi |
|---|---|
| `project.yml` | XcodeGen tanımı, iki hedef ve gömülen web dosyaları |
| `Sources/App.swift` | SwiftUI giriş noktası ve pencere |
| `Sources/WebHost.swift` | Tek WKWebView örneği, köprü ve yedek enjeksiyonu |
| `Sources/AppScheme.swift` | `czapp://local/...` şeması, dosyaları paketten sunar |
| `Sources/Bridge.swift` | JS'ten gelen komutlar: alarm, yedek, ekran, titreşim |
| `Sources/BackupStore.swift` | Application Support içindeki JSON kopyası |

`file://` yerine özel şema kullanılmasının sebebi, WKWebView'in `file://` kökeninde
localStorage'ı kalıcı tutmamasıdır.

## Web tarafını değiştirmek

`zamanlayici.html` tek kaynaktır. Değiştirdiğinde web sürümü GitHub Pages üzerinden,
uygulamalar ise yeniden derlendiğinde güncellenir. Xcode projesinde dosya kopyası
tutulmaz, doğrudan depo kökündeki dosya paketlenir.
