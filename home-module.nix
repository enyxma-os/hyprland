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

  # Standart Enyxma modern kabuk kisayollari
  enyxmaAliases = {
    # Modern CLI alternatifleri
    ls = "eza --icons --git -a";
    lt = "eza --tree --level=2 --icons";
    ll = "eza --icons --git -lha --group-directories-first --time-style=long-iso";
    l = "eza --icons --git -lh --group-directories-first";
    la = "eza --icons --git -lha --group-directories-first";
    cat = "bat";
    grep = "rg";
    find = "fd";
    cd = "z"; # Zoxide akilli dizin degistirme

    # NixOS sistem yonetimi
    update = "nh os switch";
    clean = "nh clean all";

    # Guvenli gelistirme (Ag izolasyonu / Sandbox)
    shell-safe = "systemd-run --user --scope -p PrivateNetwork=true bash";
    pnpm-safe = "systemd-run --user --scope -p PrivateNetwork=true pnpm";

    # Power-User araclari
    lg = "lazygit";
    v = "nvim";

    # VSCodium bayat kilit temizleyici guvenli baslatici
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
    # Hyprland Lua ve bagli bilesenlerin yapilandirma dosyalari baglanir
    xdg.configFile."hypr/hyprland.lua".source = lib.mkDefault (resolveSource ./hyprland.lua "hyprland.lua");
    xdg.configFile."hypr/lua".source = lib.mkDefault (resolveSource ./lua "lua");
    xdg.configFile."hypr/hyprlock.conf".source = lib.mkDefault (resolveSource ./configs/hyprlock.conf "configs/hyprlock.conf");
    xdg.configFile."hypr/hypridle.conf".source = lib.mkDefault (resolveSource ./configs/hypridle.conf "configs/hypridle.conf");
    xdg.configFile."hypr/scripts".source = lib.mkDefault (resolveSource ./scripts "scripts");

    # Ekran goruntusu klasoru guvenceye alinir
    home.activation.createScreenshotsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/Pictures/Screenshots"
    '';

    # Terminal ve Power-User dosyalari
    xdg.configFile."fastfetch/config.jsonc".source = lib.mkIf cfg.terminal.enable (lib.mkDefault (resolveSource ./configs/fastfetch.jsonc "configs/fastfetch.jsonc"));
    xdg.configFile."starship.toml".source = lib.mkIf cfg.terminal.enable (lib.mkDefault (resolveSource ./configs/starship.toml "configs/starship.toml"));
    xdg.configFile."foot/foot.ini".source = lib.mkIf cfg.terminal.enable (lib.mkDefault (resolveSource ./configs/foot.ini "configs/foot.ini"));
    xdg.configFile."kitty/kitty.conf".source = lib.mkIf cfg.terminal.enable (lib.mkDefault (resolveSource ./configs/kitty.conf "configs/kitty.conf"));

    # Kabuk kisayollari ve entegrasyonu
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

    # Starship ve Zoxide servisleri
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

    # Kullanici ve masaustu araclari
    home.packages = with pkgs; [
      grim
      slurp
      wl-clipboard
      cliphist
      brightnessctl
      playerctl
      hyprlock
      hypridle
      ddcutil
    ] ++ lib.optionals cfg.terminal.enable [
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
