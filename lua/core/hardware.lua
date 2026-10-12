-- =====================================================
-- enyxma çekirdek donanım modülü
-- Dinamik ekran monitör ve Türkçe klavye ayarları
-- Sabit ekran kartı yolu kullanılmaz
-- Sanal makine entegre grafik ve harici ekran kartları desteklenir
-- =====================================================

-- Ortam değişkeni okuma yardımcısı
-- Boş değerler yok sayılır
local function get_env(name)
    local val = os.getenv(name)
    if val == nil or val == "" then
        return nil
    end
    return val
end

-- Dosya okuma yardımcısı
-- Erişim yoksa boş metin döner
local function read_file(path)
    if not io or not io.open then
        return ""
    end

    local file = io.open(path, "r")
    if not file then
        return ""
    end

    local content = file:read("a")
    file:close()

    if content == nil then
        return ""
    end

    return content
end

-- Metin içinde arama yardımcısı
local function contains(text, pattern)
    if text == nil then
        return false
    end
    return text:lower():find(pattern, 1, true) ~= nil
end

-- Sanal makine tespiti
-- Ortam değişkenleri ve donanım kimliği birlikte değerlendirilir
local function is_virtual_machine()
    local vm_identifiers = { "qemu", "kvm", "virtualbox", "vmware", "innotek", "xen", "bochs", "parallels", "microsoft corporation" }

    if get_env("container") or get_env("WSL_DISTRO_NAME") or get_env("ENYXMA_SANAL_MAKINE") then
        return true
    end

    local cpu_info = read_file("/proc/cpuinfo")
    if contains(cpu_info, "hypervisor") then
        return true
    end

    local sys_vendor = read_file("/sys/class/dmi/id/sys_vendor")
    local product_name = read_file("/sys/class/dmi/id/product_name")

    for _, identifier in ipairs(vm_identifiers) do
        if contains(sys_vendor, identifier) or contains(product_name, identifier) then
            return true
        end
    end

    return false
end

local IS_VM = is_virtual_machine()

-- =====================================================
-- MONITOR AYARLARI
-- =====================================================

-- Boş output değeri hiçbir kurala uymayan tüm çıkışlar için yedek kural oluşturur
-- Bu sayede yapılandırma hiçbir ekran kartına veya bağlantı tipine çakılmaz
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- İsteğe bağlı açık monitör tanımı
-- Kullanıcı ortam değişkenleri ile kendi ekranını tanımlayabilir
local custom_monitor = get_env("ENYXMA_MONITOR")
if custom_monitor then
    hl.monitor({
        output   = custom_monitor,
        mode     = get_env("ENYXMA_MONITOR_MODE") or "preferred",
        position = get_env("ENYXMA_MONITOR_POSITION") or "auto",
        scale    = get_env("ENYXMA_MONITOR_SCALE") or "auto",
    })
end

-- =====================================================
-- GİRİŞ BIRIMI AYARLARI
-- =====================================================

-- Türkçe klavye düzeni tanımlanır
-- Q düzeni için tr değeri kullanılır
hl.config({
    input = {
        kb_layout = "tr",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",

        numlock_by_default = true,
        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Dokunmatik yüzey hareketi ile çalışma alanı değiştirme
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

-- =====================================================
-- İMLEC AYARLARI
-- =====================================================

-- no_hardware_cursors değeri 2 otomatik seçim anlamına gelir
-- Sanal makinede yazılım imleci zorlanır
hl.config({
    cursor = {
        no_hardware_cursors = IS_VM and 1 or 2,
        enable_hyprcursor = true,
        sync_gsettings_theme = true,
    },
})

-- =====================================================
-- ORTAM DEĞİŞKENLERİ
-- =====================================================

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("GDK_BACKEND", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
