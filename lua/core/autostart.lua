-- =====================================================
-- enyxma otomatik başlatma modülü
-- Temel arka plan servisleri burada başlatılır
-- Enyxma Shell ve Wayland oturum standartlarıyla tam uyumludur
-- =====================================================

-- Başlatma olayı dinlenir
hl.on("hyprland.start", function()
    -- 1. UWSM oturumunu hazır işaretle → graphical-session.target aktifleşir
    -- Bu çağrı olmadan systemd user servisleri quickshell, cliphist ve benzeri servisler başlayamaz
    hl.exec_cmd("command -v uwsm >/dev/null 2>&1 && uwsm finalize")

    -- 2. Masaüstü oturum değişkenleri D-Bus ve systemd ortamına aktarılır
    hl.exec_cmd("command -v dbus-update-activation-environment >/dev/null 2>&1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP")

    -- 3. Enyxma Shell masaüstü kabuğu
    -- Systemd user servisi enyxma-shell etkinse mükerrer başlatılmaz, değilse yedek olarak çalıştırılır
    hl.exec_cmd("systemctl --user is-enabled --quiet enyxma-shell 2>/dev/null || ( command -v enyxma-shell >/dev/null 2>&1 && enyxma-shell ) || ( command -v quickshell >/dev/null 2>&1 && quickshell ) || true")

    -- 4. Duvar kağıdı motoru awww veya swww daemon
    hl.exec_cmd("( command -v awww-daemon >/dev/null 2>&1 && awww-daemon ) || ( command -v swww-daemon >/dev/null 2>&1 && swww-daemon ) || true")

    -- 5. Güç yönetimi ve ekran kilidi zamanlayıcısı
    hl.exec_cmd("command -v hypridle >/dev/null 2>&1 && hypridle")

    -- 6. Polkit yetki istemcisi
    hl.exec_cmd("( command -v hyprpolkitagent >/dev/null 2>&1 && hyprpolkitagent ) || ( command -v polkit-gnome-authentication-agent-1 >/dev/null 2>&1 && polkit-gnome-authentication-agent-1 ) || ( command -v lxpolkit >/dev/null 2>&1 && lxpolkit ) || true")

    -- 7. Pano geçmişi cliphist
    hl.exec_cmd("command -v cliphist >/dev/null 2>&1 && command -v wl-paste >/dev/null 2>&1 && wl-paste --watch cliphist store")

    -- 8. İmleç teması ve boyutu
    hl.exec_cmd("command -v hyprctl >/dev/null 2>&1 && hyprctl setcursor Adwaita 24")
end)
