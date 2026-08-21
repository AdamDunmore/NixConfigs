{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./ags.nix
        ./mako.nix
        ./waybar.nix
        ./wpaperd.nix
        ./wofi.nix
    ];
    options.settings.modules.home.wm.shell = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.wm.enable;
            example = false;
            description = "Enables the window manager shell modules";
        };
    };
}
