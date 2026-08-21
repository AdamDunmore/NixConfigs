{ pkgs, lib, config, ... }:
let
    cfg = config.settings.modules.home.wm.theme.gtk;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        qt = {
            enable = true;
            platformTheme.name = "gtk3";
            style = {
                name = "Nordic";
                package = pkgs.nordic;
            };
        };
    };
}
