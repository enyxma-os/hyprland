{ lib, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "enyxma-hyprland";
  version = "0.1.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/share/enyxma-hyprland
    cp -r hyprland.lua lua $out/share/enyxma-hyprland/
  '';

  meta = with lib; {
    description = "Enyxma OS pure Lua Hyprland configuration framework";
    homepage = "https://codeberg.org/enyxma/hyprland";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
