-- =====================================================
-- enyxma pencere yönetimi kısayolları
-- Uygulama başlatma pencere işlemleri odak ve çalışma alanları
-- =====================================================

-- Ana değiştirici tuş
local MOD = "SUPER"

-- Ortam değişkeni okuma yardımcısı
local function get_env(name)
    local val = os.getenv(name)
    if val == nil or val == "" then
        return nil
    end
    return val
end

-- Kurulu olan ilk uygulamayı başlatan kabuk zinciri oluşturulur
-- Böylece aynı yapılandırma farklı sistemlerde doğrudan çalışır
local function find_first_binary(candidates)
    local parts = {}
    for _, binary_name in ipairs(candidates) do
        parts[#parts + 1] = "( command -v " .. binary_name .. " >/dev/null 2>&1 && " .. binary_name .. " )"
    end
    parts[#parts + 1] = "true"
    return table.concat(parts, " || ")
end

-- Tercih edilen uygulamalar
local terminal     = get_env("TERMINAL") or find_first_binary({ "kitty", "foot", "alacritty", "wezterm", "konsole", "xterm" })
local file_manager = get_env("FILEMANAGER") or find_first_binary({ "nautilus", "dolphin", "thunar", "nemo", "pcmanfm" })
local app_launcher = get_env("MENU") or find_first_binary({ "hyprlauncher", "rofi", "wofi", "fuzzel", "dmenu_run" })
local web_browser  = get_env("BROWSER") or find_first_binary({ "firefox", "brave", "chromium", "google-chrome-stable" })
local screen_lock  = find_first_binary({ "hyprlock", "swaylock" })

-- Ekran görüntüsü ve pano araçları
local screenshot_screen = "( command -v grimblast >/dev/null 2>&1 && grimblast copysave screen ) || ( command -v hyprshot >/dev/null 2>&1 && hyprshot -m output ) || ( command -v grim >/dev/null 2>&1 && grim ) || true"
local screenshot_region = "( command -v grimblast >/dev/null 2>&1 && grimblast copysave area ) || ( command -v hyprshot >/dev/null 2>&1 && hyprshot -m region ) || ( command -v slurp >/dev/null 2>&1 && command -v grim >/dev/null 2>&1 && grim -g \"$(slurp)\" ) || true"
local clipboard_menu    = "( command -v cliphist >/dev/null 2>&1 && command -v rofi >/dev/null 2>&1 && cliphist list | rofi -dmenu | cliphist decode | wl-copy ) || ( command -v cliphist >/dev/null 2>&1 && command -v fuzzel >/dev/null 2>&1 && cliphist list | fuzzel -d | cliphist decode | wl-copy ) || ( command -v cliphist >/dev/null 2>&1 && command -v wofi >/dev/null 2>&1 && cliphist list | wofi --dmenu | cliphist decode | wl-copy ) || true"

-- =====================================================
-- UYGULAMA KISAYOLLARI
-- =====================================================

hl.bind(MOD .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(MOD .. " + Q", hl.dsp.window.close())
hl.bind(MOD .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(MOD .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(MOD .. " + R", hl.dsp.exec_cmd(app_launcher))
hl.bind(MOD .. " + W", hl.dsp.exec_cmd(web_browser))
hl.bind(MOD .. " + L", hl.dsp.exec_cmd(screen_lock))
hl.bind(MOD .. " + SHIFT + V", hl.dsp.exec_cmd(clipboard_menu))
hl.bind(MOD .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(MOD .. " + SHIFT + E", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- Ekran görüntüsü kısayolları
hl.bind("Print", hl.dsp.exec_cmd(screenshot_screen))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(screenshot_region))
hl.bind(MOD .. " + Print", hl.dsp.exec_cmd(screenshot_region))

-- =====================================================
-- PENCERE DURUMLARI
-- =====================================================

hl.bind(MOD .. " + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
hl.bind(MOD .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" }))
hl.bind(MOD .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(MOD .. " + P", hl.dsp.window.pseudo())
hl.bind(MOD .. " + SHIFT + P", hl.dsp.window.pin({ action = "toggle" }))
hl.bind(MOD .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(MOD .. " + G", hl.dsp.group.toggle())
hl.bind(MOD .. " + Tab", hl.dsp.window.cycle_next())
hl.bind(MOD .. " + C", hl.dsp.window.center())

-- =====================================================
-- ODAK YÖNLENDİRME VE PENCERE TAŞIMA
-- =====================================================

local directions = { "left", "right", "up", "down" }
local resize_deltas = {
    left  = { x = -40, y = 0 },
    right = { x = 40,  y = 0 },
    up    = { x = 0,   y = -40 },
    down  = { x = 0,   y = 40 },
}

for _, direction in ipairs(directions) do
    hl.bind(MOD .. " + " .. direction, hl.dsp.focus({ direction = direction }))
    hl.bind(MOD .. " + SHIFT + " .. direction, hl.dsp.window.move({ direction = direction }))
    hl.bind(MOD .. " + CTRL + " .. direction, hl.dsp.window.swap({ direction = direction }))

    local delta = resize_deltas[direction]
    hl.bind(MOD .. " + SHIFT + CTRL + " .. direction, hl.dsp.window.resize({ x = delta.x, y = delta.y, relative = true }))
end

-- =====================================================
-- ÇOKLU EKRAN KONTROLLERİ
-- =====================================================

hl.bind(MOD .. " + comma", hl.dsp.focus({ monitor = "-1" }))
hl.bind(MOD .. " + period", hl.dsp.focus({ monitor = "+1" }))
hl.bind(MOD .. " + SHIFT + comma", hl.dsp.window.move({ monitor = "-1" }))
hl.bind(MOD .. " + SHIFT + period", hl.dsp.window.move({ monitor = "+1" }))

-- ÇALIŞMA ALANLARI
-- =====================================================

-- Onuncu tuş sıfır tuşuna denk gelir
for i = 1, 10 do
    local key = i % 10
    hl.bind(MOD .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(MOD .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Mevcut çalışma alanları arasında tekerlek ile gezinme
hl.bind(MOD .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(MOD .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Özel çalışma alanı
hl.bind(MOD .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(MOD .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- =====================================================
-- FARE ILE PENCERE İŞLEMLERİ
-- =====================================================

hl.bind(MOD .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(MOD .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- =====================================================
-- MEDYA VE DONANIM TUŞLARI
-- =====================================================

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("command -v wpctl >/dev/null 2>&1 && wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ || pactl set-sink-volume @DEFAULT_SINK@ +5%"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("command -v wpctl >/dev/null 2>&1 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- || pactl set-sink-volume @DEFAULT_SINK@ -5%"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("command -v wpctl >/dev/null 2>&1 && wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle || pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("command -v wpctl >/dev/null 2>&1 && wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle || pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("command -v brightnessctl >/dev/null 2>&1 && brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("command -v brightnessctl >/dev/null 2>&1 && brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


-- =====================================================
-- ENYXMA SHELL IPC KISAYOLLARI
-- =====================================================
hl.bind(MOD .. " + space", hl.dsp.exec_cmd("qs ipc call enyxma-launcher toggle"))
hl.bind(MOD .. " + D", hl.dsp.exec_cmd("qs ipc call enyxma-dashboard toggle"))
hl.bind(MOD .. " + B", hl.dsp.exec_cmd("qs ipc call enyxma-bar toggle"))
