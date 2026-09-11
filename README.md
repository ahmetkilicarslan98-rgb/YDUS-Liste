# YDUS-Liste

YDUS hazırlığı için iki bağımsız web aracı. İkisi de tek başına çalışır, sunucu gerektirmez,
veriyi yalnızca açtığın cihazın tarayıcısında (localStorage) saklar.

| Dosya | Ne işe yarar |
|---|---|
| `calisma_listesi.html` | Ders/kitap bazlı çalışma adımı takip listesi |
| `zamanlayici.html` | **Çalışma Zamanı**: Pomodoro + kronometre, gün içi süre takibi ve istatistikler |

## Çalışma Zamanı

- **Pomodoro**: odak, kısa mola ve uzun mola süreleri hem zamanlayıcı ekranındaki
  +/- düğmelerinden hem de Ayarlar sekmesinden değiştirilir. 25/5, 50/10 ve 90/20 hazır
  kalıpları tek dokunuşla uygulanır, uzun mola aralığı seçilir, süre bitince otomatik
  geçiş açılabilir. İşleyen bir faz, üzerinden geçen sürenin altına çekilemez.
- **Kronometre**: açık uçlu çalışma veya mola ölçümü.
- **Ders seçimi**: çalışma süresi seçtiğin derse yazılır, molalar derse yazılmaz.
  Hazır liste, çalışma listesindeki on beş başlığa ek olarak Genel, Tez ve Araştırma
  içerir; ayarlardan yeniden adlandırılır, gizlenir veya silinir. Hazır listeye sonradan
  eklenen başlıklar kurulu cihazlara bir kez taşınır, kullanıcı silerse geri gelmez.
- **Bugün**: toplam çalışma, toplam mola, seans sayısı, odak oranı ve günlük hedef çubuğu.
- **Elle seans**: zamanlayıcı çalıştırılmadan geçen süre tarih, saat ve dakika girilerek
  eklenir. İstatistik sekmesinin gün görünümündeki liste, o günün seanslarını sıralar;
  bir seansa dokunarak süresi, saati veya dersi düzeltilir, yanlış kayıt silinir.
  Elle girilen kayıtlar listede işaretlenir. Gelecek zamanlı kayıt kabul edilmez.
- **İstatistik**: gün, hafta, ay, yıl görünümleri, saat/gün/ay kırılımlı grafik,
  ders dağılımı, yıllık ısı haritası, en verimli gün, hedefi tutturulan gün sayısı.
- **Seri (streak)**: en az 10 dakika çalışılan ardışık günler. Gün bitmeden seri bozulmaz.
- **Uyarılar**: zil sesi, titreşim, bildirim ve sayaç çalışırken ekranı açık tutma (Wake Lock).
- **Veri**: JSON olarak yedek alma, panoya kopyalama ve geri yükleme. Kayıt birikmişken
  30 gün yedek alınmadıysa zamanlayıcı ekranında uyarı şeridi çıkar.
- **Arka plan**: sayaç zaman damgası üzerinden yürür. Uygulama kapalıyken dolan faz,
  açılışta gerçek bitiş saatiyle kaydedilir ve ekranda bildirilir.

## Telefona kurmak (PWA)

Çalışma Zamanı bir Progressive Web App olarak paketlendi (`manifest.webmanifest` + `sw.js`).
Ana ekrana kurulabilmesi ve çevrimdışı açılabilmesi için dosyaların `https://` üzerinden
sunulması gerekir; `file://` ile açıldığında uygulama çalışır ama kurulum ve çevrimdışı
önbellek devreye girmez.

En kolay yol GitHub Pages:

1. Repo ayarlarında **Settings → Pages → Source: Deploy from a branch**, branch olarak `main` ve klasör `/ (root)` seç.
2. Birkaç dakika sonra `https://<kullanici-adi>.github.io/YDUS-Liste/zamanlayici.html` adresini telefonda aç.
3. **Android / Chrome**: menü → "Uygulamayı yükle" veya "Ana ekrana ekle".
   **iPhone / Safari**: paylaş simgesi → "Ana Ekrana Ekle".

Ana ekrandaki uygulama adı "Çalışma Zamanı" olarak gelir. iOS uzun adları kısaltabilir;
"Ana Ekrana Ekle" ekranında ad alanına dokunup istediğin şekilde kısaltabilirsin.
Dosya adı `zamanlayici.html` olarak kaldı, böylece mevcut kısayollar ve adres bozulmuyor.

Ana ekran ikonu yeşil zemin üzerinde bej bir kum saatidir; kaynak çizim `icon.svg`
dosyasında, PNG boyutları ondan üretilmiştir (iOS için 180/167/152, Android için 192/512
ve maskable 512). iOS ikonu bir kez önbelleğe alır: ikon değişirse ana ekrandaki kısayolu
silip yeniden eklemek gerekir.

Kurulumdan sonra uygulama tam ekran açılır ve internet olmadan da çalışır.

## Notlar

- Veriler cihazda tutulur, cihazlar arasında eşitlenmez. Telefon değiştirirken
  Ayarlar → Veri → **Yedek al** ile JSON indir, yeni cihazda **Yedekten yükle**.
- Verinin silindiği durumlar: Ayarlar → Safari → Geçmişi ve Web Sitesi Verilerini Sil,
  Safari → Gelişmiş → Web Sitesi Verileri'nden siteyi kaldırmak, telefonu sıfırlamak,
  ana ekrandaki kısayolu silmek. Web sitesi verisi iCloud yedeğine girmez.
- Safari sekmesi olarak kullanılırsa WebKit, etkileşim görmeyen sitenin verisini yedi günlük
  Safari kullanımı sonunda siler. Ana ekrana eklenmiş uygulamalar bu kuraldan muaftır,
  bu yüzden her zaman ana ekran kısayolundan girmek gerekir.
- Telefon kilitliyken tarayıcı sayacı askıya alınabilir; uyarı o anda değil uygulama
  açıldığında gelir. Süre yine doğru hesaplanır.
- Bildirim izni ve ekranı açık tutma özelliği tarayıcıya göre değişir; iOS'ta bildirim için
  uygulamanın ana ekrana eklenmiş olması gerekir.
