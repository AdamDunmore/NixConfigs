{ lib, config, ... }:
let
    inherit (lib) mkOption types;
in
{
    options.settings.modules.home.apps.misc.discord = {
        enable = mkOption {
            type = types.bool;
            default = config.settings.modules.home.apps.misc.enable;
            example = false;
            description = "Enables the discord module";
        };

        flavour = mkOption {
            type = types.enum [ "vanilla" "moonlight" "concord" ];
            default = "vanilla";
            example = "concord";
            description = "Defines which discord module you want to use. Options are 'vanilla', 'moonlight' and 'concord'";
        };
    };
}
