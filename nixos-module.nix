{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
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
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
      config.common.default = ["hyprland" "gtk"];
    };

    environment.etc = {
      "xdg/hypr/hyprland.lua".source = ./hyprland.lua;
      "xdg/hypr/lua".source = ./lua;
      "xdg/hypr/configs".source = ./configs;
      "xdg/hypr/scripts".source = ./scripts;
    };

    environment.systemPackages = with pkgs; [
      quickshell
      awww
      networkmanagerapplet
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
    ];
  };
}
