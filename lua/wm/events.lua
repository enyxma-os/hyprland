-- =====================================================
-- enyxma akıllı olaylar ve uzaysal mantık Smart Event Hooks
-- Hyprland 0.56+ Pure Lua API
-- GamingMode, Odak Koruma, Geometrik Auto-Tab ve Zen Modu
-- =====================================================

-- ═══════════════════════════════════════════
-- 1. DURUM YÖNETİMİ RAM İçi, Sıfır Gecikme
-- ═══════════════════════════════════════════
local ws_window_counts = {}

-- Dikkat dağıtıcı iletişim ve medya uygulamaları
local DISTRACTORS = {
    "discord", "telegram-desktop", "org.telegram.desktop",
    "slack", "signal", "spotify", "webcord", "vesktop"
}

local function is_distractor(class)
    for _, d in ipairs(DISTRACTORS) do
        if class == d then return true end
    end
    return false
end

local function get_ws_id(w)
    if not w then return -1 end
    if type(w.workspace) == "table" and w.workspace.id then
        return w.workspace.id
    elseif type(w.workspace) == "number" then
        return w.workspace
    end
    return -1
end

-- ═══════════════════════════════════════════
-- 2. GAMING / DÜŞÜK GECİKME MODU SUPER+G
-- ═══════════════════════════════════════════
GamingMode = {
    active = false,
}

function GamingMode.toggle()
    GamingMode.active = not GamingMode.active
    if GamingMode.active then
        hl.config({
            animations = { enabled = false },
            decoration = {
                blur = { enabled = false },
                shadow = { enabled = false },
            },
        })
        Utils.notify("✦ Enyxma Gaming", "Düşük Gecikme Modu Aktif (180Hz / Blur & Animasyon Kapalı)", 2500)
    else
        hl.config({
            animations = { enabled = true },
            decoration = {
                blur = { enabled = true },
                shadow = { enabled = true },
            },
        })
        Utils.notify("✦ Enyxma Normal", "Glassmorphism & Animasyonlar Aktif", 2500)
    end
end

-- ═══════════════════════════════════════════
-- 3. WINDOW OPEN — Auto-Tab + Focus Stealing Koruması
-- ═══════════════════════════════════════════
hl.on("window.open", function(w)
    if not w then return end

    local class = string.lower(w.class or "")

    -- Dikkat dağıtıcı uygulama → sessizce Workspace 9'a taşı, odağı koru
    if is_distractor(class) then
        local addr = w.address or ""
        if addr ~= "" then
            Utils.async_cmd("hyprctl dispatch movetoworkspacesilent 9,address:" .. addr)
            Utils.notify("✦ Odak Korundu", (w.title or class) .. " sessizce Workspace 9'a taşındı.", 3000)
        end
        return
    end

    -- Normal uygulama → Çalışma alanı pencere sayacı ve Auto-Tab
    local ws_id = get_ws_id(w)
    if ws_id ~= -1 then
        ws_window_counts[ws_id] = (ws_window_counts[ws_id] or 0) + 1

        if ws_window_counts[ws_id] >= 3 and not w.floating then
            hl.dispatch(hl.dsp.group.toggle())
            Utils.notify("✦ Enyxma Auto-Tab", "Alan daraldığı için Geometrik Koruma (Sekme) aktif edildi.", 2500)
        end
    end
end)

-- ═══════════════════════════════════════════
-- 4. WINDOW CLOSE — Pencere Sayacı Güncelleme
-- ═══════════════════════════════════════════
hl.on("window.close", function(w)
    if not w then return end
    local ws_id = get_ws_id(w)

    if ws_id ~= -1 and ws_window_counts[ws_id] then
        ws_window_counts[ws_id] = math.max(0, ws_window_counts[ws_id] - 1)
    end
end)

-- ═══════════════════════════════════════════
-- 5. ZEN MODE Focus Tracker & Bar Gizleme
-- ═══════════════════════════════════════════
hl.on("window.active", function(w)
    if not w then return end

    -- GamingMode aktifken özel parlaklık/dim ayarlarını ezme
    if GamingMode.active then return end

    local class = string.lower(w.class or "")
    local is_zen_app = (class == "mpv" or class == "gamescope" or class == "steam_app" or string.find(class, "steam_app_") ~= nil)
    local is_fullscreen = (w.fullscreen == true or w.fullscreen == 1 or w.fullscreen == 2)

    if is_zen_app or is_fullscreen then
        hl.config({
            decoration = { dim_inactive = true, dim_strength = 0.4 }
        })
        Utils.qs_ipc("enyxma-bar", "hide")
    else
        hl.config({
            decoration = { dim_inactive = false, dim_strength = 0.0 }
        })
        Utils.qs_ipc("enyxma-bar", "reveal")
    end
end)

return {
    GamingMode = GamingMode
}
