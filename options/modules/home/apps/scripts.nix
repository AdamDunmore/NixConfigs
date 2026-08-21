{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.apps.scripts = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.apps.enable;
            example = false;
            description = "Enables the scripts module";
        };
    };
}
