{ lib, config, ... }:
let
    cfg = config.settings.nixos.system.enable;
in
{
    config = lib.mkIf cfg {
        hardware.bluetooth = {
            enable = true;
            powerOnBoot = true;
        };
        services.blueman.enable = true;
    };
}
