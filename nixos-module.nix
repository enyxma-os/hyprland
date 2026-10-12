{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.enyxma.desktop.hyprland;
in {
  options.enyxma.desktop.hyprland = {
    enable = mkEnableOption "Enyxma Hyprland pure Lua window manager and desktop stack";
  };

  # Kolay kullanim icin kisa yol tanimi
  options.enyxma.hyprland = {
    enable = mkEnableOption "Enyxma Hyprland alias";
  };

  config = mkIf (cfg.enable || config.enyxma.hyprland.enable) {
    # Hyprland ve UWSM sistem seviyesinde etkinlestirilir
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    # Masaustunun calismasi icin gereken temel araclar
    environment.systemPackages = with pkgs; [
      # Ekran goruntusu ve pano araclari
      grim
      slurp
      wl-clipboard
      cliphist

      # Ses ve parlaklik yonetimi
      brightnessctl
      playerctl
      wireplumber

      # Bildirim kutuphanesi
      libnotify
    ];
  };
}
