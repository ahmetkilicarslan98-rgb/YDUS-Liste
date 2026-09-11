# YDUS-Liste

YDUS hazırlığı için iki bağımsız web aracı. İkisi de tek başına çalışır, sunucu gerektirmez,
veriyi yalnızca açtığın cihazın tarayıcısında (localStorage) saklar.

| Dosya | Ne işe yarar |
|---|---|
| `calisma_listesi.html` | Ders/kitap bazlı çalışma adımı takip listesi |
| `zamanlayici.html` | Pomodoro + kronometre, gün içi süre takibi ve istatistikler |

## Zamanlayıcı

- **Pomodoro**: odak, kısa mola ve uzun mola süreleri hem zamanlayıcı ekranındaki
  +/- düğmelerinden hem de Ayarlar sekmesinden değiştirilir. 25/5, 50/10 ve 90/20 hazır
  kalıpları tek dokunuşla uygulanır, uzun mola aralığı seçilir, süre bitince otomatik
  geçiş açılabilir. İşleyen bir faz, üzerinden geçen sürenin altına çekilemez.
- **Kronometre**: açık uçlu çalışma veya mola ölçümü.
- **Ders seçimi**: çalışma süresi seçtiğin derse yazılır, molalar derse yazılmaz.
  Ders listesi ayarlardan düzenlenir.
- **Bugün**: toplam çalışma, toplam mola, seans sayısı, odak oranı ve günlük hedef çubuğu.
- **İstatistik**: gün, hafta, ay, yıl görünümleri, saat/gün/ay kırılımlı grafik,
  ders dağılımı, yıllık ısı haritası, en verimli gün, hedefi tutturulan gün sayısı.
- **Seri (streak)**: en az 10 dakika çalışılan ardışık günler. Gün bitmeden seri bozulmaz.
- **Uyarılar**: zil sesi, titreşim, bildirim ve sayaç çalışırken ekranı açık tutma (Wake Lock).
- **Veri**: JSON olarak yedek alma ve geri yükleme.

## Telefona kurmak (PWA)

Zamanlayıcı bir Progressive Web App olarak paketlendi (`manifest.webmanifest` + `sw.js`).
Ana ekrana kurulabilmesi ve çevrimdışı açılabilmesi için dosyaların `https://` üzerinden
sunulması gerekir; `file://` ile açıldığında uygulama çalışır ama kurulum ve çevrimdışı
önbellek devreye girmez.

En kolay yol GitHub Pages:

1. Repo ayarlarında **Settings → Pages → Source: Deploy from a branch**, branch olarak `main` ve klasör `/ (root)` seç.
2. Birkaç dakika sonra `https://<kullanici-adi>.github.io/YDUS-Liste/zamanlayici.html` adresini telefonda aç.
3. **Android / Chrome**: menü → "Uygulamayı yükle" veya "Ana ekrana ekle".
   **iPhone / Safari**: paylaş simgesi → "Ana Ekrana Ekle".

Kurulumdan sonra uygulama tam ekran açılır ve internet olmadan da çalışır.

## Notlar

- Veriler cihazda tutulur, cihazlar arasında eşitlenmez. Telefon değiştirirken
  Ayarlar → Veri → **Yedek al** ile JSON indir, yeni cihazda **Yedekten yükle**.
- Tarayıcı verilerini silmek kayıtları da siler.
- Bildirim izni ve ekranı açık tutma özelliği tarayıcıya göre değişir; iOS'ta bildirim için
  uygulamanın ana ekrana eklenmiş olması gerekir.
