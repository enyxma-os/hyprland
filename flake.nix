{
  description = "Enyxma Hyprland pure Lua desktop ecosystem";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      # NixOS sistem modülü
      nixosModules.default = import ./nixos-module.nix;
      nixosModules.enyxma-hyprland = import ./nixos-module.nix;

      # Home Manager kullanıcı modülü
      homeManagerModules.default = import ./home-module.nix;
      homeManagerModules.enyxma-hyprland = import ./home-module.nix;

      # Bağımsız paket çıktısı
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.callPackage ./default.nix { };
          enyxma-hyprland = pkgs.callPackage ./default.nix { };
        }
      );
    };
}
