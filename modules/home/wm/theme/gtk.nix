{ pkgs, lib, config, ... }:
let
    font = config.settings.values.font;
    cfg = config.settings.modules.home.wm.theme.gtk;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        gtk = {
            enable = true;
            theme = {
                name = "Nordic";
                package = pkgs.nordic;
            };
            gtk4.theme = config.gtk.theme;
            iconTheme = {
                name = "breeze";
            };
            font = {
                name = font.name;
                package = font.pkg;
            };
        };
    };
}
