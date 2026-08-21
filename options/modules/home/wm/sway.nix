{ lib, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.wm.sway = {
        enable = mkOption {
            type = lib.types.bool;
            default = false;
            example = false;
            description = "Enables the sway module";
        };
        swaylock.enable = mkOption {
            type = lib.types.bool;
            default = false;
            example = false;
            description = "Enables the swaylock module";
        };
    };
}
