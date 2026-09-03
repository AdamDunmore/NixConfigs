{ config, lib, ... }:
let
    cfg = config.settings.modules.home.wm.niri;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        wayland.windowManager.niri = {
            enable = true;
            systemd.enable = true;
            settings = {
                
            };
        };
    };
}
