{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./mako.nix
        ./swaync.nix
    ];
    options.settings.modules.home.wm.shell.notifications = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.wm.shell.enable;
            example = false;
            description = "Enables the window manager shell notifications modules";
        };
    };
}
