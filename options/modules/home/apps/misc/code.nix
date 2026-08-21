{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.apps.misc.code = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.apps.misc.enable;
            example = false;
            description = "Enables the code module";
        };
    };
}
