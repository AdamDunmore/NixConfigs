{ lib, config, ... }:
let
    cfg = config.settings.modules.home.wm.shell.wpaperd;
in
{
    config = lib.mkIf cfg.enable {
        services.wpaperd = {
            enable = true;
            settings = {
                any = {
                    path = ../../../../wallpapers;
                    duration = "10m";
                    sorting = "random";
                };
            };
        };
    };
}
