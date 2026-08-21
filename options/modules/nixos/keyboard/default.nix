{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    imports = [
        ./mappings.nix
    ];
    options.settings.modules.nixos.keyboard = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.nixos.enable;
            example = false;
            description = "Enables keyboard modules";
        };
    };
}
