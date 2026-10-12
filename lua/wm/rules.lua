-- =====================================================
-- enyxma pencere kuralları
-- Güncel Lua kural sözdizimi kullanılır
-- =====================================================

-- Tüm uygulamalardan gelen büyütme istekleri yok sayılır
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- XWayland sürükleme sorunlarını giderir
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
    match = { class = "^(pinentry|pinentry-gtk-2|pinentry-qt|pinentry-gnome3|hyprpolkitagent)$" },

    float  = true,
    center = true,
})

-- Dosya seçme pencereleri yüzer konumda ve orantılı boyutta açılır
hl.window_rule({
    name  = "file-pickers-floating",
    match = {
        class = "^(xdg-desktop-portal-gtk|xdg-desktop-portal-kde|org.gnome.Nautilus)$",
        title = "^(Open|Save|Save As|Select|Choose).*",
    },

    float  = true,
    size   = { "monitor_w*0.55", "monitor_h*0.65" },
    center = true,
})

-- Resim içinde resim penceresi imlecin yanında açılır ve sabitlenir
hl.window_rule({
    name  = "picture-in-picture-floating",
    match = { title = "^Picture-in-Picture$" },

    float = true,
    pin   = true,
    move  = { "cursor_x-(window_w*0.5)", "cursor_y-(window_h*0.5)" },
})

-- Uçlar için hafif saydamlık
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

-- Katman kuralları da bir tanıtıcı döndürür
-- Alan seçim katmanında animasyon kapatılır
hl.layer_rule({
    name  = "selection-layer-no-anim",
    match = { namespace = "^selection$" },

    no_anim = true,
})
