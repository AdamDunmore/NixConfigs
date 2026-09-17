{ lib, config, ... }:
let
    inherit (lib) mkOption;
in
{
    options.settings.modules.nixos.services.battery = {
        enable = mkOption {
            type = lib.types.bool;
            default = config.settings.modules.nixos.base.enable;
            example = false;
            description = "Enables the battry module";
        };
        chargeLimit = mkOption {
            type = lib.types.int;
            default = 80;
            example = 100;
            description = "Enables AMD rocm";
        };

    };
}
