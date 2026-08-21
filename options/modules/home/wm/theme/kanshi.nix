{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.wm.theme.kanshi = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.wm.theme.enable;
            example = false;
            description = "Enables the kanshi module";
        };
    };
}
