{ config, lib, inputs, ... }:
let
    cfg = config.settings.home.wm.cosmic;
    inherit (lib) mkIf;
in
{
    imports = [ inputs.cosmic-manager.homeManagerModules.cosmic-manager ];

    config = mkIf cfg.enable {
        wayland.desktopManager.cosmic = {
            enable = true;
        };
    };
}
