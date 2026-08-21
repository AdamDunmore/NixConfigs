{ lib, config, pkgs, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./media
        ./misc
        ./scripts.nix
    ];
    options.settings.modules.home.apps = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.home.enable;
            example = false;
            description = "Enables apps modules";
        };

        user_apps = mkOption {
            type = lib.types.listOf lib.types.package;
            default = [];
            example = [ pkgs.git pkgs.fastfetch ];
            description = "User packages";
        };
    };
}
