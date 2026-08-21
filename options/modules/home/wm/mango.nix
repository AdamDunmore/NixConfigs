{ lib, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.wm.mango = {
        enable = mkOption {
            type = lib.types.bool;
            default = false;
            example = false;
            description = "Enables the mango module";
        };
    };
}
