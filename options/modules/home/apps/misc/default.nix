{ config, lib, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./code.nix
        ./discord.nix
        ./drive.nix
        ./flatpak.nix
        ./firefox.nix
    ];
    options.settings.modules.home.apps.misc = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.apps.enable;
            example = false;
            description = "Enables misc apps modules";
        };
    };
}
