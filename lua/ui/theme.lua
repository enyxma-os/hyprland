-- =====================================================
-- enyxma arayüz ve görünüm modülü
-- Boşluklar kenarlık renkler yerleşim ve animasyonlar
-- =====================================================

-- Genel görünüm ayarları
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(7aa2f7ee)", "rgba(bb9af7ee)" }, angle = 45 },
            inactive_border = "rgba(3b4261aa)",
        },

        resize_on_border = true,
        allow_tearing    = false,

        layout = "dwindle",
    },
})

-- Süsleme ayarları
hl.config({
    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 0.95,

        shadow = {
            enabled      = true,
            range        = 8,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled  = true,
            size     = 4,
            passes   = 2,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Yumuşak hareket eğrileri
hl.curve("enyxmaSmooth",     { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1 } } })
hl.curve("enyxmaTransition", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("enyxmaFast",       { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("enyxmaLinear",     { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("enyxmaSpring",     { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

-- Animasyon yaprakları
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "enyxmaLinear" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "enyxmaSmooth" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, spring = "enyxmaSpring" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  spring = "enyxmaSpring", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "enyxmaLinear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "enyxmaLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "enyxmaLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "enyxmaFast" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "enyxmaSmooth" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "enyxmaSmooth", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "enyxmaLinear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "enyxmaLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "enyxmaLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "enyxmaLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "enyxmaLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "enyxmaLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "enyxmaFast" })

-- =====================================================
-- DWINDLE YERLEŞİMİ
-- =====================================================

-- force_split değeri 2 yeni pencerenin her zaman sağa veya alta bölünmesini sağlar
-- preserve_split bölünme yönünü korur
-- Bu iki ayar pencerelerin üst üste binmesini engeller
hl.config({
    dwindle = {
        force_split    = 2,
        preserve_split = true,
        smart_split    = false,
        smart_resizing = true,
    },
})

-- Usta yerleşimi için yeni pencere konumu
hl.config({
    master = {
        new_status = "master",
    },
})

-- Kaydırma yerleşimi için tek sütunda tam ekran davranışı
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

-- Akıllı boşluk kuralı
-- Tek pencere kaldığında boşluklar kaldırılır
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })

-- Çeşitli ayarlar
hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = true,
    },
})
