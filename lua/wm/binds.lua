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
local function qs_call(target, action)
    return "quickshell -p $HOME/.local/share/enyxma-shell/0.2.0/shell.qml ipc call " .. target .. " " .. action
end

local terminal         = get_env("TERMINAL") or "kitty -o remember_window_size=no"
local file_manager     = get_env("FILEMANAGER") or find_first_binary({ "thunar", "nautilus", "dolphin", "nemo", "pcmanfm" })
local tui_file_manager = "kitty -o remember_window_size=no -e yazi"
local app_launcher     = get_env("MENU") or qs_call("launcher", "toggle")
local web_browser      = get_env("BROWSER") or find_first_binary({ "librewolf", "firefox", "brave", "chromium", "google-chrome-stable" })
local screen_lock      = find_first_binary({ "hyprlock", "swaylock" })

-- Ekran goruntusu alma komutlari
local screenshot_screen = "sh -c 'grim - | wl-copy && notify-send \"Ekran Goruntusu\" \"Tam ekran panoya kopyalandi\" -t 2000'"
local screenshot_region = "sh -c 'grim -g \"$(slurp)\" - | wl-copy && notify-send \"Ekran Alintisi\" \"Secilen alan panoya kopyalandi\" -t 2000'"
local screenshot_save   = "sh -c 'mkdir -p ~/Pictures/Screenshots && FILE=~/Pictures/Screenshots/enyxma_$(date +%Y%m%d_%H%M%S).png && grim -g \"$(slurp)\" \"$FILE\" && wl-copy < \"$FILE\" && notify-send \"Ekran Alintisi Kaydedildi\" \"$FILE\" -t 2000'"
local clipboard_menu    = "( command -v cliphist >/dev/null 2>&1 && command -v rofi >/dev/null 2>&1 && cliphist list | rofi -dmenu | cliphist decode | wl-copy ) || ( command -v cliphist >/dev/null 2>&1 && command -v fuzzel >/dev/null 2>&1 && cliphist list | fuzzel -d | cliphist decode | wl-copy ) || ( command -v cliphist >/dev/null 2>&1 && command -v wofi >/dev/null 2>&1 && cliphist list | wofi --dmenu | cliphist decode | wl-copy ) || true"

-- =====================================================
-- UYGULAMA KISAYOLLARI
-- =====================================================

hl.bind(MOD .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(MOD .. " + Q", hl.dsp.window.close())
hl.bind(MOD .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(MOD .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(MOD .. " + Y", hl.dsp.exec_cmd(tui_file_manager))
hl.bind(MOD .. " + R", hl.dsp.exec_cmd(app_launcher))
hl.bind(MOD .. " + W", hl.dsp.exec_cmd(web_browser))
hl.bind(MOD .. " + L", hl.dsp.exec_cmd(screen_lock))
hl.bind(MOD .. " + SHIFT + V", hl.dsp.exec_cmd(clipboard_menu))
hl.bind(MOD .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(MOD .. " + SHIFT + E", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- Ekran goruntusu kisayollari
hl.bind("Print", hl.dsp.exec_cmd(screenshot_screen))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(screenshot_save))
hl.bind(MOD .. " + Print", hl.dsp.exec_cmd(screenshot_save))
hl.bind(MOD .. " + SHIFT + S", hl.dsp.exec_cmd(screenshot_region))

-- =====================================================
-- PENCERE DURUMLARI
-- =====================================================

hl.bind(MOD .. " + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
hl.bind(MOD .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" }))
hl.bind(MOD .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(MOD .. " + P", hl.dsp.window.pseudo())
hl.bind(MOD .. " + SHIFT + P", hl.dsp.window.pin({ action = "toggle" }))
hl.bind(MOD .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(MOD .. " + G", function() if GamingMode and GamingMode.toggle then GamingMode.toggle() end end)
hl.bind(MOD .. " + SHIFT + G", hl.dsp.group.toggle())
hl.bind(MOD .. " + Tab", hl.dsp.exec_cmd(qs_call("overview", "toggle")))
hl.bind("ALT + Tab", hl.dsp.focus({ workspace = "previous" }))
hl.bind("ALT + SHIFT + Tab", hl.dsp.focus({ workspace = "e-1" }))
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
hl.bind(MOD .. " + grave", hl.dsp.workspace.toggle_special("magic"))
hl.bind(MOD .. " + SHIFT + M", hl.dsp.window.move({ workspace = "special:magic" }))

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
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("([ -f ~/.config/hypr/scripts/brightness.sh ] && ~/.config/hypr/scripts/brightness.sh +5) || (command -v brightnessctl >/dev/null 2>&1 && brightnessctl -e4 -n2 set 5%+)"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("([ -f ~/.config/hypr/scripts/brightness.sh ] && ~/.config/hypr/scripts/brightness.sh -5) || (command -v brightnessctl >/dev/null 2>&1 && brightnessctl -e4 -n2 set 5%-)"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


-- =====================================================
-- ENYXMA SHELL IPC KISAYOLLARI
-- =====================================================
hl.bind(MOD .. " + space", hl.dsp.exec_cmd(qs_call("launcher", "toggle")))
hl.bind(MOD .. " + D", hl.dsp.exec_cmd(qs_call("dashboard", "toggle")))
hl.bind(MOD .. " + B", hl.dsp.exec_cmd(qs_call("bar", "toggle")))
hl.bind(MOD .. " + N", hl.dsp.exec_cmd(qs_call("notifications", "toggle")))
hl.bind(MOD .. " + S", hl.dsp.exec_cmd(qs_call("ai", "toggle")))
