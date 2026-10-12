{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.enyxma.hyprland;
in {
  options.programs.enyxma.hyprland = {
    enable = mkEnableOption "Enyxma Hyprland pure Lua window manager and desktop stack";
  };

  config = mkIf cfg.enable {
    # Hyprland ve UWSM sistem seviyesinde etkinleştirilir
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    # Masaüstünün çalışması için gereken temel araçlar
    environment.systemPackages = with pkgs; [
      # Ekran görüntüsü ve pano araçları
      grim
      slurp
      wl-clipboard
      cliphist

      # Ses ve parlaklık yönetimi
      brightnessctl
      playerctl
      wireplumber

      # Bildirim kütüphanesi
      libnotify
    ];
  };
}
