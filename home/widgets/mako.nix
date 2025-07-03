{ config, lib, font, colours, ... }:
let
    cfg = config.settings.home.widgets.mako;
in
with lib;
{
    config = mkIf cfg {
        services.mako = {
            enable = true;
            settings = {
                actions = true;
                anchor = "top-right";
                background-color = "${colours.blue.one}DD";
                border-color = "${colours.blue.two}FF";
                border-radius = 30;
                border-size = 2;
                default-timeout = 3000;
                font = "${font.name} 12";
                layer = "top";
                max-visible = 3;
                sort = "-time";
                height = 100;
                icons = true;
                ignore-timeout = true;
                margin = "10,10,10,10";
                max-icon-size = 64;
                padding = "5,5,5,5";
                text-color = "${colours.white.one}";
                width = 300;
            };
        };
    };
}

