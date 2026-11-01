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

-- Native Hyprland bildirimi v0.56+ — fork yok, dahili C++ katmanı, anında gösterir
function Utils.notify(title, message, timeout)
    timeout = timeout or 2500
    local text = title .. ": " .. (message or "")
    if hl and hl.notification and hl.notification.create then
        hl.notification.create({ text = text, timeout = timeout })
    else
        Utils.notify_send(title, message, timeout)
    end
end

-- Zengin masaüstü bildirimi libnotify üzerinden
function Utils.notify_send(title, message, timeout)
    timeout = timeout or 2500
    local safe_title = tostring(title):gsub("'", "'\\''")
    local safe_msg = tostring(message or ""):gsub("'", "'\\''")
    Utils.async_cmd(string.format("notify-send '%s' '%s' -t %d", safe_title, safe_msg, timeout))
end

-- Enyxma Shell Quickshell IPC çağrısı Örn: Utils.qs_ipc"enyxma-bar", "hide"
function Utils.qs_ipc(target, action)
    if action == "show" then action = "reveal" end
    local qs_path = os.getenv("QS_CONFIG_PATH") or "$HOME/.local/share/enyxma-shell/0.2.0/shell.qml"
    Utils.async_cmd(string.format("quickshell -p %s ipc call %s %s", qs_path, target, action))
end

return Utils
