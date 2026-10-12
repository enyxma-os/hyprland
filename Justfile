# Enyxma Hyprland Yönetim ve Doğrulama Paneli
# Hedef Hyprland 0.56 ve üzeri saf Lua mimarisi

# Varsayılan yardım menüsü
default:
    @just --list

# Lua sözdizimi doğrulaması
check:
    @echo "Lua sözdizimi doğrulanıyor..."
    @find lua -name "*.lua" -exec luac -p {} +
    @luac -p hyprland.lua
    @echo "Sözdizimi testleri BAŞARILI."

# Yerel Hyprland oturumunu yenile
reload:
    hyprctl reload
    @echo "Hyprland oturumu yenilendi."

# Değişiklikleri doğrula ve depoya gönder
sync message="update":
    just check
    git add .
    git commit -m "{{message}}" || echo "Değişiklik yok."
    git push origin main
