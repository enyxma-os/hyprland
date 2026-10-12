# Enyxma Hyprland

Hyprland 0.56 ve üzeri sürümler için saf Lua ile yazılmış bağımsız ve evrensel pencere yöneticisi yapılandırması.

---

## Mimari Özellikler

- **Saf Lua Standardı:** Tüm yapılandırma Hyprland C++ Lua bağlayıcıları üzerinde çalışır. Harici eski yapılandırma dosyasına ihtiyaç duymaz.
- **Donanım Bağımsız:** Sabit ekran kartı yolu veya sabit çıkış adı içermez. Sanal makinede yazılım imlecine, fiziksel donanımda ise yüksek yenileme hızına otomatik uyum sağlar.
- **Akıllı Döşeme:** Dwindle split değeri ile pencerelerin üst üste binmesini önler, her yeni pencereyi sağa veya alta doğru akıllı spiral düzeninde açar.
- **Evrensel Uygulama Zinciri:** Sistemde kurulu uçbirim, dosya yöneticisi ve menüyü otomatik tespit eder. Eksik uygulama durumunda oturum çökmez.

---

## Dizin Yapısı

```text
.
├── Justfile               # Yönetim ve doğrulama komutları
├── README.md              # Belgelendirme
├── hyprland.lua           # Ana giriş noktası ve güvenli modül yükleyici
└── lua
    ├── core
    │   ├── autostart.lua  # Arka plan servisleri ve ortam değişkenleri
    │   └── hardware.lua   # Donanım, ekran, Türkçe klavye ve imleç
    ├── ui
    │   └── theme.lua      # Renkler, yay eğrileri, animasyonlar ve dwindle
    └── wm
        ├── binds.lua      # Kısayollar, fare hareketleri, ekran görüntüsü ve pano
        └── rules.lua      # Pencere kuralları ve katman ayarları
```

---

## Kısayol Referansı

### Uygulamalar ve Sistem

| Tuş | İşlev |
| :--- | :--- |
| SUPER + Return | Uçbirim çalıştır |
| SUPER + Q | Aktif pencereyi kapat |
| SUPER + SHIFT + Q | Pencereyi zorla sonlandır |
| SUPER + E | Dosya yöneticisini aç |
| SUPER + R | Uygulama başlatıcısını aç |
| SUPER + W | Web tarayıcısını aç |
| SUPER + L | Ekranı kilitle |
| SUPER + SHIFT + V | Pano geçmişi menüsünü aç |
| SUPER + SHIFT + R | Hyprland yapılandırmasını yeniden yükle |
| SUPER + SHIFT + E | Oturumdan çıkış yap |

### Ekran Görüntüsü

| Tuş | İşlev |
| :--- | :--- |
| Print | Tam ekran görüntüsü al ve panoya kopyala |
| SHIFT + Print | Seçilen alan görüntüsü al ve panoya kopyala |
| SUPER + Print | Seçilen alan görüntüsü al ve panoya kopyala |

### Pencere Yönetimi

| Tuş | İşlev |
| :--- | :--- |
| SUPER + F | Tam ekran durumunu değiştir |
| SUPER + SHIFT + F | En büyük boyuta getir |
| SUPER + V | Yüzen pencere durumunu değiştir |
| SUPER + P | Sahte döşeme durumuna geç |
| SUPER + J | Bölünme yönünü değiştir |
| SUPER + Tab | Sonraki pencereye odaklan |
| SUPER + C | Pencereyi ekranda ortala |

### Yön Tuşları ile Odak ve Boyut

| Tuş | İşlev |
| :--- | :--- |
| SUPER + Yön Tuşları | Pencere odağını değiştir |
| SUPER + SHIFT + Yön Tuşları | Pencereyi o yöne taşı |
| SUPER + CTRL + Yön Tuşları | Pencerelerin yerini değiştir |
| SUPER + SHIFT + CTRL + Yön Tuşları | Pencereyi o yönde boyutlandır |

### Çoklu Ekran

| Tuş | İşlev |
| :--- | :--- |
| SUPER + virgül | Önceki monitöre odaklan |
| SUPER + nokta | Sonraki monitöre odaklan |
| SUPER + SHIFT + virgül | Pencereyi önceki monitöre taşı |
| SUPER + SHIFT + nokta | Pencereyi sonraki monitöre taşı |

### Çalışma Alanları

| Tuş | İşlev |
| :--- | :--- |
| SUPER + 1..9, 0 | Belirtilen çalışma alanına geç |
| SUPER + SHIFT + 1..9, 0 | Pencereyi çalışma alanına taşı |
| SUPER + S | Özel çalışma alanını aç veya kapat |
| SUPER + SHIFT + S | Pencereyi özel çalışma alanına gönder |
| SUPER + Fare Tekerleği | Çalışma alanları arasında sırayla gez |

### Fare İşlemleri

| Tuş | İşlev |
| :--- | :--- |
| SUPER + Fare Sol | Pencereyi sürükle |
| SUPER + Fare Sağ | Pencereyi boyutlandır |

---

## Kurulum

Yapılandırmayı doğrudan kullanıcı ev dizinine bağlamak için:

```bash
git clone https://codeberg.org/enyxma/hyprland ~/.config/hypr
```

Gerekli tüm modüller dinamik yollar üzerinden çözümlendiği için ek yol ayarı gerekmez.

---

## Yönetim Komutları

Depo içinde `just` aracıyla şu görevler çalıştırılabilir:

```bash
just check     # Lua sözdizimini test eder
just reload    # Yerel Hyprland oturumunu tazeler
just sync      # Testleri çalıştırır ve depoya gönderir
```
