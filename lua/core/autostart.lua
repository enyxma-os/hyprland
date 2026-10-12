-- =====================================================
-- enyxma otomatik başlatma modülü
-- Temel arka plan servisleri burada başlatılır
-- Kurulu olmayan servisler sessizce atlanır
-- =====================================================

-- Kurulu olan ilk servisi başlatan kabuk zinciri oluşturulur
local function build_service_chain(candidates)
    local parts = {}
    for _, binary_name in ipairs(candidates) do
        parts[#parts + 1] = "( command -v " .. binary_name .. " >/dev/null 2>&1 && " .. binary_name .. " )"
    end
    parts[#parts + 1] = "true"
    return table.concat(parts, " || ")
end

-- Başlatma olayı dinlenir
hl.on("hyprland.start", function()
    -- Masaüstü oturum değişkenleri D-Bus ortamına aktarılır
    -- Portallar ve diğer servisler bu değişkenlere ihtiyaç duyar
    hl.exec_cmd("command -v dbus-update-activation-environment >/dev/null 2>&1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP")

    -- Bildirim servisi
    hl.exec_cmd(build_service_chain({ "dunst", "mako", "swaync", "fnott" }))

    -- Durum çubuğu
    hl.exec_cmd(build_service_chain({ "waybar", "quickshell", "ironbar" }))

    -- Duvar kağıdı
    hl.exec_cmd(build_service_chain({ "hyprpaper", "swaybg" }))

    -- Güç yönetimi ve ekran kilidi zamanlayıcısı
    hl.exec_cmd(build_service_chain({ "hypridle", "swayidle" }))

    -- Yetki istemcisi
    hl.exec_cmd(build_service_chain({ "hyprpolkitagent", "polkit-gnome-authentication-agent-1", "lxpolkit" }))

    -- Pano geçmişi
    hl.exec_cmd("command -v cliphist >/dev/null 2>&1 && command -v wl-paste >/dev/null 2>&1 && wl-paste --watch cliphist store")

    -- Masaüstü portalı
    hl.exec_cmd("command -v xdg-desktop-portal-hyprland >/dev/null 2>&1 && xdg-desktop-portal-hyprland")

    -- Dizilim göstergesi
    hl.exec_cmd("command -v hyprctl >/dev/null 2>&1 && hyprctl setcursor Adwaita 24")
end)
