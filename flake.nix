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
      # NixOS sistem modulu
      nixosModules.default = import ./nixos-module.nix;
      nixosModules.hyprland = import ./nixos-module.nix;

      # Home Manager kullanici modulu
      homeManagerModules.default = import ./home-module.nix;
      homeManagerModules.hyprland = import ./home-module.nix;

      # Bagimsiz paket ciktisi
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.callPackage ./default.nix { };
          hyprland = pkgs.callPackage ./default.nix { };
        }
      );
    };
}
