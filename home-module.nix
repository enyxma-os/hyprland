{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.enyxma.desktop.hyprland;

  resolveSource = storePath: relPath:
    if cfg.sourcePath != null && cfg.sourcePath != ""
    then config.lib.file.mkOutOfStoreSymlink "${cfg.sourcePath}/${relPath}"
    else storePath;

  enyxmaAliases = {
    ls = "eza --icons --git -a";
    lt = "eza --tree --level=2 --icons";
    ll = "eza --icons --git -lha --group-directories-first --time-style=long-iso";
    l = "eza --icons --git -lh --group-directories-first";
    la = "eza --icons --git -lha --group-directories-first";
    cat = "bat";
    grep = "rg";
    find = "fd";
    cd = "z";

    update = "nh os switch";
    clean = "nh clean all";

    shell-safe = "systemd-run --user --scope -p PrivateNetwork=true bash";
    pnpm-safe = "systemd-run --user --scope -p PrivateNetwork=true pnpm";

    lg = "lazygit";
    v = "nvim";

    code = "$HOME/.config/hypr/scripts/codium-safe.sh";
    codium = "$HOME/.config/hypr/scripts/codium-safe.sh";
  };
in {
  options.enyxma.desktop.hyprland = {
    enable = mkEnableOption "Enyxma Hyprland user configuration and files";

    sourcePath = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/home/username/Projects/enyxma/hyprland";
      description = "Yerel gelistirme dizini yolu. Belirtilirse canli duzenleme modu aktif olur.";
    };

    terminal = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enyxma modern terminal profili, starship prompt, fastfetch ve kisayollari aktif eder.";
      };
    };
  };

  options.enyxma.hyprland = {
    enable = mkEnableOption "Enyxma Hyprland alias";
    sourcePath = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Yerel gelistirme dizini yolu.";
    };
  };

  config = mkIf (cfg.enable || config.enyxma.hyprland.enable) {
    xdg.configFile."hypr/hyprland.lua".source = lib.mkDefault (resolveSource ./hyprland.lua "hyprland.lua");
    xdg.configFile."hypr/lua".source = lib.mkDefault (resolveSource ./lua "lua");
    xdg.configFile."hypr/hyprlock.conf".source = lib.mkDefault (resolveSource ./configs/hyprlock.conf "configs/hyprlock.conf");
    xdg.configFile."hypr/hypridle.conf".source = lib.mkDefault (resolveSource ./configs/hypridle.conf "configs/hypridle.conf");
    xdg.configFile."hypr/scripts".source = lib.mkDefault (resolveSource ./scripts "scripts");

    home.activation.createScreenshotsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$HOME/Pictures/Screenshots"
    '';

    xdg.configFile."fastfetch/config.jsonc".source = lib.mkIf cfg.terminal.enable (lib.mkDefault (resolveSource ./configs/fastfetch.jsonc "configs/fastfetch.jsonc"));
    xdg.configFile."starship.toml".source = lib.mkIf cfg.terminal.enable (lib.mkDefault (resolveSource ./configs/starship.toml "configs/starship.toml"));
    xdg.configFile."foot/foot.ini".source = lib.mkIf cfg.terminal.enable (lib.mkDefault (resolveSource ./configs/foot.ini "configs/foot.ini"));
    xdg.configFile."kitty/kitty.conf".source = lib.mkIf cfg.terminal.enable (lib.mkDefault (resolveSource ./configs/kitty.conf "configs/kitty.conf"));

    programs.bash = lib.mkIf cfg.terminal.enable {
      enable = lib.mkDefault true;
      shellAliases = enyxmaAliases;
    };

    programs.fish = lib.mkIf cfg.terminal.enable {
      enable = lib.mkDefault true;
      shellAliases = enyxmaAliases;
      interactiveShellInit = ''
        set fish_greeting
      '';
    };

    programs.zsh = lib.mkIf cfg.terminal.enable {
      enable = lib.mkDefault true;
      shellAliases = enyxmaAliases;
    };

    programs.starship = lib.mkIf cfg.terminal.enable {
      enable = lib.mkDefault true;
      enableBashIntegration = lib.mkDefault true;
      enableFishIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
    };

    programs.zoxide = lib.mkIf cfg.terminal.enable {
      enable = lib.mkDefault true;
      enableBashIntegration = lib.mkDefault true;
      enableFishIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
    };

    home.packages =
      with pkgs; [
        quickshell
        awww
          grim
        slurp
        wl-clipboard
        cliphist
        brightnessctl
        playerctl
        pamixer
        hyprlock
        hypridle
        ddcutil
      ]
      ++ lib.optionals cfg.terminal.enable [
        fastfetch
        starship
        eza
        bat
        fzf
        ripgrep
        fd
        zoxide
        jq
        lazygit
        foot
        kitty
      ];
  };
}
