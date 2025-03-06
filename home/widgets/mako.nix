{ config, lib, ... }:
let
    cfg = config.settings.home.widgets.mako;
    colours = import ../../values/colours.nix;
    font = import ../../values/font.nix;
in
with lib;
{
    config = mkIf cfg {
        services.mako = {
            enable = true;
            actions = true; # Disable if notifications open apps
            anchor = "top-right";
            backgroundColor = "${colours.blue.one}DD";
            borderColor = "${colours.blue.two}FF";
            borderRadius = 30;
            borderSize = 2;
            defaultTimeout = 3000;
            font = "${font.name} 12";
            height = 100;
            icons = true;
            ignoreTimeout = true;
            layer = "top";
            margin = "10,10,10,10";
            maxIconSize = 64;
            maxVisible = 3;
            padding = "5,5,5,5";
            sort = "-time";
            textColor = "${colours.white.one}";
            width = 300;
        };
    };
}

