{ lib, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.wm.niri = {
        enable = mkOption {
            type = lib.types.bool;
            default = false;
            example = false;
            description = "Enables the niri module";
        };
    };
}
