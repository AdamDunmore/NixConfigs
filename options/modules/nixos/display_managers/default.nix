{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.nixos.display_managers = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.enable;
            example = false;
            description = "Enables display manager modules";
        };

        default = mkOption {
                type = lib.types.enum [ "greetd" "ly" "sddm" "cosmic" "none" ];
                default = "sddm";
                example = "ly";
                description = "String value for what display manager to use. Possible options are 'greetd', 'ly', 'sddm', 'cosmic' or 'none'.";

        };
    };
}

