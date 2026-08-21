{ lib, config, ... }:
let
    cfg = config.settings.modules.nixos.base.bluetooth;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        hardware.bluetooth = {
            enable = true;
            powerOnBoot = true;
        };
        services.blueman.enable = true;
    };
}
