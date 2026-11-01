-- =====================================================
-- enyxma pencere ve katman kuralları Rules
-- Hyprland 0.56+ Pure Lua API
-- Pencere davranışları, opasite, sistem float ve Enyxma Shell blur katmanları
-- =====================================================

-- ═══════════════════════════════════════════
-- 1. TEMEL PENCERE KURALLARI Declarative API
-- ═══════════════════════════════════════════

-- Tüm uygulamalardan gelen sahte büyütme istekleri yok sayılır
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- XWayland sürükleme ve hayalet odak sorunlarını giderir
hl.window_rule({
    name  = "fix-xwayland-drag-drop",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Akıllı boşluk kurallarına eşlik eden kenarlık sıfırlama
hl.window_rule({
    name  = "collapsed-window-borders",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding    = 0,
})

hl.window_rule({
    name  = "single-window-borders",
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding    = 0,
})

-- Kimlik doğrulama pencereleri her zaman yüzer konumda açılır
hl.window_rule({
    name  = "auth-dialogs-floating",
    match = { class = "^(pinentry|pinentry-gtk-2|pinentry-qt|pinentry-gnome3|hyprpolkitagent|org.kde.polkit-kde-authentication-agent-1)$" },
    float  = true,
    center = true,
})

-- Dosya seçme ve sistem paylaşım pencereleri yüzer konumda açılır
hl.window_rule({
    name  = "file-pickers-floating",
    match = {
        class = "^(xdg-desktop-portal-gtk|xdg-desktop-portal-kde|org.gnome.Nautilus|hyprland-share-picker)$",
        title = "^(Open|Save|Save As|Select|Choose).*",
    },
    float  = true,
    size   = { "monitor_w*0.55", "monitor_h*0.65" },
    center = true,
})

-- Resim içinde resim penceresi imlecin yanında açılır ve sabitlenir
hl.window_rule({
    name  = "picture-in-picture-floating",
    match = { title = "^(Picture-in-Picture|Picture in picture)$" },
    float = true,
    pin   = true,
    move  = { "cursor_x-(window_w*0.5)", "cursor_y-(window_h*0.5)" },
})

-- Uçbirimler için hafif saydamlık
hl.window_rule({
    name  = "terminal-opacity",
    match = { class = "^(kitty|foot|alacritty|wezterm|konsole)$" },
    opacity = "0.96 0.88",
})

-- Hyprland çalıştır penceresi
hl.window_rule({
    name  = "hyprland-run-floating",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- Alan seçim katmanında animasyon kapatılır
hl.layer_rule({
    name  = "selection-layer-no-anim",
    match = { namespace = "^selection$" },
    no_anim = true,
})

-- ═══════════════════════════════════════════
-- 2. GELİŞMİŞ PENCERE VE KATMAN KURALLARI hl.config
-- ═══════════════════════════════════════════
hl.config({
    windowrulev2 = {
        -- Sistem Araçları ve Ayar Yöneticileri Otomatik Float
        "float, class:^(pavucontrol)$",
        "float, class:^(blueman-manager)$",
        "float, class:^(.blueman-manager-wrapped)$",
        "float, class:^(nm-connection-editor)$",
        "float, class:^(org.gnome.Calculator)$",
        "float, class:^(imv)$",
        "float, class:^(mpv)$",

        -- Dosya İşlem ve Değiştirme Onay Pencereleri
        "float, title:^(Confirm to replace files)$",
        "float, title:^(File Operation Progress)$",

        -- Steam Diyalogları Ana vitrin tile, popup/sohbet float
        "float, class:^(steam)$",
        "tile, class:^(steam)$, title:^(Steam)$",

        -- Geliştirici Ortamı Opasitesi Glassmorphism Derinliği
        "opacity 0.95 0.90, class:^(code)$",
        "opacity 0.95 0.90, class:^(Code)$",
        "opacity 0.95 0.90, class:^(codium)$",
        "opacity 0.95 0.90, class:^(vscodium)$",
        "opacity 0.95 0.90, class:^(antigravity-ide)$",

        -- Tam Ekranda Boşta Kalma Kilidini Önle Film ve Oyun Koruması
        "idleinhibit fullscreen, fullscreen:1",
    },

    -- ═══════════════════════════════════════════
    -- 3. ENYXMA SHELL KATMAN KURALLARI Blur & Animasyonlar
    -- ═══════════════════════════════════════════
    layerrule = {
        -- Tüm Enyxma Shell pencerelerine donanımsal çift-geçişli blur ve kenar koruması
        "blur, ^(enyxma-.*)$",
        "ignorezero, ^(enyxma-.*)$",

        -- Enyxma Bar Üst durum çubuğu
        "animation slide top, enyxma-bar",

        -- Enyxma Control Center & AI Sidebar Sağdan akıcı kayma
        "animation slide right, enyxma-cc",
        "animation slide right, enyxma-ai",

        -- Enyxma Omni Launcher Merkezden yumuşak büyüme
        "animation popin 80%, enyxma-launcher",

        -- Tanzaku Wallpaper & Media Browser Önizleme geçişleri
        "animation popin 85%, enyxma-wallpaper-picker",
        "animation popin 85%, enyxma-media-browser",

        -- Bildirimler ve OSD Katmanları Hafif kararma/belirme
        "animation fade, enyxma-notifications",
        "animation fade, enyxma-notify",
        "animation fade, enyxma-osd",

        -- Enyxma Shot & Mockup Stüdyosu
        "animation fade, enyxma-shot",

        -- Enyxma Overview Mission Control pencere genel bakışı
        "animation fade, enyxma-overview",
    },
})
