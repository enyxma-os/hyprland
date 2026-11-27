-- =====================================================
-- enyxma yardımcı kütüphane Utils Library
-- Hyprland 0.56+ Pure Lua API
-- Global Utils nesnesi: Asenkron komutlar, native bildirimler ve Shell IPC
-- =====================================================

Utils = {}

-- Asenkron kabuk komutu Hyprland UI ana döngüsünü asla bloklamaz
function Utils.async_cmd(cmd)
    if cmd and cmd ~= "" then
        os.execute(cmd .. " > /dev/null 2>&1 &")
    end
end

-- Enyxma dil ayarını ~/.config/enyxma/settings.json dosyasından okur
function Utils.is_en()
    local home = os.getenv("HOME")
    if not home or home == "" then return false end
    local f = io.open(home .. "/.config/enyxma/settings.json", "r")
    if not f then return false end
    local content = f:read("*a")
    f:close()
    if not content then return false end
    return content:match('"language"%s*:%s*"([^"]+)"') == "en"
end

function Utils.t(tr, en)
    if Utils.is_en() then return en end
    return tr
end

-- Enyxma Shell bildirim sistemine notify-send üzerinden bildirim gönderir
function Utils.notify(title, message, timeout)
    Utils.notify_send(title, message, timeout)
end

-- Zengin masaüstü bildirimi libnotify üzerinden
function Utils.notify_send(title, message, timeout)
    timeout = timeout or 2500
    local safe_title = tostring(title):gsub("'", "'\\''")
    local safe_msg = tostring(message or ""):gsub("'", "'\\''")
    Utils.async_cmd(string.format("notify-send -a 'Enyxma' '%s' '%s' -t %d", safe_title, safe_msg, timeout))
end

-- Enyxma Shell Quickshell IPC çağrısı Örn: Utils.qs_ipc"enyxma-bar", "hide"
function Utils.qs_ipc(target, action)
    if action == "show" then action = "reveal" end
    local qs_path = os.getenv("QS_CONFIG_PATH") or "$HOME/.local/share/enyxma-shell/runtime/shell.qml"
    Utils.async_cmd(string.format("quickshell -p %s ipc call %s %s", qs_path, target, action))
end

return Utils
