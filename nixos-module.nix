{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.enyxma.desktop.hyprland;
in {
  options.enyxma.desktop.hyprland = {
    enable = mkEnableOption "Enyxma Hyprland pure Lua window manager and desktop stack";
  };

  options.enyxma.hyprland = {
    enable = mkEnableOption "Enyxma Hyprland alias";
  };

  config = mkIf (cfg.enable || config.enyxma.hyprland.enable) {
    programs.hyprland = {
      enable = mkDefault true;
      withUWSM = mkDefault true;
      xwayland.enable = mkDefault true;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = mkDefault "1";
      MOZ_ENABLE_WAYLAND = mkDefault "1";
      XDG_CURRENT_DESKTOP = mkDefault "Hyprland";
      XDG_SESSION_TYPE = mkDefault "wayland";
      XDG_SESSION_DESKTOP = mkDefault "Hyprland";
    };

    xdg.portal = {
      enable = mkDefault true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
      config.common.default = mkDefault ["hyprland" "gtk"];
    };

    environment.etc = {
      "xdg/hypr/hyprland.lua".source = ./hyprland.lua;
      "xdg/hypr/lua".source = ./lua;
      "xdg/hypr/configs".source = ./configs;
      "xdg/hypr/scripts".source = ./scripts;
      "xdg/hypr/hyprlock.conf".source = ./configs/hyprlock.conf;
      "xdg/hypr/hypridle.conf".source = ./configs/hypridle.conf;
    };

    environment.systemPackages = with pkgs; [
      quickshell
      awww
      grim
      slurp
      wl-clipboard
      cliphist
      brightnessctl
      playerctl
      pamixer
      wireplumber
      libnotify
      kitty
      foot
      hyprlock
      hypridle
      yazi
      thunar
    ];
  };
}
