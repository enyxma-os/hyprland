{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.programs.enyxma.hyprland;

  # Geliştirici modu için yerel yol veya üretim modu için doğrudan paket yolu
  resolveSource = storePath: relPath:
    if cfg.sourcePath != null && cfg.sourcePath != "" then
      config.lib.file.mkOutOfStoreSymlink "${cfg.sourcePath}/${relPath}"
    else
      storePath;
in {
  options.programs.enyxma.hyprland = {
    enable = mkEnableOption "Enyxma Hyprland user configuration and files";

    sourcePath = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/home/username/Projects/enyxma/hyprland";
      description = "Yerel geliştirme dizini yolu. Belirtilirse canlı düzenleme modu aktif olur.";
    };
  };

  config = mkIf cfg.enable {
    # Hyprland Lua yapılandırma dosyaları bağlanır
    xdg.configFile."hypr/hyprland.lua".source = lib.mkDefault (resolveSource ./hyprland.lua "hyprland.lua");
    xdg.configFile."hypr/lua".source = lib.mkDefault (resolveSource ./lua "lua");

    # Ekran görüntüsü klasörü güvenceye alınır
    home.activation.createScreenshotsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/Pictures/Screenshots"
    '';

    # Kullanıcı araçları
    home.packages = with pkgs; [
      grim
      slurp
      wl-clipboard
      cliphist
      brightnessctl
      playerctl
    ];
  };
}
