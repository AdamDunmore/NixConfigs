{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.home.apps.media.kodi = {
        enable = mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Enables kodi module";
        };
    };
}
