{ pkgs, lib, config, font, ... }:
let
    cfg = config.settings.home.theme;
in
{
    config = lib.mkIf cfg {
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
