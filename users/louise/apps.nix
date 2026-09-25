{ inputs, pkgs, ... }:

let
    custom-pkgs = import ../../pkgs/default.nix { inherit pkgs; };
in
{
    config.settings.modules.home.apps.misc.flatpak.packages = [

    ];
    config.settings.modules.home.apps.user_apps = with pkgs; [

    ];
}
