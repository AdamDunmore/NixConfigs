{ config, lib, ... }:
let
    cfg = config.settings.nixos.system.virtualisation;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg {
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
