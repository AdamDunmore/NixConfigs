{ config, lib, ... }:
let
    cfg = config.settings.modules.nixos.base.virtualisation;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        virtualisation.virtualbox = {
            host = {
                enable = true;
                enableExtensionPack = true;
                enableKvm = true;
                addNetworkInterface = false;
            };
            guest = {
                enable = true;
                dragAndDrop = true;
                seamless = true;
                clipboard = true;
            };
        };
    };

}
