{ lib, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.wm.hyprland = {
        enable = mkOption {
            type = lib.types.bool;
            default = false;
            example = false;
            description = "Enables the hyprland module";
        };
        hyprlock.enable = mkOption {
            type = lib.types.bool;
            default = false;
            example = false;
            description = "Enables the hyprlock module";
        };
    };
}
