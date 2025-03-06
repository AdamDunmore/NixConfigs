{ config, lib, ... }:

let
    cfg = config.settings.home.widgets.waybar;
    colours = import ../../values/colours.nix;
in
with lib;
{
    config = mkIf cfg {
        programs.waybar = {
            enable = true;
            settings = {
                mainBar = {
                    layer = "top";
                    position = "top";
                    height = 30;
                    # margin-top = 20;
                    # margin-left = 100;
                    # margin-right = 100;
                    margin-bottom = 10;
                    spacing = 30;
                    # output = [

                    # ];

                    modules-left = [ "sway/workspaces" ];
                    modules-center = [ "clock" "clock#date" ];
                    modules-right = [ "backlight" "pulseaudio" "battery" "network" ];

                    "backlight" = {
                      format = "󰃠    {percent}%";
                    };

                    "pulseaudio" = {
                      format = "   {volume}%";
                    };

                    "battery" = {
                        format = "    {capacity}%";
                    };

                    "network" = {
                      format-wifi = "i    {signalStrength}%";
                    };

                    "clock" = {
                      format = "{:%H:%M}";
                    };
                    "clock#date" = {
                      format = "{:%A, %d %b %Y} ";
                    };
                };
            };
            style = ''
                #workspaces button.focused {
                    background-color: ${colours.blue.two};
                }
            '';
        };     
    };
}
