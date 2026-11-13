-- =====================================================
-- enyxma hyprland yapılandırması
-- Ana giriş noktası ve güvenli modül yükleyici
-- Hedef sürüm Hyprland 0.56 ve üzeri
-- Tüm yapılandırma saf Lua dilinde yazılmıştır
-- =====================================================

-- Kök dizin dinamik olarak tespit edilir
-- Sabit kullanıcı adı veya sabit ev dizini yolu kullanılmaz
local function detect_root_dir()
    local source = nil
    if debug and debug.getinfo then
        source = debug.getinfo(1, "S").source
    end

    if source then
        source = source:gsub("^@", "")
        local dir = source:match("^(.+)[/\\][^/\\]+$")
        if dir and dir ~= "" then
            return dir
        end
    end

    local xdg = os.getenv("XDG_CONFIG_HOME")
    if xdg and xdg ~= "" then
        return xdg .. "/hypr"
    end

    local home = os.getenv("HOME")
    if home and home ~= "" then
        return home .. "/.config/hypr"
    end

    return "."
end

local ROOT_DIR = detect_root_dir()

-- Lua arama yoluna kök dizin eklenir
-- Böylece modül çözümlemesi her sistemde aynı şekilde çalışır
if package and package.path then
    local old_path = package.path or ""
    package.path = ROOT_DIR .. "/?.lua;" .. ROOT_DIR .. "/?/init.lua;/etc/xdg/hypr/?.lua;/etc/xdg/hypr/?/init.lua;" .. old_path
end

-- Sessiz uyarı yardımcısı
local function warn(msg)
    if print then
        print(msg)
    end
end

-- Güvenli modül yükleyici
-- Her modül kendi Lua kapsamında çalışır
-- Bir modül hata verse bile diğer modüller çalışmaya devam eder
local function load_module(mod_name)
    if package and package.loaded then
        package.loaded[mod_name] = nil
    end
    local ok, res = pcall(require, mod_name)

    if ok then
        return res
    end

    if dofile then
        local rel = mod_name:gsub("%.", "/") .. ".lua"
        local candidates = {
            ROOT_DIR .. "/" .. rel,
            "/etc/xdg/hypr/" .. rel,
        }
        for _, path in ipairs(candidates) do
            local f = io.open(path, "r")
            if f then
                f:close()
                local ok2, res2 = pcall(dofile, path)
                if ok2 then
                    return res2
                end
                warn("dofile hatası " .. tostring(res2))
            end
        end
        warn("enyxma uyarısı modül yüklenemedi " .. mod_name)
        warn("require hatası " .. tostring(res))
        return nil
    end

    warn("enyxma uyarısı modül yüklenemedi " .. mod_name)
    warn("hata " .. tostring(res))
    return nil
end

-- Yükleme sırası önemlidir
-- Yardımcı kütüphane en başta yüklenir, böylece global Utils her yerden erişilebilir olur
load_module("lua.lib.utils")
load_module("lua.core.hardware")
load_module("lua.ui.theme")
load_module("lua.wm.rules")
load_module("lua.wm.events")
load_module("lua.wm.binds")
load_module("lua.core.autostart")
