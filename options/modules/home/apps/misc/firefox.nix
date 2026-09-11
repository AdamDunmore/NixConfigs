{ lib, config, pkgs, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.apps.misc.firefox = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.apps.misc.enable;
            example = false;
            description = "Enables the firefox module";
        };
    };
}
