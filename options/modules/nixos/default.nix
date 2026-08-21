{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./base
        ./display_managers
        ./keyboard
        ./services
    ];
    options.settings.modules.nixos = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.enable;
            example = false;
            description = "Enables nixos modules";
        };
    };
}

