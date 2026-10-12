{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.enyxma.desktop.hyprland;

  # Gelistirici modu icin yerel yol veya uretim modu icin dogrudan paket yolu
  resolveSource = storePath: relPath:
    if cfg.sourcePath != null && cfg.sourcePath != "" then
      config.lib.file.mkOutOfStoreSymlink "${cfg.sourcePath}/${relPath}"
    else
      storePath;
in {
  options.enyxma.desktop.hyprland = {
    enable = mkEnableOption "Enyxma Hyprland user configuration and files";

    sourcePath = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/home/username/Projects/enyxma/hyprland";
      description = "Yerel gelistirme dizini yolu. Belirtilirse canli duzenleme modu aktif olur.";
    };
  };

  # Kolay kullanim icin kisa yol tanimi
  options.enyxma.hyprland = {
    enable = mkEnableOption "Enyxma Hyprland alias";
    sourcePath = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Yerel gelistirme dizini yolu.";
    };
  };

  config = mkIf (cfg.enable || config.enyxma.hyprland.enable) {
    # Hyprland Lua yapilandirma dosyalari baglanir
    xdg.configFile."hypr/hyprland.lua".source = lib.mkDefault (resolveSource ./hyprland.lua "hyprland.lua");
    xdg.configFile."hypr/lua".source = lib.mkDefault (resolveSource ./lua "lua");

    # Ekran goruntusu klasoru guvenceye alinir
    home.activation.createScreenshotsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/Pictures/Screenshots"
    '';

    # Kullanici araclari
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
