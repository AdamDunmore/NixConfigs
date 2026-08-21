{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.apps.media.rip = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.apps.media.enable;
            example = false;
            description = "Enables rip module";
        };
    };
}
