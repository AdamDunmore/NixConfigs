{ lib, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./colours.nix
        ./font.nix
    ];

    options.settings.values = {
        primary-monitor = mkOption {
            type = lib.types.str;
            default = "DP-1";
            example = "eDP-1";
            description = "Sets the primary monitor"; 
        };
    };
}
