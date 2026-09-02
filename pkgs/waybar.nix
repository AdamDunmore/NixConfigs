
{ inputs, pkgs, ... }:

inputs.waybar.packages.${pkgs.system}.waybar.overrideAttrs(old: {
    doCheck = false;
    mesonFlags = (old.mesonFlags or []) ++ [
        "-Dtests=disabled"
    ];
})

