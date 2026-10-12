# Enyxma Hyprland Yönetim ve Doğrulama Paneli
# Hedef Hyprland 0.56 ve üzeri saf Lua mimarisi

# Varsayılan yardım menüsü
default:
    @just --list

# Lua ve Nix sözdizimi ile kısayol çakışma doğrulaması
check:
    @echo "Lua sözdizimi doğrulanıyor..."
    @find lua -name "*.lua" -exec luac -p {} +
    @luac -p hyprland.lua
    @echo "Nix sözdizimi doğrulanıyor..."
    @nix-instantiate --parse flake.nix default.nix nixos-module.nix home-module.nix >/dev/null
    @echo "Kısayol çakışmaları denetleniyor..."
    @python3 scripts/check-binds.py
    @echo "Tüm kalite ve güvenlik kontrolleri BAŞARILI."

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
