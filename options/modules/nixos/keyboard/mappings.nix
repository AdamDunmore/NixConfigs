{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.nixos.keyboard.mappings = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.nixos.keyboard.enable;
            example = false;
            description = "Enables keyboard modules";
        };
    };
}
