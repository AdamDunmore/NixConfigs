{ pkgs, lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./dconf.nix
        ./kanshi.nix
        ./gtk.nix
        ./qt.nix
    ];
    options.settings.modules.home.wm.theme = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.wm.enable;
            example = false;
            description = "Enables the window manager theme modules";
        };
    };
}
