{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.apps.media.beets = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.apps.media.enable;
            example = false;
            description = "Enables beets module";
        };
    };
}
