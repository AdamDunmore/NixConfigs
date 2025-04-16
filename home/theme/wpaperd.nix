{ lib, config, ... }:
let
    cfg = config.settings.nixos.theme;
in
{
    config = lib.mkIf cfg {
        services.wpaperd = {
            enable = true;
            settings = {
                any = {
                    path = ../../wallpapers;
                    duration = "10m";
                    sorting = "random";
                };
            };
        };
    };
}
