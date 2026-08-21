{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./kodi.nix
        ./rip.nix
        ./rmpc.nix
        ./spicetify.nix
        ./mpd.nix
    ];

    options.settings.modules.home.apps.media = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.apps.enable;
            example = false;
            description = "Enables media module";
        };
    };
}
