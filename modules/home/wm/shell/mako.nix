{ config, lib, ... }:
let
    cfg = config.settings.modules.home.wm.shell.mako;
    colours = config.settings.values.colours;
    font = config.settings.values.font;
    inherit (lib) mkIf;
in
{
    config = mkIf cfg.enable {
        services.mako = {
            enable = true;
            settings = {
                actions = true;
                anchor = "top-left";
                background-color = "${colours.blue.one}AA";
                border-color = "${colours.blue.two}FF";
                border-radius = 10;
                border-size = 1;
                default-timeout = 8000;
                font = "${font.name} 10";
                layer = "overlay";
                max-visible = 3;
                sort = "-time";
                height = 300;
                icons = true;
                icon-border-radius=10;
                ignore-timeout = true;
                margin = "10,10,10,10";
                max-icon-size = 64;
                padding = "5,5,5,5";
                text-color = "${colours.white.one}";
                width = 400;
            };
        };
    };
}

