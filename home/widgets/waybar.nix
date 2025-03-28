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
                    spacing = 30;

                    modules-left = [ "sway/workspaces" "custom/waybar-mpris" ];
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

                    "custom/waybar-mpris" = {
                        return-type = "json";
                        exec = "waybar-mpris --position --autofocus";
                        on-click = "waybar-mpris --send toggle";
                        on-click-right = "waybar-mpris --send player-next";
                        on-scroll-up = "waybar-mpris --send player-next";
                        on-scroll-down = "waybar-mpris --send player-prev";
                        # on-scroll-up = "waybar-mpris --send next";
                        # on-scroll-down = "waybar-mpris --send prev";
                        escape = true;
                    };
                };
            };
            style = ''
                window#waybar {
                    padding-left: 20;
                    padding-right: 20;
                }

                #workspaces button.focused {
                    background-color: ${colours.blue.two};
                }
            '';
        };     
    };
}
